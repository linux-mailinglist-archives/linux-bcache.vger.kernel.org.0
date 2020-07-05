Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AD6214DE6
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Jul 2020 18:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgGEQEx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jul 2020 12:04:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:39516 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbgGEQEx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 12:04:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 40E62ACFE;
        Sun,  5 Jul 2020 16:04:51 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH 2/4] struct_offset: print offset of each member of the on-disk data structure
Date:   Mon,  6 Jul 2020 00:04:38 +0800
Message-Id: <20200705160440.5801-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705160440.5801-1-colyli@suse.de>
References: <20200705160440.5801-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a helper small program to print out the offset in bytes of each
member of the on-disk data structure. Currently the member print lines
are coded manually, hope latter it can be more intelligent to avoid the
hard code.

Signed-off-by: Coly Li <colyli@suse.de>
---
 Makefile        |  4 +++-
 struct_offset.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 struct_offset.c

diff --git a/Makefile b/Makefile
index 2c326cf..b352d21 100644
--- a/Makefile
+++ b/Makefile
@@ -5,7 +5,7 @@ DRACUTLIBDIR=/lib/dracut
 INSTALL=install
 CFLAGS+=-O2 -Wall -g
 
-all: make-bcache probe-bcache bcache-super-show bcache-register bcache
+all: make-bcache probe-bcache bcache-super-show bcache-register bcache struct_offset
 
 install: make-bcache probe-bcache bcache-super-show
 	$(INSTALL) -m0755 make-bcache bcache-super-show	bcache $(DESTDIR)${PREFIX}/sbin/
@@ -22,6 +22,8 @@ clean:
 
 bcache-test: LDLIBS += `pkg-config --libs openssl` -lm
 
+struct_offset: struct_offset.o
+
 make-bcache: LDLIBS += `pkg-config --libs uuid blkid smartcols`
 make-bcache: CFLAGS += `pkg-config --cflags uuid blkid smartcols`
 make-bcache: make.o crc64.o lib.o zoned.o
diff --git a/struct_offset.c b/struct_offset.c
new file mode 100644
index 0000000..6061259
--- /dev/null
+++ b/struct_offset.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Author: Coly Li <colyli@suse.de>
+ *
+ * Print out offset of each member of on-disk structure
+ */
+
+#include <stdio.h>
+#include <stddef.h>
+#include <inttypes.h>
+#include <stdbool.h>
+
+#include "bcache.h"
+
+
+#define OFF_SB(m)	offsetof(struct cache_sb, m)
+
+void print_cache_sb()
+{
+	printf("	  struct cache_sb {:\n");
+	printf("/* %3.3lx */         uint64_t		csum;\n", OFF_SB(csum));
+	printf("/* %3.3lx */         uint64_t		offset;\n", OFF_SB(offset));
+	printf("/* %3.3lx */         uint64_t		version;\n", OFF_SB(version));
+	printf("/* %3.3lx */         uint8_t		magic[6];\n", OFF_SB(magic));
+	printf("/* %3.3lx */         uint8_t		uuid[16];\n", OFF_SB(uuid));
+	printf("                  union {;\n");
+	printf("/* %3.3lx */         	uint8_t		set_uuid;\n", OFF_SB(set_uuid));
+	printf("/* %3.3lx */         	uint64_t	set_magic;\n", OFF_SB(set_magic));
+	printf("		  };\n");
+	printf("/* %3.3lx */         uint8_t		label[%u];\n", OFF_SB(label),
+							SB_LABEL_SIZE);
+	printf("/* %3.3lx */         uint64_t		flags;\n", OFF_SB(flags));
+	printf("/* %3.3lx */         uint64_t		seq;\n", OFF_SB(seq));
+	printf("/* %3.3lx */         uint64_t		pad[8];\n", OFF_SB(pad));
+	printf("                  union {\n");
+	printf("                  struct {\n");
+	printf("/* %3.3lx */         	uint64_t	nbuckets;\n", OFF_SB(nbuckets));
+	printf("/* %3.3lx */         	uint16_t	block_size;\n", OFF_SB(block_size));
+	printf("/* %3.3lx */         	uint16_t	bucket_size;\n", OFF_SB(bucket_size));
+	printf("/* %3.3lx */         	uint16_t	nr_in_set;\n", OFF_SB(nr_in_set));
+	printf("/* %3.3lx */         	uint16_t	nr_this_dev;\n", OFF_SB(nr_this_dev));
+	printf("                  };\n");
+	printf("                  struct {\n");
+	printf("/* %3.3lx */          	uint64_t	data_offset;\n", OFF_SB(data_offset));
+	printf("                  };\n");
+	printf("                  };\n");
+	printf("/* %3.3lx */         uint32_t		last_mount;\n", OFF_SB(last_mount));
+	printf("/* %3.3lx */         uint16_t		first_bucket;\n", OFF_SB(first_bucket));
+	printf("                  union {\n");
+	printf("/* %3.3lx */         	uint16_t	njournal_buckets;\n", OFF_SB(njournal_buckets));
+	printf("/* %3.3lx */         	uint16_t	keys;\n", OFF_SB(keys));
+	printf("                  };\n");
+	printf("/* %3.3lx */         uint64_t		d[%u];\n", OFF_SB(d), SB_JOURNAL_BUCKETS);
+	printf("/* %3.3lx */ }\n", OFF_SB(d) + sizeof(uint64_t) * SB_JOURNAL_BUCKETS);
+}
+
+int main(int argc, char *argv[])
+{
+	print_cache_sb();
+	return 0;
+}
-- 
2.26.2

