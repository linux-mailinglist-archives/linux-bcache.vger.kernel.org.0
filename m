Return-Path: <linux-bcache+bounces-848-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E384CA41A38
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Feb 2025 11:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C85B03B9895
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Feb 2025 10:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2832C255E41;
	Mon, 24 Feb 2025 10:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VqD2Dozx"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F36253B64;
	Mon, 24 Feb 2025 10:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740391290; cv=none; b=urz0i0vAJuIvYVRWhNfErBtNqrIaZ3VsLutQ6TJCdYB+BHvxoNRuohoUzqzHb6PXn2XOBmDJgASmpOt6plrflaGm1WV4fAU3Kh5nvKIylACjCTpWOaTAZJgEBjZdctcrUlNvVmDsa79D+3wKbEMAAO7KwRkyuZG8Qcniur4hNvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740391290; c=relaxed/simple;
	bh=Enp3Zb8nzXxEkwvMAjUB6rg1iQahYbSwBGgW+v2Giuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/XZMK1D0GCvIMki3/dqftvbtcZYxYPvHauci2tMqTwV+NeNd1bn+kB+VA3eE8cy7nfpa5QCdzX/2OaXwQIbNGl1paXQF+bcX7i1elwDx34gt2csvSjg/zIpzsuuE/rFl4axWqu31L3BuWYkPt5uxwGenltQIxFCvFa+V7pwJBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VqD2Dozx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C2AC4CEE6;
	Mon, 24 Feb 2025 10:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740391289;
	bh=Enp3Zb8nzXxEkwvMAjUB6rg1iQahYbSwBGgW+v2Giuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VqD2DozxGOkrHVQIsobsGCZ2nE6oH/nofMiU9yF8e/R+bboQE5R4zG3QPdTpZJ77i
	 l8DmXlsNEJUFZl9DOR43gsjJM/mrB7Uz5HUUY76bRPXNU5w3R3bg5dvmtun3UZf9JH
	 toesJTUvnYW3mYt58Ecwo+e7hZpuE3aPYQK4IY6l7rL7l6tcq+wPJBRQvH8TZXTqhP
	 mgh44a15AR8lugpYTekF+UUAWrPzxKjFGXN/yuofnbG4oG+YAmLU+wWC7ysFsSD/gP
	 6ApKOJkIoYbEgFYnWfDSXPQ21I8r8YjPeCKng5//dR9N+TPugTdtYHw7eJDJrxvWkk
	 Wtkm3rlFubUzw==
Date: Mon, 24 Feb 2025 20:31:26 +1030
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH 8/8][next] bcache: Avoid -Wflex-array-member-not-at-end
 warnings
Message-ID: <f9f20ad9362972ef920dd9aecd7b98ab345ee866.1739957534.git.gustavoars@kernel.org>
References: <cover.1739957534.git.gustavoars@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1739957534.git.gustavoars@kernel.org>

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Change the type of the middle struct members currently causing trouble
from `struct bio` to `struct bio_hdr`.

We also use `container_of()` whenever we need to retrieve a pointer to
the flexible structure `struct bio`, through which we can access the
flexible-array member in it, if necessary.

With these changes fix 112 of the following warnings:

drivers/md/bcache/bcache.h:233:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/md/bcache/bcache.h:241:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/md/bcache/bcache.h:242:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/md/bcache/bcache.h:308:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/md/bcache/bcache.h:422:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/md/bcache/bcache.h:639:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/md/bcache/journal.h:152:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/md/bcache/journal.h:156:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/md/bcache/bcache.h  |  4 ++--
 drivers/md/bcache/journal.c | 10 +++++-----
 drivers/md/bcache/journal.h |  4 ++--
 drivers/md/bcache/super.c   |  8 +++++---
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 785b0d9008fa..328023e90eb2 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -305,7 +305,7 @@ struct cached_dev {
 
 	struct cache_sb		sb;
 	struct cache_sb_disk	*sb_disk;
-	struct bio		sb_bio;
+	struct bio_hdr		sb_bio;
 	struct bio_vec		sb_bv[1];
 	struct closure		sb_write;
 	struct semaphore	sb_write_mutex;
@@ -419,7 +419,7 @@ struct cache {
 	struct cache_set	*set;
 	struct cache_sb		sb;
 	struct cache_sb_disk	*sb_disk;
-	struct bio		sb_bio;
+	struct bio_hdr		sb_bio;
 	struct bio_vec		sb_bv[1];
 
 	struct kobject		kobj;
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 7ff14bd2feb8..2ead129f7758 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -36,7 +36,7 @@ static int journal_read_bucket(struct cache *ca, struct list_head *list,
 			       unsigned int bucket_index)
 {
 	struct journal_device *ja = &ca->journal;
-	struct bio *bio = &ja->bio;
+	struct bio *bio = container_of(&ja->bio, struct bio, __hdr);
 
 	struct journal_replay *i;
 	struct jset *j, *data = ca->set->journal.w[0].data;
@@ -571,7 +571,7 @@ static void btree_flush_write(struct cache_set *c)
 static void journal_discard_endio(struct bio *bio)
 {
 	struct journal_device *ja =
-		container_of(bio, struct journal_device, discard_bio);
+		container_of(&bio->__hdr, struct journal_device, discard_bio);
 	struct cache *ca = container_of(ja, struct cache, journal);
 
 	atomic_set(&ja->discard_in_flight, DISCARD_DONE);
@@ -585,13 +585,13 @@ static void journal_discard_work(struct work_struct *work)
 	struct journal_device *ja =
 		container_of(work, struct journal_device, discard_work);
 
-	submit_bio(&ja->discard_bio);
+	submit_bio(container_of(&ja->discard_bio, struct bio, __hdr));
 }
 
 static void do_journal_discard(struct cache *ca)
 {
 	struct journal_device *ja = &ca->journal;
-	struct bio *bio = &ja->discard_bio;
+	struct bio *bio = container_of(&ja->discard_bio, struct bio, __hdr);
 
 	if (!ca->discard) {
 		ja->discard_idx = ja->last_idx;
@@ -787,7 +787,7 @@ static CLOSURE_CALLBACK(journal_write_unlocked)
 
 	for (i = 0; i < KEY_PTRS(k); i++) {
 		ca = c->cache;
-		bio = &ca->journal.bio;
+		bio = container_of(&ca->journal.bio, struct bio, __hdr);
 
 		atomic_long_add(sectors, &ca->meta_sectors_written);
 
diff --git a/drivers/md/bcache/journal.h b/drivers/md/bcache/journal.h
index cd316b4a1e95..b4ff5269aee3 100644
--- a/drivers/md/bcache/journal.h
+++ b/drivers/md/bcache/journal.h
@@ -149,11 +149,11 @@ struct journal_device {
 	atomic_t		discard_in_flight;
 
 	struct work_struct	discard_work;
-	struct bio		discard_bio;
+	struct bio_hdr		discard_bio;
 	struct bio_vec		discard_bv;
 
 	/* Bio for journal reads/writes to this device */
-	struct bio		bio;
+	struct bio_hdr		bio;
 	struct bio_vec		bv[8];
 };
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e42f1400cea9..cd1342355cf2 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -337,7 +337,7 @@ static CLOSURE_CALLBACK(bch_write_bdev_super_unlock)
 void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent)
 {
 	struct closure *cl = &dc->sb_write;
-	struct bio *bio = &dc->sb_bio;
+	struct bio *bio = container_of(&dc->sb_bio, struct bio, __hdr);
 
 	down(&dc->sb_write_mutex);
 	closure_init(cl, parent);
@@ -374,7 +374,7 @@ void bcache_write_super(struct cache_set *c)
 {
 	struct closure *cl = &c->sb_write;
 	struct cache *ca = c->cache;
-	struct bio *bio = &ca->sb_bio;
+	struct bio *bio = container_of(&ca->sb_bio, struct bio, __hdr);
 	unsigned int version = BCACHE_SB_VERSION_CDEV_WITH_UUID;
 
 	down(&c->sb_write_mutex);
@@ -2230,7 +2230,9 @@ static int cache_alloc(struct cache *ca)
 	__module_get(THIS_MODULE);
 	kobject_init(&ca->kobj, &bch_cache_ktype);
 
-	bio_init(&ca->journal.bio, NULL, ca->journal.bio.bi_inline_vecs, 8, 0);
+	bio_init(container_of(&ca->journal.bio, struct bio, __hdr), NULL,
+		 container_of(&ca->journal.bio, struct bio, __hdr)->bi_inline_vecs,
+		 8, 0);
 
 	/*
 	 * when ca->sb.njournal_buckets is not zero, journal exists,
-- 
2.43.0


