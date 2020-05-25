Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95FA1E065F
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 07:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgEYFZe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 May 2020 01:25:34 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:43978 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgEYFZe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 01:25:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590384333; x=1621920333;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Rxh1lCfB46Ir/pkU3/ab58TAL3tqL8k+Vr8OfyrdoEA=;
  b=LwhTDRGtADIkJoK3MvBaSsOI53V6epUZzcs9VOAg/9ljSQ4GQLoDV3Dn
   Vc8+CfabeCBvtimHtwhPdHEGOJ2o4CDnc4O7bj8M9DrnlrmE4+w62QHRr
   BSqyeuYCbxTztoj60kYsdhxAmfRTa0+VYhsUC7zov5n3bR5h6wy8Xwtnf
   LCP7jUaH+2hFiw5CTZRFtmtekGu60MdZD4aRKXwSZAODlOwNnDIB1O7NT
   u0fWRt+YJBnJacfCiXdOgsa/zDdvWAFy88knIKSMqnTsPtqbzvqXIh/i7
   uP8WP9XuZP1In9gLZB1dO/flHiBM4BR0KbO4JoKocGCyq2vTn1YABuvTz
   Q==;
IronPort-SDR: moaUJb4rqJiY7Z/uckYogw12LT57Bw4JoTgxa3Rbt5oSUZ+P5hcefLc/yHLCUvTGbTU2YS9q73
 Cqf7xvjWA1iJbK346x8op+xgMfKY+8gk+uN9YcN+E4lE57pe3lWdJxSofhuhRoQg7tXnFV0zcR
 q/0y1x6clC3GRuYbSZaFy94ifjehC8cq21fmmHpkf8Te5j2FfnZIxrPArP3zZhF3o1QmprPz9S
 f+smp1qE3xstCltK3Ok6xeLBQFpLxLpIzP2YBLypwOoMynad0q73AWlNLd5mJ/rzFYvASncW9k
 wRo=
X-IronPort-AV: E=Sophos;i="5.73,432,1583164800"; 
   d="scan'208";a="138442206"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2020 13:25:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iemGoGnfRdrCGTxxDOLEYW94Q/QmwBSiR60usNJQScJ7W6DaMvaTsK2/29arRHkCCOCzdkQmpNCgFKO9Y9fReJEg1scDnldtAk8gAtB9o1wqCzlCaJf6hVFUFTuAc6jYM321JbsFK2ZGzTDHornxO0IxKh/lA9P/zSR5WT7CNxvPo8TXrpgdQAeRF9KazrQ4/2YvT/LcnoValx7KPKhuhYt5h56hCSQU59307yIjALNQlwIP+yNeSUKWM6/fwMgiYRGIZPaPU5dphpUdWL0JcvqzJN5bGTCD9T90lsufdnkXeUokWKKt4HWZk8myDd5FSVFQFTcsfwePH+zFka5GBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzINyJ/vPjK87A9fymWMTSsGXkPhbw8W8fOldengIpo=;
 b=aXX+9vDg/XTMrm/l/SMmytReeVLWOz7PLZYnun0bUsXB67olUVKXRu7w6dufYx+vppePO7YsKcvQqh1CCfR4Q9ys/qxQjREHV12V7LBBvwFK0MOjzGQdQNVKDf3GYhN39wbiz+se/E5lFcTyUEn9+WAeK9kITXXDqu1HU6ttQ7zVAtTcdcdNp3X+ZiyML1P2e/ufcK6f1vG4tJfJ2x7f5MEqg56STZWCUugKKdjODs0ONGO2fktIiB85rKk8LPX7PXllckPRkEGW0IpNz4kSxnzWmWf0P8ToD9D690N2/RZQWC7JotqETiXNIt/lbM5Yz4/ZeAGLJ1qRe0ivwL1Irg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzINyJ/vPjK87A9fymWMTSsGXkPhbw8W8fOldengIpo=;
 b=V78CqLIVm8/BcWNrf3xcp8yBZHgKuiDc/Clqf1iuK6Fj9Ty9TNVKmI70CnG4DbrYtUidkieHZvYF140B6ht88qwBKex40bgwgmFJD33tfrid7u6djDRhPH93jTXlIcd0SUBzgO2KkEWRMTtQjzrztdTcTxBrACnGKttCH7HdTao=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0793.namprd04.prod.outlook.com (2603:10b6:903:e5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 05:25:31 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 05:25:31 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/3] bcache: support zoned device as bcache backing
 device
Thread-Topic: [RFC PATCH v4 0/3] bcache: support zoned device as bcache
 backing device
Thread-Index: AQHWMDMsE+l2uspj1kiVJXj7z6QcgQ==
Date:   Mon, 25 May 2020 05:25:31 +0000
Message-ID: <CY4PR04MB3751BEA457F5B95A4D6EFB01E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 71b88bd0-135c-41de-7910-08d8006c0afe
x-ms-traffictypediagnostic: CY4PR04MB0793:
x-microsoft-antispam-prvs: <CY4PR04MB07935C3EB408D89892100BB7E7B30@CY4PR04MB0793.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ne+nyKAdUvul397TB+ViThnJ+cQlHMKL37Ex+sK/tG/30ccRjuczYlyuTpwrlLqyafHpdOzK6I2b7o16vrGrmaLuncOvXVnkgVK/XNcKl/cNNZsIGatXYaqvi+EbY3X5Zwtfz1LaqZvTuhjuTNMJ2MPe1MmVMJDaPGwJm3QsFXYtEKzMj4iAhKwV93CE3GMVtvMtOjD2ZRUrPXc5/cJNqrnhC2X9WEubG6jZooA+y22df1b9mSemvT2y6GsBI2BFGEaoQKunOeL3DajvshxkkFBRsgtCxa+iCBCp1wg74Zs5QmWA7Y89o5FWWkZ3mOgEmGBwbsV7RXF/+dY+GdB8GA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(478600001)(52536014)(64756008)(66446008)(2906002)(66556008)(66476007)(53546011)(110136005)(4326008)(6506007)(8936002)(86362001)(66946007)(76116006)(186003)(9686003)(91956017)(55016002)(33656002)(316002)(8676002)(26005)(71200400001)(5660300002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /SD21VtH3pg3CnNy230KPOw0ZKRqUXdxfcd+potJcxGprPnmC08v3shAjhKU+EbEOJjixd+n0tdpa9vBxAAPDYA5dgiQ8u8nXjtGyPLMFVKR69DCRqz84z4xAd7243p8cJCgqxqbyqh+FS8M6R+tfJG/2W6Gf3hewgoKOmyxl+rZ5OLelshp9uU6RHN87wh2FCfdRJkzvOoiWObua5+rPMXpz6pW4muOVEUocD5R8HaoEJuw3IQZta2f603yQkHBzWPtDgBikRkn/XPXs/Yd+YHFyUEbkVIfnEz6DidSTHNKxY+Kpg4qeTInTs3Xe1d5WiueqYiGzkCF7Q5CuBcEdfNbvFiO1b8Ze/vy+1myAtxgEJUv60mWsjDvFT7wJwlxmGItt0OX8kgAgQpi7yMvGj8a52ZUwg2sE+vfO0bkfWtFu6S3KNFIgf8ORGcB9tsAuIewL/AizxTSqkrkNRXPuwdK2UtV708N60q31Z9ag68=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71b88bd0-135c-41de-7910-08d8006c0afe
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 05:25:31.2473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aFktvGRe+eB5PHyHNjjMwkI1BPRYyq/sHc9jTKAsfA/0vIpHjALn0Gg7X3nh/0u5wDJKZZz/E2vj3RmhMk3kug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0793
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/22 21:19, Coly Li wrote:=0A=
> Hi folks,=0A=
> =0A=
> This is series, now bcache can support zoned device (e.g. host managed=0A=
> SMR hard drive) as the backing deice. Currently writeback mode is not=0A=
> support yet, which is on the to-do list (requires on-disk super block=0A=
> format change).=0A=
> =0A=
> The first patch makes bcache to export the zoned information to upper=0A=
> layer code, for example formatting zonefs on top of the bcache device.=0A=
> By default, zone 0 of the zoned device is fully reserved for bcache=0A=
> super block, therefore the reported zones number is 1 less than the=0A=
> exact zones number of the physical SMR hard drive.=0A=
> =0A=
> The second patch handles zone management command for bcache. Indeed=0A=
> these zone management commands are wrappered as zone management bios.=0A=
> For REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL zone management bios,=0A=
> before forwarding the bio to backing device, all cached data covered=0A=
> by the resetting zone(s) must be invalidated to keep data consistency.=0A=
> For rested zone management bios just minus the bi_sector by data_offset=
=0A=
> and simply forward to the zoned backing device.=0A=
> =0A=
> The third patch is to make sure after bcache device starts, the cache=0A=
> mode cannot be changed to writeback via sysfs interface. Bcache-tools=0A=
> is modified to notice users and convert to writeback mode to the default=
=0A=
> writethrough mode when making a bcache device.=0A=
> =0A=
> There is one thing not addressed by this series, that is re-write the=0A=
> bcache super block after REQ_OP_ZONE_RESET_ALL command. There will be=0A=
> quite soon that all seq zones device may appear, but it is OK to make=0A=
> bcache support such all seq-zones device a bit later.=0A=
> =0A=
> Now a bcache device created with a zoned SMR drive can pass these test=0A=
> cases,=0A=
> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'=0A=
> - read /sys/block/bcache0/queue/nr_zones, content is number of zones=0A=
>   excluding zone 0 of the backing device (reserved for bcache super=0A=
>   block).=0A=
> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size=0A=
>   in sectors.=0A=
> - run 'blkzone report /dev/bcache0', all zones information displayed.=0A=
> - run 'blkzone reset -o <zone LBA> -c <zones number> /dev/bcache0',=0A=
>   conventional zones will reject the command, seqential zones covered=0A=
>   by the command range will reset its write pointer to start LBA of=0A=
>   their zones. If <zone LBA> is 0 and <zones number> covers all zones,=0A=
>   REQ_OP_ZONE_RESET_ALL command will be received and handled by bcache=0A=
>   device properly.=0A=
> - zonefs can be created on top of the bcache device, with/without cache=
=0A=
>   device attached. All sequential direct write and random read work well=
=0A=
>   and zone reset by 'truncate -s 0 <zone file>' works too.=0A=
> - Writeback cache mode does not support yet.=0A=
> =0A=
> Now all prevous code review comments are addressed by this RFC version.=
=0A=
> Please don't hesitate to offer your opinion on this version.=0A=
> =0A=
> Thanks in advance for your help.=0A=
=0A=
Coly,=0A=
=0A=
One more thing: your patch series lacks support for REQ_OP_ZONE_APPEND. It =
would=0A=
be great to add that. As is, since you do not set the max_zone_append_secto=
rs=0A=
queue limit for the bcache device, that command will not be issued by the b=
lock=0A=
layer. But zonefs (and btrfs) will use zone append in (support for zonefs i=
s=0A=
queued already in 5.8, btrfs will come later).=0A=
=0A=
If bcache writethrough policy results in a data write to be issued to both =
the=0A=
backend device and the cache device, then some special code will be needed:=
=0A=
these 2 BIOs will need to be serialized since the actual write location of =
a=0A=
zone append command is known only on completion of the command. That is, th=
e=0A=
zone append BIO needs to be issued to the backend device first, then to the=
=0A=
cache SSD device as a regular write once the zone append completes and its =
write=0A=
location is known.=0A=
=0A=
=0A=
> =0A=
> Coly Li=0A=
> ---=0A=
> Changelog:=0A=
> v4: another improved version without any other generic block change.=0A=
> v3: an improved version depends on other generic block layer changes.=0A=
> v2: the first RFC version for comments and review.=0A=
> v1: the initial version posted just for information.=0A=
> =0A=
> =0A=
> Coly Li (3):=0A=
>   bcache: export bcache zone information for zoned backing device=0A=
>   bcache: handle zone management bios for bcache device=0A=
>   bcache: reject writeback cache mode for zoned backing device=0A=
> =0A=
>  drivers/md/bcache/bcache.h  |  10 +++=0A=
>  drivers/md/bcache/request.c | 168 +++++++++++++++++++++++++++++++++++-=
=0A=
>  drivers/md/bcache/super.c   |  98 ++++++++++++++++++++-=0A=
>  drivers/md/bcache/sysfs.c   |   5 ++=0A=
>  4 files changed, 279 insertions(+), 2 deletions(-)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
