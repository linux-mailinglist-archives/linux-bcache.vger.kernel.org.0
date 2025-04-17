Return-Path: <linux-bcache+bounces-894-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3578CA9129F
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 07:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E90B17AC825
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 05:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4181DE3AC;
	Thu, 17 Apr 2025 05:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tKVdj+hU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD601DC184
	for <linux-bcache@vger.kernel.org>; Thu, 17 Apr 2025 05:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744867570; cv=none; b=myKCUJAhlBAQmV4pxnWRXtPYKwB7dcKjTKLiFjRNteVO077gOBkOkRB32K7L3ibsRPc5EMZcYBw+3u6+P+qzqAmIsfhcdAszThQPHcyqhr1+VVhfMFIFp4lXcDBFl762GPRhaL7Go7YIVxkPq1rdEYlp+LAbWmub0OY9UxCFIps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744867570; c=relaxed/simple;
	bh=AQOCEJKVTkks48MTYTMB9EALRfHGcvzhyei6MUta3aY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KsG3qf++cN7sqikCMr3Vsqt2QJ8Gj2NiD9fl4BmKXVe1l1FPCwAfohq9Pl/TzHSUQ7Z4PJRKjqRzHWfch0GSn+ox/HznC7IxszUVYcAwu5g4hZGuKM5ULcauFq9D+9iMT1KDg3IGROUiZWFZPaNyve1jhdwPkmQrKTrn4ZW401c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tKVdj+hU; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-227a8cdd272so4472385ad.2
        for <linux-bcache@vger.kernel.org>; Wed, 16 Apr 2025 22:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744867568; x=1745472368; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7xSZh6+8f08OdZfXEKAi/81J0Uyvt096olH15yzbCvI=;
        b=tKVdj+hUVqjLwd7G1ScS1SZQAFrtTlvxSJ4+pCYtbYo7Q0P3zS9osBEtEgng/FYGFj
         6P92piP5pCJUCc8bUKzTuqxR+6R+wN+9fR0859Vu7p5MR58HMzFXycpTkFWh1gHLA58d
         dp8fkWa5jFQPaQ1bRQEaTw3wy9OgbeuhQotXxwDAnnJ/KX0wMcYnYOAoxYBGwI69KKRC
         tl05uwVVEFOSwYc6WCBKEeW9KvBIyuBxKkjccQgVkrYtLLsYdh44qDSrN5v8QsHIemWg
         djuSH0NoOgRQ+uMHdt1eUTGbDmP3SMKokn2MYd9uqkjXFbRNVazr1wjDpzHXMMQkQEr7
         Bhxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744867568; x=1745472368;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7xSZh6+8f08OdZfXEKAi/81J0Uyvt096olH15yzbCvI=;
        b=SQwYzS4m3BFEhGIB4GUvERst6qHVVv42slaqcXxziVxCbFrJxS44JpA1z8esvYKnx3
         IlolWslZJJQipXpXYikLkFzFgoD5WbgXYnjtwbQritAY80mWG+7bFnJsJJ8oB0p8aK74
         qD4Uk7VdaUjkzghGe5NPszOEalgAbGQOQIkNDwHtLsXSPx8697G17G/+VawKRGGaXC7F
         Vg+t7suHq3azNYK3nqhSA8XGhmtYSrZ+aiwmFKxHCHmwAYeyT4eis6sBbt0eg4aA9VVE
         LD7LZxGL+iOaU9wmvvmneEMgNz7t0GM8qgK2fAKBcTCj73ipLuoinLOmQRvcdLOXPo0T
         EKpA==
X-Forwarded-Encrypted: i=1; AJvYcCU9gZPYeDfkTKAKQHEOO5/rScMPzi4TLmt2zD8+3y5LoLq5gqIc1qIngZJb7m+/DlltAxoaXUFurVowwrs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRM3NDoKx//5ILaRLj+dVnsbT1rl0AigRtThxA4W81CeDox3vM
	MD6SmnGwEWx0ab8Vuon9Y0oOe2jXORke/Qd+joURoc9SNVja/pJ8N6Yc7qQrYNBRHHpH2F/D0/u
	PXvdND8jrHRmZhTWAhA==
X-Google-Smtp-Source: AGHT+IG4oulQd9Jnf51OrBMckEEUWMBN3/gsmjCG3X9hj3FdEaXigjPRn3sDeeBGy1m4Ou6Wk4zT5sPfWmK4KK0g
X-Received: from ploz20.prod.google.com ([2002:a17:902:8f94:b0:223:536f:9461])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:19e3:b0:220:ca08:8986 with SMTP id d9443c01a7336-22c358db700mr76629755ad.22.1744867568544;
 Wed, 16 Apr 2025 22:26:08 -0700 (PDT)
Date: Wed, 16 Apr 2025 22:25:34 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250417052553.1015905-1-robertpang@google.com>
Subject: [PATCH v3 0/1] bcache: reduce front IO latency during GC
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

---

Changes in v3:
- Use 64-bit integer division macros to fix build error on i386 architecture.

Robert Pang (1):
  bcache: process fewer btree nodes in incremental GC cycles

 drivers/md/bcache/btree.c | 37 ++++++++++++++++++-------------------
 drivers/md/bcache/util.h  |  7 +++++++
 2 files changed, 25 insertions(+), 19 deletions(-)

-- 
2.49.0.777.g153de2bbd5-goog


