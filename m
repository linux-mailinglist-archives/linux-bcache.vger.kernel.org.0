Return-Path: <linux-bcache+bounces-781-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB329C693A
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2024 07:25:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74F37286611
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2024 06:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888711779B8;
	Wed, 13 Nov 2024 06:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsy5Rg8z"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA51BA34;
	Wed, 13 Nov 2024 06:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731479153; cv=none; b=PJlN28QqWJJWpcqddDhSfo5TLmO2pNvmnV6LMKxvqjUFMgeH6gM0GWCS9R4z9HQE7qK+96V98OOtV2BQ1DpWOQciy+HE8fnFbuKmHF5yqFGPTjKPcsFTZjgxkVIQQY+ZNUclmSsv71WiIsugYLwalsSf6r4FaGGRB/JruZtPuE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731479153; c=relaxed/simple;
	bh=wvNnTtJd+T9Y3rRJ7wLih/lVADKpH5O1HPwxEPFpXmM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=crhzkxL7a3m65Por1BurstYbXRAAi0tzMAz8Wnqjdx7jlIeUh380rlPP5TarxAt3gxZ14pmRpolZJ2U3pfEMfQiLI79aMI/Hsq3330wozgtqqVVX4dqaSEJhTpz2dwrkWcfcGFYMjxmGXTTczeEeYcs/JXgd7e0jXHzSg8PIL3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dsy5Rg8z; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7b14443a71eso496803285a.1;
        Tue, 12 Nov 2024 22:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731479151; x=1732083951; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=udmJLU+VUrTJ8lMtQy3DVP6BCAyAnqzBp8QUEwZB7M8=;
        b=dsy5Rg8zHAAu+ThNU8B6L0K9+kuaiGhcGlNHrxhmcHXShFiu9uyQFiSdgqAzW9H8ss
         e2Fd2dKelpg0rErEICuJJVLT7zwvxJkASOcZhvRNvzy5Kr+JFeeILYrNtEY8KWRvDHHn
         nlFZlrFjEQYMtudmd1w06yzeARv1fsAbNQ+2RtHt02KY6+td4OnJk7QxVJ8oj1nSr4Ve
         qQ1ZcraagDpnaN5nk4NrFqlOHOjnDpCVLcw5pa8cI0483nypugmfYyeCUdtae/h6SOnx
         rDEfrJ0jOGR07rTZH/fhvJU4JtDPHMWXR64I3mk4SVODpu+cuIKuRcSOryV/T9PxXvgx
         3m0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731479151; x=1732083951;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=udmJLU+VUrTJ8lMtQy3DVP6BCAyAnqzBp8QUEwZB7M8=;
        b=YdwEQlpLD/ByxCeByaP2CP88FobJ4LNn6HluJ+60jVbEVj17OxUSdmkFtdQzLkPSKH
         lrcnt6ME/3Y9LkNSi8McLztWdcierIteF91ieg12u88pBJfIdXxYtdK2cGsZwWhOp+jp
         snncv5jHvyGxR338k2k95soNztMSq6fOmNjDYvhZGycJjOR8UaU/yf2+/hN7KVrsOXIp
         qpF85x1laD0UQ82RQU+h7apQv1EJ38zgaMZB47B/acBfjI3La5kT5GN3rZ3X9isXiodW
         +Q1qT0Tcmdc6lRsDzvIWzoiNJV/Xilav0n6rxOBLde0KeBFZJrqEMKX5leNCyUJeU8F3
         Vr/g==
X-Forwarded-Encrypted: i=1; AJvYcCVgi9vpQXD+txdc3PHlRMyYWfgiEIBSej4vKvP9wdLSg2jFV9ZTUApr646jgRBjFnWC7L7lHxNyIdoaiGo=@vger.kernel.org, AJvYcCWMrPHBGRL8d7gNDQjSir9CvW8GarLex9yySpTISU7lZWPgUVNX17GKlol3yYxI4/FLKdo3byfA4715xIoV@vger.kernel.org
X-Gm-Message-State: AOJu0YwuYvdC8V1p0mZgjWq57ct9FUJu5PTDu6lrWgos78mykKkFXTWz
	/kEaIePnYpmYW7M4csxnf4WpztlrRkjzh6X1HAyYk1xjC5afun/NNEDngny1n8+qnBIqq3rcwo9
	J+20Frz5AFhPMdnftvj3eE5LDdePklhN5WW4=
X-Google-Smtp-Source: AGHT+IFivH+ROQfDfZ309x/SixFBN810qCeMwjBx+u0/Gsx0ULHyvCb65UHoH+Y4Ne7pPOhZLKClbUVeg0GA2cF0S84=
X-Received: by 2002:a05:6214:3bc3:b0:6d3:80a9:fcad with SMTP id
 6a1803df08f44-6d39e114e77mr262036646d6.19.1731479150809; Tue, 12 Nov 2024
 22:25:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: liequan che <liequanche@gmail.com>
Date: Wed, 13 Nov 2024 14:25:38 +0800
Message-ID: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
Subject: bcache: fix oops bug in cache_set_flush
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, 
	linux-bcache <linux-bcache@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: cheliequan <cheliequan@inspur.com>

   If the bcache cache disk contains damaged btree data,
when the bcache cache disk partition is directly operated,
the system-udevd service is triggered to call the bcache-register
program to register the bcache device,resulting in kernel oops.

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
#10 [ffff800046373bf0] el1_sync_handler at ffffbe503ac671d4
#11 [ffff800046373d30] el1_sync at ffffbe5039e82230
#12 [ffff800046373d50] cache_set_flush at ffffbe50121fa4c4 [bcache]
#13 [ffff800046373da0] process_one_work at ffffbe5039f5af68
#14 [ffff800046373e00] worker_thread at ffffbe5039f5b3c4
#15 [ffff800046373e50] kthread at ffffbe5039f634b8
crash> dis cache_set_flush+0x94
0xffffbe50121fa4c8 <cache_set_flush+148>:       str     x23, [x20, #512]

---
drivers/md/bcache/super.c | 16 ++++++++++------
1 file changed, 10 insertions(+), 6 deletions(-)
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fd97730479d8..8a41dfcf9fb6 100644
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
@@ -1750,10 +1752,12 @@ static void cache_set_flush(struct closure *cl)
        */
       if (!test_bit(CACHE_SET_IO_DISABLE, &c->flags))
               list_for_each_entry(b, &c->btree_cache, list) {
-                       mutex_lock(&b->write_lock);
-                       if (btree_node_dirty(b))
-                               __bch_btree_node_write(b, NULL);
-                       mutex_unlock(&b->write_lock);
+                       if (!IS_ERR_OR_NULL(b)) {
+                               mutex_lock(&b->write_lock);
+                               if (btree_node_dirty(b))
+                                       __bch_btree_node_write(b, NULL);
+                               mutex_unlock(&b->write_lock);
+                       }
               }

       if (ca->alloc_thread)
--
2.33.0

