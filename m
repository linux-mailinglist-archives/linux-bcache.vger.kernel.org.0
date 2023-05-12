Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E87700450
	for <lists+linux-bcache@lfdr.de>; Fri, 12 May 2023 11:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbjELJy7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 May 2023 05:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240507AbjELJy6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 May 2023 05:54:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D905410E49
        for <linux-bcache@vger.kernel.org>; Fri, 12 May 2023 02:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifLXisJ5kYnAiZsh1ULZkJvNa7jKBfgTITA2maz4yuYp/xwX76EW0xxFmnWSD0+hxHQVPBNWBQqAV8dd4JiN6FvdemjuKz+Tr8JdWNadH7D5Af4pumAZUIV0OZZh8dlU72QqEwgcyN8dJda7YBNIJEkBbbpqpzIujas5tHZmPBA+QNwmKgiQMAMyQv3rd0BPXHdw55OXsAvusmY8Zdt3wMoQpiCocSNzQtGUhqAWzPpbuK600FW6eF4Ru4vd+BrpJ/aJiJUijSRVAC/RE805Vg7kM/4qp9oHHivujHwDvZZaxmry1ykzZZPdISbTFygAwCqtuAyVOV+C83TbHEWWzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K/HRhgFxTpuAHYd4wuZTrPyuUT6gVSgnpPksUUXVxms=;
 b=CtiBWI494gZF8yHcO1TUmAq1fhGF7sFAHYkXPs3gM70y8H3rh9/4RLfYbvlAqga9rXspfFs6JOg6cKMmAaepyMIGjZsticMAsDgrYVhQ6zlaBRS0XmCVgxbg52NBfazJMeCc4TR9PLyfVRNiGdG6F7aHLefmxbueXMj7x6Le49jhHp5Fh1hdFYfCi7f+zrvNZqeSTDQmGYJjwxnEfkz2cTQb55fbCb1Jt0Yvuzva4HrxK8DoUb+EdLwNR2WT7a1gtYGzENZtJ4qxTcXBaoO85MigJw9rXIDv1VXOmNE2kw86pOwqm6eqqOxiFiHDQt+3HzNKQH0kLdtNfavQrlwpEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=suse.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/HRhgFxTpuAHYd4wuZTrPyuUT6gVSgnpPksUUXVxms=;
 b=HuX8/C88xcFt/aDuog/VlAGJEUg1DdbXbdTziEgU4b7YvN9rvpFkUXBRlPnYKJOMTWK+2rwhcyEmAUBFjZZA0WrYT60W0srbrU7/VUEg9C3Xwd1cxYuRjlCUSTCv/EVVEdDNsFFNisjgbgcottr31IrvsvMEksisRNNQkxiUmA0F3IbqsNQ6J4qjboug7y0Zod0Wcqne5u73lEjPUV4MqpTOG5fdD0eExMAJRaOQ9ysEnVeXZsBnKWANXOC8cZKaisNIgBh2gwoRawh6L/i17ZyCMgqFkWri4qGadFumU17oZTUl+xFlDB3hnRcZNEF48R4cei9ezd4hKuVwZCrkAg==
Received: from BN9P220CA0028.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::33)
 by CH3PR12MB7594.namprd12.prod.outlook.com (2603:10b6:610:140::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Fri, 12 May
 2023 09:54:49 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::9c) by BN9P220CA0028.outlook.office365.com
 (2603:10b6:408:13e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24 via Frontend
 Transport; Fri, 12 May 2023 09:54:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.24 via Frontend Transport; Fri, 12 May 2023 09:54:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 12 May 2023
 02:54:38 -0700
Received: from dev.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 12 May
 2023 02:54:37 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <colyli@suse.de>, <kent.overstreet@gmail.com>
CC:     <linux-bcache@vger.kernel.org>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 1/1] bcache: allow user to set QUEUE_FLAG_NOWAIT
Date:   Fri, 12 May 2023 02:54:20 -0700
Message-ID: <20230512095420.12578-2-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230512095420.12578-1-kch@nvidia.com>
References: <20230512095420.12578-1-kch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|CH3PR12MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: 8003ce0b-29e2-4202-7704-08db52ceed02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x5bA0bicI1KIrY83qSrUMWRWJcjvN3SHXmQczGX/SV2XUnIJsH+Zp1BMek8F7FWaHpl5Yc+TZePEexa9if43CdbMqvHydVSe06TfV+cHUQHH1X3gYZvUgYlYyFltY9+OamAfFLLuW2Vnyk8V4PcEMmV38E6mHSyusdECPOz3Ch+cYtgXViSBuDlddllZlOIm+SKleVkj8cmZLWwrLeZ/VEc61hKFn0fk9Yy6fNBLNmWXaj9JQc2u9V4/Rp6Rzod8aVYakyJFOEXUP6MxjiNc3WUdi8+P+amhIjA0fgtPtgB5pXJ2H02D8nPfeIJlYr494q9R0p49dwRAysl7dnLjVUS2bRGotvg2Tr5vlBMmshIsB+aqYNEAWsT4jEF5/4p43O5/IuuQyxJmBKAbAILDV1pD2xC1DrLTq1AYEADUPbKmqpECEQ6VvvpzA3aVquCAmK2rEOvbxskVSLJNuFWXgAcVZjsCycqrc0W/zqha5kqgWlbUKbI9UCpvbE17ksNPfm14jyp2wPy7iZcLULJx7QDiziPDLg2ZF7jXA2neItrOAULRNKT2Wma5VLVCfCg0vAfc985+reTEEcz93DW5Jgf/kupCDS5jwOVGAOSbL8FNbryB/7eQsNkYEprAGIfoTAnAlzJQNoi15h7LFLcLVSbEFz2IT3y5QerA7HJQmdM35Eu7mouog4HKRl4HZJcs45aWSWS77rqIrLNfRwNNOaYs733YXvTRLP8q/xPuz3radq2p6RNMQPe+GfAXjxyW
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199021)(46966006)(36840700001)(40470700004)(82310400005)(40460700003)(7696005)(54906003)(110136005)(316002)(41300700001)(6666004)(36756003)(478600001)(70206006)(70586007)(40480700001)(1076003)(83380400001)(26005)(2616005)(186003)(16526019)(82740400003)(426003)(336012)(7636003)(356005)(5660300002)(8676002)(8936002)(47076005)(2906002)(4326008)(36860700001)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 09:54:49.4440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8003ce0b-29e2-4202-7704-08db52ceed02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7594
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
parameter to retain the default behaviour. Also, update respective
allocation flags in the write path. Following are the performance
numbers with io_uring fio engine for random read, note that device has
been populated fully with randwrite workload before taking these
numbers :-

* linux-block (for-next) # grep IOPS  bc-*fio | column -t

nowait-off-1.fio:  read:  IOPS=482k,  BW=1885MiB/s
nowait-off-2.fio:  read:  IOPS=484k,  BW=1889MiB/s
nowait-off-3.fio:  read:  IOPS=483k,  BW=1886MiB/s

nowait-on-1.fio:   read:  IOPS=544k,  BW=2125MiB/s
nowait-on-2.fio:   read:  IOPS=547k,  BW=2137MiB/s
nowait-on-3.fio:   read:  IOPS=546k,  BW=2132MiB/s

* linux-block (for-next) # grep slat  bc-*fio | column -t

nowait-off-1.fio: slat (nsec):  min=430, max=5488.5k, avg=2797.52
nowait-off-2.fio: slat (nsec):  min=431, max=8252.4k, avg=2805.33
nowait-off-3.fio: slat (nsec):  min=431, max=6846.6k, avg=2814.57

nowait-on-1.fio:  slat (usec):  min=2,   max=39086,   avg=87.48
nowait-on-2.fio:  slat (usec):  min=3,   max=39519,   avg=86.98
nowait-on-3.fio:  slat (usec):  min=3,   max=38880,   avg=87.17

* linux-block (for-next) # grep cpu  bc-*fio | column -t

nowait-off-1.fio:  cpu  :  usr=2.77%,  sys=6.57%,   ctx=22015526
nowait-off-2.fio:  cpu  :  usr=2.75%,  sys=6.59%,   ctx=22003700
nowait-off-3.fio:  cpu  :  usr=2.81%,  sys=6.57%,   ctx=21938309

nowait-on-1.fio:   cpu  :  usr=1.08%,  sys=78.39%,  ctx=2744092
nowait-on-2.fio:   cpu  :  usr=1.10%,  sys=79.76%,  ctx=2537466
nowait-on-3.fio:   cpu  :  usr=1.10%,  sys=79.88%,  ctx=2528092

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/md/bcache/request.c | 3 ++-
 drivers/md/bcache/super.c   | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 67a2e29e0b40..2055a23eb4b7 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -716,9 +716,10 @@ static inline struct search *search_alloc(struct bio *bio,
 		struct bcache_device *d, struct block_device *orig_bdev,
 		unsigned long start_time)
 {
+	gfp_t gfp = bio->bi_opf & REQ_NOWAIT ? GFP_NOWAIT : GFP_NOIO;
 	struct search *s;
 
-	s = mempool_alloc(&d->c->search, GFP_NOIO);
+	s = mempool_alloc(&d->c->search, gfp);
 
 	closure_init(&s->cl, NULL);
 	do_bio_hook(s, bio, request_endio);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 7e9d19fd21dd..f76822bece26 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -28,6 +28,7 @@
 
 unsigned int bch_cutoff_writeback;
 unsigned int bch_cutoff_writeback_sync;
+bool bch_nowait;
 
 static const char bcache_magic[] = {
 	0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca,
@@ -971,6 +972,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	}
 
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
+	if (bch_nowait)
+		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, d->disk->queue);
 
 	blk_queue_write_cache(q, true, true);
 
@@ -2933,6 +2936,9 @@ MODULE_PARM_DESC(bch_cutoff_writeback, "threshold to cutoff writeback");
 module_param(bch_cutoff_writeback_sync, uint, 0);
 MODULE_PARM_DESC(bch_cutoff_writeback_sync, "hard threshold to cutoff writeback");
 
+module_param(bch_nowait, bool, 0);
+MODULE_PARM_DESC(bch_nowait, "set QUEUE_FLAG_NOWAIT");
+
 MODULE_DESCRIPTION("Bcache: a Linux block layer cache");
 MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
 MODULE_LICENSE("GPL");
-- 
2.40.0

