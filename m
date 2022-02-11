Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3B34B2044
	for <lists+linux-bcache@lfdr.de>; Fri, 11 Feb 2022 09:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348040AbiBKIj2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 11 Feb 2022 03:39:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242964AbiBKIj1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 11 Feb 2022 03:39:27 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA141BF
        for <linux-bcache@vger.kernel.org>; Fri, 11 Feb 2022 00:39:27 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2127721126;
        Fri, 11 Feb 2022 08:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644568766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=07BbKBXM2sFjnEyAnw52NDkzwwEd0L9V8AIrOwMx6Uk=;
        b=SIP3Jvh8zQa7ssvGR5t1ZsmdaqV+4R/bTaacLE8h7lFXJK5uCr15Z1cNIUHwBsGoOctOG9
        rxeo7tyngl5tpdwV+f4h1yv1//nX9smmm3Kgd5XRL4wKZpaXLeWw9YHsloz4ssS9v3hQMt
        nb6m08AmB4JBxjbUU5fWS2x6LO8chTo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644568766;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=07BbKBXM2sFjnEyAnw52NDkzwwEd0L9V8AIrOwMx6Uk=;
        b=R8s1qm8SF7DOgJAjJ5il2NPDWk1u1eopWZbnuFN7D4eVStDY75JivUuO+uER8wXkEeaWSk
        J5lV8miqboSgcXAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 14E3713B59;
        Fri, 11 Feb 2022 08:39:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9n+5NLwgBmKjewAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 11 Feb 2022 08:39:24 +0000
Message-ID: <8c7314c0-4df3-5bda-f17c-7ddc15de7ffc@suse.de>
Date:   Fri, 11 Feb 2022 16:39:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH] bcache: fixup multiple threads crash
Content-Language: en-US
To:     mingzhe.zou@easystack.cn
Cc:     zoumingzhe@qq.com, linux-bcache@vger.kernel.org
References: <20220211063915.4101-1-mingzhe.zou@easystack.cn>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220211063915.4101-1-mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/11/22 2:39 PM, mingzhe.zou@easystack.cn wrote:
> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>
> When multiple threads to check btree nodes in parallel, the main
> thread wait for all threads to stop or CACHE_SET_IO_DISABLE flag:
>
> wait_event_interruptible(check_state->wait,
>                           atomic_read(&check_state->started) == 0 ||
>                           test_bit(CACHE_SET_IO_DISABLE, &c->flags));
>
> However, the bch_btree_node_read and bch_btree_node_read_done
> maybe call bch_cache_set_error, then the CACHE_SET_IO_DISABLE
> will be set. If the flag already set, the main thread return
> error. At the same time, maybe some threads still running and
> read NULL pointer, the kernel will crash.

Hi Mingzhe,

Could you please explain a bit more about "read NULL pointer"? Which 
NULL pointer might be read in the above condition?

Thanks.

Coly Li

> This patch change the event wait condition, the main thread must
> wait for all threads to stop.
>
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> ---
>   drivers/md/bcache/btree.c     | 6 ++++--
>   drivers/md/bcache/writeback.c | 6 ++++--
>   2 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 88c573eeb598..ad9f16689419 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -2060,9 +2060,11 @@ int bch_btree_check(struct cache_set *c)
>   		}
>   	}
>   
> +	/*
> +	 * Must wait for all threads to stop.
> +	 */
>   	wait_event_interruptible(check_state->wait,
> -				 atomic_read(&check_state->started) == 0 ||
> -				  test_bit(CACHE_SET_IO_DISABLE, &c->flags));
> +				 atomic_read(&check_state->started) == 0);
>   
>   	for (i = 0; i < check_state->total_threads; i++) {
>   		if (check_state->infos[i].result) {
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index c7560f66dca8..68d3dd6b4f11 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -998,9 +998,11 @@ void bch_sectors_dirty_init(struct bcache_device *d)
>   		}
>   	}
>   
> +	/*
> +	 * Must wait for all threads to stop.
> +	 */
>   	wait_event_interruptible(state->wait,
> -		 atomic_read(&state->started) == 0 ||
> -		 test_bit(CACHE_SET_IO_DISABLE, &c->flags));
> +		 atomic_read(&state->started) == 0);
>   
>   out:
>   	kfree(state);

