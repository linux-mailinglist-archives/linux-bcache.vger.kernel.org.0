Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644DA67306
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Jul 2019 18:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfGLQJ7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 Jul 2019 12:09:59 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:19105 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfGLQJ6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Jul 2019 12:09:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562947861; x=1594483861;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=N0fhyTrShdGrfIW5zABp0j8FA7VDbZFhG3Fjh78mCWY=;
  b=EX78Am3YmUBBzP9jqt5n8T9a4o17ht3kvSmuxqV/PnxHvndQfaSRkRWJ
   m1GD63IV9kvZ9k5DOE63by6RWlby3L5DZ6IzJd7w7uOy2vgJ9P2yDLaNu
   P0wrPMvSsbguMd/N2s4hyJHq9FFZvmSRgqcH9tBRWKJp40wI4ioNTLMPf
   y5xWnW3LN+w03H8HGr2piLl7x7Kd02+AniwnJET683V6BMn003MmOfEIL
   yGb3y/m/seYXHO3uZ9OLdnq/K2Fn//O9TdSR1nlla+GYs9fLo2LoVgH6R
   TO7pwXsZiyWZV7RizAhfjWPzyXQuG0kdmjCyXb4MqT5cy+tnccwHUh5XL
   A==;
IronPort-SDR: D7AKZ0sFotlHabHpoZYaGMlm/sydqrz7/jqe+0fse36zw+twTcdZhYTT7MlL0ogV0CKYTD55Gf
 Bsr2889sTfy/fjz0AmhXWUW/HzFzQVnlr9a939AsqK2BjTAwJgbdLKHdPZkJ4/1uutLKEUG2oS
 ixF0mtoh0DBGZKyxKNd0HIZZnMM0sayw/CHbgPIBMhOWqf1HSDECJbNf6uFj+O8f9fBDElS60m
 eAOWlVIw9dMYzDqHv41RHTXPlHbO80gMayCx1rw5SnOhmQ6xfbWc0WIU1B5s3ZLJAflbLLFuQ3
 mOo=
X-IronPort-AV: E=Sophos;i="5.63,483,1557158400"; 
   d="scan'208";a="212841637"
Received: from mail-by2nam01lp2054.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.54])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2019 00:11:00 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDqjVCuNjygIykNV6cNUa9bqD2yACUy0tABSvnq9LH8=;
 b=NCcXh2b2sDhx2kujb9Mi9sQjnCYoIL7v+saCw3b9UvlfBu4AwEhdHn/6a/NuFDaOIkcVUtCpPZ49UhWCpV8b4sFB9xqHr8qd/vBLp1q9XaoomtOQHdzCgQmui2yVJm+Y22Syi3fUzsgUXlC8RCMR1HtCRw9OiK0QJSc/O975Y50=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.58.26) by
 BYAPR04MB5992.namprd04.prod.outlook.com (20.178.233.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Fri, 12 Jul 2019 16:09:57 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::8025:ccea:a0e6:9078]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::8025:ccea:a0e6:9078%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 16:09:57 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "colyli@suse.de" <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "yuchao0@huawei.com" <yuchao0@huawei.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH V4 1/9] block: add a helper function to read nr_setcs
Thread-Topic: [PATCH V4 1/9] block: add a helper function to read nr_setcs
Thread-Index: AQHVNb2Z4KyEErtQ+UKxJ+HV/zvqXg==
Date:   Fri, 12 Jul 2019 16:09:56 +0000
Message-ID: <BYAPR04MB5749AF90A9E9C81B4A6857F386F20@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
 <20190708184711.2984-2-chaitanya.kulkarni@wdc.com>
 <yq18st457yb.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.64]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fd8b164-03d7-4925-211a-08d706e3622d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5992;
x-ms-traffictypediagnostic: BYAPR04MB5992:
x-microsoft-antispam-prvs: <BYAPR04MB59928DC0BC9E08C4D8F6E87B86F20@BYAPR04MB5992.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(199004)(189003)(6506007)(316002)(71200400001)(74316002)(68736007)(8676002)(52536014)(53546011)(486006)(7736002)(476003)(81156014)(229853002)(305945005)(71190400001)(54906003)(81166006)(86362001)(446003)(7416002)(9686003)(99286004)(66066001)(2906002)(55016002)(4326008)(53936002)(6116002)(3846002)(4744005)(14454004)(478600001)(25786009)(7696005)(8936002)(186003)(66946007)(66476007)(6916009)(76176011)(66446008)(66556008)(64756008)(33656002)(26005)(256004)(5660300002)(6436002)(76116006)(102836004)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5992;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: m65h7YZuEY0B2mfDKE2vkIXVULnruRvyk75fkhxpzgV8FGZL0HMHPsVsO3Ld72vawN7WKVVQVXbNEJOmwfyNDP2X4a+0E0paeczD8wg8EJdAk/MO31iAajhL+AClW8vfPHDJxKpz6murAWqgDaWbazuQSy0jckZX4eiBk6CvM943Zgx+byGUPYfyINRdHDL/cvOEIMyW0DZt8bX9qToeV6rDXeZXWJnCz2EWjWnKcjDNOG9yw0cMYRInUFzmF8Dp7k+BYNk4UxCHdsb4X9p6N17n1ruhBfeEFtMd9MzKAEjKWLfM4lmH5QnVWwFc35IF0T0ny/7DZiTyjcatQnmN1qV/jZ+mz/bps1cVRQ/K1JFQKMab76cKP5gARNjhf8PUjQnUxyEF/QBlfMbONiOUw0ACwiDqha4PIrw/QTNZJfU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd8b164-03d7-4925-211a-08d706e3622d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 16:09:56.9522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Chaitanya.Kulkarni@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5992
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/11/19 6:59 PM, Martin K. Petersen wrote:=0A=
> Hi Chaitanya,=0A=
>=0A=
>> +static inline sector_t bdev_nr_sects(struct block_device *bdev)=0A=
>> +{=0A=
>> +	return part_nr_sects_read(bdev->bd_part);=0A=
>> +}=0A=
> Can bdev end up being NULL in any of the call sites?=0A=
>=0A=
> Otherwise no objections.=0A=
>=0A=
Thanks for mentioning that. Initial version which was not posted had=0A=
that check.=0A=
=0A=
This series just replaces the existing accesses without changing anything.=
=0A=
=0A=
So if any of the exiting code has that bug then it will blow up nicely.=0A=
=0A=
For future callers I don't mind adding a new check and resend the series.=
=0A=
=0A=
Would you prefer adding a check  ?=0A=
=0A=
=0A=
