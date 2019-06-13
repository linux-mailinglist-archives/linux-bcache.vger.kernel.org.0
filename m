Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454324408D
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 18:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbfFMQHb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 12:07:31 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:46187 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391364AbfFMQHY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 12:07:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560442044; x=1591978044;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=GxTOaOO5zyp40W5DUff2fnUgR4Lb3sQ1yiQ7dGCYmTY=;
  b=lAcPRlSb4QTCeZI/3QFDn8CByh7Wt8joxB0UT0Qvp9xMuOkoQUW613Al
   HDXvcDW0aC8M/SFb6n567kudgQ8p2+gHsRDESdl4CznevIDGv+cmiCzj/
   N3Ri+Z/Ca5AAY+mE/KsUp3HIeoZxEiu96GRHCiNd69C2AgHG8MgHFYM5t
   mwP0/s7M+VE5ccUWgKWHQTk9PvA2+9BWyiJRaEUsQtAMKfC45Up5W8fMx
   qMS0kdVunBLSpOLCFZNR9BKHPIPb0T+bcN8p50iJSIjSzZZZA94XbvA2P
   6PHvFvX26iLVJyyLDPjGA8tAmU+EJhrSaaKuwRBHLTOVqBDSgRzb2ctWR
   g==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="115425751"
Received: from mail-bn3nam01lp2056.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.56])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jun 2019 00:07:22 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Veg/OnHcoOv3HiS0et4oStCSEN6FTddMYHN8V7ly4oI=;
 b=j4h8m5J3jeQ7yMRS8dz8e9S1R7iHlCGg86Zze5FoCaBpE8Rexc71zOO0alEXTFtITA4orqhbolsm4+k1vRbMIpcpOkArCHsETl0QqQfu6OvguzU00TbPeFWBC4LELpeky+bV3ILzdGJVDffSP9z94fXwFt3gwT/nw+OJZaNaPvY=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.58.26) by
 BYAPR04MB5031.namprd04.prod.outlook.com (52.135.235.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 16:07:19 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6%7]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 16:07:19 +0000
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
Subject: Re: [PATCH 1/8] block: add a helper function to read nr_setcs
Thread-Topic: [PATCH 1/8] block: add a helper function to read nr_setcs
Thread-Index: AQHVIfi3BfhkYZDiB0K2HYRp35cL8w==
Date:   Thu, 13 Jun 2019 16:07:19 +0000
Message-ID: <BYAPR04MB57498CEB8869ED7B54F08E2286EF0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
 <20190613145955.4813-2-chaitanya.kulkarni@wdc.com>
 <9abfc2b8-4496-db7a-fcbb-b52102a67f8e@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9a8c06d-3fba-435d-c14c-08d6f019362b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5031;
x-ms-traffictypediagnostic: BYAPR04MB5031:
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB503141659D4DD1D268CDD22086EF0@BYAPR04MB5031.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(366004)(39860400002)(376002)(199004)(189003)(6116002)(71200400001)(25786009)(64756008)(476003)(26005)(53546011)(102836004)(54906003)(5660300002)(186003)(110136005)(7736002)(68736007)(6506007)(76176011)(14444005)(7696005)(71190400001)(99286004)(229853002)(316002)(256004)(3846002)(76116006)(66066001)(52536014)(66446008)(72206003)(33656002)(6246003)(14454004)(66556008)(66946007)(81156014)(55016002)(2501003)(4326008)(66476007)(6436002)(73956011)(446003)(8936002)(74316002)(305945005)(53936002)(486006)(81166006)(2906002)(86362001)(8676002)(9686003)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5031;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wHAoWkAIghEq+W02eLn2aDypjR7F+JbJ7FTaz+MjjLyq7tGUvMmigzp8LpsN+1pec0d6VTTTdlLxg5fYxXK6Gcpy8K6KhZvijStSjNXGVrKOTNQnfAoXO80RR6jKp332YD15NGi9IpDTLcAQhA+nIayVqToXyHEF87Mn2Z8Zaj9kj5csnRRhowJaUUmqdBL3RoxtaAYbEMml5v49qogruGxB9WDRvpZltBcKmw4ue89rPHblwvKKHkeZ82GyRHs5cCYLlil9u3qcKRWtHBFMGsVoUf8p2TL8hF+LRMoGQsrAHEVdnElBzjG2ULd8sGFaiKIy3ic42vduryzjW5rLwPvCoZkDOqerSuQp6V+LBEJBfG7XCXvSjHtFY03v4JcCkw9UDU+7Dv6Eshcm5AUircEEoflnmyJIdlw1emGTbaU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a8c06d-3fba-435d-c14c-08d6f019362b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 16:07:19.0851
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

On 06/13/2019 08:31 AM, Bart Van Assche wrote:=0A=
> On 6/13/19 7:59 AM, Chaitanya Kulkarni wrote:=0A=
>> This patch introduces helper function to read the number of sectors=0A=
>> from struct block_device->bd_part member. For more details Please refer=
=0A=
>> to the comment in the include/linux/genhd.h for part_nr_sects_read().=0A=
>>=0A=
>> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
>> ---=0A=
>>    include/linux/blkdev.h | 12 ++++++++++++=0A=
>>    1 file changed, 12 insertions(+)=0A=
>>=0A=
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
>> index 592669bcc536..1ae65107182a 100644=0A=
>> --- a/include/linux/blkdev.h=0A=
>> +++ b/include/linux/blkdev.h=0A=
>> @@ -1475,6 +1475,18 @@ static inline void put_dev_sector(Sector p)=0A=
>>    	put_page(p.v);=0A=
>>    }=0A=
>>=0A=
>> +/* Helper function to read the bdev->bd_part->nr_sects */=0A=
>> +static inline sector_t bdev_nr_sects(struct block_device *bdev)=0A=
>> +{=0A=
>> +	sector_t nr_sects;=0A=
>> +=0A=
>> +	rcu_read_lock();=0A=
>> +	nr_sects =3D part_nr_sects_read(bdev->bd_part);=0A=
>> +	rcu_read_unlock();=0A=
>> +=0A=
>> +	return nr_sects;=0A=
>> +}=0A=
>> +=0A=
>>    int kblockd_schedule_work(struct work_struct *work);=0A=
>>    int kblockd_schedule_work_on(int cpu, struct work_struct *work);=0A=
>>    int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork, =
unsigned long delay);=0A=
>>=0A=
>=0A=
> Please explain what makes you think that part_nr_sects_read() must be=0A=
> protected by an RCU read lock.=0A=
=0A=
Thanks Bart for looking into this, we actually don't need those locking.=0A=
=0A=
I'll fix this in the V2.=0A=
=0A=
Please let me know if you find any other issues with this series.=0A=
=0A=
>=0A=
> Thanks,=0A=
>=0A=
> Bart.=0A=
>=0A=
=0A=
