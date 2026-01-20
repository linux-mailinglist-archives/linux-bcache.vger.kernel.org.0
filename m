Return-Path: <linux-bcache+bounces-1388-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B7ED3BDA0
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jan 2026 03:49:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 416524E021F
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jan 2026 02:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E3D1DE8AD;
	Tue, 20 Jan 2026 02:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQKrrjUx"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6CC50276
	for <linux-bcache@vger.kernel.org>; Tue, 20 Jan 2026 02:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768877361; cv=pass; b=fbEknDWyJnRZumX6/ilU+umvi17szkbOQcxHlHRyfbjQNb0rKq6SoZwL9uw/Oa//E+TrPygmB3Xmj3+c98aDrIMMnwLCPm7jPTKIvWaDetXzJjwY970AxgG1P3OCyIybEPr1I2BGpR84oBrupUveAgSATUU95bRihQ3Tk5PVFf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768877361; c=relaxed/simple;
	bh=ddYbeB+KDUSWNyZBHS9DA+iQK7A/fQucO7pGZBkfaw8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FLArBwj+PPciHG2Y0drX5N9dq4qMmILG8whTPBIC5DKLoDmeBxTWIv+Ld2OoyE4pnr4FhkoDqW9ZaVuKyqqIuuwkapx8Z9cwrUd5nmhlhIzC5sX+AYr+6zXGblpK3wN+rU3yap7MmLmM20/rHqUvLIEltPAv4vYMOO+7lWxU8kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HQKrrjUx; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5014db8e268so72777791cf.1
        for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2026 18:49:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768877358; cv=none;
        d=google.com; s=arc-20240605;
        b=Ze+GEa6YUtuzs8craT9Mukq6NUonzCA6Cj3JHxHVT0N2UIrkTvC5ok4LsI+jfD9hoL
         2ludRXv5UrYNk46Cji0JAxzgjVJxvLg5BjSTCwZOJaJ6862HawjhoThSJT1Zo9QV1xDx
         jCP0VTsunGyL7estChDbOe/M+6jyX3rc76bRs4Szj8PQe7AJjjmx92tsee9QCdysgsLw
         EorDIPq+iEb1pogsStz45WQyccv1AGoTIGNCi7aii19RQqZRCt070JqhaD3RjqQ5O8zC
         6dfqd5n/NTPUyk8rl/ZWx6KBbAS5W7g//OHw5CSh8+K4FDkiZsTxq+bqhXtnc9KxYO4y
         1hdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L1OtdBtLM2d6DHhwhKqshTTpTzjON1djW9O4IawusOk=;
        fh=oUPiufUnowSFiPWUyhmA/jq+4vrFeQSOrkb3YyMBfHg=;
        b=bPOQWHmm/o0Gcw17JMqM6YLHVYd96djWtu+gn/pc+5CG6CO6ErDhuxlNeEJ/d799cG
         4POS7kaeyZC9HizbYHuX5C0fAFRrsCTJZZxpaH1CoCVRoCTBNEEbZvZDOQZAojYrUJOO
         aoFqswMtdAMmz56X4eh7NWk6CuLnnmR9yaPfxljTnon0SzcyZvdbF02+xmPWgnYMXjmQ
         nIxB3jdR0TfXfvNfVT/zD6WTJ3m/iVGphobjxwwqP4o4Vw7minpoRLB8A7jfowPkvQI4
         Id4BLgV+rH4vXvHaOdLpMJCDcQgJue3g/7v+n6NGjV3vvAj9kJBfiLTmc1GsTJIuLv9p
         sU0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768877358; x=1769482158; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L1OtdBtLM2d6DHhwhKqshTTpTzjON1djW9O4IawusOk=;
        b=HQKrrjUxSPzk08eGb35MAeq2mXEnlsZsV8y3dsxxa3r/YABKAG0WIqfEVDC58lZWBN
         KFNo8H+lrFFiVrxKLzGb0hXfyBD9qsyLZS37NmNjIJbacAB6DmgHOdqOj9z+HhS8ATRb
         CV9PL6JRlcIz9ktCm3AR1WjcR5oshq+107+ZeOOUHv8ueGKdfOuf+RHRK6e2tMeOPBNi
         eoZhCZ5qKeGH667v4eU2Q81UDFdVPfd1xe0zaYwoejExvWVXHlB/im1CgGAKtievQE6W
         Sj/1Q6cQMaXYf1R1xc/nnCRtjtky8R0Eb93X1FF25K4wrJrgcWDUZq7y6Jr57w6AZyA4
         pwPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768877358; x=1769482158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L1OtdBtLM2d6DHhwhKqshTTpTzjON1djW9O4IawusOk=;
        b=XX8Bb44hy08/LU/3WheKsaAqpfYMPFumbYyQ1lJAjbyA/Xh/6lNMzwAMAWGj8PVo64
         EwHHALsO5vlp2S6xLQXCLDME4LzLSy6MD0SxIhyQRDFj/+3vg0vVlF1wsEwXzIiYlVq3
         5tK6C1GOuY4gQx4zvAM5evBPaPmMrn7lyU0DoKJCNXGVlQGiz129pMYdTXwnCKP27IjA
         j5h4LK/MtlASFbtzT0aNqZxxmj7vKY3XdYcqDd6teuQs2NbSG2H6nJdw7JamsmQ1cZqQ
         skuPfp7DPc1Rvf5lihTTqdpR9fZomAUPoN+qrzcuNEcosCxxNSZ1nqpJPlRTXP52fNIG
         fTiA==
X-Gm-Message-State: AOJu0Yx0L8T4SIFLfBK8mMeXHYex89zSYHVbslCCM1JbMToqDLmPSis8
	KiSNzTF0ma+bRvxqiiUDJsn4mrl5gRHRQWrqwleZKqEuFCbjtAXe78IK9DBZE6TaiYElLMpPu8A
	EUyRVL77s/m/jSpMqtH1WlrGGyKHgbZI=
X-Gm-Gg: AY/fxX6gyVu3PoTsjynq+bI/ZUNfxJnCdlXxMiVPUOUMOisXPqTK8jFGRxCoro6zwTt
	GpqDirmzCVuFhOSBiAsxOJfXZfu5XrfInRVWulQeRxuD+V+NUCuQrSrzyvl/p0ebmvJz2QYUEro
	LFZQ3qtyV4OnzCoC+2x3d7XRKRgdGErzMjZEHHo8rA6YnJQ41Yifv2+FZfYP243Gl4RH0TGKLia
	6JSnSMkv8PKuYjLC05aPPbSyAx9GA5IVsLltU37BTfvK3tvMJRCmwEwmpszGSHw4b9IWAA=
X-Received: by 2002:ac8:5949:0:b0:502:9b1f:ca3f with SMTP id
 d75a77b69052e-502a1f838camr186572761cf.56.1768877358378; Mon, 19 Jan 2026
 18:49:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120023535.9109-1-zhangshida@kylinos.cn> <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
In-Reply-To: <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Tue, 20 Jan 2026 10:48:42 +0800
X-Gm-Features: AZwV_Qj3tXgNNuy5lk_ZPaIIqU9AK_Sc1_JrfImOnyKNRI3OWp6ZatvmDZld1Qo
Message-ID: <CANubcdX7eNbH_bo4-f94DUbdiEbt04Vxy1MPyhm+CZyXB01FuQ@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: use bio cloning for detached device requests
To: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>, axboe@kernel.dk, 
	Sasha Levin <sashal@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-bcache@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zhangshida <zhangshida@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Stephen Zhang <starzhangzsd@gmail.com> =E4=BA=8E2026=E5=B9=B41=E6=9C=8820=
=E6=97=A5=E5=91=A8=E4=BA=8C 10:39=E5=86=99=E9=81=93=EF=BC=9A
>
> ---------- Forwarded message ---------
> =E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A zhangshida <starzhangzsd@gmail.com>
> Date: 2026=E5=B9=B41=E6=9C=8820=E6=97=A5=E5=91=A8=E4=BA=8C 10:35
> Subject: [PATCH v2] bcache: use bio cloning for detached device requests
> To: <colyli@fnnas.com>, <kent.overstreet@linux.dev>,
> <axboe@kernel.dk>, <sashal@kernel.org>, <hch@infradead.org>
> Cc: <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
> <zhangshida@kylinos.cn>, <starzhangzsd@gmail.com>, Christoph Hellwig
> <hch@lst.de>
>
>
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Previously, bcache hijacked the bi_end_io and bi_private fields of
> the incoming bio when the backing device was in a detached state.
> This is fragile and breaks if the bio is needed to be processed by
> other layers.
>
> This patch transitions to using a cloned bio embedded within a private
> structure. This ensures the original bio's metadata remains untouched.
>
> Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
> Co-developed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>
> Changelog:
> v1:
> https://lore.kernel.org/all/20260115074811.230807-1-zhangshida@kylinos.cn=
/
>
>  drivers/md/bcache/bcache.h  |  9 +++++
>  drivers/md/bcache/request.c | 79 ++++++++++++++++---------------------
>  drivers/md/bcache/super.c   | 12 +++++-
>  3 files changed, 54 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 8ccacba8554..54ff4e0238a 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -273,6 +273,8 @@ struct bcache_device {
>
>         struct bio_set          bio_split;
>
> +       struct bio_set          bio_detach;
> +
>         unsigned int            data_csum:1;
>
>         int (*cache_miss)(struct btree *b, struct search *s,
> @@ -753,6 +755,13 @@ struct bbio {
>         struct bio              bio;
>  };
>
> +struct detached_dev_io_private {
> +       struct bcache_device    *d;
> +       unsigned long           start_time;
> +       struct bio              *orig_bio;
> +       struct bio              bio;
> +};
> +
>  #define BTREE_PRIO             USHRT_MAX
>  #define INITIAL_PRIO           32768U
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 82fdea7dea7..e0b12cb622b 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1077,68 +1077,58 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
>         continue_at(cl, cached_dev_bio_complete, NULL);
>  }
>
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
>
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
>
> -       kfree(ddip);
> -       bio_endio(bio);
> +       bio_put(bio);
> +       bio_endio(orig_bio);
>  }
>
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
>
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
>
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
>
>  static void quit_max_writeback_rate(struct cache_set *c,
> @@ -1214,10 +1204,10 @@ void cached_dev_submit_bio(struct bio *bio)
>
>         start_time =3D bio_start_io_acct(bio);
>
> -       bio_set_dev(bio, dc->bdev);
>         bio->bi_iter.bi_sector +=3D dc->sb.data_offset;
>
>         if (cached_dev_get(dc)) {
> +               bio_set_dev(bio, dc->bdev);
>                 s =3D search_alloc(bio, d, orig_bdev, start_time);
>                 trace_bcache_request_start(s->d, bio);
>
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
>
>  static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index c17d4517af2..d4b798668c8 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -887,6 +887,7 @@ static void bcache_device_free(struct bcache_device *=
d)
>         }
>
>         bioset_exit(&d->bio_split);
> +       bioset_exit(&d->bio_detach);
>         kvfree(d->full_dirty_stripes);
>         kvfree(d->stripe_sectors_dirty);
>
> @@ -949,6 +950,11 @@ static int bcache_device_init(struct
> bcache_device *d, unsigned int block_size,
>                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>                 goto out_ida_remove;
>
> +       if (bioset_init(&d->bio_detach, 4,
> +                       offsetof(struct detached_dev_io_private, bio),
> +                       BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
> +               goto out_bioset_split_exit;
> +
>         if (lim.logical_block_size > PAGE_SIZE && cached_bdev) {
>                 /*
>                  * This should only happen with BCACHE_SB_VERSION_BDEV.
> @@ -964,7 +970,7 @@ static int bcache_device_init(struct bcache_device
> *d, unsigned int block_size,
>
>         d->disk =3D blk_alloc_disk(&lim, NUMA_NO_NODE);
>         if (IS_ERR(d->disk))
> -               goto out_bioset_exit;
> +               goto out_bioset_detach_exit;
>
>         set_capacity(d->disk, sectors);
>         snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
> @@ -976,7 +982,9 @@ static int bcache_device_init(struct bcache_device
> *d, unsigned int block_size,
>         d->disk->private_data   =3D d;
>         return 0;
>
> -out_bioset_exit:
> +out_bioset_detach_exit:
> +       bioset_exit(&d->bio_detach);
> +out_bioset_split_exit:
>         bioset_exit(&d->bio_split);
>  out_ida_remove:
>         ida_free(&bcache_device_idx, idx);
> --
> 2.34.1

I=E2=80=99ve tested this patch with the script below, and the results look =
good.
I couldn't find a standard test suite for the project, but I=E2=80=99d be
happy to integrate
these tests into it if needed. Just let me know.

Thanks,
Shida
-----
#!/bin/bash
# cycle_test.sh - Automation for bcache detached bio-cloning patch

# --- CONFIGURATION ---
BACKING_DEV=3D"/dev/sdb1"
CACHE_DEV=3D"/dev/nvme0n1p1"
BCACHE_DEV=3D"/dev/bcache0"
ITERATIONS=3D3
FIO_RUNTIME=3D60

set -e

log() { echo -e "\n[$(date +%T)] $1"; }

# --- CLEANUP HANDLER ---
cleanup() {
    set +e
    log "CLEANING UP RESOURCES..."

    if pgrep fio > /dev/null; then
        sudo pkill -9 fio
    fi

    # 1. Stop the logical bcache device
    if [ -b "$BCACHE_DEV" ]; then
        BDEV_NAME=3D$(basename "$BCACHE_DEV")
        echo 1 | sudo tee /sys/block/$BDEV_NAME/bcache/stop >
/dev/null 2>&1 || true
    fi

    # 2. Unregister the backing device specifically if it's still active
    # This is often the cause of "Device busy" during wipefs
    BACKING_NAME=3D$(basename "$BACKING_DEV")
    if [ -d "/sys/block/$BACKING_NAME/bcache" ]; then
        echo 1 | sudo tee /sys/block/$BACKING_NAME/bcache/stop >
/dev/null 2>&1 || true
    fi

    # 3. Unregister all bcache cache sets
    for cset in /sys/fs/bcache/*-*-*-*-*; do
        if [ -d "$cset" ]; then
            echo 1 | sudo tee "$cset/unregister" > /dev/null 2>&1 || true
        fi
    done

    # 4. Wait for kernel/udev to catch up
    sudo udevadm settle
    sleep 2
    log "Cleanup complete."
}

# Trap for unexpected exits
trap cleanup EXIT SIGINT SIGTERM

check_deps() {
    for cmd in make-bcache fio iostat wipefs bc pgrep udevadm; do
        if ! command -v $cmd &> /dev/null; then
            echo "Error: $cmd not found."
            exit 1
        fi
    done
}

run_cycle() {
    local i=3D$1
    log ">>> STARTING CYCLE #$i"

    # 1. Clean and Initialize
    log "Wiping devices..."
    # If wipefs fails, we try a quick dd to clear the headers
    sudo wipefs -a $BACKING_DEV || (sudo dd if=3D/dev/zero
of=3D$BACKING_DEV bs=3D1M count=3D10 && sudo wipefs -a $BACKING_DEV)
    sudo wipefs -a $CACHE_DEV

    log "Creating bcache..."
    sudo make-bcache -B $BACKING_DEV -C $CACHE_DEV
    sleep 3

    if [ ! -b "$BCACHE_DEV" ]; then
        echo "Error: $BCACHE_DEV did not initialize."
        exit 1
    fi

    # 2. Detach
    log "Detaching backing device..."
    BDEV_NAME=3D$(basename $BCACHE_DEV)
    echo 1 | sudo tee /sys/block/$BDEV_NAME/bcache/detach > /dev/null

    STATE=3D$(cat /sys/block/$BDEV_NAME/bcache/state)
    log "Device state: $STATE"

    # 3. Stress Test
    log "Running fio stress test (${FIO_RUNTIME}s)..."
    sudo fio --name=3Dbcache_test --filename=3D$BCACHE_DEV --rw=3Drandrw --=
bs=3D4k \
         --direct=3D1 --ioengine=3Dlibaio --iodepth=3D64 --runtime=3D$FIO_R=
UNTIME \
         --numjobs=3D4 --group_reporting --minimal > /dev/null

    # 4. Validation
    log "Validating I/O accounting..."
    sleep 5

    STATS_LINE=3D$(iostat -x 1 2 $BDEV_NAME | grep -w "$BDEV_NAME" | tail -=
n 1)
    UTIL=3D$(echo "$STATS_LINE" | awk '{print $NF}')
    log "Final Stats -> %util: $UTIL"

    if (( $(echo "$UTIL > 1.0" | bc -l) )); then
        echo "!!! FAILURE: Accounting leak detected!"
        exit 1
    fi

    # 5. Cycle Teardown
    log "Cycle $i complete. Teardown..."
    # We call our cleanup function logic manually to ensure a clean
slate for the next iteration
    cleanup

    # Re-enable 'exit on error' for the next loop
    set -e
    log ">>> CYCLE #$i FINISHED"
}

# --- Main ---
check_deps
sudo -v

for ((c=3D1; c<=3DITERATIONS; c++)); do
    run_cycle $c
    # Extra breather between cycles
    sleep 2
done

log "ALL CYCLES PASSED."
trap - EXIT
----

