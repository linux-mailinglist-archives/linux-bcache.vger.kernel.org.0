Return-Path: <linux-bcache+bounces-715-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B28895DFF7
	for <lists+linux-bcache@lfdr.de>; Sat, 24 Aug 2024 22:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B41C51C20C50
	for <lists+linux-bcache@lfdr.de>; Sat, 24 Aug 2024 20:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486AE7404B;
	Sat, 24 Aug 2024 20:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nfQlQSBm"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56F814A85
	for <linux-bcache@vger.kernel.org>; Sat, 24 Aug 2024 20:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724530644; cv=none; b=mR0qZVOX4A3n5y6bnvXvK16K99osKW0qbtyBPaXCfrjkGegLCEqNEqSVV6ngft/d4eQs50o55GC6Pw0VH3ERlJN0srvssa1y1k47cXQwV3XKR8PwWP72lmz1WB4K3lyw3+O4MVlT9NpwmbWVCyvrqfwSrCtOac2rgPmBX4j2dHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724530644; c=relaxed/simple;
	bh=V8UfwUYSJHwx71i8vs2aQTI+vcA9UUp4FzH6wapigRA=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=oGOGO4SUe9tBgH11jygFYfJwsrUxtHHlipRAIvS9nww4O9NKrwrPvLJHnMfaJ8/5bfId47BRlc7DpxjPF71jCxOqTDNvhNR1FEXZof52WUGjYopVCkydz123Ti4cwLLb+qQMc5J8TIuE5d6Kfvj+LXmLKmR+t6uXxD5MQVtsibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nfQlQSBm; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-498cd1112c3so801760137.0
        for <linux-bcache@vger.kernel.org>; Sat, 24 Aug 2024 13:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724530640; x=1725135440; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=V8UfwUYSJHwx71i8vs2aQTI+vcA9UUp4FzH6wapigRA=;
        b=nfQlQSBm9Xr3gblOJHgR+ljKy1GJ/zib+M2NcPmbOQxAecCGHu6zk6Szo/G33KDFkA
         uCrmTaOB2upSPEX1GqZH85nk5oWPveYyVH4UKPlaaBg5TFIeH35GrJbQqxGU/OkluyDQ
         YVTfZswTB/2zlVHvDmaWEyOy/YPvvoH5rEZzBCmtrN0d3tpQ+AXmMnmWySmyCx4ndM0h
         n1jXzDVxiPnTjVBZniCu0JvLX8BZKC8KYJc/xwSezhCmaoMlhwIco+c0HD5WVtPgZ2se
         JMHehpLmYBPfi2Qwdf9P5Arj8FpB2mpS9Mui/Z8YhnQqSBU/4FMWy7efd/7VmGQiK3Zp
         9u4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724530640; x=1725135440;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V8UfwUYSJHwx71i8vs2aQTI+vcA9UUp4FzH6wapigRA=;
        b=eE0gLUO5RZILbyGS/HXKIj7L9r26PocNJK5rcndcRtrpGvUxlQJzsa7nxeculZ4+uo
         7Xf5j+EWNHSEsirLt730PDkDJdn9kEALxbd3hmi3sCaF8spH37dM3WUt7Yi0VI6K8T/C
         DPy69CRPKutwyeXolezpVFVX2Nk/K36VyteBtVE81oQKddMK0ClCBeyYwSa7hA4MbNDR
         38/yx7AfUdFakI2tjW3JM2Y3wzVjaGDpNwL769cOzkvIr6nEdSm7ltM4foJPuvXM0PiL
         WQfkJUUBB69qa/f1Hyf7X2/aawPlJaG040vqKz8UCYa0pASh/IedFEDOgSqfWegQotNy
         eL/A==
X-Gm-Message-State: AOJu0YxI0M/VS+fy+JtlH9eBI8A3NK+VLV+32JVBxvK7Z4k3Yzs+pved
	HBj7ds2JzPHxye+wFT7/4i/D9hvSSQrwwGJvKELOJwV98lL3RpwTZ0GKmg==
X-Google-Smtp-Source: AGHT+IHb7vZg6nT4oli8zOYcvOySOc95fqRJ/EkVPKabWCBbUtVNOl3dbPS0VOlNTkE5o5ogUUObzg==
X-Received: by 2002:a05:6102:358c:b0:498:c2cd:1ac5 with SMTP id ada2fe7eead31-498f4b15bc6mr6638401137.9.1724530640066;
        Sat, 24 Aug 2024 13:17:20 -0700 (PDT)
Received: from smtpclient.apple ([2600:1700:2520:442d:fde1:5fd6:16d1:d6dc])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-498e47f3933sm915503137.17.2024.08.24.13.17.19
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Aug 2024 13:17:19 -0700 (PDT)
From: Giovanni Francesco <gioflux@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Filesystem stability and recommendations?
Message-Id: <91488477-9465-430C-96FF-44BB5C02C384@gmail.com>
Date: Sat, 24 Aug 2024 16:17:09 -0400
To: linux-bcache@vger.kernel.org
X-Mailer: Apple Mail (2.3776.700.51)

Hi. Which filesystems are considered stable and recommended for a =
reliable bcache setup in 2024?

There=E2=80=99s a lot of misinformation on the internet dating back to =
several years and I wanted to feel confident in using bcache for my home =
NAS server.=20

I have done some of my own experiments and =E2=80=9Cspeed benchmarks=E2=80=
=9D, noting that XFS and EXT4 filesystems seem to be the =E2=80=9Cfastest=E2=
=80=9D when compared to say btrfs and zfs.

My use case is NAS media server where I want to be very greedy with =
catching everything on first write or first read, so my HDDs can go back =
to sleep/idle/low-power state. My bcache configuration used on my =
experiments and =E2=80=9Ccheatsheet=E2=80=9D is here: =
https://github.com/TheLinuxGuy/ugreen-nas/blob/main/bcache-cheatsheet.md

High-level insights on hardware and my goals:
* 4 to 6 large capacity hard disks of mixed sizes (18TB, 14TB, 10TB, =
20TB)
* 2x 1TB NVME PCIE 3.0 x4 Samsung and WD, configured on RAID1 mdadm, =
/dev/md0p1 which is 85% of total available space. The remaining 15% of =
the nvmes are left empty on /dev/md0p2 following recommendations in this =
mailing list about =E2=80=9Cblkdiscard=E2=80=9D (because Arch Linux =
bcache article scares you of using =E2=80=9Cdiscard=E2=80=9D option =
natively in bcache)
* Would like my 4-6 backing disks to be RAID5, so 1 disk failure can =
occur.

Some experiments and benchmarks I have done on my own and its results:
- mdadm + bcache + btrfs (no lvm): =
https://github.com/TheLinuxGuy/ugreen-nas/blob/main/experiments-bench/mdad=
m-bcache-btrfs.md
- same but LVM2 on top: =
https://github.com/TheLinuxGuy/ugreen-nas/blob/main/experiments-bench/mdad=
m-lvm2-bcache-btrfs.md
- ZFS monster with custom settings and bcache: =
https://github.com/TheLinuxGuy/ugreen-nas/blob/main/experiments-bench/mdad=
m-lvm2-bcache-zfs.md

OK sorry for the wall of text. Please help me understand and recommend:
1) Can I trust bcache =E2=80=9Cdiscard=E2=80=9D on my nvme /dev/md0 =
RAID1, or should I stick with blkdiscard on blank partition2?
2) Can I fully rely on btrfs as a filesystem on top of bcache? Setup =
like mdadm + lvm2 vol (bcache backing)
3) Any other warnings, recommendations, suggestions or things to =
consider?

The reason for btrfs over all others is: snapshots, ability to shrink =
filesystem and expand it at will. LVM2 is used for stitching up disks of =
different sizes with the least amount of wasted disk space.

Thanks
Giovanni=

