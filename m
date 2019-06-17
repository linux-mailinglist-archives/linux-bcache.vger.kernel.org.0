Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD2C4896C
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 18:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFQQ5J (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Jun 2019 12:57:09 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:51827 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQQ5J (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Jun 2019 12:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560790628; x=1592326628;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ZTFs1VQyVxdcUx53xPdgJmVbGFeeqXpKJw2Hx6bpFnM=;
  b=rP06jrEO5JmSnGZGeJnOu9bt0puYJawUh4JSZOJ8XLlRj1Ag7CrDbn93
   DnKD2vZAJU1HP+FcvLnPaxekENk6QDOCqAh+VMmB2aAHk+DxrqyyGKkgC
   FKdemzrp3sEEh45EHEb7bB3S4pSm0oVwxIJWJxS2Ieg5y7Ld5kmS1KPbL
   4gojVTnQmlrY0gjC6Bk/nERQqPPsxcP+DS4B8blafkf+1GZefErhCoMaq
   OvY5BLdLkhPo6mxL8UXM1hfO+60p4+QCrMN68r+dUZYbhscznL/Khcm8b
   BareEV9083bJLQap2KrJKcbgqDJGoHT0ircHp2zVzGjA8OulzqZmhZIQM
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,386,1557158400"; 
   d="scan'208";a="112024181"
Received: from mail-cys01nam02lp2057.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.57])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2019 00:57:07 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTFs1VQyVxdcUx53xPdgJmVbGFeeqXpKJw2Hx6bpFnM=;
 b=Tyu57hi9vNxgwlPbAnhnn1HbbC8U+za2V1e1Gu+2ESRaGegasotKYHpFTiIc34re3BTpjbCvtYJOlZtd2w5rnZpYGgsV1QwYgHH5nLpwaj5lIB4eJ8dbL5kuNIzpgatPFEyBsdcf3DBgpGhF88v0stgW17CzCPQYVKG0KGnwHZM=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.58.26) by
 BYAPR04MB4117.namprd04.prod.outlook.com (20.176.250.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Mon, 17 Jun 2019 16:57:06 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6%7]) with mapi id 15.20.1987.012; Mon, 17 Jun 2019
 16:57:06 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "colyli@suse.de" <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH V2 0/7] block: use right accessor to read nr_setcs
Thread-Topic: [PATCH V2 0/7] block: use right accessor to read nr_setcs
Thread-Index: AQHVJKv/SVB4gCEUf0q3+CUlcI0YtQ==
Date:   Mon, 17 Jun 2019 16:57:06 +0000
Message-ID: <BYAPR04MB5749A60A077E1D976845264A86EB0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
 <a7458a93-5dd2-ddd1-8466-9da95c4d3aff@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0611ea86-8305-4259-94f1-08d6f344d485
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4117;
x-ms-traffictypediagnostic: BYAPR04MB4117:
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB41179B3DED2ECEAA75FED98C86EB0@BYAPR04MB4117.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(396003)(376002)(136003)(346002)(199004)(189003)(66066001)(71190400001)(229853002)(6436002)(55016002)(71200400001)(74316002)(64756008)(305945005)(53936002)(81156014)(8936002)(81166006)(6116002)(9686003)(256004)(186003)(26005)(102836004)(7736002)(3846002)(8676002)(99286004)(53546011)(76176011)(6506007)(7696005)(73956011)(486006)(66946007)(476003)(446003)(33656002)(316002)(14454004)(52536014)(68736007)(2906002)(478600001)(4326008)(86362001)(2501003)(4744005)(66556008)(54906003)(5660300002)(25786009)(6246003)(72206003)(110136005)(66476007)(66446008)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4117;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 74obm9wI4mPCAYK9vr9JDiX7RTDkNxpcgDbe02BESRPj9+8O1LRnOb4JonEwRhklH0PYrVxtqL5nNuiOeEAv0iZFJjCSSDZPUVlXYN0UiOP7ol9bGbeELWD02Seg2mq2jqyhQbTbL6wR5mLl6+ekxzM/BUVCl1cmuoAyZjFeFqmIBDcwTtEP67x8m8+qKpQ4WkatfaIivFxN05Bqy1poUvz8wGxu0vHZBLWZhznQN2OfsVV7mJdXxwSLRbHmyPCd7lErGVPra+4lUgUynuBPQgsCzqaHZ6Nsr2Rn4HlzkL1l9AGm0xjqcC/1AZM6MfHJhxaE0zCsHDCOPQ5y32JPfy031ij7ajaVY4RR+QbSUy7PNrj+K+NZA48r1nR16ymKkz2LgmmcdL47wH9IDuQMLE266Ae1dNEtegwGkYe+n3M=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0611ea86-8305-4259-94f1-08d6f344d485
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 16:57:06.5885
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

On 06/17/2019 08:45 AM, Bart Van Assche wrote:=0A=
> On 6/16/19 6:28 PM, Chaitanya Kulkarni wrote:=0A=
>> In the blk-zoned, bcache, f2fs and blktrace implementation=0A=
>> block device->hd_part->number of sectors field is accessed directly=0A=
>> without any appropriate locking or accessor function. There is=0A=
>> an existing accessor function present in the in include/linux/genhd.h=0A=
>> which should be used to read the bdev->hd_part->nr_sects.=0A=
>=0A=
> In the subject, "nr_setcs" should probably be changed into "nr_sects"?=0A=
>=0A=
Yes, will fix it in next version.=0A=
> Bart.=0A=
>=0A=
=0A=
