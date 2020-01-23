Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8391146F09
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Jan 2020 18:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgAWRDE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 23 Jan 2020 12:03:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:51832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730037AbgAWRDE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:03:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A4FB5AD73;
        Thu, 23 Jan 2020 17:03:02 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Guoju Fang <fangguoju@gmail.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 13/17] bcache: print written and keys in trace_bcache_btree_write
Date:   Fri, 24 Jan 2020 01:01:38 +0800
Message-Id: <20200123170142.98974-14-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Guoju Fang <fangguoju@gmail.com>

It's useful to dump written block and keys on btree write, this patch
add them into trace_bcache_btree_write.

Signed-off-by: Guoju Fang <fangguoju@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 include/trace/events/bcache.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/bcache.h b/include/trace/events/bcache.h
index e4526f85c19d..0bddea663b3b 100644
--- a/include/trace/events/bcache.h
+++ b/include/trace/events/bcache.h
@@ -275,7 +275,8 @@ TRACE_EVENT(bcache_btree_write,
 		__entry->keys	= b->keys.set[b->keys.nsets].data->keys;
 	),
 
-	TP_printk("bucket %zu", __entry->bucket)
+	TP_printk("bucket %zu written block %u + %u",
+		__entry->bucket, __entry->block, __entry->keys)
 );
 
 DEFINE_EVENT(btree_node, bcache_btree_node_alloc,
-- 
2.16.4

