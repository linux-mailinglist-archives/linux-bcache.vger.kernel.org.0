Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DEF1E05BB
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 06:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgEYEBl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 May 2020 00:01:41 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:14629 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgEYEBk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 00:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590379300; x=1621915300;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=DTBPJh3pXlMvguBuNEBsYyTITbci2kbWR8hAh2H+J2g=;
  b=PNst+egjblo9tSNWQS2zvpZ//Zhmf6ksBGzwsemjOIcVUfVlv8GQi1BU
   zoF0Ye7wkoxqybc0c9l8oAY75z3Gd5d0XwWn3B9dSqvmddrbS/a+O/0f0
   TcPi71LahjPQXRYuWBHB22rCGWhla62FC5IHr4Kw/0lcegHTKoT+f37Bl
   LcIjRxOIjxRXVQhR3/gCO/xgdRMqrTbdNTy/z7qKIu37ljHn0aAkPd0B/
   9HL4KNI6la+d77Je50h03Z9lNbTss6jrrvxg6SdE+wGf1oL5okUcwGayz
   NKppTNArTKrR+RNMM0CS89OPQ0BnLg/wcw5qVl9Cfm/3vH2LJqcI/i+NP
   g==;
IronPort-SDR: olLr8GnwGmmZ/WzQW4nXGtmF5cscdsal3pGy9vwVI56rzycC7Wudjm4HtUqsjrpawVTgtqDHqC
 Myanr4XthJqpoIvsrAxF8q9eUWn0vfx8dexLpabESU5dro8VcnSDgOCLF4ryY93KjyGh53Us76
 biB4aOQcTOKO6KRcNwb90H+2aoHpWJM7QeEVx9X6FLVUpJgD+tPC1NKKG1Gu5+PuYbT6I1bQPY
 ANzwVQsbosrT8nO7QWPkBrbpnpCw6Lynk91ya4eajxPMKRfKDv1TSJc+x3BY6xK5H6eBRKejys
 HYU=
X-IronPort-AV: E=Sophos;i="5.73,432,1583164800"; 
   d="scan'208";a="138437988"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2020 12:01:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kp4nXH+VAoNYVib3kZGPTvYNcckrogz0RM9cCaY12556e011DHwNm2y9hPvHorWA2X3RnOo8buzC6LJUBj92qcD/Rqjw/8ChkKFXQpnEJAp3KxMIh047fKVoMaLee0KY5BrYjKhmadm0B6SbnPak9RrufEelmFWdiaTOoQfXLVY5eFglTNf+KW3w6rm2PJ33SWVqKflajmghSWnHhp83DjuKBLT5SNQViXeBGoaZ/AY7btmcROA9aR7NkHvwXPKbtV5I1pV2HAQxy2U8xARBvhwHgXOu/PQLniYyF7S6X7EWA5bn/vkZkHW5w8wGatXNmZKrE3jTt88gl3mTacP5Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30dYtOTkx2g6vIV3v6BNV41lX5UM8ShfU5nzqfO0djE=;
 b=Wx+vhSXasaaJgAs9PANYm9INasWkr2HjKMNUk0Qw77+5YGzhKTbevm/XWmT4tTpY0waGG/6WU8HxGz+OK7rFgeWCytVF0Dx6bMIBlkobuDMLoiqg/9ufltmapRezeBW4+exolXrTl8WrK0PxcGN+4x4JheMuZBYRWRu4Dz+tdEQ6tSsWY4UU0nZYCsCZ0DZRw91bbQd/1/1S+yXzDMEiWO8HIwXnUZHp2wTaeZ7pgQi1i6drZZyrKowa9CrhdjZcU5VPa9sPZZI/gj3pjc7dl7mdlbbSPDlNdSw4+qNpaSCvdOnRrjsmmhBvhBjiKQQKgXrB7i9vmeJa49DWF9pzrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30dYtOTkx2g6vIV3v6BNV41lX5UM8ShfU5nzqfO0djE=;
 b=j8DuKP+r/yLvI5Lr4v/mfcYZPty0belG1IZV+0vS8AmR134+dsR8yknLOJe2q1Q8waUyC/Jwe2EE/iEXHw2hMpOc4F6CIDCek3SvQHnc3fxAgztbRUrHsZ66/WfnagEd+myeBYYSMAHKIqe09R5ZsWBsVXX65ssgdC8JtV3khHo=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4887.namprd04.prod.outlook.com (2603:10b6:a03:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Mon, 25 May
 2020 04:01:38 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 04:01:38 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH] block: change REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL
 to be odd numbers
Thread-Topic: [PATCH] block: change REQ_OP_ZONE_RESET and
 REQ_OP_ZONE_RESET_ALL to be odd numbers
Thread-Index: AQHWMDx2/O9GcPiAf0ylnymRhHwVgA==
Date:   Mon, 25 May 2020 04:01:38 +0000
Message-ID: <BYAPR04MB4965739982A9642376B4F52686B30@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200522132309.112794-1-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d96f2b47-44ee-4525-6f98-08d800605342
x-ms-traffictypediagnostic: BYAPR04MB4887:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4887ACC5DC138898EA7AD8C986B30@BYAPR04MB4887.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TKmQU+GvQmIpTlQ8v6YXnE/p02sQS2zJYJGTX7rMNlEznsbq/XLOV7Ha/901Mj1URw96hFPr/rrZfpVj/V9oDvXNEIBLIfoCg5Lgv8hIEEJhs1DCGQemZJymiXbM9sPCt0d/vBgOOiNIPlTPVTdXEvdbwNGg7+iB2QIUJiqDaPR8KN2XX+BEeA0CgFqZP16lFTGSAVLlhSGTpk8c54EbhBabOE+gj7669JX9C+8qtOlvGd1Z92LX4hshF9Fqd96Zh8V+jde0OKhLvteDI1GTbMyE/n2x0OU8TPubI2NImEC1WUSrMjLAoJaiC57xwRw66cwxp4Ke8ZH9ny2vYGXXeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(2906002)(110136005)(76116006)(66556008)(64756008)(316002)(8936002)(8676002)(66476007)(66946007)(66446008)(7416002)(4326008)(186003)(26005)(71200400001)(86362001)(54906003)(5660300002)(52536014)(478600001)(9686003)(7696005)(6506007)(53546011)(4744005)(55016002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DYPebBFb4cwhpak65ypMl5id9bU6RWC4FOeNyfoxoLX+joqq25iq1x3JX0Q+27VXN/+VO35IIQGAwzAkXRK4vkpJ81dlMeCz6TFUua1AdMwxYzgP1LOTpU0YVjmwD5fcgBazvMViL2NooGzqQQze6JNU7EwGI/5inVVyxv5NNA50BHFosMCBD64rkEXGqrU04sS/GUgxy+G+2ZrCprJnXctvuEJIpZ6RnCVT+Wkx3adF1Y+U6ctBt+wnv341bsaLwG2t+lWOl/xn/aOmVpk3MsOPr9tgkqeV2jarWfaJzUZZE807l/Ku2KhpTuzdmO3H8MY2OKEOuejONqjSk110G3Ibe5eRn9beqKVLwIMwoobYTRV2jvXsUETa0J3X/cC18OIWvSIZQMR0fWItw+yM3Jju3slDOXrz1NGDvkVkbjnrUIfggb0RxXq7iVFyns0zV2QRmKC2Kzd/fZEhGL9b/o9DOI7DoeytumBEWzH50/o=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d96f2b47-44ee-4525-6f98-08d800605342
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 04:01:38.5359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IDfX945q3jKrntT6kJILJADIVYIp6xLDTBxAiEkuAxLmDFyQoMhh1ph5pQ14L2Nx4vjtK1pYzA7PzGc3cweiQk0iq0f2Iwy2o9YuLucjBAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4887
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/22/20 6:25 AM, Coly Li wrote:=0A=
>   	/* write data at the current zone write pointer */=0A=
>   	REQ_OP_ZONE_APPEND	=3D 13,=0A=
> +	/* reset a zone write pointer */=0A=
> +	REQ_OP_ZONE_RESET	=3D 15,=0A=
> +	/* reset all the zone present on the device */=0A=
> +	REQ_OP_ZONE_RESET_ALL	=3D 17,=0A=
>   =0A=
>   	/* SCSI passthrough using struct scsi_request */=0A=
>   	REQ_OP_SCSI_IN		=3D 32,=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
