Return-Path: <linux-bcache+bounces-90-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 095817FCEE6
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Nov 2023 07:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BB2D28300A
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Nov 2023 06:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE77D514;
	Wed, 29 Nov 2023 06:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dOJ01/mn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NhIyLSqJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CC091;
	Tue, 28 Nov 2023 22:13:31 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3BD422199D;
	Wed, 29 Nov 2023 06:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1701238410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4Zpx07hDUcD4NgakkCOTXPuax7ULKLgP3vQfNDy2UM=;
	b=dOJ01/mnfsbi5S2Wk29cKCSwucpx8f6HajSbLH9MbntESW0lYc5nmbc0Uhnph65++aKEO7
	oyEbGyZG2mnG3XDaOcEuih/Ec1FK9nLnRMmB6NvEnhWfI95UryLwHQkbFqxZqOJ3OlM4/d
	96M54IT8jgUfR5y76o1K1EF3O4rA/SI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1701238410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4Zpx07hDUcD4NgakkCOTXPuax7ULKLgP3vQfNDy2UM=;
	b=NhIyLSqJ5LR0SxIASTp94sl/mdEHuT+wSjhWTc7pVTgXqR9j5CFfDHMEtZI+ENJ004Ka81
	2HBTpObdjCz97YDA==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A9DC1377E;
	Wed, 29 Nov 2023 06:13:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id X5qLOofWZmVIGwAAn2gu4w
	(envelope-from <colyli@suse.de>); Wed, 29 Nov 2023 06:13:27 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: [PATCH] closures: CLOSURE_CALLBACK() to fix type punning
From: Coly Li <colyli@suse.de>
In-Reply-To: <20231120030729.3285278-1-kent.overstreet@linux.dev>
Date: Wed, 29 Nov 2023 14:13:14 +0800
Cc: linux-bcachefs@vger.kernel.org,
 linux-bcache@vger.kernel.org,
 Kees Cook <keescook@chromium.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E15D58DE-3286-4FF8-8799-2DCDB89DEBA3@suse.de>
References: <20231120030729.3285278-1-kent.overstreet@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3774.200.91.1.1)
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spamd-Result: default: False [-0.88 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 MV_CASE(0.50)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_SPAM_SHORT(2.72)[0.908];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -0.88



> 2023=E5=B9=B411=E6=9C=8820=E6=97=A5 11:07=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Control flow integrity is now checking that type signatures match on
> indirect function calls. That breaks closures, which embed a =
work_struct
> in a closure in such a way that a closure_fn may also be used as a
> workqueue fn by the underlying closure code.
>=20
> So we have to change closure fns to take a work_struct as their
> argument - but that results in a loss of clarity, as closure fns have
> different semantics from normal workqueue functions (they run owning a
> ref on the closure, which must be released with continue_at() or
> closure_return()).
>=20
> Thus, this patc introduces CLOSURE_CALLBACK() and closure_type() =
macros
> as suggested by Kees, to smooth things over a bit.
>=20
> Suggested-by: Kees Cook <keescook@chromium.org>
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Acked-by: Coly Li <colyli@suse.de>

Thanks.


Coly Li


> ---
> drivers/md/bcache/btree.c           | 14 +++---
> drivers/md/bcache/journal.c         | 20 ++++----
> drivers/md/bcache/movinggc.c        | 16 +++----
> drivers/md/bcache/request.c         | 74 ++++++++++++++---------------
> drivers/md/bcache/request.h         |  2 +-
> drivers/md/bcache/super.c           | 40 ++++++++--------
> drivers/md/bcache/writeback.c       | 16 +++----
> fs/bcachefs/btree_io.c              |  7 ++-
> fs/bcachefs/btree_update_interior.c |  4 +-
> fs/bcachefs/fs-io-direct.c          |  8 ++--
> fs/bcachefs/io_write.c              | 14 +++---
> fs/bcachefs/io_write.h              |  3 +-
> fs/bcachefs/journal_io.c            | 17 ++++---
> fs/bcachefs/journal_io.h            |  2 +-
> include/linux/closure.h             |  9 +++-
> lib/closure.c                       |  5 +-
> 16 files changed, 127 insertions(+), 124 deletions(-)
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index fd121a61f17c..e7ccf731f08b 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -293,16 +293,16 @@ static void btree_complete_write(struct btree =
*b, struct btree_write *w)
> w->journal =3D NULL;
> }
>=20
> -static void btree_node_write_unlock(struct closure *cl)
> +static CLOSURE_CALLBACK(btree_node_write_unlock)
> {
> - struct btree *b =3D container_of(cl, struct btree, io);
> + closure_type(b, struct btree, io);
>=20
> up(&b->io_mutex);
> }
>=20
> -static void __btree_node_write_done(struct closure *cl)
> +static CLOSURE_CALLBACK(__btree_node_write_done)
> {
> - struct btree *b =3D container_of(cl, struct btree, io);
> + closure_type(b, struct btree, io);
> struct btree_write *w =3D btree_prev_write(b);
>=20
> bch_bbio_free(b->bio, b->c);
> @@ -315,12 +315,12 @@ static void __btree_node_write_done(struct =
closure *cl)
> closure_return_with_destructor(cl, btree_node_write_unlock);
> }
>=20
> -static void btree_node_write_done(struct closure *cl)
> +static CLOSURE_CALLBACK(btree_node_write_done)
> {
> - struct btree *b =3D container_of(cl, struct btree, io);
> + closure_type(b, struct btree, io);
>=20
> bio_free_pages(b->bio);
> - __btree_node_write_done(cl);
> + __btree_node_write_done(&cl->work);
> }
>=20
> static void btree_node_write_endio(struct bio *bio)
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index c182c21de2e8..7ff14bd2feb8 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -723,11 +723,11 @@ static void journal_write_endio(struct bio *bio)
> closure_put(&w->c->journal.io);
> }
>=20
> -static void journal_write(struct closure *cl);
> +static CLOSURE_CALLBACK(journal_write);
>=20
> -static void journal_write_done(struct closure *cl)
> +static CLOSURE_CALLBACK(journal_write_done)
> {
> - struct journal *j =3D container_of(cl, struct journal, io);
> + closure_type(j, struct journal, io);
> struct journal_write *w =3D (j->cur =3D=3D j->w)
> ? &j->w[1]
> : &j->w[0];
> @@ -736,19 +736,19 @@ static void journal_write_done(struct closure =
*cl)
> continue_at_nobarrier(cl, journal_write, bch_journal_wq);
> }
>=20
> -static void journal_write_unlock(struct closure *cl)
> +static CLOSURE_CALLBACK(journal_write_unlock)
> __releases(&c->journal.lock)
> {
> - struct cache_set *c =3D container_of(cl, struct cache_set, =
journal.io);
> + closure_type(c, struct cache_set, journal.io);
>=20
> c->journal.io_in_flight =3D 0;
> spin_unlock(&c->journal.lock);
> }
>=20
> -static void journal_write_unlocked(struct closure *cl)
> +static CLOSURE_CALLBACK(journal_write_unlocked)
> __releases(c->journal.lock)
> {
> - struct cache_set *c =3D container_of(cl, struct cache_set, =
journal.io);
> + closure_type(c, struct cache_set, journal.io);
> struct cache *ca =3D c->cache;
> struct journal_write *w =3D c->journal.cur;
> struct bkey *k =3D &c->journal.key;
> @@ -823,12 +823,12 @@ static void journal_write_unlocked(struct =
closure *cl)
> continue_at(cl, journal_write_done, NULL);
> }
>=20
> -static void journal_write(struct closure *cl)
> +static CLOSURE_CALLBACK(journal_write)
> {
> - struct cache_set *c =3D container_of(cl, struct cache_set, =
journal.io);
> + closure_type(c, struct cache_set, journal.io);
>=20
> spin_lock(&c->journal.lock);
> - journal_write_unlocked(cl);
> + journal_write_unlocked(&cl->work);
> }
>=20
> static void journal_try_write(struct cache_set *c)
> diff --git a/drivers/md/bcache/movinggc.c =
b/drivers/md/bcache/movinggc.c
> index 9f32901fdad1..ebd500bdf0b2 100644
> --- a/drivers/md/bcache/movinggc.c
> +++ b/drivers/md/bcache/movinggc.c
> @@ -35,16 +35,16 @@ static bool moving_pred(struct keybuf *buf, struct =
bkey *k)
>=20
> /* Moving GC - IO loop */
>=20
> -static void moving_io_destructor(struct closure *cl)
> +static CLOSURE_CALLBACK(moving_io_destructor)
> {
> - struct moving_io *io =3D container_of(cl, struct moving_io, cl);
> + closure_type(io, struct moving_io, cl);
>=20
> kfree(io);
> }
>=20
> -static void write_moving_finish(struct closure *cl)
> +static CLOSURE_CALLBACK(write_moving_finish)
> {
> - struct moving_io *io =3D container_of(cl, struct moving_io, cl);
> + closure_type(io, struct moving_io, cl);
> struct bio *bio =3D &io->bio.bio;
>=20
> bio_free_pages(bio);
> @@ -89,9 +89,9 @@ static void moving_init(struct moving_io *io)
> bch_bio_map(bio, NULL);
> }
>=20
> -static void write_moving(struct closure *cl)
> +static CLOSURE_CALLBACK(write_moving)
> {
> - struct moving_io *io =3D container_of(cl, struct moving_io, cl);
> + closure_type(io, struct moving_io, cl);
> struct data_insert_op *op =3D &io->op;
>=20
> if (!op->status) {
> @@ -113,9 +113,9 @@ static void write_moving(struct closure *cl)
> continue_at(cl, write_moving_finish, op->wq);
> }
>=20
> -static void read_moving_submit(struct closure *cl)
> +static CLOSURE_CALLBACK(read_moving_submit)
> {
> - struct moving_io *io =3D container_of(cl, struct moving_io, cl);
> + closure_type(io, struct moving_io, cl);
> struct bio *bio =3D &io->bio.bio;
>=20
> bch_submit_bbio(bio, io->op.c, &io->w->key, 0);
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index a9b1f3896249..83d112bd2b1c 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -25,7 +25,7 @@
>=20
> struct kmem_cache *bch_search_cache;
>=20
> -static void bch_data_insert_start(struct closure *cl);
> +static CLOSURE_CALLBACK(bch_data_insert_start);
>=20
> static unsigned int cache_mode(struct cached_dev *dc)
> {
> @@ -55,9 +55,9 @@ static void bio_csum(struct bio *bio, struct bkey =
*k)
>=20
> /* Insert data into cache */
>=20
> -static void bch_data_insert_keys(struct closure *cl)
> +static CLOSURE_CALLBACK(bch_data_insert_keys)
> {
> - struct data_insert_op *op =3D container_of(cl, struct =
data_insert_op, cl);
> + closure_type(op, struct data_insert_op, cl);
> atomic_t *journal_ref =3D NULL;
> struct bkey *replace_key =3D op->replace ? &op->replace_key : NULL;
> int ret;
> @@ -136,9 +136,9 @@ static void bch_data_invalidate(struct closure =
*cl)
> continue_at(cl, bch_data_insert_keys, op->wq);
> }
>=20
> -static void bch_data_insert_error(struct closure *cl)
> +static CLOSURE_CALLBACK(bch_data_insert_error)
> {
> - struct data_insert_op *op =3D container_of(cl, struct =
data_insert_op, cl);
> + closure_type(op, struct data_insert_op, cl);
>=20
> /*
> * Our data write just errored, which means we've got a bunch of keys =
to
> @@ -163,7 +163,7 @@ static void bch_data_insert_error(struct closure =
*cl)
>=20
> op->insert_keys.top =3D dst;
>=20
> - bch_data_insert_keys(cl);
> + bch_data_insert_keys(&cl->work);
> }
>=20
> static void bch_data_insert_endio(struct bio *bio)
> @@ -184,9 +184,9 @@ static void bch_data_insert_endio(struct bio *bio)
> bch_bbio_endio(op->c, bio, bio->bi_status, "writing data to cache");
> }
>=20
> -static void bch_data_insert_start(struct closure *cl)
> +static CLOSURE_CALLBACK(bch_data_insert_start)
> {
> - struct data_insert_op *op =3D container_of(cl, struct =
data_insert_op, cl);
> + closure_type(op, struct data_insert_op, cl);
> struct bio *bio =3D op->bio, *n;
>=20
> if (op->bypass)
> @@ -305,16 +305,16 @@ static void bch_data_insert_start(struct closure =
*cl)
>  * If op->bypass is true, instead of inserting the data it invalidates =
the
>  * region of the cache represented by op->bio and op->inode.
>  */
> -void bch_data_insert(struct closure *cl)
> +CLOSURE_CALLBACK(bch_data_insert)
> {
> - struct data_insert_op *op =3D container_of(cl, struct =
data_insert_op, cl);
> + closure_type(op, struct data_insert_op, cl);
>=20
> trace_bcache_write(op->c, op->inode, op->bio,
>   op->writeback, op->bypass);
>=20
> bch_keylist_init(&op->insert_keys);
> bio_get(op->bio);
> - bch_data_insert_start(cl);
> + bch_data_insert_start(&cl->work);
> }
>=20
> /*
> @@ -575,9 +575,9 @@ static int cache_lookup_fn(struct btree_op *op, =
struct btree *b, struct bkey *k)
> return n =3D=3D bio ? MAP_DONE : MAP_CONTINUE;
> }
>=20
> -static void cache_lookup(struct closure *cl)
> +static CLOSURE_CALLBACK(cache_lookup)
> {
> - struct search *s =3D container_of(cl, struct search, iop.cl);
> + closure_type(s, struct search, iop.cl);
> struct bio *bio =3D &s->bio.bio;
> struct cached_dev *dc;
> int ret;
> @@ -698,9 +698,9 @@ static void do_bio_hook(struct search *s,
> bio_cnt_set(bio, 3);
> }
>=20
> -static void search_free(struct closure *cl)
> +static CLOSURE_CALLBACK(search_free)
> {
> - struct search *s =3D container_of(cl, struct search, cl);
> + closure_type(s, struct search, cl);
>=20
> atomic_dec(&s->iop.c->search_inflight);
>=20
> @@ -749,20 +749,20 @@ static inline struct search *search_alloc(struct =
bio *bio,
>=20
> /* Cached devices */
>=20
> -static void cached_dev_bio_complete(struct closure *cl)
> +static CLOSURE_CALLBACK(cached_dev_bio_complete)
> {
> - struct search *s =3D container_of(cl, struct search, cl);
> + closure_type(s, struct search, cl);
> struct cached_dev *dc =3D container_of(s->d, struct cached_dev, disk);
>=20
> cached_dev_put(dc);
> - search_free(cl);
> + search_free(&cl->work);
> }
>=20
> /* Process reads */
>=20
> -static void cached_dev_read_error_done(struct closure *cl)
> +static CLOSURE_CALLBACK(cached_dev_read_error_done)
> {
> - struct search *s =3D container_of(cl, struct search, cl);
> + closure_type(s, struct search, cl);
>=20
> if (s->iop.replace_collision)
> bch_mark_cache_miss_collision(s->iop.c, s->d);
> @@ -770,12 +770,12 @@ static void cached_dev_read_error_done(struct =
closure *cl)
> if (s->iop.bio)
> bio_free_pages(s->iop.bio);
>=20
> - cached_dev_bio_complete(cl);
> + cached_dev_bio_complete(&cl->work);
> }
>=20
> -static void cached_dev_read_error(struct closure *cl)
> +static CLOSURE_CALLBACK(cached_dev_read_error)
> {
> - struct search *s =3D container_of(cl, struct search, cl);
> + closure_type(s, struct search, cl);
> struct bio *bio =3D &s->bio.bio;
>=20
> /*
> @@ -801,9 +801,9 @@ static void cached_dev_read_error(struct closure =
*cl)
> continue_at(cl, cached_dev_read_error_done, NULL);
> }
>=20
> -static void cached_dev_cache_miss_done(struct closure *cl)
> +static CLOSURE_CALLBACK(cached_dev_cache_miss_done)
> {
> - struct search *s =3D container_of(cl, struct search, cl);
> + closure_type(s, struct search, cl);
> struct bcache_device *d =3D s->d;
>=20
> if (s->iop.replace_collision)
> @@ -812,13 +812,13 @@ static void cached_dev_cache_miss_done(struct =
closure *cl)
> if (s->iop.bio)
> bio_free_pages(s->iop.bio);
>=20
> - cached_dev_bio_complete(cl);
> + cached_dev_bio_complete(&cl->work);
> closure_put(&d->cl);
> }
>=20
> -static void cached_dev_read_done(struct closure *cl)
> +static CLOSURE_CALLBACK(cached_dev_read_done)
> {
> - struct search *s =3D container_of(cl, struct search, cl);
> + closure_type(s, struct search, cl);
> struct cached_dev *dc =3D container_of(s->d, struct cached_dev, disk);
>=20
> /*
> @@ -858,9 +858,9 @@ static void cached_dev_read_done(struct closure =
*cl)
> continue_at(cl, cached_dev_cache_miss_done, NULL);
> }
>=20
> -static void cached_dev_read_done_bh(struct closure *cl)
> +static CLOSURE_CALLBACK(cached_dev_read_done_bh)
> {
> - struct search *s =3D container_of(cl, struct search, cl);
> + closure_type(s, struct search, cl);
> struct cached_dev *dc =3D container_of(s->d, struct cached_dev, disk);
>=20
> bch_mark_cache_accounting(s->iop.c, s->d,
> @@ -955,13 +955,13 @@ static void cached_dev_read(struct cached_dev =
*dc, struct search *s)
>=20
> /* Process writes */
>=20
> -static void cached_dev_write_complete(struct closure *cl)
> +static CLOSURE_CALLBACK(cached_dev_write_complete)
> {
> - struct search *s =3D container_of(cl, struct search, cl);
> + closure_type(s, struct search, cl);
> struct cached_dev *dc =3D container_of(s->d, struct cached_dev, disk);
>=20
> up_read_non_owner(&dc->writeback_lock);
> - cached_dev_bio_complete(cl);
> + cached_dev_bio_complete(&cl->work);
> }
>=20
> static void cached_dev_write(struct cached_dev *dc, struct search *s)
> @@ -1048,9 +1048,9 @@ static void cached_dev_write(struct cached_dev =
*dc, struct search *s)
> continue_at(cl, cached_dev_write_complete, NULL);
> }
>=20
> -static void cached_dev_nodata(struct closure *cl)
> +static CLOSURE_CALLBACK(cached_dev_nodata)
> {
> - struct search *s =3D container_of(cl, struct search, cl);
> + closure_type(s, struct search, cl);
> struct bio *bio =3D &s->bio.bio;
>=20
> if (s->iop.flush_journal)
> @@ -1265,9 +1265,9 @@ static int flash_dev_cache_miss(struct btree *b, =
struct search *s,
> return MAP_CONTINUE;
> }
>=20
> -static void flash_dev_nodata(struct closure *cl)
> +static CLOSURE_CALLBACK(flash_dev_nodata)
> {
> - struct search *s =3D container_of(cl, struct search, cl);
> + closure_type(s, struct search, cl);
>=20
> if (s->iop.flush_journal)
> bch_journal_meta(s->iop.c, cl);
> diff --git a/drivers/md/bcache/request.h b/drivers/md/bcache/request.h
> index 38ab4856eaab..46bbef00aebb 100644
> --- a/drivers/md/bcache/request.h
> +++ b/drivers/md/bcache/request.h
> @@ -34,7 +34,7 @@ struct data_insert_op {
> };
>=20
> unsigned int bch_get_congested(const struct cache_set *c);
> -void bch_data_insert(struct closure *cl);
> +CLOSURE_CALLBACK(bch_data_insert);
>=20
> void bch_cached_dev_request_init(struct cached_dev *dc);
> void cached_dev_submit_bio(struct bio *bio);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 8bd899766372..e0db905c1ca0 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -327,9 +327,9 @@ static void __write_super(struct cache_sb *sb, =
struct cache_sb_disk *out,
> submit_bio(bio);
> }
>=20
> -static void bch_write_bdev_super_unlock(struct closure *cl)
> +static CLOSURE_CALLBACK(bch_write_bdev_super_unlock)
> {
> - struct cached_dev *dc =3D container_of(cl, struct cached_dev, =
sb_write);
> + closure_type(dc, struct cached_dev, sb_write);
>=20
> up(&dc->sb_write_mutex);
> }
> @@ -363,9 +363,9 @@ static void write_super_endio(struct bio *bio)
> closure_put(&ca->set->sb_write);
> }
>=20
> -static void bcache_write_super_unlock(struct closure *cl)
> +static CLOSURE_CALLBACK(bcache_write_super_unlock)
> {
> - struct cache_set *c =3D container_of(cl, struct cache_set, =
sb_write);
> + closure_type(c, struct cache_set, sb_write);
>=20
> up(&c->sb_write_mutex);
> }
> @@ -407,9 +407,9 @@ static void uuid_endio(struct bio *bio)
> closure_put(cl);
> }
>=20
> -static void uuid_io_unlock(struct closure *cl)
> +static CLOSURE_CALLBACK(uuid_io_unlock)
> {
> - struct cache_set *c =3D container_of(cl, struct cache_set, =
uuid_write);
> + closure_type(c, struct cache_set, uuid_write);
>=20
> up(&c->uuid_write_mutex);
> }
> @@ -1342,9 +1342,9 @@ void bch_cached_dev_release(struct kobject =
*kobj)
> module_put(THIS_MODULE);
> }
>=20
> -static void cached_dev_free(struct closure *cl)
> +static CLOSURE_CALLBACK(cached_dev_free)
> {
> - struct cached_dev *dc =3D container_of(cl, struct cached_dev, =
disk.cl);
> + closure_type(dc, struct cached_dev, disk.cl);
>=20
> if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
> cancel_writeback_rate_update_dwork(dc);
> @@ -1376,9 +1376,9 @@ static void cached_dev_free(struct closure *cl)
> kobject_put(&dc->disk.kobj);
> }
>=20
> -static void cached_dev_flush(struct closure *cl)
> +static CLOSURE_CALLBACK(cached_dev_flush)
> {
> - struct cached_dev *dc =3D container_of(cl, struct cached_dev, =
disk.cl);
> + closure_type(dc, struct cached_dev, disk.cl);
> struct bcache_device *d =3D &dc->disk;
>=20
> mutex_lock(&bch_register_lock);
> @@ -1497,9 +1497,9 @@ void bch_flash_dev_release(struct kobject *kobj)
> kfree(d);
> }
>=20
> -static void flash_dev_free(struct closure *cl)
> +static CLOSURE_CALLBACK(flash_dev_free)
> {
> - struct bcache_device *d =3D container_of(cl, struct bcache_device, =
cl);
> + closure_type(d, struct bcache_device, cl);
>=20
> mutex_lock(&bch_register_lock);
> atomic_long_sub(bcache_dev_sectors_dirty(d),
> @@ -1510,9 +1510,9 @@ static void flash_dev_free(struct closure *cl)
> kobject_put(&d->kobj);
> }
>=20
> -static void flash_dev_flush(struct closure *cl)
> +static CLOSURE_CALLBACK(flash_dev_flush)
> {
> - struct bcache_device *d =3D container_of(cl, struct bcache_device, =
cl);
> + closure_type(d, struct bcache_device, cl);
>=20
> mutex_lock(&bch_register_lock);
> bcache_device_unlink(d);
> @@ -1668,9 +1668,9 @@ void bch_cache_set_release(struct kobject *kobj)
> module_put(THIS_MODULE);
> }
>=20
> -static void cache_set_free(struct closure *cl)
> +static CLOSURE_CALLBACK(cache_set_free)
> {
> - struct cache_set *c =3D container_of(cl, struct cache_set, cl);
> + closure_type(c, struct cache_set, cl);
> struct cache *ca;
>=20
> debugfs_remove(c->debug);
> @@ -1709,9 +1709,9 @@ static void cache_set_free(struct closure *cl)
> kobject_put(&c->kobj);
> }
>=20
> -static void cache_set_flush(struct closure *cl)
> +static CLOSURE_CALLBACK(cache_set_flush)
> {
> - struct cache_set *c =3D container_of(cl, struct cache_set, caching);
> + closure_type(c, struct cache_set, caching);
> struct cache *ca =3D c->cache;
> struct btree *b;
>=20
> @@ -1806,9 +1806,9 @@ static void =
conditional_stop_bcache_device(struct cache_set *c,
> }
> }
>=20
> -static void __cache_set_unregister(struct closure *cl)
> +static CLOSURE_CALLBACK(__cache_set_unregister)
> {
> - struct cache_set *c =3D container_of(cl, struct cache_set, caching);
> + closure_type(c, struct cache_set, caching);
> struct cached_dev *dc;
> struct bcache_device *d;
> size_t i;
> diff --git a/drivers/md/bcache/writeback.c =
b/drivers/md/bcache/writeback.c
> index 24c049067f61..77427e355613 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -341,16 +341,16 @@ static void dirty_init(struct keybuf_key *w)
> bch_bio_map(bio, NULL);
> }
>=20
> -static void dirty_io_destructor(struct closure *cl)
> +static CLOSURE_CALLBACK(dirty_io_destructor)
> {
> - struct dirty_io *io =3D container_of(cl, struct dirty_io, cl);
> + closure_type(io, struct dirty_io, cl);
>=20
> kfree(io);
> }
>=20
> -static void write_dirty_finish(struct closure *cl)
> +static CLOSURE_CALLBACK(write_dirty_finish)
> {
> - struct dirty_io *io =3D container_of(cl, struct dirty_io, cl);
> + closure_type(io, struct dirty_io, cl);
> struct keybuf_key *w =3D io->bio.bi_private;
> struct cached_dev *dc =3D io->dc;
>=20
> @@ -400,9 +400,9 @@ static void dirty_endio(struct bio *bio)
> closure_put(&io->cl);
> }
>=20
> -static void write_dirty(struct closure *cl)
> +static CLOSURE_CALLBACK(write_dirty)
> {
> - struct dirty_io *io =3D container_of(cl, struct dirty_io, cl);
> + closure_type(io, struct dirty_io, cl);
> struct keybuf_key *w =3D io->bio.bi_private;
> struct cached_dev *dc =3D io->dc;
>=20
> @@ -462,9 +462,9 @@ static void read_dirty_endio(struct bio *bio)
> dirty_endio(bio);
> }
>=20
> -static void read_dirty_submit(struct closure *cl)
> +static CLOSURE_CALLBACK(read_dirty_submit)
> {
> - struct dirty_io *io =3D container_of(cl, struct dirty_io, cl);
> + closure_type(io, struct dirty_io, cl);
>=20
> closure_bio_submit(io->dc->disk.c, &io->bio, cl);
>=20
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index 1f73ee0ee359..3c663c596b46 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -1358,10 +1358,9 @@ static bool btree_node_has_extra_bsets(struct =
bch_fs *c, unsigned offset, void *
> return offset;
> }
>=20
> -static void btree_node_read_all_replicas_done(struct closure *cl)
> +static CLOSURE_CALLBACK(btree_node_read_all_replicas_done)
> {
> - struct btree_node_read_all *ra =3D
> - container_of(cl, struct btree_node_read_all, cl);
> + closure_type(ra, struct btree_node_read_all, cl);
> struct bch_fs *c =3D ra->c;
> struct btree *b =3D ra->b;
> struct printbuf buf =3D PRINTBUF;
> @@ -1567,7 +1566,7 @@ static int btree_node_read_all_replicas(struct =
bch_fs *c, struct btree *b, bool
>=20
> if (sync) {
> closure_sync(&ra->cl);
> - btree_node_read_all_replicas_done(&ra->cl);
> + btree_node_read_all_replicas_done(&ra->cl.work);
> } else {
> continue_at(&ra->cl, btree_node_read_all_replicas_done,
>    c->io_complete_wq);
> diff --git a/fs/bcachefs/btree_update_interior.c =
b/fs/bcachefs/btree_update_interior.c
> index 18e5a75142e9..bfe4d7975bd8 100644
> --- a/fs/bcachefs/btree_update_interior.c
> +++ b/fs/bcachefs/btree_update_interior.c
> @@ -774,9 +774,9 @@ static void btree_interior_update_work(struct =
work_struct *work)
> }
> }
>=20
> -static void btree_update_set_nodes_written(struct closure *cl)
> +static CLOSURE_CALLBACK(btree_update_set_nodes_written)
> {
> - struct btree_update *as =3D container_of(cl, struct btree_update, =
cl);
> + closure_type(as, struct btree_update, cl);
> struct bch_fs *c =3D as->c;
>=20
> mutex_lock(&c->btree_interior_update_lock);
> diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
> index 5b42a76c4796..9a479e4de6b3 100644
> --- a/fs/bcachefs/fs-io-direct.c
> +++ b/fs/bcachefs/fs-io-direct.c
> @@ -35,9 +35,9 @@ static void bio_check_or_release(struct bio *bio, =
bool check_dirty)
> }
> }
>=20
> -static void bch2_dio_read_complete(struct closure *cl)
> +static CLOSURE_CALLBACK(bch2_dio_read_complete)
> {
> - struct dio_read *dio =3D container_of(cl, struct dio_read, cl);
> + closure_type(dio, struct dio_read, cl);
>=20
> dio->req->ki_complete(dio->req, dio->ret);
> bio_check_or_release(&dio->rbio.bio, dio->should_dirty);
> @@ -325,9 +325,9 @@ static noinline int bch2_dio_write_copy_iov(struct =
dio_write *dio)
> return 0;
> }
>=20
> -static void bch2_dio_write_flush_done(struct closure *cl)
> +static CLOSURE_CALLBACK(bch2_dio_write_flush_done)
> {
> - struct dio_write *dio =3D container_of(cl, struct dio_write, op.cl);
> + closure_type(dio, struct dio_write, op.cl);
> struct bch_fs *c =3D dio->op.c;
>=20
> closure_debug_destroy(cl);
> diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
> index 75376f040e4b..d6bd8f788d3a 100644
> --- a/fs/bcachefs/io_write.c
> +++ b/fs/bcachefs/io_write.c
> @@ -580,9 +580,9 @@ static inline void wp_update_state(struct =
write_point *wp, bool running)
> __wp_update_state(wp, state);
> }
>=20
> -static void bch2_write_index(struct closure *cl)
> +static CLOSURE_CALLBACK(bch2_write_index)
> {
> - struct bch_write_op *op =3D container_of(cl, struct bch_write_op, =
cl);
> + closure_type(op, struct bch_write_op, cl);
> struct write_point *wp =3D op->wp;
> struct workqueue_struct *wq =3D index_update_wq(op);
> unsigned long flags;
> @@ -1208,9 +1208,9 @@ static void __bch2_nocow_write_done(struct =
bch_write_op *op)
> bch2_nocow_write_convert_unwritten(op);
> }
>=20
> -static void bch2_nocow_write_done(struct closure *cl)
> +static CLOSURE_CALLBACK(bch2_nocow_write_done)
> {
> - struct bch_write_op *op =3D container_of(cl, struct bch_write_op, =
cl);
> + closure_type(op, struct bch_write_op, cl);
>=20
> __bch2_nocow_write_done(op);
> bch2_write_done(cl);
> @@ -1363,7 +1363,7 @@ static void bch2_nocow_write(struct bch_write_op =
*op)
> op->insert_keys.top =3D op->insert_keys.keys;
> } else if (op->flags & BCH_WRITE_SYNC) {
> closure_sync(&op->cl);
> - bch2_nocow_write_done(&op->cl);
> + bch2_nocow_write_done(&op->cl.work);
> } else {
> /*
> * XXX
> @@ -1566,9 +1566,9 @@ static void bch2_write_data_inline(struct =
bch_write_op *op, unsigned data_len)
>  * If op->discard is true, instead of inserting the data it =
invalidates the
>  * region of the cache represented by op->bio and op->inode.
>  */
> -void bch2_write(struct closure *cl)
> +CLOSURE_CALLBACK(bch2_write)
> {
> - struct bch_write_op *op =3D container_of(cl, struct bch_write_op, =
cl);
> + closure_type(op, struct bch_write_op, cl);
> struct bio *bio =3D &op->wbio.bio;
> struct bch_fs *c =3D op->c;
> unsigned data_len;
> diff --git a/fs/bcachefs/io_write.h b/fs/bcachefs/io_write.h
> index 9323167229ee..6c276a48f95d 100644
> --- a/fs/bcachefs/io_write.h
> +++ b/fs/bcachefs/io_write.h
> @@ -90,8 +90,7 @@ static inline void bch2_write_op_init(struct =
bch_write_op *op, struct bch_fs *c,
> op->devs_need_flush =3D NULL;
> }
>=20
> -void bch2_write(struct closure *);
> -
> +CLOSURE_CALLBACK(bch2_write);
> void bch2_write_point_do_index_updates(struct work_struct *);
>=20
> static inline struct bch_write_bio *wbio_init(struct bio *bio)
> diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
> index 09fcea643a6a..6553a2cab1d4 100644
> --- a/fs/bcachefs/journal_io.c
> +++ b/fs/bcachefs/journal_io.c
> @@ -1042,10 +1042,9 @@ static int journal_read_bucket(struct bch_dev =
*ca,
> return 0;
> }
>=20
> -static void bch2_journal_read_device(struct closure *cl)
> +static CLOSURE_CALLBACK(bch2_journal_read_device)
> {
> - struct journal_device *ja =3D
> - container_of(cl, struct journal_device, read);
> + closure_type(ja, struct journal_device, read);
> struct bch_dev *ca =3D container_of(ja, struct bch_dev, journal);
> struct bch_fs *c =3D ca->fs;
> struct journal_list *jlist =3D
> @@ -1544,9 +1543,9 @@ static inline struct journal_buf =
*journal_last_unwritten_buf(struct journal *j)
> return j->buf + (journal_last_unwritten_seq(j) & JOURNAL_BUF_MASK);
> }
>=20
> -static void journal_write_done(struct closure *cl)
> +static CLOSURE_CALLBACK(journal_write_done)
> {
> - struct journal *j =3D container_of(cl, struct journal, io);
> + closure_type(j, struct journal, io);
> struct bch_fs *c =3D container_of(j, struct bch_fs, journal);
> struct journal_buf *w =3D journal_last_unwritten_buf(j);
> struct bch_replicas_padded replicas;
> @@ -1666,9 +1665,9 @@ static void journal_write_endio(struct bio *bio)
> percpu_ref_put(&ca->io_ref);
> }
>=20
> -static void do_journal_write(struct closure *cl)
> +static CLOSURE_CALLBACK(do_journal_write)
> {
> - struct journal *j =3D container_of(cl, struct journal, io);
> + closure_type(j, struct journal, io);
> struct bch_fs *c =3D container_of(j, struct bch_fs, journal);
> struct bch_dev *ca;
> struct journal_buf *w =3D journal_last_unwritten_buf(j);
> @@ -1902,9 +1901,9 @@ static int bch2_journal_write_pick_flush(struct =
journal *j, struct journal_buf *
> return 0;
> }
>=20
> -void bch2_journal_write(struct closure *cl)
> +CLOSURE_CALLBACK(bch2_journal_write)
> {
> - struct journal *j =3D container_of(cl, struct journal, io);
> + closure_type(j, struct journal, io);
> struct bch_fs *c =3D container_of(j, struct bch_fs, journal);
> struct bch_dev *ca;
> struct journal_buf *w =3D journal_last_unwritten_buf(j);
> diff --git a/fs/bcachefs/journal_io.h b/fs/bcachefs/journal_io.h
> index a88d097b13f1..c035e7c108e1 100644
> --- a/fs/bcachefs/journal_io.h
> +++ b/fs/bcachefs/journal_io.h
> @@ -60,6 +60,6 @@ void bch2_journal_ptrs_to_text(struct printbuf *, =
struct bch_fs *,
>=20
> int bch2_journal_read(struct bch_fs *, u64 *, u64 *, u64 *);
>=20
> -void bch2_journal_write(struct closure *);
> +CLOSURE_CALLBACK(bch2_journal_write);
>=20
> #endif /* _BCACHEFS_JOURNAL_IO_H */
> diff --git a/include/linux/closure.h b/include/linux/closure.h
> index de7bb47d8a46..c554c6a08768 100644
> --- a/include/linux/closure.h
> +++ b/include/linux/closure.h
> @@ -104,7 +104,7 @@
>=20
> struct closure;
> struct closure_syncer;
> -typedef void (closure_fn) (struct closure *);
> +typedef void (closure_fn) (struct work_struct *);
> extern struct dentry *bcache_debug;
>=20
> struct closure_waitlist {
> @@ -254,7 +254,7 @@ static inline void closure_queue(struct closure =
*cl)
> INIT_WORK(&cl->work, cl->work.func);
> BUG_ON(!queue_work(wq, &cl->work));
> } else
> - cl->fn(cl);
> + cl->fn(&cl->work);
> }
>=20
> /**
> @@ -309,6 +309,11 @@ static inline void closure_wake_up(struct =
closure_waitlist *list)
> __closure_wake_up(list);
> }
>=20
> +#define CLOSURE_CALLBACK(name) void name(struct work_struct *ws)
> +#define closure_type(name, type, member) \
> + struct closure *cl =3D container_of(ws, struct closure, work); \
> + type *name =3D container_of(cl, type, member)
> +
> /**
>  * continue_at - jump to another function with barrier
>  *
> diff --git a/lib/closure.c b/lib/closure.c
> index f86c9eeafb35..c16540552d61 100644
> --- a/lib/closure.c
> +++ b/lib/closure.c
> @@ -36,7 +36,7 @@ static inline void closure_put_after_sub(struct =
closure *cl, int flags)
> closure_debug_destroy(cl);
>=20
> if (destructor)
> - destructor(cl);
> + destructor(&cl->work);
>=20
> if (parent)
> closure_put(parent);
> @@ -108,8 +108,9 @@ struct closure_syncer {
> int done;
> };
>=20
> -static void closure_sync_fn(struct closure *cl)
> +static CLOSURE_CALLBACK(closure_sync_fn)
> {
> + struct closure *cl =3D container_of(ws, struct closure, work);
> struct closure_syncer *s =3D cl->s;
> struct task_struct *p;
>=20
> --=20
> 2.42.0
>=20
>=20


