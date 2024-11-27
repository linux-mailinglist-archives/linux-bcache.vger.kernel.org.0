Return-Path: <linux-bcache+bounces-804-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81DFE9DA047
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Nov 2024 02:28:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7835B2340D
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Nov 2024 01:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E4028E8;
	Wed, 27 Nov 2024 01:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJ4K1PVw"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3658C2C8;
	Wed, 27 Nov 2024 01:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732670917; cv=none; b=fu/WCVVQyDu15Vif0Bwam+irI8lqermbDXuqxJxvlubYujlU3D95wyGlUT5KTZWBrevZybhJ/mqofbV4hUL3DyDg8UGdKBdFamTirxO0xqA2fyrf8H1tVA1r27X9H1bbCiev53IwcmCugsZlhASbTJ+/ddPE3pCY6Q2XV+TMi6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732670917; c=relaxed/simple;
	bh=xgcVac1+8JTtY+MAEzTJPKDad8WK2RWqBk36DEWFFdw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NdoxeTLF//2Zbh9NpT0Dt26OnT9O1vQdZKxVkXFDwu4KnW1vQYADip1L//zBPq2/sSLv4x1RJkVq0TspmVxJH8G2Y+R6fUDhEL8nOxN2gY4qE4na0z6leGQoleoMtOX4LrV9zNAiNCO5uEqxnnEMazAA9xcKUesVAoavKvXXzfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VJ4K1PVw; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6ee676b4e20so64789407b3.3;
        Tue, 26 Nov 2024 17:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732670914; x=1733275714; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hrpi/+ve4yn+KqJVdDwRTih59lt+ln6RdiSdTwzQdBg=;
        b=VJ4K1PVw30SSHNdRjHfAa6SQBBvnAelQAb4EjUjoPDqiy0Q09srUfctR++spulPb/+
         ILzlXG21N24Fx34pZRA3sP2882YGbP0zSGR7kkEo76XzNPGgaJTf03LovwA+3Zr8zAOX
         YyN0uSokoVqTIAgC0B5QZEAYsoAWUZhqRk96X5ioAfiOXdqPFc5OlTclLQ0L8I9VG6rg
         1affk3dHKNpARnHWivfhqkqTHw37kyDxkw3HLDmLYM9T3XbcsX5he9mAp6nuJq/g+0xk
         Cq1nvGTUfSiEQMFl8ez3/06vClNb/dlQdqZEqB8AdKNbhStATVNkVIrJbnmdOiETJPKH
         6idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732670914; x=1733275714;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrpi/+ve4yn+KqJVdDwRTih59lt+ln6RdiSdTwzQdBg=;
        b=DBHeUtxqngexYdfLfU5bYQYamcOqlGaHdaJXsOOI5ntUXmiNYXjDLgH+PB2OhdG3C6
         jqaBGginEvQTxaAjaZNT2DE3gcVOaXYy3saCzFKAvtD8CmPkEohtWOWYdqN0Qe7W6Bv0
         WM5zTVDi35eBF0YBNvy2TvNG9fh/7niB5nVwSc7XzU98givR5UAFjmWz9qJmK9wCxzq4
         FcnSleArOw57h9BLwvJBOCi3QILrNiSu70ILc4Fq54IRF5P2UWrQ4mHxZhZskaxIvai+
         pIB0hEwweYNpvd+MbVUVCDBHfK23X/9X92TkcbU41lQw7Q6yO4MQivEkmRsYJFI9TDu5
         XT+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUYPboRyUhjoORnFXSsfB1A7ub+XkXkBpKcJ9mXVXAwPvoTDsbqm5aMG+2PohLkRdnezBM0zD08+jraT9wK@vger.kernel.org, AJvYcCWpDJhLZuckLWGvA8rjPXi2QUV5oO0QnVjYLNv7Gt0AYuYghoGWC8cIoRp0xXSZfi4pdvTQYjqq0zzv7YA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyStLgSVNcTJuNNCzYdHiHNA0p4D5LnGMw4wS4hU1votuNNTyC+
	Gt/R6Y0MsFDFPdgzlEMiKI644qimrM11RqN5phIgtlf22TL0IfA61vxO+8Jq90eB1HF2wN04l25
	UC/KlDbXKcimQhMpL3kh4FGQh7iI=
X-Gm-Gg: ASbGncuEdhirVUcy5IB2yxpR/GC5MibwqWtK05krIcBGMEAXqHt09j80mU1dYC2u4qw
	OGM//x9R01dnMRQgN6ElhG5meVxNbF2k=
X-Google-Smtp-Source: AGHT+IEp4LGe8Jhoz6WxQPMbuJhE535YCZ6w2Zl2WTC4nwajljsdfywsoqbi1sL2VcenG3a8LwPpst2MdXdXdH1gHfA=
X-Received: by 2002:a05:690c:a8b:b0:6ea:e967:81da with SMTP id
 00721157ae682-6ef3720d0a7mr13749717b3.11.1732670914542; Tue, 26 Nov 2024
 17:28:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
 <TYZPR02MB78424F31FF023102693D2DB2A65A2@TYZPR02MB7842.apcprd02.prod.outlook.com>
 <15077D4C-8DE9-4751-9492-51D972B3E4C3@suse.de> <CAAsfc_r_6mZ2HesDOQWU-0F2KXhz=EJ_nHeR4bLanXNnAiduTg@mail.gmail.com>
 <D5D1CBD5-0031-4285-BE12-910D6898B465@suse.de> <CAAsfc_oTmE2E8pMctiLSwMngVUbtJa4G=KAozzAfztMMc_RMOQ@mail.gmail.com>
 <0CFF2B9E-4E40-480D-9F3B-F7631FE3CEA5@suse.de> <A86AAB66-C89A-4A37-8416-F9A99D4630D8@suse.de>
In-Reply-To: <A86AAB66-C89A-4A37-8416-F9A99D4630D8@suse.de>
From: liequan che <liequanche@gmail.com>
Date: Wed, 27 Nov 2024 09:28:23 +0800
Message-ID: <CAAsfc_pK8JYE4Abaxj5ea-D2R2hCWWE2Cupq3u0hNDv_eXwc6g@mail.gmail.com>
Subject: [PATCH V2] bcache:fix oops in cache_set_flush
To: Coly Li <colyli@suse.de>
Cc: "mingzhe.zou@easystack.cn" <mingzhe.zou@easystack.cn>, Kent Overstreet <kent.overstreet@gmail.com>, 
	linux-bcache <linux-bcache@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Caused by the following commit, partially revert it.

Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations") replaced IS_ERR_OR_NULL by IS_ERR. This leads to a
NULL pointer dereference.

crash> bt
PID: 7773     TASK: ffff49cc44d69340  CPU: 57   COMMAND: "kworker/57:2"
 #0 [ffff800046373800] machine_kexec at ffffbe5039eb54a8
 #1 [ffff8000463739b0] __crash_kexec at ffffbe503a052824
 #2 [ffff8000463739e0] crash_kexec at ffffbe503a0529cc
 #3 [ffff800046373a60] die at ffffbe5039e9445c
 #4 [ffff800046373ac0] die_kernel_fault at ffffbe5039ec698c
 #5 [ffff800046373af0] __do_kernel_fault at ffffbe5039ec6a38
 #6 [ffff800046373b20] do_page_fault at ffffbe503ac76ba4
 #7 [ffff800046373b70] do_translation_fault at ffffbe503ac76ebc
 #8 [ffff800046373b90] do_mem_abort at ffffbe5039ec68ac
 #9 [ffff800046373bc0] el1_abort at ffffbe503ac669bc
crash> dis cache_set_flush+0x94
0xffffbe50121fa4c8 <cache_set_flush+148>:       str     x23, [x20, #512]

If the bcache cache disk contains damaged data,when the bcache cache
disk partition is directly operated,the system-udevd service is
triggered to call the bcache-register program to register the
bcache device, resulting in kernel oops.

This patch replaces IS_ERR() by IS_ERR_OR_NULL() to fix this.

Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations")
Link: https://lore.kernel.org/all/3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de/
Cc: stable@vger.kernel.org
Cc: Zheng Wang <zyytlz.wz@163.com>
Cc: Coly Li <colyli@suse.de>
Signed-off-by: Markus Weippert <markus@gekmihesg.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1f829e74db0a..e2a803683105 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1723,7 +1723,7 @@ static void cache_set_flush(struct closure *cl)
        if (!IS_ERR_OR_NULL(c->gc_thread))
                kthread_stop(c->gc_thread);

-       if (!IS_ERR_OR_NULL(c->root))
+       if (!IS_ERR(c->root))
                list_add(&c->root->list, &c->btree_cache);

        /*
--

Signed-off-by: cheliequan <cheliequan@inspur.com>
---
 drivers/md/bcache/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fd97730479d8..c72f5576e4da 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1741,8 +1741,10 @@ static void cache_set_flush(struct closure *cl)
        if (!IS_ERR_OR_NULL(c->gc_thread))
                kthread_stop(c->gc_thread);

-       if (!IS_ERR(c->root))
-               list_add(&c->root->list, &c->btree_cache);
+       if (!IS_ERR_OR_NULL(c->root)) {
+               if (!list_empty(&c->root->list))
+                       list_add(&c->root->list, &c->btree_cache);
+       }

        /*
         * Avoid flushing cached nodes if cache set is retiring
-- 
2.33.0

