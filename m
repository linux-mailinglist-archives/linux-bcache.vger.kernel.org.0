Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8038611597D
	for <lists+linux-bcache@lfdr.de>; Sat,  7 Dec 2019 00:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfLFXJX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 18:09:23 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:33644 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfLFXJX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 18:09:23 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id DB9D4A0440;
        Fri,  6 Dec 2019 23:09:17 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id H_XoFx0OiXyB; Fri,  6 Dec 2019 23:08:57 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id D5337A0633;
        Fri,  6 Dec 2019 23:08:56 +0000 (UTC)
Date:   Fri, 6 Dec 2019 23:08:55 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Liang Chen <liangchen.linux@gmail.com>
cc:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH 1/2] [PATCH] bcache: cached_dev_free needs to put the sb
 page
In-Reply-To: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
Message-ID: <alpine.LRH.2.11.1912062308370.11561@mx.ewheeler.net>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 6 Dec 2019, Liang Chen wrote:

> Same as cache device, the buffer page needs to be put while
> freeing cached_dev.  Otherwise a page would be leaked every
> time a cached_dev is stopped.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>


+cc stable?

--
Eric Wheeler


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
> +
>  	if (!IS_ERR_OR_NULL(dc->bdev))
>  		blkdev_put(dc->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
>  
> -- 
> 2.17.0
> 
> 
