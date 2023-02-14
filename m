Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B25695749
	for <lists+linux-bcache@lfdr.de>; Tue, 14 Feb 2023 04:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjBNDOm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 Feb 2023 22:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjBNDOl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Feb 2023 22:14:41 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3501C582;
        Mon, 13 Feb 2023 19:14:11 -0800 (PST)
From:   =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1676344425;
        bh=lUBQv/gxbu9SY9YrTLi2niEa4rAG6aaQal1onFRL2K0=;
        h=From:Date:Subject:To:Cc:From;
        b=fHiwu9Nkh1OA406ptS5CCA4B5NxL5QMbqTHkDFViGUH9shajemAjgLr5I8pvuwXdi
         oEKuRcCGxH/wfzhrU0xg2Ph9BL7jZUGnrdnUU6q4m3rT3KGtqd2n7udJOQYCH4b+OG
         /lC6duSKqXg8SU9J1+bEuMqon4XRUBgFCIjDoIbc=
Date:   Tue, 14 Feb 2023 03:13:39 +0000
Subject: [PATCH] bcache: make kobj_type structures constant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230214-kobj_type-bcache-v1-1-cf00ead7bee7@weissschuh.net>
X-B4-Tracking: v=1; b=H4sIAGL86mMC/x2N0QrCMAxFf2Xk2UIbh6C/IiJJm9no6EY7xTH27
 wYfz7kc7gZNqkqDS7dBlY82nYpBOHQQM5WHOE3GgB6PHkPvXhM/78s6i+NIMYs7JeQU8Mx+ILC
 MqdlWqcRsYXmPo8m5yqDf/8/1tu8/HKS1BXcAAAA=
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1676344423; l=2027;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=lUBQv/gxbu9SY9YrTLi2niEa4rAG6aaQal1onFRL2K0=;
 b=TlvCX16r4S6MNFq0EVBI7VxgI64XDdViGztU1MHvVmy1roWeuLrCuLGERPS8MaF51wIKVWMIq
 5OeMD9RebRSCWX575Rs360ss1izfQdHDKDQ84ZnJSJPB3jv3i0pXxtf
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
the driver core allows the usage of const struct kobj_type.

Take advantage of this to constify the structure definitions to prevent
modification at runtime.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/md/bcache/bcache.h | 10 +++++-----
 drivers/md/bcache/sysfs.h  |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index aebb7ef10e63..a522f4f1f992 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1004,11 +1004,11 @@ extern struct workqueue_struct *bch_flush_wq;
 extern struct mutex bch_register_lock;
 extern struct list_head bch_cache_sets;
 
-extern struct kobj_type bch_cached_dev_ktype;
-extern struct kobj_type bch_flash_dev_ktype;
-extern struct kobj_type bch_cache_set_ktype;
-extern struct kobj_type bch_cache_set_internal_ktype;
-extern struct kobj_type bch_cache_ktype;
+extern const struct kobj_type bch_cached_dev_ktype;
+extern const struct kobj_type bch_flash_dev_ktype;
+extern const struct kobj_type bch_cache_set_ktype;
+extern const struct kobj_type bch_cache_set_internal_ktype;
+extern const struct kobj_type bch_cache_ktype;
 
 void bch_cached_dev_release(struct kobject *kobj);
 void bch_flash_dev_release(struct kobject *kobj);
diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
index a2ff6447b699..65b8bd975ab1 100644
--- a/drivers/md/bcache/sysfs.h
+++ b/drivers/md/bcache/sysfs.h
@@ -3,7 +3,7 @@
 #define _BCACHE_SYSFS_H_
 
 #define KTYPE(type)							\
-struct kobj_type type ## _ktype = {					\
+const struct kobj_type type ## _ktype = {					\
 	.release	= type ## _release,				\
 	.sysfs_ops	= &((const struct sysfs_ops) {			\
 		.show	= type ## _show,				\

---
base-commit: f6feea56f66d34259c4222fa02e8171c4f2673d1
change-id: 20230214-kobj_type-bcache-6d2bd129b0fa

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>

