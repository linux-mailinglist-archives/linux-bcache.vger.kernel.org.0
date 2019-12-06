Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF794114E22
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 10:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfLFJ1P (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 04:27:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfLFJ1O (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 04:27:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Zo0jtbIsOCFbGh+b8IHpEzhIrR3GU31EEJ5gwFtfOLI=; b=tCLQjpLBG1mkfvFy2UlwcyiY5
        /QkA+UQH6qepxcH8+285c71e9nPMDHT3s8+mW8JsSEUrAVP0FW6UxGNOlEzv3ukQ9NCok2rHB2PV2
        NZ5PEku1ONlrdtesCjGjxnwoo5Mxn7ALqYZ0lH+KTQXwkQPTVQtNJOIN0FASRJaQ8WnB2q/JQmmuv
        WhWrW8N+7GUlHhM3dcaJ/Z6scTt7KALoxEzcjgFubDtgXqcohjm1GG+7n85gW4ptPhRxI5Gd+zP7H
        jtNilC6Yx20Q0Vc2KiNf1U8orUWzdPylX33i5q+6SSDUxUTaRu9JeHEIipuXrs6FBYceYFIqOHMeT
        PI+19/JPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1id9tK-0006Qg-0X; Fri, 06 Dec 2019 09:27:14 +0000
Date:   Fri, 6 Dec 2019 01:27:13 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH 1/2] [PATCH] bcache: cached_dev_free needs to put the sb
 page
Message-ID: <20191206092713.GB7650@infradead.org>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Dec 06, 2019 at 04:55:42PM +0800, Liang Chen wrote:
> Same as cache device, the buffer page needs to be put while
> freeing cached_dev.  Otherwise a page would be leaked every
> time a cached_dev is stopped.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
>  drivers/md/bcache/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 77e9869345e7..a573ce1d85aa 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1275,6 +1275,9 @@ static void cached_dev_free(struct closure *cl)
>  
>  	mutex_unlock(&bch_register_lock);
>  
> +	if (dc->sb_bio.bi_inline_vecs[0].bv_page)
> +		put_page(bio_first_page_all(&dc->sb_bio));

Using bio_first_page_all in the put_page call, but open coding it
for the check looks rather strange.

The cleanest thing here would be to just add a page pointer to the
cached device structure and use that instead of all the indirections.
