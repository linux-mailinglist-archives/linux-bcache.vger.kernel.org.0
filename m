Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A5A6A4353
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Feb 2023 14:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjB0Nwb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Feb 2023 08:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjB0Nwa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Feb 2023 08:52:30 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4948A1E1CA
        for <linux-bcache@vger.kernel.org>; Mon, 27 Feb 2023 05:52:29 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F0ACF1FD63;
        Mon, 27 Feb 2023 13:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677505947; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S8QrDY9QVVjdqu4WEpCjDcb6bEjdi3aTIC1nOArVVNI=;
        b=QydURrjlbEk9asMeYxLb7wbn/HWlt5FcDIu1nyL03X61IMBYdqhAN+r0mv16nDgjDqd9h+
        QEBqr0BBNIPanlR/Q6/8zUxpN5BVHcPWv6xHNN6bCfFMZlCD2suDI5HUaIHEUufHeEWFRK
        kkKn49a6bVNLnI8bsnoNrGBIO3gGPLU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677505947;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S8QrDY9QVVjdqu4WEpCjDcb6bEjdi3aTIC1nOArVVNI=;
        b=ZncTWDlhGe+MUNna54yr5odcaprCAPMG6Sg9RVUPXfEi9LKyGmGdX9ojb+13DEOPUIzPBY
        apQDNkU9Is5faWCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EBBBB13912;
        Mon, 27 Feb 2023 13:52:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FBMwLJq1/GNwdAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 27 Feb 2023 13:52:26 +0000
Date:   Mon, 27 Feb 2023 21:52:20 +0800
From:   Coly Li <colyli@suse.de>
To:     Zhang Zhen <zhangzhen.email@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: [PATCH] bcache: remove return value from bch_cached_dev_error
Message-ID: <Y/y1lJ6wXt3Isw6I@enigma.lan>
References: <20230227124132.1925274-1-zhangzhen15@kuaishou.com>
 <ddeb178d-4889-4c41-9638-fa8b4aa5cb71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ddeb178d-4889-4c41-9638-fa8b4aa5cb71@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Feb 27, 2023 at 08:44:33PM +0800, Zhang Zhen wrote:
> The only caller of bch_cached_dev_error does not check the return
> value. We can make it a void function.
> 
> Signed-off-by: Zhen Zhang <zhangzhen15@kuaishou.com>

NACK. I prefer to have the return values for different conditions,
even they are not used for now.

Coly Li

> ---
>  drivers/md/bcache/bcache.h | 2 +-
>  drivers/md/bcache/super.c  | 5 ++---
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index aebb7ef10e63..ff175a2fb2f0 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -990,7 +990,7 @@ int bch_bucket_alloc_set(struct cache_set *c, unsigned
> int reserve,
>  bool bch_alloc_sectors(struct cache_set *c, struct bkey *k,
>  		       unsigned int sectors, unsigned int write_point,
>  		       unsigned int write_prio, bool wait);
> -bool bch_cached_dev_error(struct cached_dev *dc);
> +void bch_cached_dev_error(struct cached_dev *dc);
>   __printf(2, 3)
>  bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..9923bb5c4fbe 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1607,10 +1607,10 @@ int bch_flash_dev_create(struct cache_set *c,
> uint64_t size)
>  	return flash_dev_run(c, u);
>  }
>  -bool bch_cached_dev_error(struct cached_dev *dc)
> +void bch_cached_dev_error(struct cached_dev *dc)
>  {
>  	if (!dc || test_bit(BCACHE_DEV_CLOSING, &dc->disk.flags))
> -		return false;
> +		return;
>   	dc->io_disable = true;
>  	/* make others know io_disable is true earlier */
> @@ -1620,7 +1620,6 @@ bool bch_cached_dev_error(struct cached_dev *dc)
>  	       dc->disk.disk->disk_name, dc->bdev);
>   	bcache_device_stop(&dc->disk);
> -	return true;
>  }
>   /* Cache set */
> -- 
> 2.27.0
> 

-- 
Coly Li
