Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F485659D9
	for <lists+linux-bcache@lfdr.de>; Mon,  4 Jul 2022 17:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiGDP3e (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Jul 2022 11:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbiGDP3b (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Jul 2022 11:29:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18A7E65
        for <linux-bcache@vger.kernel.org>; Mon,  4 Jul 2022 08:29:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 739451FF25;
        Mon,  4 Jul 2022 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656948568; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=we4t0IFL+p9bvB1E7oFT8OKcpM3QQMvf45TWliSwCN0=;
        b=Dd4lS0NI6G4RbWvEnwvWP19VlI/SkToo4i1uNgEZ+eAORLpKBZsicvziUbqXra2N273/k4
        nI3ysk7WxKoDSdF1tMAqsVouaNIN5w9LkGa9I1Q7qylxOtVmOm0jl1uii1EtspTrxXy8i3
        2GxvFud7EQyHeNq7fbHdZPPf3MqAVWw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656948568;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=we4t0IFL+p9bvB1E7oFT8OKcpM3QQMvf45TWliSwCN0=;
        b=3ERjT9Ea7DtwM0v7aCIo6I46CLVse6OEmMqZAJJsJweS+3DUVmG1B46SJ4ltl1ZBJrcmSR
        QvFOHDb7LeeswHCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B17B41342C;
        Mon,  4 Jul 2022 15:29:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rGk3OVUHw2L4dwAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 04 Jul 2022 15:29:25 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] bcache: Use bcache without formatting existing device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220704151320.78094-1-andrea.tomassetti-opensource@devo.com>
Date:   Mon, 4 Jul 2022 23:29:21 +0800
Cc:     linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B18A4668-47F5-4219-8336-EDB00D0292C2@suse.de>
References: <20220704151320.78094-1-andrea.tomassetti-opensource@devo.com>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=884=E6=97=A5 23:13=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Introducing a bcache control device (/dev/bcache_ctrl)
> that allows communicating to the driver from user space
> via IOCTL. The only IOCTL commands currently implemented,
> receives a struct cache_sb and uses it to register the
> backing device without any need of formatting them.
>=20
> Signed-off-by: Andrea Tomassetti =
<andrea.tomassetti-opensource@devo.com>
> ---
> Hi all,
> At Devo we started to think of using bcache in our production systems
> to boost performance. But, at the very beginning, we were faced with
> one annoying issue, at least for our use-case: bcache needs the =
backing
> devices to be formatted before being able to use them. What's really
> needed is just to wipe any FS signature out of them. This is =
definitely
> not an option we will consider in our production systems because we =
would
> need to move hundreds of terabytes of data.
>=20
> To circumvent the "formatting" problem, in the past weeks I worked on =
some
> modifications to the actual bcache module. In particular, I added a =
bcache
> control device (exported to /dev/bcache_ctrl) that allows =
communicating to
> the driver from userspace via IOCTL. One of the IOCTL commands that I
> implemented receives a struct cache_sb and uses it to register the =
backing
> device. The modifications are really small and retro compatible. To =
then
> re-create the same configuration after every boot (because the backing
> devices now do not present the bcache super block anymore) I created =
an
> udev rule that invokes a python script that will re-create the same
> scenario based on a yaml configuration file.
>=20
> I'm re-sending this patch without any confidentiality footer, sorry =
for that.

Thanks for removing that confidential and legal statement, that=E2=80=99s =
the reason I was not able to reply your email.

Back to the patch, I don=E2=80=99t support this idea. For the problem =
you are solving, indeed people uses device mapper linear target for many =
years, and it works perfectly without any code modification.

That is, create a 8K image and set it as a loop device, then write a dm =
table to combine it with the existing hard drive. Then you run =E2=80=9Cbc=
ache make -B <combined dm target>=E2=80=9D, you will get a bcache device =
whose first 8K in the loop device and existing super block of the hard =
driver located at expected offset.

It is unnecessary to create a new IOCTL interface, and I feel the way =
how it works is really unconvinced for potential security risk.

Thanks.

Coly Li

>=20
> drivers/md/bcache/Makefile      |   2 +-
> drivers/md/bcache/control.c     | 117 ++++++++++++++++++++++++++++++++
> drivers/md/bcache/control.h     |  12 ++++
> drivers/md/bcache/ioctl_codes.h |  19 ++++++
> drivers/md/bcache/super.c       |  50 +++++++++++---
> 5 files changed, 189 insertions(+), 11 deletions(-)
> create mode 100644 drivers/md/bcache/control.c
> create mode 100644 drivers/md/bcache/control.h
> create mode 100644 drivers/md/bcache/ioctl_codes.h
>=20
> diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
> index 5b87e59676b8..46ed41baed7a 100644
> --- a/drivers/md/bcache/Makefile
> +++ b/drivers/md/bcache/Makefile
> @@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)	+=3D bcache.o
>=20
> bcache-y		:=3D alloc.o bset.o btree.o closure.o debug.o =
extents.o\
> 	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o =
trace.o\
> -	util.o writeback.o features.o
> +	util.o writeback.o features.o control.o
> diff --git a/drivers/md/bcache/control.c b/drivers/md/bcache/control.c
> new file mode 100644
> index 000000000000..69b5e554d093
> --- /dev/null
> +++ b/drivers/md/bcache/control.c
> @@ -0,0 +1,117 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/cdev.h>
> +#include <linux/fs.h>
> +#include <linux/vmalloc.h>
> +
> +#include "control.h"
> +
> +struct bch_ctrl_device {
> +	struct cdev cdev;
> +	struct class *class;
> +	dev_t dev;
> +};
> +
> +static struct bch_ctrl_device _control_device;
> +
> +/* this handles IOCTL for /dev/bcache_ctrl */
> +/*********************************************/
> +static long bch_service_ioctl_ctrl(struct file *filp, unsigned int =
cmd,
> +		unsigned long arg)
> +{
> +	int retval =3D 0;
> +
> +	if (_IOC_TYPE(cmd) !=3D BCH_IOCTL_MAGIC)
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN)) {
> +		/* Must be root to issue ioctls */
> +		return -EPERM;
> +	}
> +
> +	switch (cmd) {
> +	case BCH_IOCTL_REGISTER_DEVICE: {
> +		struct bch_register_device *cmd_info;
> +
> +		cmd_info =3D vmalloc(sizeof(struct =
bch_register_device));
> +		if (!cmd_info)
> +			return -ENOMEM;
> +
> +		if (copy_from_user(cmd_info, (void __user *)arg,
> +				sizeof(struct bch_register_device))) {
> +			pr_err("Cannot copy cmd info from user =
space\n");
> +			vfree(cmd_info);
> +			return -EINVAL;
> +		}
> +
> +		retval =3D register_bcache_ioctl(cmd_info);
> +
> +		vfree(cmd_info);
> +		return retval;
> +	}
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static const struct file_operations _ctrl_dev_fops =3D {
> +	.owner =3D THIS_MODULE,
> +	.unlocked_ioctl =3D bch_service_ioctl_ctrl
> +};
> +
> +int __init bch_ctrl_device_init(void)
> +{
> +	struct bch_ctrl_device *ctrl =3D &_control_device;
> +	struct device *device;
> +	int result =3D 0;
> +
> +	result =3D alloc_chrdev_region(&ctrl->dev, 0, 1, "bcache");
> +	if (result) {
> +		pr_err("Cannot allocate control chrdev number.\n");
> +		goto error_alloc_chrdev_region;
> +	}
> +
> +	cdev_init(&ctrl->cdev, &_ctrl_dev_fops);
> +
> +	result =3D cdev_add(&ctrl->cdev, ctrl->dev, 1);
> +	if (result) {
> +		pr_err("Cannot add control chrdev.\n");
> +		goto error_cdev_add;
> +	}
> +
> +	ctrl->class =3D class_create(THIS_MODULE, "bcache");
> +	if (IS_ERR(ctrl->class)) {
> +		pr_err("Cannot create control chrdev class.\n");
> +		result =3D PTR_ERR(ctrl->class);
> +		goto error_class_create;
> +	}
> +
> +	device =3D device_create(ctrl->class, NULL, ctrl->dev, NULL,
> +			"bcache_ctrl");
> +	if (IS_ERR(device)) {
> +		pr_err("Cannot create control chrdev.\n");
> +		result =3D PTR_ERR(device);
> +		goto error_device_create;
> +	}
> +
> +	return result;
> +
> +error_device_create:
> +	class_destroy(ctrl->class);
> +error_class_create:
> +	cdev_del(&ctrl->cdev);
> +error_cdev_add:
> +	unregister_chrdev_region(ctrl->dev, 1);
> +error_alloc_chrdev_region:
> +	return result;
> +}
> +
> +void bch_ctrl_device_deinit(void)
> +{
> +	struct bch_ctrl_device *ctrl =3D &_control_device;
> +
> +	device_destroy(ctrl->class, ctrl->dev);
> +	class_destroy(ctrl->class);
> +	cdev_del(&ctrl->cdev);
> +	unregister_chrdev_region(ctrl->dev, 1);
> +}
> diff --git a/drivers/md/bcache/control.h b/drivers/md/bcache/control.h
> new file mode 100644
> index 000000000000..3e4273db02a3
> --- /dev/null
> +++ b/drivers/md/bcache/control.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __BCACHE_CONTROL_H__
> +#define __BCACHE_CONTROL_H__
> +
> +#include "ioctl_codes.h"
> +
> +int __init bch_ctrl_device_init(void);
> +void bch_ctrl_device_deinit(void);
> +
> +ssize_t register_bcache_ioctl(struct bch_register_device *brd);
> +
> +#endif
> diff --git a/drivers/md/bcache/ioctl_codes.h =
b/drivers/md/bcache/ioctl_codes.h
> new file mode 100644
> index 000000000000..b004d60c29ff
> --- /dev/null
> +++ b/drivers/md/bcache/ioctl_codes.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __BCACHE_IOCTL_CODES_H__
> +#define __BCACHE_IOCTL_CODES_H__
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +struct bch_register_device {
> +	const char *dev_name;
> +	size_t size;
> +	struct cache_sb *sb;
> +};
> +
> +#define BCH_IOCTL_MAGIC (0xBC)
> +
> +/* Register a new backing device */
> +#define BCH_IOCTL_REGISTER_DEVICE	_IOWR(BCH_IOCTL_MAGIC, 1, struct =
bch_register_device)
> +
> +#endif
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 140f35dc0c45..339a11d00fef 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -14,6 +14,7 @@
> #include "request.h"
> #include "writeback.h"
> #include "features.h"
> +#include "control.h"
>=20
> #include <linux/blkdev.h>
> #include <linux/pagemap.h>
> @@ -340,6 +341,9 @@ void bch_write_bdev_super(struct cached_dev *dc, =
struct closure *parent)
> 	struct closure *cl =3D &dc->sb_write;
> 	struct bio *bio =3D &dc->sb_bio;
>=20
> +	if (!dc->sb_disk)
> +		return;
> +
> 	down(&dc->sb_write_mutex);
> 	closure_init(cl, parent);
>=20
> @@ -2403,14 +2407,14 @@ static int register_cache(struct cache_sb *sb, =
struct cache_sb_disk *sb_disk,
>=20
> /* Global interfaces/init */
>=20
> -static ssize_t register_bcache(struct kobject *k, struct =
kobj_attribute *attr,
> +static ssize_t register_bcache_sysfs(struct kobject *k, struct =
kobj_attribute *attr,
> 			       const char *buffer, size_t size);
> static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
> 					 struct kobj_attribute *attr,
> 					 const char *buffer, size_t =
size);
>=20
> -kobj_attribute_write(register,		register_bcache);
> -kobj_attribute_write(register_quiet,	register_bcache);
> +kobj_attribute_write(register,		register_bcache_sysfs);
> +kobj_attribute_write(register_quiet,	register_bcache_sysfs);
> kobj_attribute_write(pendings_cleanup,	=
bch_pending_bdevs_cleanup);
>=20
> static bool bch_is_open_backing(dev_t dev)
> @@ -2465,7 +2469,8 @@ static void register_bdev_worker(struct =
work_struct *work)
> 	dc =3D kzalloc(sizeof(*dc), GFP_KERNEL);
> 	if (!dc) {
> 		fail =3D true;
> -		put_page(virt_to_page(args->sb_disk));
> +		if (args->sb_disk)
> +			put_page(virt_to_page(args->sb_disk));
> 		blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | =
FMODE_EXCL);
> 		goto out;
> 	}
> @@ -2495,7 +2500,8 @@ static void register_cache_worker(struct =
work_struct *work)
> 	ca =3D kzalloc(sizeof(*ca), GFP_KERNEL);
> 	if (!ca) {
> 		fail =3D true;
> -		put_page(virt_to_page(args->sb_disk));
> +		if (args->sb_disk)
> +			put_page(virt_to_page(args->sb_disk));
> 		blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | =
FMODE_EXCL);
> 		goto out;
> 	}
> @@ -2525,7 +2531,7 @@ static void register_device_async(struct =
async_reg_args *args)
> 	queue_delayed_work(system_wq, &args->reg_work, 10);
> }
>=20
> -static ssize_t register_bcache(struct kobject *k, struct =
kobj_attribute *attr,
> +static ssize_t register_bcache_common(void *k, struct kobj_attribute =
*attr,
> 			       const char *buffer, size_t size)
> {
> 	const char *err;
> @@ -2587,9 +2593,14 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> 	if (set_blocksize(bdev, 4096))
> 		goto out_blkdev_put;
>=20
> -	err =3D read_super(sb, bdev, &sb_disk);
> -	if (err)
> -		goto out_blkdev_put;
> +	if (!k) {
> +		err =3D read_super(sb, bdev, &sb_disk);
> +		if (err)
> +			goto out_blkdev_put;
> +	} else {
> +		sb_disk =3D  NULL;
> +		memcpy(sb, (struct cache_sb *)k, sizeof(struct =
cache_sb));
> +	}
>=20
> 	err =3D "failed to register device";
>=20
> @@ -2651,7 +2662,8 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> 	return size;
>=20
> out_put_sb_page:
> -	put_page(virt_to_page(sb_disk));
> +	if (!k)
> +		put_page(virt_to_page(sb_disk));
> out_blkdev_put:
> 	blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
> out_free_sb:
> @@ -2666,6 +2678,18 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
> 	return ret;
> }
>=20
> +static ssize_t register_bcache_sysfs(struct kobject *k, struct =
kobj_attribute *attr,
> +			       const char *buffer, size_t size)
> +{
> +	return register_bcache_common(NULL, attr, buffer, size);
> +}
> +
> +ssize_t register_bcache_ioctl(struct bch_register_device *brd)
> +{
> +	return register_bcache_common((void *)brd->sb, NULL, =
brd->dev_name, brd->size);
> +}
> +
> +
>=20
> struct pdev {
> 	struct list_head list;
> @@ -2819,6 +2843,7 @@ static void bcache_exit(void)
> {
> 	bch_debug_exit();
> 	bch_request_exit();
> +	bch_ctrl_device_deinit();
> 	if (bcache_kobj)
> 		kobject_put(bcache_kobj);
> 	if (bcache_wq)
> @@ -2918,6 +2943,11 @@ static int __init bcache_init(void)
> 	bch_debug_init();
> 	closure_debug_init();
>=20
> +	if (bch_ctrl_device_init()) {
> +		pr_err("Cannot initialize control device\n");
> +		goto err;
> +	}
> +
> 	bcache_is_reboot =3D false;
>=20
> 	return 0;
> --
> 2.37.0
>=20

