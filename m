Return-Path: <linux-bcache+bounces-1387-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B3708D3BD8F
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jan 2026 03:40:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D05AB30285AD
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jan 2026 02:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FE4221F15;
	Tue, 20 Jan 2026 02:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOD/e4/i"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632F619F135
	for <linux-bcache@vger.kernel.org>; Tue, 20 Jan 2026 02:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768876814; cv=pass; b=rtQgIHamUPWb3P4iJka1GxnayrAbgrjADAuDKMkfwj2ZN0qD2DFb3eEw9eVbPH51i2ViPdeoEt5POcuGFzKJQjtZNesADEGUAVypa4ObSHxI2f8L7turbC/xTFKufkiq7vosfT7Oy5Fhk8dQD6JzcP7Lfkhj3NUkeQrr6kz3ptE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768876814; c=relaxed/simple;
	bh=1QyxMtjlNe8ZiYKOAal1lvTerpAXr7aEr27Jjrl+ji0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BW4TO1WEW34vSJnfYg5LMj3IHk9raQ8tlezvrgjrImspYjKgJ7DGx3kTSlk3JCS6iKRlNyTc+Fxr6TrD4y2AKbNPr3vFFMB1LUUgFNOs9jSJQUDl3n/T3t96J8W2wp4RIvTIyJWaAt7HDQA4cxTnr+B/gnM1s2LHgagYWiLGzZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aOD/e4/i; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5029aa94f28so37359961cf.1
        for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2026 18:40:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768876812; cv=none;
        d=google.com; s=arc-20240605;
        b=eTIT7OZgsDGc8fkg1PeUE9UD8OxC3Pe3K/7NnHfIwO/UuKiah5yANSmj5ja7nPutWk
         VOKj1/lGGq+8h8u9ukpWXl3Sy2lmQB9gSYKAc3J1G79G0uFCg2YLHGgTTfS3HKbk3h15
         Q89M7RsJDHLKPyPcxoZ61jYouk3KqTcxCpy98qAfq0UdDpVKdmFalRqHrkxw93pEL0xr
         jrOrJkubjNOaHhpNxXOWoYVcwVjVlrAz+ofR5zubYmuvZw/3Xva1JvtkU4r8PRwcKflX
         szPrsNlFxJsEd4BnhoTfNFGth1j+tXPY1bAoja1Zu/4vTPq9kOPSALAU0UsIgTX4vS/G
         znRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ObDknAp/TMMROwaN+7kiMAbgz1CSAi9eVouI+TDoMTQ=;
        fh=oUPiufUnowSFiPWUyhmA/jq+4vrFeQSOrkb3YyMBfHg=;
        b=JTAF/Kdvsw9hD+GOWW+Yxvcs0jFlwfFFWKEQEZYiiJwJlRFXKTRDXsMxD+2uOgFKdj
         Y5ZIiR26mZyTmIMbc8wspXYTpszrmemfKZKTtLABufPnZ4iNXmLNaTkChfXfHvcO4zAu
         tV7DqLTB1D44lyT5Tc8Nol5DMAsYCMgzMmeb4ArF1sY8lsTr1F/d24LO2BRgC3dpZQO9
         WOpbFc+zL2nXtJNTHUx3vSsu66BsXNwWCHbwPGmQaZquBJ242HvAH0esU8wzFl+OnB3z
         dLA+xPKU9sqXzPc5pcQvGV83Plii1AMz3hK9DPMXIWXMpuc2NxGe8h5G4buw0FCCdFI+
         fLKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768876812; x=1769481612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ObDknAp/TMMROwaN+7kiMAbgz1CSAi9eVouI+TDoMTQ=;
        b=aOD/e4/iSu1oJD2wm1CwJfK6YtVN/qWyX0imikFpJz1OIfKGwtB5qXLeSol2EalOeC
         NYokzjsg6dK4goBwxf2tfCnjiLBOq/5jLOPitZZy6MvgFmy5i25EbFUdlukFe7ruV4qD
         P30mClMY1MpHdMtIIVbqOe1hHjrQGxGAcpf8BpJvFChXkko5ozv0YEEdVAkmhfKuRBU/
         eyLd7Gt30lBkvH12xiRZYB5KkTMX0O8cKG/GaBKuHKdZXctirDIzSiLFgEBFFDaVRvSd
         G7TqsbEVnVBirLcmguElWQRINnXBFYKChaDjEjOE+A9yiEhF1wtqeLgweqnwGVZ9keVT
         W5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768876812; x=1769481612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ObDknAp/TMMROwaN+7kiMAbgz1CSAi9eVouI+TDoMTQ=;
        b=GDiYSTa6EXKv47secp6RiNKeP9CgQlMTi4sObJQFVnyWzWjxvGg/XEIOQOkaxvTfHu
         zhXjgxcie5rM9biXje8HmZR7ap0km9SR3+FSznRjE51kdEZG6r8vJds306SvSgAEvoIt
         h77naJax53s9dqJHTGXGBOc8sX7AUnOrNfXYts+weeEzofnPnc6GB0lVyEEXL/8Olac8
         dHeainnVopJsdETvAoT9njw5ctY1ONHZfufi6QUeTJI5/UPylOiwrf5WPN+62Ge5SvSD
         Y7s0up5Y/vB6v3i7/o3t7RPZpHlVI7FlbDklG0EVbtPQLyJuR/YcIPrxtV2C0bRkPutO
         tzRg==
X-Gm-Message-State: AOJu0YyXAKKqTTfgysFWjFvBfuCzIVeqIs0vALzUH1lKE5aic2fwDUJi
	8gc+9aQg8KvvYKz2S/Bu3kwq3/adGvWz7txh+RF1xdBlz9Kj6fT86Ltcuz1+gYiEHNcLD+U95Ik
	ikTrKtIstoRtA3FKuLrc0D7jfz/tXKFA=
X-Gm-Gg: AY/fxX7lw8k494r1Z26Pb822qFWmE2OhftvsZoiOzAkLCiA8xet0Sa72/9nWzJ9X/zu
	hlX+FOBk/Uvt8AmyNYhEQaKOc/EPBQKwFaRjBJhYG7QSh6vlecPdXX57Srf3RMt1bdXcIPsXcng
	wx4eNK7VNEV4TEKLmFuDY5B8CklyFjy8f+LFLHvxHJ9hljaegr/kp4hrGeCWzwqAQULOqaJfU7f
	upn3puWn8zYu+HJYct8DRJAgi/z/gjcnOfhgww1oVsHIvtTVFm/1mCchMfeFiHU8YtSR+c=
X-Received: by 2002:ac8:7d90:0:b0:501:4b9d:ad19 with SMTP id
 d75a77b69052e-5019f8e3f06mr240782581cf.22.1768876812273; Mon, 19 Jan 2026
 18:40:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120023535.9109-1-zhangshida@kylinos.cn>
In-Reply-To: <20260120023535.9109-1-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Tue, 20 Jan 2026 10:39:36 +0800
X-Gm-Features: AZwV_QjtZzISj4cApH_8-cpqd_TEmwMjrNAMD9SVdiiexF7nJQ6ZlcHGdH80_Ac
Message-ID: <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
Subject: Fwd: [PATCH v2] bcache: use bio cloning for detached device requests
To: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>, axboe@kernel.dk, 
	Sasha Levin <sashal@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-bcache@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zhangshida <zhangshida@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

---------- Forwarded message ---------
=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A zhangshida <starzhangzsd@gmail.com>
Date: 2026=E5=B9=B41=E6=9C=8820=E6=97=A5=E5=91=A8=E4=BA=8C 10:35
Subject: [PATCH v2] bcache: use bio cloning for detached device requests
To: <colyli@fnnas.com>, <kent.overstreet@linux.dev>,
<axboe@kernel.dk>, <sashal@kernel.org>, <hch@infradead.org>
Cc: <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
<zhangshida@kylinos.cn>, <starzhangzsd@gmail.com>, Christoph Hellwig
<hch@lst.de>


From: Shida Zhang <zhangshida@kylinos.cn>

Previously, bcache hijacked the bi_end_io and bi_private fields of
the incoming bio when the backing device was in a detached state.
This is fragile and breaks if the bio is needed to be processed by
other layers.

This patch transitions to using a cloned bio embedded within a private
structure. This ensures the original bio's metadata remains untouched.

Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
Co-developed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---

Changelog:
v1:
https://lore.kernel.org/all/20260115074811.230807-1-zhangshida@kylinos.cn/

 drivers/md/bcache/bcache.h  |  9 +++++
 drivers/md/bcache/request.c | 79 ++++++++++++++++---------------------
 drivers/md/bcache/super.c   | 12 +++++-
 3 files changed, 54 insertions(+), 46 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 8ccacba8554..54ff4e0238a 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -273,6 +273,8 @@ struct bcache_device {

        struct bio_set          bio_split;

+       struct bio_set          bio_detach;
+
        unsigned int            data_csum:1;

        int (*cache_miss)(struct btree *b, struct search *s,
@@ -753,6 +755,13 @@ struct bbio {
        struct bio              bio;
 };

+struct detached_dev_io_private {
+       struct bcache_device    *d;
+       unsigned long           start_time;
+       struct bio              *orig_bio;
+       struct bio              bio;
+};
+
 #define BTREE_PRIO             USHRT_MAX
 #define INITIAL_PRIO           32768U

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 82fdea7dea7..e0b12cb622b 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1077,68 +1077,58 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
        continue_at(cl, cached_dev_bio_complete, NULL);
 }

-struct detached_dev_io_private {
-       struct bcache_device    *d;
-       unsigned long           start_time;
-       bio_end_io_t            *bi_end_io;
-       void                    *bi_private;
-       struct block_device     *orig_bdev;
-};
-
 static void detached_dev_end_io(struct bio *bio)
 {
-       struct detached_dev_io_private *ddip;
-
-       ddip =3D bio->bi_private;
-       bio->bi_end_io =3D ddip->bi_end_io;
-       bio->bi_private =3D ddip->bi_private;
+       struct detached_dev_io_private *ddip =3D
+               container_of(bio, struct detached_dev_io_private, bio);
+       struct bio *orig_bio =3D ddip->orig_bio;

        /* Count on the bcache device */
-       bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
+       bio_end_io_acct(orig_bio, ddip->start_time);

        if (bio->bi_status) {
-               struct cached_dev *dc =3D container_of(ddip->d,
-                                                    struct cached_dev, dis=
k);
+               struct cached_dev *dc =3D bio->bi_private;
+
                /* should count I/O error for backing device here */
                bch_count_backing_io_errors(dc, bio);
+               orig_bio->bi_status =3D bio->bi_status;
        }

-       kfree(ddip);
-       bio_endio(bio);
+       bio_put(bio);
+       bio_endio(orig_bio);
 }

-static void detached_dev_do_request(struct bcache_device *d, struct bio *b=
io,
-               struct block_device *orig_bdev, unsigned long start_time)
+static void detached_dev_do_request(struct bcache_device *d,
+               struct bio *orig_bio, unsigned long start_time)
 {
        struct detached_dev_io_private *ddip;
        struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);
+       struct bio *clone_bio;

-       /*
-        * no need to call closure_get(&dc->disk.cl),
-        * because upper layer had already opened bcache device,
-        * which would call closure_get(&dc->disk.cl)
-        */
-       ddip =3D kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
-       if (!ddip) {
-               bio->bi_status =3D BLK_STS_RESOURCE;
-               bio_endio(bio);
+       if (bio_op(orig_bio) =3D=3D REQ_OP_DISCARD &&
+           !bdev_max_discard_sectors(dc->bdev)) {
+               bio_endio(orig_bio);
                return;
        }

-       ddip->d =3D d;
+       clone_bio =3D bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
+                                   &d->bio_detach);
+       if (!clone_bio) {
+               orig_bio->bi_status =3D BLK_STS_RESOURCE;
+               bio_endio(orig_bio);
+               return;
+       }
+
+       ddip =3D container_of(clone_bio, struct detached_dev_io_private, bi=
o);
        /* Count on the bcache device */
-       ddip->orig_bdev =3D orig_bdev;
+       ddip->d =3D d;
        ddip->start_time =3D start_time;
-       ddip->bi_end_io =3D bio->bi_end_io;
-       ddip->bi_private =3D bio->bi_private;
-       bio->bi_end_io =3D detached_dev_end_io;
-       bio->bi_private =3D ddip;
-
-       if ((bio_op(bio) =3D=3D REQ_OP_DISCARD) &&
-           !bdev_max_discard_sectors(dc->bdev))
-               detached_dev_end_io(bio);
-       else
-               submit_bio_noacct(bio);
+       ddip->orig_bio =3D orig_bio;
+
+       clone_bio->bi_end_io =3D detached_dev_end_io;
+       clone_bio->bi_private =3D dc;
+
+       submit_bio_noacct(clone_bio);
 }

 static void quit_max_writeback_rate(struct cache_set *c,
@@ -1214,10 +1204,10 @@ void cached_dev_submit_bio(struct bio *bio)

        start_time =3D bio_start_io_acct(bio);

-       bio_set_dev(bio, dc->bdev);
        bio->bi_iter.bi_sector +=3D dc->sb.data_offset;

        if (cached_dev_get(dc)) {
+               bio_set_dev(bio, dc->bdev);
                s =3D search_alloc(bio, d, orig_bdev, start_time);
                trace_bcache_request_start(s->d, bio);

@@ -1237,9 +1227,10 @@ void cached_dev_submit_bio(struct bio *bio)
                        else
                                cached_dev_read(dc, s);
                }
-       } else
+       } else {
                /* I/O request sent to backing device */
-               detached_dev_do_request(d, bio, orig_bdev, start_time);
+               detached_dev_do_request(d, bio, start_time);
+       }
 }

 static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c17d4517af2..d4b798668c8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -887,6 +887,7 @@ static void bcache_device_free(struct bcache_device *d)
        }

        bioset_exit(&d->bio_split);
+       bioset_exit(&d->bio_detach);
        kvfree(d->full_dirty_stripes);
        kvfree(d->stripe_sectors_dirty);

@@ -949,6 +950,11 @@ static int bcache_device_init(struct
bcache_device *d, unsigned int block_size,
                        BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
                goto out_ida_remove;

+       if (bioset_init(&d->bio_detach, 4,
+                       offsetof(struct detached_dev_io_private, bio),
+                       BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
+               goto out_bioset_split_exit;
+
        if (lim.logical_block_size > PAGE_SIZE && cached_bdev) {
                /*
                 * This should only happen with BCACHE_SB_VERSION_BDEV.
@@ -964,7 +970,7 @@ static int bcache_device_init(struct bcache_device
*d, unsigned int block_size,

        d->disk =3D blk_alloc_disk(&lim, NUMA_NO_NODE);
        if (IS_ERR(d->disk))
-               goto out_bioset_exit;
+               goto out_bioset_detach_exit;

        set_capacity(d->disk, sectors);
        snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
@@ -976,7 +982,9 @@ static int bcache_device_init(struct bcache_device
*d, unsigned int block_size,
        d->disk->private_data   =3D d;
        return 0;

-out_bioset_exit:
+out_bioset_detach_exit:
+       bioset_exit(&d->bio_detach);
+out_bioset_split_exit:
        bioset_exit(&d->bio_split);
 out_ida_remove:
        ida_free(&bcache_device_idx, idx);
--
2.34.1

