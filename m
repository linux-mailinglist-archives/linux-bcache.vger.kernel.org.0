Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B03F3A9EB2
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Jun 2021 17:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhFPPPL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 16 Jun 2021 11:15:11 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:38028 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234498AbhFPPPL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Jun 2021 11:15:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 566981FD47;
        Wed, 16 Jun 2021 15:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623856384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=RAkhWSADyaoHLpylPeq+igwC/iINB5l6eElYHNFu8Zc=;
        b=d91Ph8y197lXG8M3CRmR1X5W7YVWzdy7Aq7ecUYMRN2vLU7dJOy1846p2DNj0/o8U589Ud
        sMhEufqs5wSpNzB75r8OdHG92vUGDvBCkyRcrVKZaT4LCZoADTX97x2TtG96xSFK493EO8
        0QQHjJsBv5x/VwpNiQCahNpU/1HlfdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623856384;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=RAkhWSADyaoHLpylPeq+igwC/iINB5l6eElYHNFu8Zc=;
        b=kD3OEcqJrQqJW8xIFzfL1DQxurK4K23as+AxRB+jzyuJfWv7Tzk6eY708qP9Pw1bkQizyn
        IrSHvemsfvK/WvBg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 7240AA3BB3;
        Wed, 16 Jun 2021 15:13:02 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Shaoxiong Li <dahefanteng@gmail.com>
Subject: [PATCH] bcache-tools: only discard cache device during making when discard is enabled
Date:   Wed, 16 Jun 2021 23:12:49 +0800
Message-Id: <20210616151249.123773-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Currently in cache device making time, discard is always issued onto the
cache device. It is unncessary and might be slow if the cache device is
combined by md raid device (e.g. raid10).

Therefore when making a new cache device, this patch only issue discard
when it is explicitly enabled by --discard option.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Shaoxiong Li <dahefanteng@gmail.com>
---
 make.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/make.c b/make.c
index 4ca7734..34d8011 100644
--- a/make.c
+++ b/make.c
@@ -446,7 +446,8 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
 
 		/* Attempting to discard cache device
 		 */
-		blkdiscard_all(dev, fd);
+		if (discard)
+			blkdiscard_all(dev, fd);
 		putchar('\n');
 	}
 
-- 
2.26.2

