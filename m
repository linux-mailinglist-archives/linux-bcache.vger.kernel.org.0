Return-Path: <linux-bcache+bounces-62-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6927FA5D2
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Nov 2023 17:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9986EB21241
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Nov 2023 16:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B832358BA;
	Mon, 27 Nov 2023 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fS/4jveW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7456CBF
	for <linux-bcache@vger.kernel.org>; Mon, 27 Nov 2023 08:12:31 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7b38ff8a517so15966839f.1
        for <linux-bcache@vger.kernel.org>; Mon, 27 Nov 2023 08:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701101550; x=1701706350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvB7rbddcLGLArA7MqLyKH3GIdpZuBsbhH9RHUl0sM8=;
        b=fS/4jveW7ONuSpqHQD2CZCgNBuOihUISIi92yOFVBkfQWg4XyLhqEUGEOmtLVDiDkg
         PhRkXqOMAsJHkGqOz9F7S0J7Y9naw24pww2KOSEY3XoMGcmd6CKfoYrP7OmglHxTfLUP
         kgeE9W4um/AorvcBTB34RZLpEqLSSSiiYJzVcEjymxZHW2zTn1V/cgm1QhaFxjoxXyeG
         1+h8zUrcgx/3PlFBER3ONH+tu6kBdE8SZDZnV1C8TLQogXmV7rNI2YyePXKOrFHor7HV
         fcfPVcZpQB0nf8U36QjnyHlZP0ecaDggyGnbSZE6hyCYpBnem7TpK9UrIGPmCyauhtn+
         ckxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701101550; x=1701706350;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bvB7rbddcLGLArA7MqLyKH3GIdpZuBsbhH9RHUl0sM8=;
        b=NyEc8hMYV+Z9AZbHhX9POwjaKv9JHw2UjwY6kMDY6+lZ54gag2QRUwwZhTbH+Q4zuU
         /LC1U+pAssp6ErGGbYQImEMvHUzvtX1s6J3hf2xBfzie3DpalX6lbZ1adtH4+6Jc5Mli
         ufOIAarWL69j+cygfvJgl0OlZlM1YtGHak33YDmlmcc6gEceFjHdpLMCFgt1u9H0G6TI
         KrZpTqr27BNOyn9+k9uHCgARRPyAaoO6oF966Q1k82gIUj1ZPAfAktzsRhuzTRb+Vz/D
         93LHpNircV+PevhQpEd2pQKMBAg8wnmbZoUg6U7HTRxpgNjSwx+jV8VVgutRJZV6+7oJ
         uH8w==
X-Gm-Message-State: AOJu0YxkCse/ZrwsJ4WaQsq4rp0eBTMCyxgllXFjch6P6FV1bfG+jBqH
	NYkFZZrEBDnRUUAMhaVsx3RlxwOJLPhDE+OzH3lVzw==
X-Google-Smtp-Source: AGHT+IG04eTzzicBywjmAxWaoEJU61uSxMw471TKINu23Lw+T9NqHOZNLbrFo4J4Xa2OGDDQItWp0g==
X-Received: by 2002:a92:503:0:b0:35c:acbd:3d3e with SMTP id q3-20020a920503000000b0035cacbd3d3emr5168491ile.3.1701101550317;
        Mon, 27 Nov 2023 08:12:30 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r15-20020a92c5af000000b0035ca20fc741sm1338589ilt.70.2023.11.27.08.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 08:12:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Bcache Linux <linux-bcache@vger.kernel.org>, 
 Markus Weippert <markus@gekmihesg.de>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, 
 Zheng Wang <zyytlz.wz@163.com>, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Stefan_F=C3=B6rster?= <cite@incertum.net>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
 Linux kernel regressions list <regressions@lists.linux.dev>, 
 Coly Li <colyli@suse.de>
In-Reply-To: <c47d3540ece151a2fb30e1c7b5881cb8922db915.camel@gekmihesg.de>
References: <ZV9ZSyDLNDlzutgQ@pharmakeia.incertum.net>
 <be371028-efeb-44af-90ea-5c307f27d4c6@leemhuis.info>
 <71576a9ff7398bfa4b8c0a1a1a2523383b056168.camel@gekmihesg.de>
 <989C39B9-A05D-4E4F-A842-A4943A29FFD6@suse.de>
 <1c2a1f362d667d36d83a5ba43218bad199855b11.camel@gekmihesg.de>
 <3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de>
 <c47d3540ece151a2fb30e1c7b5881cb8922db915.camel@gekmihesg.de>
Subject: Re: [PATCH] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR
Message-Id: <170110154924.44993.12405607589120929041.b4-ty@kernel.dk>
Date: Mon, 27 Nov 2023 09:12:29 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-26615


On Fri, 24 Nov 2023 16:14:37 +0100, Markus Weippert wrote:
> Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
> node allocations") replaced IS_ERR_OR_NULL by IS_ERR. This leads to a
> NULL pointer dereference.
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000080
> Call Trace:
>  ? __die_body.cold+0x1a/0x1f
>  ? page_fault_oops+0xd2/0x2b0
>  ? exc_page_fault+0x70/0x170
>  ? asm_exc_page_fault+0x22/0x30
>  ? btree_node_free+0xf/0x160 [bcache]
>  ? up_write+0x32/0x60
>  btree_gc_coalesce+0x2aa/0x890 [bcache]
>  ? bch_extent_bad+0x70/0x170 [bcache]
>  btree_gc_recurse+0x130/0x390 [bcache]
>  ? btree_gc_mark_node+0x72/0x230 [bcache]
>  bch_btree_gc+0x5da/0x600 [bcache]
>  ? cpuusage_read+0x10/0x10
>  ? bch_btree_gc+0x600/0x600 [bcache]
>  bch_gc_thread+0x135/0x180 [bcache]
> 
> [...]

Applied, thanks!

[1/1] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR
      (no commit info)

Best regards,
-- 
Jens Axboe




