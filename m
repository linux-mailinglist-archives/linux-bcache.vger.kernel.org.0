Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CB71E045B
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 03:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388194AbgEYBY5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 May 2020 21:24:57 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:54708 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388104AbgEYBY5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 May 2020 21:24:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590369914; x=1621905914;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=RjKYIxWYqyCG4Vew/qvzKH4cvBUhvcVTtbsh2GXqzpY=;
  b=JOUr7p7pqlOOJVsNnkVn8jJXQjDSQsYjuEPkT+UW3GmhjAf+nFY8P+5W
   lBFR8Bv3SNPI55IFN9R0+M0Lzwkw/AA7uL7TSVs0O/mJ2mc8pCwZuztwS
   iveBMhfznoNCxKZWRa5F8haD8kGn8WkxlfwnbZfD0qBkbeZLdqpIyG7R4
   bdZcwg40GZiZ8wL/yNucby7q+UqNjdpi1kcz7CrohBrgePRi3V7q51IFB
   lqpjX9P4VgfzJZ50mrnm0E/Pdk5fzadP8g3OAVorNBf93/l9C9z1lIdRQ
   8HpP2fSzjvHlHY4gsxEkaDo36hkA2jKF9Qfnu4HOrSiNTaSBvhykAkyRp
   g==;
IronPort-SDR: GTnvhTQrirKe4LPgFu2QWvqEBaZraihc/WXdpvCyE09rofBRokfOPqfumpYlfnLkKr7zC/wdUm
 08FPk+l3sNewkKCzkNSAu5qnzQsLEcxEf+GY1GIhv9jZ6glNmOrQDEP0VozvPkCX32MnSUo/Mt
 TRsTNYVfmWKz62+IveUo33as5ZBkONMVwaBG7adsNCnUQGENtNL/Z9/YNzvC0iThrVcxnIy+cx
 8qKtVDe3kJ0/OV2XfqIvUjB2OVNSLu4qwx2oQdVWMC+/9Lwo/ZgYdaBKAIujFTzBGJJ/7gBQKF
 VqQ=
X-IronPort-AV: E=Sophos;i="5.73,431,1583164800"; 
   d="scan'208";a="241212279"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2020 09:25:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avlNlacLMqPqi+SwjQ/1uB2DPQk1PZiQSCcvVPJbdKHsA8JDNkaPKz0DKEqnZpoIDjyswtLtjS0Geisv5kehe+dcBvq6sDW2LwAEUOfBwnk7SujbNbK9IMTqPUX7DXfLBtmOG06aRj/u50yZXjdH+CWrpdVwqEBmX3VOuLmaK67Z1FaAJpEFbi0Wvw5Knh017fuLhkD3HxBtzC2FjBv85yjio3cFFZfgDcn6J5b0OrsW1OYXOLKj16JdgiORYnNlcDfcrvcJpFdZQi+1Rx+XmaUQ6YRrTYa8Xa2RF8gG0DaeClLeg7eCFmwXr5FYTSkKFxG0KK53Y7Hg5yJ4Rq55qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQCXdN1GLO91uUwgz0x5vU56GJjaDZbgD13ite3sZHQ=;
 b=RKK3jxwOqOw7Olb/QCu4RQy4YDyEX3dxazvoERysuE6K+41rjKSJuO2aBXadZNSZW0NW0nPawgfGawem39HC8+KkdYI5z9smbOT9RMQ7/rNwKNzLfcLo4GXE7hjhkwS1DbOk3Bq/x+7/rMKtnbBbZIvWISKnfQIYP1uHocgmkb4LFrthIz5rL9wVfhf+vp+THkRpzaYVu7oEQujHUN/iVEKIuva7w2LMdvojBjbOIraQKHlt5e7YvM1lD+R6mH3ViEyxM/MqcvXpW3g2+JDqF4BWVuQiJWgthlI9AcNdSPPfJiYW09WJ6O7x0ZsWqJZXPjxoliW0h+U5XElsALfz8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQCXdN1GLO91uUwgz0x5vU56GJjaDZbgD13ite3sZHQ=;
 b=uWDNNO9izWQ7qZ+ssk+JqVIzP++43ebGQHDR3A/EY0g6DW88BQF+fyde1Cvc7apgcRBygFGfLI4D5x1LpPHw0rtcTGPrgGGCYZ0MVMEXoHBuGCDqsmhx2UcMoK7jZ/PoudgRaqFB8HEdtOFy6FjZHwFokJNEuTdM9mXej+GudWE=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0745.namprd04.prod.outlook.com (2603:10b6:903:ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 01:24:47 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 01:24:47 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [RFC PATCH v4 2/3] bcache: handle zone management bios for bcache
 device
Thread-Topic: [RFC PATCH v4 2/3] bcache: handle zone management bios for
 bcache device
Thread-Index: AQHWMDMrALMD8aFhJEWGpHp2plS4gw==
Date:   Mon, 25 May 2020 01:24:47 +0000
Message-ID: <CY4PR04MB37511266F1D87572D3C648CFE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-3-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 59d2effd-1c8c-457c-caf4-08d8004a69a8
x-ms-traffictypediagnostic: CY4PR04MB0745:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0745D818F4A71DC7FC61DA58E7B30@CY4PR04MB0745.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LqOyYeV0rP6PmP5BUwUETjStR4I9K9AQosSd2a0whhtxxkC/guqE9zyWInFmNizGSLFWrlWJxA6JFLjOKOA8se8cJs2HpkVFLw6QJ1khJUiMms9YcqjsELNw74QaJ/y3ejlh+MoQV9i1YjiC0OcAmQUIHcEM1oygbZ8w72bj7cxTR4ehDVPxtuHPijReEShNqE+1UOU00d9yC5KuIOnPmKCM6AkJl6VZ5+lJqRnA7GFxYR5QYG6beP7XC/+wLyV3VmPBHDQXi2R5BDUd7bn8wo8zgrfrI+DSARAkq/tz0nAn7EBXjbocyOs5d2TW89U1+19QAbmyp2gOF3fTWgaKDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66446008)(52536014)(110136005)(54906003)(66476007)(76116006)(91956017)(316002)(66946007)(64756008)(66556008)(9686003)(478600001)(4326008)(55016002)(71200400001)(53546011)(7696005)(186003)(86362001)(26005)(33656002)(5660300002)(2906002)(6506007)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Z65SfXyRlQXBQw4MyTD5yaPfkmUcIGeZT12ah098RjTZZd37y0IAs9h3U0EvA6krwjKXWowtFbdQxhXjzgEClfIrs2N3tDP1xL4XMx6LnqRL42zBac53gPllEliaiNteduSeJEwjhdLZNcLRJP8lF/AZH3Fum0Z/yZuCnAmwMK6ZFOWH075iw+WmP49wxL6Fuapg2v+zNKgQdOdKTcnlGWzrQg32efV6xOX+9sd9V6d1wjLdTJtghqfLKM2F7yeRqEyH/yVc6w8Y1N+LvKgj5tOW6y5nDerb3bvo2EfzPkOucTe7Al05PBzBWAFhBsvZtPQ2ujxJq8hXFRbLC75enkEAwdTDZxWdI+lp/m97RT4QfQQ9kmS0PvcsmINLuKstHpzv4oIzHPCPSNNawnT3i2aYXGhPpPvSt6455xxzTw6tLOxBnQxt6OP6Mv7/ea1G8cBGKLemS7MJAURTqEXdndU4Q8mL7hUsSg8TfPoVTCk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d2effd-1c8c-457c-caf4-08d8004a69a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 01:24:47.2425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iJ6GsRUCai+FR3zbLYetFDLeQXSoYrzL59BTHNivhR93sw46FTg7cfXZ6sOf9FghPgoaMATylJ85wmO59LGIgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0745
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/22 21:18, Coly Li wrote:=0A=
> Fortunately the zoned device management interface is designed to use=0A=
> bio operations, the bcache code just needs to do a little change to=0A=
> handle the zone management bios.=0A=
> =0A=
> Bcache driver needs to handle 5 zone management bios for now, all of=0A=
> them are handled by cached_dev_nodata() since their bi_size values=0A=
> are 0.=0A=
> - REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE, REQ_OP_ZONE_FINISH:=0A=
>     The LBA conversion is already done in cached_dev_make_request(),=0A=
>   just simply send such zone management bios to backing device is=0A=
>   enough.=0A=
> - REQ_OP_ZONE_RESET, REQ_OP_ZONE_RESET_ALL:=0A=
>     If thre is cached data (clean or dirty) on cache device covered=0A=
>   by the LBA range of resetting zone(s), such cached data must be=0A=
=0A=
The first part of the sentence is a little unclear... Did you mean:=0A=
=0A=
If the cache device holds data of the target zones, cache invalidation is n=
eeded=0A=
before forwarding...=0A=
=0A=
>   invalidate from the cache device before forwarding the zone reset=0A=
>   bios to the backing device. Otherwise data inconsistency or further=0A=
>   corruption may happen from the view of bcache device.=0A=
>     The difference of REQ_OP_ZONE_RESET_ALL and REQ_OP_ZONE_RESET is=0A=
>   when the zone management bio is to reset all zones, send all zones=0A=
>   number reported by the bcache device (s->d->disk->queue->nr_zones)=0A=
>   into bch_data_invalidate_zones() as parameter 'size_t nr_zones'. If=0A=
>   only reset a single zone, just set 1 as 'size_t nr_zones'.=0A=
> =0A=
> By supporting zone managememnt bios with this patch, now a bcache device=
=0A=
=0A=
s/managememnt/management=0A=
=0A=
> can be formatted by zonefs, and the zones can be reset by truncate -s 0=
=0A=
> on the zone files under seq/ directory. Supporting REQ_OP_ZONE_RESET_ALL=
=0A=
> makes the whole disk zones reset much faster. In my testing on a 14TB=0A=
> zoned SMR hard drive, 1 by 1 resetting 51632 seq zones by sending=0A=
> REQ_OP_ZONE_RESET bios takes 4m34s, by sending a single=0A=
> REQ_OP_ZONE_RESET_ALL bio takes 12s, which is 22x times faster.=0A=
> =0A=
> REQ_OP_ZONE_RESET_ALL is supported by bcache only when the backing device=
=0A=
> supports it. So the bcache queue flag is set QUEUE_FLAG_ZONE_RESETALL on=
=0A=
> only when queue of backing device has such flag, which can be checked by=
=0A=
> calling blk_queue_zone_resetall() on backing device's request queue.=0A=
> =0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.com>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
> Changelog:=0A=
> v2: an improved version without any generic block layer change.=0A=
> v1: initial version depends on other generic block layer changes.=0A=
> =0A=
>  drivers/md/bcache/request.c | 99 ++++++++++++++++++++++++++++++++++++-=
=0A=
>  drivers/md/bcache/super.c   |  2 +=0A=
>  2 files changed, 100 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c=0A=
> index 34f63da2338d..700b8ab5dec9 100644=0A=
> --- a/drivers/md/bcache/request.c=0A=
> +++ b/drivers/md/bcache/request.c=0A=
> @@ -1052,18 +1052,115 @@ static void cached_dev_write(struct cached_dev *=
dc, struct search *s)=0A=
>  	continue_at(cl, cached_dev_write_complete, NULL);=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * Invalidate the LBA range on cache device which is covered by the=0A=
> + * the resetting zones.=0A=
> + */=0A=
> +static int bch_data_invalidate_zones(struct closure *cl,=0A=
> +				      size_t zone_sector,=0A=
> +				      size_t nr_zones)=0A=
=0A=
No need for the line break after the second argument.=0A=
=0A=
> +{=0A=
> +	struct search *s =3D container_of(cl, struct search, cl);=0A=
> +	struct data_insert_op *iop =3D &s->iop;=0A=
> +	int max_keys, free_keys;=0A=
> +	size_t start =3D zone_sector;=0A=
> +	int ret;=0A=
> +=0A=
> +	max_keys =3D (block_bytes(iop->c) - sizeof(struct jset)) /=0A=
> +		   sizeof(uint64_t);=0A=
> +	bch_keylist_init(&iop->insert_keys);=0A=
> +	ret =3D bch_keylist_realloc(&iop->insert_keys, max_keys, iop->c);=0A=
> +	if (ret < 0)=0A=
> +		return -ENOMEM;=0A=
> +=0A=
> +	while (nr_zones-- > 0) {=0A=
> +		atomic_t *journal_ref =3D NULL;=0A=
> +		size_t size =3D s->d->disk->queue->limits.chunk_sectors;=0A=
> +more_keys:=0A=
> +		bch_keylist_reset(&iop->insert_keys);=0A=
> +		free_keys =3D max_keys;=0A=
> +=0A=
> +		while (size > 0 && free_keys >=3D 2) {=0A=
> +			size_t sectors =3D min_t(size_t, size,=0A=
> +					       1U << (KEY_SIZE_BITS - 1));=0A=
> +=0A=
> +			bch_keylist_add(&iop->insert_keys,=0A=
> +					&KEY(iop->inode, start, sectors));=0A=
> +			start +=3D sectors;=0A=
> +			size -=3D sectors;=0A=
> +			free_keys -=3D 2;=0A=
> +		}=0A=
> +=0A=
> +		/* Insert invalidate keys into btree */=0A=
> +		journal_ref =3D bch_journal(iop->c, &iop->insert_keys, NULL);=0A=
> +		if (!journal_ref) {=0A=
> +			ret =3D -EIO;=0A=
> +			break;=0A=
> +		}=0A=
> +=0A=
> +		ret =3D bch_btree_insert(iop->c,=0A=
> +				&iop->insert_keys, journal_ref, NULL);=0A=
> +		atomic_dec_bug(journal_ref);=0A=
> +		if (ret < 0)=0A=
> +			break;=0A=
> +=0A=
> +		if (size)=0A=
> +			goto more_keys;=0A=
> +	}=0A=
> +=0A=
> +	bch_keylist_free(&iop->insert_keys);=0A=
> +=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
>  static void cached_dev_nodata(struct closure *cl)=0A=
>  {=0A=
>  	struct search *s =3D container_of(cl, struct search, cl);=0A=
>  	struct bio *bio =3D &s->bio.bio;=0A=
> +	int nr_zones =3D 1;=0A=
>  =0A=
>  	if (s->iop.flush_journal)=0A=
>  		bch_journal_meta(s->iop.c, cl);=0A=
>  =0A=
> -	/* If it's a flush, we send the flush to the backing device too */=0A=
> +	if (bio_op(bio) =3D=3D REQ_OP_ZONE_RESET_ALL ||=0A=
> +	    bio_op(bio) =3D=3D REQ_OP_ZONE_RESET) {=0A=
> +		int err =3D 0;=0A=
> +		/*=0A=
> +		 * If this is REQ_OP_ZONE_RESET_ALL bio, cached data=0A=
> +		 * covered by all zones should be invalidate from the=0A=
=0A=
s/invalidate/invalidated=0A=
=0A=
> +		 * cache device.=0A=
> +		 */=0A=
> +		if (bio_op(bio) =3D=3D REQ_OP_ZONE_RESET_ALL)=0A=
> +			nr_zones =3D s->d->disk->queue->nr_zones;=0A=
=0A=
Not: sending a REQ_OP_ZONE_RESET BIO to a conventional zone will be failed =
by=0A=
the disk... This is not allowed by the ZBC/ZAC specs. So invalidation the c=
ache=0A=
for conventional zones is not really necessary. But as an initial support, =
I=0A=
think this is fine. This can be optimized later.=0A=
=0A=
> +=0A=
> +		err =3D bch_data_invalidate_zones(=0A=
> +			cl, bio->bi_iter.bi_sector, nr_zones);=0A=
> +=0A=
> +		if (err < 0) {=0A=
> +			s->iop.status =3D errno_to_blk_status(err);=0A=
> +			/* debug, should be removed before post patch */=0A=
> +			bio->bi_status =3D BLK_STS_TIMEOUT;=0A=
=0A=
You did not remove it :)=0A=
=0A=
> +			/* set by bio_cnt_set() in do_bio_hook() */=0A=
> +			bio_put(bio);=0A=
> +			/*=0A=
> +			 * Invalidate cached data fails, don't send=0A=
> +			 * the zone reset bio to backing device and=0A=
> +			 * return failure. Otherwise potential data=0A=
> +			 * corruption on bcache device may happen.=0A=
> +			 */=0A=
> +			goto continue_bio_complete;=0A=
> +		}=0A=
> +=0A=
> +	}=0A=
> +=0A=
> +	/*=0A=
> +	 * For flush or zone management bios, of cause=0A=
> +	 * they should be sent to backing device too.=0A=
> +	 */=0A=
>  	bio->bi_end_io =3D backing_request_endio;=0A=
>  	closure_bio_submit(s->iop.c, bio, cl);=0A=
=0A=
You cannot submit a REQ_OP_ZONE_RESET_ALL to the backing dev here, at least=
 not=0A=
unconditionally. The problem is that if the backing dev doe not have any=0A=
conventional zones at its LBA 0, REQ_OP_ZONE_RESET_ALL will really reset al=
l=0A=
zones, including the first zone of the device that contains bcache super bl=
ock.=0A=
So you will loose/destroy the bcache setup. You probably did not notice thi=
s=0A=
because your test drive has conventional zones at LBA 0 and reset all does =
not=0A=
have any effect on conventional zones...=0A=
=0A=
The easy way to deal with this is to not set the QUEUE_FLAG_ZONE_RESETALL f=
lag=0A=
for the bcache device queue. If it is not set, the block layer will=0A=
automatically issue only single zone REQ_OP_ZONE_RESET BIOs. That is slower=
,=0A=
yes, but that cannot be avoided when the backend disk does not have any=0A=
conventional zones. The QUEUE_FLAG_ZONE_RESETALL flag can be kept if the ba=
ckend=0A=
disk first zone containing the bcache super block is a conventional zone.=
=0A=
=0A=
>  =0A=
> +continue_bio_complete:=0A=
>  	continue_at(cl, cached_dev_bio_complete, NULL);=0A=
>  }=0A=
>  =0A=
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c=0A=
> index d5da7ad5157d..70c31950ec1b 100644=0A=
> --- a/drivers/md/bcache/super.c=0A=
> +++ b/drivers/md/bcache/super.c=0A=
> @@ -1390,6 +1390,8 @@ static int bch_cached_dev_zone_init(struct cached_d=
ev *dc)=0A=
>  		 */=0A=
>  		d_q->nr_zones =3D b_q->nr_zones -=0A=
>  			(dc->sb.data_offset / d_q->limits.chunk_sectors);=0A=
> +		if (blk_queue_zone_resetall(b_q))=0A=
> +			blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, d_q);=0A=
=0A=
See above comment.=0A=
=0A=
>  	}=0A=
>  =0A=
>  	return 0;=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
