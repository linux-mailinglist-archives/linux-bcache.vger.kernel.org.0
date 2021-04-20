Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF2D365196
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Apr 2021 06:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhDTErd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Apr 2021 00:47:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:40818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229786AbhDTErd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Apr 2021 00:47:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 72D95B1C9;
        Tue, 20 Apr 2021 04:45:45 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 2/2] bcache: Set error return err to -ENOMEM on allocation failure
Date:   Tue, 20 Apr 2021 12:44:52 +0800
Message-Id: <20210420044452.88267-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210420044452.88267-1-colyli@suse.de>
References: <20210420044452.88267-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently when ns fails to be allocated the error return path returns
an uninitialized return code in variable 'err'. Fix this by setting
err to -ENOMEM.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 688330711e9a ("bcache: initialize the nvm pages allocator")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/nvm-pages.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 08cd45e90481..2e124d546099 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -584,6 +584,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 		return ERR_PTR(PTR_ERR(bdev));
 	}
 
+	err = -ENOMEM;
 	ns = kzalloc(sizeof(struct bch_nvm_namespace), GFP_KERNEL);
 	if (!ns)
 		goto bdput;
-- 
2.26.2

