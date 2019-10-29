Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2DFE81CC
	for <lists+linux-bcache@lfdr.de>; Tue, 29 Oct 2019 08:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfJ2HGg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Oct 2019 03:06:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29354 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbfJ2HGg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Oct 2019 03:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572332795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2lyPsvLW9xcG9wUlUhf3OFgXWxRn2snNCoHVMuXk4Vc=;
        b=cG/jmXKaJ0jiq8TvC6UO0gqym0Qc0OwlcwdmkmxP9+m9oo1zJKuS58MXfqmp8tkayVH256
        TingJKawwsJ5fDs/GptQoDba3CCRQVByRGvHc02+I8SQEDEHlJO4TGvyKUYfS7ootG7izD
        v5f9jQoV+5x9IMvEjV/1cFN9bJo4I1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-F_NDxrMNNKm8SjZ8w5VL3A-1; Tue, 29 Oct 2019 03:06:32 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE3671005500;
        Tue, 29 Oct 2019 07:06:30 +0000 (UTC)
Received: from localhost (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2D455D9C8;
        Tue, 29 Oct 2019 07:06:27 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Subject: [PATCH V2] block: optimize for small BS IO
Date:   Tue, 29 Oct 2019 15:06:21 +0800
Message-Id: <20191029070621.1307-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: F_NDxrMNNKm8SjZ8w5VL3A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

__blk_queue_split() may be a bit heavy for small BS(such as 512B, or
4KB) IO, so introduce one flag to decide if this bio includes multiple
page. And only consider to try splitting this bio in case that
the multiple page flag is set.

~3% - 5% IOPS improvement can be observed on io_uring test over
null_blk(MQ), and the io_uring test code is from fio/t/io_uring.c

bch_bio_map() should be the only one which doesn't use bio_add_page(),
so force to mark bio built via bch_bio_map() as MULTI_PAGE.

RAID5 has similar usage too, however the bio is really single-page bio,
so not necessary to handle it.

Cc: Keith Busch <kbusch@kernel.org>
Cc: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org
Acked-by: Coly Li <colyli@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
=09- share bit flag with passthrough IO
=09- deal with adding multipage in one bio_add_page()


 block/bio.c               | 9 +++++++++
 block/blk-merge.c         | 4 ++++
 block/bounce.c            | 3 +++
 drivers/md/bcache/util.c  | 2 ++
 include/linux/blk_types.h | 3 +++
 5 files changed, 21 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 8f0ed6228fc5..4876a7f464f2 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -583,6 +583,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_=
src)
 =09bio_set_flag(bio, BIO_CLONED);
 =09if (bio_flagged(bio_src, BIO_THROTTLED))
 =09=09bio_set_flag(bio, BIO_THROTTLED);
+=09if (bio_flagged(bio_src, BIO_MULTI_PAGE))
+=09=09bio_set_flag(bio, BIO_MULTI_PAGE);
 =09bio->bi_opf =3D bio_src->bi_opf;
 =09bio->bi_ioprio =3D bio_src->bi_ioprio;
 =09bio->bi_write_hint =3D bio_src->bi_write_hint;
@@ -757,6 +759,9 @@ bool __bio_try_merge_page(struct bio *bio, struct page =
*page,
 =09=09if (page_is_mergeable(bv, page, len, off, same_page)) {
 =09=09=09bv->bv_len +=3D len;
 =09=09=09bio->bi_iter.bi_size +=3D len;
+
+=09=09=09if (!*same_page)
+=09=09=09=09bio_set_flag(bio, BIO_MULTI_PAGE);
 =09=09=09return true;
 =09=09}
 =09}
@@ -789,6 +794,10 @@ void __bio_add_page(struct bio *bio, struct page *page=
,
 =09bio->bi_iter.bi_size +=3D len;
 =09bio->bi_vcnt++;
=20
+=09if (!bio_flagged(bio, BIO_MULTI_PAGE) && (bio->bi_vcnt >=3D 2 ||
+=09=09=09=09(bio->bi_vcnt =3D=3D 1 && len > PAGE_SIZE)))
+=09=09bio_set_flag(bio, BIO_MULTI_PAGE);
+
 =09if (!bio_flagged(bio, BIO_WORKINGSET) && unlikely(PageWorkingset(page))=
)
 =09=09bio_set_flag(bio, BIO_WORKINGSET);
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 48e6725b32ee..737bbec9e153 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -309,6 +309,10 @@ void __blk_queue_split(struct request_queue *q, struct=
 bio **bio,
 =09=09=09=09nr_segs);
 =09=09break;
 =09default:
+=09=09if (!bio_flagged(*bio, BIO_MULTI_PAGE)) {
+=09=09=09*nr_segs =3D 1;
+=09=09=09return;
+=09=09}
 =09=09split =3D blk_bio_segment_split(q, *bio, &q->bio_split, nr_segs);
 =09=09break;
 =09}
diff --git a/block/bounce.c b/block/bounce.c
index f8ed677a1bf7..4b18a2accccc 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -253,6 +253,9 @@ static struct bio *bounce_clone_bio(struct bio *bio_src=
, gfp_t gfp_mask,
 =09bio->bi_iter.bi_sector=09=3D bio_src->bi_iter.bi_sector;
 =09bio->bi_iter.bi_size=09=3D bio_src->bi_iter.bi_size;
=20
+=09if (bio_flagged(bio_src, BIO_MULTI_PAGE))
+=09=09bio_set_flag(bio, BIO_MULTI_PAGE);
+
 =09switch (bio_op(bio)) {
 =09case REQ_OP_DISCARD:
 =09case REQ_OP_SECURE_ERASE:
diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index 62fb917f7a4f..71f5cbb6fdd6 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -253,6 +253,8 @@ start:=09=09bv->bv_len=09=3D min_t(size_t, PAGE_SIZE - =
bv->bv_offset,
=20
 =09=09size -=3D bv->bv_len;
 =09}
+
+=09bio_set_flag(bio, BIO_MULTI_PAGE);
 }
=20
 /**
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d688b96d1d63..10b9a3539716 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -220,6 +220,9 @@ enum {
 =09=09=09=09 * throttling rules. Don't do it again. */
 =09BIO_TRACE_COMPLETION,=09/* bio_endio() should trace the final completio=
n
 =09=09=09=09 * of this bio. */
+=09BIO_MULTI_PAGE =3D BIO_USER_MAPPED,
+=09=09=09=09/* used for optimize small BS IO from FS, so
+=09=09=09=09 * share the bit flag with passthrough IO */
 =09BIO_QUEUE_ENTERED,=09/* can use blk_queue_enter_live() */
 =09BIO_TRACKED,=09=09/* set if bio goes through the rq_qos path */
 =09BIO_FLAG_LAST
--=20
2.20.1

