Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C9D3170AF
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 20:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhBJTy2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 14:54:28 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:23812 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbhBJTyJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 14:54:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612986849; x=1644522849;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=T309dXnmQqAzwl5QpfUDRI1cRIN9bixqLWfnhQg9Hkc=;
  b=STc7j8z1hGBzhn070YvEwalUrVF3PplxOZE3+oO+Cl+L4q4Bn00nRcIq
   gmIM7BzMdIIPNHWx8pDJmXOXExlVTOnGVTa5+yq3v/03h9W3aArRYa0Y1
   xi+E+D/UYxVfl//4XsFmcOL8oTD6d7a59w8wqQH/kHtgdfgjobTlBXOZv
   PwMFRSVzTS1VZ/QnTQdB5pls53rf5TqtNWmIfUm/Bfe9wcUIWkvfz1YIT
   Y6gL8kKClSxDbKm6aR2QXDBng6enkf5k5ccaiXyW92+MXYp13ZX1K2zWe
   /dHkHz44/GUpCawOsvwkXez7lRMEZsIDGYfgY/fHSk4WdIAPq9ZNAFhDE
   g==;
IronPort-SDR: u/MEIuqu24uVV5lQwdJGXYVdvoZe0IjP4H1p1kf9ZX0ULznhtx6r9zQdIChj3YkZC6eOy67Z/t
 L7wv5pV+h6ENOTy7WTtroguyal+geB/K1E9icO5qNMzv64n5eBp3mOqmD6NT1gcGUaD68e1w4q
 ie/qcwrfNyyqyBWldOXjRHSUFAqH8+PbEjoKEKAxRU05nwbLJwr/r9G/WW3LEU+OBTiob8rvmc
 g6rJtnLXOMSkWKBBFPjfl4tXAuvg4jhx97Az9mmoNMlYAPGsGwUDakk0UlrCh0a/cmquiLboD0
 glc=
X-IronPort-AV: E=Sophos;i="5.81,169,1610380800"; 
   d="scan'208";a="159699951"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2021 03:52:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlpyU7kyWArtSxFx0aeaG1WoZRCHJC/ryGjoykXdi4B1PvWO7jUT+C3SbcYdJ5MD/OoGTdXM5lquF3Y/gKRpcbLri9QRvtg/oNuMoDAkCbvn395ZRRAYaBW/k2pKStpLuOXkq+RLsQw2AfBHUPYAsSma8LVRHtSNEg5L3cCj9T/xk4azXyWFUDkJg5WqIhlJXWoFsHh0b2x7HEQuk2BsukSspKo0CJ/hVuSnvAm/aubrM9XjPgpchKOUmlPThv6tYMBMjgQDDMchFsVIYNL0BPDrWrs1mo7ldz4P/rAHETXtgYn5zpr1MyPzTT1PdZvACUdpP1NFjXUDrxOs8V8UXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T309dXnmQqAzwl5QpfUDRI1cRIN9bixqLWfnhQg9Hkc=;
 b=Z6vmwq1UoJQY15Gf8KWfTdmGqJSVCs4RJHvmnIKByJu9qahdlDOsgWd3BB8zwRQkYCibzDjVbjLfPkElwaVLktl/XuBRqPVQpD+mMQ1mckt3H8MI9ftZ9VNP/QMOkEETBIYXttkPMplbQTTA81VJJZoyhk068WUqfDZpbvGg7RcGRayh1WoY//dJyAc5cShLyai84J5D0dLNrO0oJWYuu0tOPBXYwgSeepcQjJ41dJwrvFBheZdit7/RCeZY36r1RZfSZdM357ImA8eWeu8Bg0ILVJtibala5lzZ9OXAZJSC+ESggO5BNT0kEYlSQtpM1JxVcBkrgKQnzA6/Z1A45A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T309dXnmQqAzwl5QpfUDRI1cRIN9bixqLWfnhQg9Hkc=;
 b=YKTMm9q8zmHuHfXhGeCFrDdvyDIXTBahHuBCNaH4TdtHBf+rws8wDvvjje4th/LkZVdFUgMIG3gYrTyPPT2Q8TGrrVLjRkBwIhmurvp/C3lyGOincA0d7pSLsS1DKzqaOGce9zyO9I0ccDcFRbXtOGyv0flnNfeHe4QGQd8psGE=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5333.namprd04.prod.outlook.com (2603:10b6:a03:c2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 10 Feb
 2021 19:52:56 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Wed, 10 Feb 2021
 19:52:56 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/4] bcache: correct return value in
 register_nvdimm_meta()
Thread-Topic: [PATCH 1/4] bcache: correct return value in
 register_nvdimm_meta()
Thread-Index: AQHW/7UkpSP79pQEokmbZrbEaZ2Qyg==
Date:   Wed, 10 Feb 2021 19:52:55 +0000
Message-ID: <BYAPR04MB49652239677DD0690B61A9DE868D9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210210135657.35284-1-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 25e6a6ea-07fb-4383-9a18-08d8cdfd75e3
x-ms-traffictypediagnostic: BYAPR04MB5333:
x-microsoft-antispam-prvs: <BYAPR04MB5333EA278BDA8C000ED3FA9E868D9@BYAPR04MB5333.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6ZSApOq91t2QrC8dMwbxg4Wuxro8a2wN6chtsB+/StsuLnpjsEt34MigPehJtrUhknd0nmnuXeNpu4J8vf40671ZKTWB5VrmbKsULNsx6K7zR/bMcxkQCd8Y0BBM9C0oXmGSsiKhWTHdrKBBFqw4aqdquOuiEqSWF9/qCK9gwUJTw85cloMswy1bPj0zeMG5ctSWm54jfZGsABzIz0y38/MiKp9vmCkqQmwkHgA0HnSnK8/eq77p0ydnR4PPRYGR7LgQ1K2+OrwJOev3NDHv9Pt2i63CObKVwe5ViIsw/+85OIhzT5Kjz9LLH5BX1oVY7kkW158sSyE6Y2ADN518YE8qz2MjYG7BvXNGSvhh1ZgJqClOTh7Orhy3pbaYF7flH1kzpKQSh0TSYEUl3V8S+FFJ+5S5aTt0QjGdaNP/C1csZGZO1jTjkuyTDdJvwZsOEcEx6kAn1SKMUy/XzUXP9CWSD9FnQixbxWdKP8bgoW+b7jSqbfLP4j21U+neAKXPIVzgH5h2K9qc9RsGvSMwKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(4326008)(8676002)(2906002)(33656002)(316002)(6506007)(9686003)(478600001)(54906003)(71200400001)(76116006)(66946007)(55016002)(53546011)(186003)(26005)(66556008)(7696005)(64756008)(110136005)(4744005)(8936002)(66476007)(66446008)(5660300002)(86362001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LdVyV//1dWixKPGxfCiAP9ltLRKBgxvrHxPyibSHP79atgl5EEbGJT79ggPd?=
 =?us-ascii?Q?yGRiRrwI+R5gS9sULbyaM3lhIU7EMAYznfrrWpIrjCEaqQfeh/9iCI3ByfrM?=
 =?us-ascii?Q?RpXLe/gdm0nMb8Uw69hKMCp4TZQev0U6y1myVK7CZrCigTwBp/lcFRPXDvrw?=
 =?us-ascii?Q?NDZ3bmKLOIMVteZToh/XH72rhk8U5EBmcaooAaFb5bXOi9pee8mkx9F+zHx8?=
 =?us-ascii?Q?/c2PuGXE+2ImeAaeFNmVw+ysrE48a+33mEy49vS1FtLm+V8m3CzzodMPMnFq?=
 =?us-ascii?Q?1F4r/gfuvtZMYjEjTXplDolarA6CbMMDnu1ErNWfvIt2DwX2XoEBIyNgIGDu?=
 =?us-ascii?Q?yqdlSSh5oX0Vmuf1CTxU94fp22XKg5dF83BgamZ58+OgwUuNmO1M53OKieJ+?=
 =?us-ascii?Q?32SrggSrCufhmKQyKN5KRfulcyFdkjqARcAoJHSXZYzZR5PxYg2OLCoJEEUu?=
 =?us-ascii?Q?7GGNspoNDcRufBWpD/+Q8MkYoESa415dAr8m1HFdKiVj0KN0Ueue0aAkEstn?=
 =?us-ascii?Q?Qu7GiRFsDXiK5LQ0UF3667aABwSEmLQwcwKrTWQs0BxLDmYZ9+2QM+zrfhb5?=
 =?us-ascii?Q?hxVTWYZhyubHAehMkIrhKQYRWYaqSJ1/gSWBzIkxHvV3NTGiV+rRewgtMRYg?=
 =?us-ascii?Q?C+Xs9vSATWGMPnqnPuhEGqB/tX8JqlZN5X80oWxzS71f1LWWAXzAKR5UPtkD?=
 =?us-ascii?Q?6ADMfFDzKgOVb2Kav1l9PIyBlVuXwyzs+wBbL7TsMro3FdaS5Z/p2WzxmH4F?=
 =?us-ascii?Q?EaRhV40aJQnKwF7lmBPev/EXHQ1Iy6Qd6mE8uAzon7EQUO2q8KCRfvS7tbC/?=
 =?us-ascii?Q?KA9A5P5RxeTeuoMk2SNIaA15Mh+sug5VShwnNyFGL21uWtPu/AdWfWICddHj?=
 =?us-ascii?Q?/yN6ENC/J0tUtKO+OBDosRJU8zMyXX3vW4ETG+j/cCbvPhF5Uofnmwg6opjE?=
 =?us-ascii?Q?gO52EyzzF1GQ/8oSW7UhloImeBv04fa4rdybla82Pzf0nwKd30Iy2jac7PF0?=
 =?us-ascii?Q?ipZ9xqdYsb8pjD+P/IXpFyeDooRPyDcaPZT1Hst7Q8QvvlHM62+gcnkf8nTz?=
 =?us-ascii?Q?TrvrRV0R3CfH8ja0Q3HELGSWIYeXx8GyKCJs7526JGJ08yev7JGCD1xtelOn?=
 =?us-ascii?Q?FikDATGhwm0Q8EREkPgDmS9AHlXCQAvO59G8eM1Wk9gNW1MHcsW0ZrNsd8xM?=
 =?us-ascii?Q?0y3n76u703QINXS/6hemt5Fr5cRsMmtGfXuRE9PxKvxkuimbtMslzWFgDgvy?=
 =?us-ascii?Q?BbIue0sDxrf0s2Mr554nMADUZN20PN8h/1Np7Net0Odl7tbpSnNxXqmCCrFG?=
 =?us-ascii?Q?b0xGmkbaVLe1qwOTtVTNu6FhTCwxzaGV9/eDoVrFcfJFfA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e6a6ea-07fb-4383-9a18-08d8cdfd75e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 19:52:55.9736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dw41cCNEfuFBF1bKP8ozGR/D6zP5frf+f0jqGmyx3x5Ca5sGLRxTQqcEZoHDPqboob4yp63kk+Ol6DVKSjd8p+BZz7dtHqMJwzfCPxelG84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5333
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/10/21 06:00, Coly Li wrote:=0A=
> 'ret' should be used a return value, thi patch fixes this error.=0A=
How about following commit log ?=0A=
=0A=
The local variable should be used to return right error code from the=0A=
register_nvdimm_meta() instead of size variable.=0A=
=0A=
> Reported-by: kernel test robot <lkp@intel.com>=0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> ---=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
