Return-Path: <linux-bcache+bounces-875-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66611A88F34
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 00:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4BB8189BADE
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 22:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647C41F3BAB;
	Mon, 14 Apr 2025 22:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eYkNt03V"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5F2156236
	for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 22:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744670698; cv=none; b=TGvkqy7v5EI7+9J3Y9RUmdptRFx82ftRxcHQ2IX+m9y3MO4THSIfGz/mlgQGzWMbATwJzPEHnI2Q49uYn2Hk2HONhtI/uRG+xeCrHTIaDymqNfZN3ppWs5NlOo1spQ0hp8rNFgTzy0R9U7j0WU03gHLt1LwNmQaAZynqAvC9K4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744670698; c=relaxed/simple;
	bh=lE/OtyDr2pyIvtQn0GthYgwpP7jE50CqNc4fvaNp7xg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EKZL+9f/zpm2MbShkVD0Pm/W+W3vrY8qh7Q853MQZ8GwzuZRgrz8U96rT3v23P1XvEouexiE/tD9ipoh4IpchVJ4xfiZt89heOsYzwU46OhwCDY6lpStKOiXth6R3F9Ke88CH/AYpHjwkdHpW6roddeotAnXDoxXiFEG49vJSus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eYkNt03V; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-72c0d69b71aso2119442a34.3
        for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 15:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744670696; x=1745275496; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZSPNvkRMaTjkK8VmorMWLpZNxwbiAB1pZpi+rkkQFjA=;
        b=eYkNt03VeZTlb6c9oyd18dZKWhaRtYxiGWmlwl2n4D0W2TOAz6KBeLubItBsoxndQi
         kZJHoYUMMeHrGg70RGOaz5fUQWLdbAlGOl4FlEyYs3v2FHa2CwtDXWlccTd9bYxFJcuH
         n9LJPwxvENlv4ImyvWKBkSJxv4tcHzwqXyZ1HNQh7T/vunylA4YwHSkNe5TkT8dEvUjs
         2+wSxiPeprzguvET4llHWEu0bHLWNuRzlCVGrintviIN+PJSNoo/butGndPaF6ItYL9n
         pdWxoK2StrosXuCPmBbNGLIVS/y2JhQNku9eFs6JXyKwkdzQqrn7qBivPttHzubDEuFe
         zTCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744670696; x=1745275496;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZSPNvkRMaTjkK8VmorMWLpZNxwbiAB1pZpi+rkkQFjA=;
        b=dJpqPRaX02Hw6T8/kme5xkT0/Y6dBUAGACtmV9MKrhTnlv1gxXWrEObERY2KaByNwt
         +OPVnrE49vQrz6GgSvgUv4dt7pgiHer66pYkiZTK0osnP4AmXbHuc5V9rCrGcXgwQE00
         XkS8ZxG3NOjfrrSYjSk34A6ReB7WrtIjfWrgBDlYGzt94g1yCT42g0y1SNCJLc/oPp3o
         vSJ71r8mY09prmUmW172/Y9PhzyD+iGCZB1ty1Qm33GyHdJKIEbVEncVRKuKQGrEsWWH
         atg/Ft5vcW9BxYABH/7zKsbP9TEYUc87DkBHvRkI+WQt+RNoY+8YAj06jcAK5PmXOxcc
         dCRA==
X-Forwarded-Encrypted: i=1; AJvYcCUMTA4ZW/5WMl/rpEQR2cYCZLQzP4mMGL/aCTTKLad9hu6d1sv2UA+NDxOdSmf9MZ+fRTgwDBlG+zMTwlg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdYS7pkp2GHcnOyYhTYuiboIZto24mTgn83XJY3S0ID7Facvg/
	FrJbpOfESIk2TpZrCs7W+6smhv30yN3VObPVI35HlmPggW3bmWc4dtPEMNJ2B5O3WWEbG1sT8AO
	Mek249cXX1umz6+zHGA==
X-Google-Smtp-Source: AGHT+IGGzXAD+QCkPCx0xlpnE0ggLVr8BpKSaekPhn8pKBo7TmAJJGh1knsKeNZ9fKW/BO5PnDSlDL/qR1O6iScA
X-Received: from oacpc18.prod.google.com ([2002:a05:6871:7a12:b0:2c1:56ea:2a0d])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:7a05:b0:29e:684d:2739 with SMTP id 586e51a60fabf-2d0d5fb3fb3mr9148220fac.32.1744670695754;
 Mon, 14 Apr 2025 15:44:55 -0700 (PDT)
Date: Mon, 14 Apr 2025 15:44:03 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250414224415.77926-1-robertpang@google.com>
Subject: [PATCH 0/1] bcache: reduce front IO latency during GC
From: Robert Pang <robertpang@google.com>
To: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org
Cc: Robert Pang <robertpang@google.com>, Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"

In performance benchmarks on disks with bcache using the Linux 6.6 kernel, we
observe noticeable IO latency increase during btree garbage collection. The
increase ranges from high tens to hundreds of milliseconds, depending on the
size of the cache device. Further investigation reveals that it is the same
issue reported in [1], where the large number of nodes processed in each
incremental GC cycle causes the front IO latency.

Building upon the approach suggested in [1], this patch decomposes the
incremental GC process into more but smaller cycles. In contrast to [1], this
implementation adopts a simpler strategy by setting a lower limit of 10 nodes
per cycle to reduce front IO delay and introducing a fixed 10ms sleep per cycle
when front IO is in progress. Furthermore, when garbage collection statistics
are available, the number of nodes processed per cycle is dynamically rescaled
based on the average GC frequency to ensure GC completes well within the next
subsequent scheduled interval.

Testing with a 750GB NVMe cache and 256KB bucket size using the following fio
configuration demonstrates that our patch reduces front IO latency during GC
without significantly increasing GC duration.

ioengine=libaio
direct=1
bs=4k
size=900G
iodepth=10
readwrite=randwrite
log_avg_msec=10

Before:

time-ms,latency-ns,,,

12170, 285016, 1, 0, 0
12183, 296581, 1, 0, 0
12207, 6542725, 1, 0, 0
12242, 24483604, 1, 0, 0
12250, 1895628, 1, 0, 0
12260, 284854, 1, 0, 0
12270, 275513, 1, 0, 0

/sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:2880
/sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec:133
/sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:121
/sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:3456

After:

12690, 378494, 1, 0, 0
12700, 413934, 1, 0, 0
12710, 661217, 1, 0, 0
12727, 354510, 1, 0, 0
12730, 1100768, 1, 0, 0
12742, 382484, 1, 0, 0
12750, 532679, 1, 0, 0
12760, 572758, 1, 0, 0
12773, 283416, 1, 0, 0

/sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:3619
/sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec:58
/sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:23
/sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:3866

[1] https://lore.kernel.org/all/20220511073903.13568-1-mingzhe.zou@easystack.cn/

Robert Pang (1):
  bcache: process fewer btree nodes in incremental GC cycles

 drivers/md/bcache/btree.c | 38 +++++++++++++++++---------------------
 drivers/md/bcache/util.h  |  3 +++
 2 files changed, 20 insertions(+), 21 deletions(-)

-- 
2.49.0.604.gff1f9ca942-goog


