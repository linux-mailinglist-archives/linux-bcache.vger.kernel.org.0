Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F051A3170B0
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 20:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhBJTyz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 14:54:55 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:29489 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbhBJTyw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 14:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612987826; x=1644523826;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=66hYRypShDSFIrqPX9dmE8suZp5MNBtp/i7AvdSEwJA=;
  b=kOa+2sVXnCzz501gqEJYpCD4LWulkRmMXzaxUSvD1C5G1DUTCRftVcdW
   mb5thky4MaLXpSWk/PWcqI1nstD/IoPwbUXknMPY5dYXZGXeyxqQUQFQL
   huV9EH1lrtCc1DV8T5cWAi0l5twXHaLfELLhxrxOLHfyqQA7cxlsGk56K
   /xIaTC7LSlabKNYqLBGl/bNHpUyQ9boKWpHzP9EXYsG4XBpAAl+IdEx1w
   hBrIE68upxJ/mNRbuRaM7zoj8ea+oXdeAc4iYOgU1igzDs3DPZ4Cx3Bn4
   Txe0RK6zRMaCCOXi1VYj8chXTTBxi9alBASTOkCScORlv64ENcFI4beOn
   Q==;
IronPort-SDR: GVS8LJ1B8jetiJcqHjngOHZSUKzaVCxRzug9br693/FNG5L40lBUqAhJjdkeQTnByfhKFzWiJK
 g+QoCDS2wgmTvdFWaSWJBDuTqBZkzVAJ8G16OKXDL0IljC5tFlYWZ5zK36FKG0cOiD2KULKNHi
 1o4ssnz1OTDtY5LwqkVWwN0Kjybz/eIL+ok4MbnmbOH3TDAYwsr09rXi5vEaaHXMtgceCjM3mJ
 VND6gEjBICIHXv0qlEjpAFHydLfMi22pUo5EmTtS5A/WT/AtJFFQXg2bqICNVnMaRi1WDTZpVa
 pqc=
X-IronPort-AV: E=Sophos;i="5.81,169,1610380800"; 
   d="scan'208";a="263811104"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2021 04:08:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNxdc7FEAPvr+RMHPdMPlXDTQOMqGLPUJwajnIUrHDbbY7fBAmFT8d1rmWy1UwfIrCLGFRyIzM0Jcpm/pASSaImLwvqk/+v19x6J1rp+NfY8WY0UJCBOlOv4DixsuJXiK+y3Hpb9vgU4sFHcBaVF7pEo54gHGVmRgShRPc3eFx7H5aXkduFtHFVAgqe3ZnYGZMuVWpLMosWoqfuAdlhRZv5J7fRVIX8YA79lT49SX7HIbOraVVhMxyK2f+HyLfH0pRXR1CrwD5M5cRFCb8fE6aR+xmqr8TNYjyTinU7BEEOXGGLNhE50hOMU+lyBQLRC54D0NW//LDBq3w5ofjJpAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66hYRypShDSFIrqPX9dmE8suZp5MNBtp/i7AvdSEwJA=;
 b=eKUorFguZ23zAxggWAF9a+n8KtdFeYtLjecpVRsn+aLf5GousiQDfICkhQoOTbxm5+wDc/3YJV5XVoIM1AdS3TBfUUtCpUnzIN/HKg/oF9YDCgZI/75+GzmzIdWwg1GhcYVX8kWfh+z3Ayc7yYkw6OpBh6WHkUte9MIporIIlis2buOWkDPqLkHHGDw8FismMmz7xf7xOGk5lpu79Uo3trbKmeP2NQWDTnH9aYqY5cEUmLYKvtH8NB7uMclqk5eecazjFkNs9okxEqSDM0/TEoSWA5jxuk1DSikxE5N6XOdVzkHZN79THWiRvgDez15oD6jSIFGP1btD1Qx3EaLCDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66hYRypShDSFIrqPX9dmE8suZp5MNBtp/i7AvdSEwJA=;
 b=WmpuJVPrbAnrWZGE/IiVdtzhIyO7vfsnr2P2VgBXq5e328FnvCimY7WlFkyV7jJqXj48XJ6Eey2P9YEr39tPd37/T/JegfN057RQrQCaZ63OmOESDcrHGjHPUoEJ32Xrli6Q3Db2snj/vz+0Ejc8DR+JCM8kTRkKLK+3CMZoErc=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5528.namprd04.prod.outlook.com (2603:10b6:a03:ed::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 19:53:42 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Wed, 10 Feb 2021
 19:53:42 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Reported-by : kernel test robot" <lkp@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: Re: [PATCH 4/4] bcache: fix a typo in nvme-pages.c
Thread-Topic: [PATCH 4/4] bcache: fix a typo in nvme-pages.c
Thread-Index: AQHW/7UqHrZt/nQu0U+fvzAGUTy44w==
Date:   Wed, 10 Feb 2021 19:53:42 +0000
Message-ID: <BYAPR04MB49656E77308075DE7F1B6CC9868D9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210210135657.35284-1-colyli@suse.de>
 <20210210135657.35284-4-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 956bb33f-1a82-4fea-a4a2-08d8cdfd915b
x-ms-traffictypediagnostic: BYAPR04MB5528:
x-microsoft-antispam-prvs: <BYAPR04MB552817F779187CB9770CCD76868D9@BYAPR04MB5528.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j0N8z2cO44qdSYJszouKUxt/dyLof+lvEtJnWkn2NwZcQ//pWdQhTcnuJVtgafaiZpb8tSeGFzfWh4R2WjYDJhWQw4gHkDYB6iWpnVDUjhJgfQ9yVdUGW8PnGNmje7jXwCxvMNtU34In4+hW7emQp+G/di7te6UlvlAqhhhG/Etkzh8G8OLDHH89q5R40fh2xGDPav2DDLn5f60D3BYoSo2k0V9MKsLVCKSQb5TdbxCkwGv17OpWvVyUYYAO7BcBYVrNNicVhhFNu3yrIMkT7+fs571n4/hxhqwCTyqQn9sgK3gXiBu98zCbpdsNbdzyI1RaDp0pxFPMxtKs3Z7EOiraAAkF3v2rqZ0qjw+KX45i+mGDqORl0h/XioObnTMUBFk4T85hRvLapDpjJIYXH86130Zp8Pz+h2V7P4d0EkOrzpxR5VPHlVd2DTKWggb1BeaeyNnrdskZ7uyFC3rT+iP+HuAAIcGeLwkVDTMlHC7anm+XA1C4s3aqR+TLaEAKU6BYWS0zzEidOqvKkkTAPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(5660300002)(7696005)(86362001)(478600001)(26005)(186003)(4744005)(9686003)(8936002)(55016002)(316002)(66946007)(66556008)(54906003)(66476007)(52536014)(6506007)(53546011)(71200400001)(8676002)(2906002)(4326008)(64756008)(76116006)(110136005)(66446008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZYW26ospXUhgoEns7DIXb9YjOVzqupy2vBQCZQlBkQfXAVYDC9TnYR9viAZJ?=
 =?us-ascii?Q?w2/0oeQR1nXM55Ce4YT+3QbwZt/l4SKJ/i+eKjECplw2CiMTFoI0b33vLPlH?=
 =?us-ascii?Q?sdhPYJrl0VFEW9rsrGaYPEtr37/CT18BEYZv5pXmMOPUWjht1iBaV7xkgFD2?=
 =?us-ascii?Q?pdssqqWikmJrEpwPxU+g7VteCPI99trSwgcg+9X+20pOwH9z+XfEf+uHz+30?=
 =?us-ascii?Q?x8lPOMdVB1ia6cY2e0QqOGSgy5oQz11UTfomoCnU9qN1thUq5JeDOorFitZm?=
 =?us-ascii?Q?9i63U2g33nlyYQOx/09j4BPxwEWnB3jnV8MEDTCgDV3U5rLzxtEPRUMhuaHw?=
 =?us-ascii?Q?ItG3B/HQfY6HaQis/JMCi+s5FNTIhwkbvgQA2azwldyM5EVO3Y5img0GoPfa?=
 =?us-ascii?Q?A30QrVhpXZ24TwqmHAtP4mTEFWkxaVQaQ81tAQadzJRJhj/Q6Ns9KUOfbQNM?=
 =?us-ascii?Q?7c5ek0IMzHq1L/QL1KeGYU8u/O8fko/urQlZvszG3WdXjHT925/ePgdDBgQf?=
 =?us-ascii?Q?aIpWoXmgAFRpE7SQZYmOhtX6yUMG4QSnKS6AVchT70GXZ3fLqEUlHHQUhxUR?=
 =?us-ascii?Q?/xnxS8mfymRryxpxfT2wZwy+IBcVUNaRQV7NPn/8enwTko1bmX0J0BJrqiGw?=
 =?us-ascii?Q?P8MC+QppEFbrXaaD+8kjsCP5ou+c5Y4ZQjKcEvE+JN6/ANmmsATdv9uwKm/L?=
 =?us-ascii?Q?PdTPPPDml/TmxxeSSQLMvDX1/kPc0luNw8TsfSmlJg+hEVkFXAgD4QRCoajr?=
 =?us-ascii?Q?66oO+waMLoYFQ0srL4lhqcQALcAC0tlK2mDIpfBQBTWgWe5cdQ6VDD+TUkLl?=
 =?us-ascii?Q?eAZxjtiNRI8BfilC67aUjmAvQ/LdsBeeMW5AUipu5fXWZJrt9YnVM4X3zLSX?=
 =?us-ascii?Q?etVe+jTEx3IugGGq7KuSvckZUwgUgvZu9vL6yLO2LrgJkrHHugHWP0NS7ER5?=
 =?us-ascii?Q?tmtrzFRRXVkW2C6bgIsRsXj8GCkQtPZt6bKn4ceJ4p1edKvdJxr8TxQRRtNV?=
 =?us-ascii?Q?IgQ0M+fliwAvE1b22xhiqKWiMhOHhIT0YP7HkrW7gJ6Tl/cZcQdTTP/K4hrM?=
 =?us-ascii?Q?VJ0PaCTsLYFJBsIlrYqdA92PC8IlpYstuuVm0drn5K//9bFKLhaX9rI39KEZ?=
 =?us-ascii?Q?7QdYZG5Ci0wyQGOo7wOoAHyDx4JoWlSG/BdOxPByYJ3ZvdcRCaAtqFTLkYA7?=
 =?us-ascii?Q?lk7KkMhevrA38RU/wzUpeZ4Neo6D9ae5tAWuIPWEP9rgFZurIbf63rLxW2sA?=
 =?us-ascii?Q?a+1Z4eRazOH2s+g59/1PDmxHbQl3sfGG9+aTDT0P3uMkBASH54EZbCHM4rjm?=
 =?us-ascii?Q?w+5dJASkY6a/cjpRIIhNaO75Lh0NklIxqZJb6M/HQ1g/nQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 956bb33f-1a82-4fea-a4a2-08d8cdfd915b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 19:53:42.1117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jwbeoPi6rG/Nz7z/2K78tcLkP/4VDlhCX+gzIiPHVapVeLd+zGXqNRajXGZZxj7paOjWWPmyEqEg7SE035GsXmWxJBnEc+RqLHsob9IPSgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5528
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/10/21 06:01, Coly Li wrote:=0A=
> This patch fixes a typo in init_owner_info() which causes an invalid=0A=
> pointer checking from a kazlloc().=0A=
>=0A=
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>=0A=
> Reported-by: Reported-by: kernel test robot <lkp@intel.com>=0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Jianpeng Ma <jianpeng.ma@intel.com>=0A=
> Cc: Qiaowei Ren <qiaowei.ren@intel.com>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
