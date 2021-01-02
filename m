Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584A22E86A6
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Jan 2021 08:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbhABHNy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 2 Jan 2021 02:13:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:47728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbhABHNx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Jan 2021 02:13:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F770ADD6;
        Sat,  2 Jan 2021 07:12:56 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 3/6] bcache.h: add BCH_FEATURE_INCOMPAT_LARGE_BUCKET to BCH_FEATURE_INCOMPAT_SUPP
Date:   Sat,  2 Jan 2021 15:12:41 +0800
Message-Id: <20210102071244.58353-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210102071244.58353-1-colyli@suse.de>
References: <20210102071244.58353-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

BCH_FEATURE_INCOMPAT_LARGE_BUCKET is a feature to support 32bits bucket
size, which is incompatible feature for existing on-disk layout. This
patch adds this feature bit to BCH_FEATURE_INCOMPAT_SUPP feature set.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bcache.h b/bcache.h
index 50dd2b5..58e973c 100644
--- a/bcache.h
+++ b/bcache.h
@@ -201,8 +201,8 @@ uint64_t crc64(const void *data, size_t len);
 #define BCH_FEATURE_TYPE_MASK	0x03
 
 #define BCH_FEATURE_COMPAT_SUPP		0
-#define BCH_FEATURE_INCOMPAT_SUPP	0
 #define BCH_FEATURE_RO_COMPAT_SUPP	0
+#define BCH_FEATURE_INCOMPAT_SUPP	BCH_FEATURE_INCOMPAT_LARGE_BUCKET
 
 #define BCH_HAS_COMPAT_FEATURE(sb, mask) \
 		((sb)->feature_compat & (mask))
-- 
2.26.2

