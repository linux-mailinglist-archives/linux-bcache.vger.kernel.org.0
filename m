Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67C122D737
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Jul 2020 14:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgGYMCy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Jul 2020 08:02:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:52180 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgGYMCy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:02:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 636D3AB55;
        Sat, 25 Jul 2020 12:03:01 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 06/25] bcache: Use struct_size() in kzalloc()
Date:   Sat, 25 Jul 2020 20:00:20 +0800
Message-Id: <20200725120039.91071-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/writeback.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 71801c086b82..5397a2c5d6cc 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -459,10 +459,8 @@ static void read_dirty(struct cached_dev *dc)
 		for (i = 0; i < nk; i++) {
 			w = keys[i];
 
-			io = kzalloc(sizeof(struct dirty_io) +
-				     sizeof(struct bio_vec) *
-				     DIV_ROUND_UP(KEY_SIZE(&w->key),
-						  PAGE_SECTORS),
+			io = kzalloc(struct_size(io, bio.bi_inline_vecs,
+						DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS)),
 				     GFP_KERNEL);
 			if (!io)
 				goto err;
-- 
2.26.2

