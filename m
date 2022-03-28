Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BCF4E9557
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Mar 2022 13:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241899AbiC1Ll0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Mar 2022 07:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245134AbiC1Li7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Mar 2022 07:38:59 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1842BA3
        for <linux-bcache@vger.kernel.org>; Mon, 28 Mar 2022 04:37:18 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p26-20020a05600c1d9a00b0038ccbff1951so5349914wms.1
        for <linux-bcache@vger.kernel.org>; Mon, 28 Mar 2022 04:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=2hTx/U46yDNjLDUbKh7Jp44HbAphNtVU0stK2WU14qk=;
        b=OQVLjWJCviCdavhjjXYq8gsFSdUoelxmpK9WNj2IyRL82IWCWuvDFdNKzy8c95B5V/
         1UHVK+FqU9Pgs7wAnRrCa4vaSPTRZC/YYJVJO1Sk6IZEWj9QnwyfdNWlk3ljr0hYD3rT
         gGY2lJTl+KuLjdaogXhiNgLuKNvd7wM1BxgfunFmQEu2ZitnCQYFL57f7hRucBZSodTW
         HsCQDwa90lpdBxMZDuyFqca/XVAFkmt0ip8ko3K3+R4L/rr0lVkK3KGJ02ZjNG/MplWq
         odTi1ISTQUATq4qzUO1RaxrTh1xjHZlnleXywWXwDe0jt4vC2XHqGP2WODoJSj/7YWrX
         cb9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=2hTx/U46yDNjLDUbKh7Jp44HbAphNtVU0stK2WU14qk=;
        b=j1oc0a0BQ9mYvxGnekAo0opbbVsQaZs5RFnZ/qYUhy2FNG2RXVA12IKnJHojtBxvZu
         VPIH6EgEEjGfoHypUgkj68OXySZnZ7Vs+wqQxj6+h2rREmOH13vI36xzXbdBPqrRZdMX
         fxIzFKEzU3Pq0nJhEWkjumIz9jd1+FkQ/65iTQJQJqbj//KajBz7QZmjBFOddL+GVTmW
         k3jll72Cz0Feqo/Dqos5GM6IrzhfiJrFaGhhBZa6oSLDEyMcUi+cue/45/UN4wNgl7hb
         3EkiChsq0uCYq7Jm/d8ZW/gPCeR0pbIWkYxK/MgIcCDujpk3CL11OtQyGhE59uLp2o8J
         kEjw==
X-Gm-Message-State: AOAM531HQLSgtpf+n5/Z/XolLnXpECnZy0XjEwD05nCJmyXaWylMPCbP
        49Q+X4oKA0g9wJVwp55/k5Moqgmb4c54pybRbkn3FjxUx6CjHlLkjfOCjJkR+0KU39N0Ozb6CZk
        2OfrcbMCffAro3/Vy
X-Google-Smtp-Source: ABdhPJzNiTPVAEVKXWZYARg/QyUW9paF7UwYkCGRVooW8Kphugf+Di0jS5sIPaQWJCQsX7ueor4A6w==
X-Received: by 2002:a05:600c:3d0e:b0:38c:9b5e:52c0 with SMTP id bh14-20020a05600c3d0e00b0038c9b5e52c0mr25280138wmb.3.1648467436497;
        Mon, 28 Mar 2022 04:37:16 -0700 (PDT)
Received: from 2021-EMEA-0269.home (251.69.14.37.dynamic.jazztel.es. [37.14.69.251])
        by smtp.googlemail.com with ESMTPSA id i1-20020a05600c354100b0038cceb205besm11572133wmq.7.2022.03.28.04.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 04:37:16 -0700 (PDT)
From:   Andrea Tomassetti <andrea.tomassetti@devo.com>
To:     Andrea Tomassetti <andrea.tomassetti@devo.com>
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: [PATCH v4] bcache: Use bcache without formatting existing device
Date:   Mon, 28 Mar 2022 13:36:35 +0200
Message-Id: <20220328113635.152071-1-andrea.tomassetti@devo.com>
X-Mailer: git-send-email 2.25.1
Reply-To: CAG2S0o-yjcc=HGVhZ-YfukT10+US45TemykFwETdgPRbJHLyqw@mail.gmail.com
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

v4: Simplify and make more consistent `dc->sb_disk !=3D NULL` check

v3: fix build warning reported by kernel test robot

>> drivers/md/bcache/control.c:18:6: warning: no
   previous prototype for function 'bch_service_ioctl_ctrl'
   [-Wmissing-prototypes]
   long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
        ^
   drivers/md/bcache/control.c:18:1: note: declare 'static' if the
   function is not intended to be used outside of this translation unit
   long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
   ^
   static
   1 warning generated.

v2: Fixed small typos

Introducing a bcache control device (/dev/bcache_ctrl)
that allows communicating to the driver from user space
via IOCTL. The only IOCTL commands currently implemented,
receives a struct cache_sb and uses it to register the
backing device.

Signed-off-by: Andrea Tomassetti <andrea.tomassetti@devo.com>
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
@@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)	+=3D bcache.o

 bcache-y		:=3D alloc.o bset.o btree.o closure.o debug.o extents.o\
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
+#define BCH_IOCTL_REGISTER_DEVICE	_IOWR(BCH_IOCTL_MAGIC, 1, struct bch_reg=
ister_device)
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
@@ -340,6 +341,9 @@ void bch_write_bdev_super(struct cached_dev *dc, struct=
 closure *parent)
 	struct closure *cl =3D &dc->sb_write;
 	struct bio *bio =3D &dc->sb_bio;

+	if (!dc->sb_disk)
+		return;
+
 	down(&dc->sb_write_mutex);
 	closure_init(cl, parent);

@@ -2403,14 +2407,14 @@ static int register_cache(struct cache_sb *sb, stru=
ct cache_sb_disk *sb_disk,

 /* Global interfaces/init */

-static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *a=
ttr,
+static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_attrib=
ute *attr,
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

 	err =3D "failed to register device";

@@ -2651,7 +2662,8 @@ static ssize_t register_bcache(struct kobject *k, str=
uct kobj_attribute *attr,
 	return size;

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
 	bcache_is_reboot =3D false;

 	return 0;
--
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

