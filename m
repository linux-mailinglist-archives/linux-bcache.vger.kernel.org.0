Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485856EC72A
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Apr 2023 09:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjDXHbt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 03:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjDXHbr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 03:31:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12hn2235.outbound.protection.outlook.com [52.100.167.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1808210A;
        Mon, 24 Apr 2023 00:31:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKMq67jbXhMxzKBshzSzIc3S4SVj8we24/SrDX/zyXJxaVAU8gfm+gC2GzlSFHDQyopmqSNtgstexxDxN83KUbSV/HUbqtdaOAKKvHHKwtFivgxeH0Lf+q+LKvVaeTPA+rtAQg+HsCWQ4KRZI5dsKkFxoK82Vf/cogFpVkDW4a61cDuvOL0iNwdSFM25b7048tCxeLbSiouEv6VoGD7uegtg6JHYcpls74/0PRdhxGpaZ7HuN5fER7o60WP2OCLY7+tP2WTmlx5w+YSm5z6B6IA5S6sdLwQEwCeCwQhVXK2OVomk8TcPtRKPfBEY8UKEM3+C+Ibdfve6QtS8ICLL9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4oeCNFOCeDAhqIMeUlEQeofszzQD0ppHGlt7WyUhz0=;
 b=X5rM8QpisMzpJO840L9xs056F0xHFQ//HW0rjQ9iw51LXTuVb0t6guSgZcDtxc9n7NEuFT/jEF7aUuluKVWt7uEDI8d4m82Dp5BpZGnsXhF0FpoIUbW5E6ZA5o5KYCmawOyUjUR+9wSbbaVbP9P9iGbZMuaqiUHPgxDkJiNwQ+3gs9+YnpVM5RlBFQFg2IZtbheKIiLVdx1o0op3Mytv+TBL8+Zemvn4eE+ZNOJbXrPE4vr9J6D/dV8ICrX0q1AhA/eouS1sYWysjRog8dIkMOq5DWCkrys+G3k6R+kLCyrdIHOtkKeLm/3nrGedP28eriW282q9QVziI3hg614Faw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4oeCNFOCeDAhqIMeUlEQeofszzQD0ppHGlt7WyUhz0=;
 b=fU8DauFr95WiypPlqwUY4UmZs6RCuv3MINFd+vNImq3QfxyvQ1FyL4NsFsUpnOEOHxMQzhvwygUYIVNV2n7igPwplLWIab5IXFQvlTkUFj/sDYSOI1FjKvNtc+KHXQh0XKF5HurNfKQMuzy6Cuei08WRH24ztkebAh0FXX4X+OMYmkaVmS60TjGDvxOYO+BDZnBX1qbAX+3kU5x3EDHTTZ4oCcPF3Xdu/kIRpjylGi430EFFPxpKbu7kIFMeENBoKl2fMxOAP3AnGhFxdcJe0qZjIJLjXagu66yP2GWUiJpKfLzBO3d8WgSslvbz+t50nCeuj4pJOZTN0V8SZn68EQ==
Received: from MW4PR04CA0251.namprd04.prod.outlook.com (2603:10b6:303:88::16)
 by CH2PR12MB4149.namprd12.prod.outlook.com (2603:10b6:610:7c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 07:31:42 +0000
Received: from CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::49) by MW4PR04CA0251.outlook.office365.com
 (2603:10b6:303:88::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 07:31:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT071.mail.protection.outlook.com (10.13.175.56) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 07:31:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 24 Apr 2023
 00:31:29 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 24 Apr
 2023 00:31:28 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>
CC:     <axboe@kernel.dk>, <josef@toxicpanda.com>, <minchan@kernel.org>,
        <senozhatsky@chromium.org>, <colyli@suse.de>,
        <kent.overstreet@gmail.com>, <dlemoal@kernel.org>,
        <kch@nvidia.com>, <johannes.thumshirn@wdc.com>,
        <bvanassche@acm.org>, <vincent.fu@samsung.com>,
        <akinobu.mita@gmail.com>, <shinichiro.kawasaki@wdc.com>,
        <nbd@other.debian.org>
Subject: [PATCH 5/5] bcache: don't clear the flag that is not set
Date:   Mon, 24 Apr 2023 00:30:23 -0700
Message-ID: <20230424073023.38935-6-kch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT071:EE_|CH2PR12MB4149:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fea8fe1-d5cd-4bf8-784e-08db4495f301
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCgZXxoPGI4nejtzseAwx5A34WCiNoeq0nFVagcDGLo1Y9NRcYJvarAJtmg1XBH+s8RlRIHjL9njDX5mrkg87nz8N/BR0Am0cpJB0mtWFgyKla6sHY7xqZiG8zt712xJFGE/cSNhqCKVQBR+MmuddGTk7fFAZ9xltOo6TdBA+3iSLeDe7mKBBrh03PJuSkhqcMxdC0jF+lxz3QeKWJu79zOOw7DuZEBMyJjnbZPoTbemf2LaL4FqXnsBcmrPUfmUpxCQdP/TLsbkhFVjX2I8z8rVPJy6P5reqg7GHIOe8iblM9TCR4Hryh5G8NRhmSXXjJDOcV5MA1sqZ0SlV1I1+714gh97fHxW25mmstljeMfkxFlb0AM6Aigq4GgMNAQI0SEqCu25DshdjquS/i0qiAFLterCKt7Epvu8fKCiDSlsWacDXPGNyNzWSoxbzICb4pZ7lC/c+yE2uGCg/yf4+EScacCCafVwOnX0TEKfWCy1SBCrX+ab7fnS7Xh7S5BFAkSl/0s5d+UjmRndXc3r8tQUQit0bqtCiWzZRjA2VJ/sM+MwhPCZby58FhRaS+zgVEdvhYYOKFOnOGExg7dVyU6G9LNCvsSg1ALBQLjcG8Nh26tR+yNc3ugsV0Sh8AFsUGOkcFQrBsgTaJSBZXBLLbs6R1/aE+CX9eO8DMZe97It6cFiQGBzfzvyLZUiaDP9pY8i5Ca4JCHHiKJScM+JfdYXMwxuRN8kQwslK+fls04NVNcBZvXNHtYqW2yqaIm+98a5jP0CBX2zUBPPpjHTyw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(136003)(396003)(5400799015)(451199021)(36840700001)(46966006)(40470700004)(478600001)(40460700003)(16526019)(110136005)(54906003)(36756003)(34020700004)(186003)(7696005)(26005)(82310400005)(1076003)(40480700001)(6666004)(4326008)(316002)(82740400003)(83380400001)(70206006)(70586007)(36860700001)(2906002)(4744005)(7636003)(336012)(356005)(426003)(41300700001)(8676002)(8936002)(5660300002)(47076005)(7416002)(2616005)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 07:31:41.9895
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fea8fe1-d5cd-4bf8-784e-08db4495f301
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4149
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

QUEUE_FLAG_ADD_RANDOM is not set in bcache_device_init() before we clear
it. There is no point in clearing the flag that is not set.
Remove blk_queue_flag_clear() for QUEUE_FLAG_ADD_RANDOM.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/md/bcache/super.c | 1 -
 1 file changed, 1 deletion(-)

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

