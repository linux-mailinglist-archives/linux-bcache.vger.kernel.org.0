Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B08247471B
	for <lists+linux-bcache@lfdr.de>; Tue, 14 Dec 2021 17:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhLNQGe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 Dec 2021 11:06:34 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59608 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhLNQGd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Dec 2021 11:06:33 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C70BA2113A;
        Tue, 14 Dec 2021 16:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639497992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NT5U3IBBu3zIl+MvV3LWXzL3na5KAZybETh0/QdFudY=;
        b=ieySwhGw11xCiI/MQFYTA752M4q0LBN0wPfv/2LhnAHDuc3M2krxA075B51v2zRvVg7sZX
        vAhALp4rVlm7POVEXXyLiruiDDDsszGiEds9x5y0a0uj4cGalVmGVxsiiBgZ12XAj2I/II
        LorvlB+WU7+jGnO2RR7SHTG925OATMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639497992;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NT5U3IBBu3zIl+MvV3LWXzL3na5KAZybETh0/QdFudY=;
        b=+nKNzbUXvxXoF+DmZdk/wN5KlNI2TM1VYpv0klM70Iq9mTV+ej7TOd2RXwmt2rjPeprXs2
        bmI7n41eSdlgFJDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3AA6713EA2;
        Tue, 14 Dec 2021 16:06:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bWyaNgbBuGF9dgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 14 Dec 2021 16:06:30 +0000
Message-ID: <77a855ff-fb0d-5c7b-d2fd-24d58beb6a07@suse.de>
Date:   Wed, 15 Dec 2021 00:06:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: bcache-register hang after reboot
Content-Language: en-US
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
Cc:     linux-bcache@vger.kernel.org, nkshirsagar@gmail.com,
        kent.overstreet@gmail.com
References: <YY/+YDSjdZPma3oT@moria.home.lan>
 <20211213220455.1633987-1-mfo@canonical.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211213220455.1633987-1-mfo@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/14/21 6:04 AM, Mauricio Faria de Oliveira wrote:
> Hey Kent and Coly,
>
> It turns out that, at least for the disk image that reproduces the issue,
> the closure from bch_btree_set_root() to bch_journal_meta() doesn't make
> a difference; the stall is in bch_journal() -> journal_wait_for_write().
>
> So the previous suggestion to skip bch_journal_meta() altogether works,
> to get things going.. of course, checking for journal replay/full case.
>
> What do you think of this patch?
>
> It simply checks the conditions in run_cache_set() for bch_journal_replay().
> (it starts w/ unlikely(!CACHE_SET_RUNNING) to quickly get to the usual case,
> and apparently has an extra strict check for !gc_thread, just in case.
> And it is journal_full() only, as the !journal_full() case in journal_wait_
> for_write() seems to be handled via another function per the comment.)
>
> This works w/ the disk image here.

Hi Mauricio,

The following patch might work but not a proper fix. I am in travel 
recently, and hope soon I may have time to refine a patch for such 
non-space issue for journal.
I have a patch but it need to be rebased with the latest bcache code.

Thanks.

Coly Li


>
> Thanks!
> Mauricio
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 72abe5cf4b12..bedeffc3ae28 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -2477,9 +2477,6 @@ int bch_btree_insert(struct cache_set *c, struct keylist *keys,
>   void bch_btree_set_root(struct btree *b)
>   {
>   	unsigned int i;
> -	struct closure cl;
> -
> -	closure_init_stack(&cl);
>   
>   	trace_bcache_btree_set_root(b);
>   
> @@ -2494,8 +2491,18 @@ void bch_btree_set_root(struct btree *b)
>   
>   	b->c->root = b;
>   
> -	bch_journal_meta(b->c, &cl);
> -	closure_sync(&cl);
> +	/* Don't journal during replay if journal is full (prevents deadlock) */
> +	if (unlikely(!test_bit(CACHE_SET_RUNNING, &b->c->flags)) &&
> +	    CACHE_SYNC(&b->c->cache->sb) && b->c->gc_thread == NULL &&
> +	    journal_full(&b->c->journal)) {
> +		pr_info("Not journaling new root (replay with full journal)\n");
> +	} else {
> +		struct closure cl;
> +
> +		closure_init_stack(&cl);
> +		bch_journal_meta(b->c, &cl);
> +		closure_sync(&cl);
> +	}
>   }
>   
>   /* Map across nodes or keys */

