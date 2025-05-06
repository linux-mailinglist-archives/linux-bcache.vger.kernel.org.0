Return-Path: <linux-bcache+bounces-1034-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E982AACE71
	for <lists+linux-bcache@lfdr.de>; Tue,  6 May 2025 21:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C74E81B68602
	for <lists+linux-bcache@lfdr.de>; Tue,  6 May 2025 19:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C914D20E007;
	Tue,  6 May 2025 19:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="b2guc51e"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail69.out.titan.email (mail69.out.titan.email [3.216.99.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E231FBCB1
	for <linux-bcache@vger.kernel.org>; Tue,  6 May 2025 19:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.216.99.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746561304; cv=none; b=kmVVqrCYZeQMXcYtUqUrLiXrSBcXRwnYktySyC/sCxJST3fkpCpZT8gU7HnG4zXKp/UvLxHnmZGsSwgL0CbEBr2iFP6K4j7p8lDMmvD7fRUPQcTdKiEoNYb5bc3dHY4+psF1DSF7djTKrw0dd3ZMC1Y7prPDG6qsdzXPIuHAgX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746561304; c=relaxed/simple;
	bh=ROp6IZyuKZWWt4b88VR4BdFL5rrK6fWKO95pNvSJjqo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=oqJ9zOuKvOIVF817PDFYseE2+o3caA1psotsUfuw83DKsfzXoF3FTYcwGvaTrFRVItHima9sRIVEgbWlzs1Ta3MAtR/GnBCgO5M69F9Rliq107NvORveNUQW8pNjn7FUxwoOZ5oHs1rPNKVM39V0P6f7GSavnEQWhDXGa1hg8p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=b2guc51e; arc=none smtp.client-ip=3.216.99.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id E7377140182;
	Tue,  6 May 2025 11:37:11 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=ebikhE+cHVrhTr8lH9oSX4FOMk6NUqQXUXww3QR480E=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=from:in-reply-to:cc:mime-version:subject:message-id:references:date:to:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1746531431; v=1;
	b=b2guc51eqZ6JwJbTkkE7pR8GYkR3//dWhCd0nKgbdPYSjBSWhkv2BiQBBSFLYMXSz6IHtRuy
	A4Ponlw+iDU6sbwgraH+jjBXdVieyV8CFqHh/R5rQOnOuiIopxdi5WWQCWR1+y/mlIWEH9IyUk1
	toFPY75m0EBnq/OTgHc6czRU=
Received: from smtpclient.apple (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id C450E14047D;
	Tue,  6 May 2025 11:37:09 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH v2] bcache: fix NULL pointer in cache_set_flush()
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <20250506084421.74535-1-mingzhe.zou@easystack.cn>
Date: Tue, 6 May 2025 19:36:57 +0800
Cc: colyli@kernel.org,
 linux-bcache@vger.kernel.org,
 linggang.zeng@easystack.cn,
 zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3D52671A-2605-4F2B-9B89-2C39921556A0@coly.li>
References: <20250506084421.74535-1-mingzhe.zou@easystack.cn>
To: mingzhe.zou@easystack.cn
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1746531431747709932.32042.648397193849182003@prod-use1-smtp-out1003.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=RvE/LDmK c=1 sm=1 tr=0 ts=6819f467
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=1npmrZcIulGByzFi36wA:9
	a=QEXdDO2ut3YA:10



> 2025=E5=B9=B45=E6=9C=886=E6=97=A5 16:44=EF=BC=8Cmingzhe.zou@easystack.cn=
 =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: Linggang Zeng <linggang.zeng@easystack.cn>
>=20
> 1. LINE#1794 - LINE#1887 is some codes about function of
>   bch_cache_set_alloc().
> 2. LINE#2078 - LINE#2142 is some codes about function of
>   register_cache_set().
> 3. register_cache_set() will call bch_cache_set_alloc() in LINE#2098.
>=20
> 1794 struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
> 1795 {
> ...
> 1860         if (!(c->devices =3D kcalloc(c->nr_uuids, sizeof(void *), =
GFP_KERNEL)) ||
> 1861             mempool_init_slab_pool(&c->search, 32, =
bch_search_cache) ||
> 1862             mempool_init_kmalloc_pool(&c->bio_meta, 2,
> 1863                                 sizeof(struct bbio) + =
sizeof(struct bio_vec) *
> 1864                                 bucket_pages(c)) ||
> 1865             mempool_init_kmalloc_pool(&c->fill_iter, 1, =
iter_size) ||
> 1866             bioset_init(&c->bio_split, 4, offsetof(struct bbio, =
bio),
> 1867                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER) ||
> 1868             !(c->uuids =3D alloc_bucket_pages(GFP_KERNEL, c)) ||
> 1869             !(c->moving_gc_wq =3D alloc_workqueue("bcache_gc",
> 1870                                                 WQ_MEM_RECLAIM, =
0)) ||
> 1871             bch_journal_alloc(c) ||
> 1872             bch_btree_cache_alloc(c) ||
> 1873             bch_open_buckets_alloc(c) ||
> 1874             bch_bset_sort_state_init(&c->sort, =
ilog2(c->btree_pages)))
> 1875                 goto err;
>                      ^^^^^^^^
> 1876
> ...
> 1883         return c;
> 1884 err:
> 1885         bch_cache_set_unregister(c);
>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 1886         return NULL;
> 1887 }
> ...
> 2078 static const char *register_cache_set(struct cache *ca)
> 2079 {
> ...
> 2098         c =3D bch_cache_set_alloc(&ca->sb);
> 2099         if (!c)
> 2100                 return err;
>                      ^^^^^^^^^^
> ...
> 2128         ca->set =3D c;
> 2129         ca->set->cache[ca->sb.nr_this_dev] =3D ca;
>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> ...
> 2138         return NULL;
> 2139 err:
> 2140         bch_cache_set_unregister(c);
> 2141         return err;
> 2142 }
>=20
> (1) If LINE#1860 - LINE#1874 is true, then do 'goto err'(LINE#1875) =
and
>    call bch_cache_set_unregister()(LINE#1885).
> (2) As (1) return NULL(LINE#1886), LINE#2098 - LINE#2100 would return.
> (3) As (2) has returned, LINE#2128 - LINE#2129 would do *not* give the
>    value to c->cache[], it means that c->cache[] is NULL.
>=20
> LINE#1624 - LINE#1665 is some codes about function of =
cache_set_flush().
> As (1), in LINE#1885 call
> bch_cache_set_unregister()
> ---> bch_cache_set_stop()
>     ---> closure_queue()
>          -.-> cache_set_flush() (as below LINE#1624)
>=20
> 1624 static void cache_set_flush(struct closure *cl)
> 1625 {
> ...
> 1654         for_each_cache(ca, c, i)
> 1655                 if (ca->alloc_thread)
>                          ^^
> 1656                         kthread_stop(ca->alloc_thread);
> ...
> 1665 }
>=20
> (4) In LINE#1655 ca is NULL(see (3)) in cache_set_flush() then the
>    kernel crash occurred as below:
> [  846.712887] bcache: register_cache() error drbd6: cannot allocate =
memory
> [  846.713242] bcache: register_bcache() error : failed to register =
device
> [  846.713336] bcache: cache_set_free() Cache set =
2f84bdc1-498a-4f2f-98a7-01946bf54287 unregistered
> [  846.713768] BUG: unable to handle kernel NULL pointer dereference =
at 00000000000009f8
> [  846.714790] PGD 0 P4D 0
> [  846.715129] Oops: 0000 [#1] SMP PTI
> [  846.715472] CPU: 19 PID: 5057 Comm: kworker/19:16 Kdump: loaded =
Tainted: G           OE    --------- -  - =
4.18.0-147.5.1.el8_1.5es.3.x86_64 #1
> [  846.716082] Hardware name: ESPAN GI-25212/X11DPL-i, BIOS 2.1 =
06/15/2018
> [  846.716451] Workqueue: events cache_set_flush [bcache]
> [  846.716808] RIP: 0010:cache_set_flush+0xc9/0x1b0 [bcache]
> [  846.717155] Code: 00 4c 89 a5 b0 03 00 00 48 8b 85 68 f6 ff ff a8 =
08 0f 84 88 00 00 00 31 db 66 83 bd 3c f7 ff ff 00 48 8b 85 48 ff ff ff =
74 28 <48> 8b b8 f8 09 00 00 48 85 ff 74 05 e8 b6 58 a2 e1 0f b7 95 3c =
f7
> [  846.718026] RSP: 0018:ffffb56dcf85fe70 EFLAGS: 00010202
> [  846.718372] RAX: 0000000000000000 RBX: 0000000000000000 RCX: =
0000000000000000
> [  846.718725] RDX: 0000000000000001 RSI: 0000000040000001 RDI: =
0000000000000000
> [  846.719076] RBP: ffffa0ccc0f20df8 R08: ffffa0ce1fedb118 R09: =
000073746e657665
> [  846.719428] R10: 8080808080808080 R11: 0000000000000000 R12: =
ffffa0ce1fee8700
> [  846.719779] R13: ffffa0ccc0f211a8 R14: ffffa0cd1b902840 R15: =
ffffa0ccc0f20e00
> [  846.720132] FS:  0000000000000000(0000) GS:ffffa0ce1fec0000(0000) =
knlGS:0000000000000000
> [  846.720726] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  846.721073] CR2: 00000000000009f8 CR3: 00000008ba00a005 CR4: =
00000000007606e0
> [  846.721426] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
> [  846.721778] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: =
0000000000000400
> [  846.722131] PKRU: 55555554
> [  846.722467] Call Trace:
> [  846.722814]  process_one_work+0x1a7/0x3b0
> [  846.723157]  worker_thread+0x30/0x390
> [  846.723501]  ? create_worker+0x1a0/0x1a0
> [  846.723844]  kthread+0x112/0x130
> [  846.724184]  ? kthread_flush_work_fn+0x10/0x10
> [  846.724535]  ret_from_fork+0x35/0x40
>=20
> Now, check whether that ca is NULL in LINE#1655 to fix the issue.
>=20
> Signed-off-by: Linggang Zeng <linggang.zeng@easystack.cn>
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>


The patch is added into my for-next. Thanks!

Coly Li



>=20
> ---
> Changes in v2:
>=20
> - add code commet
> ---
> drivers/md/bcache/super.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 813b38aec3e4..37f5e31618c0 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1733,7 +1733,12 @@ static CLOSURE_CALLBACK(cache_set_flush)
> mutex_unlock(&b->write_lock);
> }
>=20
> - if (ca->alloc_thread)
> + /*
> + * If the register_cache_set() call to bch_cache_set_alloc() failed,
> + * ca has not been assigned a value and return error.
> + * So we need check ca is not NULL during bch_cache_set_unregister().
> + */
> + if (ca && ca->alloc_thread)
> kthread_stop(ca->alloc_thread);
>=20
> if (c->journal.cur) {
> --=20
> 2.34.1
>=20


