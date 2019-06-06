Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41168369C7
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jun 2019 04:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfFFCGX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jun 2019 22:06:23 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42169 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfFFCGX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jun 2019 22:06:23 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so464663pff.9
        for <linux-bcache@vger.kernel.org>; Wed, 05 Jun 2019 19:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=/CsAq+kapoIo+gjGlxHpLLSneYTgaxgCTJ76XAw2OoE=;
        b=BJ+Uvx3RYPfMnk626bW665ClettSks3fhrTnVmwV3qES/ch8/pNx/DpGlBbTHsa6yI
         RiLMtSRhgp4mJH8/ivnZ9OsaJ4FDX9yAMmPMzE+oxH5EFg1Yy4zBeBC1m9Qf4Reo8KmU
         MRifdb5zj35PCtkjQAO0DqNXNS28LAwv6uWJ0gkJt+VQ6kKDx+fARk8swI6Z1QywWND8
         MvWZNFvwJJFT7BeN5iFvP1rl4GdMJidKNAqAaNPsuhzleLcScqvQIc6fsbfpLqZ7rb3V
         EeeS9kNtc8Gt/LbHRGYsDMN+RWXCFa+OsnyOQyvFJP5ZGrSiSC7cz/LY87mFEsW2wox3
         Tggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=/CsAq+kapoIo+gjGlxHpLLSneYTgaxgCTJ76XAw2OoE=;
        b=t0gJrpxgJEG9vnHk3wnMFvsGl0v37Vd76urTjlsyuHawgxKwGL+V0vmzeCxJUA8NWv
         MqxOJf2evLqkskFrA63VU7gWVRqRNThDPt300Iosi81yxj5PYw1ATVQ2kJzBr2jff2rU
         VEU1lq365nH3DtAZZaA/4Apwr3w5+GmeTy6/yO4BLoGf1wznzhqVl6xIvfHmNd+r0ND9
         NYD+Yq4J8wR5NwVg8nG5Qucal9VObRtOqxn7P0OomHqTGhpGmuQsAUK0mfuw9zXEUmZM
         ZCh7L+6BOdsL+oxhKfX+PrEizNwUbfhEnvoCmwk6zbLmgZIKOzTqD1+i4eguGj5MVhvR
         gWSg==
X-Gm-Message-State: APjAAAWPNOOkOCBKiHPa9e4a52fDf0DImMICmlTs+qMqKtn5fKfH5Mc6
        eAZEeHyMAPfE3qg88r9YbQiCHUY4HKNIqQ==
X-Google-Smtp-Source: APXvYqxaEYMNaft2GICZ4IupU5NcRqrBmYIU3baNJDgudXV23UnN+fD3PMjE7rALehncPlb2OHeRkA==
X-Received: by 2002:a65:63cd:: with SMTP id n13mr888230pgv.153.1559786782566;
        Wed, 05 Jun 2019 19:06:22 -0700 (PDT)
Received: from ip-172-31-33-21.ap-northeast-1.compute.internal (ec2-3-112-67-113.ap-northeast-1.compute.amazonaws.com. [3.112.67.113])
        by smtp.gmail.com with ESMTPSA id x7sm221939pfa.125.2019.06.05.19.06.20
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 19:06:21 -0700 (PDT)
From:   Xinwei Wei <xinweiwei90@gmail.com>
To:     linux-bcache@vger.kernel.org
Subject: [PATCH 1/1] bcache-tools:Add blkdiscard for cache dev
Date:   Thu,  6 Jun 2019 02:06:15 +0000
Message-Id: <114c3049bf90d8e469e49edb307b27218166bcc8.1559729340.git.xinweiwei90@gmail.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Signed-off-by: Xinwei Wei <xinweiwei90@gmail.com>
---
 make.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/make.c b/make.c
index e5e7464..4244866 100644
--- a/make.c
+++ b/make.c
@@ -179,6 +179,48 @@ const char * const cache_replacement_policies[] = {
 	NULL
 };
 
+int blkdiscard_all(char *path, int fd)
+{
+	printf("%s blkdiscard beginning...", path);
+	fflush(stdout);
+
+	uint64_t end, blksize, secsize, range[2];
+	struct stat sb;
+
+	range[0] = 0;
+	range[1] = ULLONG_MAX;
+
+	if (fstat(fd, &sb) == -1)
+		goto err;
+
+	if (!S_ISBLK(sb.st_mode))
+		goto err;
+
+	if (ioctl(fd, BLKGETSIZE64, &blksize))
+		goto err;
+
+	if (ioctl(fd, BLKSSZGET, &secsize))
+		goto err;
+
+	/* align range to the sector size */
+	range[0] = (range[0] + secsize - 1) & ~(secsize - 1);
+	range[1] &= ~(secsize - 1);
+
+	/* is the range end behind the end of the device ?*/
+	end = range[0] + range[1];
+	if (end < range[0] || end > blksize)
+		range[1] = blksize - range[0];
+
+	if (ioctl(fd, BLKDISCARD, &range))
+		goto err;
+
+	printf("done\n");
+	return 0;
+err:
+	printf("\r                                ");
+	return -1;
+}
+
 static void write_sb(char *dev, unsigned int block_size,
 			unsigned int bucket_size,
 			bool writeback, bool discard, bool wipe_bcache,
@@ -354,6 +396,10 @@ static void write_sb(char *dev, unsigned int block_size,
 		       sb.nr_in_set,
 		       sb.nr_this_dev,
 		       sb.first_bucket);
+
+		/* Attempting to discard cache device
+		 */
+		blkdiscard_all(dev, fd);
 		putchar('\n');
 	}
 
@@ -429,7 +475,7 @@ int make_bcache(int argc, char **argv)
 	unsigned int i, ncache_devices = 0, nbacking_devices = 0;
 	char *cache_devices[argc];
 	char *backing_devices[argc];
-	char label[SB_LABEL_SIZE];
+	char label[SB_LABEL_SIZE] = { 0 };
 	unsigned int block_size = 0, bucket_size = 1024;
 	int writeback = 0, discard = 0, wipe_bcache = 0, force = 0;
 	unsigned int cache_replacement_policy = 0;
-- 
2.18.1

