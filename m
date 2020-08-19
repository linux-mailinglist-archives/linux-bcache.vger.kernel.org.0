Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE47C249B37
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Aug 2020 12:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgHSKwI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 19 Aug 2020 06:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbgHSKvq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Aug 2020 06:51:46 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD5FC061349
        for <linux-bcache@vger.kernel.org>; Wed, 19 Aug 2020 03:51:38 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id x6so11202970pgx.12
        for <linux-bcache@vger.kernel.org>; Wed, 19 Aug 2020 03:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=SDR0t7Rqf/6fbKmybT7NGgxnhIG5UxonWcpFTUCWyDM=;
        b=L7+98Mege8uYdFMaBAHs87wyHZ7Erd+2RhMyRWqCvJXfyEqFGPB7x0eJk9vE3YMV97
         nGpMBWMW/Bn9gzJv4iGehahdSPfPmjjJllG08hL+BCZHuPDa8bxRuClePpq3xENEDoLC
         7JNZ+sVZZ+GTXIHS1ebTpcRfrY6tUbJOscPUL1i/+St9LnWEjUiviu62mVWufSbbUDUJ
         /3f90jIFLpcAMF6PqyGaGLL8UQ0cQUTfgVZ0wtngDyMWmPOEjAeQ2mBrxP6kMyBB54RU
         GCHefvfwC/LmjtxgZfSH0FSRE6OTDp3Wsi/FGvXNziGGpCFxL+BwXPgMRyq3AuuX8Grf
         WRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=SDR0t7Rqf/6fbKmybT7NGgxnhIG5UxonWcpFTUCWyDM=;
        b=AfImDa2+7tu2bgor4QN2nkjVLb3CHSFhTrS/a+QyQHsBfnrynvY0EDban2zrW4ylHV
         pahYUqhLUBXVFYPswj89G/PywJpf9z6Gfd5vUjno3mgkrHvCZoFhDaVVa4nmaXSN8r/r
         3x1jEgWBIr7d415GTRP3lGgrkYcf+OYI9ImzD5uT6UCRE4Bslhv8kpnOsCuvn6K2aqid
         Qq5FKQPN9NFaEkMb3kaAn4aQxMpBXaXvIQbnynxOCswJyZCKyY9x/qYPW3JfChBX/3CD
         NkYlcdU7gFncKPWxM+FAL8ysjcDZxWSoFrtri9G1Yu84JZvBukcj4qWWqtxMM8M0Xuoz
         J5ZQ==
X-Gm-Message-State: AOAM53201ue+xr42H8qd8UKikZFqISO73/W2gMMtYkWfJlyiOU2PwN3y
        QiiMRjWP5vX3lvKYwTtPxesm5CkSI/Zp2VzJ
X-Google-Smtp-Source: ABdhPJzvhQ3z+IXmOvndcro4jQUeyKhYa0Jh8laPYKX/tXDLhOtopXn4mjIgzQDNBcA+2fwD5JMHpg==
X-Received: by 2002:a65:5849:: with SMTP id s9mr17074155pgr.145.1597834293077;
        Wed, 19 Aug 2020 03:51:33 -0700 (PDT)
Received: from gmail.com ([119.8.124.38])
        by smtp.gmail.com with ESMTPSA id k21sm24844830pgl.0.2020.08.19.03.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 03:51:32 -0700 (PDT)
From:   Shaoxiong Li <dahefanteng@gmail.com>
To:     linux-bcache@vger.kernel.org
Cc:     colyli@suse.de, Ryan Harper <ryan.harper@canonical.com>
Subject: [PATCH 2/3] bcache-tools: Export CACHED_UUID and CACHED_LABEL
Date:   Wed, 19 Aug 2020 18:51:27 +0800
Message-Id: <a2ff85c43ac0f9b8e93563fc98d02e0e08f8b770.1597817961.git.dahefanteng@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <a6b9fc134e5dd73d1a6f3945fd649d7aa23cff9e.1597817961.git.dahefanteng@gmail.com>
References: <a6b9fc134e5dd73d1a6f3945fd649d7aa23cff9e.1597817961.git.dahefanteng@gmail.com>
In-Reply-To: <a6b9fc134e5dd73d1a6f3945fd649d7aa23cff9e.1597817961.git.dahefanteng@gmail.com>
References: <a6b9fc134e5dd73d1a6f3945fd649d7aa23cff9e.1597817961.git.dahefanteng@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Ryan Harper <ryan.harper@canonical.com>

https://github.com/koverstreet/bcache-tools/pull/1

Add bcache-export-cached helper to export CACHED_UUID and CACHED_LABEL always

Linux kernel bcache driver does not always emit a uevent[1] for when
a backing device is bound to a bcacheN device.  When this happens, the udev
rule for creating /dev/bcache/by-uuid or /dev/bcache/by-label symlinks does
not fire and removes any persistent symlink to a specific backing device
since the bcache minor numbers (bcache0, 1, 2) are not guaranteed across reboots.

This script reads the superblock of the bcache device slaves,ensuring the slave
is a backing device via sb.version check, extracts the dev.uuid and
dev.label values and exports them to udev for triggering the symlink rules in
the existing rules file.

1. https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1729145

Signed-off-by: Shaoxiong Li <dahefanteng@gmail.com>
---
 69-bcache.rules      |  7 +++----
 Makefile             |  2 +-
 bcache-export-cached | 31 +++++++++++++++++++++++++++++++
 initcpio/install     |  1 +
 initramfs/hook       |  1 +
 5 files changed, 37 insertions(+), 5 deletions(-)
 create mode 100644 bcache-export-cached

diff --git a/69-bcache.rules b/69-bcache.rules
index 9cc7f0d..fd25f5b 100644
--- a/69-bcache.rules
+++ b/69-bcache.rules
@@ -23,10 +23,9 @@ RUN+="bcache-register $tempnode"
 LABEL="bcache_backing_end"
 
 # Cached devices: symlink
-DRIVER=="bcache", ENV{CACHED_UUID}=="?*", \
-        SYMLINK+="bcache/by-uuid/$env{CACHED_UUID}"
-DRIVER=="bcache", ENV{CACHED_LABEL}=="?*", \
-        SYMLINK+="bcache/by-label/$env{CACHED_LABEL}"
+IMPORT{program}="bcache-export-cached $tempnode"
+ENV{CACHED_UUID}=="?*", SYMLINK+="bcache/by-uuid/$env{CACHED_UUID}"
+ENV{CACHED_LABEL}=="?*", SYMLINK+="bcache/by-label/$env{CACHED_LABEL}"
 
 LABEL="bcache_end"
 
diff --git a/Makefile b/Makefile
index 8b87a67..90db951 100644
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,7 @@ all: make-bcache probe-bcache bcache-super-show bcache-register bcache
 
 install: make-bcache probe-bcache bcache-super-show
 	$(INSTALL) -m0755 make-bcache bcache-super-show	bcache $(DESTDIR)${PREFIX}/sbin/
-	$(INSTALL) -m0755 probe-bcache bcache-register		$(DESTDIR)$(UDEVLIBDIR)/
+	$(INSTALL) -m0755 probe-bcache bcache-register bcache-export-cached $(DESTDIR)$(UDEVLIBDIR)/
 	$(INSTALL) -m0644 69-bcache.rules	$(DESTDIR)$(UDEVLIBDIR)/rules.d/
 	$(INSTALL) -m0644 -- *.8 $(DESTDIR)${PREFIX}/share/man/man8/
 	$(INSTALL) -D -m0755 initramfs/hook	$(DESTDIR)/usr/share/initramfs-tools/hooks/bcache
diff --git a/bcache-export-cached b/bcache-export-cached
new file mode 100644
index 0000000..b345922
--- /dev/null
+++ b/bcache-export-cached
@@ -0,0 +1,31 @@
+#!/bin/sh
+#
+# This program reads the bcache superblock on bcacheX slaves to extract the
+# dev.uuid and dev.label which refer to a specific backing device.
+#
+# It integrates with udev 'import' by writing CACHED_UUID=X and optionally
+# CACHED_LABEL=X for the backing device of the provided bcache device.
+# Ignore caching devices by skipping unless sb.version=1
+#
+# There is 1 and only 1 backing device (slaves/*) for a bcache device.
+
+TEMPNODE=${1}  # /dev/bcacheN
+DEVNAME=${TEMPNODE##*/}  # /dev/bcacheN -> bcacheN
+
+for slave in "/sys/class/block/$DEVNAME/slaves"/*; do
+    [ -d "$slave" ] || continue
+    bcache-super-show "/dev/${slave##*/}" |
+       awk '$1 == "sb.version" { sbver=$2; }
+            $1 == "dev.uuid" { uuid=$2; }
+            $1 == "dev.label" && $2 != "(empty)" { label=$2; }
+            END {
+                if (sbver == 1 && uuid) {
+                    print("CACHED_UUID=" uuid)
+                    if (label) print("CACHED_LABEL=" label)
+                    exit(0)
+                }
+                exit(1);
+            }'
+    # awk exits 0 if it found a backing device.
+    [ $? -eq 0 ] && exit 0
+done
diff --git a/initcpio/install b/initcpio/install
index 72d4231..c1a86fe 100755
--- a/initcpio/install
+++ b/initcpio/install
@@ -1,6 +1,7 @@
 #!/bin/bash
 build() {
     add_module bcache
+    add_binary /usr/lib/udev/bcache-export-cached
     add_binary /usr/lib/udev/bcache-register
     add_binary /usr/lib/udev/probe-bcache
     add_file /usr/lib/udev/rules.d/69-bcache.rules
diff --git a/initramfs/hook b/initramfs/hook
index a6baa24..485491d 100755
--- a/initramfs/hook
+++ b/initramfs/hook
@@ -22,6 +22,7 @@ elif [ -e /lib/udev/rules.d/69-bcache.rules ]; then
     cp -pt "${DESTDIR}/lib/udev/rules.d" /lib/udev/rules.d/69-bcache.rules
 fi
 
+copy_exec /lib/udev/bcache-export-cached
 copy_exec /lib/udev/bcache-register
 copy_exec /lib/udev/probe-bcache
 manual_add_modules bcache
-- 
2.17.1

