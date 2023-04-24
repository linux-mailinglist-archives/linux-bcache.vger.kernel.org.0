Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31096EC721
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Apr 2023 09:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjDXHbX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 03:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjDXHbV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 03:31:21 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02hn2237.outbound.protection.outlook.com [52.100.160.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0CFE71;
        Mon, 24 Apr 2023 00:31:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIGZXww5k0obNOgUknjlggLRg2OgvX6yI+p9sDU2m9b89XOaA9ek9kmYN+B4vQBgwWuHBXh3YRQszAUbC6xNv0Bv7nvM+KL/51kTn87wgfHzFx9KCtVfjVVpJIXkYOqoWbYRezFziVsem9kLq4syROx2Iv+rG2vBMHM2oX8iqyX/Enrd5CS0t6Qr9gJk+Ek+90MxLipbPuE8+5DQeBs8pai0zfJk4VYNOhnus8N2OU1IuOKnrozSGBzf+T+YRjytSCLcABE3tmF159f9p7mRU9PSuvk/34jutNS8yvWfprxgDDzAJo7xgQb4nhq13rOJOiwuQWe2hCGYyx6QI/kCIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0JE5sPj1JBSNn0kA/6fe94CuFYT7geDSqyMLk20AkI=;
 b=isvPztAtB9i+zVvFZ9pEckp3rvWRRXuMxji0Iy3FtXvMBXTpvn3G4BeGbkAAOvTTrwGGdsJwLMxEmkU5mci/sZZeSr4lP2WHjOQDH6ECX7d9/KPM4rNMJxCvLQO4sG0H0qLd01xAg3NritLWKzB6BYNGpsC1pu/9oSOhjzeYokRLwZbwfNk4nfBHahsQm+QfWlyGKXDfkSGDdYaA/Wv1GF3zyiehZGaupJz8OpmUKd4ck+Wf3eNL3byFgx3gpalbk7J20GLHJ5rPzC0o1t0gcFYTqNO7x60kTzE8Lm7oeDpRo8Oj+lFeCwyrrT6ybGrBwlOWcazMoP5RevW460vZWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0JE5sPj1JBSNn0kA/6fe94CuFYT7geDSqyMLk20AkI=;
 b=ENX0t1Aqqyjz0UrBHq8M2+7mSYYbxCXOxIGxtC9pTtbO22a9foQ4X/8x0ZVdMtQsf8TlK2QQfaDkjAqFZFPMr2a203jmSENo9uvp5xZceRFFpUfIGdgKHvnqg8XkQVnmVBmEOvbKfT4M4cE6Hr3SFxYb9Z5/UrOroyXWOZ9zvL65hcMKGpQaCrGKAI5Wt00FIkcK81WVUAy8UtrHZD4zzojI8o88zdmdmH7prSBEQCi1pJyhj1OKfaNMILwWEg4Kzf5MjETdg2ChvD7TvZfZUNjUBS28s/youhi5L7yK87EML6oa4Ig3BkddRTt1lhSRJr6ovfvxQ0DOURlAINP3jg==
Received: from DS7PR03CA0151.namprd03.prod.outlook.com (2603:10b6:5:3b2::6) by
 PH8PR12MB6915.namprd12.prod.outlook.com (2603:10b6:510:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 07:31:17 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::a4) by DS7PR03CA0151.outlook.office365.com
 (2603:10b6:5:3b2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 07:31:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 07:31:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 24 Apr 2023
 00:31:06 -0700
Received: from dev.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 24 Apr
 2023 00:31:05 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>
CC:     <axboe@kernel.dk>, <josef@toxicpanda.com>, <minchan@kernel.org>,
        <senozhatsky@chromium.org>, <colyli@suse.de>,
        <kent.overstreet@gmail.com>, <dlemoal@kernel.org>,
        <kch@nvidia.com>, <johannes.thumshirn@wdc.com>,
        <bvanassche@acm.org>, <vincent.fu@samsung.com>,
        <akinobu.mita@gmail.com>, <shinichiro.kawasaki@wdc.com>,
        <nbd@other.debian.org>
Subject: [PATCH 3/5] nbd: don't clear the flag that is not set
Date:   Mon, 24 Apr 2023 00:30:21 -0700
Message-ID: <20230424073023.38935-4-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424073023.38935-1-kch@nvidia.com>
References: <20230424073023.38935-1-kch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT025:EE_|PH8PR12MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: a2fbcbe7-0254-4a49-5794-08db4495e410
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1c1AuiDGdoghnLOr7+x+pONbhrs0uRmKCBYeNuPHcKQDsDD5oMDqJDT63ibcYhnjvM7RD/qSy2u0YVbnqFyaczJBTn4WcQKNre6HmQ3yXx4ofvippghNThYTiGednxGac3Tr9NJgow6PlRptTVXQYL0e3aU4OhcK6x7WMhu4Cgpyd7xlXgI3bg9S22J9fzkZOOHTs2YRlIQHGprgX23BNhyXXWOVaDGfFuBnjWa6k54dz48KxlgiohgWEnl1betoa64b34yNJa0BgD59K7Wbr5yHdZmbllfaweW4yjiiwFp3XHU5wWgWvZ2ljMJ8pv0CPppWwjkQAdNQmigcSyQ4kdvgD2bLPL7TKHuAlS7GBr15+7NwgSK6x/Ym+aWyzDj4Zsti2M6i8+mdtZdJYlAWaoRANEFnsGKEVr/7bXAF+nJLFycOYQ+wbTtrrnsGJwRKaP3A/Q49jNbNyMlMcySk1ZdgWXkQS+xg3+CFA1rcQEhUMAiynkGRzlIoSgHgGcIOhyF0m8wdqcC42NquG0A7exCpMFvg2I0x7FJvaThntKZJxBhoX/ztgR6R66xz9bjRcX3XGM3PSZF7yQcG1QyeZjfrGwHet6Vz2/d29NKe9o168Fr5N/uhWYaCiwEUwC4IiVhhaTOwlM8SOVvT3tlODcmduEG7dITpHfmgLetfLXKZuTwk58xetqixucEml3mij/iZV5wprJBRxP6ofkqA/wKeH+88Z2g5rsfsRoEhNJlAW5tLvGj0h2X/FXSj/V/idNrbkpcEItJeBM623SvkMg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(5400799015)(46966006)(40470700004)(36840700001)(54906003)(36756003)(110136005)(40460700003)(34020700004)(478600001)(82740400003)(316002)(4326008)(40480700001)(70206006)(70586007)(7416002)(356005)(7636003)(41300700001)(4744005)(2906002)(8936002)(8676002)(5660300002)(2616005)(426003)(336012)(1076003)(26005)(186003)(16526019)(6666004)(83380400001)(47076005)(7696005)(82310400005)(36860700001)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 07:31:16.8743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2fbcbe7-0254-4a49-5794-08db4495e410
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6915
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

QUEUE_FLAG_ADD_RANDOM is not set in nbd_dev_add() before we clear it.
There is no point in clearing the flag that is not set.
Remove blk_queue_flag_clear() for QUEUE_FLAG_ADD_RANDOM.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/block/nbd.c | 1 -
 1 file changed, 1 deletion(-)

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
-- 
2.40.0

