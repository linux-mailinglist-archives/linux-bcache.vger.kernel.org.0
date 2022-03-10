Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27314D42DD
	for <lists+linux-bcache@lfdr.de>; Thu, 10 Mar 2022 09:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiCJIxw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 10 Mar 2022 03:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiCJIxv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 10 Mar 2022 03:53:51 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5D96398
        for <linux-bcache@vger.kernel.org>; Thu, 10 Mar 2022 00:52:48 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id v2-20020a7bcb42000000b0037b9d960079so4984178wmj.0
        for <linux-bcache@vger.kernel.org>; Thu, 10 Mar 2022 00:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=9c0+u5RGxs3tygxW7uEqzFBsQIJ+tb/LUIrIJu33KCM=;
        b=k4je0P5bDgT0PvpNhF26M4XGz24HVWyHSsAYyNZFDbmnbQi9cKpLRAGZBLHAse16DB
         0Y+wLbnrnE6j07+ZEGiDa4Bkzm91wStTvckBSMPstYPgYI058gPwbvUq+LatNVZ0TTbN
         BbtIZgOfOrlToaDifz/VkOjmMCWOh+HPTZ+7sVzNGERX1qQCzB0L+p8FKkj1v5pK2c12
         //6uVle5u/stb4VDZYRQRWjEN5YCRWOpGiaIA/jyvy1pVVrnoKoT4aW4W+4Cr+K/mmOc
         SAlv6MmyMxGVEVLaH9zJtmjznsEL6Q4pb88y6lwWRQz32GG41eQBMmSlomQA6rna3+ZO
         2Faw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=9c0+u5RGxs3tygxW7uEqzFBsQIJ+tb/LUIrIJu33KCM=;
        b=wMPvQQ6CTNnCZE/1oHmJb8qJGqHIcgJMoUDs+0rHXMWWli09LX7ii/IjP0hnJ987C8
         JRgM3UsKxE/v7wQdUqZTgR1xEEMheQ4VTII+bXICSgqab2a2UL843G6MJK5CK657yhsj
         u2PWmbA3rAky02BXXmKEm2nhyzf4p8IyTNVnwlXSOXZTbGQ5DzWvMg7oOqG+6lOfTc3c
         9pkGVnFEzfy/Cc8BkneZjO/5F6Y59mXZUDhnHChyBZSmHtgbJhJTXI551wyn77qJwcoY
         sZOH36ocoyo4sEi+dAlWVwo192EWus5bg4AcrR/lcjU3hY9N9swHB87xb0wDFIM6uwzB
         7Trg==
X-Gm-Message-State: AOAM530kuyF5BveIFN9dD/6zTHc1KLaaJlYif71Gj01HLF13oIQrv/jc
        rdp8g7cR46Z/E5HYYn7kG0rHwOQeOosk6ZEJRu3EDAbEfwn2ll7knci4AfzcUMkvUGq3j/Cecr/
        XrkX7CumdAL+3CjVuJgf7ynhS
X-Google-Smtp-Source: ABdhPJzU/PCc/BnwUeJCEVLWETfY65u+uw6BWA76QbTXz+nuCOdoObePDWTpipKRK2Op01HuFbehLQ==
X-Received: by 2002:a05:600c:4f83:b0:37c:d057:3efe with SMTP id n3-20020a05600c4f8300b0037cd0573efemr10579508wmq.143.1646902366956;
        Thu, 10 Mar 2022 00:52:46 -0800 (PST)
Received: from 2021-EMEA-0269.home (251.69.14.37.dynamic.jazztel.es. [37.14.69.251])
        by smtp.googlemail.com with ESMTPSA id s17-20020adfdb11000000b001f02d5fea43sm3948421wri.98.2022.03.10.00.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 00:52:46 -0800 (PST)
From:   Andrea Tomassetti <andrea.tomassetti@devo.com>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>,
        Andrea Tomassetti <andrea.tomassetti@devo.com>
Subject: [PATCH] bcache: Use bcache without formatting existing device
Date:   Thu, 10 Mar 2022 09:52:40 +0100
Message-Id: <20220310085240.334068-1-andrea.tomassetti@devo.com>
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

v2: Fixed small typo

Introducing a bcache control device (/dev/bcache_ctrl)
that allows communicating to the driver from user space
via IOCTL. The only IOCTL commands currently implemented,
receives a struct cache_sb and uses it to register the
backing device.

Signed-off-by: Andrea Tomassetti <andrea.tomassetti@devo.com>
---
 drivers/md/bcache/Makefile      |   2 +-
 drivers/md/bcache/control.c     | 117 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/control.h     |  12 ++++
 drivers/md/bcache/ioctl_codes.h |  19 ++++++
 drivers/md/bcache/super.c       |  62 ++++++++++++-----
 drivers/md/bcache/sysfs.c       |   4 ++
 drivers/md/bcache/writeback.h   |   2 +-
 7 files changed, 200 insertions(+), 18 deletions(-)
 create mode 100644 drivers/md/bcache/control.c
 create mode 100644 drivers/md/bcache/control.h
 create mode 100644 drivers/md/bcache/ioctl_codes.h

diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
index 5b87e59676b8..46ed41baed7a 100644
--- a/drivers/md/bcache/Makefile
+++ b/drivers/md/bcache/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)	+=3D bcache.o
=20
 bcache-y		:=3D alloc.o bset.o btree.o closure.o debug.o extents.o\
 	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
-	util.o writeback.o features.o
+	util.o writeback.o features.o control.o
diff --git a/drivers/md/bcache/control.c b/drivers/md/bcache/control.c
new file mode 100644
index 000000000000..dad432613474
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
+long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
+		unsigned long arg)
+{
+	int retval =3D 0;
+
+	if (_IOC_TYPE(cmd) !=3D BCH_IOCTL_MAGIC)
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
+		cmd_info =3D vmalloc(sizeof(struct bch_register_device));
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
+		retval =3D register_bcache_ioctl(cmd_info);
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
+static const struct file_operations _ctrl_dev_fops =3D {
+	.owner =3D THIS_MODULE,
+	.unlocked_ioctl =3D bch_service_ioctl_ctrl
+};
+
+int __init bch_ctrl_device_init(void)
+{
+	struct bch_ctrl_device *ctrl =3D &_control_device;
+	struct device *device;
+	int result =3D 0;
+
+	result =3D alloc_chrdev_region(&ctrl->dev, 0, 1, "bcache");
+	if (result) {
+		pr_err("Cannot allocate control chrdev number.\n");
+		goto error_alloc_chrdev_region;
+	}
+
+	cdev_init(&ctrl->cdev, &_ctrl_dev_fops);
+
+	result =3D cdev_add(&ctrl->cdev, ctrl->dev, 1);
+	if (result) {
+		pr_err("Cannot add control chrdev.\n");
+		goto error_cdev_add;
+	}
+
+	ctrl->class =3D class_create(THIS_MODULE, "bcache");
+	if (IS_ERR(ctrl->class)) {
+		pr_err("Cannot create control chrdev class.\n");
+		result =3D PTR_ERR(ctrl->class);
+		goto error_class_create;
+	}
+
+	device =3D device_create(ctrl->class, NULL, ctrl->dev, NULL,
+			"bcache_ctrl");
+	if (IS_ERR(device)) {
+		pr_err("Cannot create control chrdev.\n");
+		result =3D PTR_ERR(device);
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
+	struct bch_ctrl_device *ctrl =3D &_control_device;
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
diff --git a/drivers/md/bcache/ioctl_codes.h b/drivers/md/bcache/ioctl_code=
s.h
new file mode 100644
index 000000000000..f25e038bee30
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
+/** Start new cache instance, load cache or recover cache */
+#define BCH_IOCTL_REGISTER_DEVICE	_IOWR(BCH_IOCTL_MAGIC, 1, struct bch_reg=
ister_device)
+
+#endif
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 140f35dc0c45..95db3785a6e0 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -14,6 +14,7 @@
 #include "request.h"
 #include "writeback.h"
 #include "features.h"
+#include "control.h"
=20
 #include <linux/blkdev.h>
 #include <linux/pagemap.h>
@@ -1069,7 +1070,7 @@ int bch_cached_dev_run(struct cached_dev *dc)
 		goto out;
 	}
=20
-	if (!d->c &&
+	if (!d->c && dc->sb_disk &&
 	    BDEV_STATE(&dc->sb) !=3D BDEV_STATE_NONE) {
 		struct closure cl;
=20
@@ -1259,9 +1260,6 @@ int bch_cached_dev_attach(struct cached_dev *dc, stru=
ct cache_set *c,
 	 */
=20
 	if (bch_is_zero(u->uuid, 16)) {
-		struct closure cl;
-
-		closure_init_stack(&cl);
=20
 		memcpy(u->uuid, dc->sb.uuid, 16);
 		memcpy(u->label, dc->sb.label, SB_LABEL_SIZE);
@@ -1271,8 +1269,14 @@ int bch_cached_dev_attach(struct cached_dev *dc, str=
uct cache_set *c,
 		memcpy(dc->sb.set_uuid, c->set_uuid, 16);
 		SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
=20
-		bch_write_bdev_super(dc, &cl);
-		closure_sync(&cl);
+		if (dc->sb_disk) {
+			struct closure cl;
+
+			closure_init_stack(&cl);
+			bch_write_bdev_super(dc, &cl);
+			closure_sync(&cl);
+		}
+
 	} else {
 		u->last_reg =3D rtime;
 		bch_uuid_write(c);
@@ -2403,14 +2407,14 @@ static int register_cache(struct cache_sb *sb, stru=
ct cache_sb_disk *sb_disk,
=20
 /* Global interfaces/init */
=20
-static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *a=
ttr,
+static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_attrib=
ute *attr,
 			       const char *buffer, size_t size);
 static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 					 struct kobj_attribute *attr,
 					 const char *buffer, size_t size);
=20
-kobj_attribute_write(register,		register_bcache);
-kobj_attribute_write(register_quiet,	register_bcache);
+kobj_attribute_write(register,		register_bcache_sysfs);
+kobj_attribute_write(register_quiet,	register_bcache_sysfs);
 kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);
=20
 static bool bch_is_open_backing(dev_t dev)
@@ -2465,7 +2469,8 @@ static void register_bdev_worker(struct work_struct *=
work)
 	dc =3D kzalloc(sizeof(*dc), GFP_KERNEL);
 	if (!dc) {
 		fail =3D true;
-		put_page(virt_to_page(args->sb_disk));
+		if (args->sb_disk)
+			put_page(virt_to_page(args->sb_disk));
 		blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 		goto out;
 	}
@@ -2495,7 +2500,8 @@ static void register_cache_worker(struct work_struct =
*work)
 	ca =3D kzalloc(sizeof(*ca), GFP_KERNEL);
 	if (!ca) {
 		fail =3D true;
-		put_page(virt_to_page(args->sb_disk));
+		if (args->sb_disk)
+			put_page(virt_to_page(args->sb_disk));
 		blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 		goto out;
 	}
@@ -2525,7 +2531,7 @@ static void register_device_async(struct async_reg_ar=
gs *args)
 	queue_delayed_work(system_wq, &args->reg_work, 10);
 }
=20
-static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *a=
ttr,
+static ssize_t register_bcache_common(void *k, struct kobj_attribute *attr=
,
 			       const char *buffer, size_t size)
 {
 	const char *err;
@@ -2587,9 +2593,14 @@ static ssize_t register_bcache(struct kobject *k, st=
ruct kobj_attribute *attr,
 	if (set_blocksize(bdev, 4096))
 		goto out_blkdev_put;
=20
-	err =3D read_super(sb, bdev, &sb_disk);
-	if (err)
-		goto out_blkdev_put;
+	if (!k) {
+		err =3D read_super(sb, bdev, &sb_disk);
+		if (err)
+			goto out_blkdev_put;
+	} else {
+		sb_disk =3D  NULL;
+		memcpy(sb, (struct cache_sb *)k, sizeof(struct cache_sb));
+	}
=20
 	err =3D "failed to register device";
=20
@@ -2651,7 +2662,8 @@ static ssize_t register_bcache(struct kobject *k, str=
uct kobj_attribute *attr,
 	return size;
=20
 out_put_sb_page:
-	put_page(virt_to_page(sb_disk));
+	if (!k)
+		put_page(virt_to_page(sb_disk));
 out_blkdev_put:
 	blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 out_free_sb:
@@ -2666,6 +2678,18 @@ static ssize_t register_bcache(struct kobject *k, st=
ruct kobj_attribute *attr,
 	return ret;
 }
=20
+static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_attrib=
ute *attr,
+			       const char *buffer, size_t size)
+{
+	return register_bcache_common(NULL, attr, buffer, size);
+}
+
+ssize_t register_bcache_ioctl(struct bch_register_device *brd)
+{
+	return register_bcache_common((void *)brd->sb, NULL, brd->dev_name, brd->=
size);
+}
+
+
=20
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
=20
+	if (bch_ctrl_device_init()) {
+		pr_err("Cannot initialize control device\n");
+		goto err;
+	}
+
 	bcache_is_reboot =3D false;
=20
 	return 0;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 1f0dce30fa75..984cc97a1d55 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -379,6 +379,10 @@ STORE(__cached_dev)
 		if (v < 0)
 			return v;
=20
+		// XXX(atom): Devices created by IOCTL don't support changing cache mode
+		if (!dc->sb_disk)
+			return -EINVAL;
+
 		if ((unsigned int) v !=3D BDEV_CACHE_MODE(&dc->sb)) {
 			SET_BDEV_CACHE_MODE(&dc->sb, v);
 			bch_write_bdev_super(dc, NULL);
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 02b2f9df73f6..bd7b95bd2da7 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -135,7 +135,7 @@ static inline void bch_writeback_add(struct cached_dev =
*dc)
 {
 	if (!atomic_read(&dc->has_dirty) &&
 	    !atomic_xchg(&dc->has_dirty, 1)) {
-		if (BDEV_STATE(&dc->sb) !=3D BDEV_STATE_DIRTY) {
+		if (dc->sb_disk && BDEV_STATE(&dc->sb) !=3D BDEV_STATE_DIRTY) {
 			SET_BDEV_STATE(&dc->sb, BDEV_STATE_DIRTY);
 			/* XXX: should do this synchronously */
 			bch_write_bdev_super(dc, NULL);
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

