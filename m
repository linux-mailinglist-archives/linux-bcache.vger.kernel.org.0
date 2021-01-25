Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A343304424
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 18:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbhAZGB3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Jan 2021 01:01:29 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60488 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729183AbhAYODy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Jan 2021 09:03:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611583433; x=1643119433;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=Ek2G7xRmYt8CIqEqm1zWuFdOelKVDeLNfESt/tOkG5QIgstFlJcvqmeB
   GrXlMgQCtcYqWaxXN+IpPiJs/+qMyQEyEu8AzfdV/rV17VQhYmf+pm8VO
   g0A/q05XEGNDQWfTQBB7eSkgQUvrHemXYTPWaK/ojrlcztl5I19ETNdj6
   WeFMcGkIlm6cClwkZ/tWmerqMzw1kGyHOnUUNd4TNecQybFarfrnWhuwW
   uM1uWk83lWNK38AuzeS9W/BvF1jelSHzxR2vfDAIMSYFf3rRqWNlXStTg
   VLhMunftGAB1ewI6ERpECKk6D23t+G9OFt6z/C9X6ldc/s15UlSXBAexw
   w==;
IronPort-SDR: V3N7ZrSNWeXTX+/dvYszCBh4E/pXfqshqmFMQiMDWHwAOGTJLRcZyxI7cUo0ne28UotquITEKB
 hnQwqn/jFVOVtBJJoaTeOUBFGDZ5/ZFyrhIj+VIsmE6lUg1fhJwQ1XV9HpOq3eyypOn+lrR42W
 FNq8SmU/8wKOP+cwLSCO+abdeSsPtD1YM+6BGllHSO7Wo6lqKk9ys0tIxZPaL6+kJp1FVrleH3
 s2CLpO2JgDRD2q2cVeg/mxi6xsXZI/4HkZ6+GgxKMC5Sxpfiwe4I+HsoIfaeGP6XKvrzcHdc5G
 kJE=
X-IronPort-AV: E=Sophos;i="5.79,373,1602518400"; 
   d="scan'208";a="268618223"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 22:02:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6bcB5R5jIoIfcZc6+zFOHuKSzvTUeHiqn46Q9kH+cxGQiAW+dxW1QO1LtqdLsljZXk3r6ni91anp7sow46DkaBRC7tN27xSyH5PkPpeclOqnkWZuFFOpkxM/wvJ49M09uKkYg/3zg+NI5amn57QJDtHq0HIAUsxpPYw+0LxeFVSJmpNegJIz9Ioq14lkLHrSrncwHb+8dHK7ccXZipYE/bl4kEZdPgVzgnBl8U1h3Fz+S5nmiNIGEZt+B+5J6P2ZqWuRod1QbvS1Uef8S0pVsc87HVYxSkYfWYJakuh54g8nh26ebvqD2oi/3ERF7lakdRUb+u6NO2ebsr1fnIwMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=kE/1ffCr2PsT/L/ulxGI7UqOOVPBs1vt8wNsJ3mhubM8+zv83o3xwSR6LgosGNbFltKaD0XZa8F5uAsyN9+oomBeCG/ChC0WIRMI8F84NenOHLrDbyfVxbQLq+LM16J/Jydx6ClG661CMTvq6LUNUtmlfCEi4x0PvHFMW/F0hs/Df7pDnPzK0OlnNVnKGQT64T4N3T5tNyXqqvodNGxHhNERFYvwDhxPiLt9Q0tswKpiyCqoumEDf85m+DD6hEiPcnn9yiXeb+I4rYLqXMhle9++rdy8BT9QuK75NBn7LOICzcaPpyXWjh9M3M2D3qFvUFRA+bPkUzLDjLOZ8xUYMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=pSsJNYj9HSyBhWLlyls+otVykfUCHA9ifkm+K0huU+DSdLclkDks3gwjGEfoeI+zZ0CB7mDSS3Pn+g2DHTMxYWSmhX+3pO2pGWVRDps5x/fSkFqPtBSNyJ0o1TjIjcR0stVEJ7lorvU9WtrRUUseAHtB+rhKheY1QTphV3zI9k8=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SA0PR04MB7212.namprd04.prod.outlook.com
 (2603:10b6:806:ef::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Mon, 25 Jan
 2021 14:02:42 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 14:02:42 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 04/10] block: simplify submit_bio_checks a bit
Thread-Topic: [PATCH 04/10] block: simplify submit_bio_checks a bit
Thread-Index: AQHW8jixUFjfNZP8d0CYJnK7p9X8jw==
Date:   Mon, 25 Jan 2021 14:02:42 +0000
Message-ID: <SN4PR0401MB35984AC9DFB6DD0A76E1D70D9BBD9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210124100241.1167849-1-hch@lst.de>
 <20210124100241.1167849-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 663f6028-63f4-4c21-dbfb-08d8c139e21e
x-ms-traffictypediagnostic: SA0PR04MB7212:
x-microsoft-antispam-prvs: <SA0PR04MB7212FF2C79CE723C2C66ED789BBD9@SA0PR04MB7212.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3z+t9zY+VtyQRVr6x2e728wxrgOx8Z1LU8v2ZTfhEyKJV5EJZa9wXklT+6x7v/Rpx06TnTCc5M7quAZqxbulQc2YjI+zwcBRAgs2aFAABXGIApSYD/YpkUUsBKvPsjH4CDe/meID2menHRrNVYTbg0ivQRi7ViWNjJ8cczsvBX5v8BiJ0St5f4hF/52lvSWk6X/Y5Ujov5hajxKPAXr5b+wEEzamhUScP5ekVhFbs27+V1FPi++DIyONVBU2p3FOF9xc7dv5QSzQDKZL9QV8x7KuaKH8vRrIeVdfOp67kmjypLaR1VwIjJp94jJ2aTgRx96v2o873FFBDswTaPWKgUnhjUffwKiuk3+wJ6TKKtdghTjH5uSlMiI2yF3sDdpwHByxZW4YJVpkeg7dkHK76w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(8936002)(26005)(8676002)(478600001)(66446008)(4270600006)(55016002)(4326008)(91956017)(76116006)(5660300002)(2906002)(19618925003)(316002)(33656002)(66556008)(9686003)(66946007)(71200400001)(52536014)(54906003)(7416002)(558084003)(6506007)(7696005)(86362001)(110136005)(64756008)(186003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?v+KZhFzsc9vL0pMjFctD/Kc+LQPY1mH7rMEVZCQxzqvGZHos/FBc5dt4qqmX?=
 =?us-ascii?Q?8G6urzTZDq99meQ25U7cWy3ck1Kh0weXZqD+PTERKuBiWX5v2wm6e1lObFdw?=
 =?us-ascii?Q?0pNulamlrVka219ThF+QGBZLaDqXWb/UOvuKdX1Mb5dcRVm6EY6ZainjG4Hi?=
 =?us-ascii?Q?fyeKwVY2HPq3ysq6MlKmth3p2nqyYPcK6ZjEcvrwujmrzg8QvwndUe4Y3JrI?=
 =?us-ascii?Q?4gwr4N6CLCcXB3mvr+onujNgvzuj9mkWNnseao52/uKc//zWfUaL7ip0FkPV?=
 =?us-ascii?Q?fI5678ALh0ITCAZXHFywPbfjAELzW7InbKkif374TqBVxRpPMHj91ZzsP8Qu?=
 =?us-ascii?Q?l9inPvKZUnhKdceb4uz82QD01+DSIo0NCVxeEr6u95PNW3D0fI2w2wR7pnmh?=
 =?us-ascii?Q?rcNFJsIGLy1+j/ZKkRx/gLhqD0zWzxAKliMO+q1pN7pqdqBA/g3T0NaGuu/v?=
 =?us-ascii?Q?2t04krV6s9HzBMZVLr/ApGAHaa8ZQyXAyi/Mwqi+WRonR8TZ7WtE1kqEDlUc?=
 =?us-ascii?Q?kzflIx+pRtB8qM5DNxYoqv2GJlk4vkw2Ht7NbGFlwffHO3zzjFkA03IsqB7T?=
 =?us-ascii?Q?Djoo7cPHPaFzZJbQ/qRP866AVIaSDgBPfwM0ZXwKPBf0RxthWa2/QbFgRPT8?=
 =?us-ascii?Q?lBxqFPkpEOU+GWE+u1xDYEXh+VSRhnver6pJ93Tnn0B8Gw82s6T/qpkRvM1W?=
 =?us-ascii?Q?esgQdO4GD69U79d0Iy9kma4vTcKODHLqDp/baeuvf00jQWMlFT9pO+6Wqvq9?=
 =?us-ascii?Q?TUcBzSpuVqyoJgjRGbaCSbI5CezgmnYNjPY9uFmOipDkRhWCXkaPvZGjYiFQ?=
 =?us-ascii?Q?SCuca5lbcZWBTfVX7EkdoVHjZXzI/KZOHXylvFor1feGxDpcu5SpFHs6vVrl?=
 =?us-ascii?Q?s9w+NHvAQFJcX5mYmGjuheoWfaq5/kNMsAwSza+V6T4Sijs4LQndUQMmB0q4?=
 =?us-ascii?Q?hx2p1AtDFDvg33W0HWSFtaIDw74DOdYR1GmxuyqRlf/PaACQ4VntjeknRCEk?=
 =?us-ascii?Q?NFpBu45Um8n+ullPbPdnCDlzweKPM3/TKiIFi+yGdC16DFB9q7H4zkINgGp1?=
 =?us-ascii?Q?P170RebQYjRvZMRCYUBR0J9LPoLOJA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663f6028-63f4-4c21-dbfb-08d8c139e21e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 14:02:42.3355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fecisb+yikKWREgRIW50+ya6NJK+A8bZWz/Eb5F1pseTJMZRl00cGDVDkHaUMTFuuJTLJWBXdzr5zQN863D87daA+RyOKYEuyk2QWI8UqMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7212
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
