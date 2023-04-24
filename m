Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFAD6ED8EA
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Apr 2023 01:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjDXXrM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 19:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDXXrL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 19:47:11 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02hn2247.outbound.protection.outlook.com [52.100.159.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AE84C16;
        Mon, 24 Apr 2023 16:47:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuUURtoXrNFWSbmrgxWeoT0kDZI0VDIwkN0JX2i0WJJic9Tf5A8fDKUVdjJW+Q/mF8pUUZe4Q/ngpuO4nTGetAghwgl8lO5Bu4is8dJDcVv3hUHxGdO0in8tGDU++zwrltE3qs5hoY8Grr5/D02O8lW2lS4Z+9ZJXvCuPNh54IwlyZ0ssyCD8HpzaH6UWulsrN7Z9FgQHBf47EP2SzQ3ufJhcpF8vxF5VaO/B7Va2HJIt6R7Tus01fiz9u9v+AcBL2L1YsfqqUFReTR7eVUccIESlHHk48KJZYn6E+wP9QD1wfl7vShrAWqlmR684qzinjCD6y86lT+x46YHtDe5Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9dIBZX7SiqUuBdxOVVxTz9CAEnCnRQIcPLF0MLWPRR0=;
 b=MefepV/e4F8yShXH6JdE4PEWn6pmnK/MDFMkSQYAIZn1r/MrvrG4H0foaoAFByCD3MNuwkL2crZmijmBTpqUMc4XvNKacNhHckPb0SP0PqSZvqujr0OPXlfseQOX2OqJPRTSj/McJhVC8QMZft7XHsqJ5YR92HBw71gOvJLfg9VbgKzSTGpQ3uL87JvdG32ZEM+QfRC5Ucy2WH76WU7wfqhGKumlgEIUC8Hm+TvSiWe/gLLe+9hD22SSQEgiTIwSgQ3MrMUok1GJ/ycCJEjXdKDdQMu5ER3M4bLnECGQ+6+s69hRHM53jA/4DQHPHyiIxDGbTidtrm74ec2XmGh+EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dIBZX7SiqUuBdxOVVxTz9CAEnCnRQIcPLF0MLWPRR0=;
 b=jJklhVQU/hMYELGz06W3owLlfWtkBXeyYyywmsX77EIcBd8rUw2zI2r4V7YBV1TSZoFo5zJXMclqRCt1EXuNX8otlyN4qCX3zJmKAL+IhOYdHNxC8pDcz1sYJTs2ovWvuutg0adHFjtCiJcYc4g+Obc/Q5Xfq6JbeByP1Cs7hYDIMYzcY/TxdXw3aYWQ+0oIBYjM8IlfvBbqiiXLZ5qBkJYHgHvR9nmNMuwV8zOXwJdk04mUd9Hx24bBQYYJ9KD32pb1lmvro0p/qbP2BXHCJsr1Qs/JdoqxfKyppSca8/FMZP73GJ4N3+NmCr1+Yd5aM2a/MNcS8KgtYO3EWXROSA==
Received: from BN1PR14CA0027.namprd14.prod.outlook.com (2603:10b6:408:e3::32)
 by DM6PR12MB4434.namprd12.prod.outlook.com (2603:10b6:5:2ad::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 23:47:03 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::48) by BN1PR14CA0027.outlook.office365.com
 (2603:10b6:408:e3::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34 via Frontend
 Transport; Mon, 24 Apr 2023 23:47:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 23:47:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 24 Apr 2023
 16:46:48 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 24 Apr
 2023 16:46:47 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>
CC:     <axboe@kernel.dk>, <josef@toxicpanda.com>, <minchan@kernel.org>,
        <senozhatsky@chromium.org>, <colyli@suse.de>,
        <kent.overstreet@gmail.com>, <dlemoal@kernel.org>,
        <kch@nvidia.com>, <johannes.thumshirn@wdc.com>,
        <bvanassche@acm.org>, <vincent.fu@samsung.com>,
        <akinobu.mita@gmail.com>, <shinichiro.kawasaki@wdc.com>,
        <nbd@other.debian.org>
Subject: [PATCH V2 1/1] block/drivers: remove dead clear of random flag
Date:   Mon, 24 Apr 2023 16:46:28 -0700
Message-ID: <20230424234628.45544-2-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424234628.45544-1-kch@nvidia.com>
References: <20230424234628.45544-1-kch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT031:EE_|DM6PR12MB4434:EE_
X-MS-Office365-Filtering-Correlation-Id: 765a9e82-eae1-4d87-ba4c-08db451e347a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HC4Y2vfLGuCIhPTHvUoLviViEg8i1CkXg6cCMIsJuExlvg8Ao9xEEDB0fg7vHbfDTKjvjn3t+5ACQXaDkp8Zfte23VEIKCLsliWpWhpFyGDzYDNajrztOKvY1n0PmIVYBtrrRro8SaX7Qzaq5APOgT2nqOjgEJLzAW+7tgN1S+6tQiNnCznNgFx2kkBf5VafDpn7nul8DM4P03//iHbY3L4awNkdeXhpu7ichoTcrNJR9RCh412HVpyTFRbW/G61Q/96yDcGjzlq/nBXdFxik4xJw5pccmVnr4mSQgksdXwjNEipSbbgDL++Eei9PhA6+9kayWeFCrZVqWRQYRQcPxjWRKz/oSzNho+eZMtXxalIiygAsIjCDsWK+e6oNufAv1CDGe6aBG0CwgJvBEv66PvvOEwSvcm2SWHxkBeQyvXedyyufrZhelfrv3EA9Q5/KF8WTL8/90ESznGjOh2oJ+kdEkZP/fcGcjN3r4ZUv+rsbYKwtdDYEaCfD5xvqgUzN4U/s6ytF92b0KRO0JGqxfwfJupqpJ5CdTOmRH9sxzIvJJRp0Xos0N0nev8XYC97Ky2YsO9YJW79iWlLdqCSpTZQ7SKw1LA9bQ6GaNpXn4eo0KQBVz13ojtBKpAqBOVpWDYEn9oBJg/mypeEPIRSwkG3KITuwqhmIQqCdJkEr3Yhj7Xm/fCorYpwd/3sppoEupLL5BN/EQ5MaMCwBTHaGUiq2QVMwu4Ug8tn6HLBi0rXcMDXUOghd6pp6SGUqLojGwqCxJsx4aomr0F6RC7WVw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(39860400002)(5400799015)(451199021)(40470700004)(46966006)(36840700001)(2906002)(7696005)(2616005)(6666004)(16526019)(186003)(40480700001)(1076003)(70206006)(70586007)(8676002)(8936002)(41300700001)(4326008)(316002)(26005)(478600001)(7416002)(5660300002)(54906003)(110136005)(82740400003)(356005)(7636003)(82310400005)(36756003)(40460700003)(36860700001)(47076005)(336012)(426003)(83380400001)(34020700004)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 23:47:03.2819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 765a9e82-eae1-4d87-ba4c-08db451e347a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4434
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

QUEUE_FLAG_ADD_RANDOM is not set before we clear it for "null_blk",
"brd", "nbd", "zram", and "bcache" since by default we don't set
"QUEUE_FLAG_ADD_RANDOM" to MQ ops.

Remove dead clear of QUEUE_FLAG_ADD_RANDOM in above listed drivers.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/block/brd.c           | 1 -
 drivers/block/nbd.c           | 1 -
 drivers/block/null_blk/main.c | 1 -
 drivers/block/zram/zram_drv.c | 1 -
 drivers/md/bcache/super.c     | 1 -
 5 files changed, 5 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 34177f1bd97d..bcad9b926b0c 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -404,7 +404,6 @@ static int brd_alloc(int i)
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, disk->queue);
-	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, disk->queue);
 	err = add_disk(disk);
 	if (err)
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index d445fd0934bd..7c96ec4e99df 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1805,7 +1805,6 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	 * Tell the block layer that we are not a rotational device
 	 */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
-	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
 	disk->queue->limits.discard_granularity = 0;
 	blk_queue_max_discard_sectors(disk->queue, 0);
 	blk_queue_max_segment_size(disk->queue, UINT_MAX);
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index b195b8b9fe32..b3fedafe301e 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2144,7 +2144,6 @@ static int null_add_dev(struct nullb_device *dev)
 
 	nullb->q->queuedata = nullb;
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, nullb->q);
-	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, nullb->q);
 
 	mutex_lock(&lock);
 	rv = ida_simple_get(&nullb_indexes, 0, 0, GFP_KERNEL);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index aa490da3cef2..f7d4c0d5ad0d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2323,7 +2323,6 @@ static int zram_add(void)
 	/* zram devices sort of resembles non-rotational disks */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, zram->disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, zram->disk->queue);
-	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, zram->disk->queue);
 
 	/*
 	 * To ensure that we always get PAGE_SIZE aligned
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..7e9d19fd21dd 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -971,7 +971,6 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	}
 
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
-	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
 
 	blk_queue_write_cache(q, true, true);
 
-- 
2.40.0

