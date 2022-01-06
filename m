Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204B448628C
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 11:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbiAFKAK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jan 2022 05:00:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37180 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236540AbiAFKAK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jan 2022 05:00:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFF7861ACA;
        Thu,  6 Jan 2022 10:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA93C36AE5;
        Thu,  6 Jan 2022 10:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641463209;
        bh=2SfoZ7s/DXTSWQQdTkTc5e/8vCvnSQo3Ptn6kJrFTnE=;
        h=From:To:Cc:Subject:Date:From;
        b=sKrluFRafEGQ4JFr1/jbzcp7imZgDqVIixTPQIsM42R4EF2HPJ4fmQL5LaQOC95BX
         tyhCRxkvGmMPHtNRxJSnHC9vlRlolL4759uTAiC5dpwuLZTmSRvw3nieXsTbFGnKrd
         YYi2pGRGIYQkknh9SnIm58hPwM4wZhDhzT7Dz5FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: [PATCH] bcache: use default_groups in kobj_type
Date:   Thu,  6 Jan 2022 11:00:04 +0100
Message-Id: <20220106100004.3277439-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4187; h=from:subject; bh=2SfoZ7s/DXTSWQQdTkTc5e/8vCvnSQo3Ptn6kJrFTnE=; b=owGbwMvMwCRo6H6F97bub03G02pJDInX9i6JF5DS2JM6K3CGhuXT2w8v2fmU3Jqw9d7bp8/SHH/c Oifs3xHLwiDIxCArpsjyZRvP0f0VhxS9DG1Pw8xhZQIZwsDFKQATSTnFMD91veKFuMz4R2IbFf3yvn PM+unPdJZhnsGmiFdnp0/x3C9nfOrsXKvnkQZVewA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There are currently 2 ways to create a set of sysfs files for a
kobj_type, through the default_attrs field, and the default_groups
field.  Move the bcache sysfs code to use default_groups field which has
been the preferred way since aa30f47cf666 ("kobject: Add support for
default attribute groups to kobj_type") so that we can soon get rid of
the obsolete default_attrs field.

Cc: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/stats.c |  3 ++-
 drivers/md/bcache/sysfs.c | 15 ++++++++++-----
 drivers/md/bcache/sysfs.h |  2 +-
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
index 4c7ee5fedb9d..68b02216033d 100644
--- a/drivers/md/bcache/stats.c
+++ b/drivers/md/bcache/stats.c
@@ -78,7 +78,7 @@ static void bch_stats_release(struct kobject *k)
 {
 }
 
-static struct attribute *bch_stats_files[] = {
+static struct attribute *bch_stats_attrs[] = {
 	&sysfs_cache_hits,
 	&sysfs_cache_misses,
 	&sysfs_cache_bypass_hits,
@@ -88,6 +88,7 @@ static struct attribute *bch_stats_files[] = {
 	&sysfs_bypassed,
 	NULL
 };
+ATTRIBUTE_GROUPS(bch_stats);
 static KTYPE(bch_stats);
 
 int bch_cache_accounting_add_kobjs(struct cache_accounting *acc,
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 1f0dce30fa75..d1029d71ff3b 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -500,7 +500,7 @@ STORE(bch_cached_dev)
 	return size;
 }
 
-static struct attribute *bch_cached_dev_files[] = {
+static struct attribute *bch_cached_dev_attrs[] = {
 	&sysfs_attach,
 	&sysfs_detach,
 	&sysfs_stop,
@@ -543,6 +543,7 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_backing_dev_uuid,
 	NULL
 };
+ATTRIBUTE_GROUPS(bch_cached_dev);
 KTYPE(bch_cached_dev);
 
 SHOW(bch_flash_dev)
@@ -600,7 +601,7 @@ STORE(__bch_flash_dev)
 }
 STORE_LOCKED(bch_flash_dev)
 
-static struct attribute *bch_flash_dev_files[] = {
+static struct attribute *bch_flash_dev_attrs[] = {
 	&sysfs_unregister,
 #if 0
 	&sysfs_data_csum,
@@ -609,6 +610,7 @@ static struct attribute *bch_flash_dev_files[] = {
 	&sysfs_size,
 	NULL
 };
+ATTRIBUTE_GROUPS(bch_flash_dev);
 KTYPE(bch_flash_dev);
 
 struct bset_stats_op {
@@ -955,7 +957,7 @@ static void bch_cache_set_internal_release(struct kobject *k)
 {
 }
 
-static struct attribute *bch_cache_set_files[] = {
+static struct attribute *bch_cache_set_attrs[] = {
 	&sysfs_unregister,
 	&sysfs_stop,
 	&sysfs_synchronous,
@@ -980,9 +982,10 @@ static struct attribute *bch_cache_set_files[] = {
 	&sysfs_clear_stats,
 	NULL
 };
+ATTRIBUTE_GROUPS(bch_cache_set);
 KTYPE(bch_cache_set);
 
-static struct attribute *bch_cache_set_internal_files[] = {
+static struct attribute *bch_cache_set_internal_attrs[] = {
 	&sysfs_active_journal_entries,
 
 	sysfs_time_stats_attribute_list(btree_gc, sec, ms)
@@ -1022,6 +1025,7 @@ static struct attribute *bch_cache_set_internal_files[] = {
 	&sysfs_feature_incompat,
 	NULL
 };
+ATTRIBUTE_GROUPS(bch_cache_set_internal);
 KTYPE(bch_cache_set_internal);
 
 static int __bch_cache_cmp(const void *l, const void *r)
@@ -1182,7 +1186,7 @@ STORE(__bch_cache)
 }
 STORE_LOCKED(bch_cache)
 
-static struct attribute *bch_cache_files[] = {
+static struct attribute *bch_cache_attrs[] = {
 	&sysfs_bucket_size,
 	&sysfs_block_size,
 	&sysfs_nbuckets,
@@ -1196,4 +1200,5 @@ static struct attribute *bch_cache_files[] = {
 	&sysfs_cache_replacement_policy,
 	NULL
 };
+ATTRIBUTE_GROUPS(bch_cache);
 KTYPE(bch_cache);
diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
index c1752ba2e05b..a2ff6447b699 100644
--- a/drivers/md/bcache/sysfs.h
+++ b/drivers/md/bcache/sysfs.h
@@ -9,7 +9,7 @@ struct kobj_type type ## _ktype = {					\
 		.show	= type ## _show,				\
 		.store	= type ## _store				\
 	}),								\
-	.default_attrs	= type ## _files				\
+	.default_groups	= type ## _groups				\
 }
 
 #define SHOW(fn)							\
-- 
2.34.1

