Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93D06EC71C
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Apr 2023 09:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjDXHbE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 03:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjDXHbD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 03:31:03 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10hn2208.outbound.protection.outlook.com [52.100.155.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A176E53;
        Mon, 24 Apr 2023 00:31:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlAkyWzdgCcuQygYz9xAfl/IS00PzhiJu4BDUeuCkqvrpBU4Bv4I3ZE45riQY1hNX9fr9W6soV4DLgOWSALP3BwQHbfsw9uixuGm4hfwAObSDlQ/B+5dvBxNuBkIJ92ljDLgJ/Ly4rxMDLysJb/aYyjs/pMRxgGFJDtrgvDPnUZkAQA7CZn3QVdbpIT17rFLWekhUNMFHqmeNEJ1a0VPvOSlOVG2oGmT09+ViaYe6AG+QcsmNM+LmZh68Ug77SKz29mLpXwXIm25hUDuk9PPGEncs0g28x/XH6ANOi+1NZygKdmDMG9jNhQQHyy2sroFJsWUlq0VxuQLcKqEyYj7qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cypey35BJytHe/i8AM3tgY/ZiUzrnRv5NbcvJrFImCc=;
 b=bUVFQGOCzSaJiG3eFemtjLYfyPgUzkWbATj1vjc4DEMYGqkgDkqsXkD+EZfpZ14U0JsYXnEmKxYUbFd70i611xfTbggaYOZyY817S2gUellGgGu+HTq9eW89mZ1HWHucSLQuddfW/A+PPpeSRRlGsjipXA6eB7d2ham5y+ecg14O7MEm6PO7CuoOLfT+NFRzQbCd2MKAMh7IdyZ62H8URVSvcJZS3fNrogTS9mznvF7T/P7y3noSvzNDe9FPB+cGLoZ7lkFyEF+nIW+oPKRjBc6aX1GL7TIkhWh84+jFTkzAhdpNY447HpiawlvHNr7dv7cq+Dg8Ur4LE41742DIkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cypey35BJytHe/i8AM3tgY/ZiUzrnRv5NbcvJrFImCc=;
 b=e7zTAUyFGGsmwK8VLtArkh+MXtaPCI19H8rE4wS3gAsa3IQSwW+ESptKtVpx7ptkwvsEJmXXDnqN8sF9WSER6ijRqfmHEeEfPQv053MGQNwxtkwHc8H92IrRhRKkyn9SYESTIn78h3tyr7ZzmHsKdyJECJo/0P9caW2TlwWBSC5GS1jEGfKFgRLtdqUHtJZz8AL1UmHoMWMOEorjsbb8hfEpmgdQgKwkl0R0S08KklG6W8MsjFC+aDUxWEKx/Uci1QQCL6gnW6UpA0ghfURd+6OJyyCRudjQh429zC06/MbgDRrrxm4C1ythvPZ2fXHjBIgWae7R+qIxBVqc2c6aAQ==
Received: from MW4PR04CA0059.namprd04.prod.outlook.com (2603:10b6:303:6a::34)
 by SN7PR12MB7980.namprd12.prod.outlook.com (2603:10b6:806:341::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 07:31:00 +0000
Received: from CO1NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::dc) by MW4PR04CA0059.outlook.office365.com
 (2603:10b6:303:6a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 07:31:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT094.mail.protection.outlook.com (10.13.174.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 07:31:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 24 Apr 2023
 00:30:43 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 24 Apr
 2023 00:30:42 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>
CC:     <axboe@kernel.dk>, <josef@toxicpanda.com>, <minchan@kernel.org>,
        <senozhatsky@chromium.org>, <colyli@suse.de>,
        <kent.overstreet@gmail.com>, <dlemoal@kernel.org>,
        <kch@nvidia.com>, <johannes.thumshirn@wdc.com>,
        <bvanassche@acm.org>, <vincent.fu@samsung.com>,
        <akinobu.mita@gmail.com>, <shinichiro.kawasaki@wdc.com>,
        <nbd@other.debian.org>
Subject: [PATCH 1/5] null_blk: don't clear the flag that is not set
Date:   Mon, 24 Apr 2023 00:30:19 -0700
Message-ID: <20230424073023.38935-2-kch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT094:EE_|SN7PR12MB7980:EE_
X-MS-Office365-Filtering-Correlation-Id: 99d38731-7311-4107-4bff-08db4495da03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qCEyDvcIl41c26qLJx1TlBwBbXdQyQo+13Erf4au+yMIHbIQ8fmbW0V/FpyB6JjMJD1oaj/AxuhU9iK1HG8MIAneLC6hY/WuMvLytqTNF1tACeY29f4vgI2zxa5b/zy2mJ5TnE3QBY/NyqH3Y7e/473j1YlBEe2z3vrMzhNKwypTuwxLkjdbIacEmACIfqYttnuQgclWF5lB+hpVnuamjgSz8QGWosbNlWflyn6XVy62oVHaJVb6BWe7vUUwvoluZpvlg6FhgW23X0/T+MINm5WoWZRvGQt/GB6lmqwxYKFg2eza16cR452Lr3Smxe4/9NcCxMQESZSykX8n9zxLvHZpZq8L9b1AEJRUD8bafRBO6Ulepvr1Vanavl6+o5BZgZt5ajZtQQ+l4OM5B+RTXPLWpnNr5DB27fEYjJK+fxVqQ0ocofOo2N7qD/o8pTFxY/VsXAYtfN0FIwh39eipgJmIXrIuhQsQUXTqxOrlRn5gz5y6bnMrY+jhlJxRVyxBQWmdI3nxi+RAsdMn2mk+TgI7yIECyUtFblXjzx0fA83CIVwAdBToUQdNBqRjVv/NusOmQ81lO+9pksp964rgkDslgTAFUS5N6BXAQr3ZNjTMxmTZogzd/99ZeyutQ/Dhj9XZnScbVdGHrJPPas/eQ9U/TrrDhyXZwcWcZGTBh1RsUJwZbKCIks+5x9OGLKUYstRIRzgs0f3D8Xo6N3diw4Y7K7aTrVjPJEb4Q9R5DrKeUmTKi07VlxRysExrjBhUSvS7Bmhdx04R8pjG6aDYZg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(5400799015)(451199021)(46966006)(36840700001)(40470700004)(1076003)(26005)(40480700001)(336012)(426003)(2616005)(34020700004)(36756003)(83380400001)(36860700001)(47076005)(186003)(16526019)(40460700003)(7636003)(356005)(82740400003)(70206006)(70586007)(478600001)(8936002)(8676002)(54906003)(7416002)(110136005)(5660300002)(7696005)(41300700001)(4744005)(2906002)(82310400005)(4326008)(6666004)(316002)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 07:31:00.0584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99d38731-7311-4107-4bff-08db4495da03
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7980
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

QUEUE_FLAG_ADD_RANDOM is not set in null_add_dev() before we clear it.
There is no point in clearing the flag that is not set.
Remove blk_queue_flag_clear() for QUEUE_FLAG_ADD_RANDOM.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/block/null_blk/main.c | 1 -
 1 file changed, 1 deletion(-)

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
-- 
2.40.0

