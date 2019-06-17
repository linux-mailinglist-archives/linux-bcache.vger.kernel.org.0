Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6728448961
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfFQQzr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Jun 2019 12:55:47 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:37254 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQQzr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Jun 2019 12:55:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560790546; x=1592326546;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=dAhW5Km0fp88XmCLirE9SYLKkGPJWKFyvsYJf+hxYWw=;
  b=olYjNiCwM2F33SQPfBz1VcHmpTXrCmLOSyObSAFx7YzAwmJxu7gkXzrC
   8Su1oaUfP9swIj/leJMggDjvevzmlQ0ReGOdjUUoK9N9hGUKpzTIn1Xc0
   K59PuCPpnbf7ORmIOUf8kv79Fuf/r6JVfiuRhs9TVFVn5MFshuvV23NqK
   bHP8IX9qxASa6BBGnMBLOTVHjk1cjatlzVr3bbWjpTb0mLPoOnq+BaNqC
   xZAi4f6l2zhoYFxgKKuSgmNRehw5C5Uan8/s4XJJz8mphQ7iVQxu66Fej
   Nl/ndVhHezY9XKmkV6haTYvWzrysr2llAtsk4mFGTg/CW1SwfFEda3wkM
   A==;
X-IronPort-AV: E=Sophos;i="5.63,385,1557158400"; 
   d="scan'208";a="217137029"
Received: from mail-dm3nam05lp2050.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.50])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2019 00:55:45 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xxzWyhmDDR63lX2NuSdibB6WHPi/V7msga+tKw2VCU=;
 b=fx2429FktUEn40d0IoVs/vfUaqpqMv7WPK784lL9bW12O2z2rf0BYBE7JvpP7XlIGz3eyYT9AujjrLgD28jp0Ahh0xJb7zJ2wygjapbQCZhYM5FFA2qWn1PLZZdnkUfloQ/IaSlcHPEZR5TzTw5laCooL3tGEuBu7QpVoEmiPWI=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.58.26) by
 BYAPR04MB4117.namprd04.prod.outlook.com (20.176.250.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Mon, 17 Jun 2019 16:55:44 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6%7]) with mapi id 15.20.1987.012; Mon, 17 Jun 2019
 16:55:44 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "colyli@suse.de" <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH V2 1/7] block: add a helper function to read nr_setcs
Thread-Topic: [PATCH V2 1/7] block: add a helper function to read nr_setcs
Thread-Index: AQHVJKwBOvNjfZQCIEmKuQqlwDGVnQ==
Date:   Mon, 17 Jun 2019 16:55:43 +0000
Message-ID: <BYAPR04MB5749AC0801F021068F84F81186EB0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
 <20190617012832.4311-2-chaitanya.kulkarni@wdc.com>
 <67bcc55e-a674-7a71-7ce3-3a6745977740@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 976cee11-b078-4b0a-b471-08d6f344a332
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4117;
x-ms-traffictypediagnostic: BYAPR04MB4117:
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB4117FED97A44358DEAD94F2B86EB0@BYAPR04MB4117.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(396003)(376002)(136003)(346002)(199004)(189003)(51914003)(66066001)(71190400001)(229853002)(6436002)(55016002)(71200400001)(74316002)(64756008)(305945005)(53936002)(81156014)(8936002)(81166006)(6116002)(9686003)(256004)(186003)(26005)(102836004)(7736002)(3846002)(8676002)(99286004)(53546011)(76176011)(6506007)(7696005)(73956011)(486006)(66946007)(476003)(446003)(33656002)(316002)(14454004)(52536014)(68736007)(2906002)(478600001)(4326008)(86362001)(2501003)(66556008)(54906003)(5660300002)(25786009)(6246003)(72206003)(110136005)(66476007)(66446008)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4117;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FOewsfiuTn9AX2b0JkZjcaY4mQ6Kr9ioThgPDEguD/Z+pkNKaqcOrGdujtSvDkmGbP3sKfaMBwU1BVp7OAara3eg7doTM+3orRQK5e3rcP5MY/6wW2AXlJtC/CKhhIeAYnVtiwGC2+chVgxMZAEJ2ZnS5qVkNlSzrEBhBvTFO3SaqQcxmkOm8WHmsEWZ+xRGkLyoGyCevqga0UTrUF6ACk2vigm43QQD8NcqEPOz+lqX+yl7LFRi84KejKFZh+HujRM6YVBd3XJN8FKPfM8yW4j1DZ02zT+UL0cZYUqWpR4AE7WtNX4NeYAu5qeKJ4kU1VwI25i+mpnIS0gOYyfLfW4tFlWMywWpFL2R/VYOa4WBKE0od48qONbsPAOQkSmMH5dXraddTghjj40g7xJpwJ42KAlFbK7Z754lTAqJoMA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 976cee11-b078-4b0a-b471-08d6f344a332
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 16:55:43.8690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Chaitanya.Kulkarni@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4117
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 06/17/2019 08:47 AM, Bart Van Assche wrote:=0A=
> On 6/16/19 6:28 PM, Chaitanya Kulkarni wrote:=0A=
>> This patch introduces helper function to read the number of sectors=0A=
>> from struct block_device->bd_part member. For more details Please refer=
=0A=
>> to the comment in the include/linux/genhd.h for part_nr_sects_read().=0A=
>>=0A=
>> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
>> ---=0A=
>>    include/linux/blkdev.h | 10 ++++++++++=0A=
>>    1 file changed, 10 insertions(+)=0A=
>>=0A=
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
>> index 592669bcc536..2ef1de20fd22 100644=0A=
>> --- a/include/linux/blkdev.h=0A=
>> +++ b/include/linux/blkdev.h=0A=
>> @@ -1475,6 +1475,16 @@ static inline void put_dev_sector(Sector p)=0A=
>>    	put_page(p.v);=0A=
>>    }=0A=
>>=0A=
>> +/* Helper function to read the bdev->bd_part->nr_sects */=0A=
>> +static inline sector_t bdev_nr_sects(struct block_device *bdev)=0A=
>> +{=0A=
>> +	sector_t nr_sects;=0A=
>> +=0A=
>> +	nr_sects =3D part_nr_sects_read(bdev->bd_part);=0A=
>> +=0A=
>> +	return nr_sects;=0A=
>> +}=0A=
>=0A=
> Although this looks fine to me, is there any reason why the body of that=
=0A=
> function has not been written as follows?=0A=
>=0A=
> static inline sector_t bdev_nr_sects(struct block_device *bdev)=0A=
> {=0A=
> 	return part_nr_sects_read(bdev->bd_part);=0A=
> }=0A=
This perfectly make sense, thanks for the suggestion, will add it in a =0A=
next version.=0A=
>=0A=
> Thanks,=0A=
>=0A=
> Bart.=0A=
>=0A=
=0A=
