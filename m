Return-Path: <linux-bcache+bounces-191-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66C9981F79B
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Dec 2023 12:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B4E51C217F6
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Dec 2023 11:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1CD5233;
	Thu, 28 Dec 2023 11:15:25 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79F56AAC;
	Thu, 28 Dec 2023 11:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 64FC36343B34;
	Thu, 28 Dec 2023 12:09:39 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id QLKAjcGqlAWB; Thu, 28 Dec 2023 12:09:38 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 83EF66343B4D;
	Thu, 28 Dec 2023 12:09:38 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ho9bqT-b41NN; Thu, 28 Dec 2023 12:09:38 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id 498246343B34;
	Thu, 28 Dec 2023 12:09:38 +0100 (CET)
Date: Thu, 28 Dec 2023 12:09:38 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: hch <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, anton ivanov <anton.ivanov@cambridgegreys.com>, 
	Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, 
	senozhatsky <senozhatsky@chromium.org>, Coly Li <colyli@suse.de>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, 
	Vignesh Raghavendra <vigneshr@ti.com>, 
	linux-um <linux-um@lists.infradead.org>, 
	linux-block <linux-block@vger.kernel.org>, nbd@other.debian.org, 
	linux-bcache <linux-bcache@vger.kernel.org>, 
	linux-mtd <linux-mtd@lists.infradead.org>
Message-ID: <651248504.172152.1703761778190.JavaMail.zimbra@nod.at>
In-Reply-To: <20231228075545.362768-10-hch@lst.de>
References: <20231228075545.362768-1-hch@lst.de> <20231228075545.362768-10-hch@lst.de>
Subject: Re: [PATCH 9/9] mtd_blkdevs: use the default discard granularity
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: mtd_blkdevs: use the default discard granularity
Thread-Index: qBzbN7jF6yK+/MNDxaXtjyFFzypHWw==

----- Urspr=C3=BCngliche Mail -----
> Von: "hch" <hch@lst.de>
> An: "Jens Axboe" <axboe@kernel.dk>
> CC: "richard" <richard@nod.at>, "anton ivanov" <anton.ivanov@cambridgegre=
ys.com>, "Josef Bacik" <josef@toxicpanda.com>,
> "Minchan Kim" <minchan@kernel.org>, "senozhatsky" <senozhatsky@chromium.o=
rg>, "Coly Li" <colyli@suse.de>, "Miquel
> Raynal" <miquel.raynal@bootlin.com>, "Vignesh Raghavendra" <vigneshr@ti.c=
om>, "linux-um"
> <linux-um@lists.infradead.org>, "linux-block" <linux-block@vger.kernel.or=
g>, nbd@other.debian.org, "linux-bcache"
> <linux-bcache@vger.kernel.org>, "linux-mtd" <linux-mtd@lists.infradead.or=
g>
> Gesendet: Donnerstag, 28. Dezember 2023 08:55:45
> Betreff: [PATCH 9/9] mtd_blkdevs: use the default discard granularity

> The discard granularity now defaults to a single sector, so don't set
> that value explicitly.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> drivers/mtd/mtd_blkdevs.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
> index ff18636e088973..0da7b33849471a 100644
> --- a/drivers/mtd/mtd_blkdevs.c
> +++ b/drivers/mtd/mtd_blkdevs.c
> @@ -376,10 +376,8 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *ne=
w)
> =09blk_queue_flag_set(QUEUE_FLAG_NONROT, new->rq);
> =09blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, new->rq);
>=20
> -=09if (tr->discard) {
> +=09if (tr->discard)
> =09=09blk_queue_max_discard_sectors(new->rq, UINT_MAX);
> -=09=09new->rq->limits.discard_granularity =3D tr->blksize;
> -=09}

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard

