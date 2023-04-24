Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620806EC71A
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Apr 2023 09:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjDXHbC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 03:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjDXHbB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 03:31:01 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12hn20331.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08B6E61;
        Mon, 24 Apr 2023 00:30:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIbHIPmT2r2cVTHxZE1oQP90SlKAwDMFkP7W1e8V6B7m5iobLwuAfdgRajh0EQEP3wobNf+mT4vrGX4WyJyxEdQv0DgDHHdKANavWC9Ra+ERq9MUkw0KBs7vGbG1vS6TOUK3KePtOmsJEge5pCt0E7vV8a6iv2y3qR7k5yHNCC80uvdPkzKsKd1iLSLiQOvn5L+3SFKKudQC/YU1/h9o85UwZljxU0GaQwwn7JkBzVZcIWNksN67s/iMv3f5Spk+DhKRHbeCI4/op5QW2sCdmXOrtxvT+m12UUA7dNhMkrTHrHPCS1ph2nidsk8stN/KG+4wJIRlhhI46eM/PkyTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nytqj6kK+1CFCF3WparGk2NKPIjakkl1iSmzK5piFno=;
 b=C5vEwyPe072ZBzK4aGdGt7/S2BMc93eIf61yfJDdmBeYtonJWpDBD4C8aS84+VxUAM1b+psgMJY4FX1zFoN7Fr8bogIZ95DLX0vUEE3dNfAiIULDJt5MEhFTeFHdIaXTT7lkFp7LUwqwBpa3xrtKY4Zq6r9aeEoPC5g5DGVgLfOAzW118wtPyn0JvXl4OPqRjaAZDXfQ1hL5k+HCyPun8jiubsOrQfEutkc70D8SYG0eqfW55eEr2VfOy9nOwjUCoZV9rF16sgHSdvOPFaE7pAXjXc8PBNjwKdnv4mM7R6E7RyDDkh1GwOdzNlY2N57XQc5ZRkf2GDXtgEV8zk7wbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nytqj6kK+1CFCF3WparGk2NKPIjakkl1iSmzK5piFno=;
 b=qV2rUe4trJW/iKHaiET+SvBhRtGFyaOmMYeoH45vI2VgprpVupc2rXiXCX88r+SS7dj0oXPimhsiD/eGAvX6xau8w703cBzeN5QfPwWym+MVXwRRzA2H8L3Ak8J1wUWU++n040mG2iWtaF1n1G1biJ2KCmIOwL8JoX9so0dk3bnQAscah1s/GINNwgQ+xVpM5orHX7eNdqdBLI5KsXUzhhRu9LZ3wFnp3D5PBZdBRCTTG21W/sIUScG4YWoX1BOR8VzPZdAhdtOQFZtIGRf4gSjqokGAGUhn48YxNN6M/8yySyNNAkYDm5xSlaf5c2AyOVI/qCXTJ8D6U7LQ4CSvDg==
Received: from MW4PR03CA0096.namprd03.prod.outlook.com (2603:10b6:303:b7::11)
 by MN2PR12MB4288.namprd12.prod.outlook.com (2603:10b6:208:1d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 07:30:49 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::2a) by MW4PR03CA0096.outlook.office365.com
 (2603:10b6:303:b7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 07:30:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 07:30:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 24 Apr 2023
 00:30:32 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 24 Apr
 2023 00:30:31 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>
CC:     <axboe@kernel.dk>, <josef@toxicpanda.com>, <minchan@kernel.org>,
        <senozhatsky@chromium.org>, <colyli@suse.de>,
        <kent.overstreet@gmail.com>, <dlemoal@kernel.org>,
        <kch@nvidia.com>, <johannes.thumshirn@wdc.com>,
        <bvanassche@acm.org>, <vincent.fu@samsung.com>,
        <akinobu.mita@gmail.com>, <shinichiro.kawasaki@wdc.com>,
        <nbd@other.debian.org>
Subject: [PATCH 0/5] block/drivers: don't clear the flag that is not set
Date:   Mon, 24 Apr 2023 00:30:18 -0700
Message-ID: <20230424073023.38935-1-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT007:EE_|MN2PR12MB4288:EE_
X-MS-Office365-Filtering-Correlation-Id: 393eb4b2-f453-49a0-b514-08db4495d383
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Na1GVKDne/1uX+ZvKLvZZcPgzCvfxFZkC/u+DjYsLc4MJEMLd6AxgN5jda7QrVSNt79tvofGVPxqEtr7Vf3tMAS1AwS5t0z9Kxe6BLl08UtiUkYS9clb14yyP2gmYCds5YKi6VoCIXrRwY8va3zmsi6q4Nnf5hI4yt8tjRh3JCLkMD2le7uejJiB6s9Ub7YXvLTdCsf77mLYvSG9dlYXCrZmM4Ir+3ua+/NsjZ/P2BnVhd718YhFuC3YpdCzDM51P+jFrpyPgTkmH/2r1sUYjVH6mX1oO8H2I/OJudcQPuwGyL3QyREHErC0Xos0mlg2QxUoh7uxZXjRqvOk4Gv4ZaPxiWkERO9VlBeY03lsjpkI8gvpowpAW2NW09/zJuma5COwSwOYPKl7q4d/qOS31Ch5rEoEOpRdm083TJKQtaz9a/f+XOIpEWzM282pD1yUjQRtpn6GI5BCTCMqzu6ZYZPOzK9D+K+xVN1dtVoqncW+5wkT7MDUrlVZjy5R2sCrUnfJADVJSApy/jcAWiRkla9i5pXliJDLl5xtW+nR7EKyFjl+qlpQ45TPre9TN1RN6Lr5fZxfLr3NEtLrMT1MYaO752Jlam3X5Z4tertpASDA343sSkRAUNWlSTuVTERiBGM02TZcEximuGAfGyKZjK6y1qpoHZKBB5SIXlKjzikh+aCb+ncPIYQrJazGJwrdizCjOYj5ZcxWkIuNXWqmIxN8iCYzhZ6ZYwyXDSnXEcTxUIbOVgoMFieud3ogX6tox3tPuZ2h1stE1qwIxV/pcg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(5400799015)(451199021)(46966006)(36840700001)(40470700004)(1076003)(26005)(40480700001)(336012)(426003)(2616005)(34020700004)(36756003)(83380400001)(36860700001)(47076005)(186003)(16526019)(40460700003)(7636003)(356005)(82740400003)(70206006)(70586007)(478600001)(8936002)(8676002)(54906003)(7416002)(110136005)(5660300002)(7696005)(41300700001)(30864003)(2906002)(82310400005)(4326008)(6666004)(316002)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 07:30:49.1560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 393eb4b2-f453-49a0-b514-08db4495d383
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4288
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

The drivers in this patch-series tries to clear the
QUEUE_FLAG_ADD_RANDOM that is not set at all in the queue allocation
and initialization path in :-

drivers/block/mtip32xx/mtip32xx.c:	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, dd->queue);
drivers/block/null_blk/main.c:	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, nullb->q);
drivers/block/rbd.c:	/* QUEUE_FLAG_ADD_RANDOM is off by default for blk-mq */
drivers/block/zram/zram_drv.c:	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, zram->disk->queue);
drivers/block/nbd.c:	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
drivers/block/brd.c:	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
drivers/md/bcache/super.c:	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
drivers/md/dm-table.c:	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
drivers/md/dm-table.c:		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
drivers/mmc/core/queue.c:	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, mq->queue);
drivers/mtd/mtd_blkdevs.c:	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, new->rq);
drivers/s390/block/scm_blk.c:	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, rq);
drivers/scsi/sd.c:		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
drivers/scsi/sd.c:		blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
include/linux/blkdev.h:#define QUEUE_FLAG_ADD_RANDOM	10	/* Contributes to random pool */
include/linux/blkdev.h:#define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)

Since sd is the only driver that sets this flag:-

drivers/scsi/sd.c: blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
drivers/scsi/sd.c: blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);

it is unclear how it will be set for null_blk, brd. nbd, zram, and
bcache in the allocation path so we have to clear it explicitly.

Remove the call to clear QUEUE_FLAG_ADD_RANDOM. Below is testlog for :-

null_blk
brd
nbd
zram
bcache

Below is the test log.

-ck

Chaitanya Kulkarni (5):
  null_blk: don't clear the flag that is not set
  brd: don't clear the flag that is not set
  nbd: don't clear the flag that is not set
  zram: don't clear the flag that is not set
  bcache: don't clear the flag that is not set

 drivers/block/brd.c           | 1 -
 drivers/block/nbd.c           | 1 -
 drivers/block/null_blk/main.c | 1 -
 drivers/block/zram/zram_drv.c | 1 -
 drivers/md/bcache/super.c     | 1 -
 5 files changed, 5 deletions(-)


* NULL_BLK:-
-----------------------------------------------------------------------

With this debug patch :-
@@ -2128,7 +2128,11 @@ static int null_add_dev(struct nullb_device *dev)
 
 	nullb->q->queuedata = nullb;
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, nullb->q);
+	pr_info("%s %d BEFORE ADD RANDOM = %s\n", __func__, __LINE__,
+			blk_queue_add_random(nullb->q) ? "TRUE" : "FALSE" );
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, nullb->q);
+	pr_info("%s %d AFTER ADD RANDOM = %s\n", __func__, __LINE__,
+			blk_queue_add_random(nullb->q) ? "TRUE" : "FALSE" );
 
 	mutex_lock(&lock);
 	rv = ida_simple_get(&nullb_indexes, 0, 0, GFP_KERNEL);

+ modprobe -r null_blk
+ lsmod
+ grep null_blk
++ nproc
+ make -j 48 M=drivers/block modules
+ HOST=drivers/block/null_blk/
++ uname -r
+ HOST_DEST=/lib/modules/6.3.0-rc7lblk+/kernel/drivers/block/null_blk/
+ cp drivers/block/null_blk//null_blk.ko /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block/null_blk//
+ ls -lrth /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block/null_blk//null_blk.ko
-rw-r--r--. 2 root root 1.2M Apr 23 13:00 /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block/null_blk//null_blk.ko
+ sleep 1
+ dmesg -c
+ modprobe null_blk queue_mode=0
+ dmesg -c
[33316.880281] null_blk: null_add_dev 2147 BEFORE ADD RANDOM = FALSE
[33316.880288] null_blk: null_add_dev 2150 AFTER ADD RANDOM = FALSE
[33316.880705] null_blk: disk nullb0 created
[33316.880707] null_blk: module loaded
+ modprobe -r null_blk
+ modprobe null_blk queue_mode=2
+ dmesg -c
[33316.920977] null_blk: null_add_dev 2147 BEFORE ADD RANDOM = FALSE
[33316.920981] null_blk: null_add_dev 2150 AFTER ADD RANDOM = FALSE
[33316.922640] null_blk: disk nullb0 created
[33316.922643] null_blk: module loaded
+ modprobe -r null_blk

+ modprobe -r null_blk
+ lsmod
+ grep null_blk
++ nproc
+ make -j 48 M=drivers/block modules
+ HOST=drivers/block/null_blk/
++ uname -r
+ HOST_DEST=/lib/modules/6.3.0-rc7lblk+/kernel/drivers/block/null_blk/
+ cp drivers/block/null_blk//null_blk.ko /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block/null_blk//
+ ls -lrth /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block/null_blk//null_blk.ko
-rw-r--r--. 2 root root 1.2M Apr 23 13:00 /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block/null_blk//null_blk.ko
+ sleep 1
+ dmesg -c
+ modprobe null_blk queue_mode=0
+ dmesg -c
[33316.880281] null_blk: null_add_dev 2147 BEFORE ADD RANDOM = FALSE
[33316.880288] null_blk: null_add_dev 2150 AFTER ADD RANDOM = FALSE
[33316.880705] null_blk: disk nullb0 created
[33316.880707] null_blk: module loaded
+ modprobe -r null_blk
+ modprobe null_blk queue_mode=2
+ dmesg -c
[33316.920977] null_blk: null_add_dev 2147 BEFORE ADD RANDOM = FALSE
[33316.920981] null_blk: null_add_dev 2150 AFTER ADD RANDOM = FALSE
[33316.922640] null_blk: disk nullb0 created
[33316.922643] null_blk: module loaded
+ modprobe -r null_blk


* BRD:-
-----------------------------------------------------------------------

With this debug patch :-
@@ -404,7 +404,11 @@ static int brd_alloc(int i)
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, disk->queue);
+	pr_info("%s %d BEFORE ADD RANDOM = %s\n", __func__, __LINE__,
+			blk_queue_add_random(disk->queue) ? "TRUE" : "FALSE" );
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
+	pr_info("%s %d AFTER ADD RANDOM = %s\n", __func__, __LINE__,
+			blk_queue_add_random(disk->queue) ? "TRUE" : "FALSE" );
 	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, disk->queue);
 	err = add_disk(disk);
 	if (err)

+ modprobe -r brd
+ lsmod
+ grep brd
++ nproc
+ make -j 48 M=drivers/block modules
+ HOST=drivers/block/brd.ko
++ uname -r
+ HOST_DEST=/lib/modules/6.3.0-rc7lblk+/kernel/drivers/block/
+ cp drivers/block/brd.ko /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block//
+ ls -lrth /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block//brd.ko
-rw-r--r--. 1 root root 381K Apr 23 14:09 /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block//brd.ko
+ dmesg -c
+ lsmod
+ grep brd
+ modprobe brd
+ dmesg -c
[ 3785.884916] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.884921] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.885320] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.885322] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.885662] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.885664] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.886270] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.886272] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.886451] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.886452] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.886621] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.886622] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.886831] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.886833] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.886990] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.886991] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.887176] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.887177] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.887368] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.887369] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.888011] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.888013] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.888212] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.888214] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.888687] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.888689] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.888911] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.888913] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.889390] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.889392] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.889585] brd_alloc 407 BEFORE ADD RANDOM = FALSE
[ 3785.889586] brd_alloc 410 AFTER ADD RANDOM = FALSE
[ 3785.890099] brd: module loaded
+ modprobe -r brd

* NBD :-
-----------------------------------------------------------------------

With this debug patch :-
@@ -1805,7 +1805,11 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	 * Tell the block layer that we are not a rotational device
 	 */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
+	pr_info("%s %d BEFORE ADD RANDOM = %s\n", __func__, __LINE__,
+			blk_queue_add_random(disk->queue) ? "TRUE" : "FALSE" );
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
+	pr_info("%s %d AFTER ADD RANDOM = %s\n", __func__, __LINE__,
+			blk_queue_add_random(disk->queue) ? "TRUE" : "FALSE" );
 	disk->queue->limits.discard_granularity = 0;
 	blk_queue_max_discard_sectors(disk->queue, 0);
 	blk_queue_max_segment_size(disk->queue, UINT_MAX);

+ modprobe -r nbd
+ lsmod
+ grep nbd
++ nproc
+ make -j 48 M=drivers/block modules
+ HOST=drivers/block/nbd.ko
++ uname -r
+ HOST_DEST=/lib/modules/6.3.0-rc7lblk+/kernel/drivers/block/
+ cp drivers/block/nbd.ko /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block//
+ ls -lrth /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block//nbd.ko
-rw-r--r--. 1 root root 998K Apr 23 14:09 /lib/modules/6.3.0-rc7lblk+/kernel/drivers/block//nbd.ko
+ dmesg -c
+ lsmod
+ grep nbd
+ modprobe nbd
+ dmesg -c
[ 3786.953726] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.953731] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.954877] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.954880] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.956753] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.956759] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.958118] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.958121] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.959372] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.959374] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.960139] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.960141] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.960878] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.960880] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.961558] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.961560] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.962303] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.962305] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.963063] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.963065] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.963821] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.963824] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.964573] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.964575] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.965282] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.965284] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.966067] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.966069] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.966851] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.966854] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
[ 3786.967544] nbd: nbd_dev_add 1808 BEFORE ADD RANDOM = FALSE
[ 3786.967545] nbd: nbd_dev_add 1811 AFTER ADD RANDOM = FALSE
+ modprobe -r nbd

* ZRAM:-
-----------------------------------------------------------------------

With this debug patch :-
@@ -2323,7 +2323,11 @@ static int zram_add(void)
        /* zram devices sort of resembles non-rotational disks */
        blk_queue_flag_set(QUEUE_FLAG_NONROT, zram->disk->queue);
        blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, zram->disk->queue);
+       pr_info("%s %d BEFORE ADD RANDOM = %s\n", __func__, __LINE__,
+                       blk_queue_add_random(zram->disk->queue) ? "TRUE" : "FALSE" );
        blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, zram->disk->queue);
+       pr_info("%s %d AFTER ADD RANDOM = %s\n", __func__, __LINE__,
+                       blk_queue_add_random(zram->disk->queue) ? "TRUE" : "FALSE" );
 
        /*
         * To ensure that we always get PAGE_SIZE aligned

[    9.020829] zram: loading out-of-tree module taints kernel.
[    9.030043] zram: zram_add 2326 BEFORE ADD RANDOM = FALSE
[    9.030047] zram: zram_add 2329 AFTER ADD RANDOM = FALSE
[    9.030579] zram: Added device: zram0
[    9.168858] systemd[1]: Created slice system-systemd\x2dzram\x2dsetup.slice.
[    9.544414] zram0: detected capacity change from 0 to 16777216
[    9.600893] Adding 8388604k swap on /dev/zram0.  Priority:100 extents:1 across:8388604k SSFS


* BCACHE:-
-----------------------------------------------------------------------

With this debug patch :-
@@ -971,7 +971,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	}
 
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
+	pr_info("%s %d BEFORE ADD RANDOM = %s\n", __func__, __LINE__,
+			blk_queue_add_random(d->disk->queue) ? "TRUE" : "FALSE" );
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
+	pr_info("%s %d AFTER ADD RANDOM = %s\n", __func__, __LINE__,
+			blk_queue_add_random(d->disk->queue) ? "TRUE" : "FALSE" );
 
 	blk_queue_write_cache(q, true, true);

+ makej M=drivers/md/bcache
+ modprobe null_blk queue_mode=2 nr_devices=2 memory_backed=1 gb=1
+ insmod drivers/md/bcache/bcache.ko
+ bcache make -B /dev/nullb0 -C /dev/nullb1
Name			/dev/nullb1
Label			
Type			cache
UUID:			0694b66e-970e-49e2-ab2c-791f84a53b8e
Set UUID:		e8be54f6-18c9-4965-b406-63e602201395
version:		0
nbuckets:		2048
block_size_in_sectors:	1
bucket_size_in_sectors:	1024
nr_in_set:		1
nr_this_dev:		0
first_bucket:		1
                                ...
Name			/dev/nullb0
Label			
Type			data
UUID:			8a64d20c-12ce-4ca5-a9fb-f978bfba52df
Set UUID:		e8be54f6-18c9-4965-b406-63e602201395
version:		1
block_size_in_sectors:	1
data_offset_in_sectors:	16

+ echo /dev/nullb0
+ echo /dev/nullb1
+ dmesg -c
[ 3788.828220] null_blk: null_add_dev 2147 BEFORE ADD RANDOM = FALSE
[ 3788.828227] null_blk: null_add_dev 2150 AFTER ADD RANDOM = FALSE
[ 3788.829617] null_blk: disk nullb0 created
[ 3788.829699] null_blk: null_add_dev 2147 BEFORE ADD RANDOM = FALSE
[ 3788.829701] null_blk: null_add_dev 2150 AFTER ADD RANDOM = FALSE
[ 3788.830484] null_blk: disk nullb1 created
[ 3788.830485] null_blk: module loaded
[ 3788.863458] bcache: bcache_device_init() bcache_device_init 974 BEFORE ADD RANDOM = FALSE
[ 3788.863462] bcache: bcache_device_init() bcache_device_init 977 AFTER ADD RANDOM = FALSE
[ 3788.863491] bcache: register_bdev() registered backing device nullb0
[ 3788.864156] bcache: run_cache_set() invalidating existing data
[ 3788.866970] bcache: bch_cached_dev_run() cached dev nullb0 is running already
[ 3788.866976] bcache: bch_cached_dev_attach() Caching nullb0 as bcache0 on set e8be54f6-18c9-4965-b406-63e602201395
[ 3788.866990] bcache: register_cache() registered cache device nullb1
+ sleep 1
+ bcache unregister /dev/nullb0
+ bcache unregister /dev/nullb1
+ sleep 1
+ modprobe -r bcache
+ modprobe -r null_blk

-- 
2.40.0

