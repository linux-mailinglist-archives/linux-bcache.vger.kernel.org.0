Return-Path: <linux-bcache+bounces-851-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5852BA7E45E
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Apr 2025 17:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25776188E4E1
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Apr 2025 15:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA9761F9F70;
	Mon,  7 Apr 2025 15:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldpaeLuL"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B659115C158
	for <linux-bcache@vger.kernel.org>; Mon,  7 Apr 2025 15:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744039366; cv=none; b=NJiIYSjBgzAQXQz5b1oWATnxKTglTAENcwwL4nMswXkH+boM/bQ20ZZarZZBcjAU+aHG00AAWGBbRB72TNOXsKEckhjIaRJe3KzZuMegApsHO5vDIPhmF3IWU1uaib6fDuScb+T+1PaL4VIMP5YDMPeBnq3mdTfHASEQ2ChI3WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744039366; c=relaxed/simple;
	bh=sT5ODP5Dz47OWYXjpRfIUMP62LM1tOKLL9zRX1a+vPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2qyKdi2lJJItxODIjTtqttWiRYkg9GkDgFmwmQ40HHuQJjepa02LCeYywB94MjDgPr6RdtGZ02DiiMVhFen/HrNq1+CC0oDtdhY805VJxGkaEO9GiUPiB32iKn+qGMMOAOnWrwDWgeZLSEHPD9lTT1wclfy2LoLnIoIxrSFQzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldpaeLuL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8358C4CEDD;
	Mon,  7 Apr 2025 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744039366;
	bh=sT5ODP5Dz47OWYXjpRfIUMP62LM1tOKLL9zRX1a+vPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ldpaeLuLXJVK12T2iTyKLWFNS9IrVKQPjUFlN+eGphTC1q2MCWol9C/Py+bmSnzbp
	 s2ZBspVy5fPykt6aU1Dk4m8/mfmhNrufj9APBxahtfBGZ1glDXUNgb6W9COwYLVWJG
	 LRV5M30xsqV2ib/VaAW+sHjnkUoV6eZGphqx07OA8ducZAD/T2IH8FN4kBhDYrwGlf
	 MINU7wImEx9P8hrf7jpV+3Xy4AaVqPgDJWMAfU+MVgNK1SUHSsfaUlNhrRm6mU7Mdw
	 txBlm+lW3zE2hwdhe5VzXilCTUi7rUgzz4krivavzSPpH8TxCyt49ySN/X34TdTWPf
	 FRC70tCndf7WQ==
Date: Mon, 7 Apr 2025 23:22:41 +0800
From: Coly Li <colyli@kernel.org>
To: mingzhe.zou@easystack.cn
Cc: colyli@suse.de, linux-bcache@vger.kernel.org, 
	dongsheng.yang@easystack.cn, zoumingzhe@qq.com
Subject: Re: [PATCH] bcache: fix NULL pointer in cache_set_flush()
Message-ID: <wboosa77dyqt2sybdg4re7blmh56j2tkpcndydbztakdsxzobp@a7a2ur2wq73y>
References: <20250407125625.270827-1-mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250407125625.270827-1-mingzhe.zou@easystack.cn>

On Mon, Apr 07, 2025 at 08:56:25PM +0800, mingzhe.zou@easystack.cn wrote:
> From: Linggang Zeng <linggang.zeng@easystack.cn>
> 
> 1. LINE#1794 - LINE#1887 is some codes about function of
>    bch_cache_set_alloc().
> 2. LINE#2078 - LINE#2142 is some codes about function of
>    register_cache_set().
> 3. register_cache_set() will call bch_cache_set_alloc() in LINE#2098.
> 
>  1794 struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>  1795 {
>  ...
>  1860         if (!(c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL)) ||
>  1861             mempool_init_slab_pool(&c->search, 32, bch_search_cache) ||
>  1862             mempool_init_kmalloc_pool(&c->bio_meta, 2,
>  1863                                 sizeof(struct bbio) + sizeof(struct bio_vec) *
>  1864                                 bucket_pages(c)) ||
>  1865             mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size) ||
>  1866             bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
>  1867                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER) ||
>  1868             !(c->uuids = alloc_bucket_pages(GFP_KERNEL, c)) ||
>  1869             !(c->moving_gc_wq = alloc_workqueue("bcache_gc",
>  1870                                                 WQ_MEM_RECLAIM, 0)) ||
>  1871             bch_journal_alloc(c) ||
>  1872             bch_btree_cache_alloc(c) ||
>  1873             bch_open_buckets_alloc(c) ||
>  1874             bch_bset_sort_state_init(&c->sort, ilog2(c->btree_pages)))
>  1875                 goto err;
>                       ^^^^^^^^
>  1876
>  ...
>  1883         return c;
>  1884 err:
>  1885         bch_cache_set_unregister(c);
>               ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  1886         return NULL;
>  1887 }
>  ...
>  2078 static const char *register_cache_set(struct cache *ca)
>  2079 {
>  ...
>  2098         c = bch_cache_set_alloc(&ca->sb);
>  2099         if (!c)
>  2100                 return err;
>                       ^^^^^^^^^^
>  ...
>  2128         ca->set = c;
>  2129         ca->set->cache[ca->sb.nr_this_dev] = ca;
>               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  ...
>  2138         return NULL;
>  2139 err:
>  2140         bch_cache_set_unregister(c);
>  2141         return err;
>  2142 }
> 
> (1) If LINE#1860 - LINE#1874 is true, then do 'goto err'(LINE#1875) and
>     call bch_cache_set_unregister()(LINE#1885).
> (2) As (1) return NULL(LINE#1886), LINE#2098 - LINE#2100 would return.
> (3) As (2) has returned, LINE#2128 - LINE#2129 would do *not* give the
>     value to c->cache[], it means that c->cache[] is NULL.
> 
> LINE#1624 - LINE#1665 is some codes about function of cache_set_flush().
> As (1), in LINE#1885 call
> bch_cache_set_unregister()
> ---> bch_cache_set_stop()
>      ---> closure_queue()
>           -.-> cache_set_flush() (as below LINE#1624)
> 
>  1624 static void cache_set_flush(struct closure *cl)
>  1625 {
>  ...
>  1654         for_each_cache(ca, c, i)
>  1655                 if (ca->alloc_thread)
>                           ^^
>  1656                         kthread_stop(ca->alloc_thread);
>  ...
>  1665 }
> 
> (4) In LINE#1655 ca is NULL(see (3)) in cache_set_flush() then the
>     kernel crash occurred as below:
> [  846.712887] bcache: register_cache() error drbd6: cannot allocate memory
> [  846.713242] bcache: register_bcache() error : failed to register device
> [  846.713336] bcache: cache_set_free() Cache set 2f84bdc1-498a-4f2f-98a7-01946bf54287 unregistered
> [  846.713768] BUG: unable to handle kernel NULL pointer dereference at 00000000000009f8
> [  846.714790] PGD 0 P4D 0
> [  846.715129] Oops: 0000 [#1] SMP PTI
> [  846.715472] CPU: 19 PID: 5057 Comm: kworker/19:16 Kdump: loaded Tainted: G           OE    --------- -  - 4.18.0-147.5.1.el8_1.5es.3.x86_64 #1
> [  846.716082] Hardware name: ESPAN GI-25212/X11DPL-i, BIOS 2.1 06/15/2018
> [  846.716451] Workqueue: events cache_set_flush [bcache]
> [  846.716808] RIP: 0010:cache_set_flush+0xc9/0x1b0 [bcache]
> [  846.717155] Code: 00 4c 89 a5 b0 03 00 00 48 8b 85 68 f6 ff ff a8 08 0f 84 88 00 00 00 31 db 66 83 bd 3c f7 ff ff 00 48 8b 85 48 ff ff ff 74 28 <48> 8b b8 f8 09 00 00 48 85 ff 74 05 e8 b6 58 a2 e1 0f b7 95 3c f7
> [  846.718026] RSP: 0018:ffffb56dcf85fe70 EFLAGS: 00010202
> [  846.718372] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  846.718725] RDX: 0000000000000001 RSI: 0000000040000001 RDI: 0000000000000000
> [  846.719076] RBP: ffffa0ccc0f20df8 R08: ffffa0ce1fedb118 R09: 000073746e657665
> [  846.719428] R10: 8080808080808080 R11: 0000000000000000 R12: ffffa0ce1fee8700
> [  846.719779] R13: ffffa0ccc0f211a8 R14: ffffa0cd1b902840 R15: ffffa0ccc0f20e00
> [  846.720132] FS:  0000000000000000(0000) GS:ffffa0ce1fec0000(0000) knlGS:0000000000000000
> [  846.720726] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  846.721073] CR2: 00000000000009f8 CR3: 00000008ba00a005 CR4: 00000000007606e0
> [  846.721426] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  846.721778] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  846.722131] PKRU: 55555554
> [  846.722467] Call Trace:
> [  846.722814]  process_one_work+0x1a7/0x3b0
> [  846.723157]  worker_thread+0x30/0x390
> [  846.723501]  ? create_worker+0x1a0/0x1a0
> [  846.723844]  kthread+0x112/0x130
> [  846.724184]  ? kthread_flush_work_fn+0x10/0x10
> [  846.724535]  ret_from_fork+0x35/0x40
> 
> Now, check whether that ca is NULL in LINE#1655 to fix the issue.
> 
> Signed-off-by: Linggang Zeng <linggang.zeng@easystack.cn>
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>

Nice catch!  Thanks for the fix up!

There are two suggestions from me,

1) the above code example is from 4.18 kernel I guess, could you please
   update the commit log against latest upstream kernel code?

> ---
>  drivers/md/bcache/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e42f1400cea9..7f07712580fe 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1733,7 +1733,7 @@ static CLOSURE_CALLBACK(cache_set_flush)
>  			mutex_unlock(&b->write_lock);
>  		}
>  

2) Could you please add code commet here to explain why ca is checked
   here? Let other people to know that in registration failure code
   path, ca might be NULL. Such information could be quite helpful for
   others to understand the code.

> -	if (ca->alloc_thread)
> +	if (ca && ca->alloc_thread)
>  		kthread_stop(ca->alloc_thread);
>  
>  	if (c->journal.cur) {
> -- 
> 2.34.1
> 
> 

-- 
Coly Li

