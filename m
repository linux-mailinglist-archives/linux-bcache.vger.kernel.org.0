Return-Path: <linux-bcache+bounces-1243-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 289E4C528AE
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Nov 2025 14:49:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 82F8F4EC9A2
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Nov 2025 13:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC85A3385AA;
	Wed, 12 Nov 2025 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHVihTd+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8584328B73
	for <linux-bcache@vger.kernel.org>; Wed, 12 Nov 2025 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762954841; cv=none; b=LvETK/FiArLKYXmbbxioFc/6dk8nzLiHk0ywTtyB5sPVYwQtBRUXZ1LcoiQiXZIr9XZy36pWRbStJwXTa0irYxZCkS3ccUSrF20SuLdMOZk3vypAz+fpjT8E8dbVREtSat7D8I2HAfS8UGMdsScVkBWgntspTlDXowfiv9fIHlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762954841; c=relaxed/simple;
	bh=NyN+dSLGV8B6zBYtyARfc4P2AJomJmbTeNTVGWNoCXY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DtzvvF2zSv/UuLphSml1x/r6ac4/k9/QtRdbosCLuG2QjRYnFQHoE4wRQeERXDp7/jNujHCxIDUIEpbajiM7bi1bPgn/aybsr7acT++Pz5AzyrUaLIy46P9BapEEzIQCIKnyMKPVzNAoPdqLEoT/AmTdhlVnk4hwaigaNa98DU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHVihTd+; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-88054872394so10484346d6.1
        for <linux-bcache@vger.kernel.org>; Wed, 12 Nov 2025 05:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762954836; x=1763559636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l37MlBCbPWNMvJKN4HZOkxA1Noq2P/ns16bTLmbaa5o=;
        b=aHVihTd+yNwTOqTu+wwzbz3nFPUJudcttNhc/+86KMwKaXHdqa4Rk1t81j5BQAI1+N
         WFLMtyao/Ci36npxEGGm2grHR05UAn0gHKal9Xulps8hk/RiODqmI1stm5HqL+sNICO/
         JFBb4YuqRSxfvPr+P/dso3zD0+GxmzZP8XJ3rGdA+ECaW+zK6M6gUuMqbwGX+WThnZt9
         t6KFgBi1frJGW1xvGpNQXyFCF/9Pqx3KOWp3RMK0n8J6ZWxXbTBXJwnkzkv7E+Bhgubg
         IrSeAs67iaguH/mFl2xza3s93WMGxU0HNamXkrwJ3b7enKoxKmX5cktEMy+DZtPXQYk+
         cLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762954836; x=1763559636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l37MlBCbPWNMvJKN4HZOkxA1Noq2P/ns16bTLmbaa5o=;
        b=KZD2cyxj3fC/jo0gQkuSGxU7aNjtIdUVPpnRM5FiW1vpgLyeZcqTT+LRAY618qaqi0
         cN7wKqykLGeNAWQJeaDIfclvf6BuZiZByZdq7HxjRuMNNEcgyYlGy7sg3kYFXmewwW7r
         7U966xt9JyWjK8pdGg4cdBCKe7Y75DULUurr9VDi+c2xV1TGWBT0WnnGXTBX5r1FoEYO
         XFFbfRZQJzXZgvLeLnIKRqyotduzaoCWbqnIT4OGrnz7Vn11CQvBI2v059SIMcVGKdEO
         tXWABVIHuOKwAcAbW5dVuKtMmV+7JUXdz/+hwURj46YL4NqOvJQZOPmkPuHVL8mZOuHW
         9QRg==
X-Forwarded-Encrypted: i=1; AJvYcCWC+mhr8idY0X1CIBGWedIw/np1qcIh4dTuKKib2lTI1UfV/yqyGV9n7VFXdbpPc5k7Fw9Wkz05uuDUAMs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv/hsReTBfeBE0yRELm+zVu9Dehg/qVqTALqUC0KJ9EarRmeMw
	7oVzqoLmMPJVkeOVyB0nPq1lfT94tLyO1OXVCGakd0bHCRSlT8iDJX42Xd7yBOA4ZbclOFy5PMX
	UhiEolovQ0PsPQPAFLtGuBOoNSiHzIoE=
X-Gm-Gg: ASbGncvVRVM3pcBEecLVYprtMudYBrHBDPVa73xLXa6fG2C74UsOCbmONFKB74VLac/
	CiJkNLfakV0biNTQwY5gkggfJOfYtifMGHdLnzq0ozD4C0uYmADoARlxC2SPNyAPJWq0K97Tz17
	52VtqA0dJyFuaaJWfzgMeDXClknXYpBj0V4GzE5dvLOAY7aznpXsTrXocZHDluuv5OM0DqWXhpC
	lzduJYgQiTmlsfJfpG4gaekgBnugPAJtI1d23ca3DGs5Sf+SplLIL/b6emO
X-Google-Smtp-Source: AGHT+IHI2OTWiVJk5I2ESXOnoKFkTovAN1oqwZ40HWjCFD/2Eaj6niG1IhKc5S1vFkxK7aSR8kXLpTm/x7jz6MkN5bg=
X-Received: by 2002:a05:6214:d4b:b0:87b:cdf4:80aa with SMTP id
 6a1803df08f44-88271a0d93cmr49164456d6.40.1762954836205; Wed, 12 Nov 2025
 05:40:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAsfc_ry+u771V_dTQMiXpaz2iGbQOPmZfhwnyF56pM+FjXdsw@mail.gmail.com>
 <4y5xucuqqqe4ppxu46nwsr6g34bu7ixc5xwwogdvkdpl3zhqi6@c6lj7rk5giem> <CAAsfc_pa=AwaaN6Fy2jU6nPwnGET0oZgWZtSc3LtQ9_oJ6supA@mail.gmail.com>
In-Reply-To: <CAAsfc_pa=AwaaN6Fy2jU6nPwnGET0oZgWZtSc3LtQ9_oJ6supA@mail.gmail.com>
From: liequan che <liequanche@gmail.com>
Date: Wed, 12 Nov 2025 21:40:24 +0800
X-Gm-Features: AWmQ_blCbmBFzbrcT0fpmUZlFF-uJ0KkPW8-G2c2bifFxMO9tmyT4jzme5vOm9E
Message-ID: <CAAsfc_rRK1rBVYFOzdioQSj5BL_t--Sbg6y5KhS+uiSeKz51xw@mail.gmail.com>
Subject: Re: [PATCH v1 bcache] bcache: fix UAF in cached_dev_free and safely
To: Coly Li <colyli@fnnas.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache <linux-bcache@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

What actually explodes is that dc->writeback_thread remains a stale
pointer after the thread has already exited and its task_struct slab
was freed. A later kthread_stop(dc->writeback_thread) tries to
get_task_struct() on a freed task, triggering:
refcount_t: addition on 0; use-after-free
So: the =E2=80=9Cstill-held ref=E2=80=9D in steady state is the kthread=E2=
=80=99s ref to dc;
the UAF is caused by calling kthread_stop() on a freed task_struct
(stale pointer), not by a ref still held on the task.

>>Could you please point out all the location where writeback_wq is stopped=
?
1=E3=80=81At the tail of the writeback thread (bch_writeback_thread()).
2=E3=80=81At the cached_dev_detach_finish.

>>Yes, if you mean explain how the panic comes in code logic, it will be
 helpful for me to understand the issue.
1=E3=80=81After the NVMe PCI device is removed and a cache error sets
CACHE_SET_IO_DISABLE, once that bit is set the writeback thread
bch_writeback_thread() exits by itself. At the tail it calls
flush_workqueue, destroy_workqueue, and cached_dev_put(dc). If that
was the last reference in dc->count, cached_dev_put() schedules the
dc->detach work (initialized in cached_dev_init() via
INIT_WORK(&dc->detach, cached_dev_detach_finish)). In
cached_dev_detach_finish() it flushes and destroys
dc->writeback_write_wq and the kthread exits; the
bch_writeback_thread=E2=80=99s task_struct is returned to the slab.
cached_dev_detach_finish() runs on a system workqueue and prints the
following log.

[ 2549.904353] bcache: cached_dev_detach_finish() Caching disabled for
sda[ 2549.919831] bcache: cache_set_free() Cache set
6d074d91-3542-4740-851c-07b193147698 unregistered

[ 5058.346366] bcache: bcache_device_free() bcache0 stopped

2=E3=80=81Meanwhile, once CACHE_SET_IO_DISABLE is set, it also triggers the=
 path
conditional_stop_bcache_device =E2=86=92 cached_dev_flush =E2=86=92 cached_=
dev_free =E2=86=92
kthread_stop(dc->writeback_thread).
bch_writeback_thread may therefore be kthread_stop()-ed again. System
logs are as follows.
[ 2524.769073] bcache: bch_count_io_errors() nvme0n1p1: IO error on
reading dirty data from cache, recovering. [ 2524.776523] bcache:
bch_count_io_errors() nvme0n1p1: IO error on writing btree. [
2524.780741] bcache: bch_count_backing_io_errors() sda: IO error on
backing device, unrecoverable [ 2524.780757] bcache:
bch_count_io_errors() nvme0n1p1: IO error on reading dirty data from
cache, recovering. [ 2524.789965] bcache: bch_btree_insert() error -5
[ 2524.798971] bcache: bch_cache_set_error() error on
6d074d91-3542-4740-851c-07b193147698: journal io error, disabling
caching [ 2524.799432] bcache: conditional_stop_bcache_device()
stop_when_cache_set_failed of bcache0 is "auto" and cache is dirty,
stop it to avoid potential data corruption.

3=E3=80=81The system logs when the NVMe device is inserted again are as fol=
lows.
[ 2535.428773] pcieport 0000:60:03.1: bridge window [io
0x1000-0x0fff] to [bus 61] add_size 1000
[ 2535.439180] pcieport 0000:60:03.1: BAR 13: no space for [io  size 0x1000=
]
[ 2535.447549] pcieport 0000:60:03.1: BAR 13: failed to assign [io  size 0x=
1000]
[ 2535.456302] pcieport 0000:60:03.1: BAR 13: no space for [io  size 0x1000=
]
[ 2535.464664] pcieport 0000:60:03.1: BAR 13: failed to assign [io  size 0x=
1000]
[ 2535.474702] pci 0000:e1:00.0: [1bd4:100e] type 00 class 0x010802
[ 2535.482241] pci 0000:e1:00.0: reg 0x10: [mem 0xc3600000-0xc360ffff 64bit=
]
[ 2535.490650] pci 0000:e1:00.0: reg 0x18: [mem 0xc3610000-0xc361ffff 64bit=
]
[ 2535.499081] pci 0000:e1:00.0: reg 0x30: [mem 0xc3620000-0xc362ffff pref]
[ 2535.509095] pcieport 0000:e0:03.1: bridge window [io
0x1000-0x0fff] to [bus e1] add_size 1000
[ 2535.519493] pcieport 0000:e0:03.2: bridge window [io
0x1000-0x0fff] to [bus e2] add_size 1000
[ 2535.529895] pcieport 0000:e0:03.3: bridge window [io
0x1000-0x0fff] to [bus e3-e4] add_size 1000
[ 2535.540590] pcieport 0000:e0:03.4: bridge window [io
0x1000-0x0fff] to [bus e5-e6] add_size 1000
[ 2535.551288] pcieport 0000:e0:03.1: BAR 13: no space for [io  size 0x1000=
]
[ 2535.559657] pcieport 0000:e0:03.1: BAR 13: failed to assign [io  size 0x=
1000]
[ 2535.568409] pcieport 0000:e0:03.2: BAR 13: no space for [io  size 0x1000=
]
[ 2535.576774] pcieport 0000:e0:03.2: BAR 13: failed to assign [io  size 0x=
1000]
[ 2535.585527] pcieport 0000:e0:03.3: BAR 13: no space for [io  size 0x1000=
]
[ 2535.593894] pcieport 0000:e0:03.3: BAR 13: failed to assign [io  size 0x=
1000]
[ 2535.602647] pcieport 0000:e0:03.4: BAR 13: no space for [io  size 0x1000=
]
[ 2535.611014] pcieport 0000:e0:03.4: BAR 13: failed to assign [io  size 0x=
1000]
[ 2535.619767] pcieport 0000:e0:03.4: BAR 13: no space for [io  size 0x1000=
]
[ 2535.628135] pcieport 0000:e0:03.4: BAR 13: failed to assign [io  size 0x=
1000]
[ 2535.636887] pcieport 0000:e0:03.3: BAR 13: no space for [io  size 0x1000=
]
[ 2535.645253] pcieport 0000:e0:03.3: BAR 13: failed to assign [io  size 0x=
1000]
[ 2535.653998] pcieport 0000:e0:03.2: BAR 13: no space for [io  size 0x1000=
]
[ 2535.662361] pcieport 0000:e0:03.2: BAR 13: failed to assign [io  size 0x=
1000]
[ 2535.671104] pcieport 0000:e0:03.1: BAR 13: no space for [io  size 0x1000=
]
[ 2535.679467] pcieport 0000:e0:03.1: BAR 13: failed to assign [io  size 0x=
1000]
[ 2535.688228] pci 0000:e1:00.0: BAR 0: assigned [mem
0xc3600000-0xc360ffff 64bit]
[ 2535.697202] pci 0000:e1:00.0: BAR 2: assigned [mem
0xc3610000-0xc361ffff 64bit]
[ 2535.706171] pci 0000:e1:00.0: BAR 6: assigned [mem
0xc3620000-0xc362ffff pref]
[ 2535.715258] nvme nvme4: pci function 0000:e1:00.0
[ 2535.722895] bcache: register_bcache() error : failed to open device
[ 2535.732519] nvme nvme4: Shutdown timeout set to 10 seconds
[ 2535.770043] nvme nvme4: 128/0/0 default/read/poll queues
[ 2535.979719]  nvme0n2: p1 p2 p3 p4 p5

4=E3=80=81I/O errors cause the bcache device to be automatically
unregistered/stopped. Logs are as follows.
[ 2544.976874] Buffer I/O error on dev bcache0, logical block
21613328, lost async page write
[ 2544.986888] Buffer I/O error on dev bcache0, logical block
21613329, lost async page write
[ 2544.996907] Buffer I/O error on dev bcache0, logical block
21613330, lost async page write
[ 2545.006919] Buffer I/O error on dev bcache0, logical block
21613331, lost async page write
[ 2545.016936] Buffer I/O error on dev bcache0, logical block
21613332, lost async page write
[ 2545.026952] Buffer I/O error on dev bcache0, logical block
21613333, lost async page write
[ 2549.904353] bcache: cached_dev_detach_finish() Caching disabled for sda
[ 2549.919831] bcache: cache_set_free() Cache set
6d074d91-3542-4740-851c-07b193147698 unregistered
......
[ 5058.346366] bcache: bcache_device_free() bcache0 stopped

5=E3=80=81udevadm trigger or a hotplug event causes the device to be
registered again. Logs are as follows.
[ 5154.442217] bcache: register_bdev() registered backing device sda
[ 5252.833600] bcache: bch_journal_replay() journal replay done,
141885 keys in 103 entries, seq 230580
[ 5253.605483] bcache: bch_cached_dev_attach() Caching sda as bcache0
on set 6d074d91-3542-4740-851c-07b193147698
[ 5253.617486] bcache: register_cache() registered cache device nvme0n2p1
[ 5253.617503] bcache: register_bcache() error : device already registered
[ 5253.684378] bcache: register_bcache() error : device already registered
[ 5253.831217] bcache: register_bcache() error : device already registered
[ 5253.858158] bcache: register_bcache() error : device already registered
[ 5253.895693] bcache: register_bcache() error : device already registered

6=E3=80=81A subsequent error leads to bch_cache_set_error, which again
triggers conditional_stop_bcache_device -> cached_dev_flush ->
cached_dev_free -> kthread_stop(dc->writeback_thread).
[18575.113816] bcache: bch_count_io_errors() nvme0n2p1: IO error on
writing data to cache.
[18575.113818] bcache: bch_count_io_errors() nvme0n2p1: IO error on
writing data to cache.
[18575.113854] bcache: bch_count_io_errors() nvme0n2p1: IO error on
writing data to cache.
[18575.113866] bcache: bch_count_io_errors() nvme0n2p1: IO error on
writing data to cache.
[18575.113878] bcache: bch_cache_set_error() error on
6d074d91-3542-4740-851c-07b193147698: nvme0n2p1: too many IO errors
writing data to cache, disabling caching
......
[18575.113882] bcache: bch_count_backing_io_errors() sda: IO error on
backing device, unrecoverable
[18575.113886] buffer_io_error: 866358 callbacks suppressed
[18575.113888] bcache: bch_count_backing_io_errors() sda: IO error on
backing device, unrecoverable
[18575.113891] Buffer I/O error on dev bcache0, logical block 93441,
lost async page write
......
[18575.128942] bcache: conditional_stop_bcache_device()
stop_when_cache_set_failed of bcache0 is "auto" and cache is dirty,
stop it to avoid potential data corruption.
[18575.527107] bcache: cached_dev_detach_finish() Caching disabled for sda
[18575.544080] bcache: cache_set_free() Cache set
6d074d91-3542-4740-851c-07b193147698 unregistered

7=E3=80=81After the NVMe is removed again and recovers, udevadm trigger or =
a
hotplug event causes the bcache device to be registered once more.
Logs are as follows.
[18590.750773] pcieport 0000:60:03.1: bridge window [io
0x1000-0x0fff] to [bus 61] add_size 1000
[18590.761282] pcieport 0000:60:03.1: BAR 13: no space for [io  size 0x1000=
]
[18590.769750] pcieport 0000:60:03.1: BAR 13: failed to assign [io  size 0x=
1000]
[18590.778610] pcieport 0000:60:03.1: BAR 13: no space for [io  size 0x1000=
]
[18590.787076] pcieport 0000:60:03.1: BAR 13: failed to assign [io  size 0x=
1000]
[18590.797686] pci 0000:e1:00.0: [1bd4:100e] type 00 class 0x010802
[18590.805757] pci 0000:e1:00.0: reg 0x10: [mem 0xc3600000-0xc360ffff 64bit=
]
[18590.814548] pci 0000:e1:00.0: reg 0x18: [mem 0xc3610000-0xc361ffff 64bit=
]
[18590.824315] pci 0000:e1:00.0: reg 0x30: [mem 0xc3620000-0xc362ffff pref]
[18590.836532] pcieport 0000:e0:03.1: bridge window [io
0x1000-0x0fff] to [bus e1] add_size 1000
[18590.847030] pcieport 0000:e0:03.2: bridge window [io
0x1000-0x0fff] to [bus e2] add_size 1000
[18590.857532] pcieport 0000:e0:03.3: bridge window [io
0x1000-0x0fff] to [bus e3-e4] add_size 1000
[18590.868332] pcieport 0000:e0:03.4: bridge window [io
0x1000-0x0fff] to [bus e5-e6] add_size 1000
[18590.879142] pcieport 0000:e0:03.1: BAR 13: no space for [io  size 0x1000=
]
[18590.887609] pcieport 0000:e0:03.1: BAR 13: failed to assign [io  size 0x=
1000]
[18590.896463] pcieport 0000:e0:03.2: BAR 13: no space for [io  size 0x1000=
]
[18590.904936] pcieport 0000:e0:03.2: BAR 13: failed to assign [io  size 0x=
1000]
[18590.913787] pcieport 0000:e0:03.3: BAR 13: no space for [io  size 0x1000=
]
[18590.922258] pcieport 0000:e0:03.3: BAR 13: failed to assign [io  size 0x=
1000]
[18590.931111] pcieport 0000:e0:03.4: BAR 13: no space for [io  size 0x1000=
]
[18590.939580] pcieport 0000:e0:03.4: BAR 13: failed to assign [io  size 0x=
1000]
[18590.948442] pcieport 0000:e0:03.4: BAR 13: no space for [io  size 0x1000=
]
[18590.956904] pcieport 0000:e0:03.4: BAR 13: failed to assign [io  size 0x=
1000]
[18590.965760] pcieport 0000:e0:03.3: BAR 13: no space for [io  size 0x1000=
]
[18590.974228] pcieport 0000:e0:03.3: BAR 13: failed to assign [io  size 0x=
1000]
[18590.983080] pcieport 0000:e0:03.2: BAR 13: no space for [io  size 0x1000=
]
[18590.991549] pcieport 0000:e0:03.2: BAR 13: failed to assign [io  size 0x=
1000]
[18591.000407] pcieport 0000:e0:03.1: BAR 13: no space for [io  size 0x1000=
]
[18591.008873] pcieport 0000:e0:03.1: BAR 13: failed to assign [io  size 0x=
1000]
[18591.017735] pci 0000:e1:00.0: BAR 0: assigned [mem
0xc3600000-0xc360ffff 64bit]
[18591.026985] pci 0000:e1:00.0: BAR 2: assigned [mem
0xc3610000-0xc361ffff 64bit]
[18591.036228] pci 0000:e1:00.0: BAR 6: assigned [mem
0xc3620000-0xc362ffff pref]
[18591.045454] nvme nvme0: pci function 0000:e1:00.0
[18591.053388] bcache: register_bcache() error : failed to open device
[18591.069906] nvme nvme0: Shutdown timeout set to 10 seconds
[18591.107868] nvme nvme0: 128/0/0 default/read/poll queues
[18591.362600]  nvme0n1: p1 p2 p3 p4 p5
[18592.783105] bcache: bch_journal_replay() journal replay done, 94423
keys in 213 entries, seq 343003
[18594.369398] bcache: bch_cached_dev_run() I/O disabled on cached dev sda
[18594.378111] bcache: bch_cached_dev_attach() Couldn't run cached device s=
da
[18594.386701] bcache: register_cache() registered cache device nvme0n1p1

8=E3=80=81Calling kthread_stop() on a freed object=E2=80=94an outdated
dc->writeback_thread pointer=E2=80=94leads to a kernel crash.
[18627.036854] ------------[ cut here ]------------
[18627.042889] refcount_t: addition on 0; use-after-free.
[18627.049532] WARNING: CPU: 83 PID: 238405 at lib/refcount.c:25
refcount_warn_saturate+0x74/0x110
[18627.060140] Modules linked in: ceph libceph dns_resolver
openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 libcrc32c vfat fat dm_multipath dm_mod amd64_edac_mod
edac_mce_amd kvm_amd kvm bcache crc64 i40iw irqbypass ses enclosure
ipmi_si ib_uverbs ipmi_devintf joydev rapl ipmi_msghandler pcspkr
ib_core sg i2c_piix4 k10temp fuse ext4 mbcache jbd2 ast
drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
sd_mod fb_sys_fops cec drm_ttm_helper ttm ahci crct10dif_pclmul igb
crc32_pclmul libahci nvme crc32c_intel ghash_clmulni_intel nvme_core
dca smartpqi i40e t10_pi drm i2c_algo_bit libata ngbe
scsi_transport_sas ccp pinctrl_amd
[18627.126211] CPU: 83 PID: 238405 Comm: kworker/83:4 Kdump: loaded
Not tainted 5.10.0-272.0.0.174.ile2312sp1.x86_64 #1
[18627.138848] Hardware name: Inspur CS5280H2/CS5280H2, BIOS 3.03.62 09/15/=
2025
[18627.147615] Workqueue: events cached_dev_free [bcache]
[18627.154245] RIP: 0010:refcount_warn_saturate+0x74/0x110
[18627.160961] Code: 01 01 e8 be 77 53 00 0f 0b e9 d8 bc 88 00 80 3d
31 57 a0 01 00 75 cb 48 c7 c7 20 28 fa b5 c6 05 21 57 a0 01 01 e8 9b
77 53 00 <0f> 0b e9 b5 bc 88 00 80 3d 10 57 a0 01 00 75 a8 48 c7 c7 f8
27 fa
[18627.182808] RSP: 0018:ffffb5f9cdd0fe58 EFLAGS: 00010282
[18627.189531] RAX: 0000000000000000 RBX: ffff94f51e700010 RCX: 00000000000=
00000
[18627.198385] RDX: ffff94d71fbb1320 RSI: ffff94d71fba0710 RDI: ffff94d71fb=
a0710
[18627.207235] RBP: ffff94cf4d518000 R08: 0000000000000000 R09: ffffb5f9cdd=
0fc90
[18627.216089] R10: ffffb5f9cdd0fc88 R11: ffffffffb69e13a8 R12: ffff94cf4d5=
18030
[18627.224939] R13: 0000000000000000 R14: ffff94d71fbbb700 R15: ffff94d71fb=
bb705
[18627.233791] FS:  0000000000000000(0000) GS:ffff94d71fb80000(0000)
knlGS:0000000000000000
[18627.243706] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18627.251003] CR2: 000055d6288098d0 CR3: 0000000594856000 CR4: 00000000003=
506e0
[18627.259857] Call Trace:
[18627.263478]  kthread_stop+0x152/0x160
[18627.268464]  cached_dev_free+0x30/0xd0 [bcache]
[18627.274413]  process_one_work+0x1b5/0x350
[18627.279774]  worker_thread+0x49/0x310
[18627.284750]  ? rescuer_thread+0x380/0x380
[18627.290110]  kthread+0xfe/0x140
[18627.294504]  ? kthread_park+0x90/0x90
[18627.299481]  ret_from_fork+0x22/0x30
[18627.304365] ---[ end trace 461f27b6101e7b4e ]---
[18627.310402] ------------[ cut here ]------------
[18627.316446] WARNING: CPU: 83 PID: 238405 at kernel/kthread.c:83
kthread_stop+0x12c/0x160
[18627.326367] Modules linked in: ceph libceph dns_resolver
openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 libcrc32c vfat fat dm_multipath dm_mod amd64_edac_mod
edac_mce_amd kvm_amd kvm bcache crc64 i40iw irqbypass ses enclosure
ipmi_si ib_uverbs ipmi_devintf joydev rapl ipmi_msghandler pcspkr
ib_core sg i2c_piix4 k10temp fuse ext4 mbcache jbd2 ast
drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
sd_mod fb_sys_fops cec drm_ttm_helper ttm ahci crct10dif_pclmul igb
crc32_pclmul libahci nvme crc32c_intel ghash_clmulni_intel nvme_core
dca smartpqi i40e t10_pi drm i2c_algo_bit libata ngbe
scsi_transport_sas ccp pinctrl_amd
[18627.392415] CPU: 83 PID: 238405 Comm: kworker/83:4 Kdump: loaded
Tainted: G        W         5.10.0-272.0.0.174.ile2312sp1.x86_64 #1
[18627.406601] Hardware name: Inspur CS5280H2/CS5280H2, BIOS 3.03.62 09/15/=
2025
[18627.415362] Workqueue: events cached_dev_free [bcache]
[18627.421985] RIP: 0010:kthread_stop+0x12c/0x160
[18627.427836] Code: 00 e9 0b ff ff ff 48 89 ef e8 50 69 fd ff e9 73
ff ff ff be 01 00 00 00 4c 89 e7 e8 2e 6a 46 00 f6 45 36 20 0f 85 16
ff ff ff <0f> 0b e9 0f ff ff ff be 03 00 00 00 4c 89 e7 e8 10 6a 46 00
e9 43
[18627.449681] RSP: 0018:ffffb5f9cdd0fe60 EFLAGS: 00010246
[18627.456406] RAX: 0000000000000000 RBX: ffff94f51e700010 RCX: 00000000000=
00000
[18627.465254] RDX: ffff94d71fbb1320 RSI: ffff94d71fba0710 RDI: ffff94d71fb=
a0710
[18627.474094] RBP: ffff94cf4d518000 R08: 0000000000000000 R09: ffffb5f9cdd=
0fc90
[18627.482942] R10: ffffb5f9cdd0fc88 R11: ffffffffb69e13a8 R12: ffff94cf4d5=
18030
[18627.491792] R13: 0000000000000000 R14: ffff94d71fbbb700 R15: ffff94d71fb=
bb705
[18627.500643] FS:  0000000000000000(0000) GS:ffff94d71fb80000(0000)
knlGS:0000000000000000
[18627.510564] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18627.517861] CR2: 000055d6288098d0 CR3: 0000000594856000 CR4: 00000000003=
506e0
[18627.526715] Call Trace:
[18627.530338]  cached_dev_free+0x30/0xd0 [bcache]
[18627.536283]  process_one_work+0x1b5/0x350
[18627.541643]  worker_thread+0x49/0x310
[18627.546618]  ? rescuer_thread+0x380/0x380
[18627.551977]  kthread+0xfe/0x140
[18627.556372]  ? kthread_park+0x90/0x90
[18627.561345]  ret_from_fork+0x22/0x30
[18627.566226] ---[ end trace 461f27b6101e7b4f ]---
[18627.572269] BUG: unable to handle page fault for address: 00007fd3f5b21e=
10
[18627.580823] #PF: supervisor write access in kernel mode
[18627.587529] #PF: error_code(0x0002) - not-present page
[18627.594131] PGD 6a710f067 P4D 6a710f067 PUD 0
[18627.599968] Oops: 0002 [#1] SMP NOPTI
[18627.604930] CPU: 83 PID: 238405 Comm: kworker/83:4 Kdump: loaded
Tainted: G        W         5.10.0-272.0.0.174.ile2312sp1.x86_64 #1
[18627.619101] Hardware name: Inspur CS5280H2/CS5280H2, BIOS 3.03.62 09/15/=
2025
[18627.627851] Workqueue: events cached_dev_free [bcache]
[18627.634463] RIP: 0010:kthread_stop+0x49/0x160
[18627.640199] Code: 45 30 85 c0 0f 84 1c 01 00 00 0f 88 e6 00 00 00
83 c0 01 0f 88 dd 00 00 00 f6 45 36 20 0f 84 ea 00 00 00 48 8b 9d e8
0a 00 00 <f0> 80 0b 02 48 89 ef e8 3b ff ff ff 48 89 ef e8 43 31 01 00
48 8d
[18627.662022] RSP: 0018:ffffb5f9cdd0fe60 EFLAGS: 00010246
[18627.668728] RAX: 0000000000000000 RBX: 00007fd3f5b21e10 RCX: 00000000000=
00000
[18627.677565] RDX: ffff94d71fbb1320 RSI: ffff94d71fba0710 RDI: ffff94d71fb=
a0710
[18627.686404] RBP: ffff94cf4d518000 R08: 0000000000000000 R09: ffffb5f9cdd=
0fc90
[18627.695232] R10: ffffb5f9cdd0fc88 R11: ffffffffb69e13a8 R12: ffff94cf4d5=
18030
[18627.704070] R13: 0000000000000000 R14: ffff94d71fbbb700 R15: ffff94d71fb=
bb705
[18627.712910] FS:  0000000000000000(0000) GS:ffff94d71fb80000(0000)
knlGS:0000000000000000
[18627.722816] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18627.730103] CR2: 00007fd3f5b21e10 CR3: 0000000594856000 CR4: 00000000003=
506e0
[18627.738941] Call Trace:
[18627.742553]  cached_dev_free+0x30/0xd0 [bcache]
[18627.748483]  process_one_work+0x1b5/0x350
[18627.753824]  worker_thread+0x49/0x310
[18627.758785]  ? rescuer_thread+0x380/0x380
[18627.764134]  kthread+0xfe/0x140
[18627.768514]  ? kthread_park+0x90/0x90
[18627.773477]  ret_from_fork+0x22/0x30
[18627.778344] Modules linked in: ceph libceph dns_resolver
openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 libcrc32c vfat fat dm_multipath dm_mod amd64_edac_mod
edac_mce_amd kvm_amd kvm bcache crc64 i40iw irqbypass ses enclosure
ipmi_si ib_uverbs ipmi_devintf joydev rapl ipmi_msghandler pcspkr
ib_core sg i2c_piix4 k10temp fuse ext4 mbcache jbd2 ast
drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
sd_mod fb_sys_fops cec drm_ttm_helper ttm ahci crct10dif_pclmul igb
crc32_pclmul libahci nvme crc32c_intel ghash_clmulni_intel nvme_core
dca smartpqi i40e t10_pi drm i2c_algo_bit libata ngbe
scsi_transport_sas ccp pinctrl_amd
[18627.844370] CR2: 00007fd3f5b21e10
[18627.851414] kexec: Bye!

liequan che <liequanche@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8812=E6=
=97=A5=E5=91=A8=E4=B8=89 21:04=E5=86=99=E9=81=93=EF=BC=9A
>
> >>Could you please point out exactly which reference is still held?
> Let's analyze the call stack of the vmcore generated by kernel kdump
> using the crash tool.
> crash> dev -d bcache0
> MAJOR GENDISK NAME REQUEST_QUEUE TOTAL ASYNC SYNC
> 259 ffff94f74254b800 nvme2n1 ffff94f748d60938 0 0 0
> 259 ffff94f741a5f800 nvme3n1 ffff94f749260000 0 0 0
> 259 ffff94f74746c000 nvme1n1 ffff94f746ff8938 0 0 0
> 8 ffff94d74196f000 sda ffff94cf45bc6568 0 0 0
> 8 ffff94f741ac7800 sdb ffff94cf45bc52f8 0 0 0
> 8 ffff94f741a1b000 sdc ffff94cf45bc5c30 0 0 0
> 8 ffff94f741d5b800 sdd ffff94cf45bc24e0 0 0 0
> 8 ffff94cf41a93000 sde ffff94cf45bc1ba8 0 0 0
> 8 ffff94cf41a97000 sdf ffff94cf45bc4088 0 0 0
> 8 ffff94cf41a93800 sdg ffff94cf4615d2f8 0 0 0
> 8 ffff94cf41a91000 sdh ffff94cf4615dc30 0 0 0
> 8 ffff94cf41a94800 sdi ffff94cf4615a4e0 0 0 0
> 8 ffff94cf41a96800 sdj ffff94cf46159ba8 0 0 0
> 8 ffff94cf41a90800 sdk ffff94cf4615e568 0 0 0
> 253 ffff94f7553dd800 bcache0 ffff94f51e742e18 0 0 0 259
> ffff94f741d57800 nvme0n1 ffff94fc9fa5dc30 0 0 0
> crash> p /x  $gendisk=3D((struct gendisk *)0xffff94f7553dd800)->private_d=
ata
> $9 =3D (void *) 0xffff94f51e700010
> crash> p /x  $closure=3D&((struct bcache_device *)$gendisk)->cl
> $10 =3D (struct closure *) 0xffff94f51e700010
> crash>p /x  $cached_set=3D&(struct cache_set *)(((struct bcache_device
> *)$gendisk)->c)
> $11 =3D (struct closure *) 0xffff94f51e7004b8
> crash> p  $fn_name=3D((struct closure *)$closure)->fn
> $12 =3D (closure_fn *) 0xffffffffc0b88440 <cached_dev_free>
> crash> p $wq_name=3D((struct closure *)$closure)->wq
> $13 =3D (struct workqueue_struct *) 0x14c0
> crash> p /x ((struct closure *)$closure)->remaining.counter
> $14 =3D  0x40000001
> crash> p $dc_off=3D&((struct cached_dev *)0)->disk.cl
> $15 =3D (struct closure *) 0x10
> crash > p/x $cached_dev =3D (struct cached_dev *)((unsigned
> long)$closure - (unsigned long)$dc_off)
> $16 =3D 0xffff94f51e700000
> crash> task $writeback_thread
> task: invalid task, pid, or task_struct member: $writeback_thread
> PID: 238405   TASK: ffff94d71fae9c00  CPU: 83   COMMAND: "kworker/83:4"
> struct task_struct {
>   thread_info =3D {
>     flags =3D 16520,
>     status =3D 0,
>     cpu =3D 83,
>     kabi_reserved1 =3D 0,
>     kabi_reserved2 =3D 0
>   },
>   state =3D 0,
>   stack =3D 0xffffb5f9cdd0c000,
> ......
> crash> p  $writeback_thread
> $41 =3D (struct task_struct *) 0xffff94cf4d518000
> crash> kmem 0xffff94cf4d518000
> CACHE             OBJSIZE  ALLOCATED     TOTAL  SLABS  SSIZE  NAME
> ffff94e740006bc0     7168       1575      2904    726    32k  task_struct
>   SLAB              MEMORY            NODE  TOTAL  ALLOCATED  FREE
>   ffffecf502354600  ffff94cf4d518000     2      4          1     3
>   FREE / [ALLOCATED]
>    ffff94cf4d518000  (cpu 12 cache)
>       PAGE         PHYSICAL      MAPPING       INDEX CNT FLAGS
> ffffecf502354600 108d518000 ffff94e740006bc0 ffff94cf4d51b800  1
> 97ffffc0010200 slab,head
>   the dc->writeback_thread kmem flag is  FREE / [ALLOCATED].
>
> The outstanding reference is the struct cached_dev lifetime reference
> (dc->count) held by the writeback kthread itself.
>
> The writeback thread takes (or is created with) a ref to dc, and it
> only drops it on exit via:
>
> // writeback.c
> ...
> if (dc->writeback_write_wq) { flush_workqueue(...); destroy_workqueue(...=
); }
> cached_dev_put(dc);                 // <-- drops the thread=E2=80=99s ref=
 to dc
> wait_for_kthread_stop();
>
> Separately, the bcache device=E2=80=99s closure (d->cl) still shows
> CLOSURE_RUNNING | 1 (you saw remaining=3D0x40000001), which is the
> closure=E2=80=99s *self* ref plus one extra reference that continue_at()l=
ater
> drops before invokingcached_dev_free(). That closure ref is not a
> leak; it=E2=80=99s the normal handoff to cached_dev_free()`.
>
> What actually explodes is that dc->writeback_thread remains a stale
> pointer after the thread has already exited and its task_struct slab
> was freed. A later kthread_stop(dc->writeback_thread) tries to
> get_task_struct() on a freed task, triggering:
>
> Coly Li <colyli@fnnas.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8811=E6=97=A5=
=E5=91=A8=E4=BA=8C 21:49=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Sat, Nov 08, 2025 at 05:22:51PM +0800, liequan che wrote:
> > >  We hit a use-after-free when cached_dev_free() is called while the
> > > writeback workqueue/thread may still be running or holding references=
.
> >
> > Could you please point out exactly which reference is still held?
> >
> > > In addition, writeback_wq was flushed/destroyed in more than one plac=
e,
> >
> > Could you please point out all the location where writeback_wq is stopp=
ed?
> >
> > > which could lead to double flush/destroy and racy teardown=E3=80=82Th=
is issue
> > > exists in kernels 5.10, 6.6, etc.
> >
> > Yes, if you mean explain how the panic comes in code logic, it will be
> > helpful for me to understand the issue.
> >
> > Thanks.
> >
> > Coly Li
> >
> >
> > >  The error message is as follows.
> >
> > > [18627.310402] ------------[ cut here ]------------
> > > [18627.316446] WARNING: CPU: 83 PID: 238405 at kernel/kthread.c:83
> > > kthread_stop+0x12c/0x160
> > > [18627.326367] Modules linked in: ceph libceph dns_resolver
> > > openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
> > > nf_defrag_ipv4 libcrc32c vfat fat dm_multipath dm_mod amd64_edac_mod
> > > edac_mce_amd kvm_amd kvm bcache crc64 i40iw irqbypass ses enclosure
> > > ipmi_si ib_uverbs ipmi_devintf joydev rapl ipmi_msghandler pcspkr
> > > ib_core sg i2c_piix4 k10temp fuse ext4 mbcache jbd2 ast
> > > drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
> > > sd_mod fb_sys_fops cec drm_ttm_helper ttm ahci crct10dif_pclmul igb
> > > crc32_pclmul libahci nvme crc32c_intel ghash_clmulni_intel nvme_core
> > > dca smartpqi i40e t10_pi drm i2c_algo_bit libata ngbe
> > > scsi_transport_sas ccp pinctrl_amd
> > > [18627.392415] CPU: 83 PID: 238405 Comm: kworker/83:4 Kdump: loaded
> > > Tainted: G        W         5.10.0-272.0.0.174.ile2312sp1.x86_64 #1
> > > [18627.406601] Hardware name: Inspur CS5280H2/CS5280H2, BIOS 3.03.62 =
09/15/2025
> > > [18627.415362] Workqueue: events cached_dev_free [bcache]
> > > [18627.421985] RIP: 0010:kthread_stop+0x12c/0x160
> > > [18627.427836] Code: 00 e9 0b ff ff ff 48 89 ef e8 50 69 fd ff e9 73
> > > ff ff ff be 01 00 00 00 4c 89 e7 e8 2e 6a 46 00 f6 45 36 20 0f 85 16
> > > ff ff ff <0f> 0b e9 0f ff ff ff be 03 00 00 00 4c 89 e7 e8 10 6a 46 0=
0
> > > e9 43
> > > [18627.449681] RSP: 0018:ffffb5f9cdd0fe60 EFLAGS: 00010246
> > > [18627.456406] RAX: 0000000000000000 RBX: ffff94f51e700010 RCX: 00000=
00000000000
> > > [18627.465254] RDX: ffff94d71fbb1320 RSI: ffff94d71fba0710 RDI: ffff9=
4d71fba0710
> > > [18627.474094] RBP: ffff94cf4d518000 R08: 0000000000000000 R09: ffffb=
5f9cdd0fc90
> > > [18627.482942] R10: ffffb5f9cdd0fc88 R11: ffffffffb69e13a8 R12: ffff9=
4cf4d518030
> > > [18627.491792] R13: 0000000000000000 R14: ffff94d71fbbb700 R15: ffff9=
4d71fbbb705
> > > [18627.500643] FS:  0000000000000000(0000) GS:ffff94d71fb80000(0000)
> > > knlGS:0000000000000000
> > > [18627.510564] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [18627.517861] CR2: 000055d6288098d0 CR3: 0000000594856000 CR4: 00000=
000003506e0
> > > [18627.526715] Call Trace:
> > > [18627.530338]  cached_dev_free+0x30/0xd0 [bcache]
> > > [18627.536283]  process_one_work+0x1b5/0x350
> > > [18627.541643]  worker_thread+0x49/0x310
> > > [18627.546618]  ? rescuer_thread+0x380/0x380
> > > [18627.551977]  kthread+0xfe/0x140
> > > [18627.556372]  ? kthread_park+0x90/0x90
> > > [18627.561345]  ret_from_fork+0x22/0x30
> > > [18627.566226] ---[ end trace 461f27b6101e7b4f ]---
> > > [18627.572269] BUG: unable to handle page fault for address: 00007fd3=
f5b21e10
> > > [18627.580823] #PF: supervisor write access in kernel mode
> > > [18627.587529] #PF: error_code(0x0002) - not-present page
> > > [18627.594131] PGD 6a710f067 P4D 6a710f067 PUD 0
> > > [18627.599968] Oops: 0002 [#1] SMP NOPTI
> > > [18627.604930] CPU: 83 PID: 238405 Comm: kworker/83:4 Kdump: loaded
> > > Tainted: G        W         5.10.0-272.0.0.174.ile2312sp1.x86_64 #1
> > > [18627.619101] Hardware name: Inspur CS5280H2/CS5280H2, BIOS 3.03.62 =
09/15/2025
> > > [18627.627851] Workqueue: events cached_dev_free [bcache]
> > > [18627.634463] RIP: 0010:kthread_stop+0x49/0x160
> > > [18627.640199] Code: 45 30 85 c0 0f 84 1c 01 00 00 0f 88 e6 00 00 00
> > > 83 c0 01 0f 88 dd 00 00 00 f6 45 36 20 0f 84 ea 00 00 00 48 8b 9d e8
> > > 0a 00 00 <f0> 80 0b 02 48 89 ef e8 3b ff ff ff 48 89 ef e8 43 31 01 0=
0
> > > 48 8d
> > > [18627.662022] RSP: 0018:ffffb5f9cdd0fe60 EFLAGS: 00010246
> > > [18627.668728] RAX: 0000000000000000 RBX: 00007fd3f5b21e10 RCX: 00000=
00000000000
> > > [18627.677565] RDX: ffff94d71fbb1320 RSI: ffff94d71fba0710 RDI: ffff9=
4d71fba0710
> > > [18627.686404] RBP: ffff94cf4d518000 R08: 0000000000000000 R09: ffffb=
5f9cdd0fc90
> > > [18627.695232] R10: ffffb5f9cdd0fc88 R11: ffffffffb69e13a8 R12: ffff9=
4cf4d518030
> > > [18627.704070] R13: 0000000000000000 R14: ffff94d71fbbb700 R15: ffff9=
4d71fbbb705
> > > [18627.712910] FS:  0000000000000000(0000) GS:ffff94d71fb80000(0000)
> > > knlGS:0000000000000000
> > > [18627.722816] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [18627.730103] CR2: 00007fd3f5b21e10 CR3: 0000000594856000 CR4: 00000=
000003506e0
> > > [18627.738941] Call Trace:
> > > [18627.742553]  cached_dev_free+0x30/0xd0 [bcache]
> > > [18627.748483]  process_one_work+0x1b5/0x350
> > > [18627.753824]  worker_thread+0x49/0x310
> > > [18627.758785]  ? rescuer_thread+0x380/0x380
> > > [18627.764134]  kthread+0xfe/0x140
> > > [18627.768514]  ? kthread_park+0x90/0x90
> > > [18627.773477]  ret_from_fork+0x22/0x30
> > > [18627.778344] Modules linked in: ceph libceph dns_resolver
> > > openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
> > > nf_defrag_ipv4 libcrc32c vfat fat dm_multipath dm_mod amd64_edac_mod
> > > edac_mce_amd kvm_amd kvm bcache crc64 i40iw irqbypass ses enclosure
> > > ipmi_si ib_uverbs ipmi_devintf joydev rapl ipmi_msghandler pcspkr
> > > ib_core sg i2c_piix4 k10temp fuse ext4 mbcache jbd2 ast
> > > drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
> > > sd_mod fb_sys_fops cec drm_ttm_helper ttm ahci crct10dif_pclmul igb
> > > crc32_pclmul libahci nvme crc32c_intel ghash_clmulni_intel nvme_core
> > > dca smartpqi i40e t10_pi drm i2c_algo_bit libata ngbe
> > > scsi_transport_sas ccp pinctrl_amd
> > > [18627.844370] CR2: 00007fd3f5b21e10
> > > [18627.851414] kexec: Bye!
> > >  The kernel error call stack is as follows:The kernel error call stac=
k
> > > is as follows.
> > > crash> bt
> > > PID: 238405   TASK: ffff94d71fae9c00  CPU: 83   COMMAND: "kworker/83:=
4"
> > > #0 [ffffb5f9cdd0fca8] crash_kexec at ffffffffb4db67e9
> > > #1 [ffffb5f9cdd0fcb8] oops_end at ffffffffb4c2b1c5
> > > #2 [ffffb5f9cdd0fcd8] no_context at ffffffffb4c7d86c
> > > #3 [ffffb5f9cdd0fd10] __bad_area_nosemaphore at ffffffffb4c7d972
> > > #4 [ffffb5f9cdd0fd58] exc_page_fault at ffffffffb56f7e1c
> > > #5 [ffffb5f9cdd0fdb0] asm_exc_page_fault at ffffffffb5800b4e
> > >    [exception RIP: kthread_stop+73]
> > >    RIP: ffffffffb4d0fee9  RSP: ffffb5f9cdd0fe60  RFLAGS: 00010246
> > >    RAX: 0000000000000000  RBX: 00007fd3f5b21e10  RCX: 000000000000000=
0
> > >    RDX: ffff94d71fbb1320  RSI: ffff94d71fba0710  RDI: ffff94d71fba071=
0
> > >    RBP: ffff94cf4d518000   R8: 0000000000000000   R9: ffffb5f9cdd0fc9=
0
> > >    R10: ffffb5f9cdd0fc88  R11: ffffffffb69e13a8  R12: ffff94cf4d51803=
0
> > >    R13: 0000000000000000  R14: ffff94d71fbbb700  R15: ffff94d71fbbb70=
5
> > >    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> > > #6 [ffffb5f9cdd0fe80] cached_dev_free at ffffffffc0b88470 [bcache]
> > > #7 [ffffb5f9cdd0fe98] process_one_work at ffffffffb4d099c5
> > > #8 [ffffb5f9cdd0fed8] worker_thread at ffffffffb4d09f29
> > > #9 [ffffb5f9cdd0ff10] kthread at ffffffffb4d0f2be
> > > #10 [ffffb5f9cdd0ff50] ret_from_fork at ffffffffb4c035b2
> > > Signed-off-by: cheliequan <cheliequan@inspur.com>
> > > ---
> > > drivers/md/bcache/bcache.h    |  7 +++++++
> > > drivers/md/bcache/super.c     | 13 +++++++++----
> > > drivers/md/bcache/writeback.c |  9 ++++++---
> > > 3 files changed, 22 insertions(+), 7 deletions(-)
> > > diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> > > index 832fb3d80eb0..5eba5c068c9c 100644
> > > --- a/drivers/md/bcache/bcache.h
> > > +++ b/drivers/md/bcache/bcache.h
> > > @@ -963,6 +963,13 @@ static inline void wait_for_kthread_stop(void)
> > >        }
> > > }
> > > +#define STOP_THREAD_ONCE(dc, member)                           \
> > > +       do {                                                         =
  \
> > > +                       struct task_struct *t__ =3D xchg(&(dc)->membe=
r, NULL);   \
> > > +                       if (t__ && !IS_ERR(t__))                     =
          \
> > > +                               kthread_stop(t__);                   =
          \
> > > +       } while (0)
> > > +
> > > /* Forward declarations */
> > > void bch_count_backing_io_errors(struct cached_dev *dc, struct bio *b=
io);
> > > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > > index 6afc718ef202..22a002cca6ab 100644
> > > --- a/drivers/md/bcache/super.c
> > > +++ b/drivers/md/bcache/super.c
> > > @@ -1368,15 +1368,20 @@ void bch_cached_dev_release(struct kobject *k=
obj)
> > > static void cached_dev_free(struct closure *cl)
> > > {
> > > +       struct workqueue_struct *wq =3D NULL;
> > >        struct cached_dev *dc =3D container_of(cl, struct cached_dev, =
disk.cl);
> > >        if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags)=
)
> > >                cancel_writeback_rate_update_dwork(dc);
> > > -       if (!IS_ERR_OR_NULL(dc->writeback_thread))
> > > -               kthread_stop(dc->writeback_thread);
> > > -       if (!IS_ERR_OR_NULL(dc->status_update_thread))
> > > -               kthread_stop(dc->status_update_thread);
> > > +       STOP_THREAD_ONCE(dc, writeback_thread);
> > > +       STOP_THREAD_ONCE(dc, status_update_thread);
> > > +
> > > +       wq =3D xchg(&dc->writeback_write_wq, NULL);
> > > +       if (wq) {
> > > +           flush_workqueue(wq);
> > > +           destroy_workqueue(wq);
> > > +       }
> > >        mutex_lock(&bch_register_lock);
> > > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeb=
ack.c
> > > index 854cdaa84462..3cac64b9d606 100644
> > > --- a/drivers/md/bcache/writeback.c
> > > +++ b/drivers/md/bcache/writeback.c
> > > @@ -741,6 +741,7 @@ static int bch_writeback_thread(void *arg)
> > >        struct cached_dev *dc =3D arg;
> > >        struct cache_set *c =3D dc->disk.c;
> > >        bool searched_full_index;
> > > +       struct workqueue_struct *wq =3D NULL;
> > >        bch_ratelimit_reset(&dc->writeback_rate);
> > > @@ -832,10 +833,12 @@ static int bch_writeback_thread(void *arg)
> > >                }
> > >        }
> > > -       if (dc->writeback_write_wq) {
> > > -               flush_workqueue(dc->writeback_write_wq);
> > > -               destroy_workqueue(dc->writeback_write_wq);
> > > +       wq =3D xchg(&dc->writeback_write_wq, NULL);
> > > +       if (wq) {
> > > +           flush_workqueue(wq);
> > > +           destroy_workqueue(wq);
> > >        }
> > > +
> > >        cached_dev_put(dc);
> > >        wait_for_kthread_stop();
> > > --
> > > 2.43.0

