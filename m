Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6076445FA
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Dec 2022 15:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiLFOqv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Dec 2022 09:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiLFOqu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Dec 2022 09:46:50 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFD323145;
        Tue,  6 Dec 2022 06:46:48 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E59CA21C3F;
        Tue,  6 Dec 2022 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1670338006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S9+5+MFTL1hE4tvRJbwZqwZV4rnHWBQklSIcJ6iyEV8=;
        b=kGS3M0AMslHWLbIkbWyu9WBfVCWPW8w/pHuMo7w5t3CDbHdDB57tTa7axm4e+p2gFBEIIB
        VOC4XudtCfXoI2FAktRPH6xUJaOpf/NKkx6mUjULZ2TEnF1qZz5PSHf7yre5Ki1YrJxtAf
        hn9D/c9q6NvWhHTOjhkc+sUDKJwypRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1670338006;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S9+5+MFTL1hE4tvRJbwZqwZV4rnHWBQklSIcJ6iyEV8=;
        b=L6oaqjm0A0v8syC+HkCteINqBFFTfizuxll6/1TVsAQkg0oeYkf5R0Rg9X4fCX55CvwlIC
        5L1Uqd8KHXDbjnBA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 9AA95132F3;
        Tue,  6 Dec 2022 14:46:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id FRuBGNRVj2MKLwAAGKfGzw
        (envelope-from <colyli@suse.de>); Tue, 06 Dec 2022 14:46:44 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] block: remove bio_set_op_attrs
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221206144057.720846-1-hch@lst.de>
Date:   Tue, 6 Dec 2022 22:46:31 +0800
Cc:     Jens Axboe <axboe@kernel.dk>, snitzer@kernel.org,
        Song Liu <song@kernel.org>, linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <434E4CE3-EA46-4CD9-9EAF-5C1B99B8A603@suse.de>
References: <20221206144057.720846-1-hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B412=E6=9C=886=E6=97=A5 22:40=EF=BC=8CChristoph Hellwig =
<hch@lst.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> This macro is obsolete, so replace the last few uses with open coded
> bi_opf assignments.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Coly Li <colyli@suse.de <mailto:colyli@suse.de>>


BTW, may I ask why bio_set_op_attrs() is removed. Quite long time ago it =
was added to avoid open code, and now we remove it to use open coded =
assignments. What is the motivation for now?

Thanks.

Coly Li


> ---
> drivers/md/bcache/movinggc.c  |  2 +-
> drivers/md/bcache/request.c   |  2 +-
> drivers/md/bcache/writeback.c |  4 ++--
> drivers/md/dm-thin.c          |  2 +-
> drivers/md/raid1.c            | 12 ++++++------
> drivers/md/raid10.c           | 18 +++++++++---------
> include/linux/blk_types.h     |  7 -------
> 7 files changed, 20 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/md/bcache/movinggc.c =
b/drivers/md/bcache/movinggc.c
> index 99499d1f6e6666..9f32901fdad102 100644
> --- a/drivers/md/bcache/movinggc.c
> +++ b/drivers/md/bcache/movinggc.c
> @@ -160,7 +160,7 @@ static void read_moving(struct cache_set *c)
> moving_init(io);
> bio =3D &io->bio.bio;
>=20
> - bio_set_op_attrs(bio, REQ_OP_READ, 0);
> + bio->bi_opf =3D REQ_OP_READ;
> bio->bi_end_io =3D read_moving_endio;
>=20
> if (bch_bio_alloc_pages(bio, GFP_KERNEL))
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 3427555b0ccae4..39c7b607f8aad8 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -244,7 +244,7 @@ static void bch_data_insert_start(struct closure =
*cl)
> trace_bcache_cache_insert(k);
> bch_keylist_push(&op->insert_keys);
>=20
> - bio_set_op_attrs(n, REQ_OP_WRITE, 0);
> + n->bi_opf =3D REQ_OP_WRITE;
> bch_submit_bbio(n, op->c, k, 0);
> } while (n !=3D bio);
>=20
> diff --git a/drivers/md/bcache/writeback.c =
b/drivers/md/bcache/writeback.c
> index 0285b676e9834a..d4a5fc0650bb29 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -434,7 +434,7 @@ static void write_dirty(struct closure *cl)
> */
> if (KEY_DIRTY(&w->key)) {
> dirty_init(w);
> - bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
> + io->bio.bi_opf =3D REQ_OP_WRITE;
> io->bio.bi_iter.bi_sector =3D KEY_START(&w->key);
> bio_set_dev(&io->bio, io->dc->bdev);
> io->bio.bi_end_io =3D dirty_endio;
> @@ -547,7 +547,7 @@ static void read_dirty(struct cached_dev *dc)
> io->sequence    =3D sequence++;
>=20
> dirty_init(w);
> - bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
> + io->bio.bi_opf =3D REQ_OP_READ;
> io->bio.bi_iter.bi_sector =3D PTR_OFFSET(&w->key, 0);
> bio_set_dev(&io->bio, dc->disk.c->cache->bdev);
> io->bio.bi_end_io =3D read_dirty_endio;
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index e76c96c760a9b5..c2b5a537f5b8ad 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -410,7 +410,7 @@ static void end_discard(struct discard_op *op, int =
r)
> * need to wait for the chain to complete.
> */
> bio_chain(op->bio, op->parent_bio);
> - bio_set_op_attrs(op->bio, REQ_OP_DISCARD, 0);
> + op->bio->bi_opf =3D REQ_OP_DISCARD;
> submit_bio(op->bio);
> }
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 58f705f4294801..68a9e2d9985b2f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1321,7 +1321,7 @@ static void raid1_read_request(struct mddev =
*mddev, struct bio *bio,
> read_bio->bi_iter.bi_sector =3D r1_bio->sector +
> mirror->rdev->data_offset;
> read_bio->bi_end_io =3D raid1_end_read_request;
> - bio_set_op_attrs(read_bio, op, do_sync);
> + read_bio->bi_opf =3D op | do_sync;
> if (test_bit(FailFast, &mirror->rdev->flags) &&
>    test_bit(R1BIO_FailFast, &r1_bio->state))
>        read_bio->bi_opf |=3D MD_FAILFAST;
> @@ -2254,7 +2254,7 @@ static void sync_request_write(struct mddev =
*mddev, struct r1bio *r1_bio)
> continue;
> }
>=20
> - bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
> + wbio->bi_opf =3D REQ_OP_WRITE;
> if (test_bit(FailFast, &conf->mirrors[i].rdev->flags))
> wbio->bi_opf |=3D MD_FAILFAST;
>=20
> @@ -2419,7 +2419,7 @@ static int narrow_write_error(struct r1bio =
*r1_bio, int i)
>       GFP_NOIO, &mddev->bio_set);
> }
>=20
> - bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
> + wbio->bi_opf =3D REQ_OP_WRITE;
> wbio->bi_iter.bi_sector =3D r1_bio->sector;
> wbio->bi_iter.bi_size =3D r1_bio->sectors << 9;
>=20
> @@ -2770,7 +2770,7 @@ static sector_t raid1_sync_request(struct mddev =
*mddev, sector_t sector_nr,
> if (i < conf->raid_disks)
> still_degraded =3D 1;
> } else if (!test_bit(In_sync, &rdev->flags)) {
> - bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> + bio->bi_opf =3D REQ_OP_WRITE;
> bio->bi_end_io =3D end_sync_write;
> write_targets ++;
> } else {
> @@ -2797,7 +2797,7 @@ static sector_t raid1_sync_request(struct mddev =
*mddev, sector_t sector_nr,
> if (disk < 0)
> disk =3D i;
> }
> - bio_set_op_attrs(bio, REQ_OP_READ, 0);
> + bio->bi_opf =3D REQ_OP_READ;
> bio->bi_end_io =3D end_sync_read;
> read_targets++;
> } else if (!test_bit(WriteErrorSeen, &rdev->flags) &&
> @@ -2809,7 +2809,7 @@ static sector_t raid1_sync_request(struct mddev =
*mddev, sector_t sector_nr,
> * if we are doing resync or repair. Otherwise, leave
> * this device alone for this sync request.
> */
> - bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> + bio->bi_opf =3D REQ_OP_WRITE;
> bio->bi_end_io =3D end_sync_write;
> write_targets++;
> }
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9a6503f5cb982e..6c66357f92f559 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1254,7 +1254,7 @@ static void raid10_read_request(struct mddev =
*mddev, struct bio *bio,
> read_bio->bi_iter.bi_sector =3D r10_bio->devs[slot].addr +
> choose_data_offset(r10_bio, rdev);
> read_bio->bi_end_io =3D raid10_end_read_request;
> - bio_set_op_attrs(read_bio, op, do_sync);
> + read_bio->bi_opf =3D op | do_sync;
> if (test_bit(FailFast, &rdev->flags) &&
>    test_bit(R10BIO_FailFast, &r10_bio->state))
>        read_bio->bi_opf |=3D MD_FAILFAST;
> @@ -1301,7 +1301,7 @@ static void raid10_write_one_disk(struct mddev =
*mddev, struct r10bio *r10_bio,
> mbio->bi_iter.bi_sector =3D (r10_bio->devs[n_copy].addr +
>   choose_data_offset(r10_bio, rdev));
> mbio->bi_end_io =3D raid10_end_write_request;
> - bio_set_op_attrs(mbio, op, do_sync | do_fua);
> + mbio->bi_opf =3D op | do_sync | do_fua;
> if (!replacement && test_bit(FailFast,
>     &conf->mirrors[devnum].rdev->flags)
> && enough(conf, devnum))
> @@ -2933,7 +2933,7 @@ static int narrow_write_error(struct r10bio =
*r10_bio, int i)
> wsector =3D r10_bio->devs[i].addr + (sector - r10_bio->sector);
> wbio->bi_iter.bi_sector =3D wsector +
>   choose_data_offset(r10_bio, rdev);
> - bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
> + wbio->bi_opf =3D REQ_OP_WRITE;
>=20
> if (submit_bio_wait(wbio) < 0)
> /* Failure! */
> @@ -3542,7 +3542,7 @@ static sector_t raid10_sync_request(struct mddev =
*mddev, sector_t sector_nr,
> bio->bi_next =3D biolist;
> biolist =3D bio;
> bio->bi_end_io =3D end_sync_read;
> - bio_set_op_attrs(bio, REQ_OP_READ, 0);
> + bio->bi_opf =3D REQ_OP_READ;
> if (test_bit(FailFast, &rdev->flags))
> bio->bi_opf |=3D MD_FAILFAST;
> from_addr =3D r10_bio->devs[j].addr;
> @@ -3567,7 +3567,7 @@ static sector_t raid10_sync_request(struct mddev =
*mddev, sector_t sector_nr,
> bio->bi_next =3D biolist;
> biolist =3D bio;
> bio->bi_end_io =3D end_sync_write;
> - bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> + bio->bi_opf =3D REQ_OP_WRITE;
> bio->bi_iter.bi_sector =3D to_addr
> + mrdev->data_offset;
> bio_set_dev(bio, mrdev->bdev);
> @@ -3588,7 +3588,7 @@ static sector_t raid10_sync_request(struct mddev =
*mddev, sector_t sector_nr,
> bio->bi_next =3D biolist;
> biolist =3D bio;
> bio->bi_end_io =3D end_sync_write;
> - bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> + bio->bi_opf =3D REQ_OP_WRITE;
> bio->bi_iter.bi_sector =3D to_addr +
> mreplace->data_offset;
> bio_set_dev(bio, mreplace->bdev);
> @@ -3742,7 +3742,7 @@ static sector_t raid10_sync_request(struct mddev =
*mddev, sector_t sector_nr,
> bio->bi_next =3D biolist;
> biolist =3D bio;
> bio->bi_end_io =3D end_sync_read;
> - bio_set_op_attrs(bio, REQ_OP_READ, 0);
> + bio->bi_opf =3D REQ_OP_READ;
> if (test_bit(FailFast, &rdev->flags))
> bio->bi_opf |=3D MD_FAILFAST;
> bio->bi_iter.bi_sector =3D sector + rdev->data_offset;
> @@ -3764,7 +3764,7 @@ static sector_t raid10_sync_request(struct mddev =
*mddev, sector_t sector_nr,
> bio->bi_next =3D biolist;
> biolist =3D bio;
> bio->bi_end_io =3D end_sync_write;
> - bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> + bio->bi_opf =3D REQ_OP_WRITE;
> if (test_bit(FailFast, &rdev->flags))
> bio->bi_opf |=3D MD_FAILFAST;
> bio->bi_iter.bi_sector =3D sector + rdev->data_offset;
> @@ -4970,7 +4970,7 @@ static sector_t reshape_request(struct mddev =
*mddev, sector_t sector_nr,
> b->bi_iter.bi_sector =3D r10_bio->devs[s/2].addr +
> rdev2->new_data_offset;
> b->bi_end_io =3D end_reshape_write;
> - bio_set_op_attrs(b, REQ_OP_WRITE, 0);
> + b->bi_opf =3D REQ_OP_WRITE;
> b->bi_next =3D blist;
> blist =3D b;
> }
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index e0b098089ef2b7..99be590f952f6e 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -472,13 +472,6 @@ static inline enum req_op bio_op(const struct bio =
*bio)
> return bio->bi_opf & REQ_OP_MASK;
> }
>=20
> -/* obsolete, don't use in new code */
> -static inline void bio_set_op_attrs(struct bio *bio, enum req_op op,
> -    blk_opf_t op_flags)
> -{
> - bio->bi_opf =3D op | op_flags;
> -}
> -
> static inline bool op_is_write(blk_opf_t op)
> {
> return !!(op & (__force blk_opf_t)1);
> --=20
> 2.35.1
>=20

