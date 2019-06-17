Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A01948964
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 18:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfFQQ4Y (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Jun 2019 12:56:24 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:51156 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQQ4Y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Jun 2019 12:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560790584; x=1592326584;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=k9fcWox9dAUVMQcETYp7JP5EL1W50vIcCWQb9ipfkug=;
  b=Jk2psbsE0H/FiTjRqLggqAmWIo4RCyRcVs1VCaaDmiiheyfxRrcd1q6m
   WnZM47EDTPvkL1Etk8EM/+Z0qg+e/lwgpVXqDEh7iItB0t1Y9qUfuJoaN
   GbyI9WQNnWvugRCXl+5fnGfD75oxR2Xc5zFmyHiv+xSyHtxyK4d2ebG/+
   U3VdT2fR6P3CLskcMScpKISfVV+22UQYU9Ya7qM0ulZG+MUH3Opk0PsWg
   n/FcyxXeQOiwyqirQfjKsIulD+Vh0qGHZnFkYZgUHElZNc8eMb7rFQ0/v
   Xr0HFWKYyRr9ScYDekH9awrOZK44mVR6QbtxXYcPLiOW1CZtFOkROWBuM
   A==;
X-IronPort-AV: E=Sophos;i="5.63,386,1557158400"; 
   d="scan'208";a="115687368"
Received: from mail-bl2nam02lp2053.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.53])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2019 00:56:14 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuPaF+5UAgO94w/KzXYSHH14QeBz0FkNyENBa0lm36A=;
 b=DDkpw0P1sK70ah0lGj+QzQ+YFdP5VYRpxqjiPVY62ZVm9D7eZbAmjIwztcvPUSDmD/1vIrid8Pq8LN/xgA00FsLJJyHsaiMQDIdGQYMscPElnWnh2k1HXS8vSgFTquXjDcC4gZOyvxX7G8S6i3q1LM6XpWjsICC0EzMhGPxdqKo=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.58.26) by
 BYAPR04MB4567.namprd04.prod.outlook.com (52.135.238.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Mon, 17 Jun 2019 16:56:12 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6%7]) with mapi id 15.20.1987.012; Mon, 17 Jun 2019
 16:56:12 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH V2 5/7] bcache: update cached_dev_init() with helper
Thread-Topic: [PATCH V2 5/7] bcache: update cached_dev_init() with helper
Thread-Index: AQHVJKwKnTXgLhfI30Cy3cQymORhzQ==
Date:   Mon, 17 Jun 2019 16:56:11 +0000
Message-ID: <BYAPR04MB5749C877C444A5A2144A921886EB0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
 <20190617012832.4311-6-chaitanya.kulkarni@wdc.com>
 <ae48b013-6e5f-1300-557e-1dbe0f4ad31c@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88d7d1d4-1e01-45c4-339e-08d6f344b3ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4567;
x-ms-traffictypediagnostic: BYAPR04MB4567:
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB456736C88594942C9AAB803886EB0@BYAPR04MB4567.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(346002)(136003)(39860400002)(199004)(189003)(7736002)(316002)(8936002)(305945005)(53936002)(3846002)(55016002)(229853002)(86362001)(6436002)(6116002)(5660300002)(446003)(186003)(73956011)(9686003)(76116006)(6246003)(66946007)(66066001)(66446008)(64756008)(486006)(66556008)(476003)(66476007)(33656002)(25786009)(72206003)(4326008)(74316002)(15650500001)(2906002)(81166006)(71190400001)(478600001)(8676002)(99286004)(7696005)(2501003)(26005)(68736007)(53546011)(71200400001)(102836004)(6506007)(76176011)(256004)(110136005)(14444005)(14454004)(52536014)(81156014)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4567;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vlhzYq0cYNscYGrvIw/shCLZjaiwyS7dcWFEySAQvqxQiww5MO7x+hUnCgWY1VDT/ytLHyM858xdIGbLlBta4Z9LqrMyl/2bAk3cStyj09sUi4F2vJhf7UFUiR8gezvaXVhL+Gc2/jdppEfVj9wziYXrNQNuG2ArtFf+HCqwryWOaQH2hM3k5bOEM8sIiCGfnbnIU49fzrm1dYaDwgf05AnFcrS5I1mW4+4iYQT/7pqYmj1G1MOp1zmj+tcftz+apRgYbpvOci8wQxfkp7yXL7uABh5fHFKAZHDBEuoiTC+11TCmsYV/Wj8monsbq8X1iyNO1nRxBr4kcR76pyz23xFV+/GwhgERxBmTCuyQFwGtxByIa5w0JpqndtmvaJHf0F+D7OnKk1TkPKuUJjCJ6G3ZzuGWoQaXvLf5z9iFxAk=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d7d1d4-1e01-45c4-339e-08d6f344b3ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 16:56:12.0098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Chaitanya.Kulkarni@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4567
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 06/16/2019 11:54 PM, Coly Li wrote:=0A=
> On 2019/6/17 9:28 =1B$B>e8a=1B(B, Chaitanya Kulkarni wrote:=0A=
>> In the bcache when initializing the device we don't actually use any=0A=
>> sort of locking when reading the number of sectors from the part. This=
=0A=
>> patch updates the cached_dev_init() with newly introduced helper=0A=
>> function to read the nr_sects from block device's hd_parts with the help=
=0A=
>> of part_nr_sects_read().=0A=
>>=0A=
>> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
>=0A=
> Acked-by: Coly Li <colyli@suse.de>=0A=
=0A=
Thanks Coly.=0A=
>=0A=
> Thanks.=0A=
>=0A=
> Coly Li=0A=
>=0A=
>> ---=0A=
>>   drivers/md/bcache/super.c | 2 +-=0A=
>>   1 file changed, 1 insertion(+), 1 deletion(-)=0A=
>>=0A=
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c=0A=
>> index 1b63ac876169..6a29ba89dae1 100644=0A=
>> --- a/drivers/md/bcache/super.c=0A=
>> +++ b/drivers/md/bcache/super.c=0A=
>> @@ -1263,7 +1263,7 @@ static int cached_dev_init(struct cached_dev *dc, =
unsigned int block_size)=0A=
>>   			q->limits.raid_partial_stripes_expensive;=0A=
>>=0A=
>>   	ret =3D bcache_device_init(&dc->disk, block_size,=0A=
>> -			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset);=0A=
>> +			 bdev_nr_sects(dc->bdev) - dc->sb.data_offset);=0A=
>>   	if (ret)=0A=
>>   		return ret;=0A=
>>=0A=
>>=0A=
>=0A=
=0A=
