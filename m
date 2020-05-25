Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D7E1E045F
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 03:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388600AbgEYB0g (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 May 2020 21:26:36 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:12028 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388104AbgEYB0g (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 May 2020 21:26:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590369998; x=1621905998;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=FCgobR2yZaSu9BjQqG7kwkV6a0gtDE5Q+2dseJeWndc=;
  b=YhznDPoaVz4AMcQw/D23ufVlu7ZiLBSLFDqNGqhnl8alHy6hkOxnz/uw
   y27FP/MXkzbA2iM+I2UAiZZexbRZYnnnM+XNDsdRSeih81ojznwktBCir
   811eFbd2jQFuOb7ZQJBwdOC/uMmNsp2BEoaPvTPMSpjXY1v9iRupPufCb
   xqjEM4WMZh9VCFIK+32vR5SbXVHIevoJFs6pKdqjp/JT9U15b+YhTNA/k
   cuWaO2EvArNyfWF013CaCzuyTPZXu4C7FifQZLt1XrOY0NdJiy2mmLnzC
   Qy6ENKnNpi/ZWgIQRE5hu7HoR/EbvQVi/kbFL82xeqWgbFHq1aOCkwvmu
   Q==;
IronPort-SDR: 2+F3DX740Qx7QzsHLDOhQSc5r6XnNKr+l/sxf0/CTQHPVukEQrXREyrl8fDnLSKhW3ZpQ2DNVe
 hHtXDlULbeFBqfQJ6beiNJH5niuWbZDgO3Z3305VteaPHl+EM4V4ByZYXQ9Hrb5p3XNpm3wQFs
 G5FRG844XM/ihE+gdE7woyt7h1QTRPLaaPm/RhcRmssFOlS3WP4B4h87MIAl23bN/5bgnkI27F
 xFqWu7ANsRdh9wTVyrAqQOxIXiCNMzVynTgc/Sj833Il3lHFOQ8BadMrRRZEwOxD+xGJuVsM7X
 iz4=
X-IronPort-AV: E=Sophos;i="5.73,431,1583164800"; 
   d="scan'208";a="241212342"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2020 09:26:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIjm1nuIYeK1CDMp/g1ea6KAVjG1QP7Mqc6Q/zbhnczZvdabirdqLWvHJCn05U+T+RcDSJtqjB0sWwp5jWijlYTzfffdOL4/RqztQq6YocaVxMSaES3UA8ks9oTlS0H1oPGaw2dq3DmGKsmTzMOf8Gjc8UjuNNumkRKhMNsLa+0rOXIViH5Xfe3Lg5dDm5Pt8kbqtlOaHRlImyOg9xCMAK12xvZLBtX6NoVb5TD3qOFWwmCF9AUh/RLxxrpWydtIcwE+xK6pcJwk7YfZ4/dJYJ/FwS8ftyRodDUXT1SFPMUEq0QKFnqOjRSjHM+oQjBgJ4cABGEZAyeaqWnw7hxChw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsj81HchLqLU5DXDBC9yPl2xJbDEsWiyIokBioqvpGo=;
 b=JUe5h/NJrh4QLIZDJxiKpjxmS+YtgkI0p5a9Wxkh2avOLG4xK4g3G/zCAkWTY3YS5vwrlpU1XFumbIE3ed8Bm+tnW2A7IopiJtVJ+C5eEl7CPDPA82P7HvIE1MIWxu6pG4pdKMRPVKehEI03brBop0dPgCwYO8ju40Ay3WRAvUIy9iHk4XBKyknarjdTJHPEz/8G/h7bs2lj+TuNZzdv9n8Y8sGoO2pm1+enkPjNypLucMy8G9y3de+Z2J7gLgoZ6d8OGENcjf/ZTHUgZVOBAzeKk5fFG/4XGYKHPzIFY2wCpZzS42OrYMiw4RGRr+HwudYXdSQk3nkWboFBRfuSGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsj81HchLqLU5DXDBC9yPl2xJbDEsWiyIokBioqvpGo=;
 b=rmLepJ9tBZbbBTExl4zMyz9Er/Vsn4oBUAGfynqY12w4hPWlUt+raz7HbDo5lvX6jG2Z3jBA24zerulGlyUmBNgxcnvlIe0VNXwW2Cy40rUY9TOxngzYpNzf3M7AOlAMK2xwHlmJjCSF04mUM++rPnEF+NuYi+/7m6lh6+YxQlM=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0745.namprd04.prod.outlook.com (2603:10b6:903:ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 01:26:34 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 01:26:34 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [RFC PATCH v4 3/3] bcache: reject writeback cache mode for zoned
 backing device
Thread-Topic: [RFC PATCH v4 3/3] bcache: reject writeback cache mode for zoned
 backing device
Thread-Index: AQHWMDMt3QijFk0LH0ivzDyeGN49DQ==
Date:   Mon, 25 May 2020 01:26:34 +0000
Message-ID: <CY4PR04MB3751EF222D4DFFB9C05AB38EE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-4-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 529200e3-e29b-4340-38bb-08d8004aa979
x-ms-traffictypediagnostic: CY4PR04MB0745:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0745758A86AD28C5126F20BDE7B30@CY4PR04MB0745.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TwIKZBgWa5UQqCkegGeybk6QdLXldzjAvrhGKemiFE/I/JiAJjs2TSqWQdIxYXc3n45GCzr11Fpf1BSkRlZBaXq0+vkxzbtUgaLw4jOLRoBnhBspeAqp1kRCGdvv8LUZFNTq5RrFzDym27Rtzw/0NdqmBkObLaTLv9Y9g5qbWhzaUJLQO3bahIAvnJJS56/e23rb/y74tRZ9p6dQZc23SMQx5mv6CFUi3RF6HT57snQW5YdgHwWX9lLJ+Sqmwitb3D6Nz/UaaGJe9trqIPimgSgej9EXs0tEdHbQR9EB5VrhZMXbWWr1lKj7gesUgbNycvKsR0h/cjLVCgt9WqYAAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66446008)(52536014)(110136005)(54906003)(66476007)(76116006)(91956017)(316002)(66946007)(64756008)(66556008)(9686003)(478600001)(4326008)(55016002)(71200400001)(53546011)(7696005)(186003)(86362001)(26005)(33656002)(5660300002)(2906002)(6506007)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cnQrAKdw/eev0Hv0frbfU3s77WqJNoyioOyeFIj/O4nD5Um0Ti5euKyVS5vFZsfi/S4cs2ISfet0fR1fhCxBAq/K6am/G8dO20RSj85CZDIgHC8IAQjgPQhE69vAlw+AkkSoEQ2iBCrjnaZtiBXq6NW0k/d+29vdXMcMpl8KMs9dEwm4dqXBXP6wNmCmZCD7SQUgXEyV88dyc/sLe9k26J8SPUGa1NBOfXzzknM5wLl06MZJOaENMW6EUPX41JU5SvZTQhmIAVeAAE4a0TUH9nBuIvOsF6VOMbtsQ/EGT/gEsqiplEWTmXw/ZXhi+VtxPuordHlHvbyATwylVphE9p9uEoz2Lclhb3IS4bN7DqlKwswku4lB1kppQzqRYtFkt2pEiVlMXYXmCFOsQNx4q8n1yNeHyN/4DvI0n/rLUeM1Rhf4neif5nJ/nTB4Sm07PdHnOYkG1moYh05VeXXVw5GJ4bxTNE2b1kQMfCmsvvk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 529200e3-e29b-4340-38bb-08d8004aa979
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 01:26:34.3449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4LxQYEAeYFBXwmIDK/R/wT3tpFEwcwuYINVwC/K+w1sVgUQB0x/7xOfL2wOr+Ig4mtiZyOvJ1iFPyNP3fdA23w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0745
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/22 21:19, Coly Li wrote:=0A=
> Currently we don't support writeback mode for zoned device as backing=0A=
> device. So reject it by sysfs interface.=0A=
> =0A=
> This rejection will be removed after the writeback cache mode support=0A=
> for zoned device gets done.=0A=
> =0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.com>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/md/bcache/sysfs.c | 5 +++++=0A=
>  1 file changed, 5 insertions(+)=0A=
> =0A=
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c=0A=
> index 323276994aab..41bdbc42a17d 100644=0A=
> --- a/drivers/md/bcache/sysfs.c=0A=
> +++ b/drivers/md/bcache/sysfs.c=0A=
> @@ -359,6 +359,11 @@ STORE(__cached_dev)=0A=
>  		if (v < 0)=0A=
>  			return v;=0A=
>  =0A=
> +		if ((unsigned int) v =3D=3D CACHE_MODE_WRITEBACK) {=0A=
> +			pr_err("writeback mode is not supported for zoned backing device.\n")=
;=0A=
> +			return -ENOTSUPP;=0A=
> +		}=0A=
> +=0A=
>  		if ((unsigned int) v !=3D BDEV_CACHE_MODE(&dc->sb)) {=0A=
>  			SET_BDEV_CACHE_MODE(&dc->sb, v);=0A=
>  			bch_write_bdev_super(dc, NULL);=0A=
> =0A=
=0A=
Do you have a similar check in bcache user tools at format time ? Or is the=
=0A=
cache mode specified only when the bcache device is started ?=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
