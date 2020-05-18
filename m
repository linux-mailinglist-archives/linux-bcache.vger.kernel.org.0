Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B601D6E5F
	for <lists+linux-bcache@lfdr.de>; Mon, 18 May 2020 02:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgERA7W (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 17 May 2020 20:59:22 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:32862 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgERA7W (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 May 2020 20:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589763576; x=1621299576;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=KaLr0n2UZFE0ROZ2PcWOwJ5qvEM+1p/KeCqtHHZQiZM=;
  b=jthNTwhRgq/+6GI+UcDXaL9/ojVtq/FC/HCQNifUoBn8TMQfOZ9fliOv
   anpREaJ2r07TL7ySwZnJr4/5k8o7M5Lc+Ti3QdZJ1xDWhpl7zla/FlKnM
   jVw2JpqknV6S8yIDNGDjNoPFBhhpqKxu1H30PZz/TIdlm8QJ6wZ2x7VwK
   2aQVl/BqfVVy8DArtMvgxD8jkzsSG/KnmHiswYNL9dTtFoXuDvylRCnG5
   P6lRlfuHrO5z+SC95RpuM06D6WEjMoZ61D/+MtcPpnDHFmQh2am1w+Vjf
   o3ZHnK0Qn3wTz8PGr+Vszzl3AZ4HVzy22JqQ4eb2WfP3bKzS+8yjaqrgH
   A==;
IronPort-SDR: ySzQSfRPfwMZo+so+skmyZYUecBfcYc02r3pAg2+9niXLsPDQ/ThRJvNxls1UIuLTBPcNClzSl
 hjDsBdwmlhaGTGhy35IdVNaNdx1GuCL84Tmz4MEcatoizSD8xEtQzQJdNeYwlhxNZ+5I2J9q65
 sFp7KJDp+mSKl/3hRzrTVoczhOzkorLqyOoXQT4BRJra/ATpjHsLvjyFPzMqtwIh+ja0/SLLbe
 9crjfN80CL5he20ZXAdVW+LhwNrlCSDGam75E9ZSiVH53h67Sg+whvVfU539pWKVnnVDY1n/T3
 lKE=
X-IronPort-AV: E=Sophos;i="5.73,405,1583164800"; 
   d="scan'208";a="240634910"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2020 08:59:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFu8EFQfPw2eLpe0jQIUqLyNgBXZ+BbrqPYm52Y++eNeU84/Niq+X/ncxATKJ5ip5NqsMhPzEQyz+C1+QqOMKMg5PVI2jSvo+6EorpXBzUKMBh7b6d8azDLVLziqUlE1O2UtTYeG4uHx08RBK6lI2CeugRMNUllsNRKt9RkkEcbNEYZRdHgeiTKJJHksyz0zQ53CfLP0t14Sxo//2Y20l801t3kc6+S7Zk153zYgHFFP+8sHRIToV01LUvMZu+CPRzHHUxCMsbaqn+2d+IJLFHrkiUDBYQ3iXQke3BpBpVRuzAZJGxHkWrbac7Dlis8WtPGkLzPP3ZZbWMl5jTMjZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ev3cU+s+xSr524MWC4fjVv4nv4NXzxcipe6sV0loVBY=;
 b=nN0yH7yztJXgUUV4EFun60/6HZo+Z0Bh6iaPnRYQe9SdQHdD0/rWeDVHOoStPTWo4XhcZu/FqNqoGwLPh3m61uk4bZ6f88VARXIcw6zUWgaByheSOB+ibwEoyJai680Fvzq3nb8QyPGe8WEh6Z4PR1x4NW6W/LWQ1k2ylRDcKKbqMA3UyBiyk6L75Ad31iWzE5aNodmoja8gSsstDDTSTNIQ5KtCUZLiNySH4PE7OGNA2WsdTZmHGt6dqD0UoGDun5ABOYebC8pODfNUFbWOihaVurWzeWTwemjG/kjV2dOW7DA6TnlnWtXVLVUbLI6MEVC2Hj69aGUKaum42rZVrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ev3cU+s+xSr524MWC4fjVv4nv4NXzxcipe6sV0loVBY=;
 b=tNVm/EDiqxTco0rDNEgCSm3Ot9mZ4iY8efjhaLTBlI3BEzvCkMkH97OoXPOkDXqSa99kBUobDch2OOgEKAO27NDUyiuHm0NP2IVqbfHnOOctdvAIDa/TSNciYygdT+IaCr1ODua/C99m55Krb0Y8iToRTvsgApQLRKonvqWwE1Y=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6897.namprd04.prod.outlook.com (2603:10b6:a03:227::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Mon, 18 May
 2020 00:59:19 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%6]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 00:59:19 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        Ajay Joshi <Ajay.Joshi@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [RFC PATCH v2 4/4] block: set bi_size to REQ_OP_ZONE_RESET bio
Thread-Topic: [RFC PATCH v2 4/4] block: set bi_size to REQ_OP_ZONE_RESET bio
Thread-Index: AQHWKzXUdIw0hmNt6EmnZmYsVaxSwg==
Date:   Mon, 18 May 2020 00:59:18 +0000
Message-ID: <BY5PR04MB6900FDE1CD0D754084FCCA38E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-5-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bb3f2b57-bc77-43f8-c752-08d7fac6b1e4
x-ms-traffictypediagnostic: BY5PR04MB6897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB68978AABF3CBAB6A0D71B46BE7B80@BY5PR04MB6897.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +3CTyjiDa/HykJmwBA24mvVPSUPaY18DeXPqNqHvETkagxUFXXotdHC+1EMpg4wcFnsM0NHSfEYsS5hZHvobj8X9dFGZX4c1J+3QvcKnIAX9UojL0U30oo2vk1UK6Et69OiFIFIH5Axx/y2NXZNxlGijVNTz+KD1WMpDbkFbxQnG578vAZ8ojS39+iWJIC3S0RsXvUEzuo74hKOAzR8s6WlQQIhhPc5+4P5o28iFBuq0qCHE+ftt5Tce0B7uyQluRumQ+2362J/eq/o/U8N6QS7fbN2GVq5UMYK2oHYa+oxFWyncJeS6DvoTYXDPG9cq9hHFcuesbrkS/th5rg7pirvVCCHDgPu/1JzdpWihKP4U6RcimjnlNp9Ys7ttssfEA9KnrQ+Foadyieid6NtEH0QtLX/H0WpCtc0mKfJE0zRTq5zWGhhp/kKOQwZt9Pn6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(478600001)(64756008)(66446008)(66556008)(110136005)(55016002)(316002)(52536014)(76116006)(4326008)(66476007)(66946007)(8936002)(9686003)(2906002)(186003)(71200400001)(6506007)(53546011)(26005)(7696005)(33656002)(86362001)(54906003)(5660300002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1KA0GFGH4hJmwxVBRRz6b0lRZDsF9i/z3o4ie04E4stqmOCg6R8zmDM3FVY2LAt2UtxeSdvPiMKcU1BOgHiC9AyHLUTm4U8zPGRqjjrJzMhbTt/uS0Qn3rl+73cPJ6CAhmhgzfV8R1h1j1qSKhh6x+3trXpdNFQLZCr7XkXXSXMXyu9LB8k0ifQhqn3bR3ayT/JvEFwd8tGQHFl/VHpk6tjKyvyi/lYuagBvq5o7EJIyf77OnVMHLjLeNOJnrnNuh9Es39IHD4N8Lz3YWuuMlR0o33wQygsLInx2qb9vikl39sudOwdeAQfWCy6LVC3aAJ8ntu7LWPLpGhD+x9WYTc0/scplZMWSaVtujbZrz8cHWsgiwYVFE+f8BtIiEe4Q4QhF4myz6Y60mDMa/rsugt2T1JCxdAXgRz2Kky2sFaVM5aptlsl9flknN2yGgXrhsCxC9bHdVZNmbU0GWac4CYmJIKShiT0SBDDPnAFgSi16gkh0gnlFyU2PpbCfGr80
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb3f2b57-bc77-43f8-c752-08d7fac6b1e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 00:59:18.9302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a854V9e6tAb5FKBaVK9yFH1eOao5jY6Mml5MmpgUEX8fG//GXuUJdjhAVx1DeWUaYK0rGJLAhHNcL/57PgWP+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6897
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/16 12:55, Coly Li wrote:=0A=
> Now for zoned device, zone management ioctl commands are converted into=
=0A=
> zone management bios and handled by blkdev_zone_mgmt(). There are 4 zone=
=0A=
> management bios are handled, their op code is,=0A=
> - REQ_OP_ZONE_RESET=0A=
>   Reset the zone's writer pointer and empty all previously stored data.=
=0A=
> - REQ_OP_ZONE_OPEN=0A=
>   Open the zones in the specified sector range, no influence on data.=0A=
> - REQ_OP_ZONE_CLOSE=0A=
>   Close the zones in the specified sector range, no influence on data.=0A=
> - REQ_OP_ZONE_FINISH=0A=
>   Mark the zone as full, no influence on data.=0A=
> All the zone management bios has 0 byte size, a.k.a their bi_size is 0.=
=0A=
> =0A=
> Exept for REQ_OP_ZONE_RESET request, zero length bio works fine for=0A=
> other zone management bio, before the zoned device e.g. host managed SMR=
=0A=
> hard drive can be created as a bcache device.=0A=
> =0A=
> When a bcache device (virtual block device to forward bios like md raid=
=0A=
> drivers) can be created on top of the zoned device, and a fast SSD is=0A=
> attached as a cache device, bcache driver may cache the frequent random=
=0A=
> READ requests on fast SSD to accelerate hot data READ performance.=0A=
> =0A=
> When bcache driver receives a zone management bio for REQ_OP_ZONE_RESET=
=0A=
> op, while forwarding the request to underlying zoned device e.g. host=0A=
> managed SMR hard drive, it should also invalidate all cached data from=0A=
> SSD for the resetting zone. Otherwise bcache will continue provide the=0A=
> outdated cached data to READ request and cause potential data storage=0A=
> inconsistency and corruption.=0A=
> =0A=
> In order to invalidate outdated data from SSD for the reset zone, bcache=
=0A=
> needs to know not only the start LBA but also the range length of the=0A=
> resetting zone. Otherwise, bcache won't be able to accurately invalidate=
=0A=
> the outdated cached data.=0A=
> =0A=
> Is it possible to simply set the bi_size inside bcache driver? The=0A=
> answer is NO. Although every REQ_OP_ZONE_RESET bio has exact length as=0A=
> zone size or q->limits.chunk_sectors, it is possible that some other=0A=
> layer stacking block driver (in the future) exists between bcache driver=
=0A=
> and blkdev_zone_mgmt() where the zone management bio is made.=0A=
=0A=
But bcache "knows" what underlying devices it is using, right ? So getting =
the=0A=
SMR drive zone size using blk_queue_zone_sectors(), bdev_zone_sectors() or =
by=0A=
directly accessing q->limits->chunk_sectors should not be a problem at all,=
 no ?=0A=
=0A=
> =0A=
> The best location to set bi_size is where the zone management bio is=0A=
> composed in blkdev_zone_mgmt(), then no matter how this bio is split=0A=
> before bcache driver receives it, bcache driver can always correctly=0A=
> invalidate the resetting range.=0A=
> =0A=
> This patch sets the bi_size of REQ_OP_ZONE_RESET bio for each resetting=
=0A=
> zone. Here REQ_OP_ZONE_RESET_ALL is special whose bi_size should be set=
=0A=
> as capacity of whole drive size, then bcache can invalidate all cached=0A=
> data from SSD for the zoned backing device.=0A=
=0A=
NACK. The problem here is that struct bio_vec bv_len field and struct bvec_=
iter=0A=
bi_size field are both "unsigned int". So they can describe at most 4G x 51=
2B =3D=0A=
2TB ranges. For REQ_OP_ZONE_RESET_ALL, that is simply way too small (we alr=
eady=0A=
are at 20TB capacity for SMR). One cannot issue a BIO with a length that is=
 the=0A=
entire disk capacity.=0A=
=0A=
I really think that bcache should handle the zone management ops as a speci=
al=0A=
case. I understand the goal of trying to minimize that by integrating them =
as=0A=
much as possible into the regular bcache IO path, but that really seems=0A=
dangerous to me. Since these operations will need remapping in bcache anywa=
y=0A=
(for handling the first hidden zone containing the super block), all specia=
l=0A=
processing can be done under a single "if" which should not impact too much=
=0A=
performance of regular read/write commands in the hot path.=0A=
=0A=
Device mapper has such code: see __split_and_process_bio() and its use of=
=0A=
op_is_zone_mgmt() function to handle zone management requests slightly=0A=
differently than other BIOs. That remove the need for relying on op_is_writ=
e()=0A=
direction (patch 1 and 2 in this series) for reset zones too, which in the =
end=0A=
will I think make your bcache code a lot more solid.=0A=
=0A=
> =0A=
> With this change, now bcache code can handle REQ_OP_ZONE_RESET bio in=0A=
> the way very similar to REQ_OP_DISCARD bio with very little change.=0A=
> =0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Ajay Joshi <ajay.joshi@wdc.com>=0A=
> Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> Cc: Keith Busch <kbusch@kernel.org>=0A=
> ---=0A=
> Changelog:=0A=
> v2: fix typo for REQ_OP_ZONE_RESET_ALL.=0A=
> v1: initial version.=0A=
> =0A=
>  block/blk-zoned.c | 4 ++++=0A=
>  1 file changed, 4 insertions(+)=0A=
> =0A=
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
> index 1e0708c68267..01d91314399b 100644=0A=
> --- a/block/blk-zoned.c=0A=
> +++ b/block/blk-zoned.c=0A=
> @@ -227,11 +227,15 @@ int blkdev_zone_mgmt(struct block_device *bdev, enu=
m req_opf op,=0A=
>  		if (op =3D=3D REQ_OP_ZONE_RESET &&=0A=
>  		    blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {=0A=
>  			bio->bi_opf =3D REQ_OP_ZONE_RESET_ALL;=0A=
> +			bio->bi_iter.bi_sector =3D sector;=0A=
> +			bio->bi_iter.bi_size =3D nr_sectors;=0A=
>  			break;=0A=
>  		}=0A=
>  =0A=
>  		bio->bi_opf =3D op | REQ_SYNC;=0A=
>  		bio->bi_iter.bi_sector =3D sector;=0A=
> +		if (op =3D=3D REQ_OP_ZONE_RESET)=0A=
> +			bio->bi_iter.bi_size =3D zone_sectors;=0A=
>  		sector +=3D zone_sectors;=0A=
>  =0A=
>  		/* This may take a while, so be nice to others */=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
