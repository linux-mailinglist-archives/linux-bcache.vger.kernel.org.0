Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5614D432E
	for <lists+linux-bcache@lfdr.de>; Thu, 10 Mar 2022 10:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbiCJJLu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 10 Mar 2022 04:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiCJJLu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 10 Mar 2022 04:11:50 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D6913776D
        for <linux-bcache@vger.kernel.org>; Thu, 10 Mar 2022 01:10:49 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2DB7A1F441;
        Thu, 10 Mar 2022 09:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646903448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vs+DpsxxwSiGIdpUb/UeAPeOjRWxTweHviRjPycZrh8=;
        b=uQytoi1gCnWzv5XuBl47vJ49LI5/huuQH+OTgcMrnHtwYePfmiIBagMTxqKUgecsPRs4ch
        kbAuWHmv7lyqhU3RNY1IRmmuvrYxRDSIr70h6p5yUSHuFQcqzp9YiM+oKorRcOXHCSxdEN
        6JJfB2NktJj4fnMy9bFGz7LmAf6Fhnk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646903448;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vs+DpsxxwSiGIdpUb/UeAPeOjRWxTweHviRjPycZrh8=;
        b=Q2oPSiP9xB/7XM1jPK566TuIqUTzufZiNoPKE8c2dyuGsDTi12Hh7GD2NAz5XzkWIX+yyg
        D7xXasOsfYDHQmBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47E9F13FA3;
        Thu, 10 Mar 2022 09:10:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id P+2iLpbAKWIKSgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 10 Mar 2022 09:10:46 +0000
Message-ID: <8146b053-deec-ae29-ea49-d8df8f1c0b6e@suse.de>
Date:   Thu, 10 Mar 2022 17:10:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH] Bcache: don't return BLK_STS_IOERR during cache detach
Content-Language: en-US
To:     Zhang Zhen <zhangzhen.email@gmail.com>
References: <20220307091409.3273-1-zhangzhen.email@gmail.com>
 <7e4035fa-a7cb-6be5-a143-011e035d8f33@gmail.com>
From:   Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
In-Reply-To: <7e4035fa-a7cb-6be5-a143-011e035d8f33@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/10/22 10:50 AM, Zhang Zhen wrote:
> Before this patch, if cache device missing, cached_dev_submit_bio 
> return io err
> to fs during cache detach, randomly lead to xfs do force shutdown.
>
> This patch delay the cache io submit in cached_dev_submit_bio
> and wait for cache set detach finish.
> So if the cache device become missing, bcache detach cache set 
> automatically,
> and the io will sumbit normally.
>
> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
> error on writing btree.
> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: IO 
> error on writing btree.
> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
> error on writing btree.
> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
> "xfs_buf_iodone_callback_error" at daddr 0x80034658 len 32 error 12
> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() bcache: error 
> on 004f8aa7-561a-4ba7-bf7b-292e461d3f18:
> Feb  2 20:59:23  kernel: journal io error
> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() , disabling 
> caching
> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> Feb  2 20:59:23  kernel: bcache: conditional_stop_bcache_device() 
> stop_when_cache_set_failed of bcache43 is "auto" and cache is clean, 
> keep it alive.
> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
> "xlog_iodone" at daddr 0x400123e60 len 64 error 12
> Feb  2 20:59:23  kernel: XFS (bcache43): xfs_do_force_shutdown(0x2) 
> called from line 1298 of file fs/xfs/xfs_log.c. Return address = 
> 00000000c1c8077f
> Feb  2 20:59:23  kernel: XFS (bcache43): Log I/O Error Detected. 
> Shutting down filesystem
> Feb  2 20:59:23  kernel: XFS (bcache43): Please unmount the filesystem 
> and rectify the problem(s)
>
> Signed-off-by: Zhen Zhang <zhangzhen.email@gmail.com>
> ---
>  drivers/md/bcache/bcache.h  | 5 -----
>  drivers/md/bcache/request.c | 8 ++++----
>  drivers/md/bcache/super.c   | 3 ++-
>  3 files changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 9ed9c955add7..e5227dd08e3a 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -928,11 +928,6 @@ static inline void closure_bio_submit(struct 
> cache_set *c,
>                        struct closure *cl)
>  {
>      closure_get(cl);
> -    if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
> -        bio->bi_status = BLK_STS_IOERR;
> -        bio_endio(bio);
> -        return;
> -    }
>      submit_bio_noacct(bio);
>  }


Comparing to make bcache device living as it looks like, avoiding data 
corruption or stale is much more critical. Therefore once there is 
critical device failure detected, the following I/O requests must be 
stopped (especially write request) to avoid further data corruption. 
Without the above checking for CACHE_SET_IO_DISABLE, the cache has to be 
attached until there is no I/O. For a busy system it should be quite 
long time. Then users may encounter silent data corruption or 
inconsistency after a long time since hardware failed.


Again, with the above change, you may introduce other issue which more 
hard to detect.


>  diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index d15aae6c51c1..36f0ee95b51f 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -13,6 +13,7 @@
>  #include "request.h"
>  #include "writeback.h"
>  +#include <linux/delay.h>
>  #include <linux/module.h>
>  #include <linux/hash.h>
>  #include <linux/random.h>
> @@ -1172,11 +1173,10 @@ void cached_dev_submit_bio(struct bio *bio)
>      unsigned long start_time;
>      int rw = bio_data_dir(bio);
>  -    if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
> &d->c->flags)) ||
> +    while (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
> &d->c->flags)) ||
>               dc->io_disable)) {
> -        bio->bi_status = BLK_STS_IOERR;
> -        bio_endio(bio);
> -        return;
> +        /* wait for detach finish and d->c == NULL. */
> +        msleep(2);
>      }

This is unacceptible, neither the infinite loop nor the msleep. You 
cannot solve the target issue by an infinite retry, such method will 
introduce more issue from other place.


>       if (likely(d->c)) {
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 140f35dc0c45..8d9a5e937bc8 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -661,7 +661,8 @@ int bch_prio_write(struct cache *ca, bool wait)
>          p->csum        = bch_crc64(&p->magic, 
> meta_bucket_bytes(&ca->sb) - 8);
>           bucket = bch_bucket_alloc(ca, RESERVE_PRIO, wait);
> -        BUG_ON(bucket == -1);
> +        if (bucket == -1)
> +            return -1;

This change is wrong. bucket == -1 indicates the bucket allocator 
doesn't work properly, if it happens something really critical 
happening. This is why BUG_ON is used here.

With the above change, you will encounter other strange issue sooner or 
later and hard to tell the root cause.


> mutex_unlock(&ca->set->bucket_lock);
>          prio_io(ca, bucket, REQ_OP_WRITE, 0);


Currently I don't have clear idea on how to avoid the IO error return 
value during cache set detaching for a failed cache device. But it 
cannot be such simple change by the this patch.


Coly Li

