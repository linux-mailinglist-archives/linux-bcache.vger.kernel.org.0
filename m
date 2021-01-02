Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1E82E86AE
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Jan 2021 08:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbhABHOA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 2 Jan 2021 02:14:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:47748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbhABHN7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Jan 2021 02:13:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B0C1AADE6;
        Sat,  2 Jan 2021 07:13:02 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 6/6] bcache-tools: display obsoleted bucket size configuration
Date:   Sat,  2 Jan 2021 15:12:44 +0800
Message-Id: <20210102071244.58353-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210102071244.58353-1-colyli@suse.de>
References: <20210102071244.58353-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Although BCH_FEATURE_INCOMPAT_LARGE_BUCKET is obsoleted and we don't
support it anymore,  we still need to display the obsoleted bucket
size combines by,
	bucket_size + (obso_bucket_size_hi << 16)
for the legancy consistency purpose.

This patch checks bch_has_feature_obso_large_bucket() in to_cache_sb(),
if it is true, still try to combine and display the bucket size from
obso_bucket_size_hi.

Signed-off-by: Coly Li <colyli@suse.de>
---
 lib.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib.c b/lib.c
index e5624c7..0d83c23 100644
--- a/lib.c
+++ b/lib.c
@@ -783,9 +783,13 @@ struct cache_sb *to_cache_sb(struct cache_sb *sb,
 		sb->feature_ro_compat = le64_to_cpu(sb_disk->feature_ro_compat);
 	}
 
-	if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES &&
-	    bch_has_feature_large_bucket(sb))
-		sb->bucket_size = 1 << le16_to_cpu(sb_disk->bucket_size);
+	if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
+		if (bch_has_feature_large_bucket(sb))
+			sb->bucket_size = 1 << le16_to_cpu(sb_disk->bucket_size);
+		else if (bch_has_feature_obso_large_bucket(sb))
+			sb->bucket_size +=
+				le16_to_cpu(sb_disk->obso_bucket_size_hi) << 16;
+	}
 
 	return sb;
 }
-- 
2.26.2

