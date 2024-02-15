Return-Path: <linux-bcache+bounces-273-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D23C2856FC2
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 23:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8872D1F2344F
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 22:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E14F1419AD;
	Thu, 15 Feb 2024 22:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yh2e4iUC"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20385145326;
	Thu, 15 Feb 2024 22:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708034699; cv=fail; b=t2WHFzGgD2EIL0ZJ4HW/p1cGb8QH+7zOjpP5XJzlYe470GkffyiVHjzepy0lZUBBw0jFvswWmkGye4Dut5YiWmpLp2oz44TmRSJi3ITRgLSLeufuG8zurMWsaXqR4xk0L5FLq5PvbJwPh1NK1AlK7hHe3vdcUmSa0czUhKyq0s0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708034699; c=relaxed/simple;
	bh=WjOgS/6HcmUfD13fhSGJ+9/v1z6pW4BvNtdd+Vg47c4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bI0fPtH8yKNRWgjxnUN/0ekfkElbq/1gWQZDjYHnV5s4KzQDQO5OMrzgqtMtjT8FG7MXKJWYfw2zgHKWoGMLL2SkB9RI2W2b6U30Hqo4a9O+4UQoK3kYIIM/g+kEVZHCiqyzUgj411dpaB8uvz+HAXAzg5e6Zh3feGutJd8Usks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yh2e4iUC; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708034696; x=1739570696;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WjOgS/6HcmUfD13fhSGJ+9/v1z6pW4BvNtdd+Vg47c4=;
  b=Yh2e4iUCBH6Ds2lEpu8/yrWs9uMrxxLEpwLQ1zmvd6Go5PwRsW65KZTH
   qtFVOPzpZH+fI1Et/iM0Ap6s44sRA1eWDrYNVSImUQPvrhK3pUdYTLFdl
   bjsgOSXQgsnLTPX4KuKW6r6XPkZ/X01+jODxYng1aY4x+Dk0BUqJD5WXn
   WdPJXpn11akb4nb1kqgl35j9HmOyd2HfikFGKKks1rtFMGAz69/cwe7rY
   XFN6ghp/1m4zqezStGGeWb26XlhEp9tMgBVwlD8zpAJR+IZn/DP8guNJv
   8P3spUiz226wCsFVxECqiZdu136Jk1+Ab4UVwA/9V33k7MEvSQZDB2vkM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10985"; a="2271035"
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="2271035"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 14:04:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="3684961"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Feb 2024 14:04:55 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 15 Feb 2024 14:04:54 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 15 Feb 2024 14:04:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 15 Feb 2024 14:04:53 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 15 Feb 2024 14:04:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQ60Wj0aBDwGbjmUmLlfYszjNR6IlCA3B/OojzKdyoD3/sUBheE2PbS4cL5hPHWDb/dZuDkIk0fSPrIygfepUKKrHtCHCDn4exOPz6CldcRGHjhbSFdlU/70DW/pkYs+zzwbqB6hfNmVz25S58iqOVOMpDX7X91+zXKkTnW4PD0BFqBiUtNcRpMkI3PQacKqUpsL53w/SsU9MsSCI0eKDjXBpE3DHTmmYd/f9UR9BYHeiD+Msma2jhIRtzLtOZ46Kx81FtuApMg7r3c/hdLOQJwlWJZQsbce/VocntzPyEzPpwhTeTGFbZDm0F8DJITUEHnRX5/j4K5Rz3bLZeKiVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGxiFLwnpOxCDhPYc4cG4WwnoaDG6ww6MAEvx/mxaXY=;
 b=F1l2JO0/mXPNQ7XjEsLrml148NCbkhU+sJ4Mr5m4IsJ6IVaIl/kqHIfucylTWp0LwX56Xxozdztm5B1wTrjuMLNou+AtaZAiBbnRwpY8QzfG4qZY5TlFacR0ZLZE9joTJWKknuUHFVDIAWDNSXxZjLwLVw12wLNz+iWqXP4+VAslES7R1DW3o11NpgclfdR9qZ9PxDLZzCQeRgR8P8jQkUAJ3nyu0GuURBpWZXtPArvkOkAE8dnt9AJczIHiaHdgtX8RR//2/d+iw3aNWd8GIndGR3tNHaGiKBesOZt2d3kwWoGsUgBvEy7ccpRxOn8ZUSEqBIV79ivs38r2TuK8+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB6685.namprd11.prod.outlook.com (2603:10b6:806:258::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26; Thu, 15 Feb
 2024 22:04:49 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7270.036; Thu, 15 Feb 2024
 22:04:49 +0000
Date: Thu, 15 Feb 2024 14:04:46 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Minchan Kim
	<minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Coly Li
	<colyli@suse.de>, Vishal Verma <vishal.l.verma@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, <linux-m68k@lists.linux-m68k.org>,
	<linux-bcache@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: RE: pass queue_limits to blk_alloc_disk for simple drivers
Message-ID: <65ce8a7e4ef0b_5e9bf294b1@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240215071055.2201424-1-hch@lst.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240215071055.2201424-1-hch@lst.de>
X-ClientProxiedBy: MW4PR04CA0152.namprd04.prod.outlook.com
 (2603:10b6:303:85::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: 933dc752-efef-46df-4283-08dc2e722093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQ8PdlS7ehdVTj+fBlBHfdYflLTtL2pzzJdoi9J77xsKofBZF2Z3NOD4VRmGex+SZfjfuQ3eeIItjXGAHJ6vrQVIm3jhg7SXWuE46GqozuhZfy80C+wdtMuwV/tUFVespdSk5rjOkltG3qn7cc37ZI5xmKyhNpARMCj/mOhq3YastOeDaqkSHSVCnIVLcGtGMFcSZvOr0SWxvk/seKXL1vfiELjQE4J+ocYoPfZQiNiiWMqyzIX143vheFgW6NPndN9yQlol47Fe10jaC9XW5MBhAwoE0bt9EtN92sRhi0Vi67qxfk1vilCoXomvaDFkMCSbAux2pSfW0gUOqLJhO2OSAWSJaFaJuR7wUNLHg1l4QVVrdJt5yQW76OwPfNxKFCcjHMRBOCsljxYWe0c1z4gymY3YtsbPI/Rd8KQshnh/AjnYSP66J2LNnodWKuPTZ5efYCQv5cUlQj8SYv3ixlOurzlO4CT6KPDpUSPTMomVVgUO5fL0BkgBN5wGbA9MDDmzV9DoxgcgJYpUdQEU6RSiin9BXh6kmB4jmqALsMzIg4hqMKbqI8ljs7go32JF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(376002)(396003)(136003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(6512007)(9686003)(83380400001)(41300700001)(4326008)(26005)(5660300002)(8676002)(66476007)(8936002)(66946007)(66556008)(110136005)(54906003)(316002)(6486002)(6506007)(86362001)(38100700002)(478600001)(82960400001)(6666004)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BfuEob+Ln16oMgJjijNgTfrJMQJTmctiCv0A4lsdp23Kl/NHZQL5ofKAFOmV?=
 =?us-ascii?Q?zpG+yJYqhw44TojY/c33LzSBmfFu80K+5cFa90OWF/GjOizgaMBC4C6vWeMk?=
 =?us-ascii?Q?W15Eb1Rg1t/mSA7mIldFFnD8ZYQdqRbJ1SxcEYPuD0kH1a3++Ncz4sUTKEZs?=
 =?us-ascii?Q?P1VGEzCQtoF4e+Mb5TAr3JbbEaFGiNFYS1nBEk3A2d5ajMUtB+SHNABIPz4G?=
 =?us-ascii?Q?anxuUxsMNAxBe8QYvo7UBYamUgh/ugFV3BIxWg1x4YFgrsXdbH36TmBzftcx?=
 =?us-ascii?Q?FYQ3vFW1VIGh4u63UfaZO8SkhAbJ0HoKJoAEoG1hCqB/LiwVsULeC+OCL0TB?=
 =?us-ascii?Q?ITIZjDafD7vjF0hXHY7uPu+SbHiU5LrpE26NImQN5WKb6/oSO+YqZ6eO6Gd8?=
 =?us-ascii?Q?bJ6vEXUiF44pCF974ePtenQfB6sYPPjnAUGpPCF2c3iZoJVt203neFzYNAPi?=
 =?us-ascii?Q?FVnB4ps+eVMx6Gm7tJPc5f3P/DlvckEd97uUqXnLLNXUgp6L/RnGT/eKpU0Y?=
 =?us-ascii?Q?/JyR+Awc9UTSdv37YJa+mtaNE3DwOtjemsdJSivbNcBm37FDSnBOKTKVZxQp?=
 =?us-ascii?Q?0iG9wNqTn8lKepezuXxrP7c4dp/e/TodQdavXwOLc/MWNIv1cCQzbKLlwILd?=
 =?us-ascii?Q?XfVs1rHkWkgF3Lo+fmpRvcHXyenwpviSaAWuZU05SkpC6YbGa/j0zrNxJzSL?=
 =?us-ascii?Q?XsAzH2eJ9cT5ba0pUW2mfG/3H/bCbYhD+uQb2P8p3g5TuHyypBym7vd6E+ao?=
 =?us-ascii?Q?1nfs2KCC92t5EZPQ/uHTPOJynnAM/8YEMQ2BLx06vDccyJjuv2WKHrEcxJ2o?=
 =?us-ascii?Q?LJtRqDo3ZHb+OAgsUmTsG2PxEi5bZMYa6mRpcusQ+8qZQBLB/rk36MCvueJO?=
 =?us-ascii?Q?UsvUmYcNdX0bxkN6MZEDDjOrql2IsoJ4J+oI4y3W0DzPgi8kSjuBGdlUEcMv?=
 =?us-ascii?Q?TMngfmTUs1jRX7Rr9UDdw7tPeJc2Lk4X/qI1bX92n+dogKW2652h2Va/lJnB?=
 =?us-ascii?Q?C/Y4V6Od1g39C8SL8LbxfShR3bjw2iu05BtBZoehmLmb7J0euwUDx8Ij61w8?=
 =?us-ascii?Q?At+TCtY+j4qNcAyy7ndizv796Cr7quzUXwgaeCEbLJAvDiPVvNBaiJTQIUXt?=
 =?us-ascii?Q?GdQ6lDhsrZaO/5rLhYbw34W5ydSL7kLDfVCkAveDT83M/c0CUZAJLhrT8uVq?=
 =?us-ascii?Q?3YXIPnM7I0rpZ+RLeQTrGu+g/Ql6Vf99s/BIIPjqs413ib6MM056orJm632q?=
 =?us-ascii?Q?0xrvzF1Zh31hRfL9A2qysXewue1uKIdcs5t/XBcfBlnFctuaU7kscZxgsbh1?=
 =?us-ascii?Q?pu+5cUPgJK2k0IgexIpeihAXchiLQOX34JCAOM+nnD/Ott/IJr683Dyw6Kyc?=
 =?us-ascii?Q?n75CHHYsrsEZy7qArq2cpvSpSpL0sB/WSJCc6jYWzcL3inUvg7ZMCHz+wwwG?=
 =?us-ascii?Q?75QVSuzxw+K/8aVSt2ZIwMF+mG8MeD9TmuQ+6r3hSvNuoP5CzPCxjqL1N7Xb?=
 =?us-ascii?Q?CV1D3MGFR8L6jffIJgpkX4rZ7JnA9fUAAgXC1WF5eJ6YH7qo2zAk+ljDMBNB?=
 =?us-ascii?Q?30GV1ufQBghUXWIZoptHG/RvJWgg7kpZbmPZpcNgvOvdhU4Sj+hGm5Lzu5FU?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 933dc752-efef-46df-4283-08dc2e722093
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 22:04:49.0236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C92rlogLD9aoUzpCAc4QqayB8+/0ln1O0cHAMVfmDGllLB+JfcMjBxnT7+GdttnkXp03wGkCNhSTwU2+prLfOIcD087tnyeMijJT/N+xR5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6685
X-OriginatorOrg: intel.com

Christoph Hellwig wrote:
> Hi Jens,
> 
> this series converts all "simple" bio based drivers that don't have
> complex internal layering or other oddities to pass the queue_limits to
> blk_mq_alloc_disk.  None of these drivers updates the limits at runtime.
> 
> 
> Diffstat:
>  arch/m68k/emu/nfblock.c             |   10 ++++---
>  arch/xtensa/platforms/iss/simdisk.c |    8 +++--
>  block/genhd.c                       |   11 ++++---
>  drivers/block/brd.c                 |   26 +++++++++---------
>  drivers/block/drbd/drbd_main.c      |    6 ++--
>  drivers/block/n64cart.c             |   12 +++++---
>  drivers/block/null_blk/main.c       |    7 ++--
>  drivers/block/pktcdvd.c             |    7 ++--
>  drivers/block/ps3vram.c             |    6 ++--
>  drivers/block/zram/zram_drv.c       |   51 +++++++++++++++++-------------------
>  drivers/md/bcache/super.c           |   48 +++++++++++++++++----------------
>  drivers/md/dm.c                     |    4 +-
>  drivers/md/md.c                     |    7 ++--
>  drivers/nvdimm/btt.c                |   14 +++++----
>  drivers/nvdimm/pmem.c               |   14 +++++----
>  drivers/nvme/host/multipath.c       |    6 ++--
>  drivers/s390/block/dcssblk.c        |   10 ++++---
>  include/linux/blkdev.h              |   10 ++++---
>  18 files changed, 143 insertions(+), 114 deletions(-)

For the series,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

