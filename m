Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C45B5DC88
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jul 2019 04:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfGCC3g (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 22:29:36 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37850 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfGCC3g (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 22:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562120976; x=1593656976;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=l+l9DomngQKuSuSJqAgq6wo3tjf1GndxXG/AHhjYVP8=;
  b=WROZVnck5fx6ab8P/N/aDyBANeWCItYb334IcV5q6hdlAA0O5TKatOnh
   SC4fwlcb6aF8Px4Mb8INOlZG/qkTlf0eFuFqgcc8sd1hoMAb4CZUZXwSo
   3aBAqmFKuXPxo8M2rR9abgukMWUK/6btOHp95j/mC0o2HvpzzdSolhToA
   DiLgZmzfu/qKfvAumuweEBlF+0MzEcjJPlv8j2GBECAuL3PW17Ucs+uLU
   1ugClNCNao+KRNTbiae2J32XrOX+bladkT6kF/9rcAWK6T6PEF+y0qP4e
   4R8+tJXhJpBx4/o6D53dwZL6dfVMFIDBGKZMhC90b7HcBeagSTtSnZQPN
   Q==;
IronPort-SDR: RHGJlDbjhGP2ZJcmx+kmVw2eYFmSmXpU6yt5ANml9SA6c3w206y3QQ3qscbRBjpW2D5raJhg6z
 Zu45ggnS24zkMK1d9NvCmJjMka5NeY/6E/5aT9LqR3z+XOMFWqWsSw6VzaOn8ZF6bt/C0rxrts
 c9E+sZRBlWZkEIdaLda6CdvO1YGPcGBrjqaMy5U3HXmVIGKI0x7/E2iSTAh+GTVNMXMEvNMDqM
 zpu6Q6BdIQwRLN0EHp7Onc4SwxumKIVB9Cka//O3ZyVzdiaSbZg1kcl8goKSIIGwHotYI8Z4ib
 im4=
X-IronPort-AV: E=Sophos;i="5.63,445,1557158400"; 
   d="scan'208";a="113301685"
Received: from mail-dm3nam05lp2056.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.56])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 10:29:35 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QTXJPiil0L5APfru6tr55G3cKzXxDERcVNdWAnJ1+U=;
 b=VuCizFLVSFkjRb8Qys9kmFaOSf17rsHCHxzPrPjtSRZnsmbvbAWBxy9w0MMJBACZ49gPy+wQxxi5QEYx+xuLih4aZvmW6XbIb/q2yTkMCD9+mZniQC4Sp3OZJqmmuYPgpnl/26xgxgD/9tBrPkweOpEV+gce5Jkk24fWbYdKfqw=
Received: from DM6PR04MB5754.namprd04.prod.outlook.com (20.179.52.22) by
 DM6PR04MB5388.namprd04.prod.outlook.com (20.178.27.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 02:29:33 +0000
Received: from DM6PR04MB5754.namprd04.prod.outlook.com
 ([fe80::a07d:d226:c10f:7211]) by DM6PR04MB5754.namprd04.prod.outlook.com
 ([fe80::a07d:d226:c10f:7211%6]) with mapi id 15.20.2052.010; Wed, 3 Jul 2019
 02:29:33 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Minwoo Im <minwoo.im.dev@gmail.com>
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
Subject: Re: [PATCH V3 4/9] blk-zoned: update blkdev_reset_zones() with helper
Thread-Topic: [PATCH V3 4/9] blk-zoned: update blkdev_reset_zones() with
 helper
Thread-Index: AQHVMP2kFSOCc0lMzky+P079uDsX6Q==
Date:   Wed, 3 Jul 2019 02:29:33 +0000
Message-ID: <DM6PR04MB5754D27FC41D86E2D419DD6C86FB0@DM6PR04MB5754.namprd04.prod.outlook.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-5-chaitanya.kulkarni@wdc.com>
 <20190703002347.GE15705@minwoo-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [2605:e000:3e45:f500:c10e:84d:47cf:30ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b20f2cc8-ec95-4a6d-0990-08d6ff5e4908
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR04MB5388;
x-ms-traffictypediagnostic: DM6PR04MB5388:
x-microsoft-antispam-prvs: <DM6PR04MB5388E1CEA3083E021D0EE5F286FB0@DM6PR04MB5388.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(189003)(199004)(99286004)(53936002)(6436002)(9686003)(55016002)(71200400001)(7696005)(14454004)(25786009)(7416002)(73956011)(6506007)(54906003)(186003)(71190400001)(53546011)(316002)(476003)(446003)(91956017)(486006)(6246003)(6116002)(102836004)(76176011)(4326008)(6916009)(229853002)(256004)(86362001)(76116006)(66446008)(33656002)(4744005)(68736007)(66556008)(15650500001)(64756008)(8676002)(7736002)(72206003)(46003)(52536014)(478600001)(66946007)(305945005)(8936002)(81156014)(81166006)(2906002)(74316002)(5660300002)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR04MB5388;H:DM6PR04MB5754.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KC9Cpj5oHfF5EMnpjqmMcP38npo0T5L9eJC6PahoMTFVqRqOM043yiIIbBae2Cr5TJjei+hmZJRv2Zu4Joc0WESq+pqAtV8aXaFXsLyjXzQwLcQ/tvkro6CKioO/Ar324Z35QYFQX99OjMJbpr+dsDkdhj4KNcES2acLn1KC3IEYmj2DgcK4/HIfzeaBWFxsiDvGR3kyLO8lvC6S6ffAC1WEaojuIReKVHlzp752yeRuYzt6dheHka5cSZev+k8EY8QDadqJxskC/KW9NEUyPdsshYhaLF8oxkoBxpnnJGCwjtD6tzuBjF66MDYrWpvu2YcJFTno33SnKf6L+ydGlqAUWLlep5bFy+MuyBxQxklvDE0umkY/w4fy+RhE9QIjun8Vi50rWcW+Q2riklIBfgNCCWpYf1HVZq/7xTLYvmM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20f2cc8-ec95-4a6d-0990-08d6ff5e4908
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 02:29:33.4847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Chaitanya.Kulkarni@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5388
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/2/19 5:23 PM, Minwoo Im wrote:=0A=
> On 19-07-02 10:42:30, Chaitanya Kulkarni wrote:=0A=
>> This patch updates the blkdev_reset_zones() with newly introduced=0A=
>> helper function to read the nr_sects from block device's hd_parts with=
=0A=
>> the help of part_nr_sects_read().=0A=
> Chaitanya,=0A=
>=0A=
> Are the first three patches split for a special reason?  IMHO, it could=
=0A=
> be squashed into a single one.=0A=
>=0A=
> It looks good to me, by the way.=0A=
=0A=
In the blk-zoned.c in this way it is easier to bisect if/when the problem=
=0A=
=0A=
comes.=0A=
=0A=
>=0A=
> Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>=0A=
>=0A=
=0A=
