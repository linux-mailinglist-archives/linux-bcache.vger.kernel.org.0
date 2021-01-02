Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286B82E86AA
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Jan 2021 08:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbhABHN4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 2 Jan 2021 02:13:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:47732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbhABHN4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Jan 2021 02:13:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 443BDADE1;
        Sat,  2 Jan 2021 07:12:58 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 4/6] bcache-tools: check incompatible feature set
Date:   Sat,  2 Jan 2021 15:12:42 +0800
Message-Id: <20210102071244.58353-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210102071244.58353-1-colyli@suse.de>
References: <20210102071244.58353-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When bcache-tools is not updated with kernel driver (or on the versus),
we need to make sure the feature set conflict can be detected to avoid
unexpected data operation.

This patch checks whether there is unsupported {compatc, ro_compat,
incompat} features detected in detail_dev(). If there is, prints out
error message and return error to its caller.

Signed-off-by: Coly Li <colyli@suse.de>
---
 lib.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/lib.c b/lib.c
index 29172f5..a529ad3 100644
--- a/lib.c
+++ b/lib.c
@@ -442,6 +442,33 @@ int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
 		goto Fail;
 	}
 
+	/* Check for incompat feature set */
+	if (sb.version >= BCACHE_SB_VERSION_BDEV_WITH_FEATURES ||
+	    sb.version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
+		uint64_t features;
+
+		features = sb.feature_compat & ~BCH_FEATURE_COMPAT_SUPP;
+		if (features) {
+			fprintf(stderr,
+				"Unsupported compatible feature found\n");
+			goto Fail;
+		}
+
+		features = sb.feature_ro_compat & ~BCH_FEATURE_RO_COMPAT_SUPP;
+		if (features) {
+			fprintf(stderr,
+				"Unsupported read-only compatible feature found\n");
+			goto Fail;
+		}
+
+		features = sb.feature_incompat & ~BCH_FEATURE_INCOMPAT_SUPP;
+		if (features) {
+			fprintf(stderr,
+				"Unsupported incompatible feature found\n");
+			goto Fail;
+		}
+	}
+
 	*type = sb.version;
 	if (sb.version == BCACHE_SB_VERSION_BDEV ||
 	    sb.version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET ||
-- 
2.26.2

