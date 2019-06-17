Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128934897B
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 18:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfFQQ6U (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Jun 2019 12:58:20 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44730 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfFQQ6U (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Jun 2019 12:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560790727; x=1592326727;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=UxamKKNUM1HouZ2FpNqaJTSa/J0NGyoAPy/BXUR6Vq4=;
  b=CJfT7KrJS1R/kdZHejgotRLhdU4kJ8WOMe/uZD7x1eztqnRNvABRoTAt
   M5R6/41UhJYjldols03u7YJs0zqXSL3rvEuq83OPbPONWOPB2RIVZSMyT
   KMjCrbQ7DeiUKPt/tLCGWulCMT5w2YXCZMnm8Nr39yH9N63ubj3jwHeh0
   QBliCsvCHCKpHe2fd1TzUzsHnuT9qtPoNZNSL+V0Weq5ppZNIuC0NnLJa
   +j+1UX2+qsyN3uXjvT1CewkyDldGvZrDPXXZJNVaiYsfzV6cP9PejDGoJ
   LwhQdRNy7pfj6trt5wS7lte8irBb2JJ6HXxZwR0agk7QmtLGVGy/gbTyy
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,386,1557158400"; 
   d="scan'208";a="210505559"
Received: from mail-by2nam01lp2057.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.57])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2019 00:58:46 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LnEXobAEDD3kMcUUpHAAZnB+d/TtghbOhcca1v2N+/Q=;
 b=j5guyA1jwi3W1tUkpMO1BvdvL7B2g8u+EZ+h/FviMAV4xt6qcR5+1QmN+Vesfevw7/ri1dQZtn9EflKdEHdvurg6TIH2DyibUovYuTbjcXCL0W2Fb/GgIATv9Nzuf+Woys0QtqtcOyvRzy8lsYL1NVc3YCcgiYxY6WCOZRy+t6Q=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.58.26) by
 BYAPR04MB4005.namprd04.prod.outlook.com (52.135.215.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Mon, 17 Jun 2019 16:58:18 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fc2b:fcd4:7782:53d6%7]) with mapi id 15.20.1987.012; Mon, 17 Jun 2019
 16:58:18 +0000
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
Date:   Mon, 17 Jun 2019 16:58:18 +0000
Message-ID: <BYAPR04MB5749B6308E645ECEBD5F63E486EB0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
 <a5a43553-69f1-fb99-fbfe-d0cb676a6cfa@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f163c262-96b7-488d-0f46-08d6f344ff51
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4005;
x-ms-traffictypediagnostic: BYAPR04MB4005:
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB40051570074069607808DFC586EB0@BYAPR04MB4005.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(346002)(366004)(396003)(199004)(189003)(99286004)(3846002)(53936002)(73956011)(316002)(476003)(4326008)(66556008)(66476007)(66066001)(110136005)(102836004)(66946007)(14454004)(6246003)(478600001)(14444005)(66446008)(52536014)(256004)(8936002)(25786009)(5660300002)(486006)(2501003)(9686003)(71200400001)(74316002)(76176011)(71190400001)(7696005)(6116002)(68736007)(81156014)(86362001)(81166006)(8676002)(305945005)(7736002)(446003)(53546011)(229853002)(26005)(33656002)(64756008)(186003)(55016002)(2906002)(6506007)(72206003)(54906003)(76116006)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4005;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ijdDTiFmD5a4tk24QVqTLEYY1W1uMwjaWv9GJr05+/SO9iSZGmO6rOBwwTNyDucXE5ixU+qegrk1bQ1euQ6RrQgrRh7LbV7xwQMQ1r3YEB8/rjDcsxK//udH8iCwI/tyQG9Ays61arv5lohb5CfZv9UQdILpp7Q0Ck7bByfJW0D+TRco3dXXaDwQ7QxQXTtamdXHnDaCN7j/dcVhsvACchpVKpZ1jWM5bvcPSoJ+1rAg9tzFefTSSonvTFPSdfjxFkkYgnpxyCMnDTvRMzx0vxVryojJ72mfrTsbJQmZ0KatTEgLaeJOuudFducEoB7tAqvw4MyOFNciBGZRKsxnw5f0P0hxyZ8k3lWhzGD6mczXLBZo3D07lOUh6MOwjaf4rI+63bKpU9BIg2bto4ypdcEQtB+LmXvVEVR+dsTbqMw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f163c262-96b7-488d-0f46-08d6f344ff51
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 16:58:18.4123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Chaitanya.Kulkarni@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4005
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 06/17/2019 08:53 AM, Bart Van Assche wrote:=0A=
> On 6/16/19 6:28 PM, Chaitanya Kulkarni wrote:=0A=
>> Changes from V1:-=0A=
>>=0A=
>> 1. Drop the target_pscsi patch. (Bart)=0A=
>> 2. Remove rcu locking which is not needed. (Bart)=0A=
>>=0A=
>> Chaitanya Kulkarni (7):=0A=
>>     block: add a helper function to read nr_setcs=0A=
>>     blk-zoned: update blkdev_nr_zones() with helper=0A=
>>     blk-zoned: update blkdev_report_zone() with helper=0A=
>>     blk-zoned: update blkdev_reset_zones() with helper=0A=
>>     bcache: update cached_dev_init() with helper=0A=
>>     f2fs: use helper in init_blkz_info()=0A=
>>     blktrace: use helper in blk_trace_setup_lba()=0A=
>>=0A=
>>    block/blk-zoned.c         | 12 ++++++------=0A=
>>    drivers/md/bcache/super.c |  2 +-=0A=
>>    fs/f2fs/super.c           |  2 +-=0A=
>>    include/linux/blkdev.h    | 10 ++++++++++=0A=
>>    kernel/trace/blktrace.c   |  2 +-=0A=
>>    5 files changed, 19 insertions(+), 9 deletions(-)=0A=
>=0A=
> My feedback about the pscsi_get_blocks() was misleading: what I meant is=
=0A=
> that it is not necessary to introduce RCU locking in that function. I=0A=
> think that using bdev_nr_sects() or part_nr_sects_read() to read=0A=
> nr_sects in that function is useful.=0A=
>=0A=
My bad. I'll add pscsi patch.=0A=
> Is there any reason that the following Xen macro has not been converted?=
=0A=
>=0A=
> #define vbd_sz(_v)	((_v)->bdev->bd_part ? \=0A=
> 			 (_v)->bdev->bd_part->nr_sects : \=0A=
> 			  get_capacity((_v)->bdev->bd_disk))=0A=
>=0A=
I'll convert this too and appropriate mailing list.=0A=
=0A=
Thanks Bart again for detailed feedback.=0A=
> Thanks,=0A=
>=0A=
> Bart.=0A=
>=0A=
=0A=
