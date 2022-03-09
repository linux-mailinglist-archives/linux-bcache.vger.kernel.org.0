Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110C54D2DD7
	for <lists+linux-bcache@lfdr.de>; Wed,  9 Mar 2022 12:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiCILVF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 9 Mar 2022 06:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiCILVE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 9 Mar 2022 06:21:04 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F0A13DFE
        for <linux-bcache@vger.kernel.org>; Wed,  9 Mar 2022 03:20:04 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id q14so2499647wrc.4
        for <linux-bcache@vger.kernel.org>; Wed, 09 Mar 2022 03:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=5g7Cux9YIcSD8DhCZJ17J5pdFPB7IZ8ZSyf8ysILQYo=;
        b=lf3Z2K9Dj2EU1LC0GUvBClhZoAmEGMKM9mlL/LR61RbKIhIDmKuIV87Gp1s8SmX1xV
         xsDii5Q5b5+moIjFnOx8iD+LVPqRrqXkTyO8rgh8SXe8P/BTVNfND8vwZIYn9LXKTqly
         ilbPhmHus6Lp+fWpi0bH6LlNagC1KEvpneQ+X2mCiUFSZeA+D4mjz3xLdlccmv6l/0gi
         1dD249yknAPZ6gBYPsOS/SEdYC4bSgk4VbpN+qB553Bc06kTdASPlOfUhgVUda134y2K
         tVNOY9C3n8BFj6KClrkuUhbUmTjTPZKDZMMyN2yqrx8Y7jj2ytbem9mIs7c7b5i/fjLH
         OOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=5g7Cux9YIcSD8DhCZJ17J5pdFPB7IZ8ZSyf8ysILQYo=;
        b=3VsObei9pTmMwXq5xWQbpyu/n8DHTYi3jp7M3xfuapv4vp9xvKqdt5IvJLSOIIFm7x
         kK4kz6Pph1n8W7JI7EIb+/tDv9GggZxjQpwYfOK7ArGa7FTycAODLxW4UO7qzefRvA0e
         IiVO7SgRgmZfRMbqD2n6VaBhGd66GeVppvg9lD+TIxq3Rm6FmLGMsTVEkr/B37dvP6C9
         z6koY0Av9IXdhY38NfxwQfb+Uf/OT6+vfslcCS9JppuyQK3i4nlUhn+A9HPulGtRPexg
         GSPZ0RhksMLSj51NPkHEfiqCtgHZvnlMfevhyrKmPaSpuLDIXJHOB9scKyK1tLrNjXdg
         sL+Q==
X-Gm-Message-State: AOAM530bQ1CggqPG7UaDZCrC8e0s7MjWuE/yGL2WMb982L/O6KPmn186
        zQxIJt2i7eowWHSIv1NA2z3N6YWywfNIHyNqzRKcrB1K6UUz/J8FARPjWyyx29/IGVpjOZ8jTGB
        zjOSD7XBDZVEzG6m0jdFzntZR
X-Google-Smtp-Source: ABdhPJwxutZ5NAsxbnqlZHsg5p0xvVhzB6GsRe1p8W/me1iXxwQm7kSFc9+Hd+0FwpBRcubAfE9xHA==
X-Received: by 2002:a05:6000:1ca:b0:1f0:2480:f52a with SMTP id t10-20020a05600001ca00b001f02480f52amr14813865wrx.388.1646824802327;
        Wed, 09 Mar 2022 03:20:02 -0800 (PST)
Received: from 2021-EMEA-0269.home (251.69.14.37.dynamic.jazztel.es. [37.14.69.251])
        by smtp.googlemail.com with ESMTPSA id m18-20020a05600c3b1200b003899d242c3asm4934171wms.44.2022.03.09.03.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 03:20:01 -0800 (PST)
From:   Andrea Tomassetti <andrea.tomassetti@devo.com>
To:     linux-bcache@vger.kernel.org,
        Zhang Zhen <zhangzhen.email@gmail.com>
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Andrea Tomassetti <andrea.tomassetti@devo.com>
Subject: [PATCH] bcache: Add ioctl feature capability to make-bcache
Date:   Wed,  9 Mar 2022 12:14:01 +0100
Message-Id: <20220309111400.267541-1-andrea.tomassetti@devo.com>
X-Mailer: git-send-email 2.25.1
Reply-To: <20220308145623.209625-1-andrea.tomassetti@devo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="ISO-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch contains the least modifications needed
to be able to use the new IOCTL interface introduced
in the bcache module.

Signed-off-by: Andrea Tomassetti <andrea.tomassetti@devo.com>
---
Hi Zhang,
yes you understood it correctly. With this patch you should have
everything to test it locally. This patch is meant to be applied
to the colyli/bcache-tools.git repo. I hope it's fine.

Let me know,
Andrea

 60-bcache.rules |   7 ++
 Makefile        |   4 +-
 bcache-loader   | 107 +++++++++++++++++
 bcache.conf     |   6 +
 make.c          | 313 +++++++++++++++++++++++++++++++-----------------
 5 files changed, 327 insertions(+), 110 deletions(-)
 create mode 100644 60-bcache.rules
 create mode 100644 bcache-loader
 create mode 100644 bcache.conf

diff --git a/60-bcache.rules b/60-bcache.rules
new file mode 100644
index 0000000..f539c75
--- /dev/null
+++ b/60-bcache.rules
@@ -0,0 +1,7 @@
+# /lib/udev/rules.d/60-bcache.rules
+ACTION=3D=3D"remove", GOTO=3D"bcache_end"
+SUBSYSTEM!=3D"block", GOTO=3D"bcache_end"
+
+RUN+=3D"/lib/udev/bcache-loader /dev/$name"
+
+LABEL=3D"bcache_end"
diff --git a/Makefile b/Makefile
index 5496c35..7829a7f 100644
--- a/Makefile
+++ b/Makefile
@@ -10,12 +10,14 @@ all: make-bcache probe-bcache bcache-super-show bcache-=
register bcache
 install: make-bcache probe-bcache bcache-super-show
 	$(INSTALL) -m0755 make-bcache bcache-super-show	bcache $(DESTDIR)${PREFIX=
}/sbin/
 	$(INSTALL) -m0755 bcache-status $(DESTDIR)${PREFIX}/sbin/
-	$(INSTALL) -m0755 probe-bcache bcache-register bcache-export-cached $(DES=
TDIR)$(UDEVLIBDIR)/
+	$(INSTALL) -m0755 probe-bcache bcache-register bcache-export-cached bcach=
e-loader $(DESTDIR)$(UDEVLIBDIR)/
 	$(INSTALL) -m0644 69-bcache.rules	$(DESTDIR)$(UDEVLIBDIR)/rules.d/
 	$(INSTALL) -m0644 -- *.8 $(DESTDIR)${PREFIX}/share/man/man8/
 	$(INSTALL) -D -m0755 initramfs/hook	$(DESTDIR)/usr/share/initramfs-tools/=
hooks/bcache
 	$(INSTALL) -D -m0755 initcpio/install	$(DESTDIR)/usr/lib/initcpio/install=
/bcache
 	$(INSTALL) -D -m0755 dracut/module-setup.sh $(DESTDIR)$(DRACUTLIBDIR)/mod=
ules.d/90bcache/module-setup.sh
+	$(INSTALL) -D -m0644 bcache.conf $(DESTDIR)/etc/bcache/
+	$(INSTALL) -D -m0644 60-bcache.rules $(DESTDIR)$(UDEVLIBDIR)/rules.d/
 #	$(INSTALL) -m0755 bcache-test $(DESTDIR)${PREFIX}/sbin/
=20
 clean:
diff --git a/bcache-loader b/bcache-loader
new file mode 100644
index 0000000..45da7b9
--- /dev/null
+++ b/bcache-loader
@@ -0,0 +1,107 @@
+#!/usr/bin/env python3
+
+from logging import exception
+import subprocess
+import sys
+import os
+import syslog as sl
+from time import sleep
+
+import yaml
+
+
+def device_exists(d):
+    return os.path.exists(d)
+
+
+def device_already_registered(d):
+    device_basename =3D os.path.basename(d)
+    return os.path.exists(f"/sys/block/{device_basename}/bcache/")
+
+
+def get_cache_uuid(c):
+    cache_basename =3D os.path.basename(c)
+    return os.path.basename(os.readlink(f'/sys/block/{cache_basename}/bcac=
he/set'))
+
+
+def register_device(d, dtype):
+    if device_exists(d):
+        if not device_already_registered(d):
+            device_type_opt =3D '-C' if dtype =3D=3D 'cache' else '-B'
+            return subprocess.call(['/usr/sbin/make-bcache', '--ioctl', de=
vice_type_opt, d])
+    else:
+        sl.syslog(sl.LOG_WARNING, f'Device does not exist: {d}')
+
+    return 0
+
+
+def attach_backing_to_cache(bd, cset):
+    backing_basename =3D os.path.basename(bd)
+    try:
+        with open(f'/sys/block/{backing_basename}/bcache/attach', 'w') as =
f:
+            f.write(cset)
+        return 0
+    except Exception as e:
+        sl.syslog(sl.LOG_ERR, f'Unable to attach {bd} to {cset}. Reason: {=
str(e)}')
+        return 1
+
+
+def attach_backing_and_cache(bds, cd):
+
+    cache_set_uuid =3D None
+
+    if register_device(cd, "cache"):
+        sl.syslog(sl.LOG_ERR, f'Error while registering cache device {cd}'=
)
+        return 1
+
+    sl.syslog(sl.LOG_INFO, f'Successfully registered cache device {cd}')
+    sleep(1)  # Wait for the cache device to fully register
+    cache_set_uuid =3D get_cache_uuid(cd)
+
+    for b in bds:
+        if register_device(b, "backing"):
+            sl.syslog(sl.LOG_ERR, f'Error while registering backing device=
 {b} ...')
+            return 1
+
+        sl.syslog(sl.LOG_INFO, f'Successfully registered backing device {b=
}')
+        sleep(1)  # Wait for the backing device to fully register
+        if cache_set_uuid:
+            sl.syslog(sl.LOG_INFO, f'Attaching backing device {b} to cache=
 device {cd} with UUID {cache_set_uuid}')
+            attach_backing_to_cache(b, cache_set_uuid)
+
+    return 0
+
+
+try:
+    subprocess.call(['/sbin/modprobe', 'bcache'])
+except Exception as e:
+    sl.syslog(sl.LOG_ERR, f'Unable to probe custom_bcache module. Reason: =
{str(e)}')
+    exit(1)
+
+try:
+    with open('/etc/bcache/bcache.conf') as f:
+        config =3D yaml.load(f, Loader=3Dyaml.FullLoader)
+except Exception as e:
+    sl.syslog(sl.LOG_ERR, f'Unable to load bcache config. Reason: {str(e)}=
')
+    exit(1)
+
+try:
+
+    for cache in config['cache_devices']:
+        cache_device =3D os.path.realpath(cache['device'])
+
+        # Check if it's a cache device
+        if sys.argv[1] =3D=3D cache_device:
+            sl.syslog(sl.LOG_INFO, f'Managing cache device: {str(sys.argv[=
1])}')
+            backing_devices =3D (b['device'] for b in cache['backing_devic=
es'])
+            attach_backing_and_cache(backing_devices, cache_device)
+        else:
+            # Check if it's a backing device of this cache device
+            for backing in cache['backing_devices']:
+                backing_device =3D os.path.realpath(backing['device'])
+                if sys.argv[1] =3D=3D backing_device:
+                    sl.syslog(sl.LOG_INFO, f'Managing backing device: {str=
(sys.argv[1])}')
+                    attach_backing_and_cache([backing_device], cache_devic=
e)
+except Exception as e:
+    sl.syslog(sl.LOG_ERR, f'Reason: {str(e)}')
+    exit(1)
diff --git a/bcache.conf b/bcache.conf
new file mode 100644
index 0000000..438fc39
--- /dev/null
+++ b/bcache.conf
@@ -0,0 +1,6 @@
+# /etc/bcache/bcache.conf
+cache_devices:
+  - device: /dev/sdc
+    backing_devices:
+      - device: /dev/sdb
+      - device: /dev/sdd
diff --git a/make.c b/make.c
index 52f54c7..5396f34 100644
--- a/make.c
+++ b/make.c
@@ -185,6 +185,7 @@ void usage(void)
 	       "	    --force		reformat a bcache device even if it is running\n"
 	       "	-l, --label		set label for device\n"
 	       "	    --cache_replacement_policy=3D(lru|fifo)\n"
+		   "	    --ioctl		Communicate via IOCTL with the control device\n"
 	       "	-h, --help		display this help and exit\n");
 	exit(EXIT_FAILURE);
 }
@@ -238,22 +239,132 @@ err:
 	return -1;
 }
=20
-static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool fo=
rce)
+static void write_sb_common(char *dev, struct cache_sb *sb, struct sb_cont=
ext *sbc,
+	bool bdev, unsigned long long nbuckets)
 {
-	int fd;
-	char uuid_str[40], set_uuid_str[40], zeroes[SB_START] =3D {0};
-	struct cache_sb_disk sb_disk;
-	struct cache_sb sb;
-	blkid_probe pr;
+	char uuid_str[40], set_uuid_str[40];
 	unsigned int block_size =3D sbc->block_size;
 	unsigned int bucket_size =3D sbc->bucket_size;
-	bool wipe_bcache =3D sbc->wipe_bcache;
 	bool writeback =3D sbc->writeback;
 	bool discard =3D sbc->discard;
 	char *label =3D sbc->label;
 	uint64_t data_offset =3D sbc->data_offset;
 	unsigned int cache_replacement_policy =3D sbc->cache_replacement_policy;
=20
+	memset(sb, 0, sizeof(struct cache_sb));
+
+	sb->offset	=3D SB_SECTOR;
+	sb->version	=3D bdev
+		? BCACHE_SB_VERSION_BDEV
+		: BCACHE_SB_VERSION_CDEV;
+
+	memcpy(sb->magic, bcache_magic, 16);
+	uuid_generate(sb->uuid);
+	memcpy(sb->set_uuid, sbc->set_uuid, sizeof(sb->set_uuid));
+
+	sb->block_size	=3D block_size;
+
+	uuid_unparse(sb->uuid, uuid_str);
+	uuid_unparse(sb->set_uuid, set_uuid_str);
+
+	if (SB_IS_BDEV(sb)) {
+		SET_BDEV_CACHE_MODE(sb, writeback ?
+			CACHE_MODE_WRITEBACK : CACHE_MODE_WRITETHROUGH);
+
+		/*
+		 * Currently bcache does not support writeback mode for
+		 * zoned device as backing device. If the cache mode is
+		 * explicitly set to writeback, automatically convert to
+		 * writethough mode.
+		 */
+		if (is_zoned_device(dev) &&
+		    BDEV_CACHE_MODE(sb) =3D=3D CACHE_MODE_WRITEBACK) {
+			printf("Zoned device %s detected: convert to writethrough mode.\n\n",
+				dev);
+			SET_BDEV_CACHE_MODE(sb, CACHE_MODE_WRITETHROUGH);
+		}
+
+		if (data_offset !=3D BDEV_DATA_START_DEFAULT) {
+			if (sb->version < BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
+				sb->version =3D BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
+			sb->data_offset =3D data_offset;
+		}
+
+		printf("Name			%s\n", dev);
+		printf("Label			%s\n", label);
+		printf("Type			data\n");
+		printf("UUID:			%s\n"
+		       "Set UUID:		%s\n"
+		       "version:		%u\n"
+		       "block_size_in_sectors:	%u\n"
+		       "data_offset_in_sectors:	%ju\n",
+		       uuid_str, set_uuid_str,
+		       (unsigned int) sb->version,
+		       sb->block_size,
+		       data_offset);
+		putchar('\n');
+	} else {
+		set_bucket_size(sb, bucket_size);
+
+		sb->nbuckets		=3D nbuckets;
+		sb->nr_in_set		=3D 1;
+		/* 23 is (SB_SECTOR + SB_SIZE) - 1 sectors */
+		sb->first_bucket		=3D (23 / sb->bucket_size) + 1;
+
+		if (sb->nbuckets < 1 << 7) {
+			fprintf(stderr, "Not enough buckets: %llu, need %u\n",
+			       sb->nbuckets, 1 << 7);
+			exit(EXIT_FAILURE);
+		}
+
+		SET_CACHE_DISCARD(sb, discard);
+		SET_CACHE_REPLACEMENT(sb, cache_replacement_policy);
+
+		printf("Name			%s\n", dev);
+		printf("Label			%s\n", label);
+		printf("Type			cache\n");
+		printf("UUID:			%s\n"
+		       "Set UUID:		%s\n"
+		       "version:		%u\n"
+		       "nbuckets:		%llu\n"
+		       "block_size_in_sectors:	%u\n"
+		       "bucket_size_in_sectors:	%u\n"
+		       "nr_in_set:		%u\n"
+		       "nr_this_dev:		%u\n"
+		       "first_bucket:		%u\n",
+		       uuid_str, set_uuid_str,
+		       (unsigned int) sb->version,
+		       sb->nbuckets,
+		       sb->block_size,
+		       sb->bucket_size,
+		       sb->nr_in_set,
+		       sb->nr_this_dev,
+		       sb->first_bucket);
+
+		putchar('\n');
+	}
+
+	/* write label */
+	int num, i;
+
+	num =3D strlen(sbc->label);
+	for (i =3D 0; i < num; i++)
+		sb->label[i] =3D sbc->label[i];
+	sb->label[i] =3D '\0';
+
+}
+
+static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool fo=
rce)
+{
+	int fd;
+	char zeroes[SB_START] =3D {0};
+	struct cache_sb_disk sb_disk;
+	struct cache_sb sb;
+	blkid_probe pr;
+	uint64_t nbuckets;
+	bool wipe_bcache =3D sbc->wipe_bcache;
+	bool discard =3D sbc->discard;
+
 	fd =3D open(dev, O_RDWR|O_EXCL);
=20
 	if (fd =3D=3D -1) {
@@ -345,111 +456,17 @@ static void write_sb(char *dev, struct sb_context *s=
bc, bool bdev, bool force)
 	}
=20
 	memset(&sb_disk, 0, sizeof(struct cache_sb_disk));
-	memset(&sb, 0, sizeof(struct cache_sb));
-
-	sb.offset	=3D SB_SECTOR;
-	sb.version	=3D bdev
-		? BCACHE_SB_VERSION_BDEV
-		: BCACHE_SB_VERSION_CDEV;
-
-	memcpy(sb.magic, bcache_magic, 16);
-	uuid_generate(sb.uuid);
-	memcpy(sb.set_uuid, sbc->set_uuid, sizeof(sb.set_uuid));
=20
-	sb.block_size	=3D block_size;
+	nbuckets =3D getblocks(fd) / sbc->bucket_size;
=20
-	uuid_unparse(sb.uuid, uuid_str);
-	uuid_unparse(sb.set_uuid, set_uuid_str);
+	write_sb_common(dev, &sb, sbc, bdev, nbuckets);
=20
-	if (SB_IS_BDEV(&sb)) {
-		SET_BDEV_CACHE_MODE(&sb, writeback ?
-			CACHE_MODE_WRITEBACK : CACHE_MODE_WRITETHROUGH);
-
-		/*
-		 * Currently bcache does not support writeback mode for
-		 * zoned device as backing device. If the cache mode is
-		 * explicitly set to writeback, automatically convert to
-		 * writethough mode.
-		 */
-		if (is_zoned_device(dev) &&
-		    BDEV_CACHE_MODE(&sb) =3D=3D CACHE_MODE_WRITEBACK) {
-			printf("Zoned device %s detected: convert to writethrough mode.\n\n",
-				dev);
-			SET_BDEV_CACHE_MODE(&sb, CACHE_MODE_WRITETHROUGH);
-		}
-
-		if (data_offset !=3D BDEV_DATA_START_DEFAULT) {
-			if (sb.version < BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
-				sb.version =3D BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
-			sb.data_offset =3D data_offset;
-		}
-
-		printf("Name			%s\n", dev);
-		printf("Label			%s\n", label);
-		printf("Type			data\n");
-		printf("UUID:			%s\n"
-		       "Set UUID:		%s\n"
-		       "version:		%u\n"
-		       "block_size_in_sectors:	%u\n"
-		       "data_offset_in_sectors:	%ju\n",
-		       uuid_str, set_uuid_str,
-		       (unsigned int) sb.version,
-		       sb.block_size,
-		       data_offset);
-		putchar('\n');
-	} else {
-		set_bucket_size(&sb, bucket_size);
-
-		sb.nbuckets		=3D getblocks(fd) / sb.bucket_size;
-		sb.nr_in_set		=3D 1;
-		/* 23 is (SB_SECTOR + SB_SIZE) - 1 sectors */
-		sb.first_bucket		=3D (23 / sb.bucket_size) + 1;
-
-		if (sb.nbuckets < 1 << 7) {
-			fprintf(stderr, "Not enough buckets: %llu, need %u\n",
-			       sb.nbuckets, 1 << 7);
-			exit(EXIT_FAILURE);
-		}
-
-		SET_CACHE_DISCARD(&sb, discard);
-		SET_CACHE_REPLACEMENT(&sb, cache_replacement_policy);
-
-		printf("Name			%s\n", dev);
-		printf("Label			%s\n", label);
-		printf("Type			cache\n");
-		printf("UUID:			%s\n"
-		       "Set UUID:		%s\n"
-		       "version:		%u\n"
-		       "nbuckets:		%llu\n"
-		       "block_size_in_sectors:	%u\n"
-		       "bucket_size_in_sectors:	%u\n"
-		       "nr_in_set:		%u\n"
-		       "nr_this_dev:		%u\n"
-		       "first_bucket:		%u\n",
-		       uuid_str, set_uuid_str,
-		       (unsigned int) sb.version,
-		       sb.nbuckets,
-		       sb.block_size,
-		       sb.bucket_size,
-		       sb.nr_in_set,
-		       sb.nr_this_dev,
-		       sb.first_bucket);
-
-		/* Attempting to discard cache device
-		 */
+	if (!SB_IS_BDEV(&sb)) {
+		/* Attempting to discard cache device */
 		if (discard)
 			blkdiscard_all(dev, fd);
-		putchar('\n');
 	}
=20
-	/* write label */
-	int num, i;
-
-	num =3D strlen(label);
-	for (i =3D 0; i < num; i++)
-		sb.label[i] =3D label[i];
-	sb.label[i] =3D '\0';
-
 	/*
 	 * Swap native bytes order to little endian for writing
 	 * the super block out.
@@ -473,6 +490,76 @@ static void write_sb(char *dev, struct sb_context *sbc=
, bool bdev, bool force)
 	close(fd);
 }
=20
+// TODO(atom): Move it to common header file
+struct bch_register_device {
+	const char *dev_name;
+	size_t size;
+	struct cache_sb *sb;
+};
+
+#define BCH_IOCTL_MAGIC (0xBC)
+
+/** Start new cache instance, load cache or recover cache */
+#define BCH_IOCTL_REGISTER_DEVICE	_IOWR(BCH_IOCTL_MAGIC, 1, struct bch_reg=
ister_device)
+
+#define CUSTOM_BCACHE_CTRL_DEV "/dev/bcache_ctrl"
+
+static void write_sb_ioctl(char *dev, struct sb_context *sbc, bool bdev, b=
ool force)
+{
+	int fd;
+	uint64_t dev_blocks;
+
+	struct bch_register_device cmd;
+	struct stat query_core;
+
+	/* Check if core device provided is valid */
+	fd =3D open(dev, 0);
+	if (fd < 0) {
+		fprintf(stderr, "Device %s not found.\n", dev);
+		exit(EXIT_FAILURE);
+	}
+
+	dev_blocks =3D getblocks(fd);
+
+	close(fd);
+
+	/* Check if the core device is a block device or a file */
+	if (stat(dev, &query_core)) {
+		fprintf(stderr, "Could not stat target core device %s!\n", dev);
+		exit(EXIT_FAILURE);
+	}
+
+	if (!S_ISBLK(query_core.st_mode)) {
+		fprintf(stderr, "Core object %s is not supported!\n", dev);
+		exit(EXIT_FAILURE);
+	}
+
+	fd =3D open(CUSTOM_BCACHE_CTRL_DEV, 0);
+	if (fd < 0) {
+		fprintf(stderr, "Unable to open " CUSTOM_BCACHE_CTRL_DEV ": %s\n", strer=
ror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	memset(&cmd, 0, sizeof(cmd));
+
+	cmd.sb =3D malloc(sizeof(struct cache_sb));
+
+	cmd.dev_name =3D strdup(dev);
+	cmd.size =3D strlen(cmd.dev_name) + 1;
+
+	write_sb_common(dev, cmd.sb, sbc, bdev, dev_blocks/sbc->bucket_size);
+
+	if (ioctl(fd, BCH_IOCTL_REGISTER_DEVICE, &cmd) < 0) {
+		fprintf(stderr, "Error during ioctl operation: %s\n", strerror(errno));
+		free(cmd.sb);
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+
+	free(cmd.sb);
+	close(fd);
+}
+
 static unsigned int get_blocksize(const char *path)
 {
 	struct stat statbuf;
@@ -523,7 +610,7 @@ int make_bcache(int argc, char **argv)
 	char *backing_devices[argc];
 	char label[SB_LABEL_SIZE] =3D { 0 };
 	unsigned int block_size =3D 0, bucket_size =3D 1024;
-	int writeback =3D 0, discard =3D 0, wipe_bcache =3D 0, force =3D 0;
+	int writeback =3D 0, discard =3D 0, wipe_bcache =3D 0, force =3D 0, use_i=
octl =3D 0;
 	unsigned int cache_replacement_policy =3D 0;
 	uint64_t data_offset =3D BDEV_DATA_START_DEFAULT;
 	uuid_t set_uuid;
@@ -547,6 +634,7 @@ int make_bcache(int argc, char **argv)
 		{ "help",		0, NULL,	'h' },
 		{ "force",		0, &force,	 1 },
 		{ "label",		1, NULL,	 'l' },
+		{ "ioctl",		0, &use_ioctl,	1},
 		{ NULL,			0, NULL,	0 },
 	};
=20
@@ -654,14 +742,21 @@ int make_bcache(int argc, char **argv)
 	memcpy(sbc.set_uuid, set_uuid, sizeof(sbc.set_uuid));
 	sbc.label =3D label;
=20
-	for (i =3D 0; i < ncache_devices; i++)
+	for (i =3D 0; i < ncache_devices; i++) {
+		if (use_ioctl) {
+			fprintf(stderr, "WARNING. Cache devices should use the normal way!\n");
+		}
 		write_sb(cache_devices[i], &sbc, false, force);
+	}
=20
 	for (i =3D 0; i < nbacking_devices; i++) {
 		check_data_offset_for_zoned_device(backing_devices[i],
 						   &sbc.data_offset);
-
-		write_sb(backing_devices[i], &sbc, true, force);
+		if (use_ioctl) {
+			write_sb_ioctl(backing_devices[i], &sbc, true, force);
+		} else {
+			write_sb(backing_devices[i], &sbc, true, force);
+		}
 	}
=20
 	return 0;
--=20
2.25.1


--=20







The contents of this email are confidential. If the reader of this=20
message is not the intended recipient, you are hereby notified that any=20
dissemination, distribution or copying of this communication is strictly=20
prohibited. If you have received this communication in error, please notify=
=20
us immediately by replying to this message and deleting it from your=20
computer. Thank you.=A0Devo, Inc; arco@devo.com <mailto:arco@devo.com>;=A0=
=A0
Calle Est=E9banez Calder=F3n 3-5, 5th Floor. Madrid, Spain 28020

