Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25C64BF149
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Feb 2022 06:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiBVF0c (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Feb 2022 00:26:32 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiBVF0Y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Feb 2022 00:26:24 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2595922BD7;
        Mon, 21 Feb 2022 21:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645507560; x=1677043560;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wr802xoxT+y0StEg6/tGS50M00zFSHbMSNcej0SdU48=;
  b=Usb3XMwM48RmXDTpwF9FXRYYqjRH10lHwu3QrRoTt6ECbbAYcll2ye9C
   4jGjtXvOSv8EewBma3JpXlvq+h8sXJMUemIdxqQAPXCzdctsRzZKFUrZB
   hUFMP1kPu4e1DDH3z+VhVzWeoev2RpjLQOX2cTIdeAgx2Wl/Z7iEnpFrr
   Vvoa7bWhATZZtRfWZA4FFkfJFujzoKjftpMLg2FmyXVCEqQ4xDnkrwExJ
   u2MSrVBHsDud9sKx21z0tImGmlbay5+FuXX673qanKrZcq4X7m0x1ubqp
   y0I3qx59wVwNhZNNnpA0Ls47kBmud4upO72GqOgGeungb+WEn/V+WBegM
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="235153706"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="235153706"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 21:03:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="638775004"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 21 Feb 2022 21:03:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 21:03:53 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 21 Feb 2022 21:03:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 21 Feb 2022 21:03:53 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 21 Feb 2022 21:03:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgvakeIfBIrtFpAttV3OIQeljcTpNZO0vSx6X5BheOiGLRj1iQFn/LEg0pi0A8Hkt0TKQBxyhPslmourrcUAAULIEvLiXdTfBvlpw39bjVKsh3ZkLxrS0hOSDMyzZrTNPOLeYLrkC8vWlWRmNGCHFklF13dzHQ6hUqt6DWpRvofx2TwXiRx/5udNqKD5yIbB2r+numt7Pw/DdXWoYIPTerLCP21amX5z7ThLVsa03ZIUyAYS349Gk+kugS1aiIF0sH4bBWk8Taru4U1wkRqPTAeSGUcGFwS+OeCCN6oDq9PEK1FzM+4CvhETj2Lbe1G7h8zyxjnx+x4fmI8wB1gZ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRy36ykhNNWN9lgGDafRu85oBF8yPMD7aKIeA/512MU=;
 b=da0Ik+OV020/AjZkFnr1Xdl74GjVPhnAB4ggmpYGgtc3hTR0JLozKiYErOxlYupKh4TLdrpihm5TFs8WTBJrzUc4xkpOfFxWCU88RDJVJH73VJJFzHdCk6I99i/mBLD1jXgSlIeYAENbH7mrnj4Ls/nRklgwZ2z5wT9qcIfqUQbRjMW+FA6+sO63ZPQJJlTh2D+AFvWeFVaAsB0d7gSRsblaragY8HqACC/2z6QkP7Gtl5AzuQX9LjQfwQ0/70bZK85jsmojPb5aZx8D5D6sBvnimxWZs9xKrM0zWzsDeO0acaCVh1r/Ny0PmqvSze/zn3MIXhrWcG0j52jTaKQQ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2706.namprd11.prod.outlook.com (2603:10b6:406:b3::18)
 by SJ0PR11MB4782.namprd11.prod.outlook.com (2603:10b6:a03:2df::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.23; Tue, 22 Feb
 2022 05:03:51 +0000
Received: from BN7PR11MB2706.namprd11.prod.outlook.com
 ([fe80::a44f:b413:7aa4:29b5]) by BN7PR11MB2706.namprd11.prod.outlook.com
 ([fe80::a44f:b413:7aa4:29b5%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 05:03:51 +0000
From:   "Ma, Jianpeng" <jianpeng.ma@intel.com>
To:     "yukuai (C)" <yukuai3@huawei.com>, "Li, Coly" <colyli@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
Subject: RE: [PATCH v13 05/12] bcache: bch_nvmpg_free_pages() of the buddy
 allocator
Thread-Topic: [PATCH v13 05/12] bcache: bch_nvmpg_free_pages() of the buddy
 allocator
Thread-Index: AQHX73qkCCQwj+e6kEe4SKUaIKfA46yeYDqAgAETZzA=
Date:   Tue, 22 Feb 2022 05:03:51 +0000
Message-ID: <BN7PR11MB270659A970DFD7E01F2D4A38FD3B9@BN7PR11MB2706.namprd11.prod.outlook.com>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-6-colyli@suse.de>
 <e1e08398-dccb-6c0d-aaa9-da72f0cf9ef1@huawei.com>
In-Reply-To: <e1e08398-dccb-6c0d-aaa9-da72f0cf9ef1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ebc6cc0-3b34-4fe4-23d8-08d9f5c0b7c9
x-ms-traffictypediagnostic: SJ0PR11MB4782:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <SJ0PR11MB47821A8E57214BD919836151FD3B9@SJ0PR11MB4782.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eO6z7dA6Pxe8eIm11xAtUmLZIlNgHlZlnTqU/0b5YiAzAztH5gRro5nB9qWdeKF1AxGlpZiGrytoqQgOMT49UB5Dv11PCwwSymW4NYZjjj3k6xWXoblpikwtrmH2DVidmv1JU0hdNSHU+aL8PRCbowcBx2V0lT9md/X2786KE/7HC+uVLI9d4FnAbxX0cx7seQPaQyQ65Oy7jv3bfiAkQE1qrJHntma5RTFpb81/rPy6+IWcROFLx3+uxKpx4zTrNi7JmtR/UEj6Gg7ufqvmdJkEpNpVsoTHSWSfdd1A989gnEoel7/fU5F5vgtas7jxsXngjVPCI07Vqu1Dmwk2YZjIuOelVpHNXUNmbDj7ddNPsUZIRPBX6W8zGcwk6bllN9ZEz8AL14FlNrczvDo5H8easY2dfYrzfeghZ+wwSsYSSpH2BksZL073LVUhmFNFlL86KPLyHDa3KifJUGqoTPrUtIMpP4EjBdwaOm4CK+z2yyQmDgm0dehEisgTw5tJXF+tXg9WYV9sNc3CTPFrcoOgMnvjEkAI6sJoLd7YE8s7Eh4TbvDPEwb4gliPjhIjj0yxSf/4yjEBwrMCxRF1ff821NahFRtWnJk0aXpUB7eMJppe5pxXo6Uk0VcskRu6OoOTuZHQDu5fV+fz+hFbXXPbOr4YcdSBrqTz4OUgKr5KB7Szur6oPqJB2otRwhS+UCwmXZ4mLBzQQb8RqnyFQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2706.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(33656002)(71200400001)(7696005)(38070700005)(55016003)(508600001)(53546011)(9686003)(2906002)(38100700002)(52536014)(66476007)(66556008)(5660300002)(66946007)(64756008)(110136005)(54906003)(26005)(8936002)(186003)(316002)(122000001)(86362001)(82960400001)(76116006)(83380400001)(8676002)(66446008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?VE4rWGx4SzYvVXVVREtROXQvRm9nWnU3SXBnMlJwN0I4bE01ZVp2amtw?=
 =?iso-2022-jp?B?YVA5THgwL0dJVFRpTCsvejJlU2pTemp1dm1UTER4SzVpRC93NnlUa211?=
 =?iso-2022-jp?B?eENQMDB1NTBkWjMxSHlWTXFxTUdmUkVubnFBZ3IyVkoyTnVYdzg1bDE0?=
 =?iso-2022-jp?B?OEgvbTI0ejZka3dXTUxhamE3WDBEc2FXNFhWbGIrbjFzRlU1TE5NN3dO?=
 =?iso-2022-jp?B?Y1luVFYrc1A0N3BQaGlCNU10cCtybnVYclBWc3EzOURhcFltcU0xQnh4?=
 =?iso-2022-jp?B?amtZNEFuRDJUSk5ZbXRFZENxU3d0OUFmd3ZBM3JsVngrK3dobWs0dDVi?=
 =?iso-2022-jp?B?cGNEMyt0YUpDTzJIMC91aWFzNnRyaGE0Z1AyYktabmlvUFM5MCtKbXRv?=
 =?iso-2022-jp?B?ckE0VjU0WmxBaUM0WXh0Y0p5MmxhN3hGcFJCL1hVTkFMQWRFZUVEd3oz?=
 =?iso-2022-jp?B?M25iYUpLdG1jS2dvdCtsZ3lFT3VLTXNoSm51UVVWbXdGc2lMZHdFakly?=
 =?iso-2022-jp?B?VkdoMURRYXYyTUp3VExTQ28ya1dkTUl4UDYyeW9kaGNUNlBqM2tNZklS?=
 =?iso-2022-jp?B?c1pON011NllUaFlvQndwaVZoRWpsK24zdFFBS1FWa3MwVVFuTC8yTHRZ?=
 =?iso-2022-jp?B?WFhlUkl6UW1PNHhiaklsVWtTS1dVbE5jR2daYlc5eTVmVFdjVHJJNEQx?=
 =?iso-2022-jp?B?US9BNjI2a0RwdFFraTdmbHQzb3Y2NW1sb1Z5QmcwYzNLeWlOQXdSRSt3?=
 =?iso-2022-jp?B?MXp4YTExUlpUVE5ncE1QU2dUcmxiV1ByWlgwcitia2ZjK0Rrcm03azZy?=
 =?iso-2022-jp?B?a2pvSlM2UzkzanI0VDRpMm9BZUlkN1pyYkVaUDdiZ2loT3JFMnh3N2JG?=
 =?iso-2022-jp?B?VHQyd3RSOGhnbXJjc0lhckVSQWs3RHhMdzE4cHJSUXYzY2xmQlR2UTVz?=
 =?iso-2022-jp?B?ZC9GRVNJZUFDS0xNOUl0dGF6cUlhVDBKTVp2Y1F0Z2ZkL2I1MVpDbDht?=
 =?iso-2022-jp?B?dUdrSmNzSUJQZnducW02eSsxZXp2dlU1N01tOEp5SytkaERaTmZuUGJU?=
 =?iso-2022-jp?B?QXlObnJ2T3lDc1Bmdys4Tm9DTTJVSXpKaWVQeDhhM0JFVFRUN0s4SGpY?=
 =?iso-2022-jp?B?ZlNvT3R4N0V5VElNSkpVZ0FBdmMwemtUWFM1YjFWNGZNTTFBTGg1Q3BY?=
 =?iso-2022-jp?B?Q2t3UWxvUlFMc3MrKzJvVnRYUlE3SnVPVEJXUXhqaGQvMEhGWllSY2hy?=
 =?iso-2022-jp?B?S0dSajFhSVlRU3lncUhSVzYvbGNkOVNTNk9GWExFWUl5dk1JaS8yekpj?=
 =?iso-2022-jp?B?TUJZMVNiZVlPS1FuUktBWC8raWt1YUlXV244eHlaUVFrT0pZdXVpZnpn?=
 =?iso-2022-jp?B?cEFnZWxBQTlqZWxRUlpVMkQvSlZIaWJlR2pLazlxRDhwVUtpRWRBcFFz?=
 =?iso-2022-jp?B?Y0xnMHZ1WHhJbENYT0hza1hUK2ZmdWhXd2NQK1dWdE9yZ05nWWlIKzRK?=
 =?iso-2022-jp?B?bm5Zek5Nb1lOWEJKVStWdGpXSWdNWWY1VmdqNWZiN0sycDVXeGI2SFJj?=
 =?iso-2022-jp?B?bURoUU9ZTHk4d1phaFBXS1B4OTNXbzZVbEU3dWpnM00vVEgweU4vWUw4?=
 =?iso-2022-jp?B?cm5GbW5Rc2lnK0Raekg5dDQ0MFgvTFhWRFdJSFRCdTNRSDI3ZUtkUzRX?=
 =?iso-2022-jp?B?b0NIK0FWQ2xIVUNwRWlVUnZoMGpjenhjbWhkdkFMTkRNd2ZiaHRwT1pE?=
 =?iso-2022-jp?B?Q29BVkZkRTJrL1FyY291THJHbGIvbGJ6czhqM3IwL2QyK0JsQjkzWFpq?=
 =?iso-2022-jp?B?bHFxWmRGZ21CMWJKbzk1Y2lKNUQ0VGlYdGJZQllBb1BzRFhYcVNiaWJs?=
 =?iso-2022-jp?B?TFl2T2YvV2hpdXdsQnd6M1dpMCsvV3dsYTJrTEhxVVFNSkg1a3N5bmxq?=
 =?iso-2022-jp?B?TTk3VTU3OVpqTFZ3RTZleUJKMUkrN3F3NlNDbFJaL0pmWlorNSszZDRu?=
 =?iso-2022-jp?B?UDlSV0pvempBcEVWVXlLZ0NEZUt5QVZZSzNkSnlyVVpFTW1NZm50dGdn?=
 =?iso-2022-jp?B?enBWYTd4T3diRTVrZjQ1ZDFaZjllaEE2UFI5a2tha1dDN2hwcjBnNXox?=
 =?iso-2022-jp?B?RDIvVHQzdDZNeGcrd1NKSUU3TUtESUpEejdQdE1DbUduYWF1Q25xZ3BM?=
 =?iso-2022-jp?B?OThYWTM4NWVmMm5oYzhDZDhicFp1QlpMS21SNkFvYmRDRU90OHlub1dS?=
 =?iso-2022-jp?B?elZwQW9hNWNYWjlCRWI5WVJGdCtQZ3pBVW05QVd5cVNRcGlOWFpCMmdi?=
 =?iso-2022-jp?B?SGlETTJNanF2K2s3VHp5ZjRnWnI0WFBSOWc9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2706.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ebc6cc0-3b34-4fe4-23d8-08d9f5c0b7c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 05:03:51.5105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wz/PVqucHF3ruyg19ysKUtMirXgv4ZB1CgG13eHM+5Q7H5yMPkMw6tONQ1pm0cUS1z88ShCF86n6G/+4KBDGFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4782
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> -----Original Message-----
> From: yukuai (C) <yukuai3@huawei.com>
> Sent: Monday, February 21, 2022 8:36 PM
> To: Li, Coly <colyli@suse.de>; axboe@kernel.dk
> Cc: linux-bcache@vger.kernel.org; linux-block@vger.kernel.org; Ma, Jianpe=
ng
> <jianpeng.ma@intel.com>; Ren, Qiaowei <qiaowei.ren@intel.com>; Christoph
> Hellwig <hch@lst.de>; Williams, Dan J <dan.j.williams@intel.com>; Hannes
> Reinecke <hare@suse.de>
> Subject: Re: [PATCH v13 05/12] bcache: bch_nvmpg_free_pages() of the budd=
y
> allocator
>=20
> =1B$B:_=1B(B 2021/12/13 1:05, Coly Li =1B$B<LF;=1B(B:
> > From: Jianpeng Ma <jianpeng.ma@intel.com>
> >
> > This patch implements the bch_nvmpg_free_pages() of the buddy allocator=
.
> >
> > The difference between this and page-buddy-free:
> > it need owner_uuid to free owner allocated pages, and must persistent
> > after free.
> >
> > Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> > Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
> > Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > ---
> >   drivers/md/bcache/nvmpg.c | 164
> ++++++++++++++++++++++++++++++++++++--
> >   drivers/md/bcache/nvmpg.h |   3 +
> >   2 files changed, 160 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
> > index a920779eb548..8ce0c4389b42 100644
> > --- a/drivers/md/bcache/nvmpg.c
> > +++ b/drivers/md/bcache/nvmpg.c
> > @@ -248,6 +248,57 @@ static int init_nvmpg_set_header(struct
> bch_nvmpg_ns *ns)
> >   	return rc;
> >   }
> >
> > +static void __free_space(struct bch_nvmpg_ns *ns, unsigned long
> nvmpg_offset,
> > +			 int order)
> > +{
> > +	unsigned long add_pages =3D (1L << order);
> > +	pgoff_t pgoff;
> > +	struct page *page;
> > +	void *va;
> > +
> > +	if (nvmpg_offset =3D=3D 0) {
> > +		pr_err("free pages on offset 0\n");
> > +		return;
> > +	}
> > +
> > +	page =3D bch_nvmpg_va_to_pg(bch_nvmpg_offset_to_ptr(nvmpg_offset));
> > +	WARN_ON((!page) || (page->private !=3D order));
> > +	pgoff =3D page->index;
> > +
> > +	while (order < BCH_MAX_ORDER - 1) {
> > +		struct page *buddy_page;
> > +
> > +		pgoff_t buddy_pgoff =3D pgoff ^ (1L << order);
> > +		pgoff_t parent_pgoff =3D pgoff & ~(1L << order);
> > +
> > +		if ((parent_pgoff + (1L << (order + 1)) > ns->pages_total))
> > +			break;
> > +
> > +		va =3D bch_nvmpg_pgoff_to_ptr(ns, buddy_pgoff);
> > +		buddy_page =3D bch_nvmpg_va_to_pg(va);
> > +		WARN_ON(!buddy_page);
> > +
> > +		if (PageBuddy(buddy_page) && (buddy_page->private =3D=3D order)) {
> > +			list_del((struct list_head *)&buddy_page->zone_device_data);
> > +			__ClearPageBuddy(buddy_page);
> > +			pgoff =3D parent_pgoff;
> > +			order++;
> > +			continue;
> > +		}
> > +		break;
> > +	}
> > +
> > +	va =3D bch_nvmpg_pgoff_to_ptr(ns, pgoff);
> > +	page =3D bch_nvmpg_va_to_pg(va);
> > +	WARN_ON(!page);
> > +	list_add((struct list_head *)&page->zone_device_data,
> > +		 &ns->free_area[order]);
> > +	page->index =3D pgoff;
> > +	set_page_private(page, order);
> > +	__SetPageBuddy(page);
> > +	ns->free +=3D add_pages;
> > +}
> > +
> >   static void bch_nvmpg_init_free_space(struct bch_nvmpg_ns *ns)
> >   {
> >   	unsigned int start, end, pages;
> > @@ -261,21 +312,19 @@ static void bch_nvmpg_init_free_space(struct
> bch_nvmpg_ns *ns)
> >   		pages =3D end - start;
> >
> >   		while (pages) {
> > -			void *addr;
> > -
> >   			for (i =3D BCH_MAX_ORDER - 1; i >=3D 0; i--) {
> >   				if ((pgoff_start % (1L << i) =3D=3D 0) &&
> >   				    (pages >=3D (1L << i)))
> >   					break;
> >   			}
> >
> > -			addr =3D bch_nvmpg_pgoff_to_ptr(ns, pgoff_start);
> > -			page =3D bch_nvmpg_va_to_pg(addr);
> > +			page =3D bch_nvmpg_va_to_pg(
> > +					bch_nvmpg_pgoff_to_ptr(ns, pgoff_start));
> >   			set_page_private(page, i);
> >   			page->index =3D pgoff_start;
> > -			__SetPageBuddy(page);
> > -			list_add((struct list_head *)&page->zone_device_data,
> > -				 &ns->free_area[i]);
> > +
> > +			/* In order to update ns->free */
> > +			__free_space(ns, pgoff_start, i);
>=20
> Hi,
>=20
> While testing this patchset, we found that this is probably wrong, pgoff_=
start
> represent page number here, however, __free_space expect this to be page
> offset. Maybe this should be:
>=20
> __free_space(ns, pgoff_start << PAGE_SHIFT, i);
>=20
Yes=1B$B!$=1B(Byou are right. I'll fix in the next version.

Thanks!
Jianpeng.
> Thanks,
> Kuai
