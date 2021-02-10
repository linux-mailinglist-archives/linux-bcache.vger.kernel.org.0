Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5CD316880
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhBJN6P (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 08:58:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:45358 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231440AbhBJN5t (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 08:57:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32FC5ACBF;
        Wed, 10 Feb 2021 13:57:06 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        kernel test robot <lkp@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 2/4] bcache: use div_u64() in init_owner_info()
Date:   Wed, 10 Feb 2021 21:56:55 +0800
Message-Id: <20210210135657.35284-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210135657.35284-1-colyli@suse.de>
References: <20210210135657.35284-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Kernel test robot reports the build-in u64/u32 in init_owner_info()
doesn't work for m68k arch, the explict div_u64() should be used.

This patch explicit uses div_u64() to do the u64/u32 division on
32bit m68k arch.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index c350dcd696dd..8be761467d8f 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -521,7 +521,7 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 	only_set->owner_list_size = owner_list_head->size;
 	only_set->owner_list_used = owner_list_head->used;
 
-	remove_owner_space(ns, 0, ns->pages_offset/ns->page_size);
+	remove_owner_space(ns, 0, div_u64(ns->pages_offset, ns->page_size));
 
 	for (i = 0; i < owner_list_head->used; i++) {
 		owner_head = &owner_list_head->heads[i];
-- 
2.26.2

