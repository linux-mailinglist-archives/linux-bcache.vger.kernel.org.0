Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D889440AD
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 18:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391050AbfFMQIQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 12:08:16 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19379 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390981AbfFMQIQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 12:08:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560442095; x=1591978095;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=b+YHNMPOTX+gPw0+iBfVJLNz40XJFp2G6BJ7EQ7Ah/o=;
  b=DWB/kuSfjlZDMGqcAbbv6o1r+WZrjnYDhWncDnximz3SMC+4C4V1nnYm
   rO/kskgM50s1x8oWeowGCqH/9GlnWzhy8FeHcEzsOQl3MaP1Th2159YK3
   Zvq01BK0bh718/aICoovAWYUdZmfTDiec6Z53l46gP6bdlNpsqVyNHncm
   Ahj0o2iXxZ1//lhoNKQA5g/sBczlyc3zFQjDolrG+CRaSTmI0UxTgr+Dm
   EDRDKnRJuQUWX4hd+H2vsrVrqoBur/cVTN7fkqKN08FaZ7JzFM8/5AHO8
   MU4p8ixQnBwBANFQYVV8exu3vi/DYCRgbhmTDeU+hwq1BFBz/MgL0qhlx
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="216840592"
Received: from mail-bn3nam01lp2052.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.52])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jun 2019 00:08:14 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Od1GXmzjG7I8UU5z24hsDdBJ/zwDw0nMC3Vn/HphG1k=;
 b=CUFBPh+RNRKsjBqPr08HQZ1/g/YE1XZZ9Utt3UXjDx9u0bUbxDC2JRblqmCjxTGMyj/guWoR6harA/HZ64ylr4mmtHK0Nmh9dr4jaSre/27H4/tN2ZfvJnLCxFLGx9XgepDpLs29NHDgl3u0S5icnhdd4mUU9O0W2EavsIF0CNo=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.58.26) by
 BYAPR04MB5031.namprd04.prod.outlook.com (52.135.235.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 16:08:12 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6%7]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 16:08:12 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "colyli@suse.de" <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [COMPILE TESTED PATCH 6/8] target/pscsi: use helper in
 pscsi_get_blocks()
Thread-Topic: [COMPILE TESTED PATCH 6/8] target/pscsi: use helper in
 pscsi_get_blocks()
Thread-Index: AQHVIfjG6S29rCNw8E+YeE1NWrddbQ==
Date:   Thu, 13 Jun 2019 16:08:12 +0000
Message-ID: <BYAPR04MB574928B826652B698EE6286886EF0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
 <20190613145955.4813-7-chaitanya.kulkarni@wdc.com>
 <ca5092fa-bc1b-08d5-888a-1ed6f909dfef@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a92986c-344f-40d5-375f-08d6f0195606
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5031;
x-ms-traffictypediagnostic: BYAPR04MB5031:
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB5031549853CAD1DD4B353EDC86EF0@BYAPR04MB5031.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(366004)(39860400002)(376002)(199004)(189003)(6116002)(71200400001)(25786009)(64756008)(476003)(26005)(53546011)(102836004)(54906003)(5660300002)(186003)(110136005)(7736002)(68736007)(6506007)(76176011)(14444005)(7696005)(71190400001)(99286004)(229853002)(316002)(256004)(3846002)(76116006)(66066001)(52536014)(66446008)(72206003)(33656002)(6246003)(14454004)(66556008)(66946007)(81156014)(55016002)(2501003)(4326008)(66476007)(6436002)(73956011)(446003)(8936002)(74316002)(305945005)(53936002)(486006)(81166006)(2906002)(86362001)(8676002)(9686003)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5031;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f2lSw5HnbqTMcPV/wAmxX7hfzRxFkDFFRvdI5g9co5ABlIPcA8KRWv41BFFQRRMKIw1WUYGJsXX24TkK/rBzI5KA3uEe7r1O0V684VS74OSDCreo2IKA/Qjp47kFVAGzjrxDiATnBr02oEvdov9bNNyKKSHODE7oC1Etud/vdHsZ5iGIzy6NJs3YfuTeGmiyzP0tO92SHe9j5y3dT1O75x+S53grwyluViLAaM1bzlb8Sp5hDmQgDkwhZrpqK+UFtZ94DnWL4YDZMxyk7OJkJau3QUCJHhRPYK/SIj9t48MwCVwMQ8WhrN+JqEmcf18FqcpHqb+99VvdgMy/U0EihcjSDYait+XZefVJ0A5qriJMuv88K20j3uvq0spJghKOgRhu8VBHqrJKyUe2dtm0e9dT5lf+8g34mFDw9cd01mc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a92986c-344f-40d5-375f-08d6f0195606
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 16:08:12.5491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Chaitanya.Kulkarni@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5031
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Okay, I'll drop this patch in the V2.=0A=
=0A=
On 06/13/2019 08:36 AM, Bart Van Assche wrote:=0A=
> On 6/13/19 7:59 AM, Chaitanya Kulkarni wrote:=0A=
>> This patch updates the pscsi_get_blocks() with newly introduced helper=
=0A=
>> function to read the nr_sects from block device's hd_parts with the=0A=
>> help if part_nr_sects_read() protected by appropriate locking.=0A=
>>=0A=
>> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
>> ---=0A=
>>    drivers/target/target_core_pscsi.c | 2 +-=0A=
>>    1 file changed, 1 insertion(+), 1 deletion(-)=0A=
>>=0A=
>> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_=
core_pscsi.c=0A=
>> index c9d92b3e777d..da481edab2de 100644=0A=
>> --- a/drivers/target/target_core_pscsi.c=0A=
>> +++ b/drivers/target/target_core_pscsi.c=0A=
>> @@ -1030,7 +1030,7 @@ static sector_t pscsi_get_blocks(struct se_device =
*dev)=0A=
>>    	struct pscsi_dev_virt *pdv =3D PSCSI_DEV(dev);=0A=
>>=0A=
>>    	if (pdv->pdv_bd && pdv->pdv_bd->bd_part)=0A=
>> -		return pdv->pdv_bd->bd_part->nr_sects;=0A=
>> +		return bdev_nr_sects(pdv->pdv_bd);=0A=
>>=0A=
>>    	return 0;=0A=
>>    }=0A=
>=0A=
> As far as I can see bd_part does not change between blkdev_get() and=0A=
> blkdev_put(). Since the pscsi code guarantees that blkdev_put() is not=0A=
> called concurrently with pscsi_get_blocks() this patch is not necessary.=
=0A=
>=0A=
> Bart.=0A=
>=0A=
>=0A=
>=0A=
=0A=
