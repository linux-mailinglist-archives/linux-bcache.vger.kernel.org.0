Return-Path: <linux-bcache+bounces-398-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 859248A23D9
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Apr 2024 04:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6E461C212AD
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Apr 2024 02:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2691DDDC3;
	Fri, 12 Apr 2024 02:43:09 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEDD17F5
	for <linux-bcache@vger.kernel.org>; Fri, 12 Apr 2024 02:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712889789; cv=none; b=sEll7oxJHhAGTd5xJ0bD7pDJVN7fsvcZH+7w+84mdeLVa+B5Q1oJ0IwDtyQzoRdBQQkCCYtqJ58HUNvdtbSW4SFb3bx8EZmKd42PyG0ZHMTDN01S49sY3Sa/Y3bjK/H9QiwHeYbqOAfavzrxcxd0YAGtGoDUgSpvyppdhPguSfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712889789; c=relaxed/simple;
	bh=3hSqVULX5NAcFBolgWncAMKyObfmQyBqEXkF3T2xeM0=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Ssr6MrM7iKnAVL3JqAKGvgRgzo4z7kMEkmH83h5+S9CVXm6FWzyKYkf4Lm8yL7pzpJZsHkN9RhpfzJgpfYQPtUi5d6VNnEmqfgn8rfAUyY3AL5rPiEvw2onkUfsdq2DPvQSaPHhcWkADSD8QPgTOKV5mRHlrZYVSfgZDjNnbtnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id D28E446;
	Thu, 11 Apr 2024 19:43:00 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id WwojyPxiyajY; Thu, 11 Apr 2024 19:43:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 0170345;
	Thu, 11 Apr 2024 19:43:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 0170345
Date: Thu, 11 Apr 2024 19:42:59 -0700 (PDT)
From: Eric Wheeler <bcache@lists.ewheeler.net>
To: Coly Li <colyli@suse.de>
cc: linux-bcache@vger.kernel.org, Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: bcache: bch_extent_bad() stale dirty pointer
Message-ID: <dd6d4e1-dcd9-81e2-4be1-1999dae5a90@ewheeler.net>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Coly and Mingzhe,

Have you ever seen this dmesg notice before?  It only printed two lines 
into dmesg:

[Apr11 19:28] bcache: bch_extent_bad() stale dirty pointer, stale 1, key: 0:15956311168 len 24 -> [0:32419560 gen 88] dirty
[  +0.014297] bcache: bch_extent_bad() stale dirty pointer, stale 1, key: 0:15956311168 len 24 -> [0:32419560 gen 88] dirty

This doesn't look like its a major concern, after all just this is a 
pr_info, and the "stale" value of "1" is well below BUCKET_GC_GEN_MAX (96) 
so I'm not at risk of hitting btree_bug_on().

Is this something that should be addressed?

Near extents.c:537:

static bool bch_extent_bad(struct btree_keys *bk, const struct bkey *k)
{
        struct btree *b = container_of(bk, struct btree, keys);
        unsigned int i, stale;
        char buf[80];

        if (!KEY_PTRS(k) ||
            bch_extent_invalid(bk, k))
                return true;

        for (i = 0; i < KEY_PTRS(k); i++)
                if (!ptr_available(b->c, k, i))
                        return true;

        for (i = 0; i < KEY_PTRS(k); i++) {
                stale = ptr_stale(b->c, k, i);

                if (stale && KEY_DIRTY(k)) {
                        bch_extent_to_text(buf, sizeof(buf), k);
                        pr_info("stale dirty pointer, stale %u, key: %s\n",  <<<<<<<
                                stale, buf);
                }

                btree_bug_on(stale > BUCKET_GC_GEN_MAX, b,
                             "key too stale: %i, need_gc %u",
                             stale, b->c->need_gc);

                if (stale)
                        return true;

                if (expensive_debug_checks(b->c) &&
                    bch_extent_bad_expensive(b, k, i))
                        return true;
        }

        return false;
}



--
Eric Wheeler

