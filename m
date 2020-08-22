Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF4724E8C4
	for <lists+linux-bcache@lfdr.de>; Sat, 22 Aug 2020 18:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgHVQbX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 22 Aug 2020 12:31:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:33028 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgHVQbX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 22 Aug 2020 12:31:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DB0F2ABED
        for <linux-bcache@vger.kernel.org>; Sat, 22 Aug 2020 16:31:50 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH] bcache-tools: make: permit only one cache device to be specified
Date:   Sun, 23 Aug 2020 00:31:17 +0800
Message-Id: <20200822163117.25588-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now a cache set only has a single cache, therefore "bache make" should
permit only one cache device to be specified for a cache set.

This patch checks if more than one cache devices are specified by "-C"
an error message "Please specify only one cache device" will be printed
and bcache exits with usage information.

Signed-off-by: Coly Li <colyli@suse.de>
---
 make.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/make.c b/make.c
index 9631857..ad89377 100644
--- a/make.c
+++ b/make.c
@@ -604,6 +604,11 @@ int make_bcache(int argc, char **argv)
 		usage();
 	}
 
+	if (ncache_devices > 1) {
+		fprintf(stderr, "Please specify only one cache device\n");
+		usage();
+	}
+
 	if (bucket_size < block_size) {
 		fprintf(stderr,
 			"Bucket size cannot be smaller than block size\n");
-- 
2.26.2

