Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B15357AF
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jun 2019 09:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFEH1h (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jun 2019 03:27:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:41172 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726477AbfFEH1h (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jun 2019 03:27:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B63FAE9F;
        Wed,  5 Jun 2019 07:27:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 3/6] bcache: set largest seq to ja->seq[bucket_index] in journal_read_bucket()
Date:   Wed,  5 Jun 2019 15:27:15 +0800
Message-Id: <20190605072718.121379-4-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190605072718.121379-1-colyli@suse.de>
References: <20190605072718.121379-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In journal_read_bucket() when setting ja->seq[bucket_index], there might
be potential case that a later non-maximum overwrites a better sequence
number to ja->seq[bucket_index]. This patch adds a check to make sure
that ja->seq[bucket_index] will be only set a new value if it is bigger
then current value.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/journal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 76d3770ce484..69586ded980c 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -156,7 +156,8 @@ reread:		left = ca->sb.bucket_size - offset;
 			list_add(&i->list, where);
 			ret = 1;
 
-			ja->seq[bucket_index] = j->seq;
+			if (j->seq > ja->seq[bucket_index])
+				ja->seq[bucket_index] = j->seq;
 next_set:
 			offset	+= blocks * ca->sb.block_size;
 			len	-= blocks * ca->sb.block_size;
-- 
2.16.4

