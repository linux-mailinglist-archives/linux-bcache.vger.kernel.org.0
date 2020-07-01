Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983E2210714
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 11:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgGAJAS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 05:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729204AbgGAJAO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 05:00:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493D9C03E979;
        Wed,  1 Jul 2020 02:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tMUnz3Lcybn8dQofQ1ryTzIcUAQ8+R8Yiszv/2NG4rI=; b=Z/F5JgSBdsAyHAjWTFzaMp6g/q
        oUzASIPvrJSJhS8H/JfA1QH8G6IT7wmV5wLn36QX/aHDo/hsxYVlgCl6qoTtD6nZ6IvOBUe/JnXQt
        goBpJk9KmMg/PLs2u8o5kRTqrjTKbPsqjWXOy6JnNqrkKOfwRlEIIUz20TquRejre+i/DVwTPiltW
        jHYesHi+fT0Dd0T/0ANjA7isBclM9yDdn8EbcZjL2aV1xUSGZFyB4MPPtssG0ekb0Vesqf9t2hN5D
        7E5atGWNGy/7VUYWuHLULEFzZmWMZQO1JDyBMSdbTihaE6Swz+QOzO9Y+CnVIeWgK7UHJ4QLdU4Me
        +zEre2Dw==;
Received: from [2001:4bb8:184:76e3:ea38:596b:3e9e:422a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYbA-0008Ea-Rh; Wed, 01 Jul 2020 09:00:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 13/20] block: tidy up a warning in bio_check_ro
Date:   Wed,  1 Jul 2020 10:59:40 +0200
Message-Id: <20200701085947.3354405-14-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701085947.3354405-1-hch@lst.de>
References: <20200701085947.3354405-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The "generic_make_request: " prefix has no value, and will soon become
stale.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 76cfd5709f66cd..95dca74534ff73 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -869,8 +869,7 @@ static inline bool bio_check_ro(struct bio *bio, struct hd_struct *part)
 			return false;
 
 		WARN_ONCE(1,
-		       "generic_make_request: Trying to write "
-			"to read-only block-device %s (partno %d)\n",
+		       "Trying to write to read-only block-device %s (partno %d)\n",
 			bio_devname(bio, b), part->partno);
 		/* Older lvm-tools actually trigger this */
 		return false;
-- 
2.26.2

