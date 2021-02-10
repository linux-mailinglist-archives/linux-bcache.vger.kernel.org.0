Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1011D31709A
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 20:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhBJTus (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 14:50:48 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:25547 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbhBJTup (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 14:50:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612987452; x=1644523452;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=vvqItAyjF526HTQ4ZDa7KS8hezHf4OTDiWwJBhnmDn4=;
  b=gZ0Fc5ACwqkEYaIz0obvifzP2kmwQ0WRXqJN55BsbYzHJf3ilHngngVZ
   KSMn802FVPl0UVBXYnijZ9vEltXN/zE7KwBo0tzDbhmIih0ze0RM/j6L2
   S4KmOrmPh9azAXutWDHce78F3DPxkuzL0mnkux2aYs2VHO6PHGFpwyGlz
   qCe9om6wV/usPVfGrgads9r9+2nadGgPGcMWUbRzSmb5xDa8AZ0RKn16u
   r8JJ+Py6vd+6XsCK7F19Gca+OIK7LGZr8jVC0v+AA/NL49bn7A/sATU3Y
   CpxYp5rqkceWJmjDq98B1nHHH5Oy+kULhSGPKHcqLI3oyT1caA+JqD7p1
   Q==;
IronPort-SDR: STKUWrPBuMWkhd/79XYuTII3QxRV4meg+2dq9ZMMH/F8nhvX1d1QCOJJHAljI+lclVFpJbqVCX
 VqtuNacVrnF8/+eN4FKbPlJAGvWD7xSbRvEtxLH2Z8Sp8BKCsSzQs6x8+f9JsmNtFAm9nqdBIj
 NeJJxUJEPYkDXvHMQSwsi6qA8S2/eYbMPwaWS5Nzky9/05i6ROOP45sty7+m4J7tdNVG9r+x7I
 HSkCOJiFd8vBw0UCnDDcpehuRiI2tbUtTw8nUDhk7UZ19PPcAe7NhHASoc+as31x7PWJg2ITLg
 9A0=
X-IronPort-AV: E=Sophos;i="5.81,169,1610380800"; 
   d="scan'208";a="263810532"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2021 04:02:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1RshVrNkWi9WvTtGSgWTmHvkHTHyaDKbLhQPTgUTlxlT9KCAeLgLMek/2AU3ATHWPXg+vD9Qf+p9WE8dxxxLDEhW/SqWtBa4xBwWKl4IxU4vd7B0tCSyfHlfe5wjOU8yqIjNktCvnR5ER6/uTEDziXrMYlG7/07W+M817Y6BOiapEGrFdoCmAcWNTIuRgfFiu5z1Bi2BRn1zM8dnfiE631cidxUdt+GKJcNBrCYp4r0uKUq84jb+/sTskl3+2Qkh+6h5SGCFv14YN2lxTeoTlU31l63WrWwHiWqtolxXWUnaWfZqEozBNR/rZ0Vl0231KFMjDlnj+5t8v+y38RwIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvqItAyjF526HTQ4ZDa7KS8hezHf4OTDiWwJBhnmDn4=;
 b=hZfKUqBnuIYieFEOSy1YW2yOlY0nc7NVaWnpanO2i0eF4uD04LDrN5FoGVQoaFum+ve1CnXQd2yWkoRIr5Sku4CgvDM94jyD4Yis9WW89ji6WWw0Vm01JEawiook3jdkYvIqHfQ/gPk07ririqNnZspSp51qfSx+lUSEuT9O7wewFvxjISI0sMvkgkC8VNnK7Qn2JS6vXvZR1oTYr45xEz1wmGA8bs9SajDTjHTPzLKNufdiKWT3CikiNh62oLeFvaw1YAGpiGzn1vfXRDXS3X5b6VUgpLK3mtXpGLvuIxT9Gc8GnLNqrbh48IF0f6+/WjRamK0s3a6V6pNjSbsPBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvqItAyjF526HTQ4ZDa7KS8hezHf4OTDiWwJBhnmDn4=;
 b=AdYCxPNsPgoBDy2KQ47ns6WFo49q/anw9HCwF+oDoxIRD7uufBFrYKpgbKW1xgeMVghaCPEK5QPxjy6o4ePNjjoS7A7M+fNtAB7JbXoFIKFid5Su+Q/OatmE4wvRJ2MH/viZPM7PpAkGMVGzn23Oc3cEWaXzfpcK+xZTkdO8Ai4=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6421.namprd04.prod.outlook.com (2603:10b6:a03:1e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 10 Feb
 2021 19:49:36 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Wed, 10 Feb 2021
 19:49:36 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 3/4] bcache: unify code comments style in nvm-pages.c
Thread-Topic: [PATCH 3/4] bcache: unify code comments style in nvm-pages.c
Thread-Index: AQHW/7UoAmV84i5mDkC6LMVzZ/k8Qw==
Date:   Wed, 10 Feb 2021 19:49:36 +0000
Message-ID: <BYAPR04MB49658895DC1CB49B8228B322868D9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210210135657.35284-1-colyli@suse.de>
 <20210210135657.35284-3-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d9d5ec9a-d632-4e66-a1ee-08d8cdfcff08
x-ms-traffictypediagnostic: BY5PR04MB6421:
x-microsoft-antispam-prvs: <BY5PR04MB6421A6E87E21E754D61471D2868D9@BY5PR04MB6421.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:439;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i2T/ugR+3C4O03PTU8L5/kU1De1JIpkHj1RaCg6AkAjo1HGaq9rQxfOu7hD3NB/cwZ5syPHyWeqzGgTuZZ2qVYNM59k6EOwiSYAbBpI0IDUbyLAM2eP5AyEl9KsgbMJ2wKlgavmXbBcX5moWp/lz8y9t1hWtly+HryuUYDzBJnws62cHArLCte9JK34DXKKSeI6/yucz3VzL65rXJDkM/1Zcc2GbtyOJDX+F9E3o0pd1Rbl18hlFdo3qkyw7gteEwk613H3mRccaG0Bltu6UFQB/L138UJCWUx21pfYuFJHK2gXozHNCohPFLVk33A+nKmSaQk0LvCCj+0j3Me+6n89OtEDD+0Tf83e+DwO01RAJnI0y5/GOxbr5zfmeXLtQnsKd5qcsiko2GZCCpGNSBedOye1VcNiffwbW45+e2sZnkyNpdaV+f/G2n6IjIwSGehQJpqpjcOhos+47qm/1+EgkJ/GwwB7q0Xfyl37Tlkf8AB/DQmqIQr4OvsvkWvuuEZCLOhvYo1hDVjDt5J4/XQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(558084003)(76116006)(6506007)(9686003)(7696005)(186003)(53546011)(52536014)(55016002)(4326008)(26005)(478600001)(2906002)(316002)(5660300002)(110136005)(64756008)(66446008)(66476007)(8936002)(66946007)(66556008)(8676002)(86362001)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WjR8aAjL8xpuz4UFNKAaOgnofK0Lo+DftdOFTF52pnO3n1v4WmV8Clq0Oaau?=
 =?us-ascii?Q?y0wloB/ZjqxLRsclruG6fAbf4vuK0CSbMdgF3du/mXSG77Pa3vE5iG4IBnXN?=
 =?us-ascii?Q?2R1QnDv8SFJB3wpvTeg8bgzsmnRVPEAsSivi1BJcwuQ8YAhM5sDwGky77DPo?=
 =?us-ascii?Q?TQ7MCizDtnuhiCngOcKtFsoIweeq7E9+UnSQJH01s49ozhJ7SlekURWQ6udK?=
 =?us-ascii?Q?YsRX0AYPjLlz96Lm74OspnDdYvCtiWSbcYZprjjrp17Fn54Z5G59J6aZgK/W?=
 =?us-ascii?Q?ptCnWkTwo5J8xjUzaOnuWom4np22HG0updQbrG6fsfNFceZ3g8q/J5mx/ML3?=
 =?us-ascii?Q?/fAEHVjTiCu3rxWVxB7csPtYePRUe1un6gaQ9HLOEAee6ulpOlA/6BjHnICM?=
 =?us-ascii?Q?2N/Q54NT7WDxtVfZS27X3Ih3uywOplg1/GOK3gLOJVyN9XIhmGQ2ktt4pedo?=
 =?us-ascii?Q?dRvLcx/IY7RDlcKHGW5UY8ejkyh9v+zOswt5//KdrmO089sxp96dSLgjaajR?=
 =?us-ascii?Q?m8Y+YpOcataeTfkYmz3clT4vKR+QLx5MsK3dPECEjTiWlghIFxSpMijZ9rkJ?=
 =?us-ascii?Q?sMfhAIvlIH49nRKHXQrwl3WD10HgJG3EewX+93RIM8cNJw4UYrENVzkVcSWU?=
 =?us-ascii?Q?iufBcuYizF0VgaQUkODyscYrcdG10njeMUc6jODqJKhq2rzhcmDIpdhguW+W?=
 =?us-ascii?Q?AoLBkL4JrvX87vp0jHQd3qr2PkZLheRartWP1OXmhFQ9aJeF/LoSOIgnO2O4?=
 =?us-ascii?Q?zSyHEx1b7dTAgYcv1POfLQuoUTr/WihBhCM2Oj/LTzb7W/9c4e2LXy6SBNGo?=
 =?us-ascii?Q?Hxe5m2SFATrSrEHBEvSWFFeFsm0AZqd2+2Ej3FTwU4aE1icFa+YNulu0FH/E?=
 =?us-ascii?Q?/agrWBFfNTrinfYV4erx1cp3Ij00AcrUbrfs9ZexZ/Y4vc12O3ihZeXe85Tl?=
 =?us-ascii?Q?ADgl+lBbdIh+Rfs4I0SQcl43SYnxiV5Hc1uwW8NT6PbajyO5XMkn5ZVP+hEf?=
 =?us-ascii?Q?31+M+Zr8iftBuztTr0jdNRf1F89L1Pjhg05Upu4AiBswiuws3HfC7575CYSa?=
 =?us-ascii?Q?AEUrP89N+nP26xu9ARK+sqEptjDRX7kiUTFz1MvUdfd4hxDDPNLBijuUcDpq?=
 =?us-ascii?Q?qpOoQW578asAzEiX0203L255dYZMDmlqJtaic/yIFvkMEFlqUJF1ckSI+LAP?=
 =?us-ascii?Q?a8AfnzsvmFbOT7niQCc06ryhj3yv/AaDJSlH04I9yTSO9mYDlcQ/J/Ugz0/P?=
 =?us-ascii?Q?OVIUcTmliDlk0QacVVVs69rCE5P1ZNMN2tb5M7zTwKSkD82Xz+3/YJaTU0lp?=
 =?us-ascii?Q?O/Nqj502ijwkdh48xm4bShWBOvhaAVqBqe8wlW1Ulf9DKw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d5ec9a-d632-4e66-a1ee-08d8cdfcff08
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 19:49:36.6314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ihurzHGgYfpt2Q+CuMPtqmq99shiyiqOm8nVuDHFMru7zEoS4lBnl8rtpRH6YXyqsxQVaxwlHnHBmsK0nxmH61F6R2vmrm3398ZtfFANm0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6421
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/10/21 06:00, Coly Li wrote:=0A=
> Make nvm-pages.c follow code comments style of other bcache code.=0A=
>=0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
