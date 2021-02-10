Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA92D316882
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 14:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhBJN6Z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 08:58:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:45380 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231699AbhBJN5u (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 08:57:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 39004ADCD;
        Wed, 10 Feb 2021 13:57:08 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 3/4] bcache: unify code comments style in nvm-pages.c
Date:   Wed, 10 Feb 2021 21:56:56 +0800
Message-Id: <20210210135657.35284-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210135657.35284-1-colyli@suse.de>
References: <20210210135657.35284-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Make nvm-pages.c follow code comments style of other bcache code.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/nvm-pages.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 8be761467d8f..3ea27ea3dd54 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -270,7 +270,7 @@ static void write_owner_info(void)
 	owner_list_head->size = BCH_MAX_OWNER_LIST;
 	WARN_ON(only_set->owner_list_used > owner_list_head->size);
 
-	// in-memory owner maybe not contain alloced-pages.
+	/* in-memory owner maybe not contain alloced-pages. */
 	for (i = 0; i < only_set->owner_list_used; i++) {
 		owner_head = &owner_list_head->heads[i];
 		owner_list = only_set->owner_lists[i];
@@ -569,14 +569,14 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 					extent->nr = rec->nr;
 					WARN_ON(!is_power_of_2(extent->nr));
 
-					/*init struct page: index/private */
+					/* init struct page: index/private */
 					order = ilog2(extent->nr);
 					page = nvm_vaddr_to_page(ns, extent->kaddr);
 					set_page_private(page, order);
 					page->index = rec->pgoff;
 
 					list_add_tail(&extent->list, &extents->extent_head);
-					/*remove already alloced space*/
+					/* remove already alloced space */
 					remove_owner_space(extents->ns, rec->pgoff, rec->nr);
 				}
 				extents->nr += nvm_pgalloc_recs->used;
-- 
2.26.2

