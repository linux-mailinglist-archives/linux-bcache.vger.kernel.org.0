Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F3643F6F3
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Oct 2021 08:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhJ2GLi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Oct 2021 02:11:38 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58968 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhJ2GLf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Oct 2021 02:11:35 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7A5661FD5C;
        Fri, 29 Oct 2021 06:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635487746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KsekPWGPMtLKHLzG1Kx8mIWf6J0hdkHJdlbakHjIGJk=;
        b=cbWL5wonmw0BKrw/Gx6wAWoHNtoXtckRTwgGpdYTFECgh3Y4rhv6iHZudzBFjpvXc9ckbY
        Szl3peVWw2cVdNyzNvBHJ3VErDHNpcE1whn1MUv3pf0+2Ngm9AegWL09pPN3f1cNZ1Gf4R
        qoA6l+MyGZ3KSk9tuYqGUnOh6SSp/NY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635487746;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KsekPWGPMtLKHLzG1Kx8mIWf6J0hdkHJdlbakHjIGJk=;
        b=Y9i76YfPZjTDuA+VZAyyB7QDyTAqUZWfs25XDoZCNBi+b6b87o4Ck5ptJL1oK/yJtTTrUm
        V+PNVaFfuRG0BwCg==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id D5873A3B81;
        Fri, 29 Oct 2021 06:09:04 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axbeo@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Qing Wang <wangqing@vivo.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 2/2] bcache: replace snprintf in show functions with sysfs_emit
Date:   Fri, 29 Oct 2021 14:08:51 +0800
Message-Id: <20211029060851.119872-3-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029060851.119872-1-colyli@suse.de>
References: <20211029060851.119872-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Qing Wang <wangqing@vivo.com>

coccicheck complains about the use of snprintf() in sysfs show functions.

Fix the following coccicheck warning:
drivers/md/bcache/sysfs.h:54:12-20: WARNING: use scnprintf or sprintf.

Implement sysfs_print() by sysfs_emit() and remove snprint() since no one
uses it any more.

Suggested-by: Coly Li <colyli@suse.de>
Signed-off-by: Qing Wang <wangqing@vivo.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/sysfs.h | 18 ++++++++++++++++--
 drivers/md/bcache/util.h  | 17 -----------------
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
index 215df32f567b..c1752ba2e05b 100644
--- a/drivers/md/bcache/sysfs.h
+++ b/drivers/md/bcache/sysfs.h
@@ -51,13 +51,27 @@ STORE(fn)								\
 #define sysfs_printf(file, fmt, ...)					\
 do {									\
 	if (attr == &sysfs_ ## file)					\
-		return snprintf(buf, PAGE_SIZE, fmt "\n", __VA_ARGS__);	\
+		return sysfs_emit(buf, fmt "\n", __VA_ARGS__);	\
 } while (0)
 
 #define sysfs_print(file, var)						\
 do {									\
 	if (attr == &sysfs_ ## file)					\
-		return snprint(buf, PAGE_SIZE, var);			\
+		return sysfs_emit(buf,						\
+				__builtin_types_compatible_p(typeof(var), int)		\
+					 ? "%i\n" :				\
+				__builtin_types_compatible_p(typeof(var), unsigned int)	\
+					 ? "%u\n" :				\
+				__builtin_types_compatible_p(typeof(var), long)		\
+					 ? "%li\n" :			\
+				__builtin_types_compatible_p(typeof(var), unsigned long)\
+					 ? "%lu\n" :			\
+				__builtin_types_compatible_p(typeof(var), int64_t)	\
+					 ? "%lli\n" :			\
+				__builtin_types_compatible_p(typeof(var), uint64_t)	\
+					 ? "%llu\n" :			\
+				__builtin_types_compatible_p(typeof(var), const char *)	\
+					 ? "%s\n" : "%i\n", var);	\
 } while (0)
 
 #define sysfs_hprint(file, val)						\
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 6274d6a17e5e..cdb165517d0b 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -340,23 +340,6 @@ static inline int bch_strtoul_h(const char *cp, long *res)
 	_r;								\
 })
 
-#define snprint(buf, size, var)						\
-	snprintf(buf, size,						\
-		__builtin_types_compatible_p(typeof(var), int)		\
-		     ? "%i\n" :						\
-		__builtin_types_compatible_p(typeof(var), unsigned int)	\
-		     ? "%u\n" :						\
-		__builtin_types_compatible_p(typeof(var), long)		\
-		     ? "%li\n" :					\
-		__builtin_types_compatible_p(typeof(var), unsigned long)\
-		     ? "%lu\n" :					\
-		__builtin_types_compatible_p(typeof(var), int64_t)	\
-		     ? "%lli\n" :					\
-		__builtin_types_compatible_p(typeof(var), uint64_t)	\
-		     ? "%llu\n" :					\
-		__builtin_types_compatible_p(typeof(var), const char *)	\
-		     ? "%s\n" : "%i\n", var)
-
 ssize_t bch_hprint(char *buf, int64_t v);
 
 bool bch_is_zero(const char *p, size_t n);
-- 
2.31.1

