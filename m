Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853F51CD7B0
	for <lists+linux-bcache@lfdr.de>; Mon, 11 May 2020 13:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgEKLUi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 11 May 2020 07:20:38 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:27251 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgEKLUi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 11 May 2020 07:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589196035; x=1620732035;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=05EzOVto3LqzdegWFhQJjBSCWO4Bq6BU3SvcTh4Lz8g=;
  b=CMGu9UBVlXZ7JpJ6DCWXYcinlkNdC+K8IzTOlPrKhAuCsDDwrWOrxeTb
   QT2rZihDTWkhxBoLVAWl6ywJj4cvSWs1W5uYrtoR9W0VKHln3jpD992B7
   0vJgYM+gngUERFnSphUnnuiolTbkzRB+Bv9rKnm2qcQXQaHeJX/NiW/Vx
   Rd+Fywc5EF/wNiwVBVJ9YIFR8M2AvrinMBzu99rME+Fvkhyuv8xu8Q/BM
   ybGjukf7rKCEAOjMeZGnyvfFkUSAGXQraONN1A9a8rncEnRp1NjGygM5M
   vg01J+Oy7/xTP/ORClTzqhI53kdH/CoR9ANRRE34XgVhZ/t3RUCK5nuHc
   Q==;
IronPort-SDR: AEYkOpWnMpE4O//ZRiWTdjBNv5fcmQ222+ZGxAHlyFrLG/H0r6FOPHK0IXCFXfVSTs2L9spIi0
 toZHBX3fm+2VgnhManXoLFN5t4akzC0e7UpbnweRyh2+uJvMtGjC6ovriQd16d/lzs56G7I+2s
 x9VkCzuuJeU3xeLZ/0ZPD95coxEFp2uolhUFJzIEI3CoyoPUi76ZWvtnnJ2AJ/CGS2IOgMTWqQ
 X5jMrR9aE5mSmix4CvJjFozAEPd7xgdpGRlSSCFr643sq2moYyuLJB2cd4LuT6B8EwpF0w4zXc
 AcU=
X-IronPort-AV: E=Sophos;i="5.73,379,1583164800"; 
   d="scan'208";a="137400778"
Received: from mail-cys01nam02lp2057.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.57])
  by ob1.hgst.iphmx.com with ESMTP; 11 May 2020 19:20:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hry4bcomnGe1z9tmhdvzvYPYxVUIIu0L0vaUA+3xH6uVCcRdR1n2kz7F4z/KCjE4QsMSYJ/r5pqhpjIICAhK0/xd3KjymKIx2oG57M6L/CDWgKERxI6zE6jFBJ/AzAMXoHVzYAcPl0LV66rWPjLO+SHtkP5ItV6CsZghyxyxAmUQogFcqPPiw8t9tXFdN443CHY4GWVuAdEzcO6T8+rBsgmS17i3D7ubJLCrRnl2nB+bzfiWiHSyDN8w0Xd880+GkpGkRVDM9nPMDrFtlV5eNDGIoERSC0URpKJSW4G4iqIO5xDuJ4ukEBYyRLfgkL6bOdOBsNyX+KDloNGe5sQUMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1wFoVkWB4z4OgKWFDT5h7eIKkL/jZUfEZOpJSeYSgM=;
 b=FrL7eJjl914ngwXO+boSN0jzJ33mvx9+r9PKTtnad45gsq8p1+n+ofXYeaAUsBOFSnaYn7G19XGTY42oXt/Aj2eKnsHhsE+K6TVcDzr8M7Iqs1TwTs47RoLanyiSyBFIJBtqo7zru9ruIX67OapAm/DDccBX6stSPbR57GWN8JHhz3VDjEbk8D5xKdjMVHujBQrUyAQjNYEKYX8j4Dp+kyWObQEHGulm5Phe8je5ugX3GyCk3Dk8aSjz6D6UfrQX6p8S9GB9ZdWJaOZ2Wcd1fG1pCY/YF+Lx7UCOkRS20ZIOQqJDHa1rLY+uPRHVaH7fOIJ2i+m5LEeri5o73+uFOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1wFoVkWB4z4OgKWFDT5h7eIKkL/jZUfEZOpJSeYSgM=;
 b=WI4suD7w8iuewBJzh/YLl6tl6P6+mMRo9f1AQ7ZjlPIJ92SjxBNG24Tt4a8D16Ka2Bqju0ZRPcUOTf6SuT+ON6bGdI27sCPVfJDzTBxGS+pfQPLre580Yb/rK8sXXogLDrSHBIBMuq74OiJiUtKaMPQ+qJFWpRTdOXu5CR/QS38=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6358.namprd04.prod.outlook.com (2603:10b6:a03:1f2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Mon, 11 May
 2020 11:20:33 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%6]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 11:20:26 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [RFC PATCH v2] bcache: export zoned information for backing
 device
Thread-Topic: [RFC PATCH v2] bcache: export zoned information for backing
 device
Thread-Index: AQHWJutu5ptgM2PW10WdzDNgRnzbBg==
Date:   Mon, 11 May 2020 11:20:26 +0000
Message-ID: <BY5PR04MB6900128DCDE2106663CEE9EAE7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200510165232.67500-1-colyli@suse.de>
 <BY5PR04MB690062564D66C5E3573CE1E1E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
 <3672c550-5453-5de5-5c5c-34ab8dafb017@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7ffdb35a-2096-4e03-9d38-08d7f59d4e5f
x-ms-traffictypediagnostic: BY5PR04MB6358:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB635803E9C4F3B99A1E0BBD8CE7A10@BY5PR04MB6358.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04004D94E2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pkgj2AmFODD3Tyzg3ElbPh4OdjfhsYLnNFi0eEMq4LFiGSQyJ9xxnD+xFBFSkkxh6HwsyP2nMWJW86yeSWCrfoCLed6dPHGf9nSr5G+BZXRKKLKJIi3NMTXXoJTHN81m6KmWHHs02KBKd//cDKrTO0FznDQOOFQW61d/ljrHh7n6lgEsoOXWOBxpG/g1alBneVWU5EMSb0xZBTIZln0RTnxUECpg2RZVZQa0cV56V1iG+ih7Lb692az/J8dJQhUCsL/LOmYdWke+tZrDhCtgxpKkXXg/oH3SZhU+aGpntg2T4Xy/N1tXAuEIhLob7xZvevRXxmbGAbR7N2AWeMnh3thZB7VZiC4H1w27+P62jPIiq5Cc8x2TnPdT6xNNQ/emyvWLc2FjCSlRE5FnGWWH/YmUF90u5JwGtbDIAvB+DP9Ca2iMt1zaJyQn1RqB/RkXaZqdzw2e4xXnRy0dW1XxYT6etJM4RcevivckwsEmwfIPAoFx24JmmSrv/uIhHIHW2yFF5euJ0UWOCebe1t3qvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(33430700001)(53546011)(30864003)(5660300002)(8936002)(26005)(186003)(71200400001)(8676002)(4326008)(2906002)(9686003)(55016002)(110136005)(316002)(76116006)(54906003)(6506007)(33440700001)(33656002)(66446008)(66556008)(64756008)(7696005)(52536014)(66946007)(86362001)(66476007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: FfdC9M/y/vVB7JmRWvcG80tppPvpXSRdtL+svnVBKxCMA/BLj9Y33OVk82vK+2hI6jnMUXlGWbManqkjTp1o3TtPBXrhAyf1AiavXK+dvuyAn3lnd5MKRyw+6joxDJy4BmWpgr2HhGpXcGro9N4M2FV+iz4JMxV6OLBVbhA838k6rfNwHzLJD+RGsifvgM+NzkExcdzZxD6zGKxZQTQa+ue8ODqBnUYzMKw2hVGccFGydpyplFPG3H2BP1L3dMQzzSbfD+qYNwNX/PVmv3whjzp0m+eqJte/5TG2Tyy6mxW4pvmFxgz/IeNir5LMedanmrWEuApB+gj4reM+YL4/HRbQCww6u7aw+XqAcJ7TNp/mhwNyKrZjxiER+XqLT0nzWorcmMC+0h3meFiYjixE9f7sZSYgBkx7OS7eGY7B8NW5XCfv4GYZOyAsUQM/LiIHMnn0/4UcA8glpSfh3RjdLPm+XFNRrKQkzI9EZ2GVdta2BtT7zKazb6cBhUECkfuY
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ffdb35a-2096-4e03-9d38-08d7f59d4e5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2020 11:20:26.7344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PkiqrkKWYqL3STMtpt/QXVMXZULHS0BWX4fUC1BM6B2g9lC37enAFowX1EnAkO8G/wD4M9/fkrh13XLRptohjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6358
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/11 20:00, Coly Li wrote:=0A=
> On 2020/5/11 17:06, Damien Le Moal wrote:=0A=
>> On 2020/05/11 1:52, Coly Li wrote:=0A=
>>> This is a very basic zoned device support. With this patch, bcache=0A=
>>> device is able to,=0A=
>>> - Export zoned device attribution via sysfs=0A=
>>> - Response report zones request, e.g. by command 'blkzone report'=0A=
>>> But the bcache device is still NOT able to,=0A=
>>> - Response any zoned device management request or IOCTL command=0A=
>>>=0A=
>>> Here are the testings I have done,=0A=
>>> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'=0A=
>>> - read /sys/block/bcache0/queue/nr_zones, content is number of zones=0A=
>>>   including all zone types.=0A=
>>> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size=0A=
>>>   in sectors.=0A=
>>> - run 'blkzone report /dev/bcache0', all zones information displayed.=
=0A=
>>> - run 'blkzone reset /dev/bcache0', operation is rejected with error=0A=
>>>   information: "blkzone: /dev/bcache0: BLKRESETZONE ioctl failed:=0A=
>>>   Operation not supported"=0A=
>>=0A=
>> Weird. If report zones works, reset should also, modulo the zone size pr=
oblem=0A=
>> for the first zone. You may get EINVAL, but not ENOTTY.=0A=
>>=0A=
> =0A=
> This is on purpose. Because reset the underlying zones layout may=0A=
> corrupt the bcache mapping between cache device and backing device. So=0A=
> such management commands are rejected.=0A=
> =0A=
> =0A=
> =0A=
>>> - Sequential writes by dd, I can see some zones' write pointer 'wptr'=
=0A=
>>>   values updated.=0A=
>>>=0A=
>>> All of these are very basic testings, if you have better testing=0A=
>>> tools or cases, please offer me hint.=0A=
>>>=0A=
>>> Thanks in advance for your review and comments.=0A=
>>>=0A=
>>> Signed-off-by: Coly Li <colyli@suse.de>=0A=
>>> CC: Hannes Reinecke <hare@suse.com>=0A=
>>> CC: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>> CC: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
>>> ---=0A=
>>>  drivers/md/bcache/bcache.h  | 10 +++++=0A=
>>>  drivers/md/bcache/request.c | 74 +++++++++++++++++++++++++++++++++++++=
=0A=
>>>  drivers/md/bcache/super.c   | 51 +++++++++++++++++++++----=0A=
>>>  3 files changed, 128 insertions(+), 7 deletions(-)=0A=
>>>=0A=
>>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h=0A=
>>> index 74a9849ea164..0d298b48707f 100644=0A=
>>> --- a/drivers/md/bcache/bcache.h=0A=
>>> +++ b/drivers/md/bcache/bcache.h=0A=
>>> @@ -221,6 +221,7 @@ BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);=0A=
>>>  struct search;=0A=
>>>  struct btree;=0A=
>>>  struct keybuf;=0A=
>>> +struct bch_report_zones_args;=0A=
>>>  =0A=
>>>  struct keybuf_key {=0A=
>>>  	struct rb_node		node;=0A=
>>> @@ -277,6 +278,8 @@ struct bcache_device {=0A=
>>>  			  struct bio *bio, unsigned int sectors);=0A=
>>>  	int (*ioctl)(struct bcache_device *d, fmode_t mode,=0A=
>>>  		     unsigned int cmd, unsigned long arg);=0A=
>>> +	int (*report_zones)(struct bch_report_zones_args *args,=0A=
>>> +			    unsigned int nr_zones);=0A=
>>>  };=0A=
>>>  =0A=
>>>  struct io {=0A=
>>> @@ -748,6 +751,13 @@ struct bbio {=0A=
>>>  	struct bio		bio;=0A=
>>>  };=0A=
>>>  =0A=
>>> +struct bch_report_zones_args {=0A=
>>> +	struct bcache_device *bcache_device;=0A=
>>> +	sector_t sector;=0A=
>>> +	void *orig_data;=0A=
>>> +	report_zones_cb orig_cb;=0A=
>>> +};=0A=
>>> +=0A=
>>>  #define BTREE_PRIO		USHRT_MAX=0A=
>>>  #define INITIAL_PRIO		32768U=0A=
>>>  =0A=
>>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c=
=0A=
>>> index 71a90fbec314..bd50204caac7 100644=0A=
>>> --- a/drivers/md/bcache/request.c=0A=
>>> +++ b/drivers/md/bcache/request.c=0A=
>>> @@ -1190,6 +1190,19 @@ blk_qc_t cached_dev_make_request(struct request_=
queue *q, struct bio *bio)=0A=
>>>  		}=0A=
>>>  	}=0A=
>>>  =0A=
>>> +	/*=0A=
>>> +	 * zone management request may change the data layout and content=0A=
>>> +	 * implicitly on backing device, which introduces unacceptible=0A=
>>=0A=
>> s/unacceptible/unacceptable=0A=
>>=0A=
>>> +	 * inconsistency between the backing device and the cache device.=0A=
>>> +	 * Therefore all zone management related request will be denied here.=
=0A=
>>> +	 */=0A=
>>> +	if (op_is_zone_mgmt(bio->bi_opf)) {=0A=
>>> +		pr_err_ratelimited("zoned device management request denied.");=0A=
>>> +		bio->bi_status =3D BLK_STS_NOTSUPP;=0A=
>>> +		bio_endio(bio);=0A=
>>> +		return BLK_QC_T_NONE;=0A=
>>=0A=
>> OK. That explains the operation not supported for "blkzone reset". I do =
not=0A=
>> think this is good. With this, the drive will be writable only exactly o=
nce,=0A=
>> without the possibility for the user to reset any zone and rewrite them.=
 All=0A=
>> zone compliant file systems will fail (f2fs, zonefs, btrfs coming).=0A=
>>=0A=
>> At the very least REQ_OP_ZONE_RESET should be allowed and trigger an=0A=
>> invalidation on the cache device of all blocks of the zone that are cach=
ed.=0A=
>>=0A=
> =0A=
> Copied. Then I should find a method to invalid the cached data on SSD in=
=0A=
> a proper way.=0A=
> =0A=
>> Note: the zone management operations will need to be remapped like repor=
t zones,=0A=
>> but in reverse: the BIO start sector must be increase by the zone size.=
=0A=
>>=0A=
> =0A=
> Thanks for the hint :-)=0A=
> =0A=
> =0A=
>>> +	}=0A=
>>> +=0A=
>>>  	generic_start_io_acct(q,=0A=
>>>  			      bio_op(bio),=0A=
>>>  			      bio_sectors(bio),=0A=
>>> @@ -1233,6 +1246,24 @@ static int cached_dev_ioctl(struct bcache_device=
 *d, fmode_t mode,=0A=
>>>  	if (dc->io_disable)=0A=
>>>  		return -EIO;=0A=
>>>  =0A=
>>> +	/*=0A=
>>> +	 * zone management ioctl commands may change the data layout=0A=
>>> +	 * and content implicitly on backing device, which introduces=0A=
>>> +	 * unacceptible inconsistency between the backing device and=0A=
>>> +	 * the cache device. Therefore all zone management related=0A=
>>> +	 * ioctl commands will be denied here.=0A=
>>> +	 */=0A=
>>> +	switch (cmd) {=0A=
>>> +	case BLKRESETZONE:=0A=
>>> +	case BLKOPENZONE:=0A=
>>> +	case BLKCLOSEZONE:=0A=
>>> +	case BLKFINISHZONE:=0A=
>>> +		return -EOPNOTSUPP;=0A=
>>=0A=
>> Same comment as above. Of note is that only BLKRESETZONE will result in =
cache=0A=
>> inconsistency if not taken care of with an invalidation of the cached bl=
ocks of=0A=
>> the zone on the cache device. Open and close operations have no effect o=
n data.=0A=
>> Finish zone will artificially increase the zone write pointer to the end=
 of the=0A=
>> zone to make it full but without actually writing any data. So there is =
no need=0A=
>> I think to change anything on the cache device in that case.=0A=
>>=0A=
> =0A=
> Copied. I will handle this.=0A=
> =0A=
> One thing not cleared to me is, what is the purpose of BLKOPENZONE and=0A=
> BLKCLOSEZONE, is it used to update writer pointer only ? Or it is also=0A=
> used to set a specific zone to be offline ?=0A=
=0A=
open and close have no effect on the wp of a zone. No change. The open oper=
ation=0A=
is a hint to the drive to tell it "I am going to write intensively to this =
zone,=0A=
so keep resources for it around" and the close operation frees the zone=0A=
resources. Everything works fine without these for SMR HDDs and the perform=
ance=0A=
gain from using open/close can hardly be measured at all. These operations =
will=0A=
however be more important for upcoming ZNS devices due to the different med=
ia=0A=
characteristics. Since these operations have no impact on the zone data, th=
ey=0A=
are safe for bcache, regardless of the cache state.=0A=
=0A=
Only reset and finish change a zone wp. And only reset needs invalidation o=
f the=0A=
cache device blocks of the zone.=0A=
=0A=
> =0A=
> =0A=
>>> +	default:=0A=
>>> +		/* Other commands fall through*/=0A=
>>> +		break;=0A=
>>> +	}=0A=
>>> +=0A=
>>>  	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);=0A=
>>>  }=0A=
>>>  =0A=
>>> @@ -1261,6 +1292,48 @@ static int cached_dev_congested(void *data, int =
bits)=0A=
>>>  	return ret;=0A=
>>>  }=0A=
>>>  =0A=
>>> +static int cached_dev_report_zones_cb(struct blk_zone *zone,=0A=
>>> +				      unsigned int idx,=0A=
>>> +				      void *data)=0A=
>>> +{=0A=
>>> +	struct bch_report_zones_args *args =3D data;=0A=
>>> +	struct bcache_device *d =3D args->bcache_device;=0A=
>>> +	struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);=
=0A=
>>> +	unsigned long data_offset =3D dc->sb.data_offset;=0A=
>>> +=0A=
>>> +	if (zone->start >=3D data_offset) {=0A=
>>> +		zone->start -=3D data_offset;=0A=
>>> +		zone->wp -=3D data_offset;=0A=
>>=0A=
>> Since the zone that contains the super block has to be ignored, the rema=
pping of=0A=
>> the zone start can be done unconditionally. For the write pointer remapp=
ing, you=0A=
>> need to handle several cases: conventional zones, full zones and read-on=
ly zones=0A=
>> do not have a valid write pointer value, so no updating. You also need t=
o skip=0A=
>> offline zones.=0A=
>>=0A=
> =0A=
> Copied, I will fix here in next version.=0A=
> =0A=
> =0A=
>>> +	} else {=0A=
>>> +		/*=0A=
>>> +		 * Normally the first zone is conventional zone,=0A=
>>> +		 * we don't need to worry about how to maintain=0A=
>>> +		 * the write pointer.=0A=
>>> +		 * But the zone->len is special, because the=0A=
>>> +		 * sector 0 on bcache device is 8KB offset on=0A=
>>> +		 * backing device indeed.=0A=
>>> +		 */=0A=
>>> +		zone->len -=3D data_offset;=0A=
>>=0A=
>> This should not be necessary if the first zone containing the super bloc=
k is=0A=
>> skipped entirely.=0A=
>>=0A=
> =0A=
> Yes, it will be.=0A=
> =0A=
> =0A=
>>> +	}=0A=
>>> +=0A=
>>> +	return args->orig_cb(zone, idx, args->orig_data);=0A=
>>> +}=0A=
>>> +=0A=
>>> +static int cached_dev_report_zones(struct bch_report_zones_args *args,=
=0A=
>>> +				   unsigned int nr_zones)=0A=
>>> +{=0A=
>>> +	struct bcache_device *d =3D args->bcache_device;=0A=
>>> +	struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);=
=0A=
>>> +	sector_t sector =3D args->sector + dc->sb.data_offset;=0A=
>>> +=0A=
>>> +	/* sector is real LBA of backing device */=0A=
>>> +	return blkdev_report_zones(dc->bdev,=0A=
>>> +				   sector,=0A=
>>> +				   nr_zones,=0A=
>>> +				   cached_dev_report_zones_cb,=0A=
>>> +				   args);=0A=
>>> +}=0A=
>>> +=0A=
>>>  void bch_cached_dev_request_init(struct cached_dev *dc)=0A=
>>>  {=0A=
>>>  	struct gendisk *g =3D dc->disk.disk;=0A=
>>> @@ -1268,6 +1341,7 @@ void bch_cached_dev_request_init(struct cached_de=
v *dc)=0A=
>>>  	g->queue->backing_dev_info->congested_fn =3D cached_dev_congested;=0A=
>>>  	dc->disk.cache_miss			=3D cached_dev_cache_miss;=0A=
>>>  	dc->disk.ioctl				=3D cached_dev_ioctl;=0A=
>>> +	dc->disk.report_zones			=3D cached_dev_report_zones;=0A=
>>>  }=0A=
>>>  =0A=
>>>  /* Flash backed devices */=0A=
>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c=0A=
>>> index d98354fa28e3..b7d496040cee 100644=0A=
>>> --- a/drivers/md/bcache/super.c=0A=
>>> +++ b/drivers/md/bcache/super.c=0A=
>>> @@ -679,10 +679,31 @@ static int ioctl_dev(struct block_device *b, fmod=
e_t mode,=0A=
>>>  	return d->ioctl(d, mode, cmd, arg);=0A=
>>>  }=0A=
>>>  =0A=
>>> +static int report_zones_dev(struct gendisk *disk,=0A=
>>> +			    sector_t sector,=0A=
>>> +			    unsigned int nr_zones,=0A=
>>> +			    report_zones_cb cb,=0A=
>>> +			    void *data)=0A=
>>> +{=0A=
>>> +	struct bcache_device *d =3D disk->private_data;=0A=
>>> +	struct bch_report_zones_args args =3D {=0A=
>>> +		.bcache_device =3D d,=0A=
>>> +		.sector =3D sector,=0A=
>>> +		.orig_data =3D data,=0A=
>>> +		.orig_cb =3D cb,=0A=
>>> +	};=0A=
>>> +=0A=
>>> +	if (d->report_zones)=0A=
>>> +		return d->report_zones(&args, nr_zones);=0A=
>>=0A=
>> It looks to me like this is not necessary. This function could just be=
=0A=
>> cached_dev_report_zones() and you can drop the dc->disk.report_zones met=
hod.=0A=
>>=0A=
> =0A=
> Yes, I will fix it.=0A=
> =0A=
> =0A=
>>> +=0A=
>>> +	return -EOPNOTSUPP;=0A=
>>> +}=0A=
>>> +=0A=
>>>  static const struct block_device_operations bcache_ops =3D {=0A=
>>>  	.open		=3D open_dev,=0A=
>>>  	.release	=3D release_dev,=0A=
>>>  	.ioctl		=3D ioctl_dev,=0A=
>>> +	.report_zones	=3D report_zones_dev,=0A=
>>>  	.owner		=3D THIS_MODULE,=0A=
>>>  };=0A=
>>>  =0A=
>>> @@ -815,8 +836,12 @@ static void bcache_device_free(struct bcache_devic=
e *d)=0A=
>>>  	closure_debug_destroy(&d->cl);=0A=
>>>  }=0A=
>>>  =0A=
>>> -static int bcache_device_init(struct bcache_device *d, unsigned int bl=
ock_size,=0A=
>>> -			      sector_t sectors, make_request_fn make_request_fn)=0A=
>>> +static int bcache_device_init(struct cached_dev *dc,=0A=
>>> +			      struct bcache_device *d,=0A=
>>> +			      unsigned int block_size,=0A=
>>> +			      sector_t sectors,=0A=
>>> +			      make_request_fn make_request_fn)=0A=
>>> +=0A=
>>>  {=0A=
>>>  	struct request_queue *q;=0A=
>>>  	const size_t max_stripes =3D min_t(size_t, INT_MAX,=0A=
>>> @@ -886,6 +911,17 @@ static int bcache_device_init(struct bcache_device=
 *d, unsigned int block_size,=0A=
>>>  	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);=0A=
>>>  	blk_queue_flag_set(QUEUE_FLAG_DISCARD, d->disk->queue);=0A=
>>>  =0A=
>>> +	/*=0A=
>>> +	 * If this is for backing device registration, and it is an=0A=
>>> +	 * zoned device (e.g. host-managed S.M.R. hard drive), set=0A=
>>> +	 * up zoned device attribution properly for sysfs interface.=0A=
>>> +	 */=0A=
>>> +	if (dc && bdev_is_zoned(dc->bdev)) {=0A=
>>> +		q->limits.zoned =3D bdev_zoned_model(dc->bdev);=0A=
>>> +		q->nr_zones =3D blkdev_nr_zones(dc->bdev->bd_disk);=0A=
>>> +		q->limits.chunk_sectors =3D bdev_zone_sectors(dc->bdev);=0A=
>>=0A=
>> You need to call blk_revalidate_disk_zones() here:=0A=
>>=0A=
>> 	blk_revalidate_disk_zones(dc->bdev->bd_disk);=0A=
>>=0A=
>> but call it *after* setting the bc device capacity to=0A=
>>=0A=
>> 	get_capacity(dc->bdev->bd_disk) - bdev_zone_sectors(dc->bdev);=0A=
>>=0A=
>> Which I think is in fact the sectors argument to this function ?=0A=
>>=0A=
>> With that information blk_revalidate_disk_zones() will check the zones a=
nd set=0A=
>> q->nr_zones.=0A=
>>=0A=
>>=0A=
> =0A=
> This is something I didn't notice. Yes I should revalidate teh zones.=0A=
> Will do it in next version.=0A=
> =0A=
> =0A=
>>> +	}=0A=
>>> +=0A=
>>>  	blk_queue_write_cache(q, true, true);=0A=
>>>  =0A=
>>>  	return 0;=0A=
>>> @@ -1337,9 +1373,9 @@ static int cached_dev_init(struct cached_dev *dc,=
 unsigned int block_size)=0A=
>>>  		dc->partial_stripes_expensive =3D=0A=
>>>  			q->limits.raid_partial_stripes_expensive;=0A=
>>>  =0A=
>>> -	ret =3D bcache_device_init(&dc->disk, block_size,=0A=
>>> -			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset,=0A=
>>> -			 cached_dev_make_request);=0A=
>>> +	ret =3D bcache_device_init(dc, &dc->disk, block_size,=0A=
>>> +			dc->bdev->bd_part->nr_sects - dc->sb.data_offset,=0A=
>>=0A=
>> dc->sb.data_offset should be the device zone size (chunk sectors) to ski=
p the=0A=
>> entire first zone and preserve the "all zones have the same size" constr=
aint.=0A=
>>=0A=
> =0A=
> =0A=
> Sure, and the bcache-tools should be fixed to recognize zoned device as=
=0A=
> well.=0A=
> =0A=
>>> +			cached_dev_make_request);=0A=
>>>  	if (ret)=0A=
>>>  		return ret;=0A=
>>>  =0A=
>>> @@ -1451,8 +1487,9 @@ static int flash_dev_run(struct cache_set *c, str=
uct uuid_entry *u)=0A=
>>>  =0A=
>>>  	kobject_init(&d->kobj, &bch_flash_dev_ktype);=0A=
>>>  =0A=
>>> -	if (bcache_device_init(d, block_bytes(c), u->sectors,=0A=
>>> -			flash_dev_make_request))=0A=
>>> +	if (bcache_device_init(NULL, d, block_bytes(c),=0A=
>>> +			       u->sectors,=0A=
>>> +			       flash_dev_make_request))=0A=
>>>  		goto err;=0A=
>>>  =0A=
>>>  	bcache_device_attach(d, c, u - c->uuids);=0A=
>>>=0A=
>>=0A=
>>=0A=
> =0A=
> Thanks for your review. I will post v2 soon.=0A=
> =0A=
> Coly Li=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
