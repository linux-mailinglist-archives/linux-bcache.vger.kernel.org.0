Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7EC0116794
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Dec 2019 08:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfLIHhq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 02:37:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42576 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfLIHhq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 02:37:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RBzUEPx4oHsspEth4FQtF7CsBt3Lu0e/H3Pg/iH6hJA=; b=IGqHHbWb3mAXUulXMcdRbUS0Y
        0zuhaNwPeJqLrq5SOvMTdIlQfa7tYyzBGq4p6i5bM6XJr7iZr5LeSq7ni2JP4fsnxQSSkMffIrmt2
        hAJpORxNtU9o/oaAw6HBatFY/9NuoUUfDFS3WI2w5iu3hiFZNl95Nd9q6vFeHEpBoOm4ObPpPBWLd
        3BCV52x8PtkjMoqdYJ+1kaXdtoJQtC1TIa197o7P1F7kEnMN0ePuZRBrGjBiUWZXQyanw3Zm9dgTT
        P49cBbdz6rZWnUAUEukYcK73haKis+uFlqyYgmh061DaBwW0+1slKZiDdsDykO8BU4XRlsj383Gmm
        kfwiajV9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ieDc0-0002fa-Rd; Mon, 09 Dec 2019 07:37:44 +0000
Date:   Sun, 8 Dec 2019 23:37:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Coly Li <colyli@suse.de>
Cc:     Liang Chen <liangchen.linux@gmail.com>, kent.overstreet@gmail.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
Message-ID: <20191209073744.GB3852@infradead.org>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com>
 <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Dec 06, 2019 at 05:44:38PM +0800, Coly Li wrote:
> >  {
> > -	struct cache_sb *out = page_address(bio_first_page_all(bio));
> > +	struct cache_sb *out;
> >  	unsigned int i;
> > +	struct buffer_head *bh;
> > +
> > +	/*
> > +	 * The page is held since read_super, this __bread * should not
> > +	 * cause an extra io read.
> > +	 */
> > +	bh = __bread(bdev, 1, SB_SIZE);
> > +	if (!bh)
> > +		goto out_bh;
> > +
> > +	out = (struct cache_sb *) bh->b_data;
> 
> This is quite tricky here. Could you please to move this code piece into
> an inline function and add code comments to explain why a read is
> necessary for a write.

A read is not nessecary.  He only added it because he was too fearful
of calculating the data offset directly.  But calculating it directly
is almost trivial and should just be done here.  Alternatively if that
is still to hard just keep a pointer to the cache_sb around, which is
how most file systems do it.
