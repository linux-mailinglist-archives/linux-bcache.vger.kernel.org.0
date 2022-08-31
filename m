Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687FF5A8292
	for <lists+linux-bcache@lfdr.de>; Wed, 31 Aug 2022 18:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiHaQA0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 31 Aug 2022 12:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiHaQAY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Aug 2022 12:00:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240631C92A;
        Wed, 31 Aug 2022 09:00:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B3A68220C9;
        Wed, 31 Aug 2022 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661961621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EL7PpUC/9fDDdQyVaF6fOuuxE/vx8O/lKuKQ83derjE=;
        b=Yseia1Mj+4h3TKJdqYY/Xk9NmchmY8PomIAmXluyZkV/+c6IyqYpl1G2nxssuFlnEeYMQe
        Xcmm7QnbktJrlnGO3Ts/CJIdkFtlCFMlxqYGmE50UfrOJD8zJLblIN+LssujI+YkEjCgzI
        DzXcH2a6+yHxU3LcjUGInYFTPSvJ8tU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661961621;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EL7PpUC/9fDDdQyVaF6fOuuxE/vx8O/lKuKQ83derjE=;
        b=ilAmCiipKlRxpWHpLuabLojg+eJtd9tmi3KF8XQQCHzTeJ+fgQsQ2DL8fuzSeL71RO5SfG
        nBMkmMIJJlliRdBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A7BD01332D;
        Wed, 31 Aug 2022 16:00:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iRUPA5SFD2NhegAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 31 Aug 2022 16:00:20 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 2/3] bcache: Convert to lib/time_stats
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220829165344.2958640-3-kent.overstreet@linux.dev>
Date:   Thu, 1 Sep 2022 00:00:17 +0800
Cc:     linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <14ACCED7-D24D-4AC4-8677-F7F4630A840A@suse.de>
References: <20220829165344.2958640-1-kent.overstreet@linux.dev>
 <20220829165344.2958640-3-kent.overstreet@linux.dev>
To:     Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8830=E6=97=A5 00:53=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> This patch converts bcache to the new generic time_stats code
> lib/time_stats.c. The new code is from bcachefs, and has some changes
> from the version in bcache:
>=20
> - we now use ktime_get_ns(), not local_clock(). When the code was
>   originally written multi processor systems that lacked synchronized
>   TSCs were still common, and so local_clock() was much cheaper than
>   sched_clock() (though not necessarily fully accurate, due to TSC
>   drift). ktime_get_ns() should be cheap enough on all common hardware
>   now, and more standard/correct.
>=20
> - time_stats are now exported in a single file in sysfs, which means =
we
>   can improve the statistics we keep track of without changing all
>   users. This also means we don't have to manually specify which units
>   (ms, us, ns) a given time_stats should be printed in; that's handled
>   dynamically.
>=20
> - There's a lazily-allocated percpu buffer, which now needs to be =
freed
>   with time_stats_exit().
>=20
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Coly Li <colyli@suse.de>

Hi Kent,

Overall I am OK with the change to bcache code. You may add
	Acked-by: Coly Li <colyli@suse.de>
in future version of this patch.

In bcache-tools, they don=E2=80=99t read the changed sysfs files =
(including bcache-status), IMHO changing the output format won=E2=80=99t =
be problem for upstream.

My only question is, how to understand the time_stats_to_text() output =
format,
count:          3
rate:           0/sec
frequency:      4 sec
avg duration:   4 sec
max duration:   4 sec
quantiles (ns): 0 4288669120 4288669120 5360836048 5360836048 5360836048 =
5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 =
5360836048 5360836048 5360836048

Fro the above output, what are =E2=80=9Crate=E2=80=9D, =E2=80=9Cfrequence=E2=
=80=9D and =E2=80=9Cquantiles=E2=80=9D for?

Thanks.

Coly Li

> ---
> drivers/md/bcache/Kconfig  |  1 +
> drivers/md/bcache/bcache.h |  1 +
> drivers/md/bcache/bset.c   |  8 +++---
> drivers/md/bcache/bset.h   |  1 +
> drivers/md/bcache/btree.c  | 12 ++++----
> drivers/md/bcache/super.c  |  3 ++
> drivers/md/bcache/sysfs.c  | 43 ++++++++++++++++++++--------
> drivers/md/bcache/util.c   | 30 --------------------
> drivers/md/bcache/util.h   | 57 --------------------------------------
> 9 files changed, 47 insertions(+), 109 deletions(-)
>=20
> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
> index 529c9d04e9..8d165052e5 100644
> --- a/drivers/md/bcache/Kconfig
> +++ b/drivers/md/bcache/Kconfig
> @@ -4,6 +4,7 @@ config BCACHE
> 	tristate "Block device as cache"
> 	select BLOCK_HOLDER_DEPRECATED if SYSFS
> 	select CRC64
> +	select TIME_STATS
> 	help
> 	Allows a block device to be used as cache for other devices; =
uses
> 	a btree for indexing and the layout is optimized for SSDs.
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 2acda9cea0..5100010a38 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -185,6 +185,7 @@
> #include <linux/rbtree.h>
> #include <linux/rwsem.h>
> #include <linux/refcount.h>
> +#include <linux/time_stats.h>
> #include <linux/types.h>
> #include <linux/workqueue.h>
> #include <linux/kthread.h>
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 94d38e8a59..727e9b7aea 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -1251,7 +1251,7 @@ static void __btree_sort(struct btree_keys *b, =
struct btree_iter *iter,
> 		order =3D state->page_order;
> 	}
>=20
> -	start_time =3D local_clock();
> +	start_time =3D ktime_get_ns();
>=20
> 	btree_mergesort(b, out, iter, fixup, false);
> 	b->nsets =3D start;
> @@ -1286,7 +1286,7 @@ static void __btree_sort(struct btree_keys *b, =
struct btree_iter *iter,
> 	bch_bset_build_written_tree(b);
>=20
> 	if (!start)
> -		bch_time_stats_update(&state->time, start_time);
> +		time_stats_update(&state->time, start_time);
> }
>=20
> void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
> @@ -1322,14 +1322,14 @@ void bch_btree_sort_and_fix_extents(struct =
btree_keys *b,
> void bch_btree_sort_into(struct btree_keys *b, struct btree_keys *new,
> 			 struct bset_sort_state *state)
> {
> -	uint64_t start_time =3D local_clock();
> +	uint64_t start_time =3D ktime_get_ns();
> 	struct btree_iter iter;
>=20
> 	bch_btree_iter_init(b, &iter, NULL);
>=20
> 	btree_mergesort(b, new->set->data, &iter, false, true);
>=20
> -	bch_time_stats_update(&state->time, start_time);
> +	time_stats_update(&state->time, start_time);
>=20
> 	new->set->size =3D 0; // XXX: why?
> }
> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> index d795c84246..13e524ad77 100644
> --- a/drivers/md/bcache/bset.h
> +++ b/drivers/md/bcache/bset.h
> @@ -3,6 +3,7 @@
> #define _BCACHE_BSET_H
>=20
> #include <linux/kernel.h>
> +#include <linux/time_stats.h>
> #include <linux/types.h>
>=20
> #include "bcache_ondisk.h"
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a98..abf543bc75 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -242,7 +242,7 @@ static void btree_node_read_endio(struct bio *bio)
>=20
> static void bch_btree_node_read(struct btree *b)
> {
> -	uint64_t start_time =3D local_clock();
> +	uint64_t start_time =3D ktime_get_ns();
> 	struct closure cl;
> 	struct bio *bio;
>=20
> @@ -270,7 +270,7 @@ static void bch_btree_node_read(struct btree *b)
> 		goto err;
>=20
> 	bch_btree_node_read_done(b);
> -	bch_time_stats_update(&b->c->btree_read_time, start_time);
> +	time_stats_update(&b->c->btree_read_time, start_time);
>=20
> 	return;
> err:
> @@ -1789,7 +1789,7 @@ static void bch_btree_gc(struct cache_set *c)
> 	struct gc_stat stats;
> 	struct closure writes;
> 	struct btree_op op;
> -	uint64_t start_time =3D local_clock();
> +	uint64_t start_time =3D ktime_get_ns();
>=20
> 	trace_bcache_gc_start(c);
>=20
> @@ -1815,7 +1815,7 @@ static void bch_btree_gc(struct cache_set *c)
> 	bch_btree_gc_finish(c);
> 	wake_up_allocators(c);
>=20
> -	bch_time_stats_update(&c->btree_gc_time, start_time);
> +	time_stats_update(&c->btree_gc_time, start_time);
>=20
> 	stats.key_bytes *=3D sizeof(uint64_t);
> 	stats.data	<<=3D 9;
> @@ -2191,7 +2191,7 @@ static int btree_split(struct btree *b, struct =
btree_op *op,
> {
> 	bool split;
> 	struct btree *n1, *n2 =3D NULL, *n3 =3D NULL;
> -	uint64_t start_time =3D local_clock();
> +	uint64_t start_time =3D ktime_get_ns();
> 	struct closure cl;
> 	struct keylist parent_keys;
>=20
> @@ -2297,7 +2297,7 @@ static int btree_split(struct btree *b, struct =
btree_op *op,
> 	btree_node_free(b);
> 	rw_unlock(true, n1);
>=20
> -	bch_time_stats_update(&b->c->btree_split_time, start_time);
> +	time_stats_update(&b->c->btree_split_time, start_time);
>=20
> 	return 0;
> err_free2:
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6b..26c8fa93b5 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1691,6 +1691,9 @@ static void cache_set_free(struct closure *cl)
> 		kobject_put(&ca->kobj);
> 	}
>=20
> +	time_stats_exit(&c->btree_gc_time);
> +	time_stats_exit(&c->btree_split_time);
> +	time_stats_exit(&c->sort.time);
>=20
> 	if (c->moving_gc_wq)
> 		destroy_workqueue(c->moving_gc_wq);
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index c6f6770592..01eec5877c 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -16,6 +16,7 @@
> #include <linux/blkdev.h>
> #include <linux/sort.h>
> #include <linux/sched/clock.h>
> +#include <linux/seq_buf.h>
>=20
> extern bool bcache_is_reboot;
>=20
> @@ -79,10 +80,10 @@ read_attribute(active_journal_entries);
> read_attribute(backing_dev_name);
> read_attribute(backing_dev_uuid);
>=20
> -sysfs_time_stats_attribute(btree_gc,	sec, ms);
> -sysfs_time_stats_attribute(btree_split, sec, us);
> -sysfs_time_stats_attribute(btree_sort,	ms,  us);
> -sysfs_time_stats_attribute(btree_read,	ms,  us);
> +read_attribute(btree_gc_time);
> +read_attribute(btree_split_time);
> +read_attribute(btree_sort_time);
> +read_attribute(btree_read_time);
>=20
> read_attribute(btree_nodes);
> read_attribute(btree_used_percent);
> @@ -731,6 +732,9 @@ static unsigned int bch_average_key_size(struct =
cache_set *c)
> SHOW(__bch_cache_set)
> {
> 	struct cache_set *c =3D container_of(kobj, struct cache_set, =
kobj);
> +	struct seq_buf s;
> +
> +	seq_buf_init(&s, buf, PAGE_SIZE);
>=20
> 	sysfs_print(synchronous,		=
CACHE_SYNC(&c->cache->sb));
> 	sysfs_print(journal_delay_ms,		c->journal_delay_ms);
> @@ -743,10 +747,25 @@ SHOW(__bch_cache_set)
> 	sysfs_print(btree_cache_max_chain,	bch_cache_max_chain(c));
> 	sysfs_print(cache_available_percent,	100 - =
c->gc_stats.in_use);
>=20
> -	sysfs_print_time_stats(&c->btree_gc_time,	btree_gc, sec, =
ms);
> -	sysfs_print_time_stats(&c->btree_split_time,	btree_split, =
sec, us);
> -	sysfs_print_time_stats(&c->sort.time,		btree_sort, ms, =
us);
> -	sysfs_print_time_stats(&c->btree_read_time,	btree_read, ms, =
us);
> +	if (attr =3D=3D &sysfs_btree_gc_time) {
> +		time_stats_to_text(&s, &c->btree_gc_time);
> +		return s.len;
> +	}
> +
> +	if (attr =3D=3D &sysfs_btree_split_time) {
> +		time_stats_to_text(&s, &c->btree_split_time);
> +		return s.len;
> +	}
> +
> +	if (attr =3D=3D &sysfs_btree_sort_time) {
> +		time_stats_to_text(&s, &c->sort.time);
> +		return s.len;
> +	}
> +
> +	if (attr =3D=3D &sysfs_btree_read_time) {
> +		time_stats_to_text(&s, &c->btree_read_time);
> +		return s.len;
> +	}
>=20
> 	sysfs_print(btree_used_percent,	bch_btree_used(c));
> 	sysfs_print(btree_nodes,	c->gc_stats.nodes);
> @@ -988,10 +1007,10 @@ KTYPE(bch_cache_set);
> static struct attribute *bch_cache_set_internal_attrs[] =3D {
> 	&sysfs_active_journal_entries,
>=20
> -	sysfs_time_stats_attribute_list(btree_gc, sec, ms)
> -	sysfs_time_stats_attribute_list(btree_split, sec, us)
> -	sysfs_time_stats_attribute_list(btree_sort, ms, us)
> -	sysfs_time_stats_attribute_list(btree_read, ms, us)
> +	&sysfs_btree_gc_time,
> +	&sysfs_btree_split_time,
> +	&sysfs_btree_sort_time,
> +	&sysfs_btree_read_time,
>=20
> 	&sysfs_btree_nodes,
> 	&sysfs_btree_used_percent,
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index ae380bc399..95282bf0f9 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -160,36 +160,6 @@ int bch_parse_uuid(const char *s, char *uuid)
> 	return i;
> }
>=20
> -void bch_time_stats_update(struct time_stats *stats, uint64_t =
start_time)
> -{
> -	uint64_t now, duration, last;
> -
> -	spin_lock(&stats->lock);
> -
> -	now		=3D local_clock();
> -	duration	=3D time_after64(now, start_time)
> -		? now - start_time : 0;
> -	last		=3D time_after64(now, stats->last)
> -		? now - stats->last : 0;
> -
> -	stats->max_duration =3D max(stats->max_duration, duration);
> -
> -	if (stats->last) {
> -		ewma_add(stats->average_duration, duration, 8, 8);
> -
> -		if (stats->average_frequency)
> -			ewma_add(stats->average_frequency, last, 8, 8);
> -		else
> -			stats->average_frequency  =3D last << 8;
> -	} else {
> -		stats->average_duration  =3D duration << 8;
> -	}
> -
> -	stats->last =3D now ?: 1;
> -
> -	spin_unlock(&stats->lock);
> -}
> -
> /**
>  * bch_next_delay() - update ratelimiting statistics and calculate =
next delay
>  * @d: the struct bch_ratelimit to update
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index 6f3cb7c921..1e1bdbae95 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -345,68 +345,11 @@ ssize_t bch_hprint(char *buf, int64_t v);
> bool bch_is_zero(const char *p, size_t n);
> int bch_parse_uuid(const char *s, char *uuid);
>=20
> -struct time_stats {
> -	spinlock_t	lock;
> -	/*
> -	 * all fields are in nanoseconds, averages are ewmas stored left =
shifted
> -	 * by 8
> -	 */
> -	uint64_t	max_duration;
> -	uint64_t	average_duration;
> -	uint64_t	average_frequency;
> -	uint64_t	last;
> -};
> -
> -void bch_time_stats_update(struct time_stats *stats, uint64_t time);
> -
> static inline unsigned int local_clock_us(void)
> {
> 	return local_clock() >> 10;
> }
>=20
> -#define NSEC_PER_ns			1L
> -#define NSEC_PER_us			NSEC_PER_USEC
> -#define NSEC_PER_ms			NSEC_PER_MSEC
> -#define NSEC_PER_sec			NSEC_PER_SEC
> -
> -#define __print_time_stat(stats, name, stat, units)			=
\
> -	sysfs_print(name ## _ ## stat ## _ ## units,			=
\
> -		    div_u64((stats)->stat >> 8, NSEC_PER_ ## units))
> -
> -#define sysfs_print_time_stats(stats, name,				=
\
> -			       frequency_units,				=
\
> -			       duration_units)				=
\
> -do {									=
\
> -	__print_time_stat(stats, name,					=
\
> -			  average_frequency,	frequency_units);	=
\
> -	__print_time_stat(stats, name,					=
\
> -			  average_duration,	duration_units);	=
\
> -	sysfs_print(name ## _ ##max_duration ## _ ## duration_units,	=
\
> -			div_u64((stats)->max_duration,			=
\
> -				NSEC_PER_ ## duration_units));		=
\
> -									=
\
> -	sysfs_print(name ## _last_ ## frequency_units, (stats)->last	=
\
> -		    ? div_s64(local_clock() - (stats)->last,		=
\
> -			      NSEC_PER_ ## frequency_units)		=
\
> -		    : -1LL);						=
\
> -} while (0)
> -
> -#define sysfs_time_stats_attribute(name,				=
\
> -				   frequency_units,			=
\
> -				   duration_units)			=
\
> -read_attribute(name ## _average_frequency_ ## frequency_units);		=
\
> -read_attribute(name ## _average_duration_ ## duration_units);		=
\
> -read_attribute(name ## _max_duration_ ## duration_units);		=
\
> -read_attribute(name ## _last_ ## frequency_units)
> -
> -#define sysfs_time_stats_attribute_list(name,				=
\
> -					frequency_units,		=
\
> -					duration_units)			=
\
> -&sysfs_ ## name ## _average_frequency_ ## frequency_units,		=
\
> -&sysfs_ ## name ## _average_duration_ ## duration_units,		=
\
> -&sysfs_ ## name ## _max_duration_ ## duration_units,			=
\
> -&sysfs_ ## name ## _last_ ## frequency_units,
> -
> #define ewma_add(ewma, val, weight, factor)				=
\
> ({									=
\
> 	(ewma) *=3D (weight) - 1;						=
\
> --=20
> 2.36.1
>=20

