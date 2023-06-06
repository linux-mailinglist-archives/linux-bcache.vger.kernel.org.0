Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EDB7237C1
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Jun 2023 08:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbjFFGdt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Jun 2023 02:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbjFFGdt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Jun 2023 02:33:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868F4E42
        for <linux-bcache@vger.kernel.org>; Mon,  5 Jun 2023 23:33:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3DF2B1FD65;
        Tue,  6 Jun 2023 06:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686033226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a2Z0WQs+3ener25l6NgnF+I5swOoMqM0RMHfs/qijOg=;
        b=epi5hPyrMkIiX8YDGQY2JQrOxDnTsppp9V3i8/mKDsgdMIVGTeKzE/KzU8fwbi3xCeoIGr
        FnVybVh9NRCpaYo12TOUFbrXyPdTjB2Gi7/YIskqigXZ29lNw4WzuJy7i6CCaXrnBRMuwc
        bdE0MJZWnfh9YV2XEFHWUIjKVdplUDM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686033226;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a2Z0WQs+3ener25l6NgnF+I5swOoMqM0RMHfs/qijOg=;
        b=dnLDg7m++axwXEcNZzUOv4iRTeKGr8Jps4zU991sDf0AGcWvlzPDqKEAWhs/FjrrLBdPaa
        S/2yFU8afZu8rZCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3B4C713776;
        Tue,  6 Jun 2023 06:33:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id T07VAknTfmTGcQAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 06 Jun 2023 06:33:45 +0000
Date:   Tue, 6 Jun 2023 14:33:43 +0800
From:   Coly Li <colyli@suse.de>
To:     mingzhe.zou@easystack.cn
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: Re: [PATCH 1/3] bcache: add dirty_data in struct bcache_device
Message-ID: <kf5u6z6lz4j3b3eeu6bl36l3bbowjfezm2fwprq4i5yukabopc@2wu4oaiz4xod>
References: <20221212032050.9511-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221212032050.9511-1-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Dec 12, 2022 at 11:20:48AM +0800, mingzhe.zou@easystack.cn wrote:
> From: mingzhe <mingzhe.zou@easystack.cn>
> 
> Currently, the dirty_data of cached_dev and flash_dev depend on the stripe.
> 
> Since the flash device supports resize, it may cause a bug (resize the flash
> from 1T to 2T, and nr_stripes from 1 to 2).
> 
> The patch add dirty_data in struct bcache_device, we can get the value of
> dirty_data quickly and fixes the bug of resize flash device.
> 
> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
> ---
>  drivers/md/bcache/bcache.h    | 1 +
>  drivers/md/bcache/writeback.c | 2 ++
>  drivers/md/bcache/writeback.h | 7 +------
>  3 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 621a2ae1767b..5da991505b45 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -268,6 +268,7 @@ struct bcache_device {
>  	unsigned int		stripe_size;
>  	atomic_t		*stripe_sectors_dirty;
>  	unsigned long		*full_dirty_stripes;
> +	atomic_long_t		dirty_sectors;
>  
>  	struct bio_set		bio_split;
>  
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index f21295dea71b..7b5009e8b4ff 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -769,6 +769,8 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
>  	if (stripe < 0)
>  		return;
>  
> +	atomic_long_add(nr_sectors, &d->dirty_sectors);
> +
>  	if (UUID_FLASH_ONLY(&c->uuids[inode]))
>  		atomic_long_add(nr_sectors, &c->flash_dev_dirty_sectors);
> 

Indeed, if the bcache device is a flash only volume, all the rested code since
here to the end of bcache_dev_sectors_dirty_add() can be ignored. Setting
stripe_sectors_dirty and full_dirty_stripes is for writeback related stuffs,
for flsh only device there is no writeback.

And then you may add atomic_long_add(nr_sectors, &d->dirty_sectors) after
atomic_long_add(nr_sectors, &c->flash_dev_dirty_sectors). After this, for
flash only device, its stripe_sectors_dirty and full_dirty_stripes can be
always 0, and its dirty sectors are counted in flash_dev_dirty_sectors.

Yes current code still allocate memory for stripes counter when it is flash
only device. I will fix this firstly.

 
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index 7e5a2fe03429..12765c0dfd5c 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -56,12 +56,7 @@ struct bch_dirty_init_state {
>  
>  static inline uint64_t bcache_dev_sectors_dirty(struct bcache_device *d)
>  {
> -	uint64_t i, ret = 0;
> -
> -	for (i = 0; i < d->nr_stripes; i++)
> -		ret += atomic_read(d->stripe_sectors_dirty + i);
> -
> -	return ret;
> +	return atomic_long_read(&d->dirty_sectors);
>  }
>  

This looks really nice.

>  static inline int offset_to_stripe(struct bcache_device *d,
> -- 
> 2.17.1
> 

-- 
Coly Li
