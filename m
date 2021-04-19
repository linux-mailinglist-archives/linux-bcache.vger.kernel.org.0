Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6540236421B
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Apr 2021 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhDSM5A (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Apr 2021 08:57:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58929 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbhDSM47 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Apr 2021 08:56:59 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lYTS0-0001Z9-7b; Mon, 19 Apr 2021 12:56:28 +0000
From:   Colin King <colin.king@canonical.com>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] bcache: Set error return err to -ENOMEM on allocation failure
Date:   Mon, 19 Apr 2021 13:56:27 +0100
Message-Id: <20210419125628.177047-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
2.30.2

