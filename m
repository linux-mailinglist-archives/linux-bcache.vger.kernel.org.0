Return-Path: <linux-bcache+bounces-1182-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F600B208E6
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Aug 2025 14:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C9DC2A16CB
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Aug 2025 12:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA4A2DCF6E;
	Mon, 11 Aug 2025 12:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="gTVbVPfE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013042.outbound.protection.outlook.com [52.101.127.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC7225D558;
	Mon, 11 Aug 2025 12:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754915818; cv=fail; b=gNtPqkAj7tnl12lrg3OkFBARJz0OVHpLeOi9kjoRG+ZBI6ZOhl/PQS1C8o8Q/MlfiEVe5z/oJfl3mFk9xoL9wQFmQ386+A1rdKruAawMnmluHze90iUmDRTpQ4D1TlUWV96JViN2maLQ7LyhRHPlb04tgHTSezMRvHVV6Zr4a3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754915818; c=relaxed/simple;
	bh=0tdY8CtYwuVwaTTdr62wdpC577/PSEPqLp9D68/J+Lw=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=mfxPtgOBS2EF+5j+7luQrR2wIfiaGw594uJT8ItmunLKppB5Qnaa5CtE2pOnL8bexLcg7SmTPSM7lL/8XtTa7+LWIKTXvJbMbnqke5Q3dIdCxVKKHu1a5qHBniqfi8von8k6OwyQr2O66NCrM1NkyCQ7buQg/mauc3d2LEc/UYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=gTVbVPfE; arc=fail smtp.client-ip=52.101.127.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K3sDQ9X6k7dR7ltO2GkCGTVo6qXBdlZ9pDVDRcj95cjAr/1hUYgYASJOmJ+5nlEN2/ZC4JCSPa7jZ2sa0jNDfoxLKUedvh7zxbFJmyy8ygP29WZQu2SxB7B+swayBmGBEcW2agqx/pXISGXLgJHh4rUPr4jFLd5HvD1xrqQhMCATgwmPjcA0xiC3JEbtjoF2GaUItRqSX6421b8SxO2uRBzgx+6oJWQSajAqq8X8nc7bM5hb0RgTQ5rvnmSFFm5oWX1K4/eX/aV5U8kAKEA+jlPzgJjsr7HVm8O/WKp06l3lSmO3mQZQpT5NZt5v3V7IIOS/fs7pN3O1X6U8MpVJ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHxqpTjVpLmFPT4JD4kKxKeMZBL0H0qF4ilGj10ABYY=;
 b=c7uKfOZAyNnOrWXhQLmsKC5OrOC1nZO46VQFSoyXyVG5Xj7Xqpa3VCVli8BCC6ycd7vIlFrBdtyWf+Hv4U5mzsITkilqC+FOfvYb6Z8DxiPlC95Ftw+p2oXoTJpOyFPhlu2B6jfbO/U0feJPYi4Hc274mHaKo4nupuGYVghtSAOMVHRWOBJIsyt9LjV2BpdqHxcG5c/ySsES8LM1NUR6twucfkcjUfTnekUuqPB1RgV+S6b+sdY9BDpXrNAUoUMJr0LuERm8dhUhcsPNsk542ZxnCNsvuaapjlGqpN8+pIxYkxiPTcz2MBVxQzPbX3FV5QqSUvrX3iaR6CSRJ3mwcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHxqpTjVpLmFPT4JD4kKxKeMZBL0H0qF4ilGj10ABYY=;
 b=gTVbVPfEJK39ppXOWfyQkX+5gz5J9nyGk1kr7p+LOUh7F6OGB8QI06bYdTKJF0ne+G6oeSWfW730cHpy3zu37laPSzQkT5BbJyIhMbilWK8R99T0LlfRK14vnhswTt0QbyHVYw+MnHfJYtBVvxZQYFSf/8xsvlIq1hO7hg25aI3es2UjiAXf/wvp4PIOgKiPUNncuyt09RuWD9FHfxkkcPTOI9yOo3EPMoVwyp6LURcC5BYwsuvYihHxnHFnDMPvWGFcJ4tde3lwFZdopYqrraxwCco2t19KQ4hSw7R1Kc0X47PcJ61YXmMBYRv+XRPsEV1AJdDLFMVKtLzf3AeHig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEZPR06MB6870.apcprd06.prod.outlook.com (2603:1096:101:19d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.21; Mon, 11 Aug 2025 12:36:50 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 12:36:50 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-bcache@vger.kernel.org (open list:BCACHE (BLOCK LAYER CACHE)),
	linux-kernel@vger.kernel.org (open list),
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 0/3] md: remove redundant __GFP_NOWARN
Date: Mon, 11 Aug 2025 20:36:34 +0800
Message-Id: <20250811123638.550822-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0033.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::21) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEZPR06MB6870:EE_
X-MS-Office365-Filtering-Correlation-Id: a2d61359-de3e-45b9-b303-08ddd8d3be73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|7416014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gvIs8fhAPSu+O9W8Fu2xBqIm/fRAPcARgF9VvkeK28iKB9L8VQK/Aht0wogz?=
 =?us-ascii?Q?mnmfcFmpAjGCJ2DcPF1XwgVHjRY5yNLOAHxt6eeG0On24Z2zMdb2W6jwn2Fa?=
 =?us-ascii?Q?pYjRBwsxh5eZ1+WbKF1Ztx4748m38zOVcTDgSDyQUmByVMh7ulUu9n01G1Dv?=
 =?us-ascii?Q?YKcIyeQqOhgkKAeUWtC5aZY1T29qG0WJdEJPRXCWsjpmxL+pvD48zRMKDPeM?=
 =?us-ascii?Q?67qej0Q02KbHFdFmoufnnuImqeb/EjERqpCIJKlH6tPDG6Td3DDj1aIhZWyK?=
 =?us-ascii?Q?FowzDzgv/dKlN7Q+1IZRkK0+4+jbqxEwSNUO9DizbB0u2F81gw2ZGvZatA7+?=
 =?us-ascii?Q?VsU/hK8pnJrJu1EmRyz3wRhLzceHGJcOxio6On6rpAyfwgOJZY+uwkHimQhb?=
 =?us-ascii?Q?oF9LhIdbdIV83Nqih+O/jBCxnb9mT9k+G0/gTWkmOKaEfBQ5rHTe4oIae1nR?=
 =?us-ascii?Q?VGFsTiwqaxqfSsE8l0ClUd6oO1VTqDrZ/JPgHEdO3IbWJzD18rSmd15FNYDY?=
 =?us-ascii?Q?FzUD0X2Qko8yT1bpQkoxb7ZK/lwmuJbLsEVXPsAkoV12V2YFEOVp48b1TsFB?=
 =?us-ascii?Q?vgVvQp3gfx6fAUR81s64jpMj/DT5Kw13PXRp0UkJvKcfcf3vI3ZqHcaEkwL8?=
 =?us-ascii?Q?qR67JM5ZtLEvinLk5inYYoYiuNYw0qTGbce7ex2zQPK9FzOjIvcegs7B0zC4?=
 =?us-ascii?Q?wnfDMARJP/KLbIKzGI8mgxBibeYNceOiuSyxHg/U8Ca1lOfX5/CvdSW3xtHz?=
 =?us-ascii?Q?BFtHO5HbQ6lRQHHvzKEpR5ETSO1dX0M4efVpr9NsgeBaQnpaQL1zp8cI6AwT?=
 =?us-ascii?Q?cPQtTDlISLMQe92SdXpaQ54LH6cq0YXN+BX4KfI+ZPuG/sOHdreU6O57NT2K?=
 =?us-ascii?Q?okNtymO8uv0mWodOi+BlqNAFarJC2yzw50pYX7ilgXwAbg/TPUzymuNItVJ6?=
 =?us-ascii?Q?vuy60WVbadkdi98MoinaR/B8Mw41EU5qjO7sz7cIQMr5MQMfqvtwn0x0melF?=
 =?us-ascii?Q?Cc2G/0v7tsvRWWpoKGiJXDzqTKMEUP5OANKmASYe2RJ/uFRN8kRrRsBpxh0F?=
 =?us-ascii?Q?6nDHMJmYHDOCoYyNXnRS9Y56U8Ju1Rj+WQ+gbv8mL5m5t+SfLeo/8BHBer4m?=
 =?us-ascii?Q?nRF9Af5FYfei2w8cEzqP8Iz06cXDsfhSHEvDhxDSucjBUB7SVhfelYnjtTEy?=
 =?us-ascii?Q?Jp89oZE+co8PgXgz/wPfYyChqAO78m7hoa5BrUnxOGN8OkDxY4yiomQzVK+o?=
 =?us-ascii?Q?H3ZZNsL2XiHVQN0blED2pVXXYBHB4az9vx1uMwBXJm4Um5MiKLW6G1HWgRMG?=
 =?us-ascii?Q?c8TcbCmv4eRXgiw3nGPbtIORRS+kTyDshmUngdQ9Nsjxi/K01JIQ0pl2xEx5?=
 =?us-ascii?Q?GNaXpHEnp0EpZFIoHFXHKSuudvF/vczABWIIeQdgpF4MB42wzQbCjetzY+J8?=
 =?us-ascii?Q?MW+5p5lt3UX+EvCrhUg0FL31yhbNalez1tMsWdfBVkzHfX5K/X29jgc8gxuz?=
 =?us-ascii?Q?T8S9EGiBHHjJmVo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(7416014)(376014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ChzhFCkdYLMYMq4bEuHM5P3HHI104OcJ44zrvdp6wZvwemjzPzH8Dyxazf8l?=
 =?us-ascii?Q?QOQ4ZT3gb7E9BNwlSwPAZx1ImW914Uo2uKnutVH32G2DUIByQi5VoKBsEuN6?=
 =?us-ascii?Q?OYy5f+MoNVM+jaaGuZaxYbdWUOh5l2GuOcVZYoTJNpETD9GhJLvgk5DuikCD?=
 =?us-ascii?Q?UZd3rhYviqBxMVXM7B8/v593QVvJ6poWy7aUCcwFN0Vf12aTTI15Y55tkptz?=
 =?us-ascii?Q?izuhfsEtn0BjVfKDxYBegPMi9SRYKfeAT5jx40Gv0Za+V9A7bsYN9UIxIru2?=
 =?us-ascii?Q?2T+vHyu2Oe8dMg450sBuc+t0AqD8PkkrekxvNE6usKqLI49LoUli2/r7S9WY?=
 =?us-ascii?Q?WswqO/2pWQb76YQ7obtBUf/WAkvf3on1NzhLn9Zvn6ptrqzhP41jOBIo/g9L?=
 =?us-ascii?Q?ehRfkZ03tQD/Pyut6v3hIhsErkJiOr6s33DBIb54ZWSMRt8HhF1URoBYFPuf?=
 =?us-ascii?Q?D09Klbd5W1iCavVUGwsq3fFMuWY15wzgIQy08UY/vQ8IX95tM3DZS0f7a6c6?=
 =?us-ascii?Q?lA3p5PCrt9MEkcvpXLkA+Jcb01B1nNWfa+eI2RS4VJM66pkUla8P0xvNGM9u?=
 =?us-ascii?Q?H5U8mcrtPajaT9dvQ6XMwp/NizHAgLoWUrl7YlYPaIM8z9MMapOR7Bsj9KY+?=
 =?us-ascii?Q?kmFgzvT8EkRVO0EuLnManrteCbljD24LUCI26EgIebOOd8FOBvNVES3E4E2k?=
 =?us-ascii?Q?HStX9KlZeQKwtP5AP2yqqyjXWjcaHtn6N42Oc8Yvt+gl8O0aAVUYVyASJmUs?=
 =?us-ascii?Q?Igg7lIRmaBjcyDkfTMYWOe52RMhuw20qHWgcWehnh2KPXFzEg4jrdd4wbM06?=
 =?us-ascii?Q?h/leIigbi5FCPIUh+j1GlitsFGwR728ogcijXXcq3QbSgIlb5trfvoRp7wmk?=
 =?us-ascii?Q?HkZ385PMv8An5vtl1POzrHkziBrKG51MzznO3Ne6OXas3fgAxmIc3qaLqs3v?=
 =?us-ascii?Q?D+7LBtSsFkUDwntvTaFKDd00l1vPzdFkz1gvQ+FedG1hq74pGIyzOLuAtaoI?=
 =?us-ascii?Q?Tjydl0eeRYsbugT8hUdpedJvEchPN04fEU+ok2IZlSyBKVLtFwyiffT9q3HE?=
 =?us-ascii?Q?eUFxSGqb8IDhjbsI6z34LvG9B8wBoi4fyaIEnufKfun2L0Z36oZwrHUIl5Wg?=
 =?us-ascii?Q?ZxosSJYGE+AyyvuDYUKROeIosYfeU245PT1ZJaZ4aYb6OGX783k/+39INCOD?=
 =?us-ascii?Q?oFfBZUcYT9yXNzIfFdDglnGIKTxPjZsw3e7fks6YuKiOk2MqCLS6AU0CnsXF?=
 =?us-ascii?Q?hU4u/AcEqxcBOXygAQO6/e30ZqaO0FHKa73RbboxWgyLSdybRKNuio2PN6at?=
 =?us-ascii?Q?sVMkotMUgS4SHNuk7Kead69fF6dKy7GoIm6oyvbzf9fnGyJWPRsZ7Lnty/Ta?=
 =?us-ascii?Q?b6JyUSQok7vZ49Cm26TezrlY2WOanSbWdqJeaBYaY0DaLf2RCNIM9cs/ZpZD?=
 =?us-ascii?Q?O8e9al+z7yVFYub15S+OKOk9NMbK72zWkGGAJwzQNPR8CvrqvbHdE0ky2gf9?=
 =?us-ascii?Q?QgSK2rIvXyTzXVnyMQsGhbXiyMrAzbdvm2N2/K1LZAGBCI4kXExC6LCoSCB6?=
 =?us-ascii?Q?VxTud+gIYpgnAGvnAv17fJMDaOdbC1fMwUqLAfZq?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d61359-de3e-45b9-b303-08ddd8d3be73
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 12:36:50.3808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sH2SlLhRdUcD8M4Qad5mkP6AoJsQWExuo5ioSRQ+fMl+RO7azYNU1csisIYuMHHhzJ7V5Vk+WtemGSmszH2GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6870

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
`GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
redundant flags across subsystems.

No functional changes.

Qianfeng Rong (3):
  bcache: remove redundant __GFP_NOWARN
  dm bufio: remove redundant __GFP_NOWARN
  md/raid5: remove redundant __GFP_NOWARN

 drivers/md/bcache/btree.c |  2 +-
 drivers/md/dm-bufio.c     | 10 +++++-----
 drivers/md/raid5-cache.c  |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.34.1


