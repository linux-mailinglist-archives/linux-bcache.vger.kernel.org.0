Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24A02465F6
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 14:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHQMGU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 08:06:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:53440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgHQMGU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 08:06:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 684F7AEDA
        for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2020 12:06:43 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 4/8] bcache-tools: add to_cache_sb() and to_cache_sb_disk()
Date:   Mon, 17 Aug 2020 20:05:54 +0800
Message-Id: <20200817120558.4491-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817120558.4491-1-colyli@suse.de>
References: <20200817120558.4491-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch adds routines to_cache_sb() to_cache_sb_disk() to lib.c,
which convert bcache super block between in-memory and on-disk formats.

This is a preparation to separate current struct cache_sb into two
structures,
- struct cache_sb is for in-memory super block
- struct cache_sb_disk is for on-disk super block

Signed-off-by: Coly Li <colyli@suse.de>
---
 lib.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 lib.h |  3 +-
 2 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/lib.c b/lib.c
index 9e69419..542f115 100644
--- a/lib.c
+++ b/lib.c
@@ -8,14 +8,14 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <fcntl.h>
-#include "bcache.h"
-#include "lib.h"
 #include <uuid.h>
 #include <string.h>
 #include <malloc.h>
 #include <regex.h>
 
-
+#include "bcache.h"
+#include "lib.h"
+#include "bitwise.h"
 /*
  * utils function
  */
@@ -681,3 +681,88 @@ int set_label(char *devname, char *label)
 	close(fd);
 	return 0;
 }
+
+
+struct cache_sb *to_cache_sb(struct cache_sb *sb,
+			     struct cache_sb_disk *sb_disk)
+{
+	/* Convert common part */
+	sb->offset = le64_to_cpu(sb_disk->offset);
+	sb->version = le64_to_cpu(sb_disk->version);
+	memcpy(sb->magic, sb_disk->magic, 16);
+	memcpy(sb->uuid, sb_disk->uuid, 16);
+	memcpy(sb->set_uuid, sb_disk->set_uuid, 16);
+	memcpy(sb->label, sb_disk->label, SB_LABEL_SIZE);
+	sb->flags = le64_to_cpu(sb_disk->flags);
+	sb->seq = le64_to_cpu(sb_disk->seq);
+	sb->block_size = le16_to_cpu(sb_disk->block_size);
+	sb->last_mount = le32_to_cpu(sb_disk->last_mount);
+	sb->first_bucket = le16_to_cpu(sb_disk->first_bucket);
+	sb->keys = le16_to_cpu(sb_disk->keys);
+
+	/* For cache or backing devices*/
+
+	if (sb->version > BCACHE_SB_MAX_VERSION) {
+		/* Unsupported version */
+		fprintf(stderr, "Unsupported super block version: %lld\n",
+			sb->version);
+	} else if (SB_IS_BDEV(sb)) {
+		/* Backing device */
+		sb->data_offset = le64_to_cpu(sb_disk->data_offset);
+	} else {
+		int i;
+
+		/* Cache device */
+		sb->nbuckets = le64_to_cpu(sb_disk->nbuckets);
+		sb->nr_in_set = le16_to_cpu(sb_disk->nr_in_set);
+		sb->nr_this_dev = le16_to_cpu(sb_disk->nr_this_dev);
+		sb->bucket_size = le32_to_cpu(sb_disk->bucket_size);
+
+		for (i = 0; i < SB_JOURNAL_BUCKETS; i++)
+			sb->d[i]= le64_to_cpu(sb_disk->d[i]);
+	}
+
+	return sb;
+}
+
+struct cache_sb_disk *to_cache_sb_disk(struct cache_sb_disk *sb_disk,
+				       struct cache_sb *sb)
+{
+	/* Convert common part */
+	sb_disk->offset = cpu_to_le64(sb->offset);
+	sb_disk->version = cpu_to_le64(sb->version);
+	memcpy(sb_disk->magic, sb->magic, 16);
+	memcpy(sb_disk->uuid, sb->uuid, 16);
+	memcpy(sb_disk->set_uuid, sb->set_uuid, 16);
+	memcpy(sb_disk->label, sb->label, SB_LABEL_SIZE);
+	sb_disk->flags = cpu_to_le64(sb->flags);
+	sb_disk->seq = cpu_to_le64(sb->seq);
+	sb_disk->block_size = cpu_to_le16(sb->block_size);
+	sb_disk->last_mount = cpu_to_le32(sb->last_mount);
+	sb_disk->first_bucket = cpu_to_le16(sb->first_bucket);
+	sb_disk->keys = cpu_to_le16(sb->keys);
+
+	/* For cache and backing devices */
+
+	if (sb->version > BCACHE_SB_MAX_VERSION) {
+		/* Unsupported version */
+		fprintf(stderr, "Unsupported super block version: %lld\n",
+			sb->version);
+	} else if (SB_IS_BDEV(sb)) {
+		/* Backing device */
+		sb_disk->data_offset = cpu_to_le64(sb->data_offset);
+	} else {
+		int i;
+
+		/* Cache device */
+		sb_disk->nbuckets = cpu_to_le64(sb->nbuckets);
+		sb_disk->nr_in_set = cpu_to_le16(sb->nr_in_set);
+		sb_disk->nr_this_dev = cpu_to_le16(sb->nr_this_dev);
+		sb_disk->bucket_size = cpu_to_le32(sb->bucket_size);
+
+		for (i = 0; i < SB_JOURNAL_BUCKETS; i++)
+			sb_disk->d[i] = cpu_to_le64(sb->d[i]);
+	}
+
+	return sb_disk;
+}
diff --git a/lib.h b/lib.h
index d4537b0..b37608e 100644
--- a/lib.h
+++ b/lib.h
@@ -50,7 +50,8 @@ int detach_backdev(char *devname);
 int set_backdev_cachemode(char *devname, char *cachemode);
 int set_label(char *devname, char *label);
 int cset_to_devname(struct list_head *head, char *cset, char *devname);
-
+struct cache_sb *to_cache_sb(struct cache_sb *sb, struct cache_sb_disk *sb_disk);
+struct cache_sb_disk *to_cache_sb_disk(struct cache_sb_disk *sb_disk,struct cache_sb *sb);
 
 #define DEVLEN sizeof(struct dev)
 
-- 
2.26.2

