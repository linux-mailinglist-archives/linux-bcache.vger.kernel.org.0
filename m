Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECB769AC7D
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Feb 2023 14:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjBQN37 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 17 Feb 2023 08:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjBQN36 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Feb 2023 08:29:58 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2076ABE8
        for <linux-bcache@vger.kernel.org>; Fri, 17 Feb 2023 05:29:27 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6C06633AA1
        for <linux-bcache@vger.kernel.org>; Fri, 17 Feb 2023 13:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676640566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=QZaTW2CFWqV/swZwcYZ30xKFsdMJ5SfeD+C+qQ8OUqA=;
        b=hX49fOLVZ3IvDvBn5PSvcg7MbCjcDkFfXnzpjJ707vxPQUgA3QPZ+0/BAN5H9nnjyyPrF1
        XhYFBTuQ7ZdHBzQgnDbiK8GnQdxFsZ3eAqW3ImkQNk/2+AatKS8nKNZPsyaGwHKZy5C/kf
        5f4o3ErTeDK0W4O97pspGmqk1lH3ACI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676640566;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=QZaTW2CFWqV/swZwcYZ30xKFsdMJ5SfeD+C+qQ8OUqA=;
        b=97GNfmnijmNqcCzOBq+Uv5rjONNm7YZBh41nBv/JTvC9klK3nsa04I+flbGLdUTwaDeYvz
        /kLLqMmRcDPGoNDQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 582CA2C141;
        Fri, 17 Feb 2023 13:29:25 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH] bcache-tools: improve is_zoned_device()
Date:   Fri, 17 Feb 2023 21:29:17 +0800
Message-Id: <20230217132917.16044-1-colyli@suse.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

To check whether a block device is zoned or not, is_zoned_device()
returns true when /sys/block/<device>/queue/chunk_sectors is not zero.

Now there are devices which are not zoned devices but has non-zero
chunk-sectors values. For such situation, the more accurate method is
to read file /sys/block/<device>/queue/zoned. If the content is not
string "none", this device is not a zoned device. Otherwise (e.g.
"host-aware" or "host- managed"), it is a zoned device.

For elder kernel if the above sysfs file doesn't exist, get_zone_size()
is still called by is_zoned_device() for compatibility.

Signed-off-by: Coly Li <colyli@suse.de>
---
 zoned.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/zoned.c b/zoned.c
index d078286..f214787 100644
--- a/zoned.c
+++ b/zoned.c
@@ -90,5 +90,24 @@ void check_data_offset_for_zoned_device(char *devname,
 
 int is_zoned_device(char *devname)
 {
+	char str[128];
+	FILE *file;
+	int res;
+
+	snprintf(str, sizeof(str),
+		"/sys/block/%s/queue/zoned",
+		basename(devname));
+	file = fopen(str, "r");
+	if (file) {
+		memset(str, 0, sizeof(str));
+		res = fscanf(file, "%s", str);
+		fclose(file);
+
+		/* "none" indicates non-zoned device */
+		if (res == 1)
+			return !(strcmp(str, "none") == 0);
+	}
+
+	/* Only used when "zoned" file doesn't exist */
 	return (get_zone_size(devname) != 0);
 }
-- 
2.39.1

