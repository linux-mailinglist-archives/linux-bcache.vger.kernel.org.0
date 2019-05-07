Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C3716144
	for <lists+linux-bcache@lfdr.de>; Tue,  7 May 2019 11:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfEGJnU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 7 May 2019 05:43:20 -0400
Received: from mail-eopbgr740077.outbound.protection.outlook.com ([40.107.74.77]:37796
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726399AbfEGJnU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 May 2019 05:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKXUpMrwogN1cdesW4/ghpgmEY6sK28hLKM3itQVf4w=;
 b=d//IjvmJT4r7aJbC8AfaBQ+7PfhHpSXLruUVhAtpvWPvcUevJIV2Qc3z7lySbX/7P+GHkkhX1jV1xwIJn3ThOCPd1B6mOJklbRInsgqZkdKlRCAqY1WfKLUCREe3ETwXlVnY2BPFSib42JLDeAkYcxv9r4N0Nai+Nk38X0mXGbw=
Received: from CY4PR03CA0023.namprd03.prod.outlook.com (10.168.162.33) by
 CY1PR03MB2267.namprd03.prod.outlook.com (10.166.206.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Tue, 7 May 2019 09:43:16 +0000
Received: from CY1NAM02FT005.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by CY4PR03CA0023.outlook.office365.com
 (2603:10b6:903:33::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1856.11 via Frontend
 Transport; Tue, 7 May 2019 09:43:16 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=analog.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT005.mail.protection.outlook.com (10.152.74.117) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Tue, 7 May 2019 09:43:16 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x479hFYR020548
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 7 May 2019 02:43:15 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Tue, 7 May 2019
 05:43:15 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <linux-bcache@vger.kernel.org>
CC:     <colyli@suse.de>, <kent.overstreet@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH] bcache: use sysfs_match_string() instead of __sysfs_match_string()
Date:   Tue, 7 May 2019 12:43:12 +0300
Message-ID: <20190507094312.18633-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(136003)(396003)(2980300002)(189003)(199004)(8936002)(26005)(77096007)(186003)(6666004)(356004)(476003)(8676002)(50226002)(6916009)(7696005)(246002)(86362001)(51416003)(70206006)(53416004)(48376002)(2351001)(70586007)(47776003)(50466002)(2906002)(7636002)(305945005)(16586007)(54906003)(106002)(107886003)(316002)(126002)(36756003)(1076003)(5024004)(5660300002)(486006)(2616005)(336012)(14444005)(44832011)(426003)(4326008)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR03MB2267;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d61e36e-0685-41c9-52f9-08d6d2d06e36
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:CY1PR03MB2267;
X-MS-TrafficTypeDiagnostic: CY1PR03MB2267:
X-Microsoft-Antispam-PRVS: <CY1PR03MB2267F5AA609B13B4155760F6F9310@CY1PR03MB2267.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-Forefront-PRVS: 0030839EEE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: +75uCfFny8fZ1FdVJBjZkvDrd14RsQU9YQbSu7RS/2JgxcRY1c2bvqFhNVWPBnR4KHe2pNfg+LR9iqP3JFpVhNlkFOhxlkaueHADuqO3bn6cjllrKJs6byHThjFOdP/rS/jooVVc8tP6PiU0cKfKzXXe/uiT4I3kfUcAiuhd0sZ/FRXgRsadG95vFHDusJUUgV7teqCDACJaZgCN50YprEcyHqxfnhjDfmTYitY103peYRkWZCCt2wGaoM8cCdFyvg2BdFRZVL5RvfuSh9b2+jncnb+AOori1LLTqFYNF3F5fqPg/U9koWuAoFgL0+1XULDhX2aZk6CXicnQhjLI6XEWkd9Xz5yDRFWCuayjpf46q/clzk2b/uAXQNnL2q0Tb9neUkKDYoA9Tv3wGOPPEAYu1b8UO/Hkt1NphlNHOzc=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2019 09:43:16.0656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d61e36e-0685-41c9-52f9-08d6d2d06e36
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR03MB2267
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The arrays (of strings) that are passed to __sysfs_match_string() are
static, so use sysfs_match_string() which does an implicit ARRAY_SIZE()
over these arrays.

Functionally, this doesn't change anything.
The change is more cosmetic.

It only shrinks the static arrays by 1 byte each.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/md/bcache/sysfs.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 17bae9c14ca0..0dfd9d4fb1c8 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -21,28 +21,24 @@ static const char * const bch_cache_modes[] = {
 	"writethrough",
 	"writeback",
 	"writearound",
-	"none",
-	NULL
+	"none"
 };
 
 /* Default is 0 ("auto") */
 static const char * const bch_stop_on_failure_modes[] = {
 	"auto",
-	"always",
-	NULL
+	"always"
 };
 
 static const char * const cache_replacement_policies[] = {
 	"lru",
 	"fifo",
-	"random",
-	NULL
+	"random"
 };
 
 static const char * const error_actions[] = {
 	"unregister",
-	"panic",
-	NULL
+	"panic"
 };
 
 write_attribute(attach);
@@ -333,7 +329,7 @@ STORE(__cached_dev)
 		bch_cached_dev_run(dc);
 
 	if (attr == &sysfs_cache_mode) {
-		v = __sysfs_match_string(bch_cache_modes, -1, buf);
+		v = sysfs_match_string(bch_cache_modes, buf);
 		if (v < 0)
 			return v;
 
@@ -344,7 +340,7 @@ STORE(__cached_dev)
 	}
 
 	if (attr == &sysfs_stop_when_cache_set_failed) {
-		v = __sysfs_match_string(bch_stop_on_failure_modes, -1, buf);
+		v = sysfs_match_string(bch_stop_on_failure_modes, buf);
 		if (v < 0)
 			return v;
 
@@ -794,7 +790,7 @@ STORE(__bch_cache_set)
 			    0, UINT_MAX);
 
 	if (attr == &sysfs_errors) {
-		v = __sysfs_match_string(error_actions, -1, buf);
+		v = sysfs_match_string(error_actions, buf);
 		if (v < 0)
 			return v;
 
@@ -1060,7 +1056,7 @@ STORE(__bch_cache)
 	}
 
 	if (attr == &sysfs_cache_replacement_policy) {
-		v = __sysfs_match_string(cache_replacement_policies, -1, buf);
+		v = sysfs_match_string(cache_replacement_policies, buf);
 		if (v < 0)
 			return v;
 
-- 
2.17.1

