Return-Path: <linux-bcache+bounces-255-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA2A846369
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Feb 2024 23:26:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9192E1C21DF6
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Feb 2024 22:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48893FE5B;
	Thu,  1 Feb 2024 22:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s9vKrvEq"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F3A3D3BC
	for <linux-bcache@vger.kernel.org>; Thu,  1 Feb 2024 22:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706826354; cv=none; b=Wgv68E0bqjq/9HpiKTZhsAV+cehHCJ4GmS1I8D+IgOZLGJXKU0wTMCNF7sdb9edeK2bra3HUSs0HsChp9tCXOU9cCiwjrd9U7lQdh+0WUfEOgrvW27kvJILSO288BFkya8At/5R/RsvRnx2PwxsKEYVaUxkxp5zuz4Cg33nRNFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706826354; c=relaxed/simple;
	bh=/lXt7KtHmHUd9VjctSV1vNkQRsy9ruhHSV4ym7HYVts=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=K/QFaKJA108mfWnA499QF21VA62qcol4jooE67FvbVbIo5Vn9OR0UeC97ZxGbwm/tv8jCdKLS5IKOIXYOPdPEi9vLgsDPDqHeOEzK4f/gH5kLF7MHZVNFfCMeVoCiNoPntLE/Ifzqq0jx++oos/Jq8tDywMunQQUnViGK2Hw2Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s9vKrvEq; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-219122781a3so80382fac.0
        for <linux-bcache@vger.kernel.org>; Thu, 01 Feb 2024 14:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706826352; x=1707431152; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dObYWnWIKXavbg61GNpnkUFxW+siBlSb4MMj6WkB/xg=;
        b=s9vKrvEqQ/zYWzSPqL9sJTTWOaEJNideXbqR2ZKEo0tg/qsWXAO3fAzswcD4n5mhl2
         ZcJ/d9kdLpwgThLaLMrQSIg/rzV0Z2AKMQ92inRd4aQOE1P0fnrtRXqCM4/TRWEPHCPM
         Pu/TTNQrO9rA5xI6jmE+fIQPxubwwKw5Egdm9NV5dkyS/tGaTi29FNMaZKNDwrSAidlv
         wjM9fU7xNq8MCem/KOpzpcGr7Oj8Aldr8USOlnuVmeileyU1GX5eWCOi/UnEDs/ENpp9
         /+jzOtZqFJqCN8N/kkQh+pP70TvEIVqQer5oYU5MHTrAIV6Cib78biq6JlTqDOvp/uxg
         0iMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706826352; x=1707431152;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dObYWnWIKXavbg61GNpnkUFxW+siBlSb4MMj6WkB/xg=;
        b=kCofIvc9PpIsUJZ/2p4AJ1ZeQU0Ros4qqHHKN01kzc8rE6Wjk/upp52PAtPTDhyU9f
         aUcf/OeEC+E6P7qyuwFb9iC6gL/NiTnfjX1m7pu9ujw3wlCQGu8rU2HpS8lEKWS67a7a
         NbVV6XNJhrUqC2UVuYb9nArmOfCLlFPmsOoHPyApv87xpweaXjvYKX3VwxCWHPc2WCiw
         V962QEJhgfeQkPFNTd9kBnP/cJ8gp5aoe9EI+YGuVA37XXHVb3N/DepoYVZTVOi62OKd
         qv+STEeMxJuJ+T/ZPgUEGQEqE/utadj+3IPwl2Fg1aNLgc5Sza6xzbrZHWePg80GylKe
         2f6g==
X-Gm-Message-State: AOJu0YxnKNtauj5W6F/Eq/2mJCBySQ+2uus/W07TkGHKONCF0bj8ynF9
	waV66umjH1JVGkFx4TVfZEDN5pW9JANoGOcOp/85NMI85oj3zcPmuqVwmJQQeXsqHuNLy4+ur/a
	g1NHOCPoQzZB98VXLLAMvua09UKPCh+jYhYkZMd4XMNqjep4pTl/9
X-Google-Smtp-Source: AGHT+IGbTYld9GQWXEQMcAXNyIrdu7PD61zy0ns0Kil3kvPgVx9jisopKVbYDhk0W5cWnIgmftw0e0M1HRllZIIeZVM=
X-Received: by 2002:a05:6870:c0d5:b0:214:3339:f2e1 with SMTP id
 e21-20020a056870c0d500b002143339f2e1mr128747oad.59.1706826351768; Thu, 01 Feb
 2024 14:25:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Arnaldo Montagner <armont@google.com>
Date: Thu, 1 Feb 2024 14:25:40 -0800
Message-ID: <CANF=pgrX7h26TjA9bPUm9umRA-9KvELb9z3-bJsHm+t6SYbE1w@mail.gmail.com>
Subject: I/O error on cache device can cause user observable errors
To: linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The bcache documentation says that errors on the cache device are
handled transparently.

I'm seeing a case where the cache device is unregistered in response
to repeated write errors (expected), but that results in a read error
on the bcache device (unexpected).

Here's how I'm reproducing the problem:
1. Create a device with dm-error to simulate I/O errors. The device is
1G in size and it will fail I/Os in a 4M extent starting at offset
128M:
    $ dmsetup create cache_disk << EOF
      0      262144    linear /dev/sdb 0
      262144 8192      error
      270336 1826816   linear /dev/sdb 270336
    EOF

2. Set up bcache in writethrough mode. The backing device is 1000G in lengt=
h:
    $ make-bcache --cache /dev/mapper/cache_disk --bdev /dev/sdc
--wipe-bcache --bucket 256k
    $ echo writethrough > /sys/block/bcache0/bcache/cache_mode
    $ echo 0 > /sys/block/bcache0/bcache/cache/synchronous

    $ lsblk
    NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    ...
    sdb            8:16   0    10G  0 disk
    =E2=94=94=E2=94=80cache_disk 253:0    0     1G  0 dm
      =E2=94=94=E2=94=80bcache0  252:0    0  1000G  0 disk
    sdc            8:32   0  1000G  0 disk
    =E2=94=94=E2=94=80bcache0    252:0    0  1000G  0 disk

3. Start a random read workload on the bcache device (using fio):
    $ fio --name=3Dbasic --filename=3D/dev/bcache0 --size=3D1000G
--rw=3Drandread  --blocksize=3D256k --blockalign=3D256k

4. After a while I see that the cache device gets unregistered.
However, the application output indicates it saw an I/O error on a
read request:
     fio: io_u error on file /dev/bcache0: Input/output error: read
offset=3D592264298496, buflen=3D262144

I can see in the syslogs that bcache unregistered the cache. The logs
also show that there was an I/O error on the bcache device:
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.176867] bcache:
bch_count_io_errors() dm-0: IO error on writing data to cache.
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.186494] bcache:
bch_count_io_errors() dm-0: IO error on writing data to cache.
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.195743] bcache:
bch_count_io_errors() dm-0: IO error on writing data to cache.
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.204869] bcache:
bch_count_io_errors() dm-0: IO error on writing data to cache.
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.234722] bcache:
bch_count_io_errors() dm-0: IO error on writing data to cache.
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.246102] bcache:
bch_count_io_errors() dm-0: IO error on writing data to cache.
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.274013] bcache:
bch_count_io_errors() dm-0: IO error on writing data to cache.
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.289128] bcache:
bch_cache_set_error() error on 427201f5-5c86-4890-9866-f9860e518041:
dm-0: too many IO errors writing data to cache
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.289128] ,
disabling caching
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.306212] bcache:
conditional_stop_bcache_device() stop_when_cache_set_failed of bcache0
is "auto" and cache is clean, keep it alive.
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.306543] Buffer
I/O error on dev bcache0, logical block 144595776, async page read
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.316119] bcache:
cached_dev_detach_finish() Caching disabled for sdc
    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.316398] bcache:
cache_set_free() Cache set 427201f5-5c86-4890-9866-f9860e518041
unregistered

The steps above reproduce the problem most of the time, but not
always. In a few of the attempts, the cache was unregistered without
resulting in observable I/O errors.

Is this expected?

I'm running the Linux kernel version 6.5.0.

