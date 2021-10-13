Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0820F42B37C
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Oct 2021 05:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbhJMD3b (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Oct 2021 23:29:31 -0400
Received: from mail-eopbgr1300128.outbound.protection.outlook.com ([40.107.130.128]:18451
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237301AbhJMD3a (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Oct 2021 23:29:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCSB3D33QArNrdZz6DXMTKkgDL/J0mNH9QHL4atoiFD4c5XWOEVOZKp3qjKk7+GiJjCOiNbXwiz71rVvdKZIKf6eSFe5LE0DpH+jSsHO4h1pBKoqtACyNMOUwywfM9CDoiKbB0UJDD5trnTnVXE0HeKorw0FSGi7ki8VR6D/L1VcvOMiFlaFacPX3+s5bwIDVu6ztw4UA+8TVCatkiihWDdRYym8PPL4X6F01kIeKmjODux1xs7WCGxCp0Z42BtWVduwahLkCXCyQbPVE6BTGWGMno73ot+Z2JL73cY+0s8wSqTrktvwmRAksF8xxec5EU7xWeXwJpn/Y+VN+EnkWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tANR3mq4OymWUa35uZlCCXjub4rWwtto9Gq2XTlSGco=;
 b=MicbWyPErPsit7gifB85W9k9xFIoiJ9fdr2Y4m0SzMdyIH/NF3ql7MCUVxA5xNnJ1v8r+MaP7Cck64kC4L628qNlIE1wwSc2vjDTa5oRvBbvnI04UAo8+dPOh5vankraKYS3297b/2lzOy6etyYZ67cWFQejVh+YAHRnscBZ30/+7629+iEhNCxBLf28Ac/ikt7ZESyQhi6HQSd2AsQ4nqeJILZg4x9okgNQ0kGAWs6XXS0oh721OQQTposQRrXZgDj4DRzXDVZiiO6Ku+fvJ8Dd7yoWAYUhVsfDDHhfVflr4eWkWZwg/Odlbix5cEdFHhvGLJY8E8yD6/PkONQaeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tANR3mq4OymWUa35uZlCCXjub4rWwtto9Gq2XTlSGco=;
 b=hC20LdqGjN6xTBY7QWOKYb/mLWqgPvEl9abYwuge/oVltau75BuGY7LqbHFIjHewmoV9NRfGLUN+eV4P8iTAH/LssJfPJmLwAQbEqNkrxCr9KLghrVIcVH2fLZJeMTCngzKp/qfZs9KZfX69RI1Ib/dWWbe8iwxXOy03MDjjmpk=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3243.apcprd06.prod.outlook.com (2603:1096:100:35::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 13 Oct
 2021 03:27:25 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4587.024; Wed, 13 Oct 2021
 03:27:25 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Subject: [PATCH] bcache: replace snprintf in show functions with sysfs_emit
Date:   Tue, 12 Oct 2021 20:27:18 -0700
Message-Id: <1634095639-4227-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0156.apcprd02.prod.outlook.com
 (2603:1096:201:1f::16) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (218.213.202.189) by HK2PR02CA0156.apcprd02.prod.outlook.com (2603:1096:201:1f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4587.21 via Frontend Transport; Wed, 13 Oct 2021 03:27:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12d93037-5f45-42b4-3dc5-08d98df9606c
X-MS-TrafficTypeDiagnostic: SL2PR06MB3243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB3243BB9F39B4794E02211B2FBDB79@SL2PR06MB3243.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LNFyOKPDOOf5nByOh5Vc0A/8fGvdqzeFHYHE1hunj89FAPRIn2pLvSLXbYIbZQf3dFK1zvI4zDvwlk1D4i4RkHMl9KPQWboXJk6ZNM6L7nOAs8JyTBJoKwn4KsrdeEW80/3XPC21QNAepuCcL4akTp0oWrE9Ol7wnwEAr4OQl0VNf48P76pDt9udzT2ZwYR0QSdQXAyNkOIS5Sbz3tNWYWmu8d8v4PK3ngv6SVt90l1WcqPbLdPqTS8FKTq9f5Huz/BckpapOSlWh9O/JrM2PWpmQynk4E49iomGtasxBiyYhx1HHZXEwGJ/xtn+M8cRgfa8I8unhaGEANgbkPyo0kBAL3l7s52Pngi1X2zhwyWUFR0BiFpOS0AqNyqNON9dzpy8oXDm73FzbEWKtsRbGS/IatcROyXcsdtZzLs5FNZIg+simysEwr6CVQAFt0VX00xuDzXVGrwMFB1lrDMEKe/8C/TilGFtgARCHk7PfiRz8CQ3cdxitjPOM9ZIembqRS0Q1v6yQ6TShNI6hvbSGOEH9YyTo9C4542lX1NyclzDDV/R5hQYkLJzlUbg1Qr9ojlhWWcX36AEPG4vgH4oBWHAjC5WU+05hVHQXr+HAT+nQwYhcGs2VoPNSK8ImAhCm4c/lEaOywiByLWYitcojVtRQHQGpEpoH4CYfE/3AyTEt+/QoIYnuMpT1rjfjNZ5yZkUepS6RDLQkgPbDb10qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(2906002)(26005)(6512007)(4326008)(66946007)(8676002)(36756003)(66476007)(83380400001)(38100700002)(6666004)(66556008)(38350700002)(107886003)(316002)(52116002)(186003)(8936002)(6486002)(5660300002)(6506007)(110136005)(956004)(2616005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZPJ2pWjsL0AB1ogjlGSPwTDLiYq1JbcctARI20K3Bb37Mt3uXSQE7IHOpHMy?=
 =?us-ascii?Q?lxPpSipLdwyvMDYFZlipq2LpoW+iy1dszSFX/L9OmGnp3Kut9XgvXMFRe0v+?=
 =?us-ascii?Q?AtBfjkVVd7/lNpqqaR3m2DUWn6KQqD1IqKfeOM3nMK3Qb8EBp8gGXr9FPph9?=
 =?us-ascii?Q?NixawS04/ij0TDmuOBlOWplqKRQ/JevDvQi7Avt9MhDDLmQpEne4knQ+i1Zt?=
 =?us-ascii?Q?s6zy9tA97dkO0ZvGr6ga+881HoHkzhI9CugYs4hemSnf5wg4I2n9Z8Qu01gl?=
 =?us-ascii?Q?XiSm5V4Uc76clOpGf83OblaKkRKMiEolCnD1pEFj4I28JMdyym9pLE5akbgq?=
 =?us-ascii?Q?wRhykG1Tgd1YKkMTbBAlmkqr811h6+IQcr7wK9igdf7rZZ7VM8ZPP6tk6b8E?=
 =?us-ascii?Q?NxN1okrGegc1yzpIpc4ylLaTvA0+YcRem/MDdpPSor7OieZQuwJ59IucqB5T?=
 =?us-ascii?Q?GscTnEjbIJcc4JKKJfMYX+bsZRbzx0lBlIpbhrNbyuTolFQfKCvI2H5IwgmY?=
 =?us-ascii?Q?4mdrLp1vNG5DpxQDlR4rIRW/SuvzaZur0wMfGy9+C6c4IsmpqNWFLk84DKk1?=
 =?us-ascii?Q?skr2dJCYk2X2T4doOuIV76N9AKG51LZl6D2eDMkV529D4mdoZsPTT7LbDfkz?=
 =?us-ascii?Q?GFM4BD3zJWTovTbkpu94ghkFDEv2NyulL5s9TJXX3mUFQ3S0VE/z7LEayi7l?=
 =?us-ascii?Q?lI1LPjGWxUp1BuO2Wo7s3+6sFjiMyWu1cKNHbKIU1s1k29Ip6Nh2+k5DTejX?=
 =?us-ascii?Q?b6OotOIKcP+3NOR8kZmT/uGUg+EimJ6qbtMOXcHlGfCdLcK0h4QarKFQ9UD8?=
 =?us-ascii?Q?8oZ1pDmEgrKOD1iOavuOVe0Bf7JVatjhSSiNut28tMzBtSBIn0toC/j3e+Ij?=
 =?us-ascii?Q?47JQnimc6QpO+LO7BHI062dy/zQWADPZw72eHfVP5/W7QnjbBba6YaEcp4zT?=
 =?us-ascii?Q?1o4I56RON4upB4vZaGPXJ1pZjs93gkP103UYfz0nT5/EQ2XKQXHurSkl/7dQ?=
 =?us-ascii?Q?LolhngYthmLgKaPLF9nJ+WUJlVNi6O1KS0Y8YDqVUiODHlk75ilvofL22lJu?=
 =?us-ascii?Q?nGsLWSCN/Mdm8MOVvmNXQwDvC26+DkWzpvgmL0XSK+7X0lkTt/NO2YLToyWk?=
 =?us-ascii?Q?e93mQemf0wZq9gCbTGZCig/0kxDMouHkjJS0jcLXBqWRQDEnPCGOsthYhf3g?=
 =?us-ascii?Q?erEIymVkmc9IYqdG4Scrd9LiJc90f3oJQXqYetvzfGaEH2SmlAvEBjSJaXIo?=
 =?us-ascii?Q?jsIN21tp0MO5JNJkuNglLTUO5ShGthf80uxvfKZEalBu01T7flwKX0udoaEs?=
 =?us-ascii?Q?4+2a4HZbl2VZAMgZgWJw53Oy40WPyIeoN9bP+D3p4SlwxA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d93037-5f45-42b4-3dc5-08d98df9606c
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 03:27:25.5704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzqyHdqGD2HP2SnFQyB64GRjIRUEVlba0RjH5+mDJ6aqGWeMvHLbDJ3hcss8GD1HpmhoCa8HsqPTdh7k6VQZHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3243
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

coccicheck complains about the use of snprintf() in sysfs show functions.

Fix the coccicheck warning:
WARNING: use scnprintf or sprintf.

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Signed-off-by: Qing Wang <wangqing@vivo.com>
---
 drivers/md/bcache/sysfs.c | 2 +-
 drivers/md/bcache/sysfs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 05ac1d6..e146c9e 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -639,7 +639,7 @@ static int bch_bset_print_stats(struct cache_set *c, char *buf)
 	if (ret < 0)
 		return ret;
 
-	return snprintf(buf, PAGE_SIZE,
+	return sysfs_emit(buf,
 			"btree nodes:		%zu\n"
 			"written sets:		%zu\n"
 			"unwritten sets:		%zu\n"
diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
index 215df32..8bec32d 100644
--- a/drivers/md/bcache/sysfs.h
+++ b/drivers/md/bcache/sysfs.h
@@ -51,7 +51,7 @@ STORE(fn)								\
 #define sysfs_printf(file, fmt, ...)					\
 do {									\
 	if (attr == &sysfs_ ## file)					\
-		return snprintf(buf, PAGE_SIZE, fmt "\n", __VA_ARGS__);	\
+		return sysfs_emit(buf, fmt "\n", __VA_ARGS__);	\
 } while (0)
 
 #define sysfs_print(file, var)						\
-- 
2.7.4

