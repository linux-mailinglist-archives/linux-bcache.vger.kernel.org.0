Return-Path: <linux-bcache+bounces-1183-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB578B208ED
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Aug 2025 14:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2131F18A3569
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Aug 2025 12:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F5802DEA6F;
	Mon, 11 Aug 2025 12:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="dADAW8Wu"
X-Original-To: linux-bcache@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013038.outbound.protection.outlook.com [52.101.127.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4558C2D3A88;
	Mon, 11 Aug 2025 12:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754915822; cv=fail; b=pOjcor2rGCM05h6I35g6BPJgb37Icn7udtYBYVcUC3Rg+WWLB768jPPH3N3fQlsaueYVBWeONrKL7amVs1Ql4bmFNcCKnYt1E4S45R/z8AHX9CcOnCG0Da6ZXZaCQuzJRr6WZZ8ob7z8H4OV5Ov1geePRRIysaSSRp34Zh6Py0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754915822; c=relaxed/simple;
	bh=6Pju5yZ1NMdOIZgkoFJqM5lX+Up9cEttRKugLrx4lyI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KXqjRiZLFnRAuLgEeBbtpO3R/e9hNz7dsCOoSpQ4AeP4sAMWikZsU190NLXxM07n2bYnPq0Gol5qPHh3NMqAD8jHBaexB3P8U/9QiykofgUooSAuaaoV8AVK1NL79RThAZOLb8uQXSpchC7Or06hyNbalrJDFNfPU/gVdCQ8w88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=dADAW8Wu; arc=fail smtp.client-ip=52.101.127.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hLKK/xr6hC0c6huXshGvDy94eWsxRcjMIETr6e5B4tMEg4rXEi3vTxZnaH9jwETAXY4ThUUHZaER+i/r/7EskA1XcCRNRSZdard6ZgtbJ2yulfZl9l//kaVKSdBy3/+ttE8lXH2e0Tc2Cb4pV4Co7bFhGwpwKya2QtbIV4Gi3nhAzkznV7IuIXeckfDHIrRERrOFmHV+pBU99JYhoFwCYaQjq1GCH1Uz045VhpmpXdLeOq8Dr1ho1oyQs2PxO8zaMBMgg9Q1XeXkt6mKOwD4xDI7HPqFyCtFqFBMU6lKnxr79J6hF1m4qHJy9z1x4zwjBJ1V6AdJMytpjfiYEz1+5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdLOzUanPr38kXSW2oQRlbieTzKQN03gh7QQr6SMB9k=;
 b=w2ihkM72V6uQT6H2kKbBoQYexE3iy9x7taqJGD7m3jAFN6JltPYiWY2kA3KUgdOBWk+nz5Eal8/l98eaqx+qqp5AilJwmkubnZrjwdp/o6VhV7+nfYiSMWRhtqjbKw1nn4Uti/LGGdKNM4GK7C71dt9PvNNB0H6XnV3IrpMKr86V2/56d9C7Mp9vub9pBgI1GrDO+ZIICvsNRwnMRq9VvRgNCzMP5VHH81iCTGLAV2JVtqE0CSmW2hgwH6eUNFyIf7N18uhp30vtdcQjwQlKoK0rLyLlmIO+4747KXsCEYp9ABbQMB5rhUqjNv/lZ8cyPOSJDrze/JgxUaP8jPeMLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdLOzUanPr38kXSW2oQRlbieTzKQN03gh7QQr6SMB9k=;
 b=dADAW8WuqhuYNYJhEPpbp/Eu/9d32qiuZv5IjIu9mI3oFmXgAN2kjFGNifgszdjevtOI5aaX7TB4tQbj3Z0JqGERDd7xph48DMO3eQGFh17YX2sQCNgZR3YusNywKxCqm843iuaijyppFJYhwIdYUFmFed3843old8fzuslsKVxVs6CDX8buMff+6GWA2Am9fRPUTppHwNu4DcF5lCAUBiEsC1R8VQK6+2TxQhVm81jAc+6Ft0AHAlROBtNQ8O4EnCdatG2WicwF8ULs+vUrwGA2LQJkhSWhO5qhYYyWzo9lT5zU0OZHK7oCSFmxCDGDwrhLRxDffWA708JgLY1ipA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 PS1PPFA1B399C66.apcprd06.prod.outlook.com (2603:1096:308::25f) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.21; Mon, 11 Aug 2025 12:36:53 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 12:36:52 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcache@vger.kernel.org (open list:BCACHE (BLOCK LAYER CACHE)),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 1/3] bcache: remove redundant __GFP_NOWARN
Date: Mon, 11 Aug 2025 20:36:35 +0800
Message-Id: <20250811123638.550822-2-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811123638.550822-1-rongqianfeng@vivo.com>
References: <20250811123638.550822-1-rongqianfeng@vivo.com>
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
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|PS1PPFA1B399C66:EE_
X-MS-Office365-Filtering-Correlation-Id: 630a7f9a-73b1-49bf-ca10-08ddd8d3bff4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VgxEr4J069Mlz9wJ2aUzVhsZAv7j+VoJjXf15uOI6WPcfDZ8c+MUoxNrgGPv?=
 =?us-ascii?Q?Jg8BklqGwJjTSYhyIZJkAWpbifjJ7BPhz3VgzPgeKpuh8IGNBWhO+fAJN6AM?=
 =?us-ascii?Q?mKM17ReUaaDFofv70iIGutiqU2XA/FNN0lVjFwVsFy1xXSt7ylGdISfh/Y2T?=
 =?us-ascii?Q?MmHCHNdkfju26T+w2LWVGSXdNYHo4pvggYbRmimAe3Fc2Kw97wVs48vXqKUu?=
 =?us-ascii?Q?3pzdng0RD3Fsquij5FVFQeNu2uWx9Im2OfzOvAaza39OCtB9RAa96l8wPcDF?=
 =?us-ascii?Q?5m51hqZnIuteCK+Qmk/ktD7onrsxnwMjwPZ5X7cJpqYGY/2bljgQb79HzEiW?=
 =?us-ascii?Q?tHYD8LUFO5sSRythGBH1t5mn2H4MJvZOd6qKINIX4EGMq6oJzSPIf1n/c/K0?=
 =?us-ascii?Q?yqyl9dOvt/Y2Gb2x4xfghc2ktIhwQGJO7hXyld7QPJpyhDY2EfKoXcaYEg3V?=
 =?us-ascii?Q?sdDI+QhQMQWncyoIfi8LanqYlNQVuhRRDImXqSrtm5329lEOupkNn/Nzmei9?=
 =?us-ascii?Q?N8XPX2MgE9krKRI+qso7UkaBKamHbv2xjRUYi0UXAKkSY/9hJGBmnXbb/av7?=
 =?us-ascii?Q?L6T36tWOoUjRIgrCIyOTV7PtYuez4oFiRH0Yy8iGyPFA6TXYOBSGqhRbfdFA?=
 =?us-ascii?Q?DHe13g4aK1ZIu/qsjScUkm79RaD8hGuyk8MsUb77Vo88TRwUUqVdEnAfy5zD?=
 =?us-ascii?Q?GCjNaZ8ICcn0BZmPay7it1hpTadJ/Fy221nrv+XKikxKi5amDBO+B7mlCMKu?=
 =?us-ascii?Q?ZbQUN59V+4KC/IuG+LIofdRklUjGkYD2TRtkWf2cibyRCRaBGnhS0k4KG/Ds?=
 =?us-ascii?Q?0aBLF2G6RStJE271Dm7RS8ytuJUImgioQt3XUoPK0Vm8JhYBOlSKTGwKphAE?=
 =?us-ascii?Q?6fJLAkRF5LI8k4D5/b8NaC9QI1Z8uGF8iBTpNL09o6frLJhnrl1bitVUc7Dl?=
 =?us-ascii?Q?wofHP2n1p6vMPBBOCw+mhNypfrlFdzULQjqyIt0JA8gX5iZsiHnH4UEl044T?=
 =?us-ascii?Q?0eN1mlrH7R5iX3GVGOKQXlPuYYqkbmy92pXstS+Fb0I6j9tJqimtqwzqC+nl?=
 =?us-ascii?Q?HVVxAAkBI9tXZxogWCyyAVAXPu4RPMFi6rfpXc7mhBYwKV7rwsz4y9qAeTRS?=
 =?us-ascii?Q?/zYE0o3+Z6MKYGIrlAzRjtSswwp3pxDsZ0UBttci4pfGBBxI0lsEpcO3yA+V?=
 =?us-ascii?Q?AqTLZdCTeM/p1/aYqmwW8bikLAhkCic0apq9rM8xQEp4wiDLKqtw3lQrw4z0?=
 =?us-ascii?Q?ncux0sHUXH1fJuq8STIZGgVc1H12sKLMUAGFS5e7lDtycMcyKD+jdNAz//lA?=
 =?us-ascii?Q?HMD3qpCBayr9PTjHew4+MgTaduewAf+3/f09NOLJRfEViDCg8D8NGexJGzRv?=
 =?us-ascii?Q?g/DfELPJ58Xj2UgY+JJeUjb6zNm9hU8vyQK15CyWXsrhPenLtRpGFrgE2eSd?=
 =?us-ascii?Q?gLBiYWu3zae5ctVDQ8rms1f/N9l+HBJF/pBI+tdAU9kH4c4+HpzBXQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bD9t2ZM1yvfKnG5otNF83mCRrXIMwrt2cKgF5wGdEQbDasgKd4XnUSyYLPFS?=
 =?us-ascii?Q?OPs7r1TaZ6mI+oVMbHjOoxh7QfEOj0kjpU4M++7q1Ti/hnD4LDHdmaLVPVK3?=
 =?us-ascii?Q?Kn5CuM7YsAonA5/T6U+wMWAVGzHNN1uwhKnAbCg2uhmJxYoTXGstPIMB04U/?=
 =?us-ascii?Q?g+N8ePDPxAxx3878NHYHrmas/NnzgED9eLnEkU3TSeesJfX3k9+CUYwu9b4+?=
 =?us-ascii?Q?CoroucdNQ4wBGYob+r1JwdTpZN+33Q/UrXDwzvgUzacNVm1J9VXB0dqWGpgZ?=
 =?us-ascii?Q?+XP8gdqv82by8ywvh70bqZ9WLwiC6xC/CwX5pPw9kdWwSNEPoUWc+L47vMGd?=
 =?us-ascii?Q?wQ1sqPLtWcOlQ8lMPgNWGbPi/JlncJIZG0hrEb2hUySdvhapXZU1/fE0h897?=
 =?us-ascii?Q?QPi/opClWnwaAPGYOsqBpfGWj8exHNzEy3r+Ha1cGzXXYCF3oEs9B4wgj6Pp?=
 =?us-ascii?Q?RiEDc4yc2cI33s2EUO1ZfySxYrfnLPUi1jW7fhW+w28ch6mX0qZThwR3X4my?=
 =?us-ascii?Q?xxLg7aXxMCFgiyI7zL4IDOHpBg6RDFaAGBJFE2DP/W5UzfwQ/Ywfu96AEdmm?=
 =?us-ascii?Q?sfWIInpQmMkp5DpE460ZAypCMafXZ5efA+SgqOqtvcz4uk8pDcYMyzePAGkF?=
 =?us-ascii?Q?AhHS2r0zHFLJf7/wvBQUbvIgQJZC3+XknZVK34J4Dip4EglmdYBZX8pThRyx?=
 =?us-ascii?Q?hCbBBZe7rJA5QgiYbGatn8p2Jg/Gglu+yvFAXVY5cJuK6jsWlmlLwxl2fWNF?=
 =?us-ascii?Q?g56QP1E10IqaO/jmr3czLEM4rj9zjpwE+Wf7u9ofyu9hyCqgwvgJw5J6Vchb?=
 =?us-ascii?Q?eBcxnHcOnvdtTIwsINM5V7AyR3rtp+3WJ9CIFyp4n3+qN+KA38enmFzSuYlC?=
 =?us-ascii?Q?cqZ1Nt/EWS1RY8xb6NJrUd+RQKTAHPOzo4F9inxGIbU+2LGniloPhib9sS7v?=
 =?us-ascii?Q?pVYH6l0oaDy2I7T1tbP0OjqYUVXfZzzLD4D7BdCy/EiC0zI9MMAiFFVWlDig?=
 =?us-ascii?Q?MqEPF6ov2y6ZeyF3GZq7GBsf5BDNkVzFBQFxg72MMpNJZ81GE1uR5nWvn2G4?=
 =?us-ascii?Q?wdhUsuvrzq5dW/mTYjsB+R5Bv6CEejmt25jBNuwOAp5fjL9zKzdi2Wsge+Iq?=
 =?us-ascii?Q?LJ36ormkk6lvggOYDxOEKqR6rMdCPaqYtmhUXj/oAqZdtuWVA93qxABoRr9t?=
 =?us-ascii?Q?3bAOUdWGERwQsVSnVi5L8aLsIYC7FBTWs4s5mGib6scQQh4jqgFyXqsjupVP?=
 =?us-ascii?Q?8x1uyIqO+ELreRc0hDXrtow6y4vl+r9y2+UDQIjBFyABuGalFcYlylTy0Gll?=
 =?us-ascii?Q?rZyRYIYD9wC+O87hmGcrh4fKD0m/O453RcL/eo1qA0wGYOHoasW5XFsrqmqN?=
 =?us-ascii?Q?oQAwX2PAMkw/w1ezG2JbOZmQaGlufr0FIgZBQ/h+5RTSWNDrlSxzBHYa2Qyw?=
 =?us-ascii?Q?64fZJieH6Cy6CkIh+Dw275Cy19tZfXaaiaf2CCyC9nxMIKirjQNtL1Pglx4u?=
 =?us-ascii?Q?IMgxV3xH9fNGtUptIdnfQTBfC45IDFzOypM9DtEeQJX4f/97VA6NRJqAYwCY?=
 =?us-ascii?Q?m1jZiOO1ALaCnIkj2uvUKTleU3TXONEkR0V+P3en?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 630a7f9a-73b1-49bf-ca10-08ddd8d3bff4
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 12:36:52.8924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qJ9yR0nwawaa76rK5Co8iR9Ezd0B08x0+a0KsFBb0N/T1B8cQj1gJOo28nodJsNzwwv7WOANsL8Z2I7CWOjVTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPFA1B399C66

GFP_NOWAIT already includes __GFP_NOWARN, so let's remove the redundant
__GFP_NOWARN.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 210b59007d98..a764ec149d7a 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -371,7 +371,7 @@ static void do_btree_node_write(struct btree *b)
 	SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) +
 		       bset_sector_offset(&b->keys, i));
 
-	if (!bch_bio_alloc_pages(b->bio, __GFP_NOWARN|GFP_NOWAIT)) {
+	if (!bch_bio_alloc_pages(b->bio, GFP_NOWAIT)) {
 		struct bio_vec *bv;
 		void *addr = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
 		struct bvec_iter_all iter_all;
-- 
2.34.1


