Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E8D214DCB
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Jul 2020 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgGEP43 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jul 2020 11:56:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:38136 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727848AbgGEP43 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 11:56:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EBC9FAC37;
        Sun,  5 Jul 2020 15:56:27 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH 08/16] bcache: struct cache_sb is only for in-memory super block now
Date:   Sun,  5 Jul 2020 23:55:53 +0800
Message-Id: <20200705155601.5404-9-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705155601.5404-1-colyli@suse.de>
References: <20200705155601.5404-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We have struct cache_sb_disk for on-disk super block already, it is
unnecessary to keep the in-memory super block format exactly mapping
to the on-disk struct layout.

This patch adds code comments to notice that struct cache_sb is not
exactly mapping to cache_sb_disk anymore, and removes the useless member
csum and pad[5].

Although struct cache_sb does not belong to uapi anymore, but there are
still some on-disk format related macros reference it and it is
unncessary to get rid of such dependency now. So struct cache_sb will
continue to stay in include/uapi/linux/bache.h for now.

Signed-off-by: Coly Li <colyli@suse.de>
---
 include/uapi/linux/bcache.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index 561032a070f2..046fa29533a8 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -216,8 +216,13 @@ struct cache_sb_disk {
 /*8d0*/
 };
 
+/*
+ * This is for in-memory bcache super block.
+ * NOTE: cache_sb is NOT exactly mapping to cache_sb_disk anymore,
+ *       the member size, ordering and even whole struct size may be
+ *       different from cache_sb_disk now.
+ */
 struct cache_sb {
-	__u64			csum;
 	__u64			offset;	/* sector where this sb was written */
 	__u64			version;
 
@@ -237,8 +242,6 @@ struct cache_sb {
 	__le64			feature_incompat;
 	__le64			feature_ro_compat;
 
-	__u64			pad[5];
-
 	union {
 	struct {
 		/* Cache devices */
@@ -246,7 +249,6 @@ struct cache_sb {
 
 		__u16		block_size;	/* sectors */
 		__u16		bucket_size;	/* sectors */
-
 		__u16		nr_in_set;
 		__u16		nr_this_dev;
 	};
-- 
2.26.2

