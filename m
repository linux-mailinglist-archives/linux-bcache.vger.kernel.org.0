Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD6CE9CB7
	for <lists+linux-bcache@lfdr.de>; Wed, 30 Oct 2019 14:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfJ3Ny1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 30 Oct 2019 09:54:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41520 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfJ3Ny1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 30 Oct 2019 09:54:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Utihgzs6H+LFi2n+mj7RWlsvBJPK1GO6rym7XoHXdXE=; b=FdHA0ymcBQE/5UwLEdX15pSF1M
        9j/JS2kVvK1xTC8JeIq4iJoKeVyPD1CHLF0vJLJcs9RgeLsQO/L8YpfgHTo9xtK8Rp34BkV0L41eo
        EI18VlQt9JZHN0nHfdc2kEj0aZ/mt68246qsHVV4zArzZm6HjOKPxMku6hhNUQHf9KdNg7QB4cs/1
        9Cki42lehQKKIe7svw4sW2QUK4hFwfDBKZWVQStnOVO0JPfr1BTW5xb/jUbtoy+bzSeicDwBJGBWJ
        vNzN2YtWYbmf4weoKv9u55N7UF2UTMnkw37VgJWmUnq9q4wic6blfmV/KDrxqVEmEu7R2jQ0ywuli
        AYMb3FDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPoQc-0006Y0-1R; Wed, 30 Oct 2019 13:54:26 +0000
Date:   Wed, 30 Oct 2019 06:54:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Keith Busch <kbusch@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH V3] block: optimize for small block size IO
Message-ID: <20191030135426.GA24655@infradead.org>
References: <20191029105125.12928-1-ming.lei@redhat.com>
 <20191029110425.GA4382@infradead.org>
 <20191030002126.GA14423@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191030002126.GA14423@ming.t460p>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Oct 30, 2019 at 08:21:26AM +0800, Ming Lei wrote:
> > +		if ((*bio)->bi_vcnt == 1 &&
> > +		    (*bio)->bi_io_vec[0].bv_len <= PAGE_SIZE) {
> > +			*nr_segs = 1;
> > +			return;
> > +		}
> >  		split = blk_bio_segment_split(q, *bio, &q->bio_split, nr_segs);
> >  		break;
> >  	}
> 
> This bio(*bio) may be a fast-cloned bio from somewhere(DM, MD, ...), so the above
> check can't work sometime.

Please explain how it doesn't work.  In the worse case it will give us
a false negastive, that is we don't take the fast path when in theory
we could, but then again fast cloneѕ bios will have so much overhead
that it should not matter.
