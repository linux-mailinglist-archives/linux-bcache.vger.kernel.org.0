Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC8A27F9BF
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Oct 2020 08:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgJAGvh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 1 Oct 2020 02:51:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:34052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgJAGvh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Oct 2020 02:51:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 390AFB01D;
        Thu,  1 Oct 2020 06:51:35 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/15] bcache: remove useless bucket_pages()
Date:   Thu,  1 Oct 2020 14:50:51 +0800
Message-Id: <20201001065056.24411-11-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001065056.24411-1-colyli@suse.de>
References: <20201001065056.24411-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

It seems alloc_bucket_pages() is the only user of bucket_pages().
Considering alloc_bucket_pages() is removed from bcache code, it is safe
to remove the useless macro bucket_pages() now.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/bcache/bcache.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 29bec61cafbb..48a2585b6bbb 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -757,7 +757,6 @@ struct bbio {
 #define btree_default_blocks(c)						\
 	((unsigned int) ((PAGE_SECTORS * (c)->btree_pages) >> (c)->block_bits))
 
-#define bucket_pages(c)		((c)->sb.bucket_size / PAGE_SECTORS)
 #define bucket_bytes(c)		((c)->sb.bucket_size << 9)
 #define block_bytes(ca)		((ca)->sb.block_size << 9)
 
-- 
2.26.2

