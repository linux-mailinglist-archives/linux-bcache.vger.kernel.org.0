Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BEE5A6A2
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 23:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfF1V4z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 17:56:55 -0400
Received: from mail-eopbgr720080.outbound.protection.outlook.com ([40.107.72.80]:23296
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726557AbfF1V4z (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 17:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantum.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MF2+l+Ikbg5zt23ohTFYXOdr9hZu5pNSHRbi4pZgvSM=;
 b=ZGll/ewBML5CTWEVHBxKZ7aezdwzwgRo3vD5K9K6OLUE4yEDiPbA5HoziMvrZrNjWK667ymJhEjAa6eDciTlwizBpeSVwAeT8MCaEHUxxRgaLclvigeAhoM2sLwrKvT5dnXuLZT33IrGJqoMtn4Zyjl1sbcQgHkShfFnAXS+S+0=
Received: from BYAPR14MB2776.namprd14.prod.outlook.com (20.178.196.154) by
 BYAPR14MB2550.namprd14.prod.outlook.com (20.178.53.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Fri, 28 Jun 2019 21:56:52 +0000
Received: from BYAPR14MB2776.namprd14.prod.outlook.com
 ([fe80::183c:86b5:f0d6:8e29]) by BYAPR14MB2776.namprd14.prod.outlook.com
 ([fe80::183c:86b5:f0d6:8e29%5]) with mapi id 15.20.2032.018; Fri, 28 Jun 2019
 21:56:52 +0000
From:   Don Doerner <Don.Doerner@Quantum.Com>
To:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: I/O Reordering: Cache -> Backing Device
Thread-Topic: I/O Reordering: Cache -> Backing Device
Thread-Index: AdUt/B/EabqHZCkOQoe8heP9RPaOEA==
Date:   Fri, 28 Jun 2019 21:56:51 +0000
Message-ID: <BYAPR14MB27766E20D92C2A07217C2DF9FCFC0@BYAPR14MB2776.namprd14.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Don.Doerner@Quantum.Com; 
x-originating-ip: [73.158.192.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45e7d956-03c2-466e-bf98-08d6fc13872b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR14MB2550;
x-ms-traffictypediagnostic: BYAPR14MB2550:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR14MB2550CD71226649C691BCB3A0FCFC0@BYAPR14MB2550.namprd14.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(189003)(199004)(55016002)(5024004)(14444005)(478600001)(71200400001)(71190400001)(8676002)(6116002)(486006)(73956011)(6506007)(66946007)(64756008)(76116006)(102836004)(66476007)(66556008)(256004)(66446008)(26005)(81166006)(476003)(66066001)(99286004)(305945005)(7696005)(186003)(68736007)(2501003)(53936002)(81156014)(8936002)(74316002)(7736002)(316002)(2906002)(6916009)(2351001)(33656002)(5660300002)(25786009)(52536014)(6436002)(3846002)(9686003)(5640700003)(72206003)(14454004)(86362001)(6306002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR14MB2550;H:BYAPR14MB2776.namprd14.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: Quantum.Com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ggGk0allSMs0saIlsYeNkC/RTjmus3ZcarWgBuvcW/JArXj6xMnd8WxzcKuu7d3ynoUd2nf4yq0ibsqc3mjhbpHnB/WMRyEo2qV2xTN7DHOw4Run/XKBPOZzgKl4RzbGv3bpzUiZSBSMucTl7qzpjd1xyNEN+30FP9t0nU0LULkxeGD1Push/hzgsRBNjMxbDPMBoPmNKis/18JP+MxtPF1XOlq/P+8D+9FGM9EnB1C8jla4jI9inMwxot7BA1zFXzLB18iT8NCSvKgO1faBpOsSQLEKtJR6vpI0myDbOAjQW+RArPNOEs1CQvK9WogyzFXrkl+MXXBEo69ynK/f89zyt32VB9T+uJRBCLnVxHS2IRU/J2psFVYiJuBaZW6q0K5Zz7u9KSW/ap2k/DDnlM5nm60Tuu41x47iVlnAbOk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantum.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e7d956-03c2-466e-bf98-08d6fc13872b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 21:56:51.9744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 322a135f-14fb-4d72-aede-122272134ae0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Don.Doerner@Quantum.Com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR14MB2550
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,
I'm also interested in using bcache to facilitate stripe re-ass'y for the b=
acking device.  I've done some experiments that dovetail with some of the t=
raffic on this mailing list.  Specifically, in this message (https://www.sp=
inics.net/lists/linux-bcache/msg07590.html), Eric suggested "...turning up =
/sys/block/bcache0/bcache/writeback_percent..." to increase the contiguous =
data in the cache.
My RAID-6 has a stripe size of 2.5MiB, and its bcache'ed with a few hundred=
 GB of NVMe storage.  Here's my experiment:
* I made the cache a write back cache: echo writeback > /sys/block/bcache0/=
bcache/cache_mode
* I plugged the cache: echo 0 > /sys/block/bcache0/bcache/writeback_running
* I use a pathological I/O pattern, generated with 'fio': fio --bs=3D128K -=
-direct=3D1 --rw=3Drandwrite --ioengine=3Dlibaio --iodepth=3D1 --numjobs=3D=
1 --size=3D40G --name=3D/dev/bcache0.  I let it run to completion, at which=
 point I believe I should have 40 GiB of sequential dirty data in cache, bu=
t not put there sequentially.  In essence, I should have ~16K complete stri=
pes sitting in the cache, waiting to be written.
* I set stuff up to go like a bat: echo 0 > /sys/block/bcache0/bcache/write=
back_percent; echo 0 > /sys/block/bcache0/bcache/writeback_delay; echo 2097=
152 > /sys/block/bcache0/bcache/writeback_rate
* And I unplugged the cache: echo 1 > /sys/block/bcache0/bcache/writeback_r=
unning
I then watched 'iostat', and saw that there were lots of read operations (s=
tatistically, after merging, about 1 read for every 7 writes) - more than I=
 had expected... that's enough that I concluded it wasn't building full str=
ipes.  It kinda looks like it's playing back a journal sorted in time then =
LBA, or something like that...
Any suggestions for improving (reducing) the ratio of reads to writes will =
be gratefully accepted!
Don Doerner
Technical Director, Advanced Projects
Quantum Corporation

Thanks,

-don-

The information contained in this transmission may be confidential. Any dis=
closure, copying, or further distribution of confidential information is no=
t permitted unless such privilege is explicitly granted in writing by Quant=
um. Quantum reserves the right to have electronic communications, including=
 email and attachments, sent across its networks filtered through security =
software programs and retain such messages in order to comply with applicab=
le data security and retention requirements. Quantum is not responsible for=
 the proper and complete transmission of the substance of this communicatio=
n or for any delay in its receipt.
