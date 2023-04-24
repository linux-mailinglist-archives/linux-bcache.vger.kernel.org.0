Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596B66EC71E
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Apr 2023 09:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjDXHbM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 03:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjDXHbL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 03:31:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10hn2223.outbound.protection.outlook.com [52.100.155.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22031E7F;
        Mon, 24 Apr 2023 00:31:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwZwVcQvenKQT8J+iyTrgX0wFoX0UMpqDoPl2onOtolmYu00pAEDnHmTqu9x15QvhOF0vSmxO1aFbEVkh+3UvBLfn33CZeH9+742Ka+fPJlL+lT33cWaB5EveCg3qHHPwmCvakdiB/7d/1XBHVnvHN8QPPUQvpFdC++ktin+fhoSZeRwJ7mAgdv4C/uWx4WroeZyZ2bBqyC1YXMP2wqNM3GPb7xKzon59hovC+QkpyLv1I9JwEbyhds2QULuhY6NKx4lIcvuBrWQ2GQx4cvGwHmRhsV2ifr7AGhaPXz4Fx0w+Td1yexdLtAsOEGRPKoZNfhiOFc/CketsYubHeZz1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AV4fsN2/gyKEGzHc8V0wf1SYvMoUEZfiB3frDpCdd28=;
 b=AMT0nne0HVjavlNh+i9YwURYDHW5TX3PqLp78/ql8PJj7wWgNhuIIoCkc74wXynNOtWkQYTRbRe3lp3nflpgHmNmBi0i8D/k0JupA4LSDNdaywVh03J2PwqL7W0jBk/Axip70apvl1nGPmcYea15t5040mBy0KSx4yHxiUO3Y+HGC6/HUlNAObqUXj4xJPSv+AlNTSjOQI8eo+YMZpdXhy+j1r662ZuXNOkO4N4k+RRoH7cE4ycmM44PM7Rzo4//LAC1BAE6g3SyTouCIQYFWazziREW+N5rBWXXPUhsy/Bg+8fNd7uv/LJIwAoCCIUwTLoV/kVVSX9MGrqYdfFT0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AV4fsN2/gyKEGzHc8V0wf1SYvMoUEZfiB3frDpCdd28=;
 b=hcQAiUXYD6NqHNgu5i1BzDmeswEDC7xpq8sdgtKPHuswPC0LvHc52YgNjrXWrAjMlHYkEwaArdtMcfNtE2LRLifhI81T5Rc884Zeo+lBqueLvPqVs2LuKcutY/36vcD9yM7N05NDSYxthxOJA+F4FAdD/kZP+05flhBfoeiARCsEpaQkqZSBSFn1Rn533xOZhsuqj9DMhK7/kzS+oMSH7riBQpqKvTnlHHWz103izzPTT3Mo6hEI1C/dJySvWAL+uqlMfCIHi9de3accuF+Fw4lv+W4zKGznAl5YkmRHE/IX7pUkiEjkArEFhM54xtxVuy8S6+HDgz6KNSppuuKntQ==
Received: from DM6PR02CA0058.namprd02.prod.outlook.com (2603:10b6:5:177::35)
 by PH8PR12MB7111.namprd12.prod.outlook.com (2603:10b6:510:22d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 07:31:07 +0000
Received: from DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::f7) by DM6PR02CA0058.outlook.office365.com
 (2603:10b6:5:177::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 07:31:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT109.mail.protection.outlook.com (10.13.173.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 07:31:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 24 Apr 2023
 00:30:54 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 24 Apr
 2023 00:30:53 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>
CC:     <axboe@kernel.dk>, <josef@toxicpanda.com>, <minchan@kernel.org>,
        <senozhatsky@chromium.org>, <colyli@suse.de>,
        <kent.overstreet@gmail.com>, <dlemoal@kernel.org>,
        <kch@nvidia.com>, <johannes.thumshirn@wdc.com>,
        <bvanassche@acm.org>, <vincent.fu@samsung.com>,
        <akinobu.mita@gmail.com>, <shinichiro.kawasaki@wdc.com>,
        <nbd@other.debian.org>
Subject: [PATCH 2/5] brd: don't clear the flag that is not set
Date:   Mon, 24 Apr 2023 00:30:20 -0700
Message-ID: <20230424073023.38935-3-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424073023.38935-1-kch@nvidia.com>
References: <20230424073023.38935-1-kch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT109:EE_|PH8PR12MB7111:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b676bca-0e25-4339-33b4-08db4495dde2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s/jAKn7lRuv2IxC4xA81zf7h5CpmjCFSuUAucHps9S30ShFiYZQIwB5TZt4dNVoCCzbNyt9O8asPVcNR3ea2/eDgaq+k/rCajwIGx3WBgQxrefQwNDosZasUJe+OUOGBh3j1GuggC9BrXHn0EqGqIsleOPShb8QFwhYNGSA6y8nXEPOD8HuGD4s3iPGztNDjXW3rPRvh9mus5yIDp1LPj4V4PZiVDID8WM4v2J8AIf5es08ubMRgZwSkl3VVR67OyiwknlM+YN2Br7TVkKesA8MekyLFQ6/nas03Gq9vf7gSwsl/htn/IIEqvJ2zb5GJHp5MtRVDwKgtZ8W0YWibvuW4jsvFU0EfxsxXc2WIo/bQnxquyyXIlgoSzSa6n5odt1WLvsGlWUbgXfjDr0hJw4f+ydszhmCRUaJ3WBayjp+f9Fbxl6xgujvbzRJUi5aKht4VlDX7yHcGFq1ZDCi6SMBqmbDBLYWr4dGEy01wTfZfwxn3afuo0iuc6mRU2rHEToUNXuGOdwYc2F3BEpMIl9XDRW+uyEEpCymKOIOcl25b+/4QbXYqxSWB5TO53Irj1hdb7oeS5DrVBq89OkmVgXBSWtaV/vETLRovQecIdZGRzOn7/T4gjvZhkOjQ0Iix5qE2wTqExtt8L6DAi5Jay53AYNWbGA4jU1kpbX/X872P+POTXp5CHu23z5wdC1XHoy4U8xJiHXE/7QqEaQ0wBCA7N6s1LuC+CK74ye7Q9M+7I4RBJ0g4MUpkdhUw23bHR4SY5T15ZD/JgeRTT6fZFg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(376002)(5400799015)(451199021)(36840700001)(46966006)(40470700004)(2906002)(4744005)(7696005)(2616005)(6666004)(16526019)(1076003)(26005)(186003)(40480700001)(70586007)(70206006)(8676002)(8936002)(316002)(41300700001)(4326008)(478600001)(5660300002)(7416002)(54906003)(110136005)(82740400003)(356005)(7636003)(82310400005)(36756003)(40460700003)(36860700001)(47076005)(426003)(336012)(83380400001)(34020700004)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 07:31:06.5055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b676bca-0e25-4339-33b4-08db4495dde2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7111
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

QUEUE_FLAG_ADD_RANDOM is not set in brd_alloc() before we clear it.
There is no point in clearing the flag that is not set.
Remove blk_queue_flag_clear() for QUEUE_FLAG_ADD_RANDOM.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/block/brd.c | 1 -
 1 file changed, 1 deletion(-)

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
-- 
2.40.0

