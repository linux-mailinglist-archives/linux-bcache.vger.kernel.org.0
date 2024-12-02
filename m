Return-Path: <linux-bcache+bounces-810-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC189E008C
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 12:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF980284FA4
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 11:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B69C209679;
	Mon,  2 Dec 2024 11:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lYWUNLkW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I0Lf/Tfy"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A982209662;
	Mon,  2 Dec 2024 11:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733138452; cv=fail; b=H1V47zFG017CR1BO8j+yN0ObTza7E8CT783DtS4SSH7h6h5ZL0TBqP7Tx/7MJAazzcfgIeI1vNbPn/1DFfxH33Zaa4yWso+oKW0/xNHN1B8Ll+TdjzZ75IczFl6ko2O/qkCtCS5bTMjX0+6by/6bby6aM+YfSY+mdPnxNRpEsvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733138452; c=relaxed/simple;
	bh=7Hu8rrUqdIoTHSyRoRY+A2SYkeRlbEG5voQJ30RUAro=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=pIbTJ715BacomHyhAC6T8u2zCvRPq8l3pkKQfC87bt2XbNhOdwwL3hUsVbtX7gg7MPH7T6WXgSHgyRIWj9k4M8wH85xmgt/9ga4lvgelERAmo0b5hncMaTjHF9f7bHoCpYZXEXySvdrEQDq5UfmOmvEmKEBhdqJ9A2aLESpMAsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lYWUNLkW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I0Lf/Tfy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B26Wwrg016647;
	Mon, 2 Dec 2024 11:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=lrb1uDHfISBPKvD5
	sPkZEkWL/oK8z9b9fg8Xo8fKRcc=; b=lYWUNLkWarOqqpg05lOxKlIkwbTzLmzZ
	ob2UgwezEbmSfMMrayXjQOl2W2Iclz/DVEildC+s29C+hoFnDTlIlWzVv8WxUpwz
	jQbNSSRH4aUN/d/7SaXDR2ECGkSiy/h4kjPpwXgi70TSPM44lFwvnJsSw5iqCLUp
	LFlXsHdOAd+XdoBnHjPB3Go4HnMjX0Kg9I8S6vPL3Uor10AGl+jT8o9I4tTjLCFt
	mDyfUSepqh/9nw1O6khxPPg8pHwlUwn6g3OhKiIxInJZHz00tjfDDzJ1Jh6WbYt/
	ErPmkrohaP1Qzo1i18QC0kOus7F32UnOv72qpBNAomSaT09yy2nD7A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437u8t2kdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 11:20:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B296FjN031023;
	Mon, 2 Dec 2024 11:20:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437wjavbm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 11:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jQycASofcTtwVex/1CZLbKo+1RsDdMQg2NLXMeGGRHL1icn7TYPrG4ED4jM38tU0cUfgMrVKYjttzoiYbbFrEh3JR34Qip8rdbC6RC5xv24o2k6pQJFgvMnc07YtanjXL/PrEek6AHk4nNTIEv3/IzLA3gCymNSSLQAe4Nh8YISVHVYmmNleXFD2eyn+5lgx7cicNfZTQVPzqtnbDnqa3VJAiLje2od9Impqfw9dgBTOcArgHeRoOelqgRV2lyZ0JD1hlEmR5OWbHEQmTXyTrU794lKBO1dqmJDSlJe9nmbQzuPRhfVDdP6AuuuqdHEha7K4XUR3L7uAISuGD4Q9Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrb1uDHfISBPKvD5sPkZEkWL/oK8z9b9fg8Xo8fKRcc=;
 b=RM/4sIhl4I/3OCV1WGPf/PGGCjmyk2PBMEVfdIZr/ChVU2mjn1YaDPHnZghUCg+IvqeNKv1IX1t/UJuDgvJFeJiY0rIkHCPBcxGSciZSg9iLaNWDbGsy3F26u3+SKpLNIaAA4nkaR1rCCSfyYqMKHVXPyP+zYs0WR9R8roO3XGsgPIkfNTdBi9sTvg77m+QbEFZb79Qkxds0P0HtfQYeesBKvTX+d2aqQF08ayM5ydxuykWlaUrxvC0zxb8N0Z18rvmshFPfG/3zupv7RzcDiT/dS24TNJQ6E9LZObKD++MwJ4OVYfWMLj2JCA+u/nOfqtuExWQkUEXj/HLVnyhIzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrb1uDHfISBPKvD5sPkZEkWL/oK8z9b9fg8Xo8fKRcc=;
 b=I0Lf/Tfy4rFXN8SPtEZxV7N/LZt/3/2W6LYsuch+7yfanWy/kKCA04fdRLepl4d+ycGaQ+I4DPyCbu9hSZW0KShDySZkMBWXiYsqHmCRUSgyiKMKsyRHFx/ZDaYn/pEVyX9PCpSuwqUcvRegzFLnEevwjM6e5IAHzUMzDj/c3PE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4728.namprd10.prod.outlook.com (2603:10b6:510:3b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Mon, 2 Dec
 2024 11:20:22 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 11:20:22 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk
Cc: haris.iqbal@ionos.com, jinpu.wang@ionos.com, colyli@suse.de,
        kent.overstreet@linux.dev, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, hch@lst.de,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/2] block: Delete bio_set_prio() and bio_prio()
Date: Mon,  2 Dec 2024 11:19:55 +0000
Message-Id: <20241202111957.2311683-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0594.namprd03.prod.outlook.com
 (2603:10b6:408:10d::29) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4728:EE_
X-MS-Office365-Filtering-Correlation-Id: 5717a8ef-e08c-417a-1335-08dd12c34fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6yT8mwYt/cDPPcyLWATxbjUndIQtnKGh+y9WpavzCMRAHB2EBixPyv8Ag8e6?=
 =?us-ascii?Q?KWJq3Z5HWFvEcfv5fKdvmBFLN/V/ZIeVgWFVP2MXge4j/xd1AGMr5ERAaHuR?=
 =?us-ascii?Q?5ciFLieySCdwi8hm/q2im3jdrzLAhdel5aPISPopdqnSLHlsM5z089UM0aTk?=
 =?us-ascii?Q?DeSUI6SRCfW3njTjW1uVo32hiwiPUw4vg3zyZF6NuxOdbOIt1OnF52rxQYlu?=
 =?us-ascii?Q?2zt0S76CvXD/MAWnuzI20EbJ+t4XpcI4r+ho3H0TBEIu+73aV0rPecQ7FGJj?=
 =?us-ascii?Q?Un8i7PagZlLKIPqXFxbeHdNmOsCPjT+bdqd7YszrpqoNtzqMXzp/MEXK+TJB?=
 =?us-ascii?Q?TU3DRL4IEjcSbsQGuUVg8KlcjpMLdfpZFj2oibbqKdAWkTFsP8S0L9cBkxfB?=
 =?us-ascii?Q?idIS4UNNFvqo2GhSKRlDLsXWcUH+rKVn0reqaCyp2jPorDG103l1CC9T03N6?=
 =?us-ascii?Q?X1pRA4n0vFmv5AQ08vPV8hsa8L9jIJXtNLjb2NEbGtrkaeZ42Iy5iYqTIXGX?=
 =?us-ascii?Q?6WvBxRqfbMzVqV0bHsmyerpJXpVjGSd8OUn7dbTgkyvGPGNptTrOSBbawlHl?=
 =?us-ascii?Q?e0N0wp+b6e7t9ddz6UTny82lT60KdB12olSY7/VXWZwGe/JdMYsbdxK3/M0K?=
 =?us-ascii?Q?5y/xZf6dEUvtBPPN2fVqJ1yWhG5eRxO8/OGH+5FwI4hP6g5U2swEnPiZWhis?=
 =?us-ascii?Q?XdBdXxOLD8V6Y0XmBj6u76i6T/6p+hfFOHbeaAUsdALa2EAJreC1c1mwIsEi?=
 =?us-ascii?Q?qGwWmaHKNJbGGGZfb7Pcs3rBclwAZiMbIXrFUw/KOdVWU8T+OqpJRK0TV88f?=
 =?us-ascii?Q?QNene1zGJ2ZxyAJccLc7P/5oC1TbDLdD/GwYA79lfmrXGpXjRhkFudldhmy2?=
 =?us-ascii?Q?fYOavG1hsB9xlZfi/jOqAi2bqn3fBmDf6g5Etjxy5NynvlAw4zMNlRvNyxVO?=
 =?us-ascii?Q?3cUBNwZn5k5kH/3EBesbF74M8/zCSIaQP1LSFxuJpcEY/r83rdqLOydZZTvI?=
 =?us-ascii?Q?OIopmRx7FtTqvS4OcMM7ZVVDSeTH5Ix6cIEQHTruy/WMb6LD+u+QKsU9caWc?=
 =?us-ascii?Q?Hzbf5rvCJ4RkszgHCI8DeNIXgOBwDPcBbH6tOGfZM6+k0nCzShoRg47l5bvl?=
 =?us-ascii?Q?SeIRE5geWYKYkJjpTerY6oO/mas4i0B8XD0Ol33EZzkyDz+KvddiYq7jZZ/f?=
 =?us-ascii?Q?sbLCHVeKlIm2FjqU7eb2SonvOLLQv70NJ2XB2Dv35JrFajfgUUf30yb5zDX+?=
 =?us-ascii?Q?mofKwPETJfo+PyKph1B7mtRk+cI9nQJNfOoo1LdMt49HEUnqLl317uutOIij?=
 =?us-ascii?Q?pgrinlVKbLjTZDcDVZXCvSbfMBn7pHcUwNtneR26vdsgQA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qo1pRg2x+kP+8sKM94yVhc1pwy9uNHOu436yaUG/SCKeEv5UrfovVvLPAB3p?=
 =?us-ascii?Q?CMYJIGaxVRhFOLgp/4uKXEU2m02UUlMd/dyPjCJMM7qjCxK8Igtlr1+uIn8H?=
 =?us-ascii?Q?VyQiSTS47gFpIvZKtJDHCFJ/vQcD782VOKMmR0buKEeYIrSvi6ZPbz7W7+kI?=
 =?us-ascii?Q?XPcCb0trOU+x0jY1OShCBDBsl1LP6j5GjRr1X6eHNKlMlMtzX2zQG++sEgRM?=
 =?us-ascii?Q?e8mEf++FZZQgKDtOWNPC2qpJnbnxU5Ih9Ob9b1J6FtHDdU1lxvJLyQPp/GNS?=
 =?us-ascii?Q?v3O5oZBy12DEmXpg2ZkDzn5VkGYZPGNqnBbQjFmHTiFuka4zWSut0Fsa/m6a?=
 =?us-ascii?Q?u5BYxXV9OHka75d1rpdFh5XP2aMQEaE9YoRhaWteWBashTxh+0Yo9qYshElP?=
 =?us-ascii?Q?oeDpi8VtHzRW5wAa9SeOIiTaVxQQhWzNCGhbDkGpWfOtUTR9EF8oB53YFihZ?=
 =?us-ascii?Q?056j3wWvVQo87qbNSa7Pjg00qp3YHSEynXfkgHiYKfdqcxeh12uH9e5NBydg?=
 =?us-ascii?Q?FoBoxO7GTkoNyUH+WSUNE2n0x20PmV4jcgE68jlY53+IFi280G/OCO4/DocU?=
 =?us-ascii?Q?uWr3Qx4ZlAG4QGWalYDbjOfanaoq3ZeWgADgT6ajruMo6kKvXfo6N98CuYx3?=
 =?us-ascii?Q?FiW4XrQgXQ+C9+vDaqBXq8h1aFuBHg3xyW/cdiQxmtoPRkwPQ1P8OEFQV/wX?=
 =?us-ascii?Q?jg7pkQnqV0nrPI+zilX293hM/siyp1M+NMsRg21/uqaOHUfNk9+8xtOVy3eb?=
 =?us-ascii?Q?sDfdFpSTY1mMhgfbswKEgaXSObHLkcdQYJLKt89EwHuH2Tic83cq2WmA4ptt?=
 =?us-ascii?Q?tSwTt17jHZMtKD5DV4SamUQStZ2T4p3oNTxKdyR/rvMTR3WvNNi74405TEDQ?=
 =?us-ascii?Q?0ezuRH9PdxM0FIXCnrSPM44BdMcDF+RAQHAWGVf782xhUm6Wfz6OgOxLrn9T?=
 =?us-ascii?Q?u7MU7z2UsGvZbaIhsGKy8vKF4p1b4CYhvPr+2mmFQWL8L2qkDDn4jEe/8sNK?=
 =?us-ascii?Q?puPoD9j6xaKx7fac5/OPhBAuEW7fD+jdBESVbHsPMfUxM15KUNjSR1r+TGVx?=
 =?us-ascii?Q?LHvuq59HwvYxgaTT7nLU1zbe28nqt89raMwB8p3pK4IznKV7qRhSZQQDLWZw?=
 =?us-ascii?Q?iQ+TB6GNaJ7usZkDr5juxsQ7I+DEkfRDJEtu393eZG0mMEdCfThOHpsG3UVh?=
 =?us-ascii?Q?73EVfZoxcOdWCAoqMi1rbdiA0byZzqIVXl0QLsd5uTUlrcyo8xh4wy7+EnRl?=
 =?us-ascii?Q?dJmw8ni8LiC9kVd2YDNl1ue/AdQypPJFWIak7F1f9FQIVuq80knBwd/joTNs?=
 =?us-ascii?Q?bepH27RL+/ufkUUXKz4TqwHP8QKtvfkP6hreNuu913vRWcACIt0XLBax0zLO?=
 =?us-ascii?Q?ub7QUTGdwQNy9YgpuzN8QROL8RVw6RrvNnB3MAi+2WKG5WNZWdXiWA4LkHL6?=
 =?us-ascii?Q?muLE0ghiKpaCMJKP9KHf6L24ZNabRYRdTL3bOfhRFCGEk8dweHQKHtSMvr7b?=
 =?us-ascii?Q?UxC0Dd3X86lKwcP7dk3Kmqi9E05+hS7Pb3Wn0uSVIWFSA9Nc8onBcgw3Eu5L?=
 =?us-ascii?Q?3Uem+MQwc98PZymyJ00IA7mfrRcFUtJ1/S6LTq4yBonqHR+z4vvS7whPY3hL?=
 =?us-ascii?Q?QA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c8hFRUbo07H/v4vmhsa8VX7cOFMIFl3Ab0aO/MmAFGwEp3QjrCm/qddocYuGTKM9WKUKvnigWd3FvrSvrklNnzvMEMe+DAfIYLaHXqwbvVpSWstjnk46FXekJnvB1H/sezcjDeA9EpC1X+7RrYOPOlaDl71YyeENWWQ7z1k8mdcaAdG3e5jbUlWzeatTjbKK4xHNyGe1BqvMvzN9wNzIwfHK53OYI/4gn7yQSXhn+vw0h1AIveNh0xHLUf7m8wyHWfdwdWsDne/ti5gML6BY6oWeibbkcUP4GXaW4jRZ4n4T96VrkL2oGk4dC2+T9r1GZS0u7E6wUK+rI0y27JD0cgIMCEAqitT+VQmtcYDJHf9XqOGUV5BtJjEKULHdl4A79m/cczLNLMo9UtB3lMpDNflDlGkyQLi2iZlbFKqWK3qvnJb8Fe0HiDwTYMyaaiEKKqo+0UKbbhx9OX/XZI/JsH+SRai0jMVmr9wLmAIERDzbI/gyLUR2BfzMQW67e8qZnbcXtrICjIyswSLoP36pnbtVOx1mgp+Ktl98Zcz3kN4V0vQa0ZZcO7hS1TUeZxStIl3UtAwqq5a7qx9NXDFWyMl7dEsIIIgCcqFRW+Pd5tQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5717a8ef-e08c-417a-1335-08dd12c34fdd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 11:20:22.5376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qL2sHdvT8Ae3Jm2/r13Q9ZtfKxbaXObPzKK+o2XBYkh07wSSrKFBBX2+V1TTSJRdTY8F3TfL9BX3CYtOm0n8Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4728
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-02_06,2024-12-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412020100
X-Proofpoint-ORIG-GUID: If-LKp_2sBsgioZc68Mztsr_7b3aRdMp
X-Proofpoint-GUID: If-LKp_2sBsgioZc68Mztsr_7b3aRdMp

Macros bio_set_prio() and bio_prio() do nothing special in terms of
setting and getting the bio io prio member, so just delete them.

Prior to commit 43b62ce3ff0a, they would actually encode and decode the
prio in the now-deleted bi_rw member.

John Garry (2):
  block: Delete bio_prio()
  block: Delete bio_set_prio()

 drivers/block/rnbd/rnbd-srv.c | 2 +-
 drivers/md/bcache/movinggc.c  | 2 +-
 drivers/md/bcache/writeback.c | 2 +-
 drivers/md/dm-verity-fec.c    | 6 +++---
 drivers/md/dm-verity-target.c | 4 ++--
 fs/bcachefs/move.c            | 6 +++---
 include/linux/bio.h           | 3 ---
 7 files changed, 11 insertions(+), 14 deletions(-)

-- 
2.31.1


