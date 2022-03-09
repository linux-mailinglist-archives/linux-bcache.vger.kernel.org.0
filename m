Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E0A4D26E6
	for <lists+linux-bcache@lfdr.de>; Wed,  9 Mar 2022 05:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiCIBmv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 8 Mar 2022 20:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiCIBmv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Mar 2022 20:42:51 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF379A94C2
        for <linux-bcache@vger.kernel.org>; Tue,  8 Mar 2022 17:41:26 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id w37so672286pga.7
        for <linux-bcache@vger.kernel.org>; Tue, 08 Mar 2022 17:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZTl2y2GGoaRvzKMgjSxzmO1qrJqYJXGDFosGveNbnTY=;
        b=FewZAPUFTm9sXEGTvr8Vd4IZAEhwzpyku3S9XoPsv+5CvYTNCMoO089c1BLvedxbX+
         oR3qmB5uKtw3x8yQA+4qQEPSIE6T5qpHLdot1zFXhrQ1Dw5bsw+usNOQbTSHzaTnjZMt
         Cdkq2yrFQxD8ZHn2rsbk0uFIPdT5Abvup8rL7fKga3HLs9/TSGnmPabnBJzODkzpDXmY
         KErU/Y2N2dGJ9s4qPDWJKnCaBGUHaBoEhCvrBkWik3VuebeO1h+PCcOfhxqh2yKs7oCn
         Q/Eqo8HsYciW1DtTLCoNmkIlO6iQ+o3FwcqJnMlT2VGkQi6hQDqSpay87MXBV6rWHSUM
         xrbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZTl2y2GGoaRvzKMgjSxzmO1qrJqYJXGDFosGveNbnTY=;
        b=3pPNlzpdgBSfYK8lT8hQqhUXY5iEokJuiClOfexaUvVw3kvUpjtUFKqPL7t2OfgcpD
         RgOXukCRg3oL77F2c0kuXi5WE3Q817TOWPlMR45q9vFD/TE40YQeQQIEW7rIr7ABw/yf
         NirCJlTFq1wjj9yXjWsYekry2XLZaKJQxxmE/1LpBv+FxueXB+9saWtwvIFsreVTq5Yu
         0jj/7WHavoUtcVWSHlUOzZuoi0LpeN3ngtAAztdBAOnpjJxnGRzv8B0pIJ+at9gOIwK1
         fDyTVy0sPErJXojtzNNT9bLMQ6pk4ibZaNtbswZ5XWK2rPT1p9fnGgWKAmaK7R2sKt7P
         NK9Q==
X-Gm-Message-State: AOAM5334FvDHBUp6HyADYaWNHzdkJmktMoybJ9vv3wz9SEU5iOW1g8Ve
        rknCC0Q/F7CKYgA4KGOMf2lcs7kJSysmQ8MJy7I=
X-Google-Smtp-Source: ABdhPJycke/ySTprUqB6XHVG6RA605/3etX2nFegrZ4QY7sBNgh3eMpn5EmgZBwTb2waEWsukHUkRQ==
X-Received: by 2002:a65:48c8:0:b0:375:9c2b:ad33 with SMTP id o8-20020a6548c8000000b003759c2bad33mr17109165pgs.232.1646790083952;
        Tue, 08 Mar 2022 17:41:23 -0800 (PST)
Received: from [172.20.104.60] ([61.16.102.69])
        by smtp.gmail.com with ESMTPSA id u8-20020a056a00098800b004f702473553sm364867pfg.6.2022.03.08.17.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 17:41:23 -0800 (PST)
Message-ID: <24376746-9a12-fd0f-e1d5-c5c964381503@gmail.com>
Date:   Wed, 9 Mar 2022 09:41:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] bcache: Use bcache without formatting existing device
Content-Language: en-US
To:     Andrea Tomassetti <andrea.tomassetti@devo.com>,
        linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <20220308145623.209625-1-andrea.tomassetti@devo.com>
From:   Zhang Zhen <zhangzhen.email@gmail.com>
In-Reply-To: <20220308145623.209625-1-andrea.tomassetti@devo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Andrea，

Good job.
We just right need this feature.
This feature store super block in yaml configuration file.
Do I understand correctly?

Would you send out the udev rule and python script？
I want to try it.

Thanks.

On 3/8/22 10:56 PM, Andrea Tomassetti wrote:
> Introducing a bcache control device (/dev/bcache_ctrl)
> that allows communicating to the driver from user space
> via IOCTL. The only IOCTL commands currently implemented,
> receives a struct cache_sb and uses it to register the
> backing device.
> 
> Signed-off-by: Andrea Tomassetti <andrea.tomassetti@devo.com>
> ---
> Hi all,
> At Devo we started to think of using bcache in our production systems
> to boost performance. But, at the very beginning, we were faced with
> one annoying issue, at least for our use-case: bcache needs the backing
> devices to be formatted before being able to use them. What's really
> needed is just to wipe any FS signature out of them. This is definitely
> not an option we will consider in our production systems because we would
> need to move hundreds of terabytes of data.
> 
> To circumvent the "formatting" problem, in the past weeks I worked on some
> modifications to the actual bcache module. In particular, I added a bcache
> control device (exported to /dev/bcache_ctrl) that allows communicating to
> the driver from userspace via IOCTL. One of the IOCTL commands that I
> implemented receives a struct cache_sb and uses it to register the backing
> device. The modifications are really small and retro compatible. To then
> re-create the same configuration after every boot (because the backing
> devices now do not present the bcache super block anymore) I created an
> udev rule that invokes a python script that will re-create the same
> scenario based on a yaml configuration file.
> 
>   drivers/md/bcache/Makefile      |   2 +-
>   drivers/md/bcache/control.c     | 117 ++++++++++++++++++++++++++++++++
>   drivers/md/bcache/control.h     |  12 ++++
>   drivers/md/bcache/ioctl_codes.h |  19 ++++++
>   drivers/md/bcache/super.c       |  62 ++++++++++++-----
>   drivers/md/bcache/sysfs.c       |   4 ++
>   drivers/md/bcache/writeback.h   |   2 +-
>   7 files changed, 200 insertions(+), 18 deletions(-)
>   create mode 100644 drivers/md/bcache/control.c
>   create mode 100644 drivers/md/bcache/control.h
>   create mode 100644 drivers/md/bcache/ioctl_codes.h
> 
> diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
> index 5b87e59676b8..46ed41baed7a 100644
> --- a/drivers/md/bcache/Makefile
> +++ b/drivers/md/bcache/Makefile
> @@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)	+= bcache.o
> 
>   bcache-y		:= alloc.o bset.o btree.o closure.o debug.o extents.o\
>   	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
> -	util.o writeback.o features.o
> +	util.o writeback.o features.o control.o
> diff --git a/drivers/md/bcache/control.c b/drivers/md/bcache/control.c
> new file mode 100644
> index 000000000000..3d04d2218171
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
> +long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
> +		unsigned long arg)
> +{
> +	int retval = 0;
> +
> +	if (_IOC_TYPE(cmd) != BCH_IOCTL_MAGIC)
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
> +		cmd_info = vmalloc(sizeof(struct bch_register_device));
> +		if (!cmd_info)
> +			return -ENOMEM;
> +
> +		if (copy_from_user(cmd_info, (void __user *)arg,
> +				sizeof(struct bch_register_device))) {
> +			pr_err("Cannot copy cmd info from user space\n");
> +			vfree(cmd_info);
> +			return -EINVAL;
> +		}
> +
> +		retval = register_bcache_ioctl(cmd_info);
> +
> +		vfree(cmd_info);
> +		return result;
> +	}
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static const struct file_operations _ctrl_dev_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = bch_service_ioctl_ctrl
> +};
> +
> +int __init bch_ctrl_device_init(void)
> +{
> +	struct bch_ctrl_device *ctrl = &_control_device;
> +	struct device *device;
> +	int result = 0;
> +
> +	result = alloc_chrdev_region(&ctrl->dev, 0, 1, "bcache");
> +	if (result) {
> +		pr_err("Cannot allocate control chrdev number.\n");
> +		goto error_alloc_chrdev_region;
> +	}
> +
> +	cdev_init(&ctrl->cdev, &_ctrl_dev_fops);
> +
> +	result = cdev_add(&ctrl->cdev, ctrl->dev, 1);
> +	if (result) {
> +		pr_err("Cannot add control chrdev.\n");
> +		goto error_cdev_add;
> +	}
> +
> +	ctrl->class = class_create(THIS_MODULE, "bcache");
> +	if (IS_ERR(ctrl->class)) {
> +		pr_err("Cannot create control chrdev class.\n");
> +		result = PTR_ERR(ctrl->class);
> +		goto error_class_create;
> +	}
> +
> +	device = device_create(ctrl->class, NULL, ctrl->dev, NULL,
> +			"bcache_ctrl");
> +	if (IS_ERR(device)) {
> +		pr_err("Cannot create control chrdev.\n");
> +		result = PTR_ERR(device);
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
> +	struct bch_ctrl_device *ctrl = &_control_device;
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
> diff --git a/drivers/md/bcache/ioctl_codes.h b/drivers/md/bcache/ioctl_codes.h
> new file mode 100644
> index 000000000000..f25e038bee30
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
> +/** Start new cache instance, load cache or recover cache */
> +#define BCH_IOCTL_REGISTER_DEVICE	_IOWR(BCH_IOCTL_MAGIC, 1, struct bch_register_device)
> +
> +#endif
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 140f35dc0c45..95db3785a6e0 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -14,6 +14,7 @@
>   #include "request.h"
>   #include "writeback.h"
>   #include "features.h"
> +#include "control.h"
> 
>   #include <linux/blkdev.h>
>   #include <linux/pagemap.h>
> @@ -1069,7 +1070,7 @@ int bch_cached_dev_run(struct cached_dev *dc)
>   		goto out;
>   	}
> 
> -	if (!d->c &&
> +	if (!d->c && dc->sb_disk &&
>   	    BDEV_STATE(&dc->sb) != BDEV_STATE_NONE) {
>   		struct closure cl;
> 
> @@ -1259,9 +1260,6 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
>   	 */
> 
>   	if (bch_is_zero(u->uuid, 16)) {
> -		struct closure cl;
> -
> -		closure_init_stack(&cl);
> 
>   		memcpy(u->uuid, dc->sb.uuid, 16);
>   		memcpy(u->label, dc->sb.label, SB_LABEL_SIZE);
> @@ -1271,8 +1269,14 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
>   		memcpy(dc->sb.set_uuid, c->set_uuid, 16);
>   		SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
> 
> -		bch_write_bdev_super(dc, &cl);
> -		closure_sync(&cl);
> +		if (dc->sb_disk) {
> +			struct closure cl;
> +
> +			closure_init_stack(&cl);
> +			bch_write_bdev_super(dc, &cl);
> +			closure_sync(&cl);
> +		}
> +
>   	} else {
>   		u->last_reg = rtime;
>   		bch_uuid_write(c);
> @@ -2403,14 +2407,14 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
> 
>   /* Global interfaces/init */
> 
> -static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
> +static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_attribute *attr,
>   			       const char *buffer, size_t size);
>   static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
>   					 struct kobj_attribute *attr,
>   					 const char *buffer, size_t size);
> 
> -kobj_attribute_write(register,		register_bcache);
> -kobj_attribute_write(register_quiet,	register_bcache);
> +kobj_attribute_write(register,		register_bcache_sysfs);
> +kobj_attribute_write(register_quiet,	register_bcache_sysfs);
>   kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);
> 
>   static bool bch_is_open_backing(dev_t dev)
> @@ -2465,7 +2469,8 @@ static void register_bdev_worker(struct work_struct *work)
>   	dc = kzalloc(sizeof(*dc), GFP_KERNEL);
>   	if (!dc) {
>   		fail = true;
> -		put_page(virt_to_page(args->sb_disk));
> +		if (args->sb_disk)
> +			put_page(virt_to_page(args->sb_disk));
>   		blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
>   		goto out;
>   	}
> @@ -2495,7 +2500,8 @@ static void register_cache_worker(struct work_struct *work)
>   	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
>   	if (!ca) {
>   		fail = true;
> -		put_page(virt_to_page(args->sb_disk));
> +		if (args->sb_disk)
> +			put_page(virt_to_page(args->sb_disk));
>   		blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
>   		goto out;
>   	}
> @@ -2525,7 +2531,7 @@ static void register_device_async(struct async_reg_args *args)
>   	queue_delayed_work(system_wq, &args->reg_work, 10);
>   }
> 
> -static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
> +static ssize_t register_bcache_common(void *k, struct kobj_attribute *attr,
>   			       const char *buffer, size_t size)
>   {
>   	const char *err;
> @@ -2587,9 +2593,14 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>   	if (set_blocksize(bdev, 4096))
>   		goto out_blkdev_put;
> 
> -	err = read_super(sb, bdev, &sb_disk);
> -	if (err)
> -		goto out_blkdev_put;
> +	if (!k) {
> +		err = read_super(sb, bdev, &sb_disk);
> +		if (err)
> +			goto out_blkdev_put;
> +	} else {
> +		sb_disk =  NULL;
> +		memcpy(sb, (struct cache_sb *)k, sizeof(struct cache_sb));
> +	}
> 
>   	err = "failed to register device";
> 
> @@ -2651,7 +2662,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>   	return size;
> 
>   out_put_sb_page:
> -	put_page(virt_to_page(sb_disk));
> +	if (!k)
> +		put_page(virt_to_page(sb_disk));
>   out_blkdev_put:
>   	blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
>   out_free_sb:
> @@ -2666,6 +2678,18 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>   	return ret;
>   }
> 
> +static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_attribute *attr,
> +			       const char *buffer, size_t size)
> +{
> +	return register_bcache_common(NULL, attr, buffer, size);
> +}
> +
> +ssize_t register_bcache_ioctl(struct bch_register_device *brd)
> +{
> +	return register_bcache_common((void *)brd->sb, NULL, brd->dev_name, brd->size);
> +}
> +
> +
> 
>   struct pdev {
>   	struct list_head list;
> @@ -2819,6 +2843,7 @@ static void bcache_exit(void)
>   {
>   	bch_debug_exit();
>   	bch_request_exit();
> +	bch_ctrl_device_deinit();
>   	if (bcache_kobj)
>   		kobject_put(bcache_kobj);
>   	if (bcache_wq)
> @@ -2918,6 +2943,11 @@ static int __init bcache_init(void)
>   	bch_debug_init();
>   	closure_debug_init();
> 
> +	if (bch_ctrl_device_init()) {
> +		pr_err("Cannot initialize control device\n");
> +		goto err;
> +	}
> +
>   	bcache_is_reboot = false;
> 
>   	return 0;
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 1f0dce30fa75..984cc97a1d55 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -379,6 +379,10 @@ STORE(__cached_dev)
>   		if (v < 0)
>   			return v;
> 
> +		// XXX(atom): Devices created by IOCTL don't support changing cache mode
> +		if (!dc->sb_disk)
> +			return -EINVAL;
> +
>   		if ((unsigned int) v != BDEV_CACHE_MODE(&dc->sb)) {
>   			SET_BDEV_CACHE_MODE(&dc->sb, v);
>   			bch_write_bdev_super(dc, NULL);
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index 02b2f9df73f6..bd7b95bd2da7 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -135,7 +135,7 @@ static inline void bch_writeback_add(struct cached_dev *dc)
>   {
>   	if (!atomic_read(&dc->has_dirty) &&
>   	    !atomic_xchg(&dc->has_dirty, 1)) {
> -		if (BDEV_STATE(&dc->sb) != BDEV_STATE_DIRTY) {
> +		if (dc->sb_disk && BDEV_STATE(&dc->sb) != BDEV_STATE_DIRTY) {
>   			SET_BDEV_STATE(&dc->sb, BDEV_STATE_DIRTY);
>   			/* XXX: should do this synchronously */
>   			bch_write_bdev_super(dc, NULL);
> --
> 2.25.1
> 
> 
