Return-Path: <linux-bcache+bounces-812-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98E669E00D8
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 12:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8BF0B24D10
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 11:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24CD4209F20;
	Mon,  2 Dec 2024 11:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LGmEWgeo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PZD0VZur"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CD6209666;
	Mon,  2 Dec 2024 11:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733138453; cv=fail; b=P+zXjjPmyOmvrWfaax4Aq0nW8eNomwULJYGiktVvm0/+sfltEPQY7SMwTRGO1mKx8ftrMAQycRPIsZ3ESu8xQZJntMIcYsMScsCDGN2y2iNrsdOLmSIzPdiS3md9qoM/dRsqG+HNfixjoE5J6I4vVanHpPtL1+lpzwU9Mxv7EGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733138453; c=relaxed/simple;
	bh=Hch1TKXC8Voj8NwJTSnJyynhqePBiF3s9AGX+F3CrfQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TJ3KG8ldxotb9Nt6DEhrht/P5Ibk7ova5jPFqbSIFTC6EQO0Q470xpSo2Sxqj7NN5M0xmtxJlBlPyhToYBoroGZ496vi1GFxRu7XTkgmTE86X590PUCmZ4rUcCR0Lh55YO5gz9G1YzMige5c9FEJLYYEyPCqsQW2rB6IVsemvh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LGmEWgeo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PZD0VZur; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B26WxFJ015031;
	Mon, 2 Dec 2024 11:20:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=rkx9dXnkSsPVlEU9j7w4UiMEakhiBxgGjW6xPzOuwtE=; b=
	LGmEWgeoYjIsOwvM0klnZ73J66t1Eyue4/eHdl0nVDbQs/cfWQ5kPfFf5UyQZdHF
	cINDzgOsx4QGtChai+aci2+bvhug6NlET3Kush/upJIJPeng9gZiKEza79MJL81/
	obymCIad416IYHnj6pcu2F3Az/kchtAezK6Mzfy3+6v1Rw5SM8cBKA2WTvzqSguM
	fsFTQOIS2D3BDouKVp0F83alCWjRYZUi6Jh8oIeD6DQkOPLxu9HhXm4xYynoq8Ez
	j6AKD4ALEitRf0AsweyX1PSVJLuGNiT30NYWKvPOjQ1dqfV8jmRyIcQyaRNLcAG5
	PY5b7khCXH6Zd3sIzhjF6A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437smaan4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 11:20:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2AJJZP032114;
	Mon, 2 Dec 2024 11:20:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s56evge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 11:20:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=reQQexTtM5MvyMi6oIiMKOAU9zfRrE6g7f80CSm3iq0YpFEBzWQecQuDNNvnB+BXYl8GYCdKH53q5Q5XE4d02SRkvYtEKc84AhzdzadhnihPsWeFkwGj/gK0NV4DN5sE584/hz2LBL0XfdsLti7vUhiEf2R7dAPCDf4s/BMAeBepLdQKLlxqoe0oreiFZmaavGfWvV/IA3Z/Mdeq1LpBcsMdAQZ2WVB15nFwZOzysUA+P0uLW7lDgsTJI/CyQ9bzv7JiJBv7SBmDh4K2RqgCvkmsfb3CbVPE4yBPfgvsKmRK+fRuco9TapWD0YM2fPVdl5grQAaz/+M5pG2ZiMyq+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkx9dXnkSsPVlEU9j7w4UiMEakhiBxgGjW6xPzOuwtE=;
 b=hNsy7IHxJb/uvCdJvSKglzjI+jrzYhcROZRdrAcE+8gIYm9gNLWsCkMPD5rFhwAugEpGMgo6MZm9Hirvu/T/8nH7Dho5F70w31GuX2hp8SBVv7FBE/IkhUOTCjCtVCd44Ulg7IMdTjSZG6Ifhrt/ZKiipObK6E2B30l7JG5N6s4hTVeOFefGuq5DFKRFt8+prqWL6ZPIux6J3rIbAilCtbJIUnYFFxYiq7OoIppvpI9yAbB64qxpYkW9SRo1CThjz7GceVlVBeZ0GM6q6Rc9FvNbWvKRk25K5SbSdKRHi1ypN5iseeY2YZn7mgSF3KqaXGleV1/Exe6vJsaXvL5TTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkx9dXnkSsPVlEU9j7w4UiMEakhiBxgGjW6xPzOuwtE=;
 b=PZD0VZurdNcDcyALwuf3fl/ByKP0PDAw3vRp8owse3IONX0kLbWpiPxKHOZhcJdrpypGQKpYjagzO6eJXnnao9NOVsevF1l9lWg5rO5picco1Qvl08t4I4/kbsMdHZKgiUZd/21hD4lkn8sURsv5YzS0Yq9UALdo9tP31/hlocg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4728.namprd10.prod.outlook.com (2603:10b6:510:3b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Mon, 2 Dec
 2024 11:20:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 11:20:25 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk
Cc: haris.iqbal@ionos.com, jinpu.wang@ionos.com, colyli@suse.de,
        kent.overstreet@linux.dev, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, hch@lst.de,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/2] block: Delete bio_set_prio()
Date: Mon,  2 Dec 2024 11:19:57 +0000
Message-Id: <20241202111957.2311683-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241202111957.2311683-1-john.g.garry@oracle.com>
References: <20241202111957.2311683-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:208:32b::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4728:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cbae3f6-a942-4076-21d6-08dd12c35169
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2gdY0KG9ulmUEzVCuZzNezornUFRvjP5YNQu/+H6jVMC6yss2mjYdTK6Fb/V?=
 =?us-ascii?Q?dJzlis92lREQ3bm9gwBnxjTBMUDD+MEl1fHdHae5LbZ95WZhf8WtZVAdoOSR?=
 =?us-ascii?Q?XsJ63gCcnMk13jC0wq3f0WZ8nOphOOJs2Lpz9R8GRIgNCXl5ogSjh9CSXYkh?=
 =?us-ascii?Q?408ovLRrYH8MCdX6nim9Bt0fBayzQeVreSFTT397WWLLvasD21Z/hV2zHfzj?=
 =?us-ascii?Q?+SXEHmJmWzKnao6UHKFGvR/22sRP7LaYYzy3hgjLNqOj9Hymtv2RUty7M3S4?=
 =?us-ascii?Q?Lo2+DjQg9rRyku6AgQJuu3g1cJeklceSQLAtUcodxyW8/Zbu8SysoIiohK3z?=
 =?us-ascii?Q?CcxSou12npXCH0P8zvRpRIzhpMWbpTNOSv6HsMrTiQrmmoQsfp8HVdOBwZb4?=
 =?us-ascii?Q?WNYsuGhUPCaOVknp5FyMyrXYAm/mj+rX9CGRGc8kYIEascuPwVB492M/ZDtp?=
 =?us-ascii?Q?sVQayAW0TKu0OWL4RvRVJt0txkc03cnsrPxxMQ/6PMw7/4ZsbJ0zEIQW4XKj?=
 =?us-ascii?Q?g1fe5JzyXtykiu9B7p5Oe4j+fXC/3mp45KQ4XG6EHsck6GUiDZUtPyLoKs1H?=
 =?us-ascii?Q?VV3HZYg+XQ3bgbjbIhmWWRYpQwawfbXl/LOo0+K5EgnpzvfUdi2G5JwAWVIZ?=
 =?us-ascii?Q?RazRrYoNjtSeq4ALMdSddeQNDw0IuO6Et9EA5TgHKEbrvPWwlBRyGUVPajL6?=
 =?us-ascii?Q?OqYBO32ckNd3zDdtf/JVZxdzXmbFAAR9KwqyFFokIq7wpnihT7ndsKJujSba?=
 =?us-ascii?Q?+faWsm6jqGf0pbEQmw3R4v787247Bj3Rfxo9ra+ff/gLCdHhy6jOd5TZuZIy?=
 =?us-ascii?Q?tnA+W1k1hubo7QL4BzatKkOIujXobHBlrk089bxp54wpbqeKgr/HDYQNPwAf?=
 =?us-ascii?Q?GLmKCq167M6tXQzUP7h+nhmxYofI4WJj+a5HFcmgq8A7FMJQdKkmIvM97DVP?=
 =?us-ascii?Q?eed9R39VluVeJl5ycNutMOT6Z1+B6v4KbTdznqNFAUo4nzJPNy101LwXak2r?=
 =?us-ascii?Q?BzZm7Cdi+wXOQ9HOzyYXBLMPk2aJ2Yx1ln6RQK7UC0FIsWY9KNWPtswNIjje?=
 =?us-ascii?Q?/0qOJaOaetsyp+Ubg9kG4hqDBo+2ggwe/qifCWU/e8H9xc62Ii5Ygs9QQDrF?=
 =?us-ascii?Q?PdCOZj7DnVX6F99o5j9lW4ejBjZ4Ho+WOhrBr5KKmug2A4gNFCr5Za9PyCUx?=
 =?us-ascii?Q?TljW9usgyMwtNg5VohNYNMyxJa+ZDb7REU/D4AiyPfxvCvPwSKIUt0zWfxE8?=
 =?us-ascii?Q?q7xCMONV3I30mvSGQVTn2YkQI/2C/FozoXRLx1umb4BEC5GYGiLiKykugJWk?=
 =?us-ascii?Q?QId+D2WS+La0YIw86n7aQKg7QtRqgXss2RFcdVOjavmMpw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e9E2654xrGWJX9FlKesAwz7Sj/RdZmQXFusq7wIiejzTJDPnmgU/gXccrDTr?=
 =?us-ascii?Q?DfvzSHu+qGnrR2Y95uep/6joUJQTTxhA7o8cQYHSYVl4ZcVsYCDKS4r5Qc9K?=
 =?us-ascii?Q?DBXM2mEsSS20X7NkLkHsGE1Of2mtkaDZUTbYEcVkpw3SJw5Ecn4K+Cpbn7m1?=
 =?us-ascii?Q?ybLEoSzPgRkmTDg6HrmqjCmi6xBrvMzVy6Y7dyEo+chVhUAKHWm1QuuTMQj2?=
 =?us-ascii?Q?2vJ84dPv2saYrKfjzYMC/YU2gJ+8FKYABqIiu/xxKwjfE/hntpYlgZte6zmY?=
 =?us-ascii?Q?o22mE1b/H8Zd5JOhrcILTTmJY909C8PinFgKQqXrAYejcR38QPh/NXRszovT?=
 =?us-ascii?Q?0ZBMxIPCAjexvhS16igYWqiPI//vh48DfwUU1k4cIM9SFr+TYjFGoRGpFIYG?=
 =?us-ascii?Q?ZNNB5/NNTTjiuyfHQn6SBlsTL5NBLHIyJM2afFOjHvOnDVerumoaFCTprZlU?=
 =?us-ascii?Q?sXnspOuy2QfAACRfKBnYCybsggE/yWKUoMZLFNeybOA4tOrCcgYZVl3XGqGD?=
 =?us-ascii?Q?p00c8DDPzv3eVwEeIWiFyOwb4vxdq5UdySIGRxql6hMojDho8haFBqpIuV/g?=
 =?us-ascii?Q?IOrHxrajAEBlZrmwIJ4NPZS059Htgltf0RlM6rSNf3bGEg174Kdw6q/7qKlP?=
 =?us-ascii?Q?rkQiUaiPpLLsQuCfF0WEb6D5wANlzwOw3fOZWvml6zzoqaem+ONsJnmeDid9?=
 =?us-ascii?Q?4CTl/aJ8u6J5+tzfK9WIbgsPu1GhxFk2tbj6PN7HWe4YUZwrxcc3B96ISTH5?=
 =?us-ascii?Q?PB6UnWfeufp5feKGDuyFsbNWTJrZ+epN/faInHULoaWBjVAaWbKnnDQSWxBM?=
 =?us-ascii?Q?vJ7FOkHFnZxqgnJfG8PVGGewpE6tH2beqTkho/YR2eyyZR5XK9nsonjaElVM?=
 =?us-ascii?Q?xEjXLenTBonc+pEs2WxYE4+djHW37ubjQMVRcSt5TMDE7//qUQ//N/JwmGQh?=
 =?us-ascii?Q?FvayztIniLV16almZClzfFrgsuYGGnZ9LRxrPVTCptz64Sabt4uRCwgxpTZs?=
 =?us-ascii?Q?6NMGFR4Qb5ECxjg5SqpkEOiu2C1JCExEatwnL3MCPk8bRWzfYVhvbod7Y+6J?=
 =?us-ascii?Q?bpUQ8n3o6aYgT2izPFdF6LUJ26fvCawyiNnfjnC/zAo1XEbh2DArMzk79q/u?=
 =?us-ascii?Q?F0m5Kw+BSJwo++NxaSCV8Qhb+NUX4Je6gpaaWFcxTlplGlqk9QX/oBc7CT/h?=
 =?us-ascii?Q?USjjvYVqyJWvByJaAV5ctorLh8+nV68cllhhUNpNsh2FJb2FSTrSlXHOewQC?=
 =?us-ascii?Q?bn7zgwBSgwuZDlr+6d14SzWraWqKwbuQp8KvTk/MP8PqIsTm4KkL3TBKccjh?=
 =?us-ascii?Q?gRcOTicgRXAeK9PJ4BBn7IQ/kgRpS6wq4vsZr7KjAXJCbpxj3kz7F0EH2/lW?=
 =?us-ascii?Q?SrF6PTmQTfFKPPX4m6Vl/8S/GLC8Fr2ScJdUfo9MumhLtwnast0aquurpUXg?=
 =?us-ascii?Q?NA9bi/yZw1Z/xN1TPnbPRC7iAcQEo54YCJJoDTfDgZM7yv56b3/OcJIzBh0t?=
 =?us-ascii?Q?b5jFKksXqtiCQdCGPTEjcuVU7TO6h9kOdsvIpJ/qNFdLUeGvKG4FFkHvls0t?=
 =?us-ascii?Q?wtpTzpr7fIsF/ISyVABnmd7XiI+nRGApKMw6ZkvH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MlGHA1kYmf95QEO0VJL9053mi+ZlCDRSw596a/qosQDGPDqR0FEck57PbprMAhEhU57XalVtBq5hAR6cAKEyJzGW3IIzin42BaGVioh9A0B7W5v2aG9dyQduUDXE9pn95HcsDdV8Ef5ARK1FUBxJwJx1vKl2v4PawB9KhyRjD5glKdcOe0pCZHHpqC6NBSL0wzn0o0kyII63H6FcWcQhsTwiRu+5538XVCXXqfuS2plB57I3cQ5/Y8MESEXC0TnxoxqxXonrZ9+8QPPjm4cRK+wMXwu3URr7CAx2sIAqlRyDDHS1CK6EVFaCwtVfuE4mgcwXMU5VmL2s0j5YM0We6Bc8133oyp2ylDnx7N/2XEDtSN+eI2HPzFtCMkN66xQ4OFcjOg5/QSt+aKGfs9IFFq+UIw71OfCmjjHzaCapbUYPp1pSBd+xG/MIPSsrJ5sVc0OL5Mo4MMXVgGVigeG4vHqDyUe64b3PBAJmzs9pd0/WWBC7l78vLaQYrL7dZCmNI1D8+aGJmwfsC9nKFGA2sIs5c/IzxftXcJCKZZJbimkUfiCJ1LxbOlbkClTEe8qZqKTrXIKCONQJmXDQ+7cdg6oN+sTNSKYF/gxN96N8Qto=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbae3f6-a942-4076-21d6-08dd12c35169
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 11:20:25.1434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SM3QkKaR05iq5AnCQxEkDhK3az6wA+mI0wgEVZPT4BjrsDFqnenRoB8XSmvh3dyIsgiL6nGhoBgvM3s+bDw9Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4728
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-02_06,2024-12-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412020100
X-Proofpoint-ORIG-GUID: Y-BwjOAroR6AoEWDwX3nQ3VzfkcwmUGk
X-Proofpoint-GUID: Y-BwjOAroR6AoEWDwX3nQ3VzfkcwmUGk

Since commit 43b62ce3ff0a ("block: move bio io prio to a new field"), macro
bio_set_prio() does nothing but set bio->bi_ioprio. All other places just
set bio->bi_ioprio directly, so replace bio_set_prio() remaining
callsites with setting bio->bi_ioprio directly and delete that macro.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/block/rnbd/rnbd-srv.c | 2 +-
 drivers/md/bcache/movinggc.c  | 2 +-
 drivers/md/bcache/writeback.c | 2 +-
 fs/bcachefs/move.c            | 6 +++---
 include/linux/bio.h           | 2 --
 5 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 08ce6d96d04c..2ee6e9bd4e28 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -167,7 +167,7 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
 	bio->bi_iter.bi_sector = le64_to_cpu(msg->sector);
 	prio = srv_sess->ver < RNBD_PROTO_VER_MAJOR ||
 	       usrlen < sizeof(*msg) ? 0 : le16_to_cpu(msg->prio);
-	bio_set_prio(bio, prio);
+	bio->bi_ioprio = prio;
 
 	submit_bio(bio);
 
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index ef6abf33f926..45ca134cbf02 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -82,7 +82,7 @@ static void moving_init(struct moving_io *io)
 	bio_init(bio, NULL, bio->bi_inline_vecs,
 		 DIV_ROUND_UP(KEY_SIZE(&io->w->key), PAGE_SECTORS), 0);
 	bio_get(bio);
-	bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
+	bio->bi_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0);
 
 	bio->bi_iter.bi_size	= KEY_SIZE(&io->w->key) << 9;
 	bio->bi_private		= &io->cl;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index c1d28e365910..453efbbdc8ee 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -334,7 +334,7 @@ static void dirty_init(struct keybuf_key *w)
 	bio_init(bio, NULL, bio->bi_inline_vecs,
 		 DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS), 0);
 	if (!io->dc->writeback_percent)
-		bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
+		bio->bi_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0);
 
 	bio->bi_iter.bi_size	= KEY_SIZE(&w->key) << 9;
 	bio->bi_private		= w;
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 0ef4a86850bb..67fb651f4af4 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -292,8 +292,8 @@ int bch2_move_extent(struct moving_context *ctxt,
 	io->write_sectors	= k.k->size;
 
 	bio_init(&io->write.op.wbio.bio, NULL, io->bi_inline_vecs, pages, 0);
-	bio_set_prio(&io->write.op.wbio.bio,
-		     IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
+	io->write.op.wbio.bio.bi_ioprio =
+		     IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0);
 
 	if (bch2_bio_alloc_pages(&io->write.op.wbio.bio, sectors << 9,
 				 GFP_KERNEL))
@@ -303,7 +303,7 @@ int bch2_move_extent(struct moving_context *ctxt,
 	io->rbio.opts		= io_opts;
 	bio_init(&io->rbio.bio, NULL, io->bi_inline_vecs, pages, 0);
 	io->rbio.bio.bi_vcnt = pages;
-	bio_set_prio(&io->rbio.bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
+	io->rbio.bio.bi_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0);
 	io->rbio.bio.bi_iter.bi_size = sectors << 9;
 
 	io->rbio.bio.bi_opf		= REQ_OP_READ;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 61e6db44d464..2e7bd5d66ef4 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -19,8 +19,6 @@ static inline unsigned int bio_max_segs(unsigned int nr_segs)
 	return min(nr_segs, BIO_MAX_VECS);
 }
 
-#define bio_set_prio(bio, prio)		((bio)->bi_ioprio = prio)
-
 #define bio_iter_iovec(bio, iter)				\
 	bvec_iter_bvec((bio)->bi_io_vec, (iter))
 
-- 
2.31.1


