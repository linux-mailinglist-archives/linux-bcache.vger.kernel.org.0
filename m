Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948CB114A3D
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 01:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfLFAau (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Dec 2019 19:30:50 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:3294 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfLFAau (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Dec 2019 19:30:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575592255; x=1607128255;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=jvlc1ilxzu510E+qyfEmAe+h/nNxRicSFCCnmpRUt2k=;
  b=Tk7tPHfB68rmYYu5E06+8ytk4VgeBKNLTcztviWd5nKOxkYglISn1i/3
   Hx5e69ReAcPLMJdD6cNq8KwflFiVI3NLhRGfIzniZjJmShPW5S5Ew9YGH
   nGf2x0TUsECw/CWrr0TGI/QmJooKOyIV5QB34pY4JRtiPKej2Nfn0sMi1
   IX7gnPb8JfWsYbyGcONOkS7BCjE9B4dX/kpCYKYfMjPAJhGXTgR9gZhZH
   ceBt2UARCQgfi/M8a3netyQAGfjF9J+1BWaeRAQwyDa9dxd+ZtRBOWLmF
   E3gWSw/G52Vc3Gfdgj73KPLxQikxfE/ezK84NuQtmTY3Pj4s97Kc56Ac1
   A==;
IronPort-SDR: T81PGqLSPXEbQy/5h6K9VMNqwCnK6rYJM+eKZKAsCHV8cLNiG2xKY4x8uCyPPc9bDCYZsQvRRa
 x7eIK4BFZJl897ptqvgnEhLsU89oiXQGE9BLIQvyS5CKtJdBQhQ+ieDOpr/yHc7RmMygKVJKWp
 9no5evzf+Ly/Xc6uuUX/75CJ0llpb+k7oYhD0K/tVr7C4UILUx3u7YG+RVKwK5E8Isom5xjIe5
 eGVtGUv4KQyCCVM5WSf2NxlV9cESpVYbTRo297kI9PdN+tQiTDZm9o42rUray9uYdBaPU5hPYF
 8Ic=
X-IronPort-AV: E=Sophos;i="5.69,282,1571673600"; 
   d="scan'208";a="226195209"
Received: from mail-cys01nam02lp2050.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.50])
  by ob1.hgst.iphmx.com with ESMTP; 06 Dec 2019 08:30:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqPSa7VIykjDDf2Dx1vFD0iKXNKjNyIYuSK7zPPRmjr8TRaGhPafkgagSL0Wtj/o8M+b/SZki5jAi2+JkdwAo+O0Vf7IzV/EL00587hLTtSPgznGipnQWJ33uiwNfT3SAK5gsVCgRvC9ybcJXUFAwcYdhTS6NCpmBQ2hqa6CMYnzSbdYGP3ab8ogbBK6ofxScZjZl4NVAxiZF+KFOvpOXW1LEBqsvLMux84P4BbF04xtcjvD9vpL9mMN8uiCdGWWtnDlRPFnTaD0IIyCnS54kWmyogP+cYXIgZ31O3uhXB/ku6x6lDo4ndjMwi3++9Ev+hoAx9EgQO/ZzoEP/mfJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+fdSIX0Aq6sOXi8iVifOsQbnOghXBdeueSMs64qfNG8=;
 b=JuXH5eYpmZ0rNrXwM8m9qo8QX1IDdXE7pndM02jOp5DZlrKKj3QWTnAq4PzF90MTh+ujm2CMf6yagW3O/15C4zA6uoUy1LoCaweLk7Z0PyfwloC/HvTwCP7gcLIyCOoHWWGXieHesA95j+X3FUj7a+7lGRKQzn66NAF9WAQPV5T3th5jPdJ6Zn360Qz8LEiVt5D/arouWtZOhtRUPDR3Df6sTU7t9VMgaanTFnQAyb3ZX2GD96UnPsBldnCDoSfFdVxOi1acmuIz0rnnVKDYa/3j6zh//rQiYw2rCizZPbX53/dcMoJLlMf0Z9HaQSPjIroh0fV2ld7DXFVpeLFTrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+fdSIX0Aq6sOXi8iVifOsQbnOghXBdeueSMs64qfNG8=;
 b=zw5F5YLp48+pxjlUSVa6Rpex5oEwya6LbzrnhmWjWWHXRuj1exC17r1xpfJzs4Zg9kJK0PWA+faXeja59ppWj6zW4cwk4XXC2df2ymzuyPQowzetmZfdMeoR9Au6qJKxyE1RcHwJTLJebVNICEieV2Guo8TLeEl1lL7nGkJxg/s=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4181.namprd04.prod.outlook.com (20.176.250.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Fri, 6 Dec 2019 00:30:45 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::f0e9:c12:647d:2aae]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::f0e9:c12:647d:2aae%4]) with mapi id 15.20.2495.026; Fri, 6 Dec 2019
 00:30:45 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <colyli@suse.de>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [RFC PATCH] bcache: enable zoned device support
Thread-Topic: [RFC PATCH] bcache: enable zoned device support
Thread-Index: AQHVq4BK89W6d1xR0kigtgr1jyyJ1w==
Date:   Fri, 6 Dec 2019 00:30:45 +0000
Message-ID: <BYAPR04MB5816090B934A7CA17EFA688AE75F0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191205152543.73885-1-colyli@suse.de>
 <alpine.LRH.2.11.1912060012380.11561@mx.ewheeler.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2eb1fee3-0cc8-41e8-722d-08d779e388e8
x-ms-traffictypediagnostic: BYAPR04MB4181:
x-microsoft-antispam-prvs: <BYAPR04MB41815AFBA76C42A14A5DC5B0E75F0@BYAPR04MB4181.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0243E5FD68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(199004)(189003)(51874003)(8936002)(76176011)(81166006)(52536014)(14454004)(66476007)(9686003)(66946007)(25786009)(76116006)(91956017)(71190400001)(478600001)(55016002)(6506007)(53546011)(66556008)(86362001)(99286004)(14444005)(229853002)(4326008)(66446008)(64756008)(8676002)(81156014)(7696005)(102836004)(26005)(316002)(2906002)(110136005)(54906003)(305945005)(71200400001)(186003)(33656002)(5660300002)(74316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4181;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uk7/kbthHjTLz7m6h+jTt8NT5e4u012couJH2D/wY1THBEDzlGXzxD5U4vm9acYxG5vwMc+RyzFGo5rZmFZB9NoYovg/TXeUbrdk4Uu2mUDl6XwRKflMGIISYOs/PKC6ykgTD21YAgBlRx8HhElCpkkJh8hji395WqEJf2miSkOjhxZiLQTYbRR8DR/4pqH53dMfH6ZXIV85Wd4fz8oVkkjQLRqeG/3FcZR+5vuZuxP3n7dQEue8T6YyTa/Eu6RyrOqBDdVv30lVQCx4i9FVoxRqb7a+aQFAHlTSSFZywO7EX6v1ScDx1SLehsju/JdtPF143RxhoUyNhLk0mZ8MkUn9Y5CSm/zQStPrvfQ7HgNNmiv3xh8JLA0y0SlaODnky/7KjkZTPnwstqp/faW1kZ9o/qjW4BeVx58bUhc9Zra09+CUHDpENFTKtdssWcgkoWPP+8rLAOhsG7Wpuj+VF3gdUnRX1gmdOEQgwOsWTlJM/lnEsTQIFPPKmO2dUUOx
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb1fee3-0cc8-41e8-722d-08d779e388e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2019 00:30:45.6587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a91hJFjmQmqybN5+KJ4qmjYI8Bo5o/HYYsv4V5x+NhKrHN8AWjGzgO2uO5RwKe6Ja4tHWcdIt/nGtTQVKRX+mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4181
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/06 9:22, Eric Wheeler wrote:=0A=
> On Thu, 5 Dec 2019, Coly Li wrote:=0A=
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
> =0A=
> Interesting. =0A=
> =0A=
> 1. should_writeback() could benefit by hinting true when an IO would fall=
 =0A=
>    in a zoned region.=0A=
> =0A=
> 2. The writeback thread could writeback such that they prefer =0A=
>    fully(mostly)-populated zones when choosing what to write out.=0A=
=0A=
That definitely would be a good idea since that would certainly benefit=0A=
backend-GC (that will be needed).=0A=
=0A=
However, I do not see the point in exposing the /dev/bcacheX block=0A=
device itself as a zoned disk. In fact, I think we want exactly the=0A=
opposite: expose it as a regular disk so that any FS or application can=0A=
run. If the bcache backend disk is zoned, then the writeback handles=0A=
sequential writes. This would be in the end a solution similar to=0A=
dm-zoned, that is, a zoned disk becomes useable as a regular block=0A=
device (random writes anywhere are possible), but likely far more=0A=
efficient and faster. That may result in imposing some limitations on=0A=
bcache operations though, e.g. it can only be setup with writeback, no=0A=
writethrough allowed (not sure though...).=0A=
Thoughts ?=0A=
=0A=
> =0A=
> --=0A=
> Eric Wheeler=0A=
> =0A=
> =0A=
> =0A=
>> Thanks in advance for your review and comments.=0A=
>>=0A=
>> Signed-off-by: Coly Li <colyli@suse.de>=0A=
>> CC: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> CC: Hannes Reinecke <hare@suse.com>=0A=
>> ---=0A=
>>  drivers/md/bcache/bcache.h  | 10 ++++++=0A=
>>  drivers/md/bcache/request.c | 74 ++++++++++++++++++++++++++++++++++++++=
+++++++=0A=
>>  drivers/md/bcache/super.c   | 41 +++++++++++++++++++++++--=0A=
>>  3 files changed, 122 insertions(+), 3 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h=0A=
>> index 9198c1b480d9..77c2040c99ee 100644=0A=
>> --- a/drivers/md/bcache/bcache.h=0A=
>> +++ b/drivers/md/bcache/bcache.h=0A=
>> @@ -221,6 +221,7 @@ BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);=0A=
>>  struct search;=0A=
>>  struct btree;=0A=
>>  struct keybuf;=0A=
>> +struct bch_report_zones_args;=0A=
>>  =0A=
>>  struct keybuf_key {=0A=
>>  	struct rb_node		node;=0A=
>> @@ -277,6 +278,8 @@ struct bcache_device {=0A=
>>  			  struct bio *bio, unsigned int sectors);=0A=
>>  	int (*ioctl)(struct bcache_device *d, fmode_t mode,=0A=
>>  		     unsigned int cmd, unsigned long arg);=0A=
>> +	int (*report_zones)(struct bch_report_zones_args *args,=0A=
>> +			    unsigned int nr_zones);=0A=
>>  };=0A=
>>  =0A=
>>  struct io {=0A=
>> @@ -743,6 +746,13 @@ struct bbio {=0A=
>>  	struct bio		bio;=0A=
>>  };=0A=
>>  =0A=
>> +struct bch_report_zones_args {=0A=
>> +	struct bcache_device *bcache_device;=0A=
>> +	sector_t sector;=0A=
>> +	void *orig_data;=0A=
>> +	report_zones_cb orig_cb;=0A=
>> +};=0A=
>> +=0A=
>>  #define BTREE_PRIO		USHRT_MAX=0A=
>>  #define INITIAL_PRIO		32768U=0A=
>>  =0A=
>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c=
=0A=
>> index 7555e4a93145..d82425300383 100644=0A=
>> --- a/drivers/md/bcache/request.c=0A=
>> +++ b/drivers/md/bcache/request.c=0A=
>> @@ -1162,6 +1162,19 @@ static blk_qc_t cached_dev_make_request(struct re=
quest_queue *q,=0A=
>>  		}=0A=
>>  	}=0A=
>>  =0A=
>> +	/*=0A=
>> +	 * zone management request may change the data layout and content=0A=
>> +	 * implicitly on backing device, which introduces unacceptible=0A=
>> +	 * inconsistency between the backing device and the cache device.=0A=
>> +	 * Therefore all zone management related request will be denied here.=
=0A=
>> +	 */=0A=
>> +	if (op_is_zone_mgmt(bio->bi_opf)) {=0A=
>> +		pr_err_ratelimited("zoned device management request denied.");=0A=
>> +		bio->bi_status =3D BLK_STS_NOTSUPP;=0A=
>> +		bio_endio(bio);=0A=
>> +		return BLK_QC_T_NONE;=0A=
>> +	}=0A=
>> +=0A=
>>  	generic_start_io_acct(q,=0A=
>>  			      bio_op(bio),=0A=
>>  			      bio_sectors(bio),=0A=
>> @@ -1205,6 +1218,24 @@ static int cached_dev_ioctl(struct bcache_device =
*d, fmode_t mode,=0A=
>>  	if (dc->io_disable)=0A=
>>  		return -EIO;=0A=
>>  =0A=
>> +	/*=0A=
>> +	 * zone management ioctl commands may change the data layout=0A=
>> +	 * and content implicitly on backing device, which introduces=0A=
>> +	 * unacceptible inconsistency between the backing device and=0A=
>> +	 * the cache device. Therefore all zone management related=0A=
>> +	 * ioctl commands will be denied here.=0A=
>> +	 */=0A=
>> +	switch (cmd) {=0A=
>> +	case BLKRESETZONE:=0A=
>> +	case BLKOPENZONE:=0A=
>> +	case BLKCLOSEZONE:=0A=
>> +	case BLKFINISHZONE:=0A=
>> +		return -EOPNOTSUPP;=0A=
>> +	default:=0A=
>> +		/* Other commands fall through*/=0A=
>> +		break;=0A=
>> +	}=0A=
>> +=0A=
>>  	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);=0A=
>>  }=0A=
>>  =0A=
>> @@ -1233,6 +1264,48 @@ static int cached_dev_congested(void *data, int b=
its)=0A=
>>  	return ret;=0A=
>>  }=0A=
>>  =0A=
>> +static int cached_dev_report_zones_cb(struct blk_zone *zone,=0A=
>> +				      unsigned int idx,=0A=
>> +				      void *data)=0A=
>> +{=0A=
>> +	struct bch_report_zones_args *args =3D data;=0A=
>> +	struct bcache_device *d =3D args->bcache_device;=0A=
>> +	struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);=0A=
>> +	unsigned long data_offset =3D dc->sb.data_offset;=0A=
>> +=0A=
>> +	if (zone->start >=3D data_offset) {=0A=
>> +		zone->start -=3D data_offset;=0A=
>> +		zone->wp -=3D data_offset;=0A=
>> +	} else {=0A=
>> +		/*=0A=
>> +		 * Normally the first zone is conventional zone,=0A=
>> +		 * we don't need to worry about how to maintain=0A=
>> +		 * the write pointer.=0A=
>> +		 * But the zone->len is special, because the=0A=
>> +		 * sector 0 on bcache device is 8KB offset on=0A=
>> +		 * backing device indeed.=0A=
>> +		 */=0A=
>> +		zone->len -=3D data_offset;=0A=
>> +	}=0A=
>> +=0A=
>> +	return args->orig_cb(zone, idx, args->orig_data);=0A=
>> +}=0A=
>> +=0A=
>> +static int cached_dev_report_zones(struct bch_report_zones_args *args,=
=0A=
>> +				   unsigned int nr_zones)=0A=
>> +{=0A=
>> +	struct bcache_device *d =3D args->bcache_device;=0A=
>> +	struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);=0A=
>> +	sector_t sector =3D args->sector + dc->sb.data_offset;=0A=
>> +=0A=
>> +	/* sector is real LBA of backing device */=0A=
>> +	return blkdev_report_zones(dc->bdev,=0A=
>> +				   sector,=0A=
>> +				   nr_zones,=0A=
>> +				   cached_dev_report_zones_cb,=0A=
>> +				   args);=0A=
>> +}=0A=
>> +=0A=
>>  void bch_cached_dev_request_init(struct cached_dev *dc)=0A=
>>  {=0A=
>>  	struct gendisk *g =3D dc->disk.disk;=0A=
>> @@ -1241,6 +1314,7 @@ void bch_cached_dev_request_init(struct cached_dev=
 *dc)=0A=
>>  	g->queue->backing_dev_info->congested_fn =3D cached_dev_congested;=0A=
>>  	dc->disk.cache_miss			=3D cached_dev_cache_miss;=0A=
>>  	dc->disk.ioctl				=3D cached_dev_ioctl;=0A=
>> +	dc->disk.report_zones			=3D cached_dev_report_zones;=0A=
>>  }=0A=
>>  =0A=
>>  /* Flash backed devices */=0A=
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c=0A=
>> index 77e9869345e7..7222fcafaf50 100644=0A=
>> --- a/drivers/md/bcache/super.c=0A=
>> +++ b/drivers/md/bcache/super.c=0A=
>> @@ -672,10 +672,32 @@ static int ioctl_dev(struct block_device *b, fmode=
_t mode,=0A=
>>  	return d->ioctl(d, mode, cmd, arg);=0A=
>>  }=0A=
>>  =0A=
>> +=0A=
>> +static int report_zones_dev(struct gendisk *disk,=0A=
>> +			    sector_t sector,=0A=
>> +			    unsigned int nr_zones,=0A=
>> +			    report_zones_cb cb,=0A=
>> +			    void *data)=0A=
>> +{=0A=
>> +	struct bcache_device *d =3D disk->private_data;=0A=
>> +	struct bch_report_zones_args args =3D {=0A=
>> +		.bcache_device =3D d,=0A=
>> +		.sector =3D sector,=0A=
>> +		.orig_data =3D data,=0A=
>> +		.orig_cb =3D cb,=0A=
>> +	};=0A=
>> +=0A=
>> +	if (d->report_zones)=0A=
>> +		return d->report_zones(&args, nr_zones);=0A=
>> +=0A=
>> +	return -EOPNOTSUPP;=0A=
>> +}=0A=
>> +=0A=
>>  static const struct block_device_operations bcache_ops =3D {=0A=
>>  	.open		=3D open_dev,=0A=
>>  	.release	=3D release_dev,=0A=
>>  	.ioctl		=3D ioctl_dev,=0A=
>> +	.report_zones	=3D report_zones_dev,=0A=
>>  	.owner		=3D THIS_MODULE,=0A=
>>  };=0A=
>>  =0A=
>> @@ -808,7 +830,9 @@ static void bcache_device_free(struct bcache_device =
*d)=0A=
>>  	closure_debug_destroy(&d->cl);=0A=
>>  }=0A=
>>  =0A=
>> -static int bcache_device_init(struct bcache_device *d, unsigned int blo=
ck_size,=0A=
>> +static int bcache_device_init(struct cached_dev *dc,=0A=
>> +			      struct bcache_device *d,=0A=
>> +			      unsigned int block_size,=0A=
>>  			      sector_t sectors)=0A=
>>  {=0A=
>>  	struct request_queue *q;=0A=
>> @@ -882,6 +906,17 @@ static int bcache_device_init(struct bcache_device =
*d, unsigned int block_size,=0A=
>>  =0A=
>>  	blk_queue_write_cache(q, true, true);=0A=
>>  =0A=
>> +	/*=0A=
>> +	 * If this is for backing device registration, and it is an=0A=
>> +	 * zoned device (e.g. host-managed S.M.R. hard drive), set=0A=
>> +	 * up zoned device attribution properly for sysfs interface.=0A=
>> +	 */=0A=
>> +	if (dc && bdev_is_zoned(dc->bdev)) {=0A=
>> +		q->limits.zoned =3D bdev_zoned_model(dc->bdev);=0A=
>> +		q->nr_zones =3D blkdev_nr_zones(dc->bdev);=0A=
>> +		q->limits.chunk_sectors =3D bdev_zone_sectors(dc->bdev);=0A=
>> +	}=0A=
>> +=0A=
>>  	return 0;=0A=
>>  =0A=
>>  err:=0A=
>> @@ -1328,7 +1363,7 @@ static int cached_dev_init(struct cached_dev *dc, =
unsigned int block_size)=0A=
>>  		dc->partial_stripes_expensive =3D=0A=
>>  			q->limits.raid_partial_stripes_expensive;=0A=
>>  =0A=
>> -	ret =3D bcache_device_init(&dc->disk, block_size,=0A=
>> +	ret =3D bcache_device_init(dc, &dc->disk, block_size,=0A=
>>  			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset);=0A=
>>  	if (ret)=0A=
>>  		return ret;=0A=
>> @@ -1445,7 +1480,7 @@ static int flash_dev_run(struct cache_set *c, stru=
ct uuid_entry *u)=0A=
>>  =0A=
>>  	kobject_init(&d->kobj, &bch_flash_dev_ktype);=0A=
>>  =0A=
>> -	if (bcache_device_init(d, block_bytes(c), u->sectors))=0A=
>> +	if (bcache_device_init(NULL, d, block_bytes(c), u->sectors))=0A=
>>  		goto err;=0A=
>>  =0A=
>>  	bcache_device_attach(d, c, u - c->uuids);=0A=
>> -- =0A=
>> 2.16.4=0A=
>>=0A=
>>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
