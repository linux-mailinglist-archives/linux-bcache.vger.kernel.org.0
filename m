Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297E5249B30
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Aug 2020 12:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgHSKwI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 19 Aug 2020 06:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbgHSKvq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Aug 2020 06:51:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEC0C061348
        for <linux-bcache@vger.kernel.org>; Wed, 19 Aug 2020 03:51:34 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 2so927211pjx.5
        for <linux-bcache@vger.kernel.org>; Wed, 19 Aug 2020 03:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:in-reply-to:references:content-transfer-encoding;
        bh=uiH7tlxXBQcdGzP3CpVXTDpR6If738RH8DOIk/plU0o=;
        b=C6e7vvBQ9iKT5vM6nr1FdpCeXQCfrpecpnmJRtKjF4yIdwfk4Nk7ZXGxRaSB7xrjLW
         kpfPpgcGIavYG6YZC/ZgKJbkubm77HbgAdER1BamYbkfRCR/zIH0IKsvBjA1K99Aqihs
         X5XLV9VBiSe9TZw+xVWstN21voCnYiAw65kHkJ/1eI88c6raEgCh4fmfyCZvNfYIvBQ4
         pkeXmN/UU+3bPjui1+L5y3vGf71jBZXqSiPhrkQLFBLs4iaoTUpMPD1RS4rAmpDjCy+g
         zzuidkxtPcNoBIRetKEKtG96m1PK/mguHGQbP1vxSb1EB0bM0R2CWzeMgCQoIPVABp8u
         XR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:in-reply-to:references
         :content-transfer-encoding;
        bh=uiH7tlxXBQcdGzP3CpVXTDpR6If738RH8DOIk/plU0o=;
        b=dtTMB8cINUgUG/fDyetASC8QehsLFtjkSQ6AdL1vu4RyB1H1nkfIY7CzYidqjL7zf0
         RWkT9ES+VYaEVhaXGXClklqnjSjbQLy2dT8egcf6pIAaMUHXU/bVqSfAG0avIe21uHkt
         3kuU3z+8n+uAjG0ms/kHpCCRlxe1J4BLvmDpb/w/Ta5JSIAKwF2i9kzKRDjbjFudly3E
         pZwQcZ2AXQkajbm3LfgV5eSCrosZisvmerooXXWoVZzI5tQfcJIyRm7dRrXAIfX9QslA
         eNdE4Kojn83H5al3z4tPqfoOPRfBefxPsfBTG9iqz9nTWWqhcVC1CdbJVlkU6+4moE7r
         IQuA==
X-Gm-Message-State: AOAM533LWghjBc4+qYHkYK94qgbCNcxVs6+dZ8fQii30pBl7HP3G5cVh
        fuu2B5eBLZi2TAOSoQy76EEimvKgjYm1idoZ
X-Google-Smtp-Source: ABdhPJwp4knBmsADh7uDdqZFpXLdOlDSFnWhu8+JklKGBn5mPvAtrqLd94bvXYk8XiGg7wziVYOZQQ==
X-Received: by 2002:a17:902:bb8d:: with SMTP id m13mr8616806pls.11.1597834294251;
        Wed, 19 Aug 2020 03:51:34 -0700 (PDT)
Received: from gmail.com ([119.8.124.38])
        by smtp.gmail.com with ESMTPSA id k21sm24844830pgl.0.2020.08.19.03.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 03:51:33 -0700 (PDT)
From:   Shaoxiong Li <dahefanteng@gmail.com>
To:     linux-bcache@vger.kernel.org
Cc:     colyli@suse.de
Subject: [PATCH 3/3] bcache-tools: Remove the dependency on libsmartcols
Date:   Wed, 19 Aug 2020 18:51:28 +0800
Message-Id: <635386ddf41bc1656344009597837b885c543bf1.1597817961.git.dahefanteng@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <a6b9fc134e5dd73d1a6f3945fd649d7aa23cff9e.1597817961.git.dahefanteng@gmail.com>
References: <a6b9fc134e5dd73d1a6f3945fd649d7aa23cff9e.1597817961.git.dahefanteng@gmail.com>
MIME-Version: 1.0
In-Reply-To: <a6b9fc134e5dd73d1a6f3945fd649d7aa23cff9e.1597817961.git.dahefanteng@gmail.com>
References: <a6b9fc134e5dd73d1a6f3945fd649d7aa23cff9e.1597817961.git.dahefanteng@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The bcache tree function relies on the libsmartcols library to
display the relationship between the cache device and the bdev
device in a tree shape. However, it is difficult for many old
operating systems (such as Ubuntu 12) to install this library.

For better compatibility, a simpler implementation is used to
achieve the same purpose, while removing the dependency on
libsmartcols.

Signed-off-by: Shaoxiong Li <dahefanteng@gmail.com>
---
 Makefile |  8 ++++----
 bcache.c | 53 +++++++++++++++++++++++++++++++++++------------------
 2 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/Makefile b/Makefile
index 90db951..df44085 100644
--- a/Makefile
+++ b/Makefile
@@ -22,8 +22,8 @@ clean:
 
 bcache-test: LDLIBS += `pkg-config --libs openssl` -lm
 
-make-bcache: LDLIBS += `pkg-config --libs uuid blkid smartcols`
-make-bcache: CFLAGS += `pkg-config --cflags uuid blkid smartcols`
+make-bcache: LDLIBS += `pkg-config --libs uuid blkid`
+make-bcache: CFLAGS += `pkg-config --cflags uuid blkid`
 make-bcache: make.o crc64.o lib.o zoned.o
 
 probe-bcache: LDLIBS += `pkg-config --libs uuid blkid`
@@ -35,7 +35,7 @@ bcache-super-show: crc64.o lib.o
 
 bcache-register: bcache-register.o
 
-bcache: CFLAGS += `pkg-config --cflags blkid uuid smartcols`
-bcache: LDLIBS += `pkg-config --libs blkid uuid smartcols`
+bcache: CFLAGS += `pkg-config --cflags blkid uuid`
+bcache: LDLIBS += `pkg-config --libs blkid uuid`
 bcache: CFLAGS += -std=gnu99
 bcache: crc64.o lib.o make.o zoned.o features.o
diff --git a/bcache.c b/bcache.c
index 3b963e4..a0c5a67 100644
--- a/bcache.c
+++ b/bcache.c
@@ -10,13 +10,13 @@
 #include <unistd.h>
 #include <getopt.h>
 #include <regex.h>
-#include <libsmartcols/libsmartcols.h>
 #include "bcache.h"
 #include "lib.h"
 #include "make.h"
 #include <locale.h>
 #include "list.h"
 #include <limits.h>
+#include <assert.h>
 
 #include "features.h"
 
@@ -425,8 +425,34 @@ int detail_single(char *devname)
 	return 0;
 }
 
+void replace_line(char **dest, const char *from, const char *to)
+{
+	assert(strlen(from) == strlen(to));
+	char sub[4096] = "";
+	char new[4096] = "";
+
+	strcpy(sub, *dest);
+	while (1) {
+		char *tmp = strpbrk(sub, from);
+
+		if (tmp != NULL) {
+			strcpy(new, tmp);
+			strcpy(sub, tmp + strlen(from));
+		} else
+			break;
+	}
+	if (strlen(new) > 0) {
+		strncpy(new, to, strlen(to));
+		sprintf(*dest + strlen(*dest) - strlen(new), new, strlen(new));
+	}
+}
+
 int tree(void)
 {
+	char *out = (char *)malloc(4096);
+	const char *begin = ".\n";
+	const char *middle = "├─";
+	const char *tail = "└─";
 	struct list_head head;
 	struct dev *devs, *tmp, *n, *m;
 
@@ -438,35 +464,26 @@ int tree(void)
 		fprintf(stderr, "Failed to list devices\n");
 		return ret;
 	}
-	struct libscols_table *tb;
-	struct libscols_line *dad, *son;
-	enum { COL_CSET, COL_BNAME };
-	setlocale(LC_ALL, "");
-	tb = scols_new_table();
-	scols_table_new_column(tb, ".", 0.1, SCOLS_FL_TREE);
-	scols_table_new_column(tb, "", 2, SCOLS_FL_TRUNC);
+	sprintf(out, "%s", begin);
 	list_for_each_entry_safe(devs, n, &head, dev_list) {
 		if ((devs->version == BCACHE_SB_VERSION_CDEV
 		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
 		    && strcmp(devs->state, BCACHE_BASIC_STATE_ACTIVE) == 0) {
-			dad = scols_table_new_line(tb, NULL);
-			scols_line_set_data(dad, COL_CSET, devs->name);
+			sprintf(out + strlen(out), "%s\n", devs->name);
 			list_for_each_entry_safe(tmp, m, &head, dev_list) {
 				if (strcmp(devs->cset, tmp->attachuuid) ==
 				    0) {
-					son =
-					    scols_table_new_line(tb, dad);
-					scols_line_set_data(son, COL_CSET,
-							    tmp->name);
-					scols_line_set_data(son, COL_BNAME,
-							    tmp->bname);
+					replace_line(&out, tail, middle);
+					sprintf(out + strlen(out), "%s%s %s\n",
+						tail, tmp->name, tmp->bname);
 				}
 			}
 		}
 	}
-	scols_print_table(tb);
-	scols_unref_table(tb);
+	if (strlen(out) > strlen(begin))
+		printf("%s", out);
 	free_dev(&head);
+	free(out);
 	return 0;
 }
 
-- 
2.17.1

