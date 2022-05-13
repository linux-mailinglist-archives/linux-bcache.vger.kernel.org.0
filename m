Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AA35265EB
	for <lists+linux-bcache@lfdr.de>; Fri, 13 May 2022 17:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344588AbiEMPV2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 13 May 2022 11:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381926AbiEMPVH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 May 2022 11:21:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7786674D0;
        Fri, 13 May 2022 08:21:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A197D21AAF;
        Fri, 13 May 2022 15:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652455262; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UV7Y5bgnV0GZ8RZ2emGi8DC2EoYJzONKlh0hnGHwbYI=;
        b=NctPhhbaRk4tci4H5TFnddICKka+XEN5PYAUWeoQ+FC14pmGBCyL+26nE3lNeDeC+9FcxU
        9GJmWTpNkfRGNU7P3uFYMTo1Swo3w7W4qAvZWskiC1eFNSNFclKJ+oebMHPtpIJwieMlK5
        gOYHgn5aGCpZO9o9zuwL01XEqU18O/4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652455262;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UV7Y5bgnV0GZ8RZ2emGi8DC2EoYJzONKlh0hnGHwbYI=;
        b=L1aCbi+lyMhWPreNqXVEA0FYIpjkLp5RxH5dMnZ6/z5grC7/vJL35oS7hEfrRcDI64DitU
        uGJ/fHtlHtNbmWBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6512113446;
        Fri, 13 May 2022 15:21:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jsepCl13fmLdIgAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 13 May 2022 15:21:01 +0000
Message-ID: <f80cefa2-e238-9939-5f48-9d84bcc248f3@suse.de>
Date:   Fri, 13 May 2022 23:20:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH] bcache: fix wrong BITMASK offset value for
 BDEV_CACHE_MODE
Content-Language: en-US
To:     Lin Feng <linf@wangsu.com>
Cc:     axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
References: <20210720103246.112027-1-linf@wangsu.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20210720103246.112027-1-linf@wangsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/20/21 6:32 PM, Lin Feng wrote:
> Original codes:
> BITMASK(CACHE_SYNC,			struct cache_sb, flags, 0, 1);
> BITMASK(CACHE_DISCARD,			struct cache_sb, flags, 1, 1);
> BITMASK(CACHE_REPLACEMENT,		struct cache_sb, flags, 2, 3);
> ...
> BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
>
> Should BDEV_CACHE_MODE bits start from bit-nr 5(2+3) else it overlaps
> with previous defined bit chunks, since we have 4 types of cache modes,
> BDEV_CACHE_MODE will overwrite CACHE_SYNC and CACHE_DISCARD bits.

The overlap won't happen, previous lines are for cache device, and what 
you modified is for backing device.

And your patch changes the on-disk format, which is unacceptable anyway.


Coly Li

>
> This bug stays there since first upstream version of bcache, don't know
> why it lives so long, or am i missing something, please point me out
> if I'm wrong, thanks!
>
> Signed-off-by: Lin Feng <linf@wangsu.com>
> ---
>   include/uapi/linux/bcache.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
> index cf7399f03b71..dccd89756451 100644
> --- a/include/uapi/linux/bcache.h
> +++ b/include/uapi/linux/bcache.h
> @@ -288,7 +288,7 @@ BITMASK(CACHE_REPLACEMENT,		struct cache_sb, flags, 2, 3);
>   #define CACHE_REPLACEMENT_FIFO		1U
>   #define CACHE_REPLACEMENT_RANDOM	2U
>   
> -BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
> +BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 5, 4);
>   #define CACHE_MODE_WRITETHROUGH		0U
>   #define CACHE_MODE_WRITEBACK		1U
>   #define CACHE_MODE_WRITEAROUND		2U


