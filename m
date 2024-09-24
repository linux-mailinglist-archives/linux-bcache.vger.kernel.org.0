Return-Path: <linux-bcache+bounces-732-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C35D19841E2
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Sep 2024 11:18:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 528441F2157F
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Sep 2024 09:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5A415624C;
	Tue, 24 Sep 2024 09:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="TtkNOkpB"
X-Original-To: linux-bcache@vger.kernel.org
Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011030.outbound.protection.outlook.com [52.101.129.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C506155326;
	Tue, 24 Sep 2024 09:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727169478; cv=fail; b=s8Ca+dqe9YHl9EunJ7T9EX4d+he03BhoqnGsxVK5LdCx2Xw8fLky0f44GSfbp5mHRhd0x4qo46c4LU6AT5F2mMKm69haarrAexSZ87tEOaRVDYZdd5JzxXdTju48ATrq72yZndEcUqqH4aeekJdfVfVrCoZR+qIv6pT4+eNAyWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727169478; c=relaxed/simple;
	bh=PzKGdT9r68X2St2Yl/ux5REatpWcTG8HjQasN04VWdA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=t8HrzZdnkj5YhB57xDbOFss+lgQpp9KSxFgrhXI8Z0PXgAn85emk9Fe89Bderzgj6zEh75KQqwqFHAYbdJzD8SqHKX4RYya9afMcqy3oVouGZdgZ4V++u0rApvW/2rvcE5aaQKbcu4ZgB+pQhtMYMVJ5EnRmiVoXNSxb6EuddDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=TtkNOkpB; arc=fail smtp.client-ip=52.101.129.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wmWg/+4uyTSwDEPmOZYsgr2ClM85BSn82in5Fe50hjiXSHGrAPa+T1yCNuvDgMZGG7RD2rnhaIqPaj3oUvF6hve1qBpXhB4opXBTg1gpGVWbJpKYsK5QWwTDvPBEuOM4Q7Eb2JZBbXkdllBelX1jYzBFB1QKZ/gYbG1g3rc5VUMpx1e2jCyINV8fgXgmEUHWfrgOxAV9LgohgRRA403DVbDcF8qw10OOsFr8zmqf2IAUdDAsouC326MNHq8XQwA17qJsseN5j+zpTd4T5KOTTsru2j4xVEmNSbpihT0ZdTsv5DHM6WgyvSrcQw42vTCQQPOAdYvUZ0CcEQWwYCYUTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfwcUBTRkZmUI6hc4EOtU2psigqzW+B6iMtqkgf2Nx4=;
 b=ZRfP6wWUioks4UAxD+tBqGvdXZ8CY7tNKv9lyVstocjtMZ+LMltwRJLWFzhi1rN4dhZynl7Qe/XlqlBegoBxQyvdl/yOWbAUkkHpEpXSCceduwupTjV8iI2ZRyKTdnRHhE+A89p4a7HBUcbtyAjKg2IEoPOPj6UwO12TrRCWBgeG9PK2ltp7G7lkfiMJvDzOwX228NLs62jgsVuUewOe/zl861zlSa285qLp8V+40ckfjFYX9GGmqNTH+y3fW+CKIH8yn4FSwDx9O70CoQFeCgS305fZ+YIX2Bo9bfzn9okJllGpmH8gh4pjm2WliQIR6nz7naYi2gwYEmWpoJTGRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfwcUBTRkZmUI6hc4EOtU2psigqzW+B6iMtqkgf2Nx4=;
 b=TtkNOkpB9mLxxfxvFqVV7VManyDFvsZ+7XsVwy0avFaSCH28YWDsyewWaYEzLKIeD8BiEItuGM5RPenx0OGYXH7GTMYm3yRtRJuprYPcy+qiyh2YFl091jFVYV2e2G63Da04AnY3jzDixYcUVXda4ZU2W7kRG8VAfICqMy5Hc3MEh8SnqfRaBsisxACejJaE6gfF7fLAwFS2AJw4+nn1JT/YAPx3+DiI3AsEn7gsW+sWvgrQeyGE7wplbRO3+NtHZ3JrPQtI0/scAGZESfaBJq11u7ymjM/H9ySN/gvw/NveKcoiEiYSd/BmyWy/UmFMypvZwd3xxtumyAHIsGXpOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com (2603:1096:101:e3::16)
 by TYUPR06MB6123.apcprd06.prod.outlook.com (2603:1096:400:352::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Tue, 24 Sep
 2024 09:17:48 +0000
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce]) by SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce%3]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 09:17:48 +0000
From: Shen Lichuan <shenlichuan@vivo.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org
Cc: yukuai3@huawei.com,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	Shen Lichuan <shenlichuan@vivo.com>
Subject: [PATCH v1] md: Correct typos in multiple comments across various files
Date: Tue, 24 Sep 2024 17:17:33 +0800
Message-Id: <20240924091733.8370-1-shenlichuan@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SEZPR06MB5899.apcprd06.prod.outlook.com
 (2603:1096:101:e3::16)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5899:EE_|TYUPR06MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: 96346940-5766-47ac-2142-08dcdc79c1ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YrJQiNBvR9kwHgX4swEuqdlAXFNoSx4Ag0tPD/vD2yeKcZZDikh86GomuJ14?=
 =?us-ascii?Q?EuSZRw/znCRzDWMjs8qHk9UnT/kL0AOtc4EcGYfYOi8Hcx/XofFZOiBlD5vP?=
 =?us-ascii?Q?AqRPDzAIA54ps9o6zHpo2GwDGeSAJ/kDbm8yb+f5boFwqvE/xnRRz0kC5b5W?=
 =?us-ascii?Q?qjGg5bUqUZ21x3oC0XKgek80VLHmCunN7amvbDghvyOJ2nNTo9g2PQkFAPVD?=
 =?us-ascii?Q?vVBAxSdkbE/uqXXVunplx4/zKWGKsUkTVqR2+t7gC/h/Qckx7y+1yFZIBvIw?=
 =?us-ascii?Q?WrOV4lRKOR9vQgozMQOSdEMRb7Ig3eG/8oJ/PmWv6OTZpzsmJNzgNwKN/oY3?=
 =?us-ascii?Q?IUSphA3zLQWJXbQH+0te5kRwycJ2SkfGXBQuB4VmS1GfK4676lKLUYdQlKAX?=
 =?us-ascii?Q?oDJzHHT+OCQf+7C4JyrrHoZDo5BfeF7RcM9cvY2amHo2Whr7Kmnvcz/fkZ+U?=
 =?us-ascii?Q?7RJm9uvdO6/7HCrFzUSazSCy1fg/NGQq9/0Ow7zI0AT1FZ99sKCzOVhW6dxe?=
 =?us-ascii?Q?YeUcnQAM/K5KyVsLmSrXIyFnwbmwYqENZUe2ktYIzxv3BsXUyBXwe7fUfCyR?=
 =?us-ascii?Q?w9eMbIRMN66ijrSnrqhqMmKWsr/DxxdPShVrLNaeObSBvTv2mC1SImWWfZJs?=
 =?us-ascii?Q?tKecQeY4zqz9ygPsWkGnz+TPXOvl2yZl0HXUwUxZSR2Ew27hZy9Rn5gZ7zBJ?=
 =?us-ascii?Q?tWqWDob+MTdnYfPBpkNRC3HHuVuTN2MoH28U6FzC7Z/h6jOr2/13DB7vZ/Bm?=
 =?us-ascii?Q?CgXqsDrkJp3WrSBTGukwTusTC372i4vtHfVpmFDMS3ZZVUlU+oebBEJQ94C+?=
 =?us-ascii?Q?L/Hca7+UJcFkl+mncF3ulXAx9QYYCbEXvpN0ZJ8NpdNtj8QYH4zOivJLG+uh?=
 =?us-ascii?Q?fyrzQWGsPl60XKR6SB1t50QpqDpj+H1TY6l85B179lh5rhZxSI0W/ITwJHBf?=
 =?us-ascii?Q?gZrMT8EsYlZwPGkGKm7h+1FhbfG3ipGE7bgxP9gNJMeDnsaZWl8Usv7SBeGH?=
 =?us-ascii?Q?nUiuT4J33+Na2GuUeVQFR+vrRMGb7vWmps47RA4u9rgNzOmsBZ8kq5g+/T5T?=
 =?us-ascii?Q?Zh00qGnoBw+nwbJuo3O9aq3DSasG0Uby7FCty43rA2fBcbfUawszLeGKPK5p?=
 =?us-ascii?Q?7CiCOwL+zFyPwRA4yBuWG3Y3AC13OCzGVMC2cQCmEidmy6peHQfYQjafTD7s?=
 =?us-ascii?Q?dJFeLKVloHsESrnZYE/x07Y/EfdUF9PE7XXSBpmbUzameaYK7m6BElfjXoxo?=
 =?us-ascii?Q?KMAERkOt4L2udKevvs9uOKcLQ4AoE3gNwQEmHnVKEOsXeXp7u8BxvZxYxd6X?=
 =?us-ascii?Q?Qd6PxgRHNu71hbx8Ki6Mdw20e/n9SWcBcr3uDRrStnWHJJXvOQsaXEqCXbCG?=
 =?us-ascii?Q?QX1R3eyKWkpdnZ82vLUuqzG4BoMoOzGhsJoOXYeOG5MDQVkeqA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5899.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z3QOfrjYhDsLxKIb7nBWXCTMUKizkokAaAWSNH3ujDnVVkJMCtnYYuv2LLMi?=
 =?us-ascii?Q?PbJgfULc+Cfj6GokjTcfSLAixMDW20zlxyjiwAWSy4C2/NmMpW+BmqvhUyj8?=
 =?us-ascii?Q?63qI3ZLz0xDVNSFug8o8L+LP6Tkqdbztt9UDsE7c6d6Ww9IDoQ6elYWR6J1+?=
 =?us-ascii?Q?Cds/DEAYF3Stjdi4I3cnrXY7skGZWbOSnOsMCrc+UGcMaDYA+r7QnbMA83nq?=
 =?us-ascii?Q?JJVpSc1qjVu9qG5btNeVmGsVY/dYRAL2y/cHFysVHqoutL12IvimHp9xice5?=
 =?us-ascii?Q?ykhCJ7RkEILVq6kEQ6/HhaF22DZj8+UOD5sJKxFQilnWcyz4GpiVifUqZDy+?=
 =?us-ascii?Q?nyw6g3up48OZysmFQ3CdzbYdydX8yLnpkvT1ElobgTFTcE38ICl7AXjo/HGZ?=
 =?us-ascii?Q?JYkShEdtfxvyv0tD5XrwDcccQTQHwcPlsGX5U1St/oGzAzoDM+rO8dLTOnyO?=
 =?us-ascii?Q?eQUSeGfNMscQPzLHGzIwDln73Sv8bM3qCQQsqrSlcfaEIpKqPTVWADtyaQxw?=
 =?us-ascii?Q?z7chDAyY9p9YnajYLwisCaoDWWU6gSpylfeiYC+2Czz6dlHmON83BE7MxK3X?=
 =?us-ascii?Q?lKC7CRlW+X6w6PvClGHPNIVcrL8sJsFANtOELmp0hPVA3b2nJ6Y9/AG2PboE?=
 =?us-ascii?Q?V8XjeKXTMu21Jr3CF4zWiCg9jKn49QKzZLHIZrzC9QeOvzAEEasBSIAR31iv?=
 =?us-ascii?Q?xKPVeN959Zg+FnXL+b8hexe1ZwlK8Txlz3w7P0JcFOWUHfpMsrfxAXeH5uy6?=
 =?us-ascii?Q?iO03AykMZf5Dt6ocpQIVbUtzFq2LlbFBltR459MSrGmq4yjAs+wpsVY8Cx+Y?=
 =?us-ascii?Q?ESdqGj76E0Xo84aWXKn8CzBuRUbh7Ax0aRe3dAO1fIyr7edWcZHjjEPXP5bo?=
 =?us-ascii?Q?uYzSzPKrfZN2rIEEw09fjLfD+ENTAoA0Zl/pgkoEHHt9OEBThLcqE0TDi26S?=
 =?us-ascii?Q?pGnsWnVNZkL5VnrwzkXm98QBw3MSsjsGLa3Te/T2UJYVDVAsjVq8yCHKSlUi?=
 =?us-ascii?Q?W1jidoHpX1X1kCZTJ4Ah/5CKfVopnk0pOJbXtQCUzKvZxQM3KegqgiOMRuO7?=
 =?us-ascii?Q?cKcjcFvo+HZijxOsb4ZDX69jVlupP0jU/iqFstuj4l5oj0V0lWahRmB896gL?=
 =?us-ascii?Q?n6UH38K64KU4iwjOuuNhGm/8DtD0VoU1LwVsvTHjxOiBez3ryVI3Ald1ajrp?=
 =?us-ascii?Q?3wpBEoLJ/L1vi3+beeqD0EgCNpiUuavIZgy20c0uZGIDXymi8/dOzNRqy5kT?=
 =?us-ascii?Q?GvReNZGu2I/oR4IaHdbZTGWXaxWKxCDgdp/R+cAW1mcbIu9b098fJCrYCjEP?=
 =?us-ascii?Q?JIPd7Zwt0FRM+RvDBDRUJG85RUrsIfQ5OE4JjFP22JXQVrbI5hhtJE90Xs09?=
 =?us-ascii?Q?m6DC9wD0igHDGGxXUzkTK6i4vNyND58q/G5iy+BxqfQO62yO3K3wKt9tcr/Q?=
 =?us-ascii?Q?1+TRU6kGFNjoloKW1IHxJXksQCJTeJ86eKAGDVY2kZ6ee6C/VcQKcJZiIRz+?=
 =?us-ascii?Q?z2yxHxkc2SLR3BK7Zb4R1Yz2ambg3HTIAfXrtyo28cyrmcnXxpP3MQMC1qc7?=
 =?us-ascii?Q?wYU2T4OwBV7lY2EtmaF8PysZFlVmf0sUBAoGi5BM?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96346940-5766-47ac-2142-08dcdc79c1ef
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5899.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 09:17:48.4280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1+MIriYZH67y2aND3D/TDU+OYxAY7KUortoH6KUpAHyji40g4dq1uCKHjcmacaZ3QeBz5c19se/N6nh7xWsq+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR06MB6123

Fixed some confusing spelling errors that were currently identified,
the details are as follows:

-in the code comments:
	writeback.c: 124:		overrite	==> overwrite
	dm-cache-target.c: 1371:	exclussive	==> exclusive
	dm-raid.c: 2522:		repective	==> respective
	md-cluster.c: 552:		daemaon		==> daemon
	md.c: 511:			entred		==> entered
	raid5-ppl.c: 990:		parial		==> partial

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
---
 drivers/md/bcache/writeback.c | 2 +-
 drivers/md/dm-cache-target.c  | 2 +-
 drivers/md/dm-raid.c          | 2 +-
 drivers/md/md-cluster.c       | 2 +-
 drivers/md/md.c               | 2 +-
 drivers/md/raid5-ppl.c        | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index c1d28e365910..3354a5cd587c 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -121,7 +121,7 @@ static void __update_writeback_rate(struct cached_dev *dc)
 		}
 		fps = div_s64(dirty, dirty_buckets) * fp_term;
 		if (fragment > 3 && fps > proportional_scaled) {
-			/* Only overrite the p when fragment > 3 */
+			/* Only overwrite the p when fragment > 3 */
 			proportional_scaled = fps;
 		}
 	}
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 17f0fab1e254..3e8be29c0a5e 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1368,7 +1368,7 @@ static void mg_copy(struct work_struct *ws)
 			 */
 			bool rb = bio_detain_shared(mg->cache, mg->op->oblock, mg->overwrite_bio);
 
-			BUG_ON(rb); /* An exclussive lock must _not_ be held for this block */
+			BUG_ON(rb); /* An exclusive lock must _not_ be held for this block */
 			mg->overwrite_bio = NULL;
 			inc_io_migrations(mg->cache);
 			mg_full_copy(ws);
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 63682d27fc8d..1e0d3b9b75d6 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2519,7 +2519,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 		rdev->saved_raid_disk = rdev->raid_disk;
 	}
 
-	/* Reshape support -> restore repective data offsets */
+	/* Reshape support -> restore respective data offsets */
 	rdev->data_offset = le64_to_cpu(sb->data_offset);
 	rdev->new_data_offset = le64_to_cpu(sb->new_data_offset);
 
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 6595f89becdb..867af995b767 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -549,7 +549,7 @@ static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg
 
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
 
-	/* daemaon thread must exist */
+	/* daemon thread must exist */
 	thread = rcu_dereference_protected(mddev->thread, true);
 	wait_event(thread->wqueue,
 		   (got_lock = mddev_trylock(mddev)) ||
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 179ee4afe937..11078a4e4951 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -508,7 +508,7 @@ static void __mddev_resume(struct mddev *mddev, bool recovery_needed)
 		return;
 	}
 
-	/* entred the memalloc scope from mddev_suspend() */
+	/* entered the memalloc scope from mddev_suspend() */
 	memalloc_noio_restore(mddev->noio_flag);
 
 	percpu_ref_resurrect(&mddev->active_io);
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index a70cbec12ed0..5323025e7dd9 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -987,7 +987,7 @@ static int ppl_recover(struct ppl_log *log, struct ppl_header *pplhdr,
 		crc = ~0;
 		crc_stored = le32_to_cpu(e->checksum);
 
-		/* read parial parity for this entry and calculate its checksum */
+		/* read partial parity for this entry and calculate its checksum */
 		while (pp_size) {
 			int s = pp_size > PAGE_SIZE ? PAGE_SIZE : pp_size;
 
-- 
2.17.1


