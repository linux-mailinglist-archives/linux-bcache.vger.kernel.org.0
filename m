Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09962E8D1B
	for <lists+linux-bcache@lfdr.de>; Sun,  3 Jan 2021 17:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbhACQZG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 3 Jan 2021 11:25:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:35452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbhACQZG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 3 Jan 2021 11:25:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9C6BFACC6;
        Sun,  3 Jan 2021 16:24:24 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 2/3] bcache-tools: only call to_cache_sb() for bcache device in may_add_item()
Date:   Mon,  4 Jan 2021 00:24:12 +0800
Message-Id: <20210103162413.16895-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103162413.16895-1-colyli@suse.de>
References: <20210103162413.16895-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

to_cache_sb() will print an error message "Unsupported super block
version" if the super block version is invalid. For non-bcache devices,
it is unnecessary to check version number and print bogus error messages.

This patch checks bcache_magic earlier in may_add_item(), and only calls
to_cache_sb() if the magic string matched. Then the non-bcache devices
can be skipped, and no more bogus error message observed.

Signed-off-by: Coly Li <colyli@suse.de>
---
 lib.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/lib.c b/lib.c
index 340ddf3..b8487db 100644
--- a/lib.c
+++ b/lib.c
@@ -343,32 +343,31 @@ int may_add_item(char *devname, struct list_head *head)
 {
 	struct cache_sb_disk sb_disk;
 	struct cache_sb sb;
+	char dev[512];
+	struct dev *tmp;
+	int ret;
 
 	if (strcmp(devname, ".") == 0 || strcmp(devname, "..") == 0)
 		return 0;
-	char dev[261];
 
 	sprintf(dev, "/dev/%s", devname);
 	int fd = open(dev, O_RDONLY);
-
 	if (fd == -1)
 		return 0;
+
 	if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk)) {
 		close(fd);
 		return 0;
 	}
 
-	to_cache_sb(&sb, &sb_disk);
-
-	if (memcmp(sb.magic, bcache_magic, 16)) {
+	if (memcmp(sb_disk.magic, bcache_magic, 16)) {
 		close(fd);
 		return 0;
 	}
-	struct dev *tmp;
-	int ret;
 
-	tmp = (struct dev *) malloc(DEVLEN);
+	to_cache_sb(&sb, &sb_disk);
 
+	tmp = (struct dev *) malloc(DEVLEN);
 	tmp->csum = le64_to_cpu(sb_disk.csum);
 	ret = detail_base(dev, sb, tmp);
 	if (ret != 0) {
-- 
2.26.2

