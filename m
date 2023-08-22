Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231E07848AD
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Aug 2023 19:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjHVRt5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Aug 2023 13:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjHVRt4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Aug 2023 13:49:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1262E1FFC
        for <linux-bcache@vger.kernel.org>; Tue, 22 Aug 2023 10:49:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8089722C12;
        Tue, 22 Aug 2023 17:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692726575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HMBdUg6WaSd3yu39ohwJ2cTcY79JwJS3/G9Zsw3XhMI=;
        b=OslmxPOgeNSZtUo7cS5V5Pt40X5Kgcu2cQBSTUMqStR7zDAk4r2Ddw1PEUz9Zx3apAOqtH
        kukcMbvd3ebon/nuIFvkw8F+S51TJryQ2/5DMDGMX7pXSB9oG30Yd5TgOZrgcooFYNv9RY
        kCX6sJZsT2bNuoH2vcpxVoMoJD4yE/8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692726575;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HMBdUg6WaSd3yu39ohwJ2cTcY79JwJS3/G9Zsw3XhMI=;
        b=aTyaw3BUG4FnyVch6tKYrrI7GIYAucbSoqw+j2/gNkhAyKq/fDkukeU0bQ3Y5Dl220Ge1c
        iT/iMJ7ifC7ySLBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 86170132B9;
        Tue, 22 Aug 2023 17:49:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id du5tFS715GRNfwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 22 Aug 2023 17:49:34 +0000
Date:   Wed, 23 Aug 2023 01:49:32 +0800
From:   Coly Li <colyli@suse.de>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc:     bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org,
        zoumingzhe@qq.com
Subject: Re: [PATCH] bcache: fixup init dirty data errors
Message-ID: <dzhok3pe53usq5qc4emosxesmimwvhxoi663hxqpigvzejmppm@2fj6swqu2j7a>
References: <20230822101958.2577-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230822101958.2577-1-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Mingzhe,

On Tue, Aug 22, 2023 at 06:19:58PM +0800, Mingzhe Zou wrote:
> We found that after long run, the dirty_data of the bcache device
> will have errors. This error cannot be eliminated unless re-register.

Could you explain what the error was?

> 
> We also found that reattach after detach, this error can accumulate.
>

Could you elaborate how the error can accumulate?

 
> In bch_sectors_dirty_init(), all inode <= d->id keys will be recounted
> again. This is wrong, we only need to count the keys of the current
> device.
> 
> Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> ---
>  drivers/md/bcache/writeback.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 24c049067f61..71d0dabcbf9d 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -983,6 +983,8 @@ void bch_sectors_dirty_init(struct bcache_device *d)
>  	struct cache_set *c = d->c;
>  	struct bch_dirty_init_state state;
>  
> +	atomic_long_set(&d->dirty_sectors, 0);
> +

The above change is not upstreamed yet, if you are fixing upstream code please
avoid to use d->dirty_sectors here.



>  	/* Just count root keys if no leaf node */
>  	rw_lock(0, c->root, c->root->level);
>  	if (c->root->level == 0) {
> @@ -991,8 +993,11 @@ void bch_sectors_dirty_init(struct bcache_device *d)
>  		op.count = 0;
>  
>  		for_each_key_filter(&c->root->keys,
> -				    k, &iter, bch_ptr_invalid)
> +				    k, &iter, bch_ptr_invalid) {
> +			if (KEY_INODE(k) != op.inode)
> +				continue;
>  			sectors_dirty_init_fn(&op.op, c->root, k);
> +		}
>  

Nice catch! IMHO if I take the above change, setting d->dirty_sectors by 0
might be unncessary in ideal condition, am I right?

Thanks for the fixup.


>  		rw_unlock(0, c->root);
>  		return;
> -- 
> 2.17.1.windows.2
> 

-- 
Coly Li
