Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDBF471BC1
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 18:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhLLRGc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 12:06:32 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39794 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhLLRGc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 12:06:32 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7C2791F3B6;
        Sun, 12 Dec 2021 17:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639328791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BVFxjDh95DjBUoZYp+aR/MCyu7Kz1R2VauRvprm0FfI=;
        b=QYHfQ3rwfI8t6FS6zGT+N3XH41vAVQ6EyS843aq1zVGBKM+lr+MR7wCle+hDb8n9c2QzwW
        B0Bkf9mxgEuN0ZsHKwVJa216aXy5goMp/oR3PY3mNVksP+ySKP9Vxmh/GDRt9hwk6NHdmq
        o8Fx1ViDtZ833d0FxuqZE/6QzR44opY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639328791;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BVFxjDh95DjBUoZYp+aR/MCyu7Kz1R2VauRvprm0FfI=;
        b=JvYU+TUCovFVt2v6C1FTTH+hrH3B9VLyl1kWwhWVQ8Gscgx1YQsj0+dO5q6ddLUJWh2J0N
        exo360aqvtI2sfAg==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 1E7A1A3B83;
        Sun, 12 Dec 2021 17:06:27 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v13 06/12] bcache: get recs list head for allocated pages by specific uuid
Date:   Mon, 13 Dec 2021 01:05:46 +0800
Message-Id: <20211212170552.2812-7-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211212170552.2812-1-colyli@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch implements bch_get_nvmpg_head() of the buddy allocator
to be used to get recs list head for allocated pages by specific
uuid. Then the requester (owner) can find all previous allocated
nvdimm pages by iterating the recs list.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/nvmpg.c | 5 +++++
 drivers/md/bcache/nvmpg.h | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
index 8ce0c4389b42..e26c7b578a62 100644
--- a/drivers/md/bcache/nvmpg.c
+++ b/drivers/md/bcache/nvmpg.c
@@ -539,6 +539,11 @@ unsigned long bch_nvmpg_alloc_pages(int order, const char *uuid)
 	return nvmpg_offset;
 }
 
+struct bch_nvmpg_head *bch_get_nvmpg_head(const char *uuid)
+{
+	return find_nvmpg_head(uuid, false);
+}
+
 static inline void *nvm_end_addr(struct bch_nvmpg_ns *ns)
 {
 	return ns->base_addr + (ns->pages_total << PAGE_SHIFT);
diff --git a/drivers/md/bcache/nvmpg.h b/drivers/md/bcache/nvmpg.h
index e089936e7f13..2361cabf18be 100644
--- a/drivers/md/bcache/nvmpg.h
+++ b/drivers/md/bcache/nvmpg.h
@@ -94,6 +94,7 @@ int bch_nvmpg_init(void);
 void bch_nvmpg_exit(void);
 unsigned long bch_nvmpg_alloc_pages(int order, const char *uuid);
 void bch_nvmpg_free_pages(unsigned long nvmpg_offset, int order, const char *uuid);
+struct bch_nvmpg_head *bch_get_nvmpg_head(const char *uuid);
 
 #else
 
@@ -116,6 +117,11 @@ static inline unsigned long bch_nvmpg_alloc_pages(int order, const char *uuid)
 
 static inline void bch_nvmpg_free_pages(void *addr, int order, const char *uuid) { }
 
+static inline struct bch_nvmpg_head *bch_get_nvmpg_head(const char *uuid)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.31.1

