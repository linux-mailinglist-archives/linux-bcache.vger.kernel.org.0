Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729992E86A2
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Jan 2021 08:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbhABHNx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 2 Jan 2021 02:13:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:47726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbhABHNw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Jan 2021 02:13:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D5545ADCA;
        Sat,  2 Jan 2021 07:12:51 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 1/6] bcache.h: fix typo from SUUP to SUPP
Date:   Sat,  2 Jan 2021 15:12:39 +0800
Message-Id: <20210102071244.58353-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210102071244.58353-1-colyli@suse.de>
References: <20210102071244.58353-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch fixes the following typos,
from BCH_FEATURE_COMPAT_SUUP to BCH_FEATURE_COMPAT_SUPP
from BCH_FEATURE_INCOMPAT_SUUP to BCH_FEATURE_INCOMPAT_SUPP
from BCH_FEATURE_INCOMPAT_SUUP to BCH_FEATURE_RO_COMPAT_SUPP

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/bcache.h b/bcache.h
index 6aef9c4..50dd2b5 100644
--- a/bcache.h
+++ b/bcache.h
@@ -200,9 +200,9 @@ uint64_t crc64(const void *data, size_t len);
 #define BCH_FEATURE_INCOMPAT	2
 #define BCH_FEATURE_TYPE_MASK	0x03
 
-#define BCH_FEATURE_COMPAT_SUUP		0
-#define BCH_FEATURE_INCOMPAT_SUUP	0
-#define BCH_FEATURE_RO_COMPAT_SUUP	0
+#define BCH_FEATURE_COMPAT_SUPP		0
+#define BCH_FEATURE_INCOMPAT_SUPP	0
+#define BCH_FEATURE_RO_COMPAT_SUPP	0
 
 #define BCH_HAS_COMPAT_FEATURE(sb, mask) \
 		((sb)->feature_compat & (mask))
-- 
2.26.2

