Return-Path: <linux-bcache+bounces-806-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E949DA0FE
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Nov 2024 04:01:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA46728787A
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Nov 2024 03:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B054D8AD;
	Wed, 27 Nov 2024 03:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7JHYwid"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BAD1BC20;
	Wed, 27 Nov 2024 03:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732676478; cv=none; b=kjH4sgg97StRCRu4tWxQkYSO40AWpROGqoJjMnu0a105Xmh81SOHWe30ti17jaC1PP1PbuoPlabU3MMXysMJn1H0ENMTHAoOEUC1Btx/KVMW0fVqK2oJsXv8ZkFksFsgvo95llBFT5+aDHI5PKpgKdb+YLgAT7ASMNgWXaMouH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732676478; c=relaxed/simple;
	bh=DOKRuxgBLue+ZbICpyQC+3DcCIGYIsRHCRxXGkBk2pE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f46ORxhAMM9MiFtnqR13iTCEFeSez4MuFBKouLEiGczACiX2AjCj6gJBdbJDIIC23EBzvN6uik9L7A4HK5hBGo70R6rsQaYrbH1w0YB4+F8EHiQeMYsDaSof8+Tv2UEY2cVCFaONMHOg3oZ3EKkLQzD1qPA0gmZGXxkXbjwYIs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C7JHYwid; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-71d579d9658so1073980a34.2;
        Tue, 26 Nov 2024 19:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732676475; x=1733281275; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=adWyH2oXhlVceO0QW5A79Ic2lCOWRYJxOdz0O2Z1b0A=;
        b=C7JHYwidqGF0HlXRenIBHfKXY+0rphUsMnUAxvRQPzm/vycQy0AnaxI8CN36NBl4Fz
         Af3ZkKLpamU0cpofRLkeY2gjf98RYD0uMK0st53gFO2/nkv0LnBwNYc7JYF6XQvWiEDt
         /iVmRjX8vhU0lzMt7oufY1++mIt1GbFsopl/i4umQeAIM1NDs1jv+Ovcp7XwQZSIqbg/
         JaQBJUwAs8gS5GZT0U8JvRdtgBHbQGbLjis32lrOm0ZHpff3COklrusMenGaWWNWdSjf
         o+sBZNtXXkezOs5YK3iVCculhxkHVre7tB6ZCiSyc4imRod2cWjpcn0peuvoyL3u4k+n
         bmkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732676475; x=1733281275;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=adWyH2oXhlVceO0QW5A79Ic2lCOWRYJxOdz0O2Z1b0A=;
        b=vJDBv3x4iH5Abm4Kz+UhhVJCImlVelniupSk9fqMdPgo5sIEv2RivKPhabRcKFlL79
         MECiV9jGJ5EbOjpDJtAMZs/p0OZmA7edNYjZguKMG83h2FxIqWO77RkS7B/te9np53WA
         X5QsiR8/3IwFYGXj0/BXUAUpvf060bBFgqyIw58c4VmNaYQnLnfwtXfVQuY/3I5U+a8N
         iepX5SJE/vdvgRZ0C+JvUwUcaqWOorYKqAMO8Mrn0RWrPj6z01th3g/6dpsYogmZmqOT
         BoV54+RVvD0o5fWu7CyXKnygg3M7wL72v6aIgU/BWHjKbT2YirEKDEQpY8RtHnSuJcMZ
         RXZQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0S+EE6d85Z4Rc3XIuSo6/4VBHsFj9D/+0sEaVKaza4noFmVMaO1Nmw65Oo6lFC3eqf/s/ZOsSg7ngWYnz@vger.kernel.org, AJvYcCVgKm6NCWtZABiHsrx3/c+sL9PtqveMSX7hBZhuq2cQAboud40Nir6AgQbwZ172/lDf6h4fyRI3gspqLVo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4WGg2xNM972buHNCF+yCl8aKBkoLqjjsi5KOQMTC1XtON6hS2
	2taJzYmVyPyKJsutqKuWN4Xam4Dnq2KzCxx+2EQeb39KwzsMSaSKylCe5ujAKct+lN2eExxELKJ
	buKdfbW6DR3VZUSlED7R4wyr0OyjtQX3fV7w=
X-Gm-Gg: ASbGncsVM8qIjzuuTsfr3vXfaOEKctl9SJ0/cpJ8jX9oHDEnYGo4D0p6MzYD8+kznlk
	JYd0n/6xNFyK88HTYQSA++jyiW410veY=
X-Google-Smtp-Source: AGHT+IHZ2KaOteDIRk3r8DiXaNyZlQz2iVm7XGR6nAu3bn9fcNkvaYrIS6M2Oa0C5wQDez1zNZ6Wti9UMBRg7vcU9Pc=
X-Received: by 2002:a05:6830:6f04:b0:718:10eb:1eab with SMTP id
 46e09a7af769-71d65c93c08mr1447012a34.11.1732676475429; Tue, 26 Nov 2024
 19:01:15 -0800 (PST)
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
Date: Wed, 27 Nov 2024 11:01:04 +0800
Message-ID: <CAAsfc_pxrz1bcfo=29-qPuZhEEffbK5=LYGeNRV9gf=vfyp8Aw@mail.gmail.com>
Subject: [PATCH V3] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again
To: Coly Li <colyli@suse.de>
Cc: "mingzhe.zou@easystack.cn" <mingzhe.zou@easystack.cn>, Kent Overstreet <kent.overstreet@gmail.com>, 
	linux-bcache <linux-bcache@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations") leads a NULL pointer deference in cache_set_flush().

1721         if (!IS_ERR_OR_NULL(c->root))
1722                 list_add(&c->root->list, &c->btree_cache);

From the above code in cache_set_flush(), if previous registration code
fails before allocating c->root, it is possible c->root is NULL as what
it is initialized. Also __bch_btree_node_alloc() never returns NULL but
c->root is possible to be NULL at above line 1721.

This patch replaces IS_ERR() by IS_ERR_OR_NULL() to fix this.

Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations")
Signed-off-by: Liequan Che <cheliequan@inspur.com>
Cc: stable@vger.kernel.org
Cc: Zheng Wang <zyytlz.wz@163.com>
Cc: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e7abfdd77c3b..e42f1400cea9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1718,7 +1718,7 @@ static CLOSURE_CALLBACK(cache_set_flush)
        if (!IS_ERR_OR_NULL(c->gc_thread))
                kthread_stop(c->gc_thread);

-       if (!IS_ERR(c->root))
+       if (!IS_ERR_OR_NULL(c->root))
                list_add(&c->root->list, &c->btree_cache);

        /*
--
2.46.0

