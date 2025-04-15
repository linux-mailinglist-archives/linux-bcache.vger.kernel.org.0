Return-Path: <linux-bcache+bounces-883-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D17AA8A63C
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 20:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77D917A2F26
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 17:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB8D21B1B9;
	Tue, 15 Apr 2025 18:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cVjcVDKl"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B625E2DFA3A;
	Tue, 15 Apr 2025 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744740051; cv=fail; b=YrucmZUAOYZESn1ufUnZFOKJ3gbV1nqQBr3J9lqBNsf1usbEQp0pQbmH5MOMHCvubpk3iWhHl27vUiOPlmj4LW7hiqE4S/p7fmMNbQ80A6AgaxmT8p1L+QoyK5+kxI/Fs+HU5xTSdveGzBEwj9k6v7u684jxMVF/3sYEnvPDfQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744740051; c=relaxed/simple;
	bh=YHYpX69AnQ1uJw4EGyR04QQOWubJnZkJ9aJuCU4Xl88=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uUPAOSg4wgsMqPjIf+I1ZKujY9Wwy5d9D5wX7Hj7e41s1KLFlbEjjGFRZV7vSjB5xHugjSJJxHw33QH6BinndHS380r50w0VLwO51qsY663TpUmsRigfKZX5NrCUAhOIVX36q8G2yUkUjEpZg1YVDtLDEdHQX7+IGUXqEmxapPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cVjcVDKl; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744740050; x=1776276050;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YHYpX69AnQ1uJw4EGyR04QQOWubJnZkJ9aJuCU4Xl88=;
  b=cVjcVDKlkCbJiw5ThEbskODzxc8WW23wUAbrWORIYcYS/1l6i0QGmpnq
   9ry+QvsBSH8k4Ey12q1yMcd5C3iCoKsdKuDDEIP98ka95bkgwIzieLUVd
   mSNZ6WdiLxkXwEYdpr0fm+MqGf175G+1+9qTS8S0o4eATxgA+o9NhVr6Y
   hJdqsnAJY8pdonM7M136B8xKSZeYaS+Rj+T1jxRDsO5APsV9zMcw1Gq0o
   dRtwL4rj+Ke+e6Yf7rBkO2JFe4PRjIynZ4sK4vS6CoABIlObwfwNtTIxP
   wu0Dt9nwU6Hjkn6Z3eRJoni+EtVor/bj4zmqtpQGIA6Co/GUoBnJ8iQGD
   Q==;
X-CSE-ConnectionGUID: +qdqTsseQ1u7bC+7IgnP3Q==
X-CSE-MsgGUID: iHUVXJXkShitsCETDAlpLQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="33882353"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="33882353"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 11:00:49 -0700
X-CSE-ConnectionGUID: QFSjw9TPRNeVMf7c80u0dA==
X-CSE-MsgGUID: GdzupyrSQmO+RgjZWIyJSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="135360709"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 11:00:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 15 Apr 2025 11:00:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 15 Apr 2025 11:00:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 15 Apr 2025 11:00:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ngtuwlern7xwdrtpV3qEbypLR5JTJDBeVXuzaXDk82N2rVsFgzixhQQ4p7ovYtS71SDDbxDKGjBVdBnzPTZ1nEZ4+A4MyZBLe5aN1EAekpz9GjZTTyMAvw/hJl4nmqwj6Odm5w7I1hwWwe4mHLp+wmHL3odmoWHIuL3D7NUv87GQr2ZYi9d5U96GjCyrOxNvI+/HBU14DXt7ksE9BmmQWVkGYWwxdqK2W4V3SLQGSgP3TrjQY8YUue1ZmgpKYhtaJsMefD7yEcLYU6oswDW97rlGJxC1OpFWLreoncsDkexfedTK74SSDAnU5QWCc3WYax91OeV2UMNiSAvmmvU/gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJN5tHeRsuT0aoCx0SJqmcsYkxaDqUk90ZzW6xkIEw4=;
 b=BhAURx5N8GPPe6qb9nVSSFAF8vNZNqHdbRvjY88NzUPnW/f4kaQvMphuMfs8xaT7a5VhiI2dFmn+xeSuHSw7aCLNp/8axu80cp5HW5UDAE7vVMJL1N2I03XR/V8BT8PBK+KvpZPlQ8AES46TxEeJaAQk2OVSW+hw9PDufNxwA/3ajIHGdvzASPXDdg33K9D7wpMSL2kdpULKZ4/hwz0vSEyceKXQSuB47ghroBrPjfga669M9ddJ3jyvIn7B+ibznxAOijnU7LCAQ90xWjIoMSCZPPXuZv9jcs2XCVLhADdSptQt+Tu7+80qfAEEJQEivx/f3RKGk1oo6DegHa1xUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB8433.namprd11.prod.outlook.com (2603:10b6:610:168::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Tue, 15 Apr
 2025 18:00:05 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 18:00:05 +0000
Date: Tue, 15 Apr 2025 11:00:02 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>, <axboe@kernel.dk>,
	<hch@lst.de>, <dan.j.williams@intel.com>, <gregory.price@memverge.com>,
	<John@groves.net>, <Jonathan.Cameron@huawei.com>, <bbhushan2@marvell.com>,
	<chaitanyak@nvidia.com>, <rdunlap@infradead.org>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux-bcache@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: Re: [RFC PATCH 00/11] pcache: Persistent Memory Cache for Block
 Devices
Message-ID: <67fe9ea2850bc_71fe294d8@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250414014505.20477-1-dongsheng.yang@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250414014505.20477-1-dongsheng.yang@linux.dev>
X-ClientProxiedBy: MW4PR04CA0369.namprd04.prod.outlook.com
 (2603:10b6:303:81::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB8433:EE_
X-MS-Office365-Filtering-Correlation-Id: da3f5fa5-bcb9-4ad9-3716-08dd7c475a41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Xa3pqnz2gRiQC9lPraFGd9m6OJTM7k5lMJVTZCG4W/POVwMc96xY9yWyYOl6?=
 =?us-ascii?Q?ZB2SskDH5iAW7FUINziXW6T4C39SwKNMnea9tTe8rNkFVO7R7oYlQ3/rWi84?=
 =?us-ascii?Q?dx7Oa9imdFiCZtrwBHBUs8oGzJFUfIeSxlyh7yrEseDdsQDovpfPpepVuNOA?=
 =?us-ascii?Q?aDx74RRe/HRvFb06wcxHYosGBKwEwTpsd/PG57WgNp0Sx3PFiBvR1UNrOT8S?=
 =?us-ascii?Q?DAlHb/IYGn/L/bYNEN4j54IdaIgUWKba4ztnKfU/X+rn1cdJBdPa+mLDrWgk?=
 =?us-ascii?Q?TERbWrxebmqFKM6FTWHsoYpbaKG1cWVMSFV50j7QUsrIAqx48mO07ZC4NmXb?=
 =?us-ascii?Q?p35VAQDKyNne+I58JlIy8ec+S/N7fs+MaBob1j3VT6o72zZ/Vud0fBchrm+d?=
 =?us-ascii?Q?py/R9zgaJ3zvy9hZ3IPXiN9H8RYDH01BmfUuW3Dg4u32Hqlr20yjOJv1JlR/?=
 =?us-ascii?Q?dnjYCNklctcyCPxE0kbC37BzrQ73qe8z9Wpi1zcmZX92+Ayww20BVcErVoTZ?=
 =?us-ascii?Q?RlORPQSaDM3o27c0xWM1V3bOTnebyuiNRuuwjUK0VMFFN+ioW71WHqa1JaVc?=
 =?us-ascii?Q?7t445Fm84mh46Kt77ZCS/c+jNtxSwnVqWoIJ5nXeUKRGx81WUFxB3z/NO6r0?=
 =?us-ascii?Q?b3AlNydfhlUpwDSA4Y6ps4Xg8ghuJnvxLgIlLmkASAx0xu605619WMBj+J1m?=
 =?us-ascii?Q?s8Av2mmHR1VfYCs9cFw4T/WX/M1b6LyCL6dN6/bDGE7e/9BfMptjktoZUy0l?=
 =?us-ascii?Q?lx+uQKaRyZSJM+XX+B0iByKyrIMm7rnKrrUjYF9boUUaRPx3HUxH9vRqpq2J?=
 =?us-ascii?Q?3UXsNsp2+plXhZHfPy3rMEOPVbJsN2MBPVUGBISzmN9kPM97XHCsIgEqE3Lt?=
 =?us-ascii?Q?jcaaPCvuV79nvbsHoYhJIgzg6W428OQXEZE1H06uGBdbP8k/cfazeoEElD4D?=
 =?us-ascii?Q?6ubkZQUwJBiT9jwkTZHPG0IaCKstGhZxTjy+h2xNw1pgLMlYWd/j2A43zBKy?=
 =?us-ascii?Q?5xPER0lbsuhEdup8K9whqtlUauBx2zIlPnQz7PH1uh2hqte0rgOf3WJlL5z6?=
 =?us-ascii?Q?UREF7S0cXDOCRpB+k7xKnXC2YABIGWnl3IqlcTsMpU2W9GO+xeXQJjmVVWbf?=
 =?us-ascii?Q?PHqM19z6+AynjtZjaS/er3TkTgqvVK/rSAhPF7JQ/3Eqr1iSQRSNi+KYENPM?=
 =?us-ascii?Q?VLTmnnu5L3ZazSmUV44Jbquze0kobWRCRcCwx/sNXhs5Fxkuodh8mnZkssC0?=
 =?us-ascii?Q?uJejXSoE4EI/xh5dTU7pYDf7SGr7Ui0PHWRfOF6YP6JKMaRB/RAA1ga71S4a?=
 =?us-ascii?Q?Puuhg4nVdtmNOUA35PWz4TPKo29fqyhRGC/ykERekwzyajHTJKTZe81604XC?=
 =?us-ascii?Q?+ASlGf6G4XnujBwxNnCL8oDC9w7ZsBJ9ZhUMbgAYmtbnSNqJ9L/RwBwCmg06?=
 =?us-ascii?Q?wtQNofsHrTo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8BC217VKN7tTJt6LAdWebQlfDpTZ8gL2fu+j1+frvK0LfQmpfjOvF5eeShkY?=
 =?us-ascii?Q?3d4Qta7N7GGdZhI6Yuv960JmypY0qRi3pFsBuG70ConTWbIydzF2ilEJ/Ddc?=
 =?us-ascii?Q?299/LB8PSffyTWecZTlpZziYiOe4KifVMotiAomm00q65ikYFbSIeN2adAFT?=
 =?us-ascii?Q?RhMQbmV21XkNDGF/P4iK1+y6lx8moHmMHkwAUDb7Ia/wiv9r+SgJgd2XOvMr?=
 =?us-ascii?Q?StxqaH0Gh+KMuIE6QHBLW5NF/CWf2gpmMnR3zuoFDRUKjark28heue9FoRa4?=
 =?us-ascii?Q?oFlZZnCcIXENtw2shVPlfRwhDPgR2uuBzKaUBBqQKw1ofVhynFSoNmTgoMLG?=
 =?us-ascii?Q?Ne4EyjX/AX/GM9tYMfPh2eTw6EaT3f+fUKE6KQ45oRDVTBwAvZz1RTVsScSG?=
 =?us-ascii?Q?XipWbeXb56xVBDNolmNgOf2hNMea6Z5XE5mOSKUc6sZFZUzgu5+fi9rYTpoZ?=
 =?us-ascii?Q?m6X7WOlRQAf746BsKqYan7MBv12cjb3HlIux2LMi5ruE5DUCnlDA/cvWj/ET?=
 =?us-ascii?Q?lcHJWIg0Y4lv2cFj2yUGE+vnnfFa0esAawcNaQVPe4H/vqdMBUNSmp14O16L?=
 =?us-ascii?Q?G7bNuBmlYbQDWUdSkzEr1174FxhEMybuA58yxXRqrfQnrUcyYiM2m7m/Gu6H?=
 =?us-ascii?Q?gGjNC43UzP/GrrCDj4/I4eJI0XLqlTUNFoqEb8EhgMABBseEXDckHm/fW8Wc?=
 =?us-ascii?Q?2Scxp6lfzPzeXF4KnfOhTSpDVUicApGW5VKEjhE6guvu2s8AlQP25jh48KHg?=
 =?us-ascii?Q?xGcTbI3NRJ0TyM5IXkQUxPWoVhgcbkyThJ8O7vGquTvy/l2x6ZVbZfiUbFyy?=
 =?us-ascii?Q?+0mkI6qmXNYaadGhazwhWR58RIuFhtY/riJZDlT3ZdlITmjE9Mof1d5HLcLr?=
 =?us-ascii?Q?lj5yhyugHtXkKU1OsyT3zOZSq7dLZqlTifSUzd53un57vr1X+JKUdWo7f71B?=
 =?us-ascii?Q?/yK2/f8oGij8+2opUIHJnjD6L4YcI2laQGPpBfklLflNfMR3qFxcutKDsa3Q?=
 =?us-ascii?Q?VO/dCJpn7EgVZeUwMElRROyJRf6cOTtdIXbFxJZ8VQz8yZD5Q7VkQUgqfq5Q?=
 =?us-ascii?Q?jHeH4waV9n2SunA2ysvlotc8vS1mRpAGu2wU3+lplCJUTQFUDxqfhF9pGym6?=
 =?us-ascii?Q?mEr5au4YBzP+8k+HmjrWcgQ/M+fD0na8j4C6xlIb1GKkBQIJT0U2LtR+ld6f?=
 =?us-ascii?Q?Huf3sYvdflB2ylsiInaIUi2jrKJI/hjUT2EUDF6NztmVak7ZpZkdmKks5jpR?=
 =?us-ascii?Q?bqEsIu8Wg6VG0m/0d8uemnNOGXOlJYyl9yctnxRDleHZ2fB9pUD0BhogYG9X?=
 =?us-ascii?Q?vMbofFimsc36OQiXj7qfCp3ESm2fClWHrqpzF4K7fLt5Vk/7kp8nEqAZjFsy?=
 =?us-ascii?Q?S3zfFxSg+xLxyOpf5njp+TQcjwr0ZAFPjGfel871orUKT7PUEMMCJJvC7MwH?=
 =?us-ascii?Q?/A71CbaWk3eyPxoR4t0sIfiNHUfTLLFdFmfzIQXfOK3Ggj3JbXxDIyNYsR0z?=
 =?us-ascii?Q?hRqQB66c8Xh9eOI0B2OJqbsubQKHPOE/WPRpvjKPIfNfmZP7YM7+z2Bqoe0z?=
 =?us-ascii?Q?PFXf5CsWceUHN4QAoNxcDlCfhho8CkO+WYoMq+VUpL4eUq+iNQQ4X7Q/n1yW?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da3f5fa5-bcb9-4ad9-3716-08dd7c475a41
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 18:00:05.6454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wCBGYR4hfrdabTFKqJNt18p0opkLSFh+deBAI4xSJzm+78pP3hzrEZgO+WN2AL6wAfiWWxSU/auoLf1H46EeNfc1ROqmpwU4QV0xE1xslbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8433
X-OriginatorOrg: intel.com

Dongsheng Yang wrote:
> Hi All,
> 
>     This patchset introduces a new Linux block layer module called
> **pcache**, which uses persistent memory (pmem) as a cache for block
> devices.
> 
> Originally, this functionality was implemented as `cbd_cache` within the
> CBD (CXL Block Device). However, after thorough consideration,
> it became clear that the cache design was not limited to CBD's pmem
> device or infrastructure. Instead, it is broadly applicable to **any**
> persistent memory device that supports DAX. Therefore, I have split
> pcache out of cbd and refactored it into a standalone module.
> 
> Although Intel's Optane product line has been discontinued, the Storage
> Class Memory (SCM) field continues to evolve. For instance, Numemory
> recently launched their Optane successor product, the NM101 SCM:
> https://www.techpowerup.com/332914/numemory-releases-optane-successor-nm101-storage-class-memory
> 
> ### About pcache
> 
> +-------------------------------+------------------------------+------------------------------+------------------------------+
> | Feature                       | pcache                       | bcache                       | dm-writecache                |
> +-------------------------------+------------------------------+------------------------------+------------------------------+
> | pmem access method            | DAX                          | bio                          | DAX                          |
> +-------------------------------+------------------------------+------------------------------+------------------------------+
> | Write Latency (4K randwrite)  | ~7us                         | ~20us                        | ~7us                         |
> +-------------------------------+------------------------------+------------------------------+------------------------------+
> | Concurrency                   | Multi-tree per backend,      | Shared global index tree,    | single indexing tree and     |
> |                               | fully utilizing pmem         |                              | global wc_lock               |
> +-------------------------------+------------------------------+------------------------------+------------------------------+
> | IOPS (4K randwrite 32 numjobs)| 2107K                        | 352K                         | 283K                         |
> +-------------------------------+------------------------------+------------------------------+------------------------------+
> | Read Cache Support            | YES                          | YES                          | NO                           |
> +-------------------------------+------------------------------+------------------------------+------------------------------+
> | Deployment Flexibility        | No reformat needed           | Requires formatting backend  | Depends on dm framework,     |
> |                               |                              | devices                      | less intuitive to deploy     |
> +-------------------------------+------------------------------+------------------------------+------------------------------+
> | Writeback Model               | log-structure; preserves     | no guarantee between         | no guarantee writeback       |
> |                               | backing crash-consistency;   | flush order and app IO order;| ordering                     |
> |                               | important for checkpoint     | may lose ordering in backing |                              |
> +-------------------------------+------------------------------+------------------------------+------------------------------+
> | Data Integrity                | CRC on both metadata and     | CRC on metadata only         | No CRC                       |
> |                               | data (data crc is optional)  |                              |                              |
> +-------------------------------+------------------------------+------------------------------+------------------------------+

Thanks for making the comparison chart. The immediate question this
raises is why not add "multi-tree per backend", "log structured
writeback", "readcache", and "CRC" support to dm-writecache?
device-mapper is everywhere, has a long track record, and enhancing it
immediately engages a community of folks in this space.

Then reviewers can spend the time purely on the enhancements and not
reviewing a new block device-management stacking ABI.

