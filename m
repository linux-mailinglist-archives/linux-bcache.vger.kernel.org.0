Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF719220482
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 07:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgGOFqb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 01:46:31 -0400
Received: from [195.135.220.15] ([195.135.220.15]:38426 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbgGOFqb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 01:46:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8E48DAC20;
        Wed, 15 Jul 2020 05:46:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v2 05/17] bcache: fix super block seq numbers comparision in register_cache_set()
Date:   Wed, 15 Jul 2020 13:46:00 +0800
Message-Id: <20200715054612.6349-6-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715054612.6349-1-colyli@suse.de>
References: <20200715054612.6349-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In register_cache_set(), c is pointer to struct cache_set, and ca is
pointer to struct cache, if ca->sb.seq > c->sb.seq, it means this
registering cache has up to date version and other members, the in-
memory version and other members should be updated to the newer value.

But current implementation makes a cache set only has a single cache
device, so the above assumption works well except for a special case.
The execption is when a cache device new created and both ca->sb.seq and
c->sb.seq are 0, because the super block is never flushed out yet. In
the location for the following if() check,
2156         if (ca->sb.seq > c->sb.seq) {
2157                 c->sb.version           = ca->sb.version;
2158                 memcpy(c->sb.set_uuid, ca->sb.set_uuid, 16);
2159                 c->sb.flags             = ca->sb.flags;
2160                 c->sb.seq               = ca->sb.seq;
2161                 pr_debug("set version = %llu\n", c->sb.version);
2162         }
c->sb.version is not initialized yet and valued 0. When ca->sb.seq is 0,
the if() check will fail (because both values are 0), and the cache set
version, set_uuid, flags and seq won't be updated.

The above problem is hiden for current code, because the bucket size is
compatible among different super block version. And the next time when
running cache set again, ca->sb.seq will be larger than 0 and cache set
super block version will be updated properly.

But if the large bucket feature is enabled,  sb->bucket_size is the low
16bits of the bucket size. For a power of 2 value, when the actual
bucket size exceeds 16bit width, sb->bucket_size will always be 0. Then
read_super_basic() will fail because the if() check to
is_power_of_2(sb->bucket_size) is false. This is how the long time
hidden bug is triggered.

This patch modifies the if() check to the following way,
2156         if (ca->sb.seq > c->sb.seq || c->sb.seq == 0) {
Then cache set's version, set_uuid, flags and seq will always be updated
corectly including for a new created cache device.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1d5b2b3ad93a..0a51ea857e3f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2146,7 +2146,14 @@ static const char *register_cache_set(struct cache *ca)
 	    sysfs_create_link(&c->kobj, &ca->kobj, buf))
 		goto err;
 
-	if (ca->sb.seq > c->sb.seq) {
+	/*
+	 * A special case is both ca->sb.seq and c->sb.seq are 0,
+	 * such condition happens on a new created cache device whose
+	 * super block is never flushed yet. In this case c->sb.version
+	 * and other members should be updated too, otherwise we will
+	 * have a mistaken super block version in cache set.
+	 */
+	if (ca->sb.seq > c->sb.seq || c->sb.seq == 0) {
 		c->sb.version		= ca->sb.version;
 		memcpy(c->sb.set_uuid, ca->sb.set_uuid, 16);
 		c->sb.flags             = ca->sb.flags;
-- 
2.26.2

