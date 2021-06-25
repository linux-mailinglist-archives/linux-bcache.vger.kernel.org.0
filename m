Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFF13B3A74
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Jun 2021 03:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhFYBdv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Jun 2021 21:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhFYBdq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Jun 2021 21:33:46 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFAEC061574
        for <linux-bcache@vger.kernel.org>; Thu, 24 Jun 2021 18:31:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id pf4-20020a17090b1d84b029016f6699c3f2so7028200pjb.0
        for <linux-bcache@vger.kernel.org>; Thu, 24 Jun 2021 18:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sjCNTcqNmvlSVfPI4HQi7RzVQGP2vgCOKaUVCr3Crwo=;
        b=tqHemavXV2l4kxa3mdC6OIWELy0/K8s9qfUAdUmk1CM9lrXlj1frm+HnZBPpIIfhIS
         38vXp7O9J/Jdb7BFBB5B7PVm8BvjPwY2EAvRZfh3VLL5VprkcOBv5B2WXq2U7yVHDqdN
         /1Q8OuOe16uP2M7cvZJAsPv7dSQ8ny7CUIBn9TansCduQpgvW+onArU/S/j8K1ZVXhrG
         MP+yh0JuMkX3293g8uK3c6YjOLFMZaRnOxUZjVoQwAJRiJ6QluM+CdeC2pF+3KMO1Bbj
         gNzs3b5ZuDPFVFrgNXmNcibpZC7fkhbUGERg8YkXOaQiJ5I52VJFDIWBwQ1ZHzWZy58b
         ATBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sjCNTcqNmvlSVfPI4HQi7RzVQGP2vgCOKaUVCr3Crwo=;
        b=gBDNygwNBfgOBIW2m4IptdhWMbzGBV3meCIeCB0rgB3ZIa7Ittz0tsawlc8ljWtlbY
         eXzMsL1dgtqY7m/gTtCk7ySFYXxRIxrZK2apclLAKs68sEraaeATo9v9EiqqWi6OJL2q
         mOau8ZZ2HzLrkN+vyBD+CEVPnVcD/+K0WHUtEruRC2X9npIkwlWEFMQ1eVfyiLGHxW7T
         9x+BAbia5IyHfz9d65chyc6meGk9jV7OH0ykORUxG2VRBhPOjSvAtRrJyLbTsKTrDfbj
         tKneFo60Fv8EW8hdF3voc1Luhgt/ogWDKhIgneG6DhLdyzEZ8BM96q6PGwDosIvnPbsB
         wmng==
X-Gm-Message-State: AOAM5306UYoefndajjD/PDxV/sGM/fkAaolIAIxvWlItfYWianR4qo5P
        o/cF7lq+w1+ZS9fKmN39U71A0Qf1gnCmB2zJ
X-Google-Smtp-Source: ABdhPJyiGsIHP4yglihy4TgmDm8itrhdFd8DWqNLp93tSCngdLrJaZ4H3+q+2Pk86f+a9IEbRzHozQ==
X-Received: by 2002:a17:90b:810:: with SMTP id bk16mr8454119pjb.2.1624584684947;
        Thu, 24 Jun 2021 18:31:24 -0700 (PDT)
Received: from instance-1.asia-east2-b.c.zippy-catwalk-317715.internal (2.31.92.34.bc.googleusercontent.com. [34.92.31.2])
        by smtp.gmail.com with ESMTPSA id y8sm4168612pfe.162.2021.06.24.18.31.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jun 2021 18:31:24 -0700 (PDT)
From:   yanhuan916@gmail.com
To:     linux-bcache@vger.kernel.org
Cc:     colyli@suse.de, dahefanteng@gmail.com,
        Huan Yan <yanhuan916@gmail.com>
Subject: [PATCH 1/2] bcache-tools: make --discard a per device option
Date:   Fri, 25 Jun 2021 09:30:29 +0800
Message-Id: <1624584630-9283-1-git-send-email-yanhuan916@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Huan Yan <yanhuan916@gmail.com>

This patch make --discard option more flexible, it can be indicated after each
backing or cache device.
---
 make.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 14 deletions(-)

diff --git a/make.c b/make.c
index 34d8011..39b381a 100644
--- a/make.c
+++ b/make.c
@@ -402,6 +402,18 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
 		       (unsigned int) sb.version,
 		       sb.block_size,
 		       data_offset);
+
+		/* Attempting to discard backing device
+		 */
+		if (discard) {
+			if (blkdiscard_all(dev, fd) < 0) {
+				fprintf(stderr,
+					"Failed to discard device %s, %s\n",
+					dev, strerror(errno));
+				exit(EXIT_FAILURE);
+			}
+		}
+
 		putchar('\n');
 	} else {
 		if (nvdimm_meta)
@@ -446,8 +458,15 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
 
 		/* Attempting to discard cache device
 		 */
-		if (discard)
-			blkdiscard_all(dev, fd);
+		if (discard) {
+			if (blkdiscard_all(dev, fd) < 0) {
+				fprintf(stderr,
+					"Failed to discard device %s, %s\n",
+					dev, strerror(errno));
+				exit(EXIT_FAILURE);
+			}
+		}
+
 		putchar('\n');
 	}
 
@@ -660,21 +679,27 @@ static unsigned int get_blocksize(const char *path)
 int make_bcache(int argc, char **argv)
 {
 	int c;
-	unsigned int i;
+	unsigned int i, n;
 	int cdev = -1, bdev = -1, mdev = -1;
 	unsigned int ncache_devices = 0, ncache_nvm_devices = 0;
 	unsigned int nbacking_devices = 0;
 	char *cache_devices[argc];
 	char *cache_nvm_devices[argc];
 	char *backing_devices[argc];
+	bool cache_devices_discard[argc];
+	bool backing_devices_discard[argc];
+	bool *device_discard = NULL;
 	char label[SB_LABEL_SIZE] = { 0 };
 	unsigned int block_size = 0, bucket_size = 1024;
-	int writeback = 0, discard = 0, wipe_bcache = 0, force = 0;
+	int writeback = 0, wipe_bcache = 0, force = 0;
 	unsigned int cache_replacement_policy = 0;
 	uint64_t data_offset = BDEV_DATA_START_DEFAULT;
 	uuid_t set_uuid;
 	struct sb_context sbc;
 
+	memset(cache_devices_discard, 0, sizeof(cache_devices_discard));
+	memset(backing_devices_discard, 0, sizeof(backing_devices_discard));
+
 	uuid_generate(set_uuid);
 
 	struct option opts[] = {
@@ -685,10 +710,8 @@ int make_bcache(int argc, char **argv)
 		{ "block",		1, NULL,	'w' },
 		{ "writeback",		0, &writeback,	1 },
 		{ "wipe-bcache",	0, &wipe_bcache,	1 },
-		{ "discard",		0, &discard,	1 },
-		{ "cache_replacement_policy", 1, NULL, 'p' },
+		{ "discard",		0, NULL,	'd' },
 		{ "cache-replacement-policy", 1, NULL, 'p' },
-		{ "data_offset",	1, NULL,	'o' },
 		{ "data-offset",	1, NULL,	'o' },
 		{ "cset-uuid",		1, NULL,	'u' },
 		{ "help",		0, NULL,	'h' },
@@ -710,6 +733,10 @@ int make_bcache(int argc, char **argv)
 		case 'M':
 			mdev = 1;
 			break;
+		case 'd':
+			if (device_discard)
+				*device_discard = true;
+			break;
 		case 'b':
 			bucket_size =
 				hatoi_validate(optarg, "bucket size", UINT_MAX);
@@ -762,15 +789,20 @@ int make_bcache(int argc, char **argv)
 			}
 
 			if (bdev > 0) {
-				backing_devices[nbacking_devices++] = optarg;
-				printf("backing_devices[%d]: %s\n", nbacking_devices - 1, optarg);
+				n = nbacking_devices++;
+				backing_devices[n] = optarg;
+				printf("backing_devices[%d]: %s\n", n, optarg);
+				device_discard = &backing_devices_discard[n];
 				bdev = -1;
 			} else if (cdev > 0) {
-				cache_devices[ncache_devices++] = optarg;
-				printf("cache_devices[%d]: %s\n", ncache_devices - 1, optarg);
+				n = ncache_devices++;
+				cache_devices[n] = optarg;
+				printf("cache_devices[%d]: %s\n", n, optarg);
+				device_discard = &cache_devices_discard[n];
 				cdev = -1;
 			} else if (mdev > 0) {
-				cache_nvm_devices[ncache_nvm_devices++] = optarg;
+				n = ncache_nvm_devices++;
+				cache_nvm_devices[n] = optarg;
 				mdev = -1;
 			}
 			break;
@@ -806,7 +838,6 @@ int make_bcache(int argc, char **argv)
 	sbc.block_size = block_size;
 	sbc.bucket_size = bucket_size;
 	sbc.writeback = writeback;
-	sbc.discard = discard;
 	sbc.wipe_bcache = wipe_bcache;
 	sbc.cache_replacement_policy = cache_replacement_policy;
 	sbc.data_offset = data_offset;
@@ -814,13 +845,16 @@ int make_bcache(int argc, char **argv)
 	sbc.label = label;
 	sbc.nvdimm_meta = (ncache_nvm_devices > 0) ? true : false;
 
-	for (i = 0; i < ncache_devices; i++)
+	for (i = 0; i < ncache_devices; i++) {
+		sbc.discard = cache_devices_discard[i];
 		write_sb(cache_devices[i], &sbc, false, force);
+	}
 
 	for (i = 0; i < nbacking_devices; i++) {
 		check_data_offset_for_zoned_device(backing_devices[i],
 						   &sbc.data_offset);
 
+		sbc.discard = backing_devices_discard[i];
 		write_sb(backing_devices[i], &sbc, true, force);
 	}
 
-- 
1.8.3.1

