Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7807273A6B5
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjFVQ4p (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 12:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjFVQ4X (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 12:56:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AFC1BD6;
        Thu, 22 Jun 2023 09:56:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1FA6321C96;
        Thu, 22 Jun 2023 16:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1687452976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CQnEWRm6GJq+3lQBmmJRd8E7zD+4frsr5pEHF32aYBY=;
        b=eR9GvTq7+QipIZDP0FcOO4SLvdqyhtH8B0yVpXtt3zuSy8A/xPgrolmN0iLfJtVjvrLJK8
        kogNwP/K1lm7s1SVYw991Ivx3CVi1t5RE2Ho4PzvbpfcuFzN2vNT4XK51Wg0VD7Sv2pyYX
        0voe2w62e2g2y2FEjd8VhJVoV4fViA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1687452976;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CQnEWRm6GJq+3lQBmmJRd8E7zD+4frsr5pEHF32aYBY=;
        b=iQrI3lW1bwlu3Owa4ivxPeJTHoc9q5PasnitGs+cLxfACqRVqy1iwBO0LcTTKxf84q5Hqo
        rO+fucpBmKyOA1Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E0BE13905;
        Thu, 22 Jun 2023 16:56:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yB0jGi59lGT4TgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 22 Jun 2023 16:56:14 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH v2 1/2] bcache: Alloc holder object before async
 registration
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230622164658.12861-1-jack@suse.cz>
Date:   Fri, 23 Jun 2023 00:56:04 +0800
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1ED53A59-24B6-466E-A5EC-7091D0D96087@suse.de>
References: <20230622164149.17134-1-jack@suse.cz>
 <20230622164658.12861-1-jack@suse.cz>
To:     Jan Kara <jack@suse.cz>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Jun 22, 2023 at 06:46:54PM +0200, Jan Kara wrote:
> Allocate holder object (cache or cached_dev) before offloading the
> rest of the startup to async work. This will allow us to open the =
block
> block device with proper holder.
>=20
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
> drivers/md/bcache/super.c | 66 +++++++++++++++------------------------
> 1 file changed, 25 insertions(+), 41 deletions(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e2a803683105..913dd94353b6 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2448,6 +2448,7 @@ struct async_reg_args {
> 	struct cache_sb *sb;
> 	struct cache_sb_disk *sb_disk;
> 	struct block_device *bdev;
> +	void *holder;
> };
>=20
> static void register_bdev_worker(struct work_struct *work)
> @@ -2455,22 +2456,13 @@ static void register_bdev_worker(struct =
work_struct *work)
> 	int fail =3D false;
> 	struct async_reg_args *args =3D
> 		container_of(work, struct async_reg_args, =
reg_work.work);
> -	struct cached_dev *dc;
> -
> -	dc =3D kzalloc(sizeof(*dc), GFP_KERNEL);
> -	if (!dc) {
> -		fail =3D true;
> -		put_page(virt_to_page(args->sb_disk));
> -		blkdev_put(args->bdev, bcache_kobj);
> -		goto out;
> -	}
>=20
> 	mutex_lock(&bch_register_lock);
> -	if (register_bdev(args->sb, args->sb_disk, args->bdev, dc) < 0)
> +	if (register_bdev(args->sb, args->sb_disk, args->bdev, =
args->holder)
> +	    < 0)
> 		fail =3D true;
> 	mutex_unlock(&bch_register_lock);
>=20
> -out:
> 	if (fail)
> 		pr_info("error %s: fail to register backing device\n",
> 			args->path);
> @@ -2485,21 +2477,11 @@ static void register_cache_worker(struct =
work_struct *work)
> 	int fail =3D false;
> 	struct async_reg_args *args =3D
> 		container_of(work, struct async_reg_args, =
reg_work.work);
> -	struct cache *ca;
> -
> -	ca =3D kzalloc(sizeof(*ca), GFP_KERNEL);
> -	if (!ca) {
> -		fail =3D true;
> -		put_page(virt_to_page(args->sb_disk));
> -		blkdev_put(args->bdev, bcache_kobj);
> -		goto out;
> -	}
>=20
> 	/* blkdev_put() will be called in bch_cache_release() */
> -	if (register_cache(args->sb, args->sb_disk, args->bdev, ca) !=3D =
0)
> +	if (register_cache(args->sb, args->sb_disk, args->bdev, =
args->holder))
> 		fail =3D true;
>=20
> -out:
> 	if (fail)
> 		pr_info("error %s: fail to register cache device\n",
> 			args->path);
> @@ -2520,6 +2502,13 @@ static void register_device_async(struct =
async_reg_args *args)
> 	queue_delayed_work(system_wq, &args->reg_work, 10);
> }
>=20
> +static void *alloc_holder_object(struct cache_sb *sb)
> +{
> +	if (SB_IS_BDEV(sb))
> +		return kzalloc(sizeof(struct cached_dev), GFP_KERNEL);
> +	return kzalloc(sizeof(struct cache), GFP_KERNEL);
> +}
> +
> static ssize_t register_bcache(struct kobject *k, struct =
kobj_attribute *attr,
> 			       const char *buffer, size_t size)
> {
> @@ -2528,6 +2517,7 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> 	struct cache_sb *sb;
> 	struct cache_sb_disk *sb_disk;
> 	struct block_device *bdev;
> +	void *holder;
> 	ssize_t ret;
> 	bool async_registration =3D false;
>=20
> @@ -2585,6 +2575,13 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> 	if (err)
> 		goto out_blkdev_put;
>=20
> +	holder =3D alloc_holder_object(sb);
> +	if (!holder) {
> +		ret =3D -ENOMEM;
> +		err =3D "cannot allocate memory";
> +		goto out_put_sb_page;
> +	}
> +
> 	err =3D "failed to register device";
>=20
> 	if (async_registration) {
> @@ -2595,44 +2592,29 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> 		if (!args) {
> 			ret =3D -ENOMEM;
> 			err =3D "cannot allocate memory";
> -			goto out_put_sb_page;
> +			goto out_free_holder;
> 		}
>=20
> 		args->path	=3D path;
> 		args->sb	=3D sb;
> 		args->sb_disk	=3D sb_disk;
> 		args->bdev	=3D bdev;
> +		args->holder	=3D holder;
> 		register_device_async(args);
> 		/* No wait and returns to user space */
> 		goto async_done;
> 	}
>=20
> 	if (SB_IS_BDEV(sb)) {
> -		struct cached_dev *dc =3D kzalloc(sizeof(*dc), =
GFP_KERNEL);
> -
> -		if (!dc) {
> -			ret =3D -ENOMEM;
> -			err =3D "cannot allocate memory";
> -			goto out_put_sb_page;
> -		}
> -
> 		mutex_lock(&bch_register_lock);
> -		ret =3D register_bdev(sb, sb_disk, bdev, dc);
> +		ret =3D register_bdev(sb, sb_disk, bdev, holder);
> 		mutex_unlock(&bch_register_lock);
> 		/* blkdev_put() will be called in cached_dev_free() */
> 		if (ret < 0)
> 			goto out_free_sb;
> 	} else {
> -		struct cache *ca =3D kzalloc(sizeof(*ca), GFP_KERNEL);
> -
> -		if (!ca) {
> -			ret =3D -ENOMEM;
> -			err =3D "cannot allocate memory";
> -			goto out_put_sb_page;
> -		}
> -
> 		/* blkdev_put() will be called in bch_cache_release() */
> -		ret =3D register_cache(sb, sb_disk, bdev, ca);
> +		ret =3D register_cache(sb, sb_disk, bdev, holder);
> 		if (ret)
> 			goto out_free_sb;
> 	}
> @@ -2644,6 +2626,8 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> async_done:
> 	return size;
>=20
> +out_free_holder:
> +	kfree(holder);
> out_put_sb_page:
> 	put_page(virt_to_page(sb_disk));
> out_blkdev_put:
> --=20
> 2.35.3
>=20

--=20
Coly Li
