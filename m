Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401562E86A8
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Jan 2021 08:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbhABHNz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 2 Jan 2021 02:13:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:47730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbhABHNy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Jan 2021 02:13:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F1509ADCD;
        Sat,  2 Jan 2021 07:12:53 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 2/6] bcache-tools: only call set_bucket_size() for cache device
Date:   Sat,  2 Jan 2021 15:12:40 +0800
Message-Id: <20210102071244.58353-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210102071244.58353-1-colyli@suse.de>
References: <20210102071244.58353-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

It doesn't make sense to set bucket size for backing device, this patch
moves set_bucket_size() into the code block for cache device only.

Signed-off-by: Coly Li <colyli@suse.de>
---
 make.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/make.c b/make.c
index ad89377..a3f97f6 100644
--- a/make.c
+++ b/make.c
@@ -340,7 +340,6 @@ static void write_sb(char *dev, unsigned int block_size,
 	uuid_generate(sb.uuid);
 	memcpy(sb.set_uuid, set_uuid, sizeof(sb.set_uuid));
 
-	set_bucket_size(&sb, bucket_size);
 	sb.block_size	= block_size;
 
 	uuid_unparse(sb.uuid, uuid_str);
@@ -383,6 +382,8 @@ static void write_sb(char *dev, unsigned int block_size,
 		       data_offset);
 		putchar('\n');
 	} else {
+		set_bucket_size(&sb, bucket_size);
+
 		sb.nbuckets		= getblocks(fd) / sb.bucket_size;
 		sb.nr_in_set		= 1;
 		/* 23 is (SB_SECTOR + SB_SIZE) - 1 sectors */
-- 
2.26.2

