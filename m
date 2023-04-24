Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2CB6ED8E8
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Apr 2023 01:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjDXXqv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 19:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDXXqu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 19:46:50 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11hn2236.outbound.protection.outlook.com [52.100.173.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C5A49EB;
        Mon, 24 Apr 2023 16:46:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGydIZoaQDWwItCfulzG3AAh/eC6vLWh9Yh1G8WQNvJl+1ujvZRN7QuAUi/2fKfDSQICc9U4Vri200Ho9L3rx9CQMiQGbQZT82Cvo14VxmSjZ/v2hWrjfvhMJotDFyawLsas0oqAART6CFWtgJUjQLRYyMqEP2EGXG794Z3qI0dYF9LAyG0uow4LCplibjz5U9LlfxlyDyiOoZqzU55zipmYux3sbMvgOAc5XDNrqOI6YMjbvIaHeMXR/M8C+c5SSUobZjGxlQDYfJx0wRJJKDDs/iUJcS6Uigr0iwJr+vNoxPeJykZAD+tf/3UtgI0VWF3I0iTDXar4mHu/yuQFuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yiJD4v5m8X2jnGV66plZkzk8wuSXoQWl73a4wj4kKZA=;
 b=SARyld5s4CAFWBa78CmVo38xuj6Nc/1pwAr/pzu4oSHkF/QbjCJ8yeaW72P1K7xazOaFwBV0y5tk99nMFKSRCajd5T2A3GhgqtS2+/COqoqY1AUq79Q1qCfBVNOR3xi3g9SFeeaQkDXkc3HTksxj4kf9I/zkNW7aFt0DhV6XQpADtjawWO8JowSnt8mJ32YpJmhCRu5NxHoj4wb/S/1bWlI5dFEj3j0YsMh22Fi2aPD5mkA+3GxefHncrKbcFc/VTfJMMfLDXcobjyDQTFiD8T2yYbPmbkq+NYzDx8k5d3XITDi+dXtwNLWVr/w1Rgo8YN4oT1S3WnZlVTzTJNTpgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yiJD4v5m8X2jnGV66plZkzk8wuSXoQWl73a4wj4kKZA=;
 b=eYU+9hMBXmK0sBZg9Tke2tAYLU37jMTiOAIDmK/e0hXlgpQVSB57g+wf6l96N5qkkOeel7UoujMPP/USfjeKUcpVxbWHJDPYaUgMGT7EvyEmGQW2sRbiYA8C0+Odgp38Xkx/MHMiRUkudietx/FJlA8aL4ZBNqsUKuHlaqcfSOm8YSavFEendA/vfeupRyKK6eJnyrZb3dlT3opnEWLfWz52v+JS0tvQ7/Vxrkjfprldz7zwgZjDU+WBha7OAC+fJVkfhqYdWWRE3RXpwkB+AH7n03ax7PiKCSO6d6wjdWE35/oooFmERXHCss1yKbGK/Jwx8Uh2AOsTs8juJeXOYA==
Received: from BN0PR04CA0119.namprd04.prod.outlook.com (2603:10b6:408:ec::34)
 by SN7PR12MB7954.namprd12.prod.outlook.com (2603:10b6:806:344::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.28; Mon, 24 Apr
 2023 23:46:45 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::ac) by BN0PR04CA0119.outlook.office365.com
 (2603:10b6:408:ec::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 23:46:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 23:46:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 24 Apr 2023
 16:46:36 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 24 Apr
 2023 16:46:35 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>
CC:     <axboe@kernel.dk>, <josef@toxicpanda.com>, <minchan@kernel.org>,
        <senozhatsky@chromium.org>, <colyli@suse.de>,
        <kent.overstreet@gmail.com>, <dlemoal@kernel.org>,
        <kch@nvidia.com>, <johannes.thumshirn@wdc.com>,
        <bvanassche@acm.org>, <vincent.fu@samsung.com>,
        <akinobu.mita@gmail.com>, <shinichiro.kawasaki@wdc.com>,
        <nbd@other.debian.org>
Subject: [PATCH V2 0/1] block/drivers: remove dead clear of random flag 
Date:   Mon, 24 Apr 2023 16:46:27 -0700
Message-ID: <20230424234628.45544-1-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT035:EE_|SN7PR12MB7954:EE_
X-MS-Office365-Filtering-Correlation-Id: b230b308-e977-432a-4257-08db451e29be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XW32v+aW2yyPwoTtQVAnQV1tz6PSB7BYQEaJgqWPkUzVCF6lzPbVqoQZsni1P/I/tWY+NSBeUUsl9cdLzoXyZyqtZfIuQpFVEgfecd1d8m88fGUtaSe6kA7nFXQ0ewV3BqZCKdURLebryHN5sNRvAlLTDi50glbWUrqkwfE5MYXUOm4nD+T35rRbKMNR9Vv67lJMk9yl86iZ61pY7GfB9ctSoeA2QtGEmVQWYfwgQJ8ErdgkL8meIhJ4bqYb84KCkxbE8/3ZIrmTT2rr/7UCCGPMUmVcFf8dAp1oxYOXwn6yDCCK+GH6WjPqs51YWRAlrwhw2vbsSpzTTEZ/BWB3FA/euSjgE/vLNWK9Eczkpz16VrV16IaxV449qoI+9D/lVqELi9fY2gw9E0ecad81yhKi5Qnik57nteEmP0KfHwQe/sDELKSjxmyYjS2gu0TDXdAAttSF1/F8putiOn4jexsveTz1hD/C6BwUFKziDcNY0b6NZNST5cCm/zMf1noFehWx4Wov9ODL1di1oR8hIfAbLW6t+IHOhmFK1mzv3WezFG9ZGfSBFFf+oGfz0QpySu/5uE92dpUQuexYmck3Delz2Lc7c2JkX48QwgpGLdHjmW22LVzg32iJweq9kmNgt1Z7DAgL28rwpE2/mbaKXhzKuRC3gL31ja6JaTRK6Y28OtskhLQ33KOCqR7DmpC2zmaHm0LjkdhauCh92zqukCCjbACKM7RSxSs0YXMI2UItuBJL36FRpwSg0FiMrTrpoQHb6LrTEU2jJIlW5njyBA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199021)(5400799015)(40470700004)(46966006)(36840700001)(47076005)(16526019)(186003)(1076003)(26005)(4743002)(40480700001)(7636003)(82310400005)(356005)(83380400001)(2616005)(336012)(426003)(34020700004)(36860700001)(2906002)(7416002)(36756003)(8676002)(30864003)(478600001)(40460700003)(7696005)(6666004)(110136005)(54906003)(82740400003)(4326008)(70206006)(8936002)(316002)(5660300002)(41300700001)(70586007)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 23:46:45.2696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b230b308-e977-432a-4257-08db451e29be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7954
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

The drivers in this patch-series clear QUEUE_FLAG_ADD_RANDOM that is
not set at all in the queue allocation path in :-

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

Remove dead clear of QUEUE_FLAG_ADD_RANDOM. Below is testlog for :-

null_blk
brd
nbd
zram
bcache

-ck

V2:-

1. Add everything into one patch.
2. Change patch title and update commit log.

Chaitanya Kulkarni (1):
  block/drivers: remove dead clear of random flag

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

