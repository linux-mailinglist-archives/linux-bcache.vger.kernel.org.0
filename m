Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C9A63E9EC
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Dec 2022 07:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiLAGcq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 1 Dec 2022 01:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiLAGcp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Dec 2022 01:32:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C967E11C23
        for <linux-bcache@vger.kernel.org>; Wed, 30 Nov 2022 22:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=1XVdmii9zWWNkXfHDBbok2TbpiCu126itACx1ujN2fg=; b=HSTM5/pzH0VIURGrBpQtOZU6TJ
        Utphxby6eStRSh5XWdkXLJex5gXlFM+eVGYPYxnGuWhQYI23VduDLQgd4UgrmiAf+MeMXgnuOZwiF
        InTXvkDp1OgPGXFADLXCqsgf1w4Z7QlFZrg8LCUYQypJFRbSTEHVLboIBy5c8kogU6z5kVI5g/CnI
        29K8LKz2pli4x9+nKghSc4x3ehUs86Hzn6H05ZABYBTvkmpwwEXGQTcZkMg4vmEmS8WPLyTUcnbh4
        y3h7QuLN5eRWRgVB3T2XEiHb6LGwcTRfP+iqZteRNS3cLnS1C8VcuG9XepdJgq8JZlrjFKFVwFKsQ
        QS8YmoEg==;
Received: from [2001:4bb8:192:26e7:3eed:6f7d:7e31:7974] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0d7i-005Ful-6S; Thu, 01 Dec 2022 06:32:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org
Subject: [PATCH] bcache: don't export tracepoints
Date:   Thu,  1 Dec 2022 07:32:40 +0100
Message-Id: <20221201063240.402246-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

All bcache tracepoints are only used inside of bcache.ko, so there is
no point in exporting them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/trace.c | 44 ---------------------------------------
 1 file changed, 44 deletions(-)

diff --git a/drivers/md/bcache/trace.c b/drivers/md/bcache/trace.c
index a9a73f560c0442..600efecf9bd9de 100644
--- a/drivers/md/bcache/trace.c
+++ b/drivers/md/bcache/trace.c
@@ -7,47 +7,3 @@
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/bcache.h>
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_request_start);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_request_end);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_bypass_sequential);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_bypass_congested);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_read);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_write);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_read_retry);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_cache_insert);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_journal_replay_key);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_journal_write);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_journal_full);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_journal_entry_full);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_cache_cannibalize);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_read);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_write);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_node_alloc);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_node_alloc_fail);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_node_free);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_gc_coalesce);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_gc_start);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_gc_end);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_gc_copy);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_gc_copy_collision);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_insert_key);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_node_split);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_node_compact);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_set_root);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_invalidate);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_alloc_fail);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_writeback);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_writeback_collision);
-- 
2.30.2

