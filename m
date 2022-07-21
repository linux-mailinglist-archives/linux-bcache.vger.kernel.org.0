Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B4457C1E5
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Jul 2022 03:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiGUBhx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Jul 2022 21:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGUBhw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Jul 2022 21:37:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2059C7695B;
        Wed, 20 Jul 2022 18:37:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D22BF33AE3;
        Thu, 21 Jul 2022 01:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658367468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xKU0h+TrWbwrX7u20LOs6wD0FbDJosFHiSAjl15y7BA=;
        b=ymgmJ8T5DFstAwAeyTRXhMtwgZTHvEz5z8gNHZO8y7zrp0KQzTccjdc/jUyZO/KdZO8ey7
        mz9LRvWE7iv37tXlXA2s59O8mGwY7cNCcfYVhgrbn0nozyJgOBgdAEHahA0/EpAk7xh6Bn
        xrSwDF0Aexk0aq9UxZ663B+SMeKlgnQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658367468;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xKU0h+TrWbwrX7u20LOs6wD0FbDJosFHiSAjl15y7BA=;
        b=Q75WVCtBaTsDt88WIIO3aeTLwiWbZ5/viFsuDvx881kxVmAr0gx6habaYw0ka0s6MOBolO
        1F3TnsuLvq96omBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5DAAD134CF;
        Thu, 21 Jul 2022 01:37:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id P+KRCuut2GJ8GAAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 21 Jul 2022 01:37:47 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v2 -next] bcache: Fix spelling mistakes
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220721013506.2842433-1-williamsukatube@163.com>
Date:   Thu, 21 Jul 2022 09:37:44 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F2D7AD2E-BD70-4B5B-9928-A17A740FD3D3@suse.de>
References: <20220721013506.2842433-1-williamsukatube@163.com>
To:     williamsukatube@163.com
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=8821=E6=97=A5 09:35=EF=BC=8Cwilliamsukatube@163.com=
 =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: William Dean <williamsukatube@gmail.com>
>=20
> Fix follow spelling misktakes:
> 	automatical  =3D=3D> automatic
> 	arount =3D=3D> around
> 	individial  =3D=3D> individual
> 	embeddded  =3D=3D> embedded
> 	addionally  =3D=3D> additionally
> 	unncessary  =3D=3D> unnecessary
> 	definitly  =3D=3D> definitely
>=20
> Reported-by: Hacash Robot <hacashRobot@santino.com>
> Signed-off-by: William Dean <williamsukatube@gmail.com>


It looks fine to me. I will add it to my for-next directory.

Thanks.

Coly Li


> ---
> v2: fix wrong commit msg comment
>=20
> drivers/md/bcache/bcache.h    | 2 +-
> drivers/md/bcache/bset.h      | 2 +-
> drivers/md/bcache/btree.c     | 2 +-
> drivers/md/bcache/btree.h     | 2 +-
> drivers/md/bcache/stats.c     | 2 +-
> drivers/md/bcache/writeback.c | 2 +-
> drivers/md/bcache/writeback.h | 2 +-
> 7 files changed, 7 insertions(+), 7 deletions(-)
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
> index e136d6edc1ed..a26863eedc6f 100644
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
> diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
> index 68b02216033d..dcd87eb6f85e 100644
> --- a/drivers/md/bcache/stats.c
> +++ b/drivers/md/bcache/stats.c
> @@ -11,7 +11,7 @@
> #include "sysfs.h"
>=20
> /*
> - * We keep absolute totals of various statistics, and addionally a =
set of three
> + * We keep absolute totals of various statistics, and additionally a =
set of three
>  * rolling averages.
>  *
>  * Every so often, a timer goes off and rescales the rolling averages.
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

