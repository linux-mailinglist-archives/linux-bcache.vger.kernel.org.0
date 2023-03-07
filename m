Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB806ADBA4
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Mar 2023 11:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjCGKTE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 7 Mar 2023 05:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCGKTD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Mar 2023 05:19:03 -0500
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33DA367FB
        for <linux-bcache@vger.kernel.org>; Tue,  7 Mar 2023 02:18:58 -0800 (PST)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id 27B8C62035D;
        Tue,  7 Mar 2023 18:18:54 +0800 (CST)
From:   mingzhe <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, bcache@lists.ewheeler.net,
        andrea.tomassetti-opensource@devo.com
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: [PATCH v6 1/3] bcache: add dirty_data in struct bcache_device
Date:   Tue,  7 Mar 2023 18:18:40 +0800
Message-Id: <20230307101842.2450-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.39.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaHRkdVh4dTU8fH0MaGENOGVUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKQ1VKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oi46UTo4EjJKTzdPHjgOFBww
        HisaCk9VSlVKTUxDSkNPSEhPQ05LVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSUJCTEI3Bg++
X-HM-Tid: 0a86bb94c3fb00a4kurm27b8c62035d
X-HM-MType: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Currently, the dirty_data of cached_dev and flash_dev depend on the stripe.

Since the flash device supports resize, it may cause a bug (resize the flash
from 1T to 2T, and nr_stripes from 1 to 2).

The patch add dirty_data in struct bcache_device, we can get the value of
dirty_data quickly and fixes the bug of resize flash device.

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/Kconfig            | 655 ----------------------------------
 drivers/md/Makefile           | 114 ------
 drivers/md/bcache/bcache.h    |   1 +
 drivers/md/bcache/writeback.c |   2 +
 drivers/md/bcache/writeback.h |   7 +-
 5 files changed, 4 insertions(+), 775 deletions(-)
 delete mode 100644 drivers/md/Kconfig
 delete mode 100644 drivers/md/Makefile

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
deleted file mode 100644
index 5f1e2593fad7..000000000000
--- a/drivers/md/Kconfig
+++ /dev/null
@@ -1,655 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-#
-# Block device driver configuration
-#
-
-menuconfig MD
-	bool "Multiple devices driver support (RAID and LVM)"
-	depends on BLOCK
-	help
-	  Support multiple physical spindles through a single logical device.
-	  Required for RAID and logical volume management.
-
-if MD
-
-config BLK_DEV_MD
-	tristate "RAID support"
-	select BLOCK_HOLDER_DEPRECATED if SYSFS
-	help
-	  This driver lets you combine several hard disk partitions into one
-	  logical block device. This can be used to simply append one
-	  partition to another one or to combine several redundant hard disks
-	  into a RAID1/4/5 device so as to provide protection against hard
-	  disk failures. This is called "Software RAID" since the combining of
-	  the partitions is done by the kernel. "Hardware RAID" means that the
-	  combining is done by a dedicated controller; if you have such a
-	  controller, you do not need to say Y here.
-
-	  More information about Software RAID on Linux is contained in the
-	  Software RAID mini-HOWTO, available from
-	  <https://www.tldp.org/docs.html#howto>. There you will also learn
-	  where to get the supporting user space utilities raidtools.
-
-	  If unsure, say N.
-
-config MD_AUTODETECT
-	bool "Autodetect RAID arrays during kernel boot"
-	depends on BLK_DEV_MD=y
-	default y
-	help
-	  If you say Y here, then the kernel will try to autodetect raid
-	  arrays as part of its boot process.
-
-	  If you don't use raid and say Y, this autodetection can cause
-	  a several-second delay in the boot time due to various
-	  synchronisation steps that are part of this step.
-
-	  If unsure, say Y.
-
-config MD_LINEAR
-	tristate "Linear (append) mode (deprecated)"
-	depends on BLK_DEV_MD
-	help
-	  If you say Y here, then your multiple devices driver will be able to
-	  use the so-called linear mode, i.e. it will combine the hard disk
-	  partitions by simply appending one to the other.
-
-	  To compile this as a module, choose M here: the module
-	  will be called linear.
-
-	  If unsure, say Y.
-
-config MD_RAID0
-	tristate "RAID-0 (striping) mode"
-	depends on BLK_DEV_MD
-	help
-	  If you say Y here, then your multiple devices driver will be able to
-	  use the so-called raid0 mode, i.e. it will combine the hard disk
-	  partitions into one logical device in such a fashion as to fill them
-	  up evenly, one chunk here and one chunk there. This will increase
-	  the throughput rate if the partitions reside on distinct disks.
-
-	  Information about Software RAID on Linux is contained in the
-	  Software-RAID mini-HOWTO, available from
-	  <https://www.tldp.org/docs.html#howto>. There you will also
-	  learn where to get the supporting user space utilities raidtools.
-
-	  To compile this as a module, choose M here: the module
-	  will be called raid0.
-
-	  If unsure, say Y.
-
-config MD_RAID1
-	tristate "RAID-1 (mirroring) mode"
-	depends on BLK_DEV_MD
-	help
-	  A RAID-1 set consists of several disk drives which are exact copies
-	  of each other.  In the event of a mirror failure, the RAID driver
-	  will continue to use the operational mirrors in the set, providing
-	  an error free MD (multiple device) to the higher levels of the
-	  kernel.  In a set with N drives, the available space is the capacity
-	  of a single drive, and the set protects against a failure of (N - 1)
-	  drives.
-
-	  Information about Software RAID on Linux is contained in the
-	  Software-RAID mini-HOWTO, available from
-	  <https://www.tldp.org/docs.html#howto>.  There you will also
-	  learn where to get the supporting user space utilities raidtools.
-
-	  If you want to use such a RAID-1 set, say Y.  To compile this code
-	  as a module, choose M here: the module will be called raid1.
-
-	  If unsure, say Y.
-
-config MD_RAID10
-	tristate "RAID-10 (mirrored striping) mode"
-	depends on BLK_DEV_MD
-	help
-	  RAID-10 provides a combination of striping (RAID-0) and
-	  mirroring (RAID-1) with easier configuration and more flexible
-	  layout.
-	  Unlike RAID-0, but like RAID-1, RAID-10 requires all devices to
-	  be the same size (or at least, only as much as the smallest device
-	  will be used).
-	  RAID-10 provides a variety of layouts that provide different levels
-	  of redundancy and performance.
-
-	  RAID-10 requires mdadm-1.7.0 or later, available at:
-
-	  https://www.kernel.org/pub/linux/utils/raid/mdadm/
-
-	  If unsure, say Y.
-
-config MD_RAID456
-	tristate "RAID-4/RAID-5/RAID-6 mode"
-	depends on BLK_DEV_MD
-	select RAID6_PQ
-	select LIBCRC32C
-	select ASYNC_MEMCPY
-	select ASYNC_XOR
-	select ASYNC_PQ
-	select ASYNC_RAID6_RECOV
-	help
-	  A RAID-5 set of N drives with a capacity of C MB per drive provides
-	  the capacity of C * (N - 1) MB, and protects against a failure
-	  of a single drive. For a given sector (row) number, (N - 1) drives
-	  contain data sectors, and one drive contains the parity protection.
-	  For a RAID-4 set, the parity blocks are present on a single drive,
-	  while a RAID-5 set distributes the parity across the drives in one
-	  of the available parity distribution methods.
-
-	  A RAID-6 set of N drives with a capacity of C MB per drive
-	  provides the capacity of C * (N - 2) MB, and protects
-	  against a failure of any two drives. For a given sector
-	  (row) number, (N - 2) drives contain data sectors, and two
-	  drives contains two independent redundancy syndromes.  Like
-	  RAID-5, RAID-6 distributes the syndromes across the drives
-	  in one of the available parity distribution methods.
-
-	  Information about Software RAID on Linux is contained in the
-	  Software-RAID mini-HOWTO, available from
-	  <https://www.tldp.org/docs.html#howto>. There you will also
-	  learn where to get the supporting user space utilities raidtools.
-
-	  If you want to use such a RAID-4/RAID-5/RAID-6 set, say Y.  To
-	  compile this code as a module, choose M here: the module
-	  will be called raid456.
-
-	  If unsure, say Y.
-
-config MD_MULTIPATH
-	tristate "Multipath I/O support (deprecated)"
-	depends on BLK_DEV_MD
-	help
-	  MD_MULTIPATH provides a simple multi-path personality for use
-	  the MD framework.  It is not under active development.  New
-	  projects should consider using DM_MULTIPATH which has more
-	  features and more testing.
-
-	  If unsure, say N.
-
-config MD_FAULTY
-	tristate "Faulty test module for MD (deprecated)"
-	depends on BLK_DEV_MD
-	help
-	  The "faulty" module allows for a block device that occasionally returns
-	  read or write errors.  It is useful for testing.
-
-	  In unsure, say N.
-
-
-config MD_CLUSTER
-	tristate "Cluster Support for MD"
-	depends on BLK_DEV_MD
-	depends on DLM
-	default n
-	help
-	Clustering support for MD devices. This enables locking and
-	synchronization across multiple systems on the cluster, so all
-	nodes in the cluster can access the MD devices simultaneously.
-
-	This brings the redundancy (and uptime) of RAID levels across the
-	nodes of the cluster. Currently, it can work with raid1 and raid10
-	(limited support).
-
-	If unsure, say N.
-
-source "drivers/md/bcache/Kconfig"
-
-config BLK_DEV_DM_BUILTIN
-	bool
-
-config BLK_DEV_DM
-	tristate "Device mapper support"
-	select BLOCK_HOLDER_DEPRECATED if SYSFS
-	select BLK_DEV_DM_BUILTIN
-	select BLK_MQ_STACKING
-	depends on DAX || DAX=n
-	help
-	  Device-mapper is a low level volume manager.  It works by allowing
-	  people to specify mappings for ranges of logical sectors.  Various
-	  mapping types are available, in addition people may write their own
-	  modules containing custom mappings if they wish.
-
-	  Higher level volume managers such as LVM2 use this driver.
-
-	  To compile this as a module, choose M here: the module will be
-	  called dm-mod.
-
-	  If unsure, say N.
-
-config DM_DEBUG
-	bool "Device mapper debugging support"
-	depends on BLK_DEV_DM
-	help
-	  Enable this for messages that may help debug device-mapper problems.
-
-	  If unsure, say N.
-
-config DM_BUFIO
-       tristate
-       depends on BLK_DEV_DM
-	help
-	 This interface allows you to do buffered I/O on a device and acts
-	 as a cache, holding recently-read blocks in memory and performing
-	 delayed writes.
-
-config DM_DEBUG_BLOCK_MANAGER_LOCKING
-       bool "Block manager locking"
-       depends on DM_BUFIO
-	help
-	 Block manager locking can catch various metadata corruption issues.
-
-	 If unsure, say N.
-
-config DM_DEBUG_BLOCK_STACK_TRACING
-       bool "Keep stack trace of persistent data block lock holders"
-       depends on STACKTRACE_SUPPORT && DM_DEBUG_BLOCK_MANAGER_LOCKING
-       select STACKTRACE
-	help
-	 Enable this for messages that may help debug problems with the
-	 block manager locking used by thin provisioning and caching.
-
-	 If unsure, say N.
-
-config DM_BIO_PRISON
-       tristate
-       depends on BLK_DEV_DM
-	help
-	 Some bio locking schemes used by other device-mapper targets
-	 including thin provisioning.
-
-source "drivers/md/persistent-data/Kconfig"
-
-config DM_UNSTRIPED
-       tristate "Unstriped target"
-       depends on BLK_DEV_DM
-	help
-	  Unstripes I/O so it is issued solely on a single drive in a HW
-	  RAID0 or dm-striped target.
-
-config DM_CRYPT
-	tristate "Crypt target support"
-	depends on BLK_DEV_DM
-	depends on (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
-	depends on (TRUSTED_KEYS || TRUSTED_KEYS=n)
-	select CRYPTO
-	select CRYPTO_CBC
-	select CRYPTO_ESSIV
-	help
-	  This device-mapper target allows you to create a device that
-	  transparently encrypts the data on it. You'll need to activate
-	  the ciphers you're going to use in the cryptoapi configuration.
-
-	  For further information on dm-crypt and userspace tools see:
-	  <https://gitlab.com/cryptsetup/cryptsetup/wikis/DMCrypt>
-
-	  To compile this code as a module, choose M here: the module will
-	  be called dm-crypt.
-
-	  If unsure, say N.
-
-config DM_SNAPSHOT
-       tristate "Snapshot target"
-       depends on BLK_DEV_DM
-       select DM_BUFIO
-	help
-	 Allow volume managers to take writable snapshots of a device.
-
-config DM_THIN_PROVISIONING
-       tristate "Thin provisioning target"
-       depends on BLK_DEV_DM
-       select DM_PERSISTENT_DATA
-       select DM_BIO_PRISON
-	help
-	 Provides thin provisioning and snapshots that share a data store.
-
-config DM_CACHE
-       tristate "Cache target (EXPERIMENTAL)"
-       depends on BLK_DEV_DM
-       default n
-       select DM_PERSISTENT_DATA
-       select DM_BIO_PRISON
-	help
-	 dm-cache attempts to improve performance of a block device by
-	 moving frequently used data to a smaller, higher performance
-	 device.  Different 'policy' plugins can be used to change the
-	 algorithms used to select which blocks are promoted, demoted,
-	 cleaned etc.  It supports writeback and writethrough modes.
-
-config DM_CACHE_SMQ
-       tristate "Stochastic MQ Cache Policy (EXPERIMENTAL)"
-       depends on DM_CACHE
-       default y
-	help
-	 A cache policy that uses a multiqueue ordered by recent hits
-	 to select which blocks should be promoted and demoted.
-	 This is meant to be a general purpose policy.  It prioritises
-	 reads over writes.  This SMQ policy (vs MQ) offers the promise
-	 of less memory utilization, improved performance and increased
-	 adaptability in the face of changing workloads.
-
-config DM_WRITECACHE
-	tristate "Writecache target"
-	depends on BLK_DEV_DM
-	help
-	   The writecache target caches writes on persistent memory or SSD.
-	   It is intended for databases or other programs that need extremely
-	   low commit latency.
-
-	   The writecache target doesn't cache reads because reads are supposed
-	   to be cached in standard RAM.
-
-config DM_EBS
-	tristate "Emulated block size target (EXPERIMENTAL)"
-	depends on BLK_DEV_DM && !HIGHMEM
-	select DM_BUFIO
-	help
-	  dm-ebs emulates smaller logical block size on backing devices
-	  with larger ones (e.g. 512 byte sectors on 4K native disks).
-
-config DM_ERA
-       tristate "Era target (EXPERIMENTAL)"
-       depends on BLK_DEV_DM
-       default n
-       select DM_PERSISTENT_DATA
-       select DM_BIO_PRISON
-	help
-	 dm-era tracks which parts of a block device are written to
-	 over time.  Useful for maintaining cache coherency when using
-	 vendor snapshots.
-
-config DM_CLONE
-       tristate "Clone target (EXPERIMENTAL)"
-       depends on BLK_DEV_DM
-       default n
-       select DM_PERSISTENT_DATA
-	help
-	 dm-clone produces a one-to-one copy of an existing, read-only source
-	 device into a writable destination device. The cloned device is
-	 visible/mountable immediately and the copy of the source device to the
-	 destination device happens in the background, in parallel with user
-	 I/O.
-
-	 If unsure, say N.
-
-config DM_MIRROR
-       tristate "Mirror target"
-       depends on BLK_DEV_DM
-	help
-	 Allow volume managers to mirror logical volumes, also
-	 needed for live data migration tools such as 'pvmove'.
-
-config DM_LOG_USERSPACE
-	tristate "Mirror userspace logging"
-	depends on DM_MIRROR && NET
-	select CONNECTOR
-	help
-	  The userspace logging module provides a mechanism for
-	  relaying the dm-dirty-log API to userspace.  Log designs
-	  which are more suited to userspace implementation (e.g.
-	  shared storage logs) or experimental logs can be implemented
-	  by leveraging this framework.
-
-config DM_RAID
-       tristate "RAID 1/4/5/6/10 target"
-       depends on BLK_DEV_DM
-       select MD_RAID0
-       select MD_RAID1
-       select MD_RAID10
-       select MD_RAID456
-       select BLK_DEV_MD
-	help
-	 A dm target that supports RAID1, RAID10, RAID4, RAID5 and RAID6 mappings
-
-	 A RAID-5 set of N drives with a capacity of C MB per drive provides
-	 the capacity of C * (N - 1) MB, and protects against a failure
-	 of a single drive. For a given sector (row) number, (N - 1) drives
-	 contain data sectors, and one drive contains the parity protection.
-	 For a RAID-4 set, the parity blocks are present on a single drive,
-	 while a RAID-5 set distributes the parity across the drives in one
-	 of the available parity distribution methods.
-
-	 A RAID-6 set of N drives with a capacity of C MB per drive
-	 provides the capacity of C * (N - 2) MB, and protects
-	 against a failure of any two drives. For a given sector
-	 (row) number, (N - 2) drives contain data sectors, and two
-	 drives contains two independent redundancy syndromes.  Like
-	 RAID-5, RAID-6 distributes the syndromes across the drives
-	 in one of the available parity distribution methods.
-
-config DM_ZERO
-	tristate "Zero target"
-	depends on BLK_DEV_DM
-	help
-	  A target that discards writes, and returns all zeroes for
-	  reads.  Useful in some recovery situations.
-
-config DM_MULTIPATH
-	tristate "Multipath target"
-	depends on BLK_DEV_DM
-	# nasty syntax but means make DM_MULTIPATH independent
-	# of SCSI_DH if the latter isn't defined but if
-	# it is, DM_MULTIPATH must depend on it.  We get a build
-	# error if SCSI_DH=m and DM_MULTIPATH=y
-	depends on !SCSI_DH || SCSI
-	help
-	  Allow volume managers to support multipath hardware.
-
-config DM_MULTIPATH_QL
-	tristate "I/O Path Selector based on the number of in-flight I/Os"
-	depends on DM_MULTIPATH
-	help
-	  This path selector is a dynamic load balancer which selects
-	  the path with the least number of in-flight I/Os.
-
-	  If unsure, say N.
-
-config DM_MULTIPATH_ST
-	tristate "I/O Path Selector based on the service time"
-	depends on DM_MULTIPATH
-	help
-	  This path selector is a dynamic load balancer which selects
-	  the path expected to complete the incoming I/O in the shortest
-	  time.
-
-	  If unsure, say N.
-
-config DM_MULTIPATH_HST
-	tristate "I/O Path Selector based on historical service time"
-	depends on DM_MULTIPATH
-	help
-	  This path selector is a dynamic load balancer which selects
-	  the path expected to complete the incoming I/O in the shortest
-	  time by comparing estimated service time (based on historical
-	  service time).
-
-	  If unsure, say N.
-
-config DM_MULTIPATH_IOA
-	tristate "I/O Path Selector based on CPU submission"
-	depends on DM_MULTIPATH
-	help
-	  This path selector selects the path based on the CPU the IO is
-	  executed on and the CPU to path mapping setup at path addition time.
-
-	  If unsure, say N.
-
-config DM_DELAY
-	tristate "I/O delaying target"
-	depends on BLK_DEV_DM
-	help
-	A target that delays reads and/or writes and can send
-	them to different devices.  Useful for testing.
-
-	If unsure, say N.
-
-config DM_DUST
-	tristate "Bad sector simulation target"
-	depends on BLK_DEV_DM
-	help
-	A target that simulates bad sector behavior.
-	Useful for testing.
-
-	If unsure, say N.
-
-config DM_INIT
-	bool "DM \"dm-mod.create=\" parameter support"
-	depends on BLK_DEV_DM=y
-	help
-	Enable "dm-mod.create=" parameter to create mapped devices at init time.
-	This option is useful to allow mounting rootfs without requiring an
-	initramfs.
-	See Documentation/admin-guide/device-mapper/dm-init.rst for dm-mod.create="..."
-	format.
-
-	If unsure, say N.
-
-config DM_UEVENT
-	bool "DM uevents"
-	depends on BLK_DEV_DM
-	help
-	Generate udev events for DM events.
-
-config DM_FLAKEY
-       tristate "Flakey target"
-       depends on BLK_DEV_DM
-	help
-	 A target that intermittently fails I/O for debugging purposes.
-
-config DM_VERITY
-	tristate "Verity target support"
-	depends on BLK_DEV_DM
-	select CRYPTO
-	select CRYPTO_HASH
-	select DM_BUFIO
-	help
-	  This device-mapper target creates a read-only device that
-	  transparently validates the data on one underlying device against
-	  a pre-generated tree of cryptographic checksums stored on a second
-	  device.
-
-	  You'll need to activate the digests you're going to use in the
-	  cryptoapi configuration.
-
-	  To compile this code as a module, choose M here: the module will
-	  be called dm-verity.
-
-	  If unsure, say N.
-
-config DM_VERITY_VERIFY_ROOTHASH_SIG
-	def_bool n
-	bool "Verity data device root hash signature verification support"
-	depends on DM_VERITY
-	select SYSTEM_DATA_VERIFICATION
-	help
-	  Add ability for dm-verity device to be validated if the
-	  pre-generated tree of cryptographic checksums passed has a pkcs#7
-	  signature file that can validate the roothash of the tree.
-
-	  By default, rely on the builtin trusted keyring.
-
-	  If unsure, say N.
-
-config DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
-	bool "Verity data device root hash signature verification with secondary keyring"
-	depends on DM_VERITY_VERIFY_ROOTHASH_SIG
-	depends on SECONDARY_TRUSTED_KEYRING
-	help
-	  Rely on the secondary trusted keyring to verify dm-verity signatures.
-
-	  If unsure, say N.
-
-config DM_VERITY_FEC
-	bool "Verity forward error correction support"
-	depends on DM_VERITY
-	select REED_SOLOMON
-	select REED_SOLOMON_DEC8
-	help
-	  Add forward error correction support to dm-verity. This option
-	  makes it possible to use pre-generated error correction data to
-	  recover from corrupted blocks.
-
-	  If unsure, say N.
-
-config DM_SWITCH
-	tristate "Switch target support (EXPERIMENTAL)"
-	depends on BLK_DEV_DM
-	help
-	  This device-mapper target creates a device that supports an arbitrary
-	  mapping of fixed-size regions of I/O across a fixed set of paths.
-	  The path used for any specific region can be switched dynamically
-	  by sending the target a message.
-
-	  To compile this code as a module, choose M here: the module will
-	  be called dm-switch.
-
-	  If unsure, say N.
-
-config DM_LOG_WRITES
-	tristate "Log writes target support"
-	depends on BLK_DEV_DM
-	help
-	  This device-mapper target takes two devices, one device to use
-	  normally, one to log all write operations done to the first device.
-	  This is for use by file system developers wishing to verify that
-	  their fs is writing a consistent file system at all times by allowing
-	  them to replay the log in a variety of ways and to check the
-	  contents.
-
-	  To compile this code as a module, choose M here: the module will
-	  be called dm-log-writes.
-
-	  If unsure, say N.
-
-config DM_INTEGRITY
-	tristate "Integrity target support"
-	depends on BLK_DEV_DM
-	select BLK_DEV_INTEGRITY
-	select DM_BUFIO
-	select CRYPTO
-	select CRYPTO_SKCIPHER
-	select ASYNC_XOR
-	select DM_AUDIT if AUDIT
-	help
-	  This device-mapper target emulates a block device that has
-	  additional per-sector tags that can be used for storing
-	  integrity information.
-
-	  This integrity target is used with the dm-crypt target to
-	  provide authenticated disk encryption or it can be used
-	  standalone.
-
-	  To compile this code as a module, choose M here: the module will
-	  be called dm-integrity.
-
-config DM_ZONED
-	tristate "Drive-managed zoned block device target support"
-	depends on BLK_DEV_DM
-	depends on BLK_DEV_ZONED
-	select CRC32
-	help
-	  This device-mapper target takes a host-managed or host-aware zoned
-	  block device and exposes most of its capacity as a regular block
-	  device (drive-managed zoned block device) without any write
-	  constraints. This is mainly intended for use with file systems that
-	  do not natively support zoned block devices but still want to
-	  benefit from the increased capacity offered by SMR disks. Other uses
-	  by applications using raw block devices (for example object stores)
-	  are also possible.
-
-	  To compile this code as a module, choose M here: the module will
-	  be called dm-zoned.
-
-	  If unsure, say N.
-
-config DM_AUDIT
-	bool "DM audit events"
-	depends on AUDIT
-	help
-	  Generate audit events for device-mapper.
-
-	  Enables audit logging of several security relevant events in the
-	  particular device-mapper targets, especially the integrity target.
-
-endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
deleted file mode 100644
index 84291e38dca8..000000000000
--- a/drivers/md/Makefile
+++ /dev/null
@@ -1,114 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-#
-# Makefile for the kernel software RAID and LVM drivers.
-#
-
-dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
-		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o dm-stats.o \
-		   dm-rq.o dm-io-rewind.o
-dm-multipath-y	+= dm-path-selector.o dm-mpath.o
-dm-historical-service-time-y += dm-ps-historical-service-time.o
-dm-io-affinity-y += dm-ps-io-affinity.o
-dm-queue-length-y += dm-ps-queue-length.o
-dm-round-robin-y += dm-ps-round-robin.o
-dm-service-time-y += dm-ps-service-time.o
-dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
-		    dm-snap-persistent.o
-dm-mirror-y	+= dm-raid1.o
-dm-log-userspace-y += dm-log-userspace-base.o dm-log-userspace-transfer.o
-dm-bio-prison-y += dm-bio-prison-v1.o dm-bio-prison-v2.o
-dm-thin-pool-y	+= dm-thin.o dm-thin-metadata.o
-dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o \
-		    dm-cache-background-tracker.o
-dm-cache-smq-y	+= dm-cache-policy-smq.o
-dm-ebs-y	+= dm-ebs-target.o
-dm-era-y	+= dm-era-target.o
-dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
-dm-verity-y	+= dm-verity-target.o
-dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
-
-md-mod-y	+= md.o md-bitmap.o
-raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
-linear-y	+= md-linear.o
-multipath-y	+= md-multipath.o
-faulty-y	+= md-faulty.o
-
-# Note: link order is important.  All raid personalities
-# and must come before md.o, as they each initialise 
-# themselves, and md.o may use the personalities when it 
-# auto-initialised.
-
-obj-$(CONFIG_MD_LINEAR)		+= linear.o
-obj-$(CONFIG_MD_RAID0)		+= raid0.o
-obj-$(CONFIG_MD_RAID1)		+= raid1.o
-obj-$(CONFIG_MD_RAID10)		+= raid10.o
-obj-$(CONFIG_MD_RAID456)	+= raid456.o
-obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
-obj-$(CONFIG_MD_FAULTY)		+= faulty.o
-obj-$(CONFIG_MD_CLUSTER)	+= md-cluster.o
-obj-$(CONFIG_BCACHE)		+= bcache/
-obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
-ifeq ($(CONFIG_BLK_DEV_MD),y)
-obj-y				+= md-autodetect.o
-endif
-obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
-obj-$(CONFIG_BLK_DEV_DM_BUILTIN) += dm-builtin.o
-obj-$(CONFIG_DM_UNSTRIPED)	+= dm-unstripe.o
-obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
-obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
-obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
-obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
-obj-$(CONFIG_DM_DUST)		+= dm-dust.o
-obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
-obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
-obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
-obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
-obj-$(CONFIG_DM_MULTIPATH_HST)	+= dm-historical-service-time.o
-obj-$(CONFIG_DM_MULTIPATH_IOA)	+= dm-io-affinity.o
-obj-$(CONFIG_DM_SWITCH)		+= dm-switch.o
-obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
-obj-$(CONFIG_DM_PERSISTENT_DATA) += persistent-data/
-obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
-obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
-obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
-obj-$(CONFIG_DM_RAID)		+= dm-raid.o
-obj-$(CONFIG_DM_THIN_PROVISIONING) += dm-thin-pool.o
-obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
-obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
-obj-$(CONFIG_DM_CACHE_SMQ)	+= dm-cache-smq.o
-obj-$(CONFIG_DM_EBS)		+= dm-ebs.o
-obj-$(CONFIG_DM_ERA)		+= dm-era.o
-obj-$(CONFIG_DM_CLONE)		+= dm-clone.o
-obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
-obj-$(CONFIG_DM_INTEGRITY)	+= dm-integrity.o
-obj-$(CONFIG_DM_ZONED)		+= dm-zoned.o
-obj-$(CONFIG_DM_WRITECACHE)	+= dm-writecache.o
-obj-$(CONFIG_SECURITY_LOADPIN_VERITY)	+= dm-verity-loadpin.o
-
-ifeq ($(CONFIG_DM_INIT),y)
-dm-mod-objs			+= dm-init.o
-endif
-
-ifeq ($(CONFIG_DM_UEVENT),y)
-dm-mod-objs			+= dm-uevent.o
-endif
-
-ifeq ($(CONFIG_BLK_DEV_ZONED),y)
-dm-mod-objs			+= dm-zone.o
-endif
-
-ifeq ($(CONFIG_IMA),y)
-dm-mod-objs			+= dm-ima.o
-endif
-
-ifeq ($(CONFIG_DM_VERITY_FEC),y)
-dm-verity-objs			+= dm-verity-fec.o
-endif
-
-ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
-dm-verity-objs			+= dm-verity-verify-sig.o
-endif
-
-ifeq ($(CONFIG_DM_AUDIT),y)
-dm-mod-objs			+= dm-audit.o
-endif
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index aebb7ef10e63..db3439d65582 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -268,6 +268,7 @@ struct bcache_device {
 	unsigned int		stripe_size;
 	atomic_t		*stripe_sectors_dirty;
 	unsigned long		*full_dirty_stripes;
+	atomic_long_t		dirty_sectors;
 
 	struct bio_set		bio_split;
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index d4a5fc0650bb..65c997b25cca 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -607,6 +607,8 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
 	if (stripe < 0)
 		return;
 
+	atomic_long_add(nr_sectors, &d->dirty_sectors);
+
 	if (UUID_FLASH_ONLY(&c->uuids[inode]))
 		atomic_long_add(nr_sectors, &c->flash_dev_dirty_sectors);
 
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df716951f6..a5bb1caa6c6e 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -48,12 +48,7 @@ struct bch_dirty_init_state {
 
 static inline uint64_t bcache_dev_sectors_dirty(struct bcache_device *d)
 {
-	uint64_t i, ret = 0;
-
-	for (i = 0; i < d->nr_stripes; i++)
-		ret += atomic_read(d->stripe_sectors_dirty + i);
-
-	return ret;
+	return atomic_long_read(&d->dirty_sectors);
 }
 
 static inline int offset_to_stripe(struct bcache_device *d,
-- 
2.39.2.windows.1

