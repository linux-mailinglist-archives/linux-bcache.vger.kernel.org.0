Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92E51D6E6B
	for <lists+linux-bcache@lfdr.de>; Mon, 18 May 2020 03:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgERBHQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 17 May 2020 21:07:16 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:21728 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgERBHP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 May 2020 21:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589764035; x=1621300035;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=QGG5MmqSiNSgCJcZL+JRwtG40IsgsbFxQ33IERkqC9E=;
  b=iG1sIl3Q0x03yvtUyFHhTA1UNB70FoAJo1OX7bGtVUdjPnAOngK1W+GH
   C/WRZH0mwpvtrmuOSIXj7KIW0/v1rKsJ7He3yPsSHhXhj0Mr9V+OX+35U
   mNTHif1MlMfBjeGrPdnhbK51nHwy5byq9QGPA+OdzKTVZbO6K6molaC05
   uXztN3b2qapmUtKrQoITZjm2GtMAcv0SEKXx+09ETIfXXksZhAcGOe7A2
   H0X+WLYffRcUk8AVEHq3GGSudyuiJjUWRKy/28TVnYjRvyomjf3asax+W
   ngYXiYPDDrZVtiUD0Zm4aOUV9oInkA6Bo1xyP3wz1QJ2p0aFJAIEl7jL9
   A==;
IronPort-SDR: 5PwkEzeZPZnCuUakXqSVcUVRUZF/5qukIHBSqkdaLhWrCzxKnWkbjCzqezGd2QFx4n2tTx7uTK
 jOlSEtc4WjsA5mvn3bHSOoZqgdTHnXintWJeTgkxU0gdG3ZtwE9Gkwjata9Dg66XY4I9YDe5KU
 3ZtQ3MHtk4CP2AW5fgWv0GlhVGnHhEGi7NWrtG8pXHTkOGm65Jw2qhpISjnxBbQ+B8XwtnRQ3Z
 bws60rGg8eqgxdRLRiwf/EQ6JjqemXr1Ka7lIfJnK/P1PZ4lZBrSvGzp2LExSK88XbNOGgOzOn
 CME=
X-IronPort-AV: E=Sophos;i="5.73,405,1583164800"; 
   d="scan'208";a="142245879"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2020 09:07:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZuNa/xRx1h6UR0pzNreum/ykdKGzZ0bWmDtOrdUh3N5ttmi1/4DM9xuAdHfYEK58POLkG46ynBOLetm7PxD8ckQ2dl5XPJt3CdXxUIM+rtAVovm/oROoDPYg9Lnj0q1jgMTt2LRPkNjZSD8XJF7u3m8ozKgC0dqDPcwL7ejL7fSb7dDW6pZXOH7oP283y/9VzLwWJk6XV5jAucGMFTjjoWxjIYXetCzgHuRX5ztvBVgqorViGA+Mu1Ns4FFWzum5GEKkUIo1LJ85NmzFAxmNoh3OtnaOmbndVAno2RIm6uG2MeLStGSkRbVirTWZBYMXyji0svfnAFbSHiLjYZtKIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/1lJC5ph/lC6Vh6Xc0oUlSutdK0gB/Ju5sogmnkVvA=;
 b=cUOUDVywEifb4h94WYfFtMnMFwY/xB+s8zZgwyPygf3q5hQJHZfqeEVIvzaCPnLJg4H+fazXFv8YBJYICgkpk+Cm9detdwU1XUaGQ90xYigL0sORQkfnqT4qnsXKew0mN5D1N9Z1fc67eCY8w4YBjfDKHrw1vD+7JayCSK0W50l5u3J0osIooR5wxELHbQjzPaoUYYPRFcntpHoTvudgPuZ1m1ycP0LMvc2xnNfKD0Jg3ZbGvGbUMetd8mPrRM8H4eEOA+uIjvd8JeAms+AesWEXOkc8h0ip/vgPovoDSndKYhzYTyTewd4tGIUQ0jzOiGj6iam6bBbYebAuqR7DVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/1lJC5ph/lC6Vh6Xc0oUlSutdK0gB/Ju5sogmnkVvA=;
 b=jONytGfsNwx3zfAFAwLErCikeYPm9sKV6PEtw5CIOToN2BcgFn1A9cshOedCC2YrpDpoIRtN+5zhu4EoRsd6cApW62x97t8zoeS3lC3ImiVPUEXghJFrTMMvubOxGZFjutSCDHvCcFy6eHBh5Fi7UIg4hK7SHPpnpvR39kL/myg=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6293.namprd04.prod.outlook.com (2603:10b6:a03:1ef::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Mon, 18 May
 2020 01:07:13 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%6]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 01:07:13 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>
Subject: Re: [RFC PATCH v2 3/4] block: remove queue_is_mq restriction from
 blk_revalidate_disk_zones()
Thread-Topic: [RFC PATCH v2 3/4] block: remove queue_is_mq restriction from
 blk_revalidate_disk_zones()
Thread-Index: AQHWKzXQPn7ylq1QrUmRrc4/xaJzyQ==
Date:   Mon, 18 May 2020 01:07:13 +0000
Message-ID: <BY5PR04MB6900CEAF2B5C87BDF6101711E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-4-colyli@suse.de> <20200516124020.GC13448@lst.de>
 <d3fe49f1-d37b-689e-ae0e-078b1254d7e7@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e1b8a732-ea13-4428-fb2f-08d7fac7cc89
x-ms-traffictypediagnostic: BY5PR04MB6293:
x-microsoft-antispam-prvs: <BY5PR04MB6293AEA9B4FBF99037185C76E7B80@BY5PR04MB6293.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5HM2A/zgJDjw4YwnJvY49zG52844jtU8Y4jft02DTvl/R7DL9z4/T9ZNRbmOVMyX1mjQLJukX1e3uXN3Dd8tcwftAZeD7xCOBEPBHhjckhtLxR6fLs+0Pwmdyfq52eK37iytPrAD5siXLK+I5BMBWMgyZbHkUAw+H8EjhgBxuzijvrt1aaopC4PIwoPiGLX6cEDHw6kZ3dZVZxDXHbhS/7f+MLHX+rzb/R899LRDleYB3COspmBsJfyEvb8daDPBRU5UKKXTCZfHBHrMquwqZgWW7dDX2bE1YxFYn2Zd4HaC5J4YwMQR9iAqGdBJVpkfr9Up0tLAIoYYJVKbceYY51dSWAns0KggE4H+Vx9o4vv33nhNCR+q+72J21a1H4GHwvDH9z/WTslfauM+WtDHPdJjPikA7GGyEdeVRN7kC4Z+XEUUAAHHU/sTuSA0PiwT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(6506007)(186003)(26005)(8936002)(9686003)(478600001)(8676002)(86362001)(55016002)(33656002)(7696005)(53546011)(110136005)(71200400001)(2906002)(66946007)(316002)(76116006)(54906003)(5660300002)(64756008)(66476007)(4326008)(66556008)(66446008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NpC57+38N31gd+Wm+/PD+CzMDQkYQcELaXRjPr/qepiWZ6yfxCC39VuILR/MP7n+aWn8dXJQ8rm40M8Zud0QW+BCw612mUtgGgjl7il/qreLTNFrirzeAoa5Xk9YpwRMDG+JhqfnSENE/vm9ux+qsTcjFw/e2PVpTNg+UBaLuwvmGGv239ohu9wot8XwhKoqUF8LYLPte3uS6ME5k8ZUJ5YgZRDfDoVgZzeGnJDPe8Y2ap5hVDGB6fx9GUk48BCfq/hWaM1n4YyMpWVB1SYoPg+fV8UOlIhfT2AaJvaF9fl645DNlPcKooHxek9YhgPGcKYeWjIeO69ep19FQWhXQI2DgGZMnX2RWa+hJozdRQE4EZ7FyGLQJxn5Ko/B1yHhhNQ4uri8nVlitYzURGL65uwnftvO1r9qsbPzOQiHyP+kjDxlXqFqlvB+3s3YZIH0IPVIMB3dZE2E3lgYfGvTWfEdwHmvtGXqBUptFeuijZ5rND5/mpZceP8qjnQlLxzs
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b8a732-ea13-4428-fb2f-08d7fac7cc89
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 01:07:13.1204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a2UjchzIUPkZGn3huUkjHCZ6vEe0Z20W/+EP9IvKVJ9mPv2ywrLDcDOfGqXALJJLbeyNZJ1rY+LcFoOtFAFA/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6293
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/16 22:14, Coly Li wrote:=0A=
> On 2020/5/16 20:40, Christoph Hellwig wrote:=0A=
>> On Sat, May 16, 2020 at 11:54:33AM +0800, Coly Li wrote:=0A=
>>> The bcache driver is bio based and NOT request based multiqueued driver=
,=0A=
>>> if a zoned SMR hard drive is used as backing device of a bcache device,=
=0A=
>>> calling blk_revalidate_disk_zones() for the bcache device will fail due=
=0A=
>>> to the following check in blk_revalidate_disk_zones(),=0A=
>>> 478       if (WARN_ON_ONCE(!queue_is_mq(q)))=0A=
>>> 479             return -EIO;=0A=
>>>=0A=
>>> Now bcache is able to export the zoned information from the underlying=
=0A=
>>> zoned SMR drives and format zonefs on top of a bcache device, the=0A=
>>> resitriction that a zoned device should be multiqueued is unnecessary=
=0A=
>>> for now.=0A=
>>>=0A=
>>> Although in commit ae58954d8734c ("block: don't handle bio based driver=
s=0A=
>>> in blk_revalidate_disk_zones") it is said that bio based drivers should=
=0A=
>>> not call blk_revalidate_disk_zones() and just manually update their own=
=0A=
>>> q->nr_zones, but this is inaccurate. The bio based drivers also need to=
=0A=
>>> set their zone size and initialize bitmaps for cnv and seq zones, it is=
=0A=
>>> necessary to call blk_revalidate_disk_zones() for bio based drivers.=0A=
>>=0A=
>> Why would you need these bitmaps for bcache?  There is no reason to=0A=
>> serialize requests for stacking drivers, and you can already derive=0A=
>> if a zone is sequential or not from whatever internal information=0A=
>> you use.=0A=
>>=0A=
>> So without a user that actually makes sense: NAK.=0A=
>>=0A=
> =0A=
> It is OK for me to set the zone_nr and zone size without calling=0A=
> blk_revalidate_disk_zones().=0A=
=0A=
Yes, no problem with that.=0A=
=0A=
This is how device mapper BIO based targets handle zoned devices. See=0A=
dm_set_device_limits() which uses bdev_stack_limits() for handling chunk_se=
ctors=0A=
(zone size) and directly set q->limits.zoned to blk_queue_zoned_model(q) of=
 the=0A=
the underlying device. For the number of zones, see dm_table_set_restrictio=
ns()=0A=
which uses blkdev_nr_zones(t->md->disk) to set q->nr_zones. Note that=0A=
blkdev_nr_zones() uses the gendisk capacity of the logical device (the bcac=
he=0A=
device in your case) and the zone size, so both must be set first before ca=
lling=0A=
blkdev_nr_zones().=0A=
=0A=
=0A=
> =0A=
> Coly Li=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
