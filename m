Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BE1731840
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jun 2023 14:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240033AbjFOMNl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 15 Jun 2023 08:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbjFOMNl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Jun 2023 08:13:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B51193;
        Thu, 15 Jun 2023 05:13:40 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 02A82223D6;
        Thu, 15 Jun 2023 12:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686831219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GQspoS/4BMqbgma/CWoOn63CiUiV7ipXCeFsW+8Z2s=;
        b=IoT9xxsAWeczKp0KZDLezvw295Ec2kH54eoyRoGeLCffxWuXbbgL8/22brdWhnrvaGeqQ0
        X65XtSbz7ethASr5C4SB2saodAbIyn7A1aLWLhY3QPsLm4iPGbu2//nwp0PwjvTlqIddFq
        Y/G6xi3pxNU9idA0ZejiXHRII0upuLE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686831219;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GQspoS/4BMqbgma/CWoOn63CiUiV7ipXCeFsW+8Z2s=;
        b=utxaOv6GhpEtVET6QeCkofpHoPmTBpk6lltborpEB62uEKhh48494tDNtkw+z83apf1Uiv
        vyV/Ux8u6hZIdBDA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id E6EA52C141;
        Thu, 15 Jun 2023 12:13:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 2/6] bcache: make kobj_type structures constant
Date:   Thu, 15 Jun 2023 20:12:19 +0800
Message-Id: <20230615121223.22502-3-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230615121223.22502-1-colyli@suse.de>
References: <20230615121223.22502-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
the driver core allows the usage of const struct kobj_type.

Take advantage of this to constify the structure definitions to prevent
modification at runtime.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Coly Li <colyli@suse.de>
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
-- 
2.35.3

