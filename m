Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC586C8D0A
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Mar 2023 11:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjCYKQj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Mar 2023 06:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCYKQi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Mar 2023 06:16:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27AF13506;
        Sat, 25 Mar 2023 03:16:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 350031FDFB;
        Sat, 25 Mar 2023 10:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679739396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0TxJ1pRGTbTsu2gMHP7OY33CZJmyGasc/4h21839kk=;
        b=LEcYYHW6zsPd6nz/2OXegYqToyKvrmZD82afuhsdw0mzv82YSJc0EOqu5GjfEjWk2j1j9F
        +yIqSjaw6hRaEcLN/HFTYDLRG76kb8/Ocx/adDm7UiKApijr+f8NHq7dyNvslZqgvEQBss
        oQHMc+2IY2Q5omX0aO3Kg8aD4D2a7ns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679739396;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0TxJ1pRGTbTsu2gMHP7OY33CZJmyGasc/4h21839kk=;
        b=I6iO9Xt+uecv4BMfJBLDRqpsnOkKPOhj3DQRdMIF3lRoDwKmjrilDgWMHQ/ij/1+Y2LNxc
        Ujghp93DxeIX+ZDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9AC9B13463;
        Sat, 25 Mar 2023 10:16:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Mvf4GQLKHmQyQgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 25 Mar 2023 10:16:34 +0000
Message-ID: <157b8db9-82f7-85e7-3bbd-7ef3a1797892@suse.de>
Date:   Sat, 25 Mar 2023 18:16:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH resent] bcache: Fix exception handling in mca_alloc()
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     cocci@inria.fr, kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
References: <f9303bdc-b1a7-be5e-56c6-dfa8232b8b55@web.de>
 <e33f264a-7ee9-4ebc-d58e-bbb7fd567198@web.de>
 <d0381c8e-7302-b0ed-cf69-cbc8c3618106@web.de>
Content-Language: en-US
From:   Coly Li <colyli@suse.de>
In-Reply-To: <d0381c8e-7302-b0ed-cf69-cbc8c3618106@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/25/23 5:31 PM, Markus Elfring wrote:
> Date: Mon, 20 Mar 2023 13:13:37 +0100
>
> The label “err” was used to jump to another pointer check despite of
> the detail in the implementation of the function “mca_alloc”
> that it was determined already that a corresponding variable contained
> a null pointer because of a failed function call “mca_bucket_alloc”.


Hmm, I don't get the exact point from the above long sentence. Could you 
please describe a bit more specific where the problem is at exact line 
number of the code?

> * Thus use a more appropriate label instead.

So far I am not convinced the modified label is more appropriate.

>
> * Delete a redundant check.

Where is the location of the redundant check?


>
>
> This issue was detected by using the Coccinelle software.

Just curious, what is the warning reported by the mentioned software ?


>
> Fixes: cafe563591446cf80bfbc2fe3bc72a2e36cf1060 ("bcache: A block layer cache")
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>   drivers/md/bcache/btree.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a989a..166afd7ec499 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -921,18 +921,18 @@ static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
>   		if (!mca_reap(b, 0, false)) {
>   			mca_data_alloc(b, k, __GFP_NOWARN|GFP_NOIO);
>   			if (!b->keys.set[0].data)
> -				goto err;
> +				goto unlock;
>   			else
>   				goto out;
>   		}
>
>   	b = mca_bucket_alloc(c, k, __GFP_NOWARN|GFP_NOIO);
>   	if (!b)
> -		goto err;
> +		goto unlock;
>
>   	BUG_ON(!down_write_trylock(&b->lock));
>   	if (!b->keys.set->data)
> -		goto err;
> +		goto unlock;
>   out:
>   	BUG_ON(b->io_mutex.count != 1);
>
> @@ -955,9 +955,8 @@ static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
>   				    &b->c->expensive_debug_checks);
>
>   	return b;
> -err:
> -	if (b)
> -		rw_unlock(true, b);
> +unlock:
> +	rw_unlock(true, b);

If b is NULL, is it a bit fishing to send the NULL pointer into 
rw_unlock() ?


Thanks in advance for more information.


Coly Li

