Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F041D618B
	for <lists+linux-bcache@lfdr.de>; Sat, 16 May 2020 16:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgEPOK2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 16 May 2020 10:10:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:47106 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgEPOK2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 10:10:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 39DD2ACB8;
        Sat, 16 May 2020 14:10:29 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 2/3] bcache-tools: add is_zoned_device()
Date:   Sat, 16 May 2020 22:09:39 +0800
Message-Id: <20200516140940.101190-3-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200516140940.101190-1-colyli@suse.de>
References: <20200516140940.101190-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a wrapper of get_zone_size(), to check whether a device is
zoned device or not by checking its chunk_sectors.

Signed-off-by: Coly Li <colyli@suse.de>
---
 zoned.c | 5 +++++
 zoned.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/zoned.c b/zoned.c
index 31c9136..d078286 100644
--- a/zoned.c
+++ b/zoned.c
@@ -87,3 +87,8 @@ void check_data_offset_for_zoned_device(char *devname,
 
 	*data_offset = _data_offset;
 }
+
+int is_zoned_device(char *devname)
+{
+	return (get_zone_size(devname) != 0);
+}
diff --git a/zoned.h b/zoned.h
index 1c5cce8..25e5c91 100644
--- a/zoned.h
+++ b/zoned.h
@@ -9,5 +9,6 @@
 #define __ZONED_H
 
 void check_data_offset_for_zoned_device(char *devname, uint64_t *data_offset);
+int is_zoned_device(char *devname);
 
 #endif
-- 
2.25.0

