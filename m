Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B23579159
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Jul 2022 05:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbiGSDbi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Jul 2022 23:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiGSDbi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Jul 2022 23:31:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550E325594;
        Mon, 18 Jul 2022 20:31:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6075B33C42;
        Tue, 19 Jul 2022 03:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658201493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pkvLznJmCOLzAgbLSLBHczbN4GBylXyt4/rPo9JuOpI=;
        b=MGchgFosaGDK72KdXjSY5BIPeOB8KC4hJ6dwbcxioiDecPsK2/rdJL/Ohb+Wa6/sB6MlhA
        W3Q7BJoV6PUQvG8pp/beXHFqGEsyfI5PAb6jM8yB2hp7eoIwPc3jn0QZkZw1sLuUIjdGA4
        8qLFBEIIvtptMGdyEqaOXTkakqWAgYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658201493;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pkvLznJmCOLzAgbLSLBHczbN4GBylXyt4/rPo9JuOpI=;
        b=V619nqHKSDQvBuzTYB9E+4Ung+dBq8Rx88j8rXQ8wZ2HbMcjZgluOkldV6KyyCGWAPQzFm
        MRj8JqnhnScrlaDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D230213754;
        Tue, 19 Jul 2022 03:31:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t1GFKZMl1mKGWQAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 19 Jul 2022 03:31:31 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH -next] bcache: Fix spelling mistakes and cleanup code
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220715071533.2729413-1-williamsukatube@163.com>
Date:   Tue, 19 Jul 2022 10:50:24 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2654CB9-1E35-45C3-BEAF-40503F9A9147@suse.de>
References: <20220715071533.2729413-1-williamsukatube@163.com>
To:     williamsukatube@163.com
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=8815=E6=97=A5 15:15=EF=BC=8Cwilliamsukatube@163.com=
 =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: William Dean <williamsukatube@gmail.com>
>=20
> First, fix follow spelling misktakes:
> 	automatical  =3D=3D> automatic
> 	individial  =3D=3D> around
> 	embeddded  =3D=3D> embedded
> 	addionally  =3D=3D> addtionally
> 	unncessary  =3D=3D> unnecessary
> 	definitly  =3D=3D> definitely
> Second, delete extra space or tab where
> appropriate to make code format more standardized.
>=20
> Reported-by: Hacash Robot <hacashRobot@santino.com>
> Signed-off-by: William Dean <williamsukatube@gmail.com>

Hi William,

It should be better to split this patch into 2 parts, one is for typo =
fixes, one is for extra space or tab fixes. Then it can be more =
convenient for me to review and maintain.

And BTW, addionally  =3D=3D> addtionally, I guess you meant =
=E2=80=98additionally=E2=80=99, wasn=E2=80=99t it?

Thanks.

Coly Li

> ---
> drivers/md/bcache/bcache.h    | 2 +-
> drivers/md/bcache/bset.h      | 2 +-
> drivers/md/bcache/btree.c     | 6 +++---
> drivers/md/bcache/btree.h     | 2 +-
> drivers/md/bcache/journal.c   | 2 +-
> drivers/md/bcache/request.c   | 5 ++---
> drivers/md/bcache/stats.c     | 2 +-
> drivers/md/bcache/super.c     | 2 +-
> drivers/md/bcache/writeback.c | 2 +-
> drivers/md/bcache/writeback.h | 2 +-
> 10 files changed, 13 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 2acda9cea0f9..2b35c0a14d4d 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -635,7 +635,7 @@ struct cache_set {
> 	struct bkey		gc_done;
>=20
> 	/*
> -	 * For automatical garbage collection after writeback completed, =
this
> +	 * For automatic garbage collection after writeback completed, =
this
> 	 * varialbe is used as bit fields,
> 	 * - 0000 0001b (BCH_ENABLE_AUTO_GC): enable gc after writeback
> 	 * - 0000 0010b (BCH_DO_AUTO_GC):     do gc after writeback
> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> index d795c84246b0..76f75bbcb731 100644
> --- a/drivers/md/bcache/bset.h
> +++ b/drivers/md/bcache/bset.h
> @@ -45,7 +45,7 @@
>  * 4 in memory - we lazily resort as needed.
>  *
>  * We implement code here for creating and maintaining auxiliary =
search trees
> - * (described below) for searching an individial bset, and on top of =
that we
> + * (described below) for searching an individual bset, and on top of =
that we
>  * implement a btree iterator.
>  *
>  * BTREE ITERATOR:
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index e136d6edc1ed..3d9fec07e862 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -154,7 +154,7 @@ void bch_btree_node_read_done(struct btree *b)
> 	/*
> 	 * c->fill_iter can allocate an iterator with more memory space
> 	 * than static MAX_BSETS.
> -	 * See the comment arount cache_set->fill_iter.
> +	 * See the comment around cache_set->fill_iter.
> 	 */
> 	iter =3D mempool_alloc(&b->c->fill_iter, GFP_NOIO);
> 	iter->size =3D b->c->cache->sb.bucket_size / =
b->c->cache->sb.block_size;
> @@ -2529,8 +2529,8 @@ int __bch_btree_map_nodes(struct btree_op *op, =
struct cache_set *c,
> }
>=20
> int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
> -				      struct bkey *from, =
btree_map_keys_fn *fn,
> -				      int flags)
> +			       struct bkey *from, btree_map_keys_fn *fn,
> +			       int flags)
> {
> 	int ret =3D MAP_CONTINUE;
> 	struct bkey *k;
> diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
> index 1b5fdbc0d83e..b46bf6268aca 100644
> --- a/drivers/md/bcache/btree.h
> +++ b/drivers/md/bcache/btree.h
> @@ -54,7 +54,7 @@
>  * Btree nodes never have to be explicitly read in; =
bch_btree_node_get() handles
>  * this.
>  *
> - * For writing, we have two btree_write structs embeddded in struct =
btree - one
> + * For writing, we have two btree_write structs embedded in struct =
btree - one
>  * write in flight, and one being set up, and we toggle between them.
>  *
>  * Writing is done with a single function -  bch_btree_write() really =
serves two
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index e5da469a4235..c7f6d2611037 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -790,7 +790,7 @@ static void journal_write_unlocked(struct closure =
*cl)
>=20
> 		atomic_long_add(sectors, &ca->meta_sectors_written);
>=20
> -		bio_reset(bio, ca->bdev, REQ_OP_WRITE |=20
> +		bio_reset(bio, ca->bdev, REQ_OP_WRITE |
> 			  REQ_SYNC | REQ_META | REQ_PREFLUSH | REQ_FUA);
> 		bio->bi_iter.bi_sector	=3D PTR_OFFSET(k, i);
> 		bio->bi_iter.bi_size =3D sectors << 9;
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index f2c5a7e06fa9..ceba536e0880 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -338,7 +338,6 @@ unsigned int bch_get_congested(const struct =
cache_set *c)
> 		return 0;
>=20
> 	i +=3D CONGESTED_MAX;
> -
> 	if (i > 0)
> 		i =3D fract_exp_two(i, 6);
>=20
> @@ -1326,8 +1325,8 @@ static int flash_dev_ioctl(struct bcache_device =
*d, fmode_t mode,
>=20
> void bch_flash_dev_request_init(struct bcache_device *d)
> {
> -	d->cache_miss				=3D =
flash_dev_cache_miss;
> -	d->ioctl				=3D flash_dev_ioctl;
> +	d->cache_miss	=3D flash_dev_cache_miss;
> +	d->ioctl	=3D flash_dev_ioctl;
> }
>=20
> void bch_request_exit(void)
> diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
> index 68b02216033d..983d16822e53 100644
> --- a/drivers/md/bcache/stats.c
> +++ b/drivers/md/bcache/stats.c
> @@ -11,7 +11,7 @@
> #include "sysfs.h"
>=20
> /*
> - * We keep absolute totals of various statistics, and addionally a =
set of three
> + * We keep absolute totals of various statistics, and addtionally a =
set of three
>  * rolling averages.
>  *
>  * Every so often, a timer goes off and rescales the rolling averages.
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 3563d15dbaf2..aca27386cca2 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -686,6 +686,7 @@ int bch_prio_write(struct cache *ca, bool wait)
>=20
> 		ca->prio_last_buckets[i] =3D ca->prio_buckets[i];
> 	}
> +
> 	return 0;
> }
>=20
> @@ -2663,7 +2664,6 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> 	return ret;
> }
>=20
> -
> struct pdev {
> 	struct list_head list;
> 	struct cached_dev *dc;
> diff --git a/drivers/md/bcache/writeback.c =
b/drivers/md/bcache/writeback.c
> index 3f0ff3aab6f2..bd83a33b8a2f 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -238,7 +238,7 @@ static void update_writeback_rate(struct =
work_struct *work)
> 	/*
> 	 * If the whole cache set is idle, set_at_max_writeback_rate()
> 	 * will set writeback rate to a max number. Then it is
> -	 * unncessary to update writeback rate for an idle cache set
> +	 * unnecessary to update writeback rate for an idle cache set
> 	 * in maximum writeback rate number(s).
> 	 */
> 	if (atomic_read(&dc->has_dirty) && dc->writeback_percent &&
> diff --git a/drivers/md/bcache/writeback.h =
b/drivers/md/bcache/writeback.h
> index 31df716951f6..37f66bea522f 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -69,7 +69,7 @@ static inline int offset_to_stripe(struct =
bcache_device *d,
> 	}
>=20
> 	/*
> -	 * Here offset is definitly smaller than INT_MAX,
> +	 * Here offset is definitely smaller than INT_MAX,
> 	 * return it as int will never overflow.
> 	 */
> 	return offset;
> --=20
> 2.25.1
>=20

