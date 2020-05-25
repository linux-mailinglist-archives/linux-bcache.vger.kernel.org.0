Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BC21E0454
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 03:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387942AbgEYBKd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 May 2020 21:10:33 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:59482 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbgEYBKd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 May 2020 21:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590369031; x=1621905031;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=sJHw06FAEPsZ1BgZpx1Rh7SITdQkS3JbqHuD6qbG4Ww=;
  b=dUqX534+iBsKosohKFkjMfSRTdUgVrIqNkmc/KnOpKgT2moa12yJ9Zwh
   u7IHFKRGZVUlaxmaA+WLBfoMYa87F9odG4u1bBqr6YNOsktikZo5AYxBD
   wSlE7xd/VHi34XfEdCHAcVZNg8g/mWKr70m6fB9BP2hi1BkwuU+a+dZyc
   dyHRvwYJL5+Fsva7XXwxDgMXnsZyKf1fZgLCXbByxcJOzTr2iRkTzBMEH
   4kzAgpRcalOwyuhYXhitBbit/LiolPQSLWoT7T5P5tAOMTU3XLHxwBc0f
   u0Xc+cu34WU/kHPLRf+ea5VZ74uagnxXn7edlCy84mUhNy7nNxeZmQPJi
   w==;
IronPort-SDR: Uz+AKgREoE/y8DIIZAZEqL+HLl3qErzJT9pMLqnSsmRVveYwj679BDn7kWjqrDgi6Ez4ba8ZKS
 aq9aHVJj0y4G/vsh0nt1VCW5wZyd0dfnI/ZxtAL6rwvLeAOkhdpHtwLcy7v3KM+X7EaM3tuKgO
 oPhhqGvTA8ocyUj+EzbFHr8Jk5eZZjwPisQrmlpslDGOajXTfyBKIW6Z1VFMZXXZchQ+D2uy6W
 WZlY3i6/fk9BAzc/1xuYTVZpyYDbbT0NyLx7hVY69wgRHsddO2/ffOR8IGmpfHSNdCa+4EYE7B
 7/c=
X-IronPort-AV: E=Sophos;i="5.73,431,1583164800"; 
   d="scan'208";a="139865887"
Received: from mail-sn1nam04lp2050.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.50])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2020 09:10:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KA9NF4/qTMvioC5A1pD45mnkVE5ZIDDconVQogsAVuXJ0Pz5LY9RxNOHwkKm3rGvDtnJHMiHR85GfkdRKqndtFRFwEeTqSTIpUv7+DgiK2+vOctKwm1lROpDCjiG7I3+4SLUrDd2f0QFFLwS2AGa+0lJDwRxpXz/zilNHP9W+arguERH32+Ecf6ovP2WeEoCyHD5+YrxFBFHNxCBcrMV/eGPCe7rDtvWNHLm8OdQG+9re6rCB35Kca8KYc3SvjfRTA5birnMA+9ngCjGzPeIkZSNHdIfGt4XOnGOjtV307oAnwYV0dcUyE0xwp+2tdxRUFtFd7yQTyizAX3kaHS4VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6CE4qtcfvJ9ZEXek/g/FErmgU1pxIb62HDpZgbXeBE=;
 b=cqY7oeaEMtiFK95pgSsaP3ukxpxpgXvJXmbpgxjJjDXEd+/1hwJ9N22Ob8xR8JFKNfr9ZUH+tl71GGiVPqBJl0Tu0EavscFm4gm2J2JxIhLAtHklttyjUO5wMMcoLunhousFD9eX2mdFuLSSE7X30lA+GnC1ECS1R8wbLzAfvqISnaT0vVJ1EJinuXGgcXn+SWg394ol5NR/q8pkc/D6KqOEv+sOXJTNJ0JYD6fOua5Cko0sf6dGkJYYNVygGkkXtEXHNrvGpDPrB684Tiums3msZ9Eo4e2yBhKfQRLrufphDkOGuFakOg9E/y/k3tQQzf1Lp18oSivuRgU5Sk5hQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6CE4qtcfvJ9ZEXek/g/FErmgU1pxIb62HDpZgbXeBE=;
 b=YwoHj2HUh1Csn26ZZtRfgvGyKJlQDQLcZu2eTiHdPKY3yQidZ22OV0kypAAtVtvH60WP67FQ3FV70uAj17ZuzEp+A3sXaLNF+eH8iqjA6M/72O9CUV599WX4e49MfP+zdregOMLDZYjyGLPS1TekjnAOxjoo6Jbzxpa87Qg4gRU=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1191.namprd04.prod.outlook.com (2603:10b6:903:b6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 01:10:27 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 01:10:27 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [RFC PATCH v4 1/3] bcache: export bcache zone information for
 zoned backing device
Thread-Topic: [RFC PATCH v4 1/3] bcache: export bcache zone information for
 zoned backing device
Thread-Index: AQHWMDMpe06BbBUQGkCzgleoTRnAkw==
Date:   Mon, 25 May 2020 01:10:27 +0000
Message-ID: <CY4PR04MB37519681E8730119C1C74A75E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-2-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd5c8e02-c8fb-4ee5-90cd-08d800486929
x-ms-traffictypediagnostic: CY4PR04MB1191:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB11912721941A32E4D27143B5E7B30@CY4PR04MB1191.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ExlmTdSDE0QHeysDaH6jMQBlolrRKByyrsZkb83a8oAyFH53BHLkHBEG1j5LB8fCJ+Rn6uM9gOxtVlVmTz2Gysvh/YbULgftEItgOpa8HA6cT4p2j796ZKEdzpOXZdIfXu/O08jOhTMhPj+XDIWQnsOgzv8LB6YTLy8VzZFdnopJveCjZKtd8UQODxYyS5AfbbwoV6XGQRTotKK3C4dcvevI8qyOFU0mmrp1wmBnAtvMFiLlNFOQMw66A2+PtovJp33vto8xB+HQ8ht0nq2hkJutN/2x10jPbpN8R3tQRQrwEoLhw007j/urV7WC/+j+IvHP0FLLQ3GAvWOVEKkicQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(5660300002)(86362001)(33656002)(2906002)(4326008)(66946007)(9686003)(55016002)(66476007)(76116006)(91956017)(66556008)(66446008)(64756008)(478600001)(52536014)(71200400001)(8676002)(110136005)(30864003)(8936002)(316002)(7696005)(6506007)(54906003)(186003)(26005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1z+sA2onfpZe4P+oAbGCr0rLKOkNZ+DecJ+70fZ4aGA7XCnWEKGvis6lZ2n3/6JKUsGHe1PTQdUDU992MJSryj+GUeFkiiRu0Ku1EORyKOlmucNGCUcexJe/pmNA5877t9MJAzMo8olOSeu6O9LMkyXwjyT6oypmiKUl3AxTBTSgUSRiZTm6XNau0eQmgX6+oBczQxdvTDjnk5AyQmZX8sjalQtBY8oJ+hrAMQqrOBClIuOpl0JaPAGgZU9Sa3iwlV1mVHgfVDKzuPYkX6M/l0ErkPMaBSSDFrpUV5q4tg7NXvnQt4bFOT6h33e4w7Ez4KJP3eiJ8j71h0llLueFgCqzQ2ivUDMgXwCkM3LLC/FjQGkZ/5Q7CRbVgKQeALjsMISXUE9dqFWjTxQCS0IA+ZWNjoQp03QTPQWOJmpN29krkXgj73rh958UEPxmkh1A66VE+QOiL4gZ55R6fIOenjzAWY6JdmL/6s9wNSyd/ns=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5c8e02-c8fb-4ee5-90cd-08d800486929
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 01:10:27.3712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oCQsShJoosNs6Df8Tt/GTRr5OhlNz1hgRpPOLL9rXejEZuosKLPiSUTHeba4IgfsTPkSBz1zGQ2+WnkesaErLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1191
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/22 21:18, Coly Li wrote:=0A=
> When using a zoned device e.g. SMR hard drive as the backing device,=0A=
> if bcache can export the zoned device information then it is possible=0A=
> to help the upper layer code to accelerate hot READ I/O requests.=0A=
> =0A=
> This patch adds the report_zones method for the bcache device which has=
=0A=
> zoned device as backing device. Now such bcache device can be treated as=
=0A=
> a zoned device, by configured to writethrough, writearound mode or none=
=0A=
> mode, zonefs can be formated on top of such bcache device.=0A=
> =0A=
> Here is a simple performance data for read requests via zonefs on top of=
=0A=
> bcache. The cache device of bcache is a 4TB NVMe SSD, the backing device=
=0A=
> is a 14TB host managed SMR hard drive. The formatted zonefs has 52155=0A=
> zone files, 523 of them are for convential zones (1 zone is reserved=0A=
=0A=
s/convential/conventional=0A=
=0A=
> for bcache super block and not reported), 51632 of them are for=0A=
> sequential zones.=0A=
> =0A=
> First run to read first 4KB from all the zone files with 50 processes,=0A=
> it takes 5 minutes 55 seconds. Second run takes 12 seconds only because=
=0A=
> all the read requests hit on cache device.=0A=
=0A=
Did you write anything first to the bcache device ? Otherwise, all zonefs f=
iles=0A=
will be empty and there is not going to be any file access... Question thou=
gh:=0A=
when writing to a bcache device with writethrough mode, does the data go to=
 the=0A=
SSD cache too ? Or is it written only to the backend device ?=0A=
=0A=
> =0A=
> 29 times faster is as expected for an ideal case when all READ I/Os hit=
=0A=
> on NVMe cache device.=0A=
> =0A=
> Besides providing report_zones method of the bcache gendisk structure,=0A=
> this patch also initializes the following zoned device attribution for=0A=
> the bcache device,=0A=
> - zones number: the total zones number minus reserved zone(s) for bcache=
=0A=
=0A=
s/zones number/number of zones=0A=
=0A=
>   super block.=0A=
> - zone size: same size as reported from the underlying zoned device=0A=
> - zone mode: same mode as reported from the underlying zoned device=0A=
=0A=
s/zone mode/zoned model=0A=
=0A=
> Currently blk_revalidate_disk_zones() does not accept non-mq drivers, so=
=0A=
> all the above attribution are initialized mannally in bcache code.=0A=
=0A=
s/mannally/manually=0A=
=0A=
> =0A=
> This patch just provides the report_zones method only. Handling all zone=
=0A=
> management commands will be addressed in following patches.=0A=
> =0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.com>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
> Changelog:=0A=
> v4: the version without any generic block layer change.=0A=
> v3: the version depends on other generic block layer changes.=0A=
> v2: an improved version for comments.=0A=
> v1: initial version.=0A=
>  drivers/md/bcache/bcache.h  | 10 ++++=0A=
>  drivers/md/bcache/request.c | 69 ++++++++++++++++++++++++++=0A=
>  drivers/md/bcache/super.c   | 96 ++++++++++++++++++++++++++++++++++++-=
=0A=
>  3 files changed, 174 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h=0A=
> index 74a9849ea164..0d298b48707f 100644=0A=
> --- a/drivers/md/bcache/bcache.h=0A=
> +++ b/drivers/md/bcache/bcache.h=0A=
> @@ -221,6 +221,7 @@ BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);=0A=
>  struct search;=0A=
>  struct btree;=0A=
>  struct keybuf;=0A=
> +struct bch_report_zones_args;=0A=
>  =0A=
>  struct keybuf_key {=0A=
>  	struct rb_node		node;=0A=
> @@ -277,6 +278,8 @@ struct bcache_device {=0A=
>  			  struct bio *bio, unsigned int sectors);=0A=
>  	int (*ioctl)(struct bcache_device *d, fmode_t mode,=0A=
>  		     unsigned int cmd, unsigned long arg);=0A=
> +	int (*report_zones)(struct bch_report_zones_args *args,=0A=
> +			    unsigned int nr_zones);=0A=
>  };=0A=
>  =0A=
>  struct io {=0A=
> @@ -748,6 +751,13 @@ struct bbio {=0A=
>  	struct bio		bio;=0A=
>  };=0A=
>  =0A=
> +struct bch_report_zones_args {=0A=
> +	struct bcache_device *bcache_device;=0A=
> +	sector_t sector;=0A=
> +	void *orig_data;=0A=
> +	report_zones_cb orig_cb;=0A=
> +};=0A=
> +=0A=
>  #define BTREE_PRIO		USHRT_MAX=0A=
>  #define INITIAL_PRIO		32768U=0A=
>  =0A=
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c=0A=
> index 71a90fbec314..34f63da2338d 100644=0A=
> --- a/drivers/md/bcache/request.c=0A=
> +++ b/drivers/md/bcache/request.c=0A=
> @@ -1233,6 +1233,30 @@ static int cached_dev_ioctl(struct bcache_device *=
d, fmode_t mode,=0A=
>  	if (dc->io_disable)=0A=
>  		return -EIO;=0A=
>  =0A=
> +	/*=0A=
> +	 * All zoned device ioctl commands are handled in=0A=
> +	 * other code paths,=0A=
> +	 * - BLKREPORTZONE: by report_zones method of bcache_ops.=0A=
> +	 * - BLKRESETZONE/BLKOPENZONE/BLKCLOSEZONE/BLKFINISHZONE: all handled=
=0A=
> +	 *   by bio code path.=0A=
> +	 * - BLKGETZONESZ/BLKGETNRZONES:directly handled inside generic block=
=0A=
> +	 *   ioctl handler blkdev_common_ioctl().=0A=
> +	 */=0A=
> +	switch (cmd) {=0A=
> +	case BLKREPORTZONE:=0A=
> +	case BLKRESETZONE:=0A=
> +	case BLKGETZONESZ:=0A=
> +	case BLKGETNRZONES:=0A=
> +	case BLKOPENZONE:=0A=
> +	case BLKCLOSEZONE:=0A=
> +	case BLKFINISHZONE:=0A=
> +		pr_warn("Zoned device ioctl cmd should not be here.\n");=0A=
> +		return -EOPNOTSUPP;=0A=
> +	default:=0A=
> +		/* Other commands  */=0A=
> +		break;=0A=
> +	}=0A=
> +=0A=
>  	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);=0A=
>  }=0A=
>  =0A=
> @@ -1261,6 +1285,50 @@ static int cached_dev_congested(void *data, int bi=
ts)=0A=
>  	return ret;=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * The callback routine to parse a specific zone from all reporting=0A=
> + * zones. args->orig_cb() is the upper layer report zones callback,=0A=
> + * which should be called after the LBA conversion.=0A=
> + * Notice: all zones after zone 0 will be reported, including the=0A=
> + * offlined zones, how to handle the different types of zones are=0A=
> + * fully decided by upper layer who calss for reporting zones of=0A=
> + * the bcache device.=0A=
> + */=0A=
> +static int cached_dev_report_zones_cb(struct blk_zone *zone,=0A=
> +				      unsigned int idx,=0A=
> +				      void *data)=0A=
=0A=
I do not think you need the line break for the last argument.=0A=
=0A=
> +{=0A=
> +	struct bch_report_zones_args *args =3D data;=0A=
> +	struct bcache_device *d =3D args->bcache_device;=0A=
> +	struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);=0A=
> +	unsigned long data_offset =3D dc->sb.data_offset;=0A=
> +=0A=
> +	/* Zone 0 should not be reported */=0A=
> +	BUG_ON(zone->start < data_offset);=0A=
=0A=
Wouldn't a WARN_ON_ONCE and return -EIO be better here ?=0A=
=0A=
> +=0A=
> +	/* convert back to LBA of the bcache device*/=0A=
> +	zone->start -=3D data_offset;=0A=
> +	zone->wp -=3D data_offset;=0A=
=0A=
This has to be done depending on the zone type and zone condition: zone->wp=
 is=0A=
"invalid" for conventional zones, and sequential zones that are full, read-=
only=0A=
or offline. So you need something like this:=0A=
=0A=
	/* Remap LBA to the bcache device */=0A=
	zone->start -=3D data_offset;=0A=
	switch(zone->cond) {=0A=
	case BLK_ZONE_COND_NOT_WP:=0A=
	case BLK_ZONE_COND_READONLY:=0A=
	case BLK_ZONE_COND_FULL:=0A=
	case BLK_ZONE_COND_OFFLINE:=0A=
		break;=0A=
	case BLK_ZONE_COND_EMPTY:=0A=
		zone->wp =3D zone->start;=0A=
		break;=0A=
	default:=0A=
		zone->wp -=3D data_offset;=0A=
		break;=0A=
	}=0A=
=0A=
	return args->orig_cb(zone, idx, args->orig_data);=0A=
=0A=
> +=0A=
> +	return args->orig_cb(zone, idx, args->orig_data);=0A=
> +}=0A=
> +=0A=
> +static int cached_dev_report_zones(struct bch_report_zones_args *args,=
=0A=
> +				   unsigned int nr_zones)=0A=
> +{=0A=
> +	struct bcache_device *d =3D args->bcache_device;=0A=
> +	struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);=0A=
> +	/* skip zone 0 which is fully occupied by bcache super block */=0A=
> +	sector_t sector =3D args->sector + dc->sb.data_offset;=0A=
> +=0A=
> +	/* sector is real LBA of backing device */=0A=
> +	return blkdev_report_zones(dc->bdev,=0A=
> +				   sector,=0A=
> +				   nr_zones,=0A=
> +				   cached_dev_report_zones_cb,=0A=
> +				   args);=0A=
=0A=
You could have multiple arguments on a couple of lines only here...=0A=
=0A=
> +}=0A=
> +=0A=
>  void bch_cached_dev_request_init(struct cached_dev *dc)=0A=
>  {=0A=
>  	struct gendisk *g =3D dc->disk.disk;=0A=
> @@ -1268,6 +1336,7 @@ void bch_cached_dev_request_init(struct cached_dev =
*dc)=0A=
>  	g->queue->backing_dev_info->congested_fn =3D cached_dev_congested;=0A=
>  	dc->disk.cache_miss			=3D cached_dev_cache_miss;=0A=
>  	dc->disk.ioctl				=3D cached_dev_ioctl;=0A=
> +	dc->disk.report_zones			=3D cached_dev_report_zones;=0A=
=0A=
Why set this method unconditionally ? Should it be set only for a zoned bca=
che=0A=
device ? E.g.:=0A=
	=0A=
	if (bdev_is_zoned(bcache bdev))=0A=
		dc->disk.report_zones =3D cached_dev_report_zones;=0A=
=0A=
>  }=0A=
>  =0A=
>  /* Flash backed devices */=0A=
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c=0A=
> index d98354fa28e3..d5da7ad5157d 100644=0A=
> --- a/drivers/md/bcache/super.c=0A=
> +++ b/drivers/md/bcache/super.c=0A=
> @@ -679,10 +679,36 @@ static int ioctl_dev(struct block_device *b, fmode_=
t mode,=0A=
>  	return d->ioctl(d, mode, cmd, arg);=0A=
>  }=0A=
>  =0A=
> +static int report_zones_dev(struct gendisk *disk,=0A=
> +			    sector_t sector,=0A=
> +			    unsigned int nr_zones,=0A=
> +			    report_zones_cb cb,=0A=
> +			    void *data)=0A=
> +{=0A=
> +	struct bcache_device *d =3D disk->private_data;=0A=
> +	struct bch_report_zones_args args =3D {=0A=
> +		.bcache_device =3D d,=0A=
> +		.sector =3D sector,=0A=
> +		.orig_data =3D data,=0A=
> +		.orig_cb =3D cb,=0A=
> +	};=0A=
> +=0A=
> +	/*=0A=
> +	 * only bcache device with backing device has=0A=
> +	 * report_zones method, flash device does not.=0A=
> +	 */=0A=
> +	if (d->report_zones)=0A=
> +		return d->report_zones(&args, nr_zones);=0A=
> +=0A=
> +	/* flash dev does not have report_zones method */=0A=
=0A=
This comment is confusing. Report zones is called against the bcache device=
, not=0A=
against its components... In any case, if the bcache device is not zoned, t=
he=0A=
report_zones method will never be called by the block layer. So you probabl=
y=0A=
should just check that on entry:=0A=
=0A=
	if (WARN_ON_ONCE(!blk_queue_is_zoned(disk->queue))=0A=
		return -EOPNOTSUPP;=0A=
=0A=
	return d->report_zones(&args, nr_zones);=0A=
=0A=
> +	return -EOPNOTSUPP;=0A=
> +}=0A=
> +=0A=
>  static const struct block_device_operations bcache_ops =3D {=0A=
>  	.open		=3D open_dev,=0A=
>  	.release	=3D release_dev,=0A=
>  	.ioctl		=3D ioctl_dev,=0A=
> +	.report_zones	=3D report_zones_dev,=0A=
>  	.owner		=3D THIS_MODULE,=0A=
>  };=0A=
=0A=
Same here. It may be better to set the report zones method only for a zoned=
=0A=
bcache dev. So you will need an additional block_device_operations struct f=
or=0A=
that type.=0A=
=0A=
static const struct block_device_operations bcache_zoned_ops =3D {=0A=
 	.open		=3D open_dev,=0A=
 	.release	=3D release_dev,=0A=
 	.ioctl		=3D ioctl_dev,=0A=
	.report_zones	=3D report_zones_dev,=0A=
 	.owner		=3D THIS_MODULE,=0A=
};=0A=
=0A=
>  =0A=
> @@ -817,6 +843,7 @@ static void bcache_device_free(struct bcache_device *=
d)=0A=
>  =0A=
>  static int bcache_device_init(struct bcache_device *d, unsigned int bloc=
k_size,=0A=
>  			      sector_t sectors, make_request_fn make_request_fn)=0A=
> +=0A=
>  {=0A=
>  	struct request_queue *q;=0A=
>  	const size_t max_stripes =3D min_t(size_t, INT_MAX,=0A=
> @@ -1307,6 +1334,67 @@ static void cached_dev_flush(struct closure *cl)=
=0A=
>  	continue_at(cl, cached_dev_free, system_wq);=0A=
>  }=0A=
>  =0A=
> +static inline int cached_dev_data_offset_check(struct cached_dev *dc)=0A=
> +{=0A=
> +	if (!bdev_is_zoned(dc->bdev))=0A=
> +		return 0;=0A=
> +=0A=
> +	/*=0A=
> +	 * If the backing hard drive is zoned device, sb.data_offset=0A=
> +	 * should be aligned to zone size, which is automatically=0A=
> +	 * handled by 'bcache' util of bcache-tools. If the data_offset=0A=
> +	 * is not aligned to zone size, it means the bcache-tools is=0A=
> +	 * outdated.=0A=
> +	 */=0A=
> +	if (dc->sb.data_offset & (bdev_zone_sectors(dc->bdev) - 1)) {=0A=
> +		pr_err("data_offset %llu is not aligned to zone size %llu, please upda=
te bcache-tools and re-make the zoned backing device.\n",=0A=
=0A=
Long line... May be split the pr_err in 2 calls ?=0A=
=0A=
> +			dc->sb.data_offset, bdev_zone_sectors(dc->bdev));=0A=
> +		return -EINVAL;=0A=
> +	}=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
> +/*=0A=
> + * Initialize zone information for the bcache device, this function=0A=
> + * assumes the bcache device has a cached device (dc !=3D NULL), and=0A=
> + * the cached device is zoned device (bdev_is_zoned(dc->bdev) =3D=3D tru=
e).=0A=
> + *=0A=
> + * The following zone information of the bcache device will be set,=0A=
> + * - zoned mode, same as the mode of zoned backing device=0A=
> + * - zone size in sectors, same as the zoned backing device=0A=
> + * - zones number, it is zones number of zoned backing device minus the=
=0A=
> + *   reserved zones for bcache super blocks.=0A=
> + */=0A=
> +static int bch_cached_dev_zone_init(struct cached_dev *dc)=0A=
> +{=0A=
> +	struct request_queue *d_q, *b_q;=0A=
> +	enum blk_zoned_model mode;=0A=
=0A=
To be clear, may be call this variable "model" ?=0A=
=0A=
> +=0A=
> +	if (!bdev_is_zoned(dc->bdev))=0A=
> +		return 0;=0A=
> +=0A=
> +	/* queue of bcache device */=0A=
> +	d_q =3D dc->disk.disk->queue;=0A=
> +	/* queue of backing device */=0A=
> +	b_q =3D bdev_get_queue(dc->bdev);=0A=
> +=0A=
> +	mode =3D blk_queue_zoned_model(b_q);=0A=
> +	if (mode !=3D BLK_ZONED_NONE) {=0A=
> +		d_q->limits.zoned =3D mode;=0A=
> +		blk_queue_chunk_sectors(d_q, b_q->limits.chunk_sectors);=0A=
> +		/*=0A=
> +		 * (dc->sb.data_offset / q->limits.chunk_sectors) is the=0A=
> +		 * zones number reserved for bcache super block. By default=0A=
> +		 * it is set to 1 by bcache-tools.=0A=
> +		 */=0A=
> +		d_q->nr_zones =3D b_q->nr_zones -=0A=
> +			(dc->sb.data_offset / d_q->limits.chunk_sectors);=0A=
=0A=
Does this compile on 32bits arch ? Don't you need a do_div() here ?=0A=
=0A=
> +	}=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
>  static int cached_dev_init(struct cached_dev *dc, unsigned int block_siz=
e)=0A=
>  {=0A=
>  	int ret;=0A=
> @@ -1333,6 +1421,10 @@ static int cached_dev_init(struct cached_dev *dc, =
unsigned int block_size)=0A=
>  =0A=
>  	dc->disk.stripe_size =3D q->limits.io_opt >> 9;=0A=
>  =0A=
> +	ret =3D cached_dev_data_offset_check(dc);=0A=
> +	if (ret)=0A=
> +		return ret;=0A=
> +=0A=
>  	if (dc->disk.stripe_size)=0A=
>  		dc->partial_stripes_expensive =3D=0A=
>  			q->limits.raid_partial_stripes_expensive;=0A=
> @@ -1355,7 +1447,9 @@ static int cached_dev_init(struct cached_dev *dc, u=
nsigned int block_size)=0A=
>  =0A=
>  	bch_cached_dev_request_init(dc);=0A=
>  	bch_cached_dev_writeback_init(dc);=0A=
> -	return 0;=0A=
> +	ret =3D bch_cached_dev_zone_init(dc);=0A=
> +=0A=
> +	return ret;=0A=
>  }=0A=
>  =0A=
>  /* Cached device - bcache superblock */=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
