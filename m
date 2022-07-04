Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C816565997
	for <lists+linux-bcache@lfdr.de>; Mon,  4 Jul 2022 17:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiGDPPL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Jul 2022 11:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGDPPL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Jul 2022 11:15:11 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C841BC9F
        for <linux-bcache@vger.kernel.org>; Mon,  4 Jul 2022 08:15:09 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so8177231wmp.3
        for <linux-bcache@vger.kernel.org>; Mon, 04 Jul 2022 08:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hulM8w4dbX6j6RJE9IPprEJmTJ10Hyx5SrSSeB62zKU=;
        b=MNY1dyXCp9g7k+PGKQ9+yu2j0lQxCBYpQcnE2w/0YtfHos833GfPNoXZ8fNIOszCRk
         zYA9aER2cKrLoMpAwR4kdBacwM66ArmN3mtA0aivHKzfD/brxhH5ke9Kj0s2BJg5WR0N
         cg1rsyTp2J1ZU+bvIzqaiItD7JO15Gvb8CyrAoBAgjI8Y/KezC/hLYgRP4P8dABQ2Bvn
         /cQ2obK9QfDLaz+sGZE2gVTyTzdqToGHLdl/CuFjyHMJyf/nduiLNxoLgQMb6dIJ3F2P
         /2weN4HLTUwMLxTY2s29Nxst4Es0JGbd6axzY5n5BeEXGj2E2I7uD8js7qHryFTyOlRc
         RWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hulM8w4dbX6j6RJE9IPprEJmTJ10Hyx5SrSSeB62zKU=;
        b=cwgFc/x76uDHnH85QIz5XRuy6j5lq0+rWVKk8mlyDb5NernHTa59E5Mi3pFKUoafR5
         k51rIlTHS84ghShypljZcZnR8dnJczCzM+A5CfMfGa3cFDEaVAHkyCUCfkjL20wVg3vu
         Cj6hNp4ADy4zjtjcXReH1xDXDS5pY9gcWcBp/P2evKaZFkpit14AGEIJP1jsjUCoCg1P
         KMI8rV0KA3+ON+OuAG7+KB6knNqEVnvaHBrbUOkF65DTaKTV5fiBBGZVyZEJOkcfhVOL
         LvmONkUHzIWYVxbQu1nBUMMpJa2XMVcDZbQO9h0yQkTH955hCKvM/Tgc3BBSL0ePuteY
         nB4g==
X-Gm-Message-State: AJIora+uqfCoVuRzcBLB9p6k5RlROzzQUvLe3tFgC4o/RmukPpnOw4Ei
        DR+Boomzy8OaiOhQXOAdjSRnmnW8x24RUZJW
X-Google-Smtp-Source: AGRyM1vj5edu0nuFX3q4ImnfQu/szy6iE1C0YgynJ61cqgszVFuM8qN5AeHHhs0jB1qCpa14Pc2Ttw==
X-Received: by 2002:a7b:c4d3:0:b0:3a2:aef9:2415 with SMTP id g19-20020a7bc4d3000000b003a2aef92415mr4512619wmk.72.1656947707802;
        Mon, 04 Jul 2022 08:15:07 -0700 (PDT)
Received: from 2021-EMEA-0269.home (46.180.77.188.dynamic.jazztel.es. [188.77.180.46])
        by smtp.googlemail.com with ESMTPSA id a1-20020a05600c348100b003a03be22f9fsm13634847wmq.18.2022.07.04.08.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 08:15:07 -0700 (PDT)
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>,
        Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Subject: [PATCH] bcache: Use bcache without formatting existing device
Date:   Mon,  4 Jul 2022 17:13:21 +0200
Message-Id: <20220704151320.78094-1-andrea.tomassetti-opensource@devo.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Introducing a bcache control device (/dev/bcache_ctrl)
that allows communicating to the driver from user space
via IOCTL. The only IOCTL commands currently implemented,
receives a struct cache_sb and uses it to register the
backing device without any need of formatting them.

Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
---
Hi all,
At Devo we started to think of using bcache in our production systems
to boost performance. But, at the very beginning, we were faced with
one annoying issue, at least for our use-case: bcache needs the backing
devices to be formatted before being able to use them. What's really
needed is just to wipe any FS signature out of them. This is definitely
not an option we will consider in our production systems because we would
need to move hundreds of terabytes of data.

To circumvent the "formatting" problem, in the past weeks I worked on some
modifications to the actual bcache module. In particular, I added a bcache
control device (exported to /dev/bcache_ctrl) that allows communicating to
the driver from userspace via IOCTL. One of the IOCTL commands that I
implemented receives a struct cache_sb and uses it to register the backing
device. The modifications are really small and retro compatible. To then
re-create the same configuration after every boot (because the backing
devices now do not present the bcache super block anymore) I created an
udev rule that invokes a python script that will re-create the same
scenario based on a yaml configuration file.

I'm re-sending this patch without any confidentiality footer, sorry for that.

 drivers/md/bcache/Makefile      |   2 +-
 drivers/md/bcache/control.c     | 117 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/control.h     |  12 ++++
 drivers/md/bcache/ioctl_codes.h |  19 ++++++
 drivers/md/bcache/super.c       |  50 +++++++++++---
 5 files changed, 189 insertions(+), 11 deletions(-)
 create mode 100644 drivers/md/bcache/control.c
 create mode 100644 drivers/md/bcache/control.h
 create mode 100644 drivers/md/bcache/ioctl_codes.h

diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
index 5b87e59676b8..46ed41baed7a 100644
--- a/drivers/md/bcache/Makefile
+++ b/drivers/md/bcache/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)	+= bcache.o

 bcache-y		:= alloc.o bset.o btree.o closure.o debug.o extents.o\
 	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
-	util.o writeback.o features.o
+	util.o writeback.o features.o control.o
diff --git a/drivers/md/bcache/control.c b/drivers/md/bcache/control.c
new file mode 100644
index 000000000000..69b5e554d093
--- /dev/null
+++ b/drivers/md/bcache/control.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cdev.h>
+#include <linux/fs.h>
+#include <linux/vmalloc.h>
+
+#include "control.h"
+
+struct bch_ctrl_device {
+	struct cdev cdev;
+	struct class *class;
+	dev_t dev;
+};
+
+static struct bch_ctrl_device _control_device;
+
+/* this handles IOCTL for /dev/bcache_ctrl */
+/*********************************************/
+static long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
+		unsigned long arg)
+{
+	int retval = 0;
+
+	if (_IOC_TYPE(cmd) != BCH_IOCTL_MAGIC)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		/* Must be root to issue ioctls */
+		return -EPERM;
+	}
+
+	switch (cmd) {
+	case BCH_IOCTL_REGISTER_DEVICE: {
+		struct bch_register_device *cmd_info;
+
+		cmd_info = vmalloc(sizeof(struct bch_register_device));
+		if (!cmd_info)
+			return -ENOMEM;
+
+		if (copy_from_user(cmd_info, (void __user *)arg,
+				sizeof(struct bch_register_device))) {
+			pr_err("Cannot copy cmd info from user space\n");
+			vfree(cmd_info);
+			return -EINVAL;
+		}
+
+		retval = register_bcache_ioctl(cmd_info);
+
+		vfree(cmd_info);
+		return retval;
+	}
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct file_operations _ctrl_dev_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = bch_service_ioctl_ctrl
+};
+
+int __init bch_ctrl_device_init(void)
+{
+	struct bch_ctrl_device *ctrl = &_control_device;
+	struct device *device;
+	int result = 0;
+
+	result = alloc_chrdev_region(&ctrl->dev, 0, 1, "bcache");
+	if (result) {
+		pr_err("Cannot allocate control chrdev number.\n");
+		goto error_alloc_chrdev_region;
+	}
+
+	cdev_init(&ctrl->cdev, &_ctrl_dev_fops);
+
+	result = cdev_add(&ctrl->cdev, ctrl->dev, 1);
+	if (result) {
+		pr_err("Cannot add control chrdev.\n");
+		goto error_cdev_add;
+	}
+
+	ctrl->class = class_create(THIS_MODULE, "bcache");
+	if (IS_ERR(ctrl->class)) {
+		pr_err("Cannot create control chrdev class.\n");
+		result = PTR_ERR(ctrl->class);
+		goto error_class_create;
+	}
+
+	device = device_create(ctrl->class, NULL, ctrl->dev, NULL,
+			"bcache_ctrl");
+	if (IS_ERR(device)) {
+		pr_err("Cannot create control chrdev.\n");
+		result = PTR_ERR(device);
+		goto error_device_create;
+	}
+
+	return result;
+
+error_device_create:
+	class_destroy(ctrl->class);
+error_class_create:
+	cdev_del(&ctrl->cdev);
+error_cdev_add:
+	unregister_chrdev_region(ctrl->dev, 1);
+error_alloc_chrdev_region:
+	return result;
+}
+
+void bch_ctrl_device_deinit(void)
+{
+	struct bch_ctrl_device *ctrl = &_control_device;
+
+	device_destroy(ctrl->class, ctrl->dev);
+	class_destroy(ctrl->class);
+	cdev_del(&ctrl->cdev);
+	unregister_chrdev_region(ctrl->dev, 1);
+}
diff --git a/drivers/md/bcache/control.h b/drivers/md/bcache/control.h
new file mode 100644
index 000000000000..3e4273db02a3
--- /dev/null
+++ b/drivers/md/bcache/control.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __BCACHE_CONTROL_H__
+#define __BCACHE_CONTROL_H__
+
+#include "ioctl_codes.h"
+
+int __init bch_ctrl_device_init(void);
+void bch_ctrl_device_deinit(void);
+
+ssize_t register_bcache_ioctl(struct bch_register_device *brd);
+
+#endif
diff --git a/drivers/md/bcache/ioctl_codes.h b/drivers/md/bcache/ioctl_codes.h
new file mode 100644
index 000000000000..b004d60c29ff
--- /dev/null
+++ b/drivers/md/bcache/ioctl_codes.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __BCACHE_IOCTL_CODES_H__
+#define __BCACHE_IOCTL_CODES_H__
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+struct bch_register_device {
+	const char *dev_name;
+	size_t size;
+	struct cache_sb *sb;
+};
+
+#define BCH_IOCTL_MAGIC (0xBC)
+
+/* Register a new backing device */
+#define BCH_IOCTL_REGISTER_DEVICE	_IOWR(BCH_IOCTL_MAGIC, 1, struct bch_register_device)
+
+#endif
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 140f35dc0c45..339a11d00fef 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -14,6 +14,7 @@
 #include "request.h"
 #include "writeback.h"
 #include "features.h"
+#include "control.h"

 #include <linux/blkdev.h>
 #include <linux/pagemap.h>
@@ -340,6 +341,9 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent)
 	struct closure *cl = &dc->sb_write;
 	struct bio *bio = &dc->sb_bio;

+	if (!dc->sb_disk)
+		return;
+
 	down(&dc->sb_write_mutex);
 	closure_init(cl, parent);

@@ -2403,14 +2407,14 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,

 /* Global interfaces/init */

-static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
+static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_attribute *attr,
 			       const char *buffer, size_t size);
 static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 					 struct kobj_attribute *attr,
 					 const char *buffer, size_t size);

-kobj_attribute_write(register,		register_bcache);
-kobj_attribute_write(register_quiet,	register_bcache);
+kobj_attribute_write(register,		register_bcache_sysfs);
+kobj_attribute_write(register_quiet,	register_bcache_sysfs);
 kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);

 static bool bch_is_open_backing(dev_t dev)
@@ -2465,7 +2469,8 @@ static void register_bdev_worker(struct work_struct *work)
 	dc = kzalloc(sizeof(*dc), GFP_KERNEL);
 	if (!dc) {
 		fail = true;
-		put_page(virt_to_page(args->sb_disk));
+		if (args->sb_disk)
+			put_page(virt_to_page(args->sb_disk));
 		blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 		goto out;
 	}
@@ -2495,7 +2500,8 @@ static void register_cache_worker(struct work_struct *work)
 	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 	if (!ca) {
 		fail = true;
-		put_page(virt_to_page(args->sb_disk));
+		if (args->sb_disk)
+			put_page(virt_to_page(args->sb_disk));
 		blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 		goto out;
 	}
@@ -2525,7 +2531,7 @@ static void register_device_async(struct async_reg_args *args)
 	queue_delayed_work(system_wq, &args->reg_work, 10);
 }

-static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
+static ssize_t register_bcache_common(void *k, struct kobj_attribute *attr,
 			       const char *buffer, size_t size)
 {
 	const char *err;
@@ -2587,9 +2593,14 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (set_blocksize(bdev, 4096))
 		goto out_blkdev_put;

-	err = read_super(sb, bdev, &sb_disk);
-	if (err)
-		goto out_blkdev_put;
+	if (!k) {
+		err = read_super(sb, bdev, &sb_disk);
+		if (err)
+			goto out_blkdev_put;
+	} else {
+		sb_disk =  NULL;
+		memcpy(sb, (struct cache_sb *)k, sizeof(struct cache_sb));
+	}

 	err = "failed to register device";

@@ -2651,7 +2662,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	return size;

 out_put_sb_page:
-	put_page(virt_to_page(sb_disk));
+	if (!k)
+		put_page(virt_to_page(sb_disk));
 out_blkdev_put:
 	blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 out_free_sb:
@@ -2666,6 +2678,18 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	return ret;
 }

+static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_attribute *attr,
+			       const char *buffer, size_t size)
+{
+	return register_bcache_common(NULL, attr, buffer, size);
+}
+
+ssize_t register_bcache_ioctl(struct bch_register_device *brd)
+{
+	return register_bcache_common((void *)brd->sb, NULL, brd->dev_name, brd->size);
+}
+
+

 struct pdev {
 	struct list_head list;
@@ -2819,6 +2843,7 @@ static void bcache_exit(void)
 {
 	bch_debug_exit();
 	bch_request_exit();
+	bch_ctrl_device_deinit();
 	if (bcache_kobj)
 		kobject_put(bcache_kobj);
 	if (bcache_wq)
@@ -2918,6 +2943,11 @@ static int __init bcache_init(void)
 	bch_debug_init();
 	closure_debug_init();

+	if (bch_ctrl_device_init()) {
+		pr_err("Cannot initialize control device\n");
+		goto err;
+	}
+
 	bcache_is_reboot = false;

 	return 0;
--
2.37.0

