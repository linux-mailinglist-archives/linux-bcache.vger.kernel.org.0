Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDE8114CD6
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 08:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfLFHmi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 02:42:38 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:27975 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfLFHmi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 02:42:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575618158; x=1607154158;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=BibBYyXue2e9UCXy35adYZIqTPoafTTlUHWccDeUm/I=;
  b=SeELBseZpOfMa3Nkc5BcUEO0Q9YnAf4XOo4fwoOgGTdplMvLq3KVZojD
   Fo/hC6wZaAL9VH6fSKu3VmNbSfFhXRzrpgzFhtJw65Rvn87tAGiCpIdd6
   GgVPQZKqfq7wEqj0229gPVW4L5FSZBEEnODIFdhM4wN3SxmSxO0tCM/n4
   /AbwWMfqxtrlNHRxyqIhlmTYfrJpIoFBnXUP9Hu8Pb91aL91K09Ckl3K7
   ic6s4NsOnUMjpjuehY0PtQ3uG0WiV3BIObMqZ6yvLqKNcE0Sajp9rxtsv
   ZKLp9sxCfAY/EbOFDAsiO2rDauU1C94nU33/m+3HbTHow1wImccNCMMJP
   g==;
IronPort-SDR: Qq2S0fNLSa0ATQUGzvWaAMKUwIs4dXTWyMjiXn60He3B23CL14xQ3lsf5knDIyr8YQBBmKH7kz
 kOuD3TU9qlNk62JP+n1Gw4xAovbS4vOMo/34opwIL5dFrs1coNQH+pzJm4PkjMA2UDGU9lg9JN
 OtIeKfcaXkTVhke4FhxnkUaskAqSySf/bfJ+pMCWIrSllR43TgmSjeUXjlkfSDTnkBbeHVmZRN
 qXCTgopw1XpaJwT5mnXoE6QiE5XgEGY1XhzL1f/4p88rkgc5wQx6GPwTEipK/rp+UESQbqoijp
 2q4=
X-IronPort-AV: E=Sophos;i="5.69,283,1571673600"; 
   d="scan'208";a="126368826"
Received: from mail-sn1nam04lp2056.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.56])
  by ob1.hgst.iphmx.com with ESMTP; 06 Dec 2019 15:42:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQa5fHl/kqqqAA7Cg1No8zTMXDTC2XpfaDw1TQNww9e53zCq0yOeuPDnPaSJRsqfeNg5TVt7payRBoSev1zVvACLtSzaBC26eI+ZZEgWTnou3zYTzm9yERB7E9nvX7VnNh4i+6Vua1RaU8FDJkIqsvghdo6OJvH0yknxXakzCj1U4O4G8Ty6uKNTZB6U0Co1YpSlO90rvu4TB3zuM7Ks8AETBcYAdgsXqfaHiJTqPWkJ7TP9o/6AoUqlcUuFFqF5hwIHp8nOAlcdIfLLviv4LieNUY0gjdSFGia29ibQf/40Z1g98CS4ajE6clRJpFU085a6Ah7Kp/iXha+JfqiuMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDXTq++2Ch4EvLcuTkd5bHDIix17cxKSgB3X+Znis/I=;
 b=QFJ0o0ZZClbZs4nYZaPDhUjls7vG6FPZNb24V0vDroBBtHhSMAYZLQ26FmYjDXMjHnAqL69P1FA4p5+bSNLD2MkpK11O6+AgBbVLWeJq0g0Eqv6RhIb1ackBP58pOjJgzEcRlRU7XxPNpK5285sKG6BsLX7AYNh2E87OCm6k5C5dOJaGVmk/8cFS++2G+y6kTPIPA6XrVaWCtLjtTuDmQE0e24zhsDRZTP3aYEnHVpVU70pZcqZhVsIaYg0imPIa86kOdqzrQvQRS052qeC1JIP3N2NVedlde2oU3VTKTGMdAU1KBvLGjVJXtpZeQ1m8ur+7oOeAbWb5Iszi5XhK2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDXTq++2Ch4EvLcuTkd5bHDIix17cxKSgB3X+Znis/I=;
 b=snfFkJXbz8LfMYRGCN1uFnlQHqRIRv353gk3H5ytBLeKQNRvsUfgJ8eJggD8N2pA7lpx6cnGQuPZUGuYvJgvtH85VfqL1Cx/N3Ch2TtkU2sIvW+QGouQdZ8YjVAFLKAxzm0o1EbeSglTP+tydGgqu4PYq4hu7xrM1zGLoBJO99A=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4918.namprd04.prod.outlook.com (52.135.233.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Fri, 6 Dec 2019 07:42:35 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::f0e9:c12:647d:2aae]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::f0e9:c12:647d:2aae%4]) with mapi id 15.20.2495.026; Fri, 6 Dec 2019
 07:42:35 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>, Coly Li <colyli@suse.de>,
        Eric Wheeler <bcache@lists.ewheeler.net>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [RFC PATCH] bcache: enable zoned device support
Thread-Topic: [RFC PATCH] bcache: enable zoned device support
Thread-Index: AQHVq4BK89W6d1xR0kigtgr1jyyJ1w==
Date:   Fri, 6 Dec 2019 07:42:34 +0000
Message-ID: <BYAPR04MB5816E7F7741B3DC8D1B3B759E75F0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191205152543.73885-1-colyli@suse.de>
 <alpine.LRH.2.11.1912060012380.11561@mx.ewheeler.net>
 <BYAPR04MB5816090B934A7CA17EFA688AE75F0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <a21ce3de-5591-198f-56bf-8dc3aee6c926@suse.de>
 <66345af3-fad6-3079-1604-3b0e9d2779ce@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ecb6642f-b766-42bb-8168-08d77a1fdc2b
x-ms-traffictypediagnostic: BYAPR04MB4918:
x-microsoft-antispam-prvs: <BYAPR04MB4918A8E62A21FC11EBBD0069E75F0@BYAPR04MB4918.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0243E5FD68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(199004)(189003)(5660300002)(54906003)(6506007)(76176011)(186003)(25786009)(99286004)(64756008)(66556008)(86362001)(316002)(53546011)(102836004)(55016002)(478600001)(91956017)(66946007)(14454004)(76116006)(66446008)(110136005)(26005)(66476007)(2906002)(71200400001)(14444005)(81166006)(52536014)(81156014)(33656002)(8936002)(8676002)(7696005)(71190400001)(305945005)(74316002)(561944003)(9686003)(4326008)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4918;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mJGvv9mY4eadxPmOo0iKb19N7CNJ+TOlW94YUqDPh8XutPnG5V2ycE9ZbkMWuipFwbwwH/NsdlnTTTcdRPMglamm6+6aPYQ0ZeCCSBnYnEPbVtKhpcVeLMSAb0okKN93Tbt0gldBxOWTnp4ugzjtAR0fXKUORK9PZbW8l82XnlInfkOWq+3HX56nbi7zHWXv9MIPqsD4XndhK+cR7NVV8K4CblyZBFJmKt0LgBgGKdz83+BtLa91aK/PuchkuXMmKrLU0WuHkHD0+il5JYtyU2mcdYR40NVbUlBR8+1CBXJ8cOzE7bs0vpj4KBUMYswIhKwi4drkQNmTcXxPmsVc1ievEpYJWBsb23dI76rF2bv5eX2FV8LiER1vWe/NzyfkD6xjt3rQGVkPUfSo92KrDl9Xehw0euglq+dlOJouNEwaQBU7aHuvwDUNXEL7v6B8
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb6642f-b766-42bb-8168-08d77a1fdc2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2019 07:42:34.9819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mXTTMRZGbcLLyLEwxQbNBHqINg6wamIAvJWs1DcRHhUywGJo/8ncAIzNaaszGvo78Wyt38Ylz4zkkw2VKfYn1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4918
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/06 16:09, Hannes Reinecke wrote:=0A=
> On 12/6/19 5:37 AM, Coly Li wrote:=0A=
>> On 2019/12/6 8:30 =1B$B>e8a=1B(B, Damien Le Moal wrote:=0A=
>>> On 2019/12/06 9:22, Eric Wheeler wrote:=0A=
>>>> On Thu, 5 Dec 2019, Coly Li wrote:=0A=
>>>>> This is a very basic zoned device support. With this patch, bcache=0A=
>>>>> device is able to,=0A=
>>>>> - Export zoned device attribution via sysfs=0A=
>>>>> - Response report zones request, e.g. by command 'blkzone report'=0A=
>>>>> But the bcache device is still NOT able to,=0A=
>>>>> - Response any zoned device management request or IOCTL command=0A=
>>>>>=0A=
>>>>> Here are the testings I have done,=0A=
>>>>> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'=0A=
>>>>> - read /sys/block/bcache0/queue/nr_zones, content is number of zones=
=0A=
>>>>>   including all zone types.=0A=
>>>>> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size=
=0A=
>>>>>   in sectors.=0A=
>>>>> - run 'blkzone report /dev/bcache0', all zones information displayed.=
=0A=
>>>>> - run 'blkzone reset /dev/bcache0', operation is rejected with error=
=0A=
>>>>>   information: "blkzone: /dev/bcache0: BLKRESETZONE ioctl failed:=0A=
>>>>>   Operation not supported"=0A=
>>>>> - Sequential writes by dd, I can see some zones' write pointer 'wptr'=
=0A=
>>>>>   values updated.=0A=
>>>>>=0A=
>>>>> All of these are very basic testings, if you have better testing=0A=
>>>>> tools or cases, please offer me hint.=0A=
>>>>=0A=
>>>> Interesting. =0A=
>>>>=0A=
>>>> 1. should_writeback() could benefit by hinting true when an IO would f=
all =0A=
>>>>    in a zoned region.=0A=
>>>>=0A=
>>>> 2. The writeback thread could writeback such that they prefer =0A=
>>>>    fully(mostly)-populated zones when choosing what to write out.=0A=
>>>=0A=
>>> That definitely would be a good idea since that would certainly benefit=
=0A=
>>> backend-GC (that will be needed).=0A=
>>>=0A=
>>> However, I do not see the point in exposing the /dev/bcacheX block=0A=
>>> device itself as a zoned disk. In fact, I think we want exactly the=0A=
>>> opposite: expose it as a regular disk so that any FS or application can=
=0A=
>>> run. If the bcache backend disk is zoned, then the writeback handles=0A=
>>> sequential writes. This would be in the end a solution similar to=0A=
>>> dm-zoned, that is, a zoned disk becomes useable as a regular block=0A=
>>> device (random writes anywhere are possible), but likely far more=0A=
>>> efficient and faster. That may result in imposing some limitations on=
=0A=
>>> bcache operations though, e.g. it can only be setup with writeback, no=
=0A=
>>> writethrough allowed (not sure though...).=0A=
>>> Thoughts ?=0A=
>>>=0A=
>>=0A=
>> I come to realize this is really an idea on the opposite. Let me try to=
=0A=
>> explain what I understand, please correct me if I am wrong. The idea you=
=0A=
>> proposed indeed is to make bcache act as something like FTL for the=0A=
>> backend zoned SMR drive, that is, for all random writes, bcache may=0A=
>> convert them into sequential write onto the backend zoned SMR drive. In=
=0A=
>> the meantime, if there are hot data, bcache continues to act as a=0A=
>> caching device to accelerate read request.=0A=
>>=0A=
>> Yes, if I understand your proposal correctly, writeback mode might be=0A=
>> mandatory and backend-GC will be needed. The idea is interesting, it=0A=
>> looks like adding a log-structure storage layer between current bcache=
=0A=
>> B+tree indexing and zoned SMR hard drive.=0A=
>>=0A=
> Well, not sure if that's required.=0A=
> =0A=
> Or, to be correct, we actually have _two_ use-cases:=0A=
> 1) Have a SMR drive as a backing device. This was my primary goal for=0A=
> handling these devices, as SMR device are typically not _that_ fast.=0A=
> (Damien once proudly reported getting the incredible speed of 1 IOPS :-)=
=0A=
=0A=
Yes, it can get to that with dm-zoned if one goes crazy with sustained=0A=
random writes :) The physical drive itself does a lot more than 1 iops=0A=
in that case though and is as fast as any other HDD. But from the DM=0A=
logical drive side, the user can sometimes fall into the 1 iops=0A=
territory for really nasty workloads. Tests for well behaved users like=0A=
f2fs show that SMR and regular HDDs are on par for performance.=0A=
=0A=
> So having bcache running on top of those will be a clear win.=0A=
> But in this scenario the cache device will be a normal device (typically=
=0A=
> an SSD), and we shouldn't need much modification here.=0A=
=0A=
I agree. That should work mostly as is since the user will be zone aware=0A=
and already be issuing sequential writes. bcache write-through only=0A=
needs to follow the same pattern, not reordering any write, and=0A=
write-back only has to replay the same.=0A=
=0A=
> In fact, a good testcase would be the btrfs patches which got posted=0A=
> earlier this week. With them you should be able to create a btrfs=0A=
> filesystem on the SMR drive, and use an SSD as a cache device.=0A=
> Getting this scenario to run would indeed be my primary goal, and I=0A=
> guess your patches should be more or less sufficient for that.=0A=
=0A=
+ Will need the zone revalidation and zone type & write lock bitmaps to=0A=
prevent reordering from the block IO stack, unless bcache is a BIO=0A=
driver ? My knowledge of bcache is limited. Would need to look into the=0A=
details a little more to be able to comment.=0A=
=0A=
> 2) Using a SMR drive as a _cache_ device. This seems to be contrary to=0A=
> the above statement of SMR drive not being fast, but then the NVMe WG is=
=0A=
> working on a similar mechanism for flash devices called 'ZNS' (zoned=0A=
> namespaces). And for those it really would make sense to have bcache=0A=
> being able to handle zoned devices as a cache device.=0A=
> But this is to my understanding really in the early stages, with no real=
=0A=
> hardware being available. Damien might disagree, though :-)=0A=
=0A=
Yes, that would be another potential use case and ZNS indeed could fit=0A=
this model, assuming that zone sizes align (multiples) between front and=0A=
back devices.=0A=
=0A=
> And the implementation is still on the works on the linux side, so it's=
=0A=
> more of a long-term goal.>=0A=
> But the first use-case is definitely something we should be looking at;=
=0A=
> SMR drives are available _and_ with large capacity, so any speedup there=
=0A=
> would be greatly appreciated.=0A=
=0A=
Yes. And what I was talking about in my earlier email is actually a=0A=
third use case:=0A=
3) SMR drive as backend + regular SSD as frontend and the resulting=0A=
bcache device advertising itself as a regular disk, hiding all the zone=0A=
& sequential write constraint to the user. Since bcache already has some=0A=
form of indirection table for cached blocks, I thought we could hijack=0A=
this to implement a sort of FTL that would allow serializing random=0A=
writes to the backend with the help of the frontend as a write staging=0A=
buffer. Doing so, we get full random write capability with the benefit=0A=
of "hot" blocks staying in the cache. But again, not knowing enough=0A=
details about bcache, I may be talking too lightly here. Not sure if=0A=
that is reasonably easily feasible with the current bcache code.=0A=
=0A=
Cheers.=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
