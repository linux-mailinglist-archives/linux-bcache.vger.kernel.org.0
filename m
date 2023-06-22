Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA01A73A6B3
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 18:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjFVQ4o (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 12:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbjFVQ4S (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 12:56:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DC110A;
        Thu, 22 Jun 2023 09:56:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B045D21BB7;
        Thu, 22 Jun 2023 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1687452973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a+RA++t4Dol3TZ0tjW5ydUV8/dySbaew2ESNwLpAC/s=;
        b=EPD3PX3Vdili5zNw02i28PoMW69Pe1dEAd/HsiexgK81UYdVl3og3DjjyKbFi6inxfuZH5
        0S0QF+AJScQb27Qa3+9o6AQRq8zLTwQOJ/X845qu65+nCfBPRMmvUE+UKS4uygHv4G0H88
        lhjOhX+eMfWtECi0eocs9KXWpt+FGxM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1687452973;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a+RA++t4Dol3TZ0tjW5ydUV8/dySbaew2ESNwLpAC/s=;
        b=rlASuO4wdLvxBwP6F81/kITNbWWf+NNYhDQ1LmX3vxbiITRgAPxQYF82IO9hOvWAmM/ytB
        1+WYrDUnHI/nLFBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3757513905;
        Thu, 22 Jun 2023 16:56:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lv31ACx9lGT4TgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 22 Jun 2023 16:56:12 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH v2 2/2] bcache: Fix bcache device claiming
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230622164658.12861-2-jack@suse.cz>
Date:   Fri, 23 Jun 2023 00:55:59 +0800
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6150CB32-3C37-4C41-9C01-BBED91550EA9@suse.de>
References: <20230622164149.17134-1-jack@suse.cz>
 <20230622164658.12861-2-jack@suse.cz>
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

On Thu, Jun 22, 2023 at 06:46:55PM +0200, Jan Kara wrote:
> Commit 2736e8eeb0cc ("block: use the holder as indication for =
exclusive
> opens") introduced a change that blkdev_put() has to get exclusive
> holder of the bdev as an argument. However it overlooked that
> register_bdev() and register_cache() overwrite the bdev->bd_holder =
field
> in the block device to point to the real owning object which was not
> available at the time we called blkdev_get_by_path(). Messing with =
bdev
> internals like this is a layering violation and it also causes
> blkdev_put() to issue warning about mismatching holders.
>=20
> Fix bcache to reopen the block device with appropriate holder once it =
is
> available which also restores the behavior that multiple bcache caches
> cannot claim the same device which was broken by commit 29499ab060fe
> ("bcache: don't pass a stack address to blkdev_get_by_path").
>=20
> Fixes: 2736e8eeb0cc ("block: use the holder as indication for =
exclusive opens")
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
> drivers/md/bcache/super.c | 65 +++++++++++++++++++++++----------------
> 1 file changed, 38 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 913dd94353b6..0ae2b3676293 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1369,7 +1369,7 @@ static void cached_dev_free(struct closure *cl)
> 		put_page(virt_to_page(dc->sb_disk));
>=20
> 	if (!IS_ERR_OR_NULL(dc->bdev))
> -		blkdev_put(dc->bdev, bcache_kobj);
> +		blkdev_put(dc->bdev, dc);
>=20
> 	wake_up(&unregister_wait);
>=20
> @@ -1453,7 +1453,6 @@ static int register_bdev(struct cache_sb *sb, =
struct cache_sb_disk *sb_disk,
>=20
> 	memcpy(&dc->sb, sb, sizeof(struct cache_sb));
> 	dc->bdev =3D bdev;
> -	dc->bdev->bd_holder =3D dc;
> 	dc->sb_disk =3D sb_disk;
>=20
> 	if (cached_dev_init(dc, sb->block_size << 9))
> @@ -2218,7 +2217,7 @@ void bch_cache_release(struct kobject *kobj)
> 		put_page(virt_to_page(ca->sb_disk));
>=20
> 	if (!IS_ERR_OR_NULL(ca->bdev))
> -		blkdev_put(ca->bdev, bcache_kobj);
> +		blkdev_put(ca->bdev, ca);
>=20
> 	kfree(ca);
> 	module_put(THIS_MODULE);
> @@ -2345,7 +2344,6 @@ static int register_cache(struct cache_sb *sb, =
struct cache_sb_disk *sb_disk,
>=20
> 	memcpy(&ca->sb, sb, sizeof(struct cache_sb));
> 	ca->bdev =3D bdev;
> -	ca->bdev->bd_holder =3D ca;
> 	ca->sb_disk =3D sb_disk;
>=20
> 	if (bdev_max_discard_sectors((bdev)))
> @@ -2359,7 +2357,7 @@ static int register_cache(struct cache_sb *sb, =
struct cache_sb_disk *sb_disk,
> 		 * call blkdev_put() to bdev in bch_cache_release(). So =
we
> 		 * explicitly call blkdev_put() here.
> 		 */
> -		blkdev_put(bdev, bcache_kobj);
> +		blkdev_put(bdev, ca);
> 		if (ret =3D=3D -ENOMEM)
> 			err =3D "cache_alloc(): -ENOMEM";
> 		else if (ret =3D=3D -EPERM)
> @@ -2516,10 +2514,11 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> 	char *path =3D NULL;
> 	struct cache_sb *sb;
> 	struct cache_sb_disk *sb_disk;
> -	struct block_device *bdev;
> -	void *holder;
> +	struct block_device *bdev, *bdev2;
> +	void *holder =3D NULL;
> 	ssize_t ret;
> 	bool async_registration =3D false;
> +	bool quiet =3D false;
>=20
> #ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
> 	async_registration =3D true;
> @@ -2548,24 +2547,9 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
>=20
> 	ret =3D -EINVAL;
> 	err =3D "failed to open device";
> -	bdev =3D blkdev_get_by_path(strim(path), BLK_OPEN_READ | =
BLK_OPEN_WRITE,
> -				  bcache_kobj, NULL);
> -	if (IS_ERR(bdev)) {
> -		if (bdev =3D=3D ERR_PTR(-EBUSY)) {
> -			dev_t dev;
> -
> -			mutex_lock(&bch_register_lock);
> -			if (lookup_bdev(strim(path), &dev) =3D=3D 0 &&
> -			    bch_is_open(dev))
> -				err =3D "device already registered";
> -			else
> -				err =3D "device busy";
> -			mutex_unlock(&bch_register_lock);
> -			if (attr =3D=3D &ksysfs_register_quiet)
> -				goto done;
> -		}
> +	bdev =3D blkdev_get_by_path(strim(path), BLK_OPEN_READ, NULL, =
NULL);
> +	if (IS_ERR(bdev))
> 		goto out_free_sb;
> -	}
>=20
> 	err =3D "failed to set blocksize";
> 	if (set_blocksize(bdev, 4096))
> @@ -2582,6 +2566,32 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> 		goto out_put_sb_page;
> 	}
>=20
> +	/* Now reopen in exclusive mode with proper holder */
> +	bdev2 =3D blkdev_get_by_dev(bdev->bd_dev, BLK_OPEN_READ | =
BLK_OPEN_WRITE,
> +				  holder, NULL);
> +	blkdev_put(bdev, NULL);
> +	bdev =3D bdev2;
> +	if (IS_ERR(bdev)) {
> +		ret =3D PTR_ERR(bdev);
> +		bdev =3D NULL;
> +		if (ret =3D=3D -EBUSY) {
> +			dev_t dev;
> +
> +			mutex_lock(&bch_register_lock);
> +			if (lookup_bdev(strim(path), &dev) =3D=3D 0 &&
> +			    bch_is_open(dev))
> +				err =3D "device already registered";
> +			else
> +				err =3D "device busy";
> +			mutex_unlock(&bch_register_lock);
> +			if (attr =3D=3D &ksysfs_register_quiet) {
> +				quiet =3D true;
> +				ret =3D size;
> +			}
> +		}
> +		goto out_free_holder;
> +	}
> +
> 	err =3D "failed to register device";
>=20
> 	if (async_registration) {
> @@ -2619,7 +2629,6 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> 			goto out_free_sb;
> 	}
>=20
> -done:
> 	kfree(sb);
> 	kfree(path);
> 	module_put(THIS_MODULE);
> @@ -2631,7 +2640,8 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> out_put_sb_page:
> 	put_page(virt_to_page(sb_disk));
> out_blkdev_put:
> -	blkdev_put(bdev, register_bcache);
> +	if (bdev)
> +		blkdev_put(bdev, holder);
> out_free_sb:
> 	kfree(sb);
> out_free_path:
> @@ -2640,7 +2650,8 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> out_module_put:
> 	module_put(THIS_MODULE);
> out:
> -	pr_info("error %s: %s\n", path?path:"", err);
> +	if (!quiet)
> +		pr_info("error %s: %s\n", path?path:"", err);
> 	return ret;
> }
>=20
> --=20
> 2.35.3
>=20

--=20
Coly Li
