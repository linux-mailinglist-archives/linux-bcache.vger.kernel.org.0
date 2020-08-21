Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CC024D833
	for <lists+linux-bcache@lfdr.de>; Fri, 21 Aug 2020 17:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgHUPOS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 Aug 2020 11:14:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:38386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbgHUPOH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 Aug 2020 11:14:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9D7B9AF45;
        Fri, 21 Aug 2020 15:14:28 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH] bcache: doc: update Documentation/admin-guide/bcache.rst
Date:   Fri, 21 Aug 2020 23:13:54 +0800
Message-Id: <20200821151354.16727-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

bcache.rst is from the original bcache.txt which was merged in mainline
kernel v3.10. There are a few things changed in the past 7 years. This
patch updates bache.rst documents in following content,
- Update bcache-tools git repo to,
  https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/
- Update bcache kernel tree to mainline kernel tree,
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
- make-bcache util is replaced by the unified bcache util,
  `make-bcache` now can be performed by `bcache make`

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
---
 Documentation/admin-guide/bcache.rst | 31 +++++++++++++++++-----------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/bcache.rst b/Documentation/admin-guide/bcache.rst
index 1eccf952876d..8d3a2d045c0a 100644
--- a/Documentation/admin-guide/bcache.rst
+++ b/Documentation/admin-guide/bcache.rst
@@ -5,11 +5,14 @@ A block layer cache (bcache)
 Say you've got a big slow raid 6, and an ssd or three. Wouldn't it be
 nice if you could use them as cache... Hence bcache.
 
-Wiki and git repositories are at:
+The bcache wiki can be found at:
+  https://bcache.evilpiepirate.org
 
-  - https://bcache.evilpiepirate.org
-  - http://evilpiepirate.org/git/linux-bcache.git
-  - https://evilpiepirate.org/git/bcache-tools.git
+This is the git repository of bcache-tools:
+  https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/
+
+The latest bcache kernel code can be found from mainline Linux kernel:
+  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
 
 It's designed around the performance characteristics of SSDs - it only allocates
 in erase block sized buckets, and it uses a hybrid btree/log to track cached
@@ -41,17 +44,21 @@ in the cache it first disables writeback caching and waits for all dirty data
 to be flushed.
 
 Getting started:
-You'll need make-bcache from the bcache-tools repository. Both the cache device
+You'll need bcache util from the bcache-tools repository. Both the cache device
 and backing device must be formatted before use::
 
-  make-bcache -B /dev/sdb
-  make-bcache -C /dev/sdc
+  bcache make -B /dev/sdb
+  bcache make -C /dev/sdc
 
-make-bcache has the ability to format multiple devices at the same time - if
+`bcache make` has the ability to format multiple devices at the same time - if
 you format your backing devices and cache device at the same time, you won't
 have to manually attach::
 
-  make-bcache -B /dev/sda /dev/sdb -C /dev/sdc
+  bcache make -B /dev/sda /dev/sdb -C /dev/sdc
+
+If your bcache-tools is not updated to latest version and does not have the
+unified `bcache` utility, you may use the legacy `make-bcache` utility to format
+bcache device with same -B and -C parameters.
 
 bcache-tools now ships udev rules, and bcache devices are known to the kernel
 immediately.  Without udev, you can manually register devices like this::
@@ -188,7 +195,7 @@ D) Recovering data without bcache:
 If bcache is not available in the kernel, a filesystem on the backing
 device is still available at an 8KiB offset. So either via a loopdev
 of the backing device created with --offset 8K, or any value defined by
---data-offset when you originally formatted bcache with `make-bcache`.
+--data-offset when you originally formatted bcache with `bcache make`.
 
 For example::
 
@@ -210,7 +217,7 @@ E) Wiping a cache device
 
 After you boot back with bcache enabled, you recreate the cache and attach it::
 
-	host:~# make-bcache -C /dev/sdh2
+	host:~# bcache make -C /dev/sdh2
 	UUID:                   7be7e175-8f4c-4f99-94b2-9c904d227045
 	Set UUID:               5bc072a8-ab17-446d-9744-e247949913c1
 	version:                0
@@ -318,7 +325,7 @@ want for getting the best possible numbers when benchmarking.
 
    The default metadata size in bcache is 8k.  If your backing device is
    RAID based, then be sure to align this by a multiple of your stride
-   width using `make-bcache --data-offset`. If you intend to expand your
+   width using `bcache make --data-offset`. If you intend to expand your
    disk array in the future, then multiply a series of primes by your
    raid stripe size to get the disk multiples that you would like.
 
-- 
2.26.2

