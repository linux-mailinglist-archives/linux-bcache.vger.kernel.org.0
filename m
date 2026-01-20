Return-Path: <linux-bcache+bounces-1391-lists+linux-bcache=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-bcache@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMkbLmiib2l7DgAAu9opvQ
	(envelope-from <linux-bcache+bounces-1391-lists+linux-bcache=lfdr.de@vger.kernel.org>)
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jan 2026 16:42:32 +0100
X-Original-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ED5D1466ED
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jan 2026 16:42:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B5D0874948C
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jan 2026 14:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F75D43DA53;
	Tue, 20 Jan 2026 14:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="yrTSECsI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-23.ptr.blmpb.com (sg-1-23.ptr.blmpb.com [118.26.132.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEA73EDAD7
	for <linux-bcache@vger.kernel.org>; Tue, 20 Jan 2026 14:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920385; cv=none; b=UBlQw3D5VF1pCS6/QbkgEQ4f/Fkteo8HqZce6Jkd1JRE5cveCYUULzZjGJIA7/WZyornKow52Cq2hvRk5jOVjV0OAZEXqsYCGBMn6xU76ozT1sjbjON7R75LkdDfUOoer3y/S5Se859CXNomNX3roSwCwjZEJP1NZ8GYy7LEtRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920385; c=relaxed/simple;
	bh=XkqjHUorie/sKCLnHV1Aa2VUpGfQyl0AbsUgD2iFZ68=;
	h=Content-Disposition:References:Cc:From:Subject:Message-Id:
	 Content-Type:In-Reply-To:To:Date:Mime-Version; b=JudqpGIEd5Q04Z87HcZdUUA2YmfWEiEFMOvlgo1mLmMcoRT4H+T3zyANMqdDAE17dvgHTw3yzve2dtRCKtbr8KXEKtOvLPZ9R0LRbCMy6BOV3eT0RHm8YaAMDng5XFDfHWabeq8QWEol9/CFBaIYXXVNdvSo6zE43sDEWErBDrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=yrTSECsI; arc=none smtp.client-ip=118.26.132.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768920370;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=NV/47piqB9x38rbPpoEFVl/ppjSwPuFhCuxaNF973z0=;
 b=yrTSECsI2kP2kL/uE7Kam8uaP6AWc8kzoBcvQ/O96MP92ZbTeanfFaShwXszX6w2g8D5Bh
 sMaefM5YisF+sRPEXXeXPR6bom9KMCDp/ibJRWhJ6crepg2LmZ5mWfa6S5hhMC2P2j0NsF
 FLPw4WnPkCgMQQEJhQw1nikI6V51JM7TxyASKsfI+lyf+Z0yqUOhbF++qVj3pjztTJ0u5S
 xg4UIFBfAeyqoAEThVAnna8fdio7BRd4c4Vp2equeTb27nONpVbUxLZ31n65+uYexcM6uD
 +mfVONmtJPXPXDAL2Uq2HS/5ytWA1EKt6afqUseFsuDCR0bNIW4rOFuHdhPTPA==
Content-Disposition: inline
References: <20260120023535.9109-1-zhangshida@kylinos.cn> <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
X-Lms-Return-Path: <lba+2696f9530+644dfe+vger.kernel.org+colyli@fnnas.com>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, <axboe@kernel.dk>, 
	"Sasha Levin" <sashal@kernel.org>, 
	"Christoph Hellwig" <hch@infradead.org>, <linux-bcache@vger.kernel.org>, 
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, 
	"zhangshida" <zhangshida@kylinos.cn>
From: "Coly Li" <colyli@fnnas.com>
X-Original-From: Coly Li <colyli@fnnas.com>
Subject: Re: Fwd: [PATCH v2] bcache: use bio cloning for detached device requests
Message-Id: <aW-DHlpo4dzKRB8K@studio.local>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Received: from studio.local ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Tue, 20 Jan 2026 22:46:07 +0800
To: "Stephen Zhang" <starzhangzsd@gmail.com>
Date: Tue, 20 Jan 2026 22:46:04 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Spamd-Result: default: False [-0.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[fnnas-com.20200927.dkim.feishu.cn:s=s1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[fnnas.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-1391-lists,linux-bcache=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[fnnas-com.20200927.dkim.feishu.cn:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[colyli@fnnas.com,linux-bcache@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[linux-bcache];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,linux.dev:email]
X-Rspamd-Queue-Id: ED5D1466ED
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 10:39:36AM +0800, Stephen Zhang wrote:
> ---------- Forwarded message ---------
> =E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A zhangshida <starzhangzsd@gmail.com>
> Date: 2026=E5=B9=B41=E6=9C=8820=E6=97=A5=E5=91=A8=E4=BA=8C 10:35
> Subject: [PATCH v2] bcache: use bio cloning for detached device requests
> To: <colyli@fnnas.com>, <kent.overstreet@linux.dev>,
> <axboe@kernel.dk>, <sashal@kernel.org>, <hch@infradead.org>
> Cc: <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
> <zhangshida@kylinos.cn>, <starzhangzsd@gmail.com>, Christoph Hellwig
> <hch@lst.de>
>=20
>=20
> From: Shida Zhang <zhangshida@kylinos.cn>
>=20
> Previously, bcache hijacked the bi_end_io and bi_private fields of
> the incoming bio when the backing device was in a detached state.
> This is fragile and breaks if the bio is needed to be processed by
> other layers.
>=20
> This patch transitions to using a cloned bio embedded within a private
> structure. This ensures the original bio's metadata remains untouched.
>=20
> Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
> Co-developed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>=20
> Changelog:
> v1:
> https://lore.kernel.org/all/20260115074811.230807-1-zhangshida@kylinos.cn=
/
>=20
>  drivers/md/bcache/bcache.h  |  9 +++++
>  drivers/md/bcache/request.c | 79 ++++++++++++++++---------------------
>  drivers/md/bcache/super.c   | 12 +++++-
>  3 files changed, 54 insertions(+), 46 deletions(-)
>=20
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 8ccacba8554..54ff4e0238a 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -273,6 +273,8 @@ struct bcache_device {
>=20
>         struct bio_set          bio_split;
>=20
> +       struct bio_set          bio_detach;
                                  ^^^^^^^^^-> better to rename it to bio_de=
tached

>         unsigned int            data_csum:1;
>=20
>         int (*cache_miss)(struct btree *b, struct search *s,
> @@ -753,6 +755,13 @@ struct bbio {
>         struct bio              bio;
>  };
>=20
> +struct detached_dev_io_private {
> +       struct bcache_device    *d;
> +       unsigned long           start_time;
> +       struct bio              *orig_bio;
> +       struct bio              bio;
> +};
> +
>  #define BTREE_PRIO             USHRT_MAX
>  #define INITIAL_PRIO           32768U
>=20
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 82fdea7dea7..e0b12cb622b 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1077,68 +1077,58 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
>         continue_at(cl, cached_dev_bio_complete, NULL);
>  }
>=20
> -struct detached_dev_io_private {
> -       struct bcache_device    *d;
> -       unsigned long           start_time;
> -       bio_end_io_t            *bi_end_io;
> -       void                    *bi_private;
> -       struct block_device     *orig_bdev;
> -};
> -
>  static void detached_dev_end_io(struct bio *bio)
>  {
> -       struct detached_dev_io_private *ddip;
> -
> -       ddip =3D bio->bi_private;
> -       bio->bi_end_io =3D ddip->bi_end_io;
> -       bio->bi_private =3D ddip->bi_private;
> +       struct detached_dev_io_private *ddip =3D
> +               container_of(bio, struct detached_dev_io_private, bio);
> +       struct bio *orig_bio =3D ddip->orig_bio;
>=20
>         /* Count on the bcache device */
> -       bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
> +       bio_end_io_acct(orig_bio, ddip->start_time);
>
>         if (bio->bi_status) {
> -               struct cached_dev *dc =3D container_of(ddip->d,
> -                                                    struct cached_dev, d=
isk);
> +               struct cached_dev *dc =3D bio->bi_private;
> +
>                 /* should count I/O error for backing device here */
>                 bch_count_backing_io_errors(dc, bio);
> +               orig_bio->bi_status =3D bio->bi_status;
>         }
>=20
> -       kfree(ddip);
> -       bio_endio(bio);
> +       bio_put(bio);
> +       bio_endio(orig_bio);
>  }
>=20
> -static void detached_dev_do_request(struct bcache_device *d, struct bio =
*bio,
> -               struct block_device *orig_bdev, unsigned long start_time)
> +static void detached_dev_do_request(struct bcache_device *d,
> +               struct bio *orig_bio, unsigned long start_time)
>  {
>         struct detached_dev_io_private *ddip;
>         struct cached_dev *dc =3D container_of(d, struct cached_dev, disk=
);
> +       struct bio *clone_bio;
>=20
> -       /*
> -        * no need to call closure_get(&dc->disk.cl),
> -        * because upper layer had already opened bcache device,
> -        * which would call closure_get(&dc->disk.cl)
> -        */
> -       ddip =3D kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO=
);
> -       if (!ddip) {
> -               bio->bi_status =3D BLK_STS_RESOURCE;
> -               bio_endio(bio);
> +       if (bio_op(orig_bio) =3D=3D REQ_OP_DISCARD &&
> +           !bdev_max_discard_sectors(dc->bdev)) {
> +               bio_endio(orig_bio);
>                 return;
>         }
>=20
> -       ddip->d =3D d;
> +       clone_bio =3D bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
> +                                   &d->bio_detach);
> +       if (!clone_bio) {
> +               orig_bio->bi_status =3D BLK_STS_RESOURCE;
> +               bio_endio(orig_bio);
> +               return;
> +       }
> +
> +       ddip =3D container_of(clone_bio, struct detached_dev_io_private, =
bio);
>         /* Count on the bcache device */
> -       ddip->orig_bdev =3D orig_bdev;
> +       ddip->d =3D d;
>         ddip->start_time =3D start_time;
> -       ddip->bi_end_io =3D bio->bi_end_io;
> -       ddip->bi_private =3D bio->bi_private;
> -       bio->bi_end_io =3D detached_dev_end_io;
> -       bio->bi_private =3D ddip;
> -
> -       if ((bio_op(bio) =3D=3D REQ_OP_DISCARD) &&
> -           !bdev_max_discard_sectors(dc->bdev))
> -               detached_dev_end_io(bio);
> -       else
> -               submit_bio_noacct(bio);
> +       ddip->orig_bio =3D orig_bio;
> +
> +       clone_bio->bi_end_io =3D detached_dev_end_io;
> +       clone_bio->bi_private =3D dc;
> +
> +       submit_bio_noacct(clone_bio);
>  }
>=20
>  static void quit_max_writeback_rate(struct cache_set *c,
> @@ -1214,10 +1204,10 @@ void cached_dev_submit_bio(struct bio *bio)
>=20
>         start_time =3D bio_start_io_acct(bio);
>=20
> -       bio_set_dev(bio, dc->bdev);
>         bio->bi_iter.bi_sector +=3D dc->sb.data_offset;
>=20
>         if (cached_dev_get(dc)) {
> +               bio_set_dev(bio, dc->bdev);
>                 s =3D search_alloc(bio, d, orig_bdev, start_time);
>                 trace_bcache_request_start(s->d, bio);
>=20
> @@ -1237,9 +1227,10 @@ void cached_dev_submit_bio(struct bio *bio)
>                         else
>                                 cached_dev_read(dc, s);
>                 }
> -       } else
> +       } else {
>                 /* I/O request sent to backing device */
> -               detached_dev_do_request(d, bio, orig_bdev, start_time);
> +               detached_dev_do_request(d, bio, start_time);
> +       }
>  }
>=20
>  static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index c17d4517af2..d4b798668c8 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -887,6 +887,7 @@ static void bcache_device_free(struct bcache_device *=
d)
>         }
>=20
>         bioset_exit(&d->bio_split);
> +       bioset_exit(&d->bio_detach);
>         kvfree(d->full_dirty_stripes);
>         kvfree(d->stripe_sectors_dirty);
>=20
> @@ -949,6 +950,11 @@ static int bcache_device_init(struct
> bcache_device *d, unsigned int block_size,
>                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>                 goto out_ida_remove;
>=20
> +       if (bioset_init(&d->bio_detach, 4,
					^^^^^-> I feel 4 might be a bit small
here. bio_detached set is for normal IO when backing device is not attached=
 to
a cache device. I would suggest to set the pool size to 128 or 256.

> +                       offsetof(struct detached_dev_io_private, bio),
> +                       BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
> +               goto out_bioset_split_exit;
> +
>         if (lim.logical_block_size > PAGE_SIZE && cached_bdev) {
>                 /*
>                  * This should only happen with BCACHE_SB_VERSION_BDEV.
> @@ -964,7 +970,7 @@ static int bcache_device_init(struct bcache_device
> *d, unsigned int block_size,
>=20
>         d->disk =3D blk_alloc_disk(&lim, NUMA_NO_NODE);
>         if (IS_ERR(d->disk))
> -               goto out_bioset_exit;
> +               goto out_bioset_detach_exit;
>=20
>         set_capacity(d->disk, sectors);
>         snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
> @@ -976,7 +982,9 @@ static int bcache_device_init(struct bcache_device
> *d, unsigned int block_size,
>         d->disk->private_data   =3D d;
>         return 0;
>=20
> -out_bioset_exit:
> +out_bioset_detach_exit:
> +       bioset_exit(&d->bio_detach);
> +out_bioset_split_exit:
>         bioset_exit(&d->bio_split);
>  out_ida_remove:
>         ida_free(&bcache_device_idx, idx);
> --

Rested part is good to me. Thanks for patching up.

Coly Li

