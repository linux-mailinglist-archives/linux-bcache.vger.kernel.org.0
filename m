Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775CD1CD234
	for <lists+linux-bcache@lfdr.de>; Mon, 11 May 2020 09:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgEKHFu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 11 May 2020 03:05:50 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:24294 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgEKHFt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 11 May 2020 03:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589180750; x=1620716750;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=YWQ6CDaPMueXFCRj/De1NaWIdMQ/x2hQvlSj4H1Hq4I=;
  b=Fzdynx1YO6Ls9IRHgy1piRnBf2IUuvfnpGLAIOerHDmfpuhiOG2ybsKK
   o7RUCUayxuysABRJLf+7GEXptDjaz6+K0eJCsli+Vrm6WugOBbLv4rzBe
   PRlu6IIDZIINuIJbyUSLfFT5OgOvgyKP7tVoF9G/Tkfuth4V1htS8mE9A
   RbgM+WFDNVUlLa8+xaDD7QTA+rwG9/nPUSCMg4Mi1s91MFcM+1at6OafL
   TmqCAzFWKhwe3PDGOyVjtnQ+5JmtpMRZEBdoP6HEqMzdp6EZNVJMiQrHu
   OE6m4VOi6+cXyelEeMxvTC0r3taJzUcaPsLUTEZgCcI9QLjES84M6TyHj
   w==;
IronPort-SDR: 34KIRePOn3yIHY70lBi6UX0/L0M6atBE3ZwqAIji361lsWYbLCYsRdM/btczZabOi9R9gM7j/x
 JXjzOW+gpmNwBFhSX+fu5FxWbPUITF8XImGs0y8eOwJv6hZmtg5KTIgTM5aLtQbVkTQiAIrN30
 cSsk8x6aXh2h1F0i8Me6KePxzvT8mXoF7ZmhPEfmbbYSfHmsuqb9eVT8E5Wv6mOKetb9gbOkBO
 m2cpl03p226RiUTbqrtmYFMYTN84Vsk0m7iOEgs/LWmyVyFt/WR0Qer6akCpiaHCWT1MerU2kC
 TYw=
X-IronPort-AV: E=Sophos;i="5.73,378,1583164800"; 
   d="scan'208";a="240067933"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
  by ob1.hgst.iphmx.com with ESMTP; 11 May 2020 15:05:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wf9ypWILZl+RAOehdr0c8JsqJzJHq0ZV39vFxZJi2oruowvZpJRwW8tnzrmOPdTpPvaxBOy32BB0LO+We2c9IUMPAAFBRAaAPQ5aItwhF85n4GltpB6t1zYUWcj2NmBb85mvxqqqyxDHae2bZzdJeKH8Oz6SD7cZ5eYAXmvJfUZHO8mFtgQAJDLLHtQcXI+EV7JIUDQih/gexSwmL24MTzo+cCcGtPO7G20PkLvqlAtSGvG0atp6W09LosXPjrrE+W+6ko3NMXcJL2hUC1SNLj6cmVfLDN/Tl9LAf++PRkxLSibLaDaA0OCWp1h9R7/VXDoJwi4n44jtGojWzhM9Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9D/uVGa19SHG6jeYBgDPnj5gH3L9Ehper08lv/cUAV0=;
 b=lzMK8xpCVTgtZixojW01MSedAdhriapVSDf1XiUMDpXRJ6YdH2lYxy25ojucU2oiyg+BkScz9GHQI/TbY+mSCbcwvasDrU7YCx10pofNVjZ3f/KsPJo/TM7iac3vzglnkUZGBWr+M5EW+n9VcOOP9CDKsKed/UmvehUs0iXaYe/6IdctjPt0wChmemApJL24ff6u01U7UYy2rW+ABXhEHMn/+jc4+E3t55J+FaMaZWRjMFz6lLd0S+2ocNYC7C/3xfImGvFTjF5T7nIRpQDeoXE1MT9/Em/GDi11JBvvuSqbYHyNNNOjlVv7xWdMw28fnh8ghntQq9fhpEO6OW+Uxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9D/uVGa19SHG6jeYBgDPnj5gH3L9Ehper08lv/cUAV0=;
 b=dZsmZ4bjJv/nEGaFhlURuoHGBmI4P7kVtW+A5wnaSimQB5LohZ2OIsoKCVJGJSVbSfG9tEc0BCJSvtx+hiJ7prbp9fxWwgOCsVuR4tOzh05Y9i7NyjVgxpLEOmUgMhyt3WR7xNXMtQtKTsKa4Cq/66En2DX/2JE14Bo8RpxSGkk=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6690.namprd04.prod.outlook.com (2603:10b6:a03:22c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Mon, 11 May
 2020 07:05:45 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%6]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 07:05:45 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [RFC PATCH v2] bcache: export zoned information for backing
 device
Thread-Topic: [RFC PATCH v2] bcache: export zoned information for backing
 device
Thread-Index: AQHWJutu5ptgM2PW10WdzDNgRnzbBg==
Date:   Mon, 11 May 2020 07:05:45 +0000
Message-ID: <BY5PR04MB6900FDDF5B6281B10B940986E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200510165232.67500-1-colyli@suse.de>
 <db0b8463-4402-41c9-e15c-76eed585caf1@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6289ac81-b28d-4224-92a5-08d7f579ba25
x-ms-traffictypediagnostic: BY5PR04MB6690:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB6690B5FA48D1DE96DCAB8DE5E7A10@BY5PR04MB6690.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04004D94E2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kMPh94SzgXCboxjh1eNmrtRdLoAFx+GUcoam3JNkxxv2hak/bFvTDNF1oUFpY5I0bjaMtyOuBKNolV+28p2dspMb54Ii2dx9V8B1bChJEfTdQXfZEIXjQ9/j38lEOOHyccR7ncXisFdUgv5P93CccJhKqydlYqXqmDINfLvbsGFvIvalkpTXhd+d6jWvWfURz0qaB367IJsqB+LRGbDfOtXJZBhLJ8ozfyiDwNrKfjCJ5LPvk3ZDDCEm0y8p3vbgloIH5ZQflLf0Fmrdb/3zxk/DJ4ObnDIRve51UegLJ8lmyC7VGtSvfoa39votB9nLWhuIYCfmhSj6lNMXTqv4P/xG8CrtE2M45xjNxyrRJ4KNAzjxU6W7VwI6Pzl1hwu6ahA0RCx+S+Q6yVqP8kHiFxwRHA/sQxuRX4WvAEBTtrf+1dtD0ABWGw60eXIYtBBkV6aSOxMtj4kk1pTXruSl9QyAmf4uQ5Hdb8Xgnum+AVbhyMC1ZvKvzLylXPfnlfnujFTPJJFGtONUAliGfqYlhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(33430700001)(33656002)(316002)(55016002)(26005)(186003)(9686003)(53546011)(6506007)(2906002)(33440700001)(4326008)(110136005)(54906003)(478600001)(8676002)(52536014)(71200400001)(66476007)(66556008)(64756008)(66446008)(5660300002)(7696005)(76116006)(6636002)(66946007)(8936002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aIbyzMUfEkNSqlZNKFPyX4ZaaYjoxluqArU0QN2ualDqNa4HIiVD99yBb0pKWV0dNTL3NWGqXew1Ij4osBwCxzxxe6MyYB2cIKQHO3FvTKhujgZsr8po850aFsUgLgzM8jPJp9Ecko2wXzZlF9ts8/vMkQZrPl52NcABSIUJm31nZmIoZhaU8R+e5bP75lpLcZA0yd6V13pLjtqHAlcelV5EmbW+TIKYR7GKeZAysd0cek2tIQfrHHqIVsYcfnXxPXTzxar+NqhE350a+Sn1vo4/OZhF0CULky7aSN+DNRLe6PEu7V0biaVm7WXw5zSno+/nv00ZRRPBc3GOnD16MBlIdjd+mqb7xykMrIPkxFQou8BcmGLJGeg/oJTnbeeUYlmhI/1mEE8dLT1Ibz/UWfzp28lTlZbytFw2kL/2jbZ6LjGlaSMgV4/UignEZB9M/ED68Fi2pdSuc6X3Tz2Jlra1zr8BQJWdJ82OX9QMnyfvSkVzqvxpKegbA2MznPL9
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6289ac81-b28d-4224-92a5-08d7f579ba25
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2020 07:05:45.7065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zEqtiw868ntABZg2UnBheOQ7duc4DJWjRGCv6qT4vOFO2QrYysYUAj/zrT823YkVR3vwS7JnBO7eG/p1gOmoRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6690
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coli,=0A=
=0A=
On 2020/05/11 2:24, Coly Li wrote:=0A=
> On 2020/5/11 00:52, Coly Li wrote:=0A=
>> This is a very basic zoned device support. With this patch, bcache=0A=
>> device is able to,=0A=
>> - Export zoned device attribution via sysfs=0A=
>> - Response report zones request, e.g. by command 'blkzone report'=0A=
>> But the bcache device is still NOT able to,=0A=
>> - Response any zoned device management request or IOCTL command=0A=
>>=0A=
>> Here are the testings I have done,=0A=
>> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'=0A=
>> - read /sys/block/bcache0/queue/nr_zones, content is number of zones=0A=
>>   including all zone types.=0A=
>> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size=0A=
>>   in sectors.=0A=
>> - run 'blkzone report /dev/bcache0', all zones information displayed.=0A=
>> - run 'blkzone reset /dev/bcache0', operation is rejected with error=0A=
>>   information: "blkzone: /dev/bcache0: BLKRESETZONE ioctl failed:=0A=
>>   Operation not supported"=0A=
>> - Sequential writes by dd, I can see some zones' write pointer 'wptr'=0A=
>>   values updated.=0A=
>>=0A=
>> All of these are very basic testings, if you have better testing=0A=
>> tools or cases, please offer me hint.=0A=
>>=0A=
>> Thanks in advance for your review and comments.=0A=
>>=0A=
>> Signed-off-by: Coly Li <colyli@suse.de>=0A=
>> CC: Hannes Reinecke <hare@suse.com>=0A=
>> CC: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> CC: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
>> ---=0A=
> =0A=
> Hi Damien and Johannes,=0A=
> =0A=
> With this patch the bcache device with a SMR drive can export the zone=0A=
> information and format zonefs on top of it. Writeback mode does not work=
=0A=
> at this moment (it requires on-disk format change and on my to-do list),=
=0A=
> writethrough and writearound mode can be used on the bcache device to=0A=
> accelerate random read when hitting.=0A=
> =0A=
> During my testing, there are 2 things needs to fix.=0A=
> =0A=
> 1, mkzonefs report the first zone size does not match.=0A=
>    Because bcache occupies the first 8KB of the backing SMR drive, so=0A=
> the first zone size is 8KB less. By ignoring unmatched zone 0 size,=0A=
> mkzonefs works and the bcache device is formated.=0A=
=0A=
Hannes was faster than me to comment on this. I can only repeat: this will =
not=0A=
work as there is the assumptions that all zones are the same size, except=
=0A=
eventually for the last one. I am even surprised that mkzonefs worked... Lo=
oks I=0A=
have some patching to do :)=0A=
=0A=
The simplest solution is as Hannes pointed out: use the first zone in its=
=0A=
entirety for bcache super block and nothing else. And do not show this zone=
 in=0A=
the zone report so that the bcache device user cannot reset or overwrite it=
.=0A=
That will mean as Hannes pointed out that the report zones device method fo=
r=0A=
bcache will need to remap zone start and wp sectors to start from sector 0.=
=0A=
Basically, substracting zone size to all zone start and to zone wp for non-=
full=0A=
zones will do.=0A=
=0A=
> 2, Direct I/O on files under seq/ directory can not be accessed.=0A=
>    I need help here. It seems direct I/O write fails with -EINVAL. I=0A=
> found the failure happens in fs/iomap/direct-io.c:iomap_dio_bio_actor(),=
=0A=
> 211         if ((pos | length | align) & ((1 << blkbits) - 1))=0A=
> 212                 return -EINVAL;=0A=
> =0A=
> When I write to seq/1 file on offset 0 with 4096 bytes, in the above=0A=
> line, align is 205427296, and  (pos | length | align) & ((1 << blkbits)=
=0A=
> - 1) is non-zero. Then all writes to files under seq/ fail with -EINVAL.=
=0A=
=0A=
205427296 is 195MB, so offset 0 in file seq/1 does not align to zone 1 star=
t=0A=
sector. This is why you see the  error (unaligned write). This is due to th=
e=0A=
first zone not being the same size, which zonefs assumes.=0A=
=0A=
If you could do all that, it probably also mean that you forgot to call=0A=
blk_revalidate_disk_zones() when setting up the bcache device. That is nece=
ssary=0A=
to set all queue limits and check the zone sizes are equal.=0A=
=0A=
I will check your patch shortly.=0A=
=0A=
> I guess there should be something missing when I do the direct I/O=0A=
> write. Could you all give me some hint ?=0A=
> =0A=
> Thanks in advance.=0A=
> =0A=
> Coly Li=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
