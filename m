Return-Path: <linux-bcache+bounces-811-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 362C69E0103
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 12:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0018B3301F
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 11:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E502209681;
	Mon,  2 Dec 2024 11:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mVFvsv63";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QO2E8odC"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A926209660;
	Mon,  2 Dec 2024 11:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733138452; cv=fail; b=uuyqNTNhNaZT9p/1IKREOupsARVkq9Sh87Np1WBR24sLzpwbAwZWKwu3h/JPR5NqFtZjSwlW4MQMojpCjt9L9BgISFB7y189WpFUcZImbs2mAOvPtV45W/wPb8hx6AFQegvWjGiNOfUh4heMCmkgxzf91/1Qmlt+xH5QxVt0gn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733138452; c=relaxed/simple;
	bh=zNMkj1XPmtZ4zyH2oFNePG7SunD6afVFQITbqbUh7Fo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q1ouKYc3qeSsJCSPa1/mGXRtqM3WbRWRzIHUIooUjFUkq1xUZMHcr2mFqH4YGp9fvzTFyTeupYecKu1r+NggMGYMvMlDDrNbaphIPaziQ35zsdz9GHFARHb+KUWjypE8nrs2a8tM00CtuTDzFSHVXGjHdAdix+whVBHIzSg+o3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mVFvsv63; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QO2E8odC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B26Wx6G008613;
	Mon, 2 Dec 2024 11:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=gu5rp6izD+8+WzSVsE54VGcO9SoZjm2fsgBW0upSi7Q=; b=
	mVFvsv63hh9MpsgSqzjHtenCcUl0DQ4OClWAi1PEJUZqvqsin7iSykxtwL8nVpt9
	4isx1/pw9t6SVmp0Hkvr95ToRexJNhGjB62D6PUOZEm6N4neEPlVwqhlEts5o3qQ
	PrI9SYpGeijVmEHRcQeo3fEdwjaNfXgfrfRTotV/htxbtg8GLbZR0SjX/vL3dWAD
	fE6Q/kWmtfzqhUE5A1cawCfCqmS/b/6mUPlDmFd50+sWJEGENP6mgGjbJUvy6vyf
	ZE+hB6f25jEthSuQE0qxGAzvaCZUafcawVg4w/KEFGnGVURO2LN7x1ubB9q0ixF4
	T92nbJaLfcOlB0lhegMiUQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437s9ytm97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 11:20:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B296FjP031023;
	Mon, 2 Dec 2024 11:20:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437wjavbm3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 11:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccl6wHPmIhm8LUQqnOr4P1QVQ8r67kK593OmM10fYztH665zdUNkan72cl8iE84sn3KyHn/3tUasWiuty2r/mtfi5AF5XyyHNOjRRFzcESpXyUHffVVhlYuRmMOsvW+LoJxJZLYNY6e6+aVJKfAgUfirD4VPQHZLBvNuTjbAA9wiEOYKPzEUeKa9Sl3BbRciXLDKqbZXOefd6iwzEytRTSpcTKuZhEufsVdJawOwgyxzbPMuraUx7RRi5ZdAT4Z/VZvSPmrHhvRdcT3bi1RCO98YX9fHJK21MpBqZwB63q7SIRnLO4/pBfy8GacmeuQnjy0bxaIhDcUD0EjD7f7b7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gu5rp6izD+8+WzSVsE54VGcO9SoZjm2fsgBW0upSi7Q=;
 b=JQKCkboCYaAWo7Dimbwzm/pF3oYQ1dOVXGgBliGElACOpD/MZT74+T25BsawiDKpSW7zTU3vo3J+iH+kxlbdoz9icDg1LSBOslURgbp15VIUJlGY0U1yu/oY9IYANNwel0pLaVDNtwxDd+KeKIVESZd5+DQTNJv0ppiBIEc66hia25d/NiRqYQSXxrwTVhyuaMdzp9FgApH9ACyI5P2TTjaqg3SYYOniengL9+oFHwpQZQx8OIjus5z1MR+NIztpsbXmqhSpIaJk/dmJcRTOtMDu5AdWG34n6o8QPctdh8Dqm9GhkwSqmCMGWPyjZ/nBVHFQaGBBJL9/JEddUDC+1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gu5rp6izD+8+WzSVsE54VGcO9SoZjm2fsgBW0upSi7Q=;
 b=QO2E8odC5XN3j4GVSNrRKfb1qX8nZzspdacS0GbImCYk+03GV5MXKVLyDq1a9s7CQEVBu73r1j4dDLNvVnp1XenNDBaFnaXnhW8I1aDO1pi6eovAr0jNq5Tdr9NOKjiOhQ7EuepWlaRMN9zwm3Kwx0sisDogQiPYV6vc17JZZ14=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4728.namprd10.prod.outlook.com (2603:10b6:510:3b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Mon, 2 Dec
 2024 11:20:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 11:20:23 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk
Cc: haris.iqbal@ionos.com, jinpu.wang@ionos.com, colyli@suse.de,
        kent.overstreet@linux.dev, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, hch@lst.de,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/2] block: Delete bio_prio()
Date: Mon,  2 Dec 2024 11:19:56 +0000
Message-Id: <20241202111957.2311683-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241202111957.2311683-1-john.g.garry@oracle.com>
References: <20241202111957.2311683-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0597.namprd03.prod.outlook.com
 (2603:10b6:408:10d::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4728:EE_
X-MS-Office365-Filtering-Correlation-Id: e4699b53-f3c1-4afd-58e7-08dd12c3508e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fylHyb39j2xAVd1C7vrj9u/z/fdaMbJ1d9HYA56fDlTXnOxC72GtR8LZP08p?=
 =?us-ascii?Q?0cNr6+/lAXnj32Co6B7jjIRiesPkZve+svwgS6bG2pMip0rm+0LrCbcWudiF?=
 =?us-ascii?Q?GtAHGZwrASPdZvhl1USFGhw+0U+4KC0hKcl53FvfjTCqqUHRRPwKFIcztawo?=
 =?us-ascii?Q?mdA+s5fE+r7uL3fWyUjCKbqCWB5P7PyG9mlxbm93M5q7hHUfoRPA0PtP2sa1?=
 =?us-ascii?Q?Rd57Sc6+FiGdJ3M2EETta8lUW010W5p3vinbMpXJ+ZEsMKbx+ydvg8edLipa?=
 =?us-ascii?Q?gnWKfcMrCWet5Nf5ep7BaF6sZtRXnQowz1Ezd9gWMDBEctViULlQCH8iKX+O?=
 =?us-ascii?Q?b44ULqxKKZWP9YX8pQaUB2nUGffFkmzpC1xv/AyaNzU8FsmzQlCZBsl8YFxN?=
 =?us-ascii?Q?94BJ1QphB3OCmKfbvrvk4WFQKJro9+EoQ8iPURXO8ASsZ9LA5FcqrXU1z83n?=
 =?us-ascii?Q?ZQ+oIuhMxgpZCJ6nwkPew6+4sB0AMscADappSPFT5AzWqo1RtUT6s8LvsaaX?=
 =?us-ascii?Q?ySelTHGvTRbXqbVte4WwbtteWQnHqQiR7hq3afRoQfiBGE6DR8TUPVGTK7cY?=
 =?us-ascii?Q?WzpgB0gy8wx8DHKB0CDPoD/4L4fb8mpRWa4kXO3dBSCFyp5YrAtAei/crPTb?=
 =?us-ascii?Q?yv5AiDYgYPn8/ik206r0qNKtPkitc3C8izWAbXc8nVUOArbrdldNCxoy8Dro?=
 =?us-ascii?Q?/bXtr0qTDBNz1ziOYrMoIhWshetk1Ez02U50ggBOpqeuUivfaJUDy8h2Vf84?=
 =?us-ascii?Q?0hC4Vst/+pnkfgpT3rosuMY0SQym8AOAHk9jt/CoWZZdGSpVNhQ++DzdYlTk?=
 =?us-ascii?Q?UFnvOL52dnWGnqJqHd777vF28ij/kxMBkqY5tzVVFSZywif0Zch2dnTrE4n3?=
 =?us-ascii?Q?iDEU0gHXfMH1ajkl9uZs41i3MI6D1zQ19/zhSqoE22v53jc+WjvbKiTkW/Vs?=
 =?us-ascii?Q?rtvdCsPPOKAR0OKLynkwBBQgpEwDoO9XcFCZ3utGOZYhbRA2sD1+ayFl0vWD?=
 =?us-ascii?Q?Zx2pzJDsgIuGmTGVm3sefPS0IWED/1OSTg2aoHlh/ytsWjr+kC6GMyHQTZR8?=
 =?us-ascii?Q?q8af5Iq/OAvBGbCeOnmSqtOcxIHqd/8G6PuxHgoPUQEonnkqTfRvM9eFKEVO?=
 =?us-ascii?Q?5CX4mvwDoje3kzRq8iArjPkGBfG+2OZ+zxPAZiBKbqoJZey4DyBWo/AI7vvq?=
 =?us-ascii?Q?DasGWAWtFRn4WTOWCUIzOQajS7o0NJYCAnMkU9FjE480UJE3cZlsbixu36YE?=
 =?us-ascii?Q?xWVvHs9ZgEWAaXOQbQ3eszRtGDidDk9uhsjL3Hy0tJSiLeSgmU1aJ9HRpmsF?=
 =?us-ascii?Q?gJv3AwhWihLl6HIGjJJhGZwekgVLYCuR0mHPQfejaYftgg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fuq1P8nB6jLoX02s5IaUMeZamtc7hgTcUH0Y5BdCYSYricHKIG1St0rQhDRm?=
 =?us-ascii?Q?i+2ucOguTX0CbedJfrSc1VOqKJsqpbELtw+povbjDvfY3/jIdLwcdM8ShpyW?=
 =?us-ascii?Q?/Ny0CE6HPVN5mGuK8+6dMK3wC1DccBgrwLwxyoohRtNpHB8hw8u91eyOJUlC?=
 =?us-ascii?Q?feuBFT2FNCTVxpxStdENY+0parG1g3sDZLmhCFVJtQMz2qi8w7luaYjMleau?=
 =?us-ascii?Q?ePJsX/NAqEqmvY22AayN+aB4YOybGV51zwLXlxqsVVzuXmCAKseS0qvPZFgg?=
 =?us-ascii?Q?1MxFM/Qp/ZvqV9Sf44E58K7t2UQLPFVXCKau43ZgyUbPlI8X+JslfeXYT+g3?=
 =?us-ascii?Q?kK+cEUFA3CdhENy1U8KZvArFAoCZ3LZmjIJ3PGSALJhxkaS0J3HPigRDcycM?=
 =?us-ascii?Q?/K8wPvXs4psVr6vgvyOWZxXQSYZZ7FwzEA+KcrQTXP8P1674F7T9/gsgzE0J?=
 =?us-ascii?Q?ER4SrOQ5KhCQ2NUaSJQ+3Z9/k6+65egHVzgZI/GM6oWVvfq++JkxWS0TBK/o?=
 =?us-ascii?Q?274agNkImvU4iAKBHEu8TY1Egh3C3+BIe2iJ/8ZpcgCnIwWmBaQY+pj1icLM?=
 =?us-ascii?Q?2dI4e98pMDnhDCE0x7qmSnmIOF0uogWGVvSVMkO7cyHIqkqzMDqzoNZ5app+?=
 =?us-ascii?Q?UH9NmQY+2eXseIChGk6Pu7wzKfEkeXGdsIf0hdbE6tR+rcsKSxSvlk9+F9W/?=
 =?us-ascii?Q?BFJ+eLAbvVACChL4I/hnSdrcwWz9RAVbwlHR2VYJA1s8RURmvnkHEp8dyo7Y?=
 =?us-ascii?Q?I/RdEMP7KvFsYFjjRCqebzc76RBIosxCccapvhtiJm1GAIRW/Ld9pU9IrEyx?=
 =?us-ascii?Q?VDGGDb9LE9f+WE0FHDkD9302GtvB2zMXmLefMWZA8L86hvOz4VrN3gjVPIx4?=
 =?us-ascii?Q?z2XSlYCqpkCBrmJfbjhi2LRJshA/Pze/AWFbUZfNrnQA7cpZ1L4U5CpSlBhC?=
 =?us-ascii?Q?k4dm7PYhWIR7E/2PowYUBDC30ujVbugMpl+KcGRn3D//nNclYh0bAdTSqeiq?=
 =?us-ascii?Q?bBYqy+PzjDWVxxEZmDtZOIN7BlOIvOP5OAsh+WDntJ2H+6e3zZFRnWIaNLCU?=
 =?us-ascii?Q?wqsE0m3COAF/9t7XHmXjvHkIBL3HXBFD9z7+7MVzboWKoXHkunjCkH0gcgmq?=
 =?us-ascii?Q?xL7FE1cFkRhlEyvws22aX7L6c3yqRGXgDufhEgO8oFM17obbYN14OdSfI3Pb?=
 =?us-ascii?Q?gyLkcgF1MUrf4ZohOiQZrhVk//p4o0IE8KhU9Exk3tMe00PBX8NZ8g2r5jPW?=
 =?us-ascii?Q?ZdqZJrVChu8hXknBBsYSNQXa4J3I/dVjOfxOTW44WOO0QGMslZm2MyOOiR+V?=
 =?us-ascii?Q?29d3G1MsPQ+UzKt6+9yQJdnmICYHHlZ4xhjejyY1rCFvJ5Y7FrZg2BHieZyh?=
 =?us-ascii?Q?p2c+HL6CHVLLmQXpXS7yviKq33v6Rl6bRlWue0ukDhBn4ClZKnBLfzsRrz1B?=
 =?us-ascii?Q?8sdxwIX1aZ5qH8K38ag1sEIXr3WTll+6TPw9TA/7lMQ3K/4lZgun6UOCUMMp?=
 =?us-ascii?Q?N4tu33E4cZAbD2Pw/iW5XyMACkFvcN5evRf58KCBlLmS2JhMsdrOIQQ0r5Tc?=
 =?us-ascii?Q?7PUNPvPALq4PbV6pTtzzgEHNAnvLyn4HwqRG92QbzRDJKVOjrDxkALKJQzXW?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VHWIrYs8y/m2o2KZBStlmwJxXf+cYlbtIvN0JIy97WVTIIYpla0wE6tqGsk1WRcwyRd8mdCg22KfsxU4f+gMAR9nm1xBuwUlyMHtjQQkUKtGiI9P31leRl2hzEoRU0I7C2zFlMcm4U2nJSqYFlSm341cXtXUrYhc7QOLxYfF9oP5jD2kvNyl7iutaPIfbp29oYBdTtNffn0srjc1o++b6wvqBQUU9V7RRAKwU7XHdhNBHS81ofQ52By59DHq3wvupelW+TdRil8YK/kCxkb2rp0M9cx6CA68w//klRWHNIETLuY0mXwkisShAQgtxoon9qFpEIaFZ1FcSzk7uMCUooK6DxnJEtVpwghyFvybOChcSLxDeycLxusdCMJVlbVnXGyoFiHKQUQmR0SjduBH96+bZr2l35h1NJdfWO/tXftUnLzOicSz1ds/FdA7I5NhRCUBVAPcLtKBcoH5BKXwMw051myVPu/LqcXGaCHwXg350utbIlwOBtccni7ShcLigEBy4y5fKJSA0SB71e94Ws3ah1tQlNO/HbGzOKVVLMepk6OZjG/qEUUhnRdYgh293N8/kyAyfKh3W5YbdPJSXKvVThL/rq1Os0Ia5AzCli8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4699b53-f3c1-4afd-58e7-08dd12c3508e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 11:20:23.7285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQcxPgcivaHvGkbAMZl7vjcc89GQlWgd3RkPvilF/i3I2NSoGno0Xe+DUYHaBBWD3/hWfqGAez1M/Z44Wo/XCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4728
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-02_06,2024-12-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412020100
X-Proofpoint-GUID: dZ_zF2koOwlnvmUZao7wcpdtbZV8bkap
X-Proofpoint-ORIG-GUID: dZ_zF2koOwlnvmUZao7wcpdtbZV8bkap

Since commit 43b62ce3ff0a ("block: move bio io prio to a new field"), macro
bio_prio() does nothing but return the value in bio->bi_ioprio. Most other
places just read bio->bi_ioprio directly, so replace bi_ioprio() callsites
with reading bio->bi_ioprio directly and delete that macro.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-verity-fec.c    | 6 +++---
 drivers/md/dm-verity-target.c | 4 ++--
 include/linux/bio.h           | 1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 62b1a44b8dd2..b0ee199009fc 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -132,7 +132,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	u8 *par, *block;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
-	par = fec_read_parity(v, rsb, block_offset, &offset, &buf, bio_prio(bio));
+	par = fec_read_parity(v, rsb, block_offset, &offset, &buf, bio->bi_ioprio);
 	if (IS_ERR(par))
 		return PTR_ERR(par);
 
@@ -160,7 +160,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		if (offset >= v->fec->io_size) {
 			dm_bufio_release(buf);
 
-			par = fec_read_parity(v, rsb, block_offset, &offset, &buf, bio_prio(bio));
+			par = fec_read_parity(v, rsb, block_offset, &offset, &buf, bio->bi_ioprio);
 			if (IS_ERR(par))
 				return PTR_ERR(par);
 		}
@@ -250,7 +250,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			bufio = v->bufio;
 		}
 
-		bbuf = dm_bufio_read_with_ioprio(bufio, block, &buf, bio_prio(bio));
+		bbuf = dm_bufio_read_with_ioprio(bufio, block, &buf, bio->bi_ioprio);
 		if (IS_ERR(bbuf)) {
 			DMWARN_LIMIT("%s: FEC %llu: read failed (%llu): %ld",
 				     v->data_dev->name,
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 47d595f6a76e..e86c1431b108 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -321,7 +321,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		}
 	} else {
 		data = dm_bufio_read_with_ioprio(v->bufio, hash_block,
-						&buf, bio_prio(bio));
+						&buf, bio->bi_ioprio);
 	}
 
 	if (IS_ERR(data))
@@ -789,7 +789,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 
 	verity_fec_init_io(io);
 
-	verity_submit_prefetch(v, io, bio_prio(bio));
+	verity_submit_prefetch(v, io, bio->bi_ioprio);
 
 	submit_bio_noacct(bio);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 60830a6a5939..61e6db44d464 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -19,7 +19,6 @@ static inline unsigned int bio_max_segs(unsigned int nr_segs)
 	return min(nr_segs, BIO_MAX_VECS);
 }
 
-#define bio_prio(bio)			(bio)->bi_ioprio
 #define bio_set_prio(bio, prio)		((bio)->bi_ioprio = prio)
 
 #define bio_iter_iovec(bio, iter)				\
-- 
2.31.1


