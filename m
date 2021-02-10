Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375AA31709E
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 20:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhBJTv3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 14:51:29 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19199 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbhBJTvZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 14:51:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612986685; x=1644522685;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=307md6JnKI1AULaC/7NmD0SyCRImgxc8I9LkRFarax8=;
  b=qLmLRVP6lKNLohnARTQnI0/haPgPvhrzvqNBMZOG83G+XmQwTfCxmzXX
   W1Ze96lSezm4qdIuB3COtZsFzlvNz23LVHJYGeJ/V1htRRDm/+N3C8SE1
   M6r++2Q89pUUAR9N6rTqSJwT+dZWifEs1IkLZrrcBBbvj/e9SUYvV/Uwp
   arcDp4+BZz+Uzma0CZXWjBhsIWzrpCeXDM3w3VNESfPtOmnrGK8brj2F3
   edtLl1AmnRFW1q/Q4Q/FzvH6Rlhrr6Sa2TlXOQRqtTAoO7CjqevUfnP+c
   r+Dz6ljUQA1y7TscjvQScUYSgNUEC+Qe1I0ygnLzkoc8ZABFlErvHoDqW
   g==;
IronPort-SDR: unYMtBXugyrhzmIpPPRtM4STh4mDZrm9unP14yZNtHucYggWaev/zs4HorkDZemMhVgBFwVttC
 kgw9q/Okq95b0Ps3c874RU00oGx9K7nWATa3EyLaMQN4kImAMN9JZhZby4Fp7APPw7NGUTA5nO
 bXDxinygSgfEWpG8xDfocoXnAbwZuYMY87tdfv8sGeF0d/0Ue7JbJPoEOYWwU4p1eilG1sjQ6/
 xEUlWTPYpuaEg3srpOFt1Y8GYNnhdTD4C/CLdzW+omokyrhzWLQ5B8sdUltyobXVJPNATR15Ft
 wWc=
X-IronPort-AV: E=Sophos;i="5.81,169,1610380800"; 
   d="scan'208";a="164162443"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2021 03:50:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+rU+CedIEXPXm+NbXankCQ7ULWJiIYib4HK6z9zXfiOO1CLvEWxAE4Du9wBTQ0p47mxAdK/zZKI1r3qu7HwVQ3TApukqYtoGwFs1LGJFQjqigERS1V7wPtuLL6hfmemstEX4GRWR/2iadgU0sLrrCqce5NcdBmoKi9N9i9iF5ChM7UNZ/4/LXH3Eo7WKV41z4J3YtqDzWYe3IJ01lhbjv8Q3UIOsZEAPtDP6vT77rQheN2rtH6C/hflv9UCyAHYx4TYDtLYXkAYMQqLFxE3lCB2Hss1FqcDHUuWpKgptzUEk0OyXfFFWoGxjWnGVWqBDDSgEbOmTY5cmtkIPiIdrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=307md6JnKI1AULaC/7NmD0SyCRImgxc8I9LkRFarax8=;
 b=VKvOyo3FCmXhkQQlwFSxc8eg9v1xRdK6wxVtseUhf1qV0LifuMaPFU0h9b31iIRAduXBg75P1HOSaz47I7Nv2omE1oBpM/9pfhxuuPRZ4t/uZiZZptxx5hQRpyTJBQGOWORdxqp3q9cAEUzXR1Zw+YYYwgKsaP8UPXTj8R6f5PO45sH4tU4/7sqeGxummjT1tI8l8EZkTTmLwi7WYr1/+dAccKLkYdTKqhVu2ER8jUmouZI75G7izLFaPyehjbpwKwsTbuW6u4rENfaFFEoYF6vx/ku2tGUBINA5Bc/xguv8JJrjd2slKB8PCwodDBQzUwxYy1Bv2pEiBK0hR3F6oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=307md6JnKI1AULaC/7NmD0SyCRImgxc8I9LkRFarax8=;
 b=KG8rN959znwHsJTKGMBV0h0i2LPGoZIFtgKAyL5A/1zr1JtuiL5u0vm6VL04rgbWK5ASaW8dk5radcFB3WaI29uupSeAQPxFxBP9iJN7Utf+LKihUghVxHY+RnV31WHo43Bce3qJatAwNDuRLIkLkZHVHrJ0AlGlFV/ZqWBoAPA=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5528.namprd04.prod.outlook.com (2603:10b6:a03:ed::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 19:50:17 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Wed, 10 Feb 2021
 19:50:17 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: Re: [PATCH 2/4] bcache: use div_u64() in init_owner_info()
Thread-Topic: [PATCH 2/4] bcache: use div_u64() in init_owner_info()
Thread-Index: AQHW/7UlSVQoVz9ITU6EoI/cbFw2Tg==
Date:   Wed, 10 Feb 2021 19:50:17 +0000
Message-ID: <BYAPR04MB4965637C8B0E81FD3BE3BB03868D9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210210135657.35284-1-colyli@suse.de>
 <20210210135657.35284-2-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c6498a22-52de-4713-5838-08d8cdfd176b
x-ms-traffictypediagnostic: BYAPR04MB5528:
x-microsoft-antispam-prvs: <BYAPR04MB55282EAB8EED789B4F59256A868D9@BYAPR04MB5528.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tu3R6Zab+DKdce+JtzICjG8USyOjChMxSecS9sPY4TmTGzZpjYtDi7kCHe/0uWuvd5nFEnPTFPV/tiY+p5L3XqFSZJ9f/X0rpLK38E6irqYSzpuN3BiwXtdXs7Gs0Sf/Q31QRLtolqcU1sZ1dQKCpxMxyatsJH5nPhB5+dhWVtjhGaa3TAICO1ZxQ6fRfpPFeA7vcQb9PY+Agh/8yPzhPeEUbtwyLgGiKvzPP9oghBFfoYodSTVW0oFYfQmG4S07PGz294UUZWjeRYXhiAf1Yx9rtqRT+mtHLu69FL1UeQuec+xtvxhAR5l0M9+LvW1cLkF0ejZyKzuGmJn/P90LFMBY08ViLNh3bxGKrXXhqBgHGiPEsWF39ereeH9pQ/N4/Ze/U4zckez1bIsfYW0lnyz5oAyx0c4EfVBB/JlfT/126gTBaXrNVE/Zbz8Sy9r9mIWBklQMcPadi577DzTKEuYCJ+Ab8gijFzHALptIsK6Y6j2M+aUgyczI7Ffe8UV00YQJp6r59OrLCAkPGno3sA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(5660300002)(7696005)(86362001)(478600001)(26005)(186003)(4744005)(9686003)(8936002)(55016002)(316002)(66946007)(66556008)(54906003)(66476007)(52536014)(6506007)(53546011)(71200400001)(8676002)(2906002)(4326008)(64756008)(76116006)(110136005)(66446008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vcTICiRjzmWedBVEJgEKNbapBnZGW7CR3FL139frmPf7QhhXCT5qHSMAfu7Z?=
 =?us-ascii?Q?sbrgJfQUmR4UKZGwmffzk9oKOPRATYy0Ya8B1gebufgABrrMg12Okb6wnirA?=
 =?us-ascii?Q?Wfik1ZBR0rTP3ijlC/RhEt8C47nq6BhKe+i1qekFOQaVWWX8J+GyB0AFxGsc?=
 =?us-ascii?Q?5xnKS/yG+qfzVKb3VvqEy/uqbSIpgDBp60iV7YRsYcZz6ZvuXtvSIGK9RdPg?=
 =?us-ascii?Q?4sm+B1nH11KmRRu3TjmJPjY157HZQJlFLAhkIGrnOwQapXiV1kv6mL6ca+4f?=
 =?us-ascii?Q?P81eRHsyOZtbc81FwNQvu5vrqLRuS1VN6vkFrscwy5YKZdcUnXhlvp1pJQ9S?=
 =?us-ascii?Q?ZKLmfzR+yg8ycGEon+TTVDltgi2xqDHl/k8KdNwaLyg3qkhPH69Pe5azEK1j?=
 =?us-ascii?Q?Rs1Vu8Vkqj2B/KDJ/pZCwTTXnryi1bZzVH2SEFrAFtjyA9cvyWv2+nDWLoGT?=
 =?us-ascii?Q?srZivxrpbQrz8RWYqRzx1hoZCexCzbDuFChb8Zfug+/rtG9CBfqaDvyIl+g2?=
 =?us-ascii?Q?JKFX72LeH1iFTEesWqxmED/KCXc7zKhBviLanu0mX16BfHJ4UXQHhu7jHsCv?=
 =?us-ascii?Q?HAhlH1TO1pQgJd2uiwJPY0+sh27QumzocsqCGSuYDLwhIAuwSnotRpLhzy97?=
 =?us-ascii?Q?UPy+HvPe8/qV9ewVUSZyzo/u1Uv44HswkIxiNHE1b4uZG+kdcLyyBGcZ0H9b?=
 =?us-ascii?Q?Tl1x1F3+fnq7WhqMRy5X7/HOXz7fUS5f3K19zeB3UYhybJcTj5MU/R/DJ13c?=
 =?us-ascii?Q?wZBK9ndBWsS1tvA4SXKYCMd5OHIo1PbJZYxQwFgXJ+0gDRaC0yDhXyhKNh9c?=
 =?us-ascii?Q?Ynsn7o4n+ZxPUEs15OKxx6/jb4fcHBkCq01cmX72rPrXKHHkACkA5I8kX9W6?=
 =?us-ascii?Q?3a+3B7zsroq8zK7gs6JQ+IA3HfMsRzPDg9PWcHALtwGWGwqrGFYdkqpvsHOM?=
 =?us-ascii?Q?CQh7ev6EQtDdWNlny8fguNDvBt4rombFrfN5FuyLewfIbBlxQyq4c4KcOYKf?=
 =?us-ascii?Q?0a6typ09nN1+x6JMNIfLinc7ThyPAmeej1L2wg3tGQT4xLDmkTjQaF2a2Itf?=
 =?us-ascii?Q?w7SyhPMyifb5x0tpCmkyGSx/MZ4xM3dTYeBPk6+L+rDouR5KHC4nnRUTYDiF?=
 =?us-ascii?Q?Pca69Iy6oQquxixPdIGK0BKqRLr1LPAMNgleOP5/irc8IlzihpV9GjUvWiZE?=
 =?us-ascii?Q?1sPF3LG6VBjktlTZqwwUdip2fNbtNM14DRxaYfig9vFnaFW4XWU9v/IpktAk?=
 =?us-ascii?Q?2huRnm7Ymn4RTYce2Bp6kj102GCnQ+LYSJ+Rp0ksWrxcS0amj0FOv/PF+0KC?=
 =?us-ascii?Q?8J8rsxL4oFiR1OaWc2gWfkbZsSeTpWPCo8tNsx7bDe1reg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6498a22-52de-4713-5838-08d8cdfd176b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 19:50:17.5326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dnRuJ0bJLIIhDUSm+9zVoaIE92wrPz+/A9WZacXOs86BPXfN68Jo7zvOYvrQZ68sW8C4WVCPKQpMgqFE++cPNoP9YdqVCGMZbqqz1VO67OM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5528
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/10/21 06:00, Coly Li wrote:=0A=
> Kernel test robot reports the build-in u64/u32 in init_owner_info()=0A=
> doesn't work for m68k arch, the explict div_u64() should be used.=0A=
>=0A=
> This patch explicit uses div_u64() to do the u64/u32 division on=0A=
> 32bit m68k arch.=0A=
>=0A=
> Reported-by: kernel test robot <lkp@intel.com>=0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Jianpeng Ma <jianpeng.ma@intel.com>=0A=
> Cc: Qiaowei Ren <qiaowei.ren@intel.com>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
