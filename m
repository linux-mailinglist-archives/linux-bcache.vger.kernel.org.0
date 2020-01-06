Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C1A13159F
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jan 2020 17:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgAFQFQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jan 2020 11:05:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:42662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgAFQFQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jan 2020 11:05:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AB4F9AD6F
        for <linux-bcache@vger.kernel.org>; Mon,  6 Jan 2020 16:05:14 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [RFC PATCH 4/7] bcache: add __bch_mca_scan() with parameter "bool reap_flush"
Date:   Tue,  7 Jan 2020 00:04:53 +0800
Message-Id: <20200106160456.45689-5-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200106160456.45689-1-colyli@suse.de>
References: <20200106160456.45689-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch renames original bch_mca_scan() to __bch_mca_scan() and add
the third parameter "bool reap_flush". The parameter reap_flush is used
when calling mca_reap() inside __bch_mca_scan() to indicate weather
mca_reap() should flush or skip dirty btree node cache.

bch_mca_scan() still exists but it changes to a wrapper of,
	{return __bch_mca_scan(shrink, sc, false);}

bch_mca_scan() won't reap dirty btree node cache, by this change, it is
possible to reap and shrink dirty btree node cache when calling
__bch_mca_scan() with reap_flush set to true.

This is necessary for following changes which control memory consumption
of bcache btree node cache by throttling regular I/O requests.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index fa872df4e770..b37405aedf6e 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -699,8 +699,9 @@ static int mca_reap(struct btree *b, unsigned int min_order, bool flush)
 	return -ENOMEM;
 }
 
-static unsigned long bch_mca_scan(struct shrinker *shrink,
-				  struct shrink_control *sc)
+static unsigned long __bch_mca_scan(struct shrinker *shrink,
+				    struct shrink_control *sc,
+				    bool reap_flush)
 {
 	struct cache_set *c = container_of(shrink, struct cache_set, shrink);
 	struct btree *b, *t;
@@ -738,7 +739,7 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 		if (nr <= 0)
 			goto out;
 
-		if (!mca_reap(b, 0, false)) {
+		if (!mca_reap(b, 0, reap_flush)) {
 			mca_data_free(b);
 			rw_unlock(true, b);
 			freed++;
@@ -751,7 +752,7 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 		if (nr <= 0 || i >= btree_cache_used)
 			goto out;
 
-		if (!mca_reap(b, 0, false)) {
+		if (!mca_reap(b, 0, reap_flush)) {
 			mca_bucket_free(b);
 			mca_data_free(b);
 			rw_unlock(true, b);
@@ -766,6 +767,12 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 	return freed * c->btree_pages;
 }
 
+static unsigned long bch_mca_scan(struct shrinker *shrink,
+				  struct shrink_control *sc)
+{
+	return __bch_mca_scan(shrink, sc, false);
+}
+
 static unsigned long bch_mca_count(struct shrinker *shrink,
 				   struct shrink_control *sc)
 {
-- 
2.16.4

