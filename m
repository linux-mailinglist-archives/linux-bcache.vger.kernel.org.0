Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5E53E9677
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Aug 2021 19:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhHKREw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 13:04:52 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58610 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhHKREv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 13:04:51 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2E9B820193;
        Wed, 11 Aug 2021 17:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628701467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=laAwESEAf1HwUo02bMecdYHi6y4qQbivmyWQ7n28vLM=;
        b=kL8U39qfAGHlfIpFKSdlb2jrwBzFmmUCbuKHdvnI5e85FkNvJFP3O1BJ06q3ES/IeJQhWf
        yByFx91+xFcC+91UKtqBaioVexFYMwDkYlqbRGPkArYHsLluWVAtFchyc9yWVZREnObCzX
        5GmsU6pjWTsitNFHOpXgJLb32Wm3p8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628701467;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=laAwESEAf1HwUo02bMecdYHi6y4qQbivmyWQ7n28vLM=;
        b=C9v12mtL3QesmsinphdNJhXzTH3yKw6zj+xrgVu7N2XGLMqnd1sJx+niQ+a/xSwqRJCffV
        BTRbzpg67QbE3yBQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 0CB9AA3D62;
        Wed, 11 Aug 2021 17:04:21 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        axboe@kernel.dk, hare@suse.com, jack@suse.cz,
        dan.j.williams@intel.com, hch@lst.de, ying.huang@intel.com,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v12 06/12] bcache: get recs list head for allocated pages by specific uuid
Date:   Thu, 12 Aug 2021 01:02:18 +0800
Message-Id: <20210811170224.42837-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210811170224.42837-1-colyli@suse.de>
References: <20210811170224.42837-1-colyli@suse.de>
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
 drivers/md/bcache/nvm-pages.c | 6 ++++++
 drivers/md/bcache/nvm-pages.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index ef61fdaaac28..497360c60f26 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -523,6 +523,12 @@ void *bch_nvmpg_alloc_pages(int order, const char *uuid)
 }
 EXPORT_SYMBOL_GPL(bch_nvmpg_alloc_pages);
 
+struct bch_nvmpg_head *bch_get_nvmpg_head(const char *uuid)
+{
+	return find_nvmpg_head(uuid, false);
+}
+EXPORT_SYMBOL_GPL(bch_get_nvmpg_head);
+
 static inline void *nvm_end_addr(struct bch_nvmpg_ns *ns)
 {
 	return ns->base_addr + (ns->pages_total << PAGE_SHIFT);
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 2529dc8b9d49..2f6f2ffbfd80 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -93,6 +93,7 @@ int bch_nvmpg_init(void);
 void bch_nvmpg_exit(void);
 void *bch_nvmpg_alloc_pages(int order, const char *uuid);
 void bch_nvmpg_free_pages(void *addr, int order, const char *uuid);
+struct bch_nvmpg_head *bch_get_nvmpg_head(const char *uuid);
 
 #else
 
@@ -115,6 +116,11 @@ static inline void *bch_nvmpg_alloc_pages(int order, const char *uuid)
 
 static inline void bch_nvmpg_free_pages(void *addr, int order, const char *uuid) { }
 
+static inline struct bch_nvmpg_head *bch_get_nvmpg_head(const char *uuid)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.26.2

