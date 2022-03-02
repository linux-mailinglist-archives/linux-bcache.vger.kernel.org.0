Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9B74CA22A
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Mar 2022 11:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239783AbiCBKaF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Mar 2022 05:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbiCBKaE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Mar 2022 05:30:04 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B67A652F;
        Wed,  2 Mar 2022 02:29:21 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A64642199B;
        Wed,  2 Mar 2022 10:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646216960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVBFzrk6TUvLRPcGtcbaStMO/+BUctPjeToj+ujUUyY=;
        b=NFkOCCagBlQ/6px1grJkisHFtNCFx4WnXHZE48ln89BvGRAmjcqqgitotoy1v/M9z8yTLb
        h4hHU45T671/Ggam8cMNmZEyYJ2phRsva91Vb2YatX+7Me3S9Nvrk7Zd4gpFZBGzVCbWBZ
        O1EgFtb8RImsyGFRkc37CROFV0raeWA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646216960;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVBFzrk6TUvLRPcGtcbaStMO/+BUctPjeToj+ujUUyY=;
        b=rBYcGza+OoWm9/huYrgifPtcn31AIQZL8Nly+EoAPoDLnVB14aSZP+1lgrWcnz99rMP8xN
        x5Q8WZcX1xP0vOAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3874113BC1;
        Wed,  2 Mar 2022 10:29:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qNsQAv9GH2LGfgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 02 Mar 2022 10:29:19 +0000
Message-ID: <0130200c-bbb1-9d7f-e177-6ffbc60db405@suse.de>
Date:   Wed, 2 Mar 2022 18:29:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] md: bcache: check the return value of mempool_alloc() in
 bch_btree_node_read_done()
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20220225082804.19793-1-baijiaju1990@gmail.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220225082804.19793-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/25/22 4:28 PM, Jia-Ju Bai wrote:
> The function mempool_alloc() in bch_btree_node_read_done() can fail, so
> its return value should be checked.
>
> Fixes: d19936a26658 ("bcache: convert to bioset_init()/mempool_init()")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>   drivers/md/bcache/btree.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 88c573eeb598..fb8b7dd6bcc2 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -157,6 +157,8 @@ void bch_btree_node_read_done(struct btree *b)
>   	 * See the comment arount cache_set->fill_iter.
>   	 */
>   	iter = mempool_alloc(&b->c->fill_iter, GFP_NOIO);
> +	if (!iter)
> +		return;


This is unnecessary, mempool_alloc() doesn't return NULL in this condition.


Coly Li



>   	iter->size = b->c->cache->sb.bucket_size / b->c->cache->sb.block_size;
>   	iter->used = 0;
>   


