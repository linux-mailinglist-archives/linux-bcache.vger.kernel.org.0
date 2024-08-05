Return-Path: <linux-bcache+bounces-705-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA40F9481B0
	for <lists+linux-bcache@lfdr.de>; Mon,  5 Aug 2024 20:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FA0428EC03
	for <lists+linux-bcache@lfdr.de>; Mon,  5 Aug 2024 18:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9081115F3F8;
	Mon,  5 Aug 2024 18:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="xXW00r5w"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3170115AD96
	for <linux-bcache@vger.kernel.org>; Mon,  5 Aug 2024 18:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722882917; cv=none; b=mxSO/0XTKSC8EhDVepZrP5rzrQKXyPuSZG52Fg2aUQEIk19Lwthr9fOKa+Dh562n5CYL556jL/nn5uHl7uc1D73saXMub76cfGyadkrj3c0qqhvbZXtYzNLaevRidUjtR5aQF9CEbfQLHgAsBjKL/8uy0CuKk7JHCpBleUkBKL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722882917; c=relaxed/simple;
	bh=DzMgvwzI+LvEfazuLey/j8lOg+VrYKIVQEwU/BYw66k=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=Mm7amz4taYdBYlcrrZMMO3ZXWG+27zWritGjBDL466a9HQL7WpcdIfF3TgjL+p71mgoqxY9TaAm3pjYGzks0D6RbfrWVWRiPC/zbjYoxPCSo0PNJp8UTImN6xjcp3cxRS7vJewEo2qy8OPoiP4EScIC9/s+N1dZZgF0VBwAU0sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=xXW00r5w; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52f01993090so14941183e87.2
        for <linux-bcache@vger.kernel.org>; Mon, 05 Aug 2024 11:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1722882913; x=1723487713; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WVkvcEgnyJ+1+Y44sUVbI5lbdMwjxmKY6OzPovi4aG0=;
        b=xXW00r5wnmYv54pYH80WLT7pUn50yCEa19suqSrU6O6FqqO3uLwGGGypURqUN3Fq6w
         5UjFgyvLRrD5mcMPHsv5zX89ODH0tj3Gqu38JUFmkBF+iwVA38wmmdoVK9iV9z4BODEL
         bYghNHQ8W9RLpvoETqOhe2Ac4kt1Ve/Z8Anh/gi+bpMFC5PYC89Hc8UDFt2YDMD6dOPx
         6wEj9i0vfxFrSy2ybTGZTydkD1qdRwnfJwIO85E/1hQMc70AYb8WBKYYZdOFGuEZMAh1
         nwAbyKOZ2m4p25RHzv/BSsyVtgsTuBoEyTrrlpeUiBOyAeW1OBl6gczWJiksIMHmJJYg
         Wt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722882913; x=1723487713;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WVkvcEgnyJ+1+Y44sUVbI5lbdMwjxmKY6OzPovi4aG0=;
        b=My3OlNpFqiGSF2d0k2eBWv9VNBCJ5T1a8pt5M+rH2lTSf0m3OjD5ugWsZ29lwXjO3l
         tXe2rL1xE2cMACrJ4vf4CEeGoLnuKtPj2GZkhhN6oq/3Z7XSPJi/BuYLTi3sx41Hj29p
         Nnyijk4rWw6VHe1yCRDMrql4EqCs/bjMjL/rrW4mjNuV/V101vncR6omaGiAb3cmtY03
         6aU2KtTy0PSOYV/Cq1ksrVDpcrofsYcwPbHjSfILeSyot6683AxboxOt+p4Jb4HedwqM
         ntatNYjBLhOs3d8e0En79lbbFMn0kWV55glr335Rr9jPzOSZkTJZm+uedlzX8sB5iVtG
         UR5g==
X-Gm-Message-State: AOJu0Yy+YB4T8YQD4SXwPSF3LqmTUZNHff1da3mn0NHL9UYsC6fyCDDC
	z71Qn5fKyUjIPmDGWR+SkF9gXrCCWcFdXK1nrMduN5DxGRoa2n8ciFIi1PHlsvY=
X-Google-Smtp-Source: AGHT+IH/VaYWA0Z9jJyzClgGdlcJHtRJW1ehk5fJeybQcQEDDraHl3N6c/uXalUPwx7bGUhBYiLCWQ==
X-Received: by 2002:a05:6512:1051:b0:52e:f4b4:6ec1 with SMTP id 2adb3069b0e04-530bb39d2fcmr7519755e87.46.1722882912901;
        Mon, 05 Aug 2024 11:35:12 -0700 (PDT)
Received: from smtpclient.apple ([2a00:1370:81a4:1df5:b5e9:827a:53fc:aa7d])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-530bba3d22csm1207484e87.287.2024.08.05.11.35.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2024 11:35:12 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.8\))
Subject: bcachefs mount issue
Message-Id: <0D2287C8-F086-43B1-85FA-B672BFF908F5@dubeyko.com>
Date: Mon, 5 Aug 2024 21:35:09 +0300
Cc: linux-bcache@vger.kernel.org,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 slava@dubeiko.com
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3696.120.41.1.8)

Hi Kent,

As far as I  can see, I have found a mount issue. I believe that it=E2=80=99=
s a mkfs tool issue.

ENVIRONMENT:
Linux ssdfs-test-0070 6.10.0 #15 SMP PREEMPT_DYNAMIC Mon Aug  5 19:00:55 =
MSK 2024 x86_64 x86_64 x86_64 GNU/Linux

I am not sure how to share the mkfs.bcachefs tool version because this =
tool doesn=E2=80=99t show the version.

REPRODUCTION PATH:

(1) Format partition by mkfs tool of any file system (for example, =
NILFS2)
(2) Mount the prepared volume
(3) Execute any file system operations on the volume
(4) Unmount the volume
(5) Format partition by mkfs.bcachefs tool
(6) Try to mount the prepared  bcachefs volume
(7) The bcachefs logic fails too mount the formatted volume

sudo mkfs.nilfs2 -f -b 4096 /dev/sda1=20
mkfs.nilfs2 (nilfs-utils 2.2.8)
Start writing file system initial data to the device
       Blocksize:4096  Device:/dev/sda1  Device Size:999292928
File system initialization succeeded !!

sudo mount /dev/sda1 /mnt/test/

mount
<skipped>
/dev/sda1 on /mnt/test type nilfs2 (rw,relatime)

Aug  5 19:14:40 ssdfs-test-0070 kernel: [  520.066975] NILFS (sda1): =
segctord starting. Construction interval =3D 5 seconds, CP frequency < =
30 seconds
Aug  5 19:14:40 ssdfs-test-0070 nilfs_cleanerd[3854]: start
Aug  5 19:14:40 ssdfs-test-0070 nilfs_cleanerd[3854]: pause (clean =
check)

sudo umount /mnt/test

Aug  5 19:15:18 ssdfs-test-0070 nilfs_cleanerd[3854]: shutdown

sudo mkfs.bcachefs -f --block_size=3D4096 /dev/sda1=20
External UUID: 483fb669-63aa-4f41-b0ba-61eb2446c2fe
Internal UUID: 43527890-f6c8-43f1-bdd9-1c4936f71a8d
Device index: 0
Label:=20
Version: 14
Oldest version on disk: 14
Created: Mon Aug  5 19:20:32 2024
Squence number: 0
Block_size: 4.0K
Btree node size: 128.0K
Error action: ro
Clean: 0
Features: =
new_siphash,new_extent_overwrite,btree_ptr_v2,extents_above_btree_updates,=
btree_updates_journalled,new_varint,journal_no_flush,alloc_v2,extents_acro=
ss_btree_nodes
Compat features:=20
Metadata replicas: 1
Data replicas: 1
Metadata checksum type: crc32c (1)
Data checksum type: crc32c (1)
Compression type: none (0)
Foreground write target: none
Background write target: none
Promote target: none
Metadata target:                none
String hash type: siphash (2)
32 bit inodes: 1
GC reserve percentage: 8%
Root reserve percentage: 0%
Devices: 1 live, 1 total
Sections: members
Superblock size: 816

Members (size 64):
  Device 0:
    UUID: 2c54ddfc-f50c-4d15-aa80-7d23474de3e6
    Size: 953.0M
    Bucket size: 128.0K
    First bucket: 0
    Buckets: 7624
    Last mount: (never)
    State: rw
    Group: (none)
    Data allowed: journal,btree,user
    Has data: (none)
    Replacement policy: lru
    Discard: 0
initializing new filesystem
going read-write
mounted with opts: (null)

sudo mount /dev/sda1 /mnt/test/

mount
<skipped>
/dev/sda1 on /mnt/test type nilfs2 (rw,relatime) <=E2=80=94 completely =
unexpected

Aug  5 19:21:13 ssdfs-test-0070 kernel: [  912.678991] NILFS (sda1): =
broken superblock, retrying with spare superblock (blocksize =3D 1024)
Aug  5 19:21:13 ssdfs-test-0070 kernel: [  912.679835] NILFS (sda1): =
broken superblock, retrying with spare superblock (blocksize =3D 4096)
Aug  5 19:21:13 ssdfs-test-0070 kernel: [  912.706795] NILFS (sda1): =
segctord starting. Construction interval =3D 5 seconds, CP frequency < =
30 seconds
Aug  5 19:21:13 ssdfs-test-0070 nilfs_cleanerd[4751]: start
Aug  5 19:21:13 ssdfs-test-0070 nilfs_cleanerd[4751]: pause (clean =
check)

sudo umount /mnt/test

sudo mount -t bcachefs /dev/sda1 /mnt/test/
mount: /mnt/test: wrong fs type, bad option, bad superblock on =
/dev/sda1, missing codepage or helper program, or other error.

Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.311715] bcachefs (sda1): =
mounting version 0.14: btree_ptr_sectors_written =
opts=3Dnoshard_inode_numbers,journal_reclaim_delay=3D1000,nojournal_transa=
ction_names
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.311753] bcachefs (sda1): =
recovering from clean shutdown, journal seq 4
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.311782] bcachefs (sda1): =
Version upgrade required:
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.311782] Doing =
incompatible version upgrade from 0.14: btree_ptr_sectors_written to =
1.7: mi_btree_bitmap
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.311782]   running =
recovery passes: =
check_allocations,check_alloc_info,check_lrus,check_btree_backpointers,che=
ck_backpointers_to_extents,check_extents_to_backpointers,check_alloc_to_lr=
u_refs,bucket_gens_init,check_snapshot_trees,check_snapshots,check_subvols=
,check_subvol_children,delete_dead_snapshots,check_inodes,check_extents,ch=
eck_indirect_extents,check_dirents,check_xattrs,check_root,check_subvolume=
_structure,check_directory_structure,check_nlinks,delete_dead_inodes,set_f=
s_needs_rebalance
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.431462] bcachefs (sda1): =
alloc_read... done
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.431675] bcachefs (sda1): =
stripes_read... done
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.431688] bcachefs (sda1): =
snapshots_read... done
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.431702] bcachefs (sda1): =
check_allocations...
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.469609] dev 0 has wrong =
free buckets: got 0, should be 7537, fixing
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.469683]  done
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.471013] bcachefs (sda1): =
going read-write
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.471766] bcachefs (sda1): =
journal_replay... done
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.471794] bcachefs (sda1): =
check_alloc_info... done
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.472921] bcachefs (sda1): =
check_lrus... done
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.473309] bcachefs (sda1): =
check_btree_backpointers... done
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.473960] bcachefs (sda1): =
check_backpointers_to_extents... done
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.474483] bcachefs (sda1): =
check_extents_to_backpointers...
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.474582] missing =
backpointer for btree=3Dinodes l=3D1 u64s 11 type btree_ptr_v2 SPOS_MAX =
len 0 ver 0: seq d7dbe59ccc0e54fa written 24 min_key POS_MIN durability: =
1 ptr: 0:78:0 gen 1
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.474590]   got:   u64s 5 =
type deleted 0:20447232:0 len 0 ver 0
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.474595]   want:  u64s 9 =
type backpointer 0:20447232:0 len 0 ver 0: bucket=3D0:78:0 btree=3Dinodes =
l=3D1 offset=3D0:0 len=3D256 pos=3DSPOS_MAX, shutting down
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.474645] bcachefs (sda1): =
inconsistency detected - emergency read only at journal seq 4
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.474664] bcachefs (sda1): =
bch2_check_extents_to_backpointers(): error fsck_errors_not_fixed
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.474682] bcachefs (sda1): =
bch2_fs_recovery(): error fsck_errors_not_fixed
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.474692] bcachefs (sda1): =
bch2_fs_start(): error starting filesystem fsck_errors_not_fixed
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.474842] bcachefs (sda1): =
unshutdown complete, journal seq 4
Aug  5 19:23:01 ssdfs-test-0070 kernel: [ 1020.595522] bcachefs: =
bch2_mount() error: fsck_errors_not_fixed

Thanks,
Slava.






