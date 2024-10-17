Return-Path: <linux-bcache+bounces-761-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B2639A1F30
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Oct 2024 11:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29E0B286144
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Oct 2024 09:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FC11D966B;
	Thu, 17 Oct 2024 09:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bka1yfHI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADAC16EB76;
	Thu, 17 Oct 2024 09:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729158938; cv=none; b=gbmaxtSKNR8kSlArNwAFoU+zEZh4WJYUkbSxnjG8ePwfahgiRwna0Vgu8Ye5n0XOaZvF7NcMYUZZuIBmANIzYPYxRq+xX8dV6PFgr4fm1QF8/gMUefGIBtz52nOLs9CQotEEUeL+CDs/bdJtgIasBRs+x7aSUijSTKnybfigUqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729158938; c=relaxed/simple;
	bh=jDvtsPbcr0H75RQrCE+HeDm5nfsBOQOeboAG3Mzs84E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsS/vzFNDaWo71Szy3Ks+QH0MPByO0fh4d8VWjRvsYIvuNgWTxYDXySvCy7x40R3oxgv6bQhbEX+no7JQfDscjJh9++Kg1rLveZUv9/1g+Y+BEG+YPRUyiXpueDuBkGvAJc8DQrUf8S5s8d6Me01E4aANlBkgd+TraKacRPUsVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bka1yfHI; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y2W+oUfoBhBZaZIr2AfzfeDyPa8UlZnH7iYkbKqwcvY=; b=bka1yfHINVgrWdYd3h2GhG4X0s
	3lAVad3sQ8+8xJ5skIdH0dlNPRaOoFVg/O7uzue+ZuxjBFEkUdj9FNcUi483B1YvQHund84pa2Ysn
	fnR47qcxyvZy7AgPxDSLL1HPO4uTcjlsx8dPQxKEo/Cajv+kHGVgf23ziOkJN8ndgHSlN//m/D1GO
	G37c0Iu6JZvAGaMPniPJBphVngE37jkpjMBJDetiDqNKa2LiJG7v8smCPdWr5JbilTR6hNQaTBWJl
	W52YZOWKgBrE9FMiO91iw99zdEt1ykmgNH92WhulRZYmuSTeCALNMFXXt/z4GfhJ+P3jJ4XuiWVrz
	4NKN8J0w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t1NE0-0000000AhR2-3ED7;
	Thu, 17 Oct 2024 09:55:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D4B483005AF; Thu, 17 Oct 2024 11:55:20 +0200 (CEST)
Date: Thu, 17 Oct 2024 11:55:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, colyli@suse.de, msakai@redhat.com,
	corbet@lwn.net, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/min_heap: Introduce non-inline versions of min
 heap API functions
Message-ID: <20241017095520.GV16066@noisy.programming.kicks-ass.net>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-2-visitorckw@gmail.com>
 <20241014081358.GS17263@noisy.programming.kicks-ass.net>
 <ZwznQzdZsg82KNT4@visitorckw-System-Product-Name>
 <xb2gihmastm3wjn2o2sufvtglvjkelhiiwhnlzoiz4qncywyga@txf4vvnyxhvu>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xb2gihmastm3wjn2o2sufvtglvjkelhiiwhnlzoiz4qncywyga@txf4vvnyxhvu>

On Wed, Oct 16, 2024 at 11:26:30PM -0400, Kent Overstreet wrote:

> yeah, I think we would prefer smaller codesize, by default.
> 
> it'd be well worth checking the code size difference on inlined vs. not,
> and then the really think to do would be to provide optional _inlined()
> helpers that we can switch to if/when a particular codepath shows up in
> a profile

Make sure to build with kCFI and IBT enabled when you do this and enjoy
seeing ec_stripes_heap_cmp turn into this:

00000000000027c0 <__cfi_ec_stripes_heap_cmp>:
    27c0:       b8 01 88 88 07          mov    $0x7888801,%eax
    27c5:       90                      nop
    27c6:       90                      nop
    27c7:       90                      nop
    27c8:       90                      nop
    27c9:       90                      nop
    27ca:       90                      nop
    27cb:       90                      nop
    27cc:       90                      nop
    27cd:       90                      nop
    27ce:       90                      nop
    27cf:       90                      nop

00000000000027d0 <ec_stripes_heap_cmp>:
    27d0:       f3 0f 1e fa             endbr64
    27d4:       e8 00 00 00 00          call   27d9 <ec_stripes_heap_cmp+0x9>   27d5: R_X86_64_PLT32    __fentry__-0x4
    27d9:       8b 47 08                mov    0x8(%rdi),%eax
    27dc:       3b 46 08                cmp    0x8(%rsi),%eax
    27df:       0f 92 c0                setb   %al
    27e2:       2e e9 00 00 00 00       cs jmp 27e8 <ec_stripes_heap_cmp+0x18>  27e4: R_X86_64_PLT32    __x86_return_thunk-0x4
    27e8:       0f 1f 84 00 00 00 00 00         nopl   0x0(%rax,%rax,1)
    27f0:       90                      nop
    27f1:       90                      nop
    27f2:       90                      nop
    27f3:       90                      nop
    27f4:       90                      nop


While I was there, you might want to do the below. It makes no sense
duplicating that thing.

---

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 1587c6e1866a..3a6c34cf8a15 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1048,6 +1048,11 @@ static inline void ec_stripes_heap_swap(void *l, void *r, void *h)
 	ec_stripes_heap_set_backpointer(_h, j);
 }
 
+static const struct min_heap_callbacks ec_stripes_callbacks = {
+	.less = ec_stripes_heap_cmp,
+	.swp = ec_stripes_heap_swap,
+};
+
 static void heap_verify_backpointer(struct bch_fs *c, size_t idx)
 {
 	ec_stripes_heap *h = &c->ec_stripes_heap;
@@ -1060,26 +1065,16 @@ static void heap_verify_backpointer(struct bch_fs *c, size_t idx)
 void bch2_stripes_heap_del(struct bch_fs *c,
 			   struct stripe *m, size_t idx)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = ec_stripes_heap_cmp,
-		.swp = ec_stripes_heap_swap,
-	};
-
 	mutex_lock(&c->ec_stripes_heap_lock);
 	heap_verify_backpointer(c, idx);
 
-	min_heap_del(&c->ec_stripes_heap, m->heap_idx, &callbacks, &c->ec_stripes_heap);
+	min_heap_del(&c->ec_stripes_heap, m->heap_idx, &ec_strips_callbacks, &c->ec_stripes_heap);
 	mutex_unlock(&c->ec_stripes_heap_lock);
 }
 
 void bch2_stripes_heap_insert(struct bch_fs *c,
 			      struct stripe *m, size_t idx)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = ec_stripes_heap_cmp,
-		.swp = ec_stripes_heap_swap,
-	};
-
 	mutex_lock(&c->ec_stripes_heap_lock);
 	BUG_ON(min_heap_full(&c->ec_stripes_heap));
 
@@ -1088,7 +1083,7 @@ void bch2_stripes_heap_insert(struct bch_fs *c,
 			.idx = idx,
 			.blocks_nonempty = m->blocks_nonempty,
 		}),
-		&callbacks,
+		&ec_stripes_callbacks,
 		&c->ec_stripes_heap);
 
 	heap_verify_backpointer(c, idx);
@@ -1098,10 +1093,6 @@ void bch2_stripes_heap_insert(struct bch_fs *c,
 void bch2_stripes_heap_update(struct bch_fs *c,
 			      struct stripe *m, size_t idx)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = ec_stripes_heap_cmp,
-		.swp = ec_stripes_heap_swap,
-	};
 	ec_stripes_heap *h = &c->ec_stripes_heap;
 	bool do_deletes;
 	size_t i;
@@ -1112,8 +1103,8 @@ void bch2_stripes_heap_update(struct bch_fs *c,
 	h->data[m->heap_idx].blocks_nonempty = m->blocks_nonempty;
 
 	i = m->heap_idx;
-	min_heap_sift_up(h,	i, &callbacks, &c->ec_stripes_heap);
-	min_heap_sift_down(h, i, &callbacks, &c->ec_stripes_heap);
+	min_heap_sift_up(  h, i, &ec_stripes_callbacks, &c->ec_stripes_heap);
+	min_heap_sift_down(h, i, &ec_stripes_callbacks, &c->ec_stripes_heap);
 
 	heap_verify_backpointer(c, idx);
 

