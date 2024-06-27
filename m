Return-Path: <linux-bcache+bounces-695-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E8D919D44
	for <lists+linux-bcache@lfdr.de>; Thu, 27 Jun 2024 04:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 931AF1C22DA0
	for <lists+linux-bcache@lfdr.de>; Thu, 27 Jun 2024 02:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B80ADF5B;
	Thu, 27 Jun 2024 02:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D/mrSIZA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CE1C8E9;
	Thu, 27 Jun 2024 02:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719455763; cv=fail; b=eeiuwjllGZXJDzggpQ8CcOJQrLt9ZSNSEIrI2gKRICurPQZdc6ihXfbOvR/pR25M4VyovikCi70b24k8i2NI/SrAjfpaoeMLegoXy2vaW0aQ4NG4BmP/371jfYzlhLcj5SHPmEKBaDN9VTSIDbZEOtUkRcjW7bn1xslYDWmCdtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719455763; c=relaxed/simple;
	bh=Tm5fXzj/0p2EHgLOiFB38ADrMsp4/BzPcBMAMvA3Zcg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kPqrfIBdBXePUqw22F8f/Z7Fohl10M/Nl0tBAp6sJEYpPp3okyDDnEW4BjielNhNJXGvfNTEEiZmHvJqRqo8E6Zbdls+ZwQwzFyvs19nCHkYNL1CIYFkdeFWK8VJM3ST5rjRd69OMte1af80DmIGDhckr9Ag1rwlygQP6HD3dPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D/mrSIZA; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719455761; x=1750991761;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Tm5fXzj/0p2EHgLOiFB38ADrMsp4/BzPcBMAMvA3Zcg=;
  b=D/mrSIZAvHFmMnNzDoMjrwmxd4anuegabMuj/w38jTcTWP+cW6IuUWwm
   hKlCBLFq6EwYVCd3gR5uV3jNjQ4Ikf8i5CLjNbpno/zLTu2z4wBroAozo
   IyKPawnnES1spoO9keAvEBiYVOCoHklBuy5Bc3dDK92HFj8aGrxI4r9o0
   lnF7TsSjHvx/4094dPEs/tf16BO+6mixpF+eeuj5Ru1v4L4XV1VMie73b
   aGymWR3soXm24NHWVSMeQ+pgdJkAiXIVNbgk/gyEq4IqjhrBfzQPQntHI
   sfKDRCMCpRVG/MXwAAXiDawp1P/t8PY63UOCIj5jeGW9YhXox9OxXRo2g
   A==;
X-CSE-ConnectionGUID: krlBGgWmQiis0Pvuh4Nrww==
X-CSE-MsgGUID: tQBOeOsUSXmDixBYDNNn8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="27150857"
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="27150857"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 19:35:59 -0700
X-CSE-ConnectionGUID: j10ZU3/DQnqD1weyP265+g==
X-CSE-MsgGUID: iUcHYBtvRKG8/JVyWBtSnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="44643323"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jun 2024 19:36:00 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 19:35:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 26 Jun 2024 19:35:58 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 26 Jun 2024 19:35:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekMKBmk67ur17JmKVOIbQXZ1fARbRMGad4UXkuRY2r5YWVhRlmYLRuAa+tk1/jQevXtZHlBL8lUxrEMhSQJsAURlKSzRRiRw0jEbfll1whAAun0sBah1iYobacA6l5JVeYheJXjv+ThwF0/cdVlkV6FbZRrf1v9yFFidoWgXOJ0ZDKV9PTlyKmuQvshTXGPE3dTjc0ErAMv8vh95mcvW7Fhst5mLVb6+KVI5wsNpPZWsFw/F2t7Xfc1zrwjTNiZciiNHPCHR3eufqHQmDBlNg0exJng8atRJBdhjD0Qlp0TygNLw+LcMRT/bcdj8s56rYC49D04Rl+uTrDmRjXJX9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+jSD7+FSTNy4cDlgbUVR5l0uy8U1HhJxiVCdYXXKGto=;
 b=cS1onbZTaz6hoAaeHtDFbFFAoLCBqY89YJ0ChMu/l5JygZp83vUplEo1j5ino1QNK0G5wxNYjBav2K4grmtn42ti+SzaiVdJQXHKI2rSYMyt6vlHYR4NtdibDCki+rI4OzvLVJPtupLeN7/ryWBhwuB8cVD62dKxeySX/pzy2w3lI71tWZqfH+s4TY6x7F4SxSh9qsfL8m6gpv1LlU5Xsg2aeJEpec41cykvfRENtheWAohONum+gjJQGsAsHQ7g+hhZIBvf2SnCXF4YVi4La+KNibZcbdQTWYAzAYwY5RdzxJEN4WWwBIgChOqdJcnKa9UeBmftpbkYiZTnwp1e4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH8PR11MB6998.namprd11.prod.outlook.com (2603:10b6:510:222::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Thu, 27 Jun
 2024 02:35:55 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7698.025; Thu, 27 Jun 2024
 02:35:55 +0000
Date: Thu, 27 Jun 2024 10:35:38 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Christoph Hellwig <hch@lst.de>, <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
	Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>, "Damien
 Le Moal" <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	<linux-block@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<drbd-dev@lists.linbit.com>, <nbd@other.debian.org>,
	<linuxppc-dev@lists.ozlabs.org>, <virtualization@lists.linux.dev>,
	<xen-devel@lists.xenproject.org>, <linux-bcache@vger.kernel.org>,
	<dm-devel@lists.linux.dev>, <linux-raid@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
	<nvdimm@lists.linux.dev>, <linux-nvme@lists.infradead.org>,
	<linux-scsi@vger.kernel.org>, <ying.huang@intel.com>, <feng.tang@intel.com>,
	<fengwei.yin@intel.com>, <oliver.sang@intel.com>
Subject: Re: [axboe-block:for-next] [block]  1122c0c1cc:  aim7.jobs-per-min
 22.6% improvement
Message-ID: <ZnzP+nUrk8+9bANK@xsang-OptiPlex-9020>
References: <202406250948.e0044f1d-oliver.sang@intel.com>
 <ZnqGf49cvy6W-xWf@infradead.org>
 <Znt4qTr/NdeIPyNp@xsang-OptiPlex-9020>
 <ZnuNhkH26nZi8fz6@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZnuNhkH26nZi8fz6@infradead.org>
X-ClientProxiedBy: KL1PR01CA0154.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::8) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH8PR11MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: 674cc3cf-f9ec-45c0-a6a8-08dc9651dedf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TRxfcgNOCtfec4hTwWFvMGMk/COYA0kIqOAMmNI1yLflOEUnMrC3HKSuGvS7?=
 =?us-ascii?Q?FlZ5anx25Bn6ds9LE7sKSXWnS9P0z+RqwfQwFZKr+N8xbpF4rO4O0JckG4yr?=
 =?us-ascii?Q?18GkU0fXamh/e6RVsa6DxlKZIQ/siRR2kROXVVBspKb1TXmivGfTpqoSALDT?=
 =?us-ascii?Q?D6K8RFOdaN23OAQr/BzT579DCtLzqhLQw89jGBHWmddgAc5XlHMsoxm23v9x?=
 =?us-ascii?Q?ZGf094sZ/4Do+7jifvn7Noc+OwuzRT06IKl/5fLQ3ZslTgJRLGfgJCRJsO+R?=
 =?us-ascii?Q?b7mWhhQBVT5hsWsYMBgyyKLwtteXCPK1OH5xqdNJeH470XH+opeH3e8hYtrJ?=
 =?us-ascii?Q?yyNTwe0U7WX2XUwY8FrMtkItIBEGZX2cbquzZSy+59z9gFt7g4Uc2zBjsE98?=
 =?us-ascii?Q?Jvf3otBt+Mg9ThMrpecwfNx1wJMEsHdeaywbAaGUkBBgHssBmYiqxpEA8EAq?=
 =?us-ascii?Q?77ii0hZNzvN5Jb2LhIDw7rBPHTt8GWY3doXv2iyu0T1BQOhnfSpVgDazU6SF?=
 =?us-ascii?Q?2IoUQY14B6+aa4aqByEtt2QVDHvbRHKRVBbEZGjNBn5WAEZYT/bgi/TvkzOX?=
 =?us-ascii?Q?LwAsZ5td/r7dAQBAlBn0ikMs5cH4ulNUo9onVMsbIS+4HRuv2mNxC1EWbMQh?=
 =?us-ascii?Q?guAGtIdIstekDRPHgnbw2C0dIZu4y5YePzd5+2834CTx90RUj/X59bcH1h9p?=
 =?us-ascii?Q?CzmIKkV5lQ6qMtlBj/tGbC93hWjhwyCSmZifp/5omvOc3LVCQCgPzR9azrYk?=
 =?us-ascii?Q?/KNMniNOMacvN921845wipSaJPH84jegt+JSwAgw3fZ/wHlftemOgt75jQ9/?=
 =?us-ascii?Q?Nr0kTnfvJYjRtYWW8DyprJDkprrhwicy36nlg0fpv+rOUZlIjZruK/L13TW8?=
 =?us-ascii?Q?fWG7Q3+w/PTcceIGkWsoQwqM6YktLrnX/51grMHgplF8Jv+gvCSFD49Xrwut?=
 =?us-ascii?Q?csqVFJVPJRNxYhDbY+0DL2cy+Ugg+zoDd6jcKJAY8VC/f083O62ANCxuDGKi?=
 =?us-ascii?Q?NnPxUHYRCfJMBcN6t8DDuG8JMK/XVC4rs5gKDCyw+p5Pj2jzHmnbhuzf8cRa?=
 =?us-ascii?Q?8PzXWrK7CZVb+j8DL9di6kKrGIzUAjYGzjt/3RHS453vPktsWB7toBbq9AXI?=
 =?us-ascii?Q?GHR8zOCq+qocCiTCtGphEI4+rqenHgANTDUD1lbjRtwRjYqYPCuLkobS63HM?=
 =?us-ascii?Q?K3OZGEX3MCVDLHNrnA4XhfEKQYFnecI1PKZBLqd99TsGBPVcF1qPZQ6YcjpF?=
 =?us-ascii?Q?RpjpoLTZqRCuCe4TIGY01vwDDQm2JW9SsDj2PFuaihrMaRJxm+K9FVVf30q6?=
 =?us-ascii?Q?fshmX05BlCbat33Li4490RGv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XkJHoqEbbM3JioGWYfAmoP8lBk7qjFj2lkgZoon44AEkR4yGBxONytPQaEcz?=
 =?us-ascii?Q?bvt87CcroadHHVHWDkhzgrZPOr8Ai6Oo3vK1kK6wtUatWrn84K3MSVps9Plz?=
 =?us-ascii?Q?Q5eaG+UHCcQGUfYkz6Mud6z1tvPGKRyuF5/O0EBDqofeWMvPurkeRfZFYPqN?=
 =?us-ascii?Q?+2m03Q8dPHKXlBC2CTYZREbzJaM7sFbOzyYyewMBegAmXRNL0UFpo6QDHh+c?=
 =?us-ascii?Q?3FRW6irHhD36jivRQTtEHJs7z7qKsfvIxMZVR1+dVN5oi1UahV0Kx4nwAv6B?=
 =?us-ascii?Q?OR0HNy3/wxjkKw2Z2LsOHpxwRpYHd9+spuEXpi8sLDC1Hs4BafOMY00LbILM?=
 =?us-ascii?Q?Pnq7UEPrbKxOrAGZ0VfyOgu50nGFpYbDiNKaQAf+E+38/Z6ewWSTg+itcUyD?=
 =?us-ascii?Q?tKBd2rYqbWAwT8fQ9n4MxKtoWHf4Gv8O8Cj32SYJXLayD/bGJ0Z+v47dSI8V?=
 =?us-ascii?Q?fNx2bjPhrfVU8v0o8eKyp5AphavWzAkHAE3Fy1TTysXTXpiRqPmcJVSVI+Z0?=
 =?us-ascii?Q?Bow6fPlu2zwES1M2fMyErOgyiPkOOBsM7vKZGDKPY3yyQ2GjriCafbzfMQZf?=
 =?us-ascii?Q?xQJrtkEV7M5US6pwa9vQNwf4duLiTSfGqpDuzXa2+RFNxu9lNh5TI9h27NjI?=
 =?us-ascii?Q?a8jenYz7gz0t2CfFu4n26V/NdNtJ+f3TYubNK+it6XWRJP5WNDlYF+UzpSSL?=
 =?us-ascii?Q?Lj1Fy4HTcK9AFV0i4JKWKEPjkDcq5cxKz8KnrklZ2puizFeWJDuyOIsFqzqn?=
 =?us-ascii?Q?R1hmLstI8hD3U36TYol6f8vUZgEiZPFvItB3yJsuPup9LDWndW+PTYYZ+NaR?=
 =?us-ascii?Q?p6pecjyt06v9HMEP48DUKqBQ2V7AR+FJv0NPuB/A8YYknTXgxoSrCxRHfvOb?=
 =?us-ascii?Q?nBUSVHivLm++m/fEbMf9/ISWG1Cyu3Dkwf1CNm6rJ1PtoSPQfJ+3c4zarTG4?=
 =?us-ascii?Q?YT2v4zViUKxGQvVm1QqlN7yRm0VieczBOmGECoTtL3Ab4lSwVvTfhM17EkhR?=
 =?us-ascii?Q?79oCcpcBtlivNjLrS9dGvcph3hGtOCusnR3p9kJLJb+QFsSFd0zJPKgeVDBj?=
 =?us-ascii?Q?nQ0lRzd3afMc7qoIBREKDB7eUv7cjcHZpBfeMsNhtCuhi7TigsvplUHzztl0?=
 =?us-ascii?Q?d9wSS1OHvHR6l7GtMxb3XIdE3Thj8fpX5G1ZErs0THQKnEMRDh5xkIa6ZTXZ?=
 =?us-ascii?Q?hu0qs4qeubuRegkSL8thgXY6AcgylxwoFb1pjftNYxVZZQXT32WhfTAfm+ci?=
 =?us-ascii?Q?InvlSSFUukZnNxmg62LuKScj73V93eNWqGam7DQC48VYvCTbet23Lu3BhgeX?=
 =?us-ascii?Q?AcJJKNVtgv2JYLpgQg31EOCyxK1nqo62id1JjOp0Ku+xOzt1IoZVDUAncb2E?=
 =?us-ascii?Q?bEv/vHy6YUGIOzX9W6On4eERqHrtiXLpEj4uFgZHs50CD3cRiN/muEQlDL0p?=
 =?us-ascii?Q?pgWPxkVUCXMdEBQzT9mt5FcFMn4c5rGB7B8611DgnuepOzrcpAMqZxkgRRYz?=
 =?us-ascii?Q?fj6tdXb1MOfADBp6CPNP6OZ5c2TijvsXYdp6G60Ex2MfiTay+7Ic4GOVHWmn?=
 =?us-ascii?Q?OWwsOpxOauCPVRJfTbRJUl/4EBkIArnZ+JM6VLbc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 674cc3cf-f9ec-45c0-a6a8-08dc9651dedf
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 02:35:55.6518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hEBCTBXCHr+NZDa/x9iWUFtzY8u2lfF7JCHOgMZESWvucK+BA/PXRt59u98o1xusx6adaHjnRY53UbVFdCazpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6998
X-OriginatorOrg: intel.com

hi, Christoph Hellwig,

On Tue, Jun 25, 2024 at 08:39:50PM -0700, Christoph Hellwig wrote:
> On Wed, Jun 26, 2024 at 10:10:49AM +0800, Oliver Sang wrote:
> > I'm not sure I understand this test request. as in title, we see a good
> > improvement of aim7 for 1122c0c1cc, and we didn't observe other issues for
> > this commit.
> 
> The improvement suggests we are not sending cache flushes when we should
> send them, or at least just handle them in md.

thanks for explanation!

> 
> > do you mean this improvement is not expected or exposes some problems instead?
> > then by below patch, should the performance back to the level of parent of
> > 1122c0c1cc?
> > 
> > sure! it's our great pleasure to test your patches. I noticed there are
> > [1]
> > https://lore.kernel.org/all/20240625110603.50885-2-hch@lst.de/
> > which includes "[PATCH 1/7] md: set md-specific flags for all queue limits"
> > [2]
> > https://lore.kernel.org/all/20240625145955.115252-2-hch@lst.de/
> > which includes "[PATCH 1/8] md: set md-specific flags for all queue limits"
> > 
> > which one you suggest us to test?
> > do we only need to apply the first patch "md: set md-specific flags for all queue limits"
> > upon 1122c0c1cc?
> > then is the expectation the performance back to parent of 1122c0c1cc?
> 
> Either just the patch in reply or the entire [2] series would be fine.

I failed to apply patch in your previous reply to 1122c0c1cc or current tip
of axboe-block/for-next:
c1440ed442a58 (axboe-block/for-next) Merge branch 'for-6.11/block' into for-next

but it's ok to apply upon next:
* 0fc4bfab2cd45 (tag: next-20240625) Add linux-next specific files for 20240625

I've already started the test based on this applyment.
is the expectation that patch should not introduce performance change comparing
to 0fc4bfab2cd45?

or if this applyment is not ok, please just give me guidance. Thanks!


> 
> Thanks!
> 

