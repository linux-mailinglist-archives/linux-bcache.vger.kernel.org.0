Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E70042BF4F
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Oct 2021 13:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhJMMAi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Oct 2021 08:00:38 -0400
Received: from mail-eopbgr1320129.outbound.protection.outlook.com ([40.107.132.129]:4167
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229535AbhJMMAi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Oct 2021 08:00:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+5dJoLe20Q8bZZBERim6owc6qmU283AJECvpAqwToniO97Y1/BmS/1YkrZJ3Qbjz8OsVwJ7QItloxIoBGWTpvg8o83nQ6Uot5VOqG21sGDSikEA7ZwYV3fz00wJWZzpZERgtfoGfe4JtlVFYPsxZvYzTy8J/Nl78N+II7N2OMC5tJuDw0p04Jy+U2sEbBHBuCUwI98vNTDHy1n868Gv5SJP4p8GGjV9RCTRgeLZYCfo3aWE24IpZwSQlBk3o3qO6XUEsjHhW5axp4vgHUf6rfLrKEiYpFJ5LHmjkrukXew/oGkRYHetKQgNmqPq5HNn34BR5QP6hwMgVQlk1LXOLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipHylihHC1Yetk7NAHC2WD+xVDOs1cSNjD0Ae533R+o=;
 b=UZpA8JX05d/Rnwn/mr+wpGPDrSWNtEsboofzb2sj8nzmi3DOB7RQR5nxq3fzRK/V1XdniZf2VBZ3WI8jAebhSaFrdMb2/Cz2t9wiihv3F88z50mk//PZwCpRbIMytkDs+qybqbuN8tfllzJDh6HYvzdO7yCFeuiS16ZoLiIcJfO9N5zJQKkVCH4B6sWC1J03hZ4nulaO3VhMt2b7qaUX+VVajQPP8ShI7moWYq1M8OB9YWEz2uYCIquHsARV7eq8e6Xr8EZKrl+05oMgpOyr1e2pU2pr+ouIU2z6kdo+fMW1yDvJqxbDhOff6ytV0rFeUegkbyc7tpzT78dm/9ziIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipHylihHC1Yetk7NAHC2WD+xVDOs1cSNjD0Ae533R+o=;
 b=RPuSMwa+O4cA/b2tgNN2B8JRxwPwO4A3YKZ0tSwTNBWX7wm79at2fETavQWSBKyct1ObkglVggxmrG/MllnXMVPRWFY04KOBE9hN1pQTN5h5cYU/0Nui6N5mx5fBFAEWz0KDywJToU1LyqK08ocvVzw8zCn2d1nqi1Bc5xuxQMs=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3148.apcprd06.prod.outlook.com (2603:1096:100:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 11:58:31 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4587.024; Wed, 13 Oct 2021
 11:58:30 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Subject: [PATCH V2] bcache: replace snprintf in show functions with sysfs_emit
Date:   Wed, 13 Oct 2021 04:58:17 -0700
Message-Id: <1634126301-2849-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
 (2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by HK2PR02CA0178.apcprd02.prod.outlook.com (2603:1096:201:21::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4587.21 via Frontend Transport; Wed, 13 Oct 2021 11:58:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd1472cd-5f19-439e-c629-08d98e40c64b
X-MS-TrafficTypeDiagnostic: SL2PR06MB3148:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB31485EA9B3C5765E2299750ABDB79@SL2PR06MB3148.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:217;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: emx900sWVrJSK9ZDN8+4zm7stxb2kqfvK1avdgbSU/mD8ckc5a0zrjWMXfDk6JY/rJ8kUCf8FnctxUilmDol+gYKoEXbaSdLnlAu9yPMnECOfqsCHGh3zyZ+2eakRIFcuw+HlmdnSIbGxBI5YjfYM2m+CJm5xwKU9QRtvfkORxZhgO7fkB542auJmewq5gsAkbZUIK7LlPZxxLYCW0DVZvURgbOmq8wM0Urc/Lq5ZrcOTekWfxfj7Wh0XZyI7AYwX+PnDCMIM1wWWfHrjuWrgQR4xylxA6XWrUD8fVxQ4vUEJyYJojrUXsYEeMVQavn9BzI59ZmCCKtdPnhAze2Fv6MkxYyGgSij0a8w+De/jOCOpbAm9cVCjnRmBsNsipCdIZWyz8cotZhkS1Mebeum50xCi2tifu/XqiP5RGvv8wPhC+YHZ6qIHiBTBinq+OuFCrvy4ku/7eOro4QJFRnNPigdBzRSgR+b4FwprTqjbYjIKhJHFrSNy3HhedJpLJYTqOWv5wZrpwMdAiX0pPqIs6llzwk3c0xodZwyoaiyIGZWYggTaRonXBdsX4yYpPky3+72TSPhCdLCT27HavZ07dTPNt/M/f/EGFRZi5lxrgKDrDtPYFC0BfEULzJqF25DFdW9A8v+IitAExKh95UsJ4a4wmcHPkhov4ao2t9MxAjPdlz8pry38h8kP3NA6cOQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(508600001)(110136005)(38350700002)(6506007)(4326008)(6666004)(83380400001)(52116002)(6512007)(316002)(38100700002)(66476007)(6486002)(26005)(956004)(107886003)(186003)(2616005)(66946007)(5660300002)(36756003)(8936002)(66556008)(2906002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M9XG+t9faNJE+dLLYNyx37vYC5VeF24BiVrwtJ2mHoT2hZ6Ln84hAnnR/aA5?=
 =?us-ascii?Q?cvtnrs+4TvlRNn8qKUytaFLZtji2owoIhJdUWrJ87IXMfFr2giJBAndnkQ2k?=
 =?us-ascii?Q?WhFpOW+2P7z6m+MUoGounK+CBQTeHYWTL3aNFMtQa3SnVNL/y4u0FC2eOG1T?=
 =?us-ascii?Q?7dg/C+R20xqdeSGKYz2Gf4Fi08nIS7g5xsofyGaadNIpf73Yp7zCTVu/jdk4?=
 =?us-ascii?Q?+ZUDa/6SIqVKgw5wruEMqnyY5Ck+093Es5AjDbbqUd5Dh4TvEtGMSC1zfJZl?=
 =?us-ascii?Q?1hlymzXkX4I5vY5TPAw0o7tyccQGMRTw6K8Xt39ka2UrN1O7th3KWVObPN9o?=
 =?us-ascii?Q?WDgG5old+k1uWHiPib5fy2aGs2v+sXLWCMAKvwhG+JqGpKFwsfb6uDqFCin8?=
 =?us-ascii?Q?gIPVEzz7GXuGWhPwTu+B1aYDBH21guRqt+9q9yv+j7gc0BfjzdVPetk/v6Zn?=
 =?us-ascii?Q?9oCxoCZGrdh3i9Lt6bUZoPMMwiPT2OS9Fqq0fxobvseUca1FkNRKh9kXFCBa?=
 =?us-ascii?Q?HXkE+VE1RJkUmuizFnP4odScs5l22RCHrQZLfVzBdyyNl45AvHPdVY6oBIOy?=
 =?us-ascii?Q?ce9stxGeejQMXEeqnX3ssWPec5k/bGfreXBt4xowqFpd2N0pLY3NkyTIbcs4?=
 =?us-ascii?Q?bWqEBeTr7yqIS33j3JNo6qp0kKfGD9CGvlJ3liddhUTgI7YjvtlsIzgl1iKB?=
 =?us-ascii?Q?IuAFKfjcHdvfJHM1xPEOeNMO3EYzzcbgtVG0t5pVCc1IfAIjNInDqFUnri71?=
 =?us-ascii?Q?L8tKJ7GtLrP47p/b2khHKqwtYoXId2bUrHgaESctahmG3QQG57kS6lGY/7ps?=
 =?us-ascii?Q?qbTWzUmkMEG4UPvDEj8zwUx2yFC4aX4pe2Fc+RitMObao2uE8abb9pD0R6s1?=
 =?us-ascii?Q?IOq5xjkb7TRnwo3A4+6R3iS/JK3p4CTIvvujPHng0CrGjwsx1EP7qppPndVZ?=
 =?us-ascii?Q?6UncLC8pi7yqpEPYEbNeGRMKvM80jUsUwlkFbzioABaJ1PYRP7Wldj0z22J4?=
 =?us-ascii?Q?wZQsfz2MAiCd5icEcgj00y6QNfCj2Bf9+TnWCZYk3dHK8GC6Q508t9mcNnud?=
 =?us-ascii?Q?iKO2qYaegf8msnJSDBUs2FGnOk3/s2HffNE0044AyYY1PqcEp8lduPskzPzA?=
 =?us-ascii?Q?8TQZTlqSGPX7PZdupR58eCFuMf+M2+oZKVzizjSISAtJYh2f1bKW4hTQvixx?=
 =?us-ascii?Q?Oc7C6qvs/rAV86PxvCULGUwOQqG6udWi76n8+O0eTLKpk2KRWziAgHbx29Xj?=
 =?us-ascii?Q?hMv38+dl4rmyyzOAUAcSdXAQOavOyguJBRRXD1zw+THAmMRGwK9LIW0qStOf?=
 =?us-ascii?Q?HbKTJ9OD2PetvvhoQTqxYXjJ?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd1472cd-5f19-439e-c629-08d98e40c64b
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 11:58:30.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e4jvxWZ8W1AIXcFmnyUuVgydqBq/c6sLS+uNPSZpoQzVmsGoi8t+TY2x9s4dGQbdbIrKM2AB6667OoDEE59MJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3148
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

coccicheck complains about the use of snprintf() in sysfs show functions.

Fix the following coccicheck warning:
drivers/md/bcache/sysfs.h:54:12-20: WARNING: use scnprintf or sprintf.

Implement sysfs_print() by sysfs_emit() and remove snprint() since no one 
uses it any more.

Suggested-by: Coly Li <colyli@suse.de>
Signed-off-by: Qing Wang <wangqing@vivo.com>
---
 drivers/md/bcache/sysfs.h | 18 ++++++++++++++++--
 drivers/md/bcache/util.h  | 17 -----------------
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
index 215df32..c1752ba
--- a/drivers/md/bcache/sysfs.h
+++ b/drivers/md/bcache/sysfs.h
@@ -51,13 +51,27 @@ STORE(fn)								\
 #define sysfs_printf(file, fmt, ...)					\
 do {									\
 	if (attr == &sysfs_ ## file)					\
-		return snprintf(buf, PAGE_SIZE, fmt "\n", __VA_ARGS__);	\
+		return sysfs_emit(buf, fmt "\n", __VA_ARGS__);	\
 } while (0)
 
 #define sysfs_print(file, var)						\
 do {									\
 	if (attr == &sysfs_ ## file)					\
-		return snprint(buf, PAGE_SIZE, var);			\
+		return sysfs_emit(buf,						\
+				__builtin_types_compatible_p(typeof(var), int)		\
+					 ? "%i\n" :				\
+				__builtin_types_compatible_p(typeof(var), unsigned int)	\
+					 ? "%u\n" :				\
+				__builtin_types_compatible_p(typeof(var), long)		\
+					 ? "%li\n" :			\
+				__builtin_types_compatible_p(typeof(var), unsigned long)\
+					 ? "%lu\n" :			\
+				__builtin_types_compatible_p(typeof(var), int64_t)	\
+					 ? "%lli\n" :			\
+				__builtin_types_compatible_p(typeof(var), uint64_t)	\
+					 ? "%llu\n" :			\
+				__builtin_types_compatible_p(typeof(var), const char *)	\
+					 ? "%s\n" : "%i\n", var);	\
 } while (0)
 
 #define sysfs_hprint(file, val)						\
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index b64460a..fecdea1
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -340,23 +340,6 @@ static inline int bch_strtoul_h(const char *cp, long *res)
 	_r;								\
 })
 
-#define snprint(buf, size, var)						\
-	snprintf(buf, size,						\
-		__builtin_types_compatible_p(typeof(var), int)		\
-		     ? "%i\n" :						\
-		__builtin_types_compatible_p(typeof(var), unsigned int)	\
-		     ? "%u\n" :						\
-		__builtin_types_compatible_p(typeof(var), long)		\
-		     ? "%li\n" :					\
-		__builtin_types_compatible_p(typeof(var), unsigned long)\
-		     ? "%lu\n" :					\
-		__builtin_types_compatible_p(typeof(var), int64_t)	\
-		     ? "%lli\n" :					\
-		__builtin_types_compatible_p(typeof(var), uint64_t)	\
-		     ? "%llu\n" :					\
-		__builtin_types_compatible_p(typeof(var), const char *)	\
-		     ? "%s\n" : "%i\n", var)
-
 ssize_t bch_hprint(char *buf, int64_t v);
 
 bool bch_is_zero(const char *p, size_t n);
-- 
2.7.4

