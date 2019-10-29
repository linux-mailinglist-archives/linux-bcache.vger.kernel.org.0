Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847E2E8281
	for <lists+linux-bcache@lfdr.de>; Tue, 29 Oct 2019 08:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfJ2H1q (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Oct 2019 03:27:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41084 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfJ2H1q (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Oct 2019 03:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Q/E9Nu2KkMUAqOtRuXDVePReEMKO9yMcn9OyUTsL2o8=; b=GB/77/q76w7fqcS/w0aL3yVdN
        VNKSRb+OuRiiFGBZhaj9OKwDIbHex/o9h2A3hbNhWpuiB0bXI5FRBTkSPWxk4rLy7IimgT7gvG+D7
        7tUEFibQc4GJtIBAFn+0/7+aQlgRks+XbCEXfP5yLFN1aSfSjHdioZuphP0BQyaW051xyGPvUBnKw
        qgr98paHcxkLWjkXWsElCoW/JSoVLIwelb0RWYfBHEjiZTJ1y1igQSYypWoDZig9nX7GkG2J86Etg
        felqskXjEuCXM2oeGVnO23rgcePWwnchOkLnPqvE2EHpQP3+eiO2W3nKMLM9baGa3Vy8Z9pm+WFyw
        4zcoLj+/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPLur-0006F7-N2; Tue, 29 Oct 2019 07:27:45 +0000
Date:   Tue, 29 Oct 2019 00:27:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH V2] block: optimize for small BS IO
Message-ID: <20191029072745.GA4521@infradead.org>
References: <20191029070621.1307-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029070621.1307-1-ming.lei@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Oct 29, 2019 at 03:06:21PM +0800, Ming Lei wrote:
> __blk_queue_split() may be a bit heavy for small BS(such as 512B, or

Maybe spell out block size.  BS has another much less nice connotation.

> bch_bio_map() should be the only one which doesn't use bio_add_page(),
> so force to mark bio built via bch_bio_map() as MULTI_PAGE.

We really need to fix that up.  I had patches back in the day which
Kent didn't particularly like for non-technical reason, that might serve
as a starting point.

> @@ -789,6 +794,10 @@ void __bio_add_page(struct bio *bio, struct page *page,
>  	bio->bi_iter.bi_size += len;
>  	bio->bi_vcnt++;
>  
> +	if (!bio_flagged(bio, BIO_MULTI_PAGE) && (bio->bi_vcnt >= 2 ||
> +				(bio->bi_vcnt == 1 && len > PAGE_SIZE)))
> +		bio_set_flag(bio, BIO_MULTI_PAGE);

This looks pretty ugly and does more (and more confusing) checks than
actually needed Maybe we need a little bio_is_multi_page helper to clean
this up a bit:

/*
 * Check if the bio contains more than a page and thus needs special
 * treatment in the bio splitting code.
 */
static inline bool bio_is_multi_page(struct bio *bio)
{
	return bio->bi_vcnt > 1 || bio->bi_io_vec[0].bv_len > PAGE_SIZE;
}

and then this becomes:

	if (!bio_flagged(bio, BIO_MULTI_PAGE) && bio_is_multi_page(bio))

Then again these checks are so cheap that we can just use the
bio_is_multi_page helper directly and skip the flag entirely.
