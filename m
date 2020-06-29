Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569A120D9C7
	for <lists+linux-bcache@lfdr.de>; Mon, 29 Jun 2020 22:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733140AbgF2Tuk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Jun 2020 15:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731981AbgF2Tke (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:34 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E3FC03E97A;
        Mon, 29 Jun 2020 12:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tMUnz3Lcybn8dQofQ1ryTzIcUAQ8+R8Yiszv/2NG4rI=; b=dWdDIaKIpyEFnUk6T7c8TrqA7o
        8fIZ/bgRHZ53ELpet4SqmmyFdsnXftWtfj5xiwEYuCQodxE0Z5R6yhJLqMxDe0osKsT4ikp+ZNkXx
        nYauz2oBUNvVsVyaCzhZdGqsuWUcOlCMQfnbLrJdS/0DB2TtAhHaDLqoX7LLtoeQF3soYwJop1lDC
        ya06oELdvMOgNHHKIS03h204DmcW72txJ/uxADHAVLGi9Ovly9EFQH2CkGylm4RNIlIh3STCYyCeJ
        XWF2NKBwGGPqKjYgFXOmS+g6i83kod9P/vUFaTeyivgmpJM0ixQuC3vVY7+PNVguSjFfJtuCY3Bso
        UOtUelMA==;
Received: from [2001:4bb8:184:76e3:fcca:c8dc:a4bf:12fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jpzdV-0004LV-9T; Mon, 29 Jun 2020 19:40:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 13/20] block: tidy up a warning in bio_check_ro
Date:   Mon, 29 Jun 2020 21:39:40 +0200
Message-Id: <20200629193947.2705954-14-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629193947.2705954-1-hch@lst.de>
References: <20200629193947.2705954-1-hch@lst.de>
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

