Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB7C4E3E7F
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Mar 2022 13:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiCVMbG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Mar 2022 08:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiCVMbF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Mar 2022 08:31:05 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58936D867
        for <linux-bcache@vger.kernel.org>; Tue, 22 Mar 2022 05:29:37 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id a127so10629151vsa.3
        for <linux-bcache@vger.kernel.org>; Tue, 22 Mar 2022 05:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QLj6GXFWryPv5jQebaoxvZxhlfbwOv+a998IxmykyRw=;
        b=QRhnGh4VDseyIb2acLILsnf8xdxSNt4tg+Pb1cUf9v+rQvJhU2QI9Y+sIo9YKA8bDf
         VsmIMMLc1u0x9rTb8eJDy77pMvwPHnyu9xBRj8Yj7MmqjMx12+03DOKf+PpfeedKM+X8
         o3oclSLDZ/wPLdKtT6HSHiRFTt6LYO8IaxDmnAXN7/+ffBGsqKyBeVdmePD9vDiNX+lY
         SHeRuQfQyV/v9s1kRNrgQQrR1jsqX7NT9OHVStv9SKwzBNKoKpwwI+4DGhDq9elSoTk6
         fcOjE2RB39ytp8D7u0/zLgpMLaCOxHukEwYg7pWSwaUbEjyKpNAkwiuZyWc84OiX6tC2
         eIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QLj6GXFWryPv5jQebaoxvZxhlfbwOv+a998IxmykyRw=;
        b=VaaHyaZgTnSfz1NhBhQpvS/j5s3hbaDB/kKUlvm+Nz9tR0tRSB2U26b6oKU89G2rl1
         hX/xYIJbq9hFHxjDlyCAnYfjtlPKQEmAFN0CVWWxndlVcR0DUAwFmZJoCQFC1ow7UTD7
         siDiVwjk/bI7Ajrx8c59QSwHIdcruoGyKm7aGuu9EbfagRr6Dh9rvj3bHWOaCooTGQTM
         uaQIdPo+KsCy4NR9pGdVc6jKg0VmUi4Va1t6NIZmjje8T1hTAzVqZgfqfmXrc6HTcq4Z
         7mvpmKwpI/FUEew9SpEhQSp1IXyNq7B6XGGHRLov4mzEqB+DQZjsK++PeJjcAM+SGPAu
         Nqeg==
X-Gm-Message-State: AOAM530hOvgqJWKIU7hpdEDN9PnWpwYvc4usRo5xqMILZMnwOWErsWSV
        fOIMy8wXzMIWkrIKs8zgtYARrEVv3A3Ab7ja1SHIawAmD4PdohlIPUhi42EAX5TZRHSaLnxnEst
        2FE0XiqkisXpYKXoNlRjHSPoZMrEG9LEcptgFk9FU
X-Google-Smtp-Source: ABdhPJz5vEUN1rywrf2wutFk1QAShG/5B8/d/znbQ8JvUJK00otiFPBljQ+H5fKOufIA/+s2WH0MCti6sNxZ+zGvrFU=
X-Received: by 2002:a05:6102:838:b0:31a:c4de:648b with SMTP id
 k24-20020a056102083800b0031ac4de648bmr8764062vsb.46.1647952176570; Tue, 22
 Mar 2022 05:29:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220310113817.353422-1-andrea.tomassetti@devo.com>
In-Reply-To: <20220310113817.353422-1-andrea.tomassetti@devo.com>
From:   Andrea Tomassetti <andrea.tomassetti@devo.com>
Date:   Tue, 22 Mar 2022 13:29:25 +0100
Message-ID: <CAG2S0o-yjcc=HGVhZ-YfukT10+US45TemykFwETdgPRbJHLyqw@mail.gmail.com>
Subject: Re: [PATCH v3] bcache: Use bcache without formatting existing device
To:     linux-bcache@vger.kernel.org, kernel test robot <lkp@intel.com>
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>, kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

ping...  any comments?

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

On Thu, Mar 10, 2022 at 12:44 PM Andrea Tomassetti
<andrea.tomassetti@devo.com> wrote:
>
> v3: fix build warning reported by kernel test robot
>
> >> drivers/md/bcache/control.c:18:6: warning: no
>    previous prototype for function 'bch_service_ioctl_ctrl'
>    [-Wmissing-prototypes]
>    long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
>         ^
>    drivers/md/bcache/control.c:18:1: note: declare 'static' if the
>    function is not intended to be used outside of this translation unit
>    long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
>    ^
>    static
>    1 warning generated.
>
> Reported-by: kernel test robot <lkp@intel.com>
>
> v2: Fixed small typos
>
> Introducing a bcache control device (/dev/bcache_ctrl)
> that allows communicating to the driver from user space
> via IOCTL. The only IOCTL commands currently implemented,
> receives a struct cache_sb and uses it to register the
> backing device.
>
> Signed-off-by: Andrea Tomassetti <andrea.tomassetti@devo.com>
> ---
>  drivers/md/bcache/Makefile      |   2 +-
>  drivers/md/bcache/control.c     | 117 ++++++++++++++++++++++++++++++++
>  drivers/md/bcache/control.h     |  12 ++++
>  drivers/md/bcache/ioctl_codes.h |  19 ++++++
>  drivers/md/bcache/super.c       |  62 ++++++++++++-----
>  drivers/md/bcache/sysfs.c       |   4 ++
>  drivers/md/bcache/writeback.h   |   2 +-
>  7 files changed, 200 insertions(+), 18 deletions(-)
>  create mode 100644 drivers/md/bcache/control.c
>  create mode 100644 drivers/md/bcache/control.h
>  create mode 100644 drivers/md/bcache/ioctl_codes.h
>
> diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
> index 5b87e59676b8..46ed41baed7a 100644
> --- a/drivers/md/bcache/Makefile
> +++ b/drivers/md/bcache/Makefile
> @@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)    +=3D bcache.o
>
>  bcache-y               :=3D alloc.o bset.o btree.o closure.o debug.o ext=
ents.o\
>         io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace=
.o\
> -       util.o writeback.o features.o
> +       util.o writeback.o features.o control.o
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
> +       struct cdev cdev;
> +       struct class *class;
> +       dev_t dev;
> +};
> +
> +static struct bch_ctrl_device _control_device;
> +
> +/* this handles IOCTL for /dev/bcache_ctrl */
> +/*********************************************/
> +static long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
> +               unsigned long arg)
> +{
> +       int retval =3D 0;
> +
> +       if (_IOC_TYPE(cmd) !=3D BCH_IOCTL_MAGIC)
> +               return -EINVAL;
> +
> +       if (!capable(CAP_SYS_ADMIN)) {
> +               /* Must be root to issue ioctls */
> +               return -EPERM;
> +       }
> +
> +       switch (cmd) {
> +       case BCH_IOCTL_REGISTER_DEVICE: {
> +               struct bch_register_device *cmd_info;
> +
> +               cmd_info =3D vmalloc(sizeof(struct bch_register_device));
> +               if (!cmd_info)
> +                       return -ENOMEM;
> +
> +               if (copy_from_user(cmd_info, (void __user *)arg,
> +                               sizeof(struct bch_register_device))) {
> +                       pr_err("Cannot copy cmd info from user space\n");
> +                       vfree(cmd_info);
> +                       return -EINVAL;
> +               }
> +
> +               retval =3D register_bcache_ioctl(cmd_info);
> +
> +               vfree(cmd_info);
> +               return retval;
> +       }
> +
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
> +static const struct file_operations _ctrl_dev_fops =3D {
> +       .owner =3D THIS_MODULE,
> +       .unlocked_ioctl =3D bch_service_ioctl_ctrl
> +};
> +
> +int __init bch_ctrl_device_init(void)
> +{
> +       struct bch_ctrl_device *ctrl =3D &_control_device;
> +       struct device *device;
> +       int result =3D 0;
> +
> +       result =3D alloc_chrdev_region(&ctrl->dev, 0, 1, "bcache");
> +       if (result) {
> +               pr_err("Cannot allocate control chrdev number.\n");
> +               goto error_alloc_chrdev_region;
> +       }
> +
> +       cdev_init(&ctrl->cdev, &_ctrl_dev_fops);
> +
> +       result =3D cdev_add(&ctrl->cdev, ctrl->dev, 1);
> +       if (result) {
> +               pr_err("Cannot add control chrdev.\n");
> +               goto error_cdev_add;
> +       }
> +
> +       ctrl->class =3D class_create(THIS_MODULE, "bcache");
> +       if (IS_ERR(ctrl->class)) {
> +               pr_err("Cannot create control chrdev class.\n");
> +               result =3D PTR_ERR(ctrl->class);
> +               goto error_class_create;
> +       }
> +
> +       device =3D device_create(ctrl->class, NULL, ctrl->dev, NULL,
> +                       "bcache_ctrl");
> +       if (IS_ERR(device)) {
> +               pr_err("Cannot create control chrdev.\n");
> +               result =3D PTR_ERR(device);
> +               goto error_device_create;
> +       }
> +
> +       return result;
> +
> +error_device_create:
> +       class_destroy(ctrl->class);
> +error_class_create:
> +       cdev_del(&ctrl->cdev);
> +error_cdev_add:
> +       unregister_chrdev_region(ctrl->dev, 1);
> +error_alloc_chrdev_region:
> +       return result;
> +}
> +
> +void bch_ctrl_device_deinit(void)
> +{
> +       struct bch_ctrl_device *ctrl =3D &_control_device;
> +
> +       device_destroy(ctrl->class, ctrl->dev);
> +       class_destroy(ctrl->class);
> +       cdev_del(&ctrl->cdev);
> +       unregister_chrdev_region(ctrl->dev, 1);
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
> diff --git a/drivers/md/bcache/ioctl_codes.h b/drivers/md/bcache/ioctl_co=
des.h
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
> +       const char *dev_name;
> +       size_t size;
> +       struct cache_sb *sb;
> +};
> +
> +#define BCH_IOCTL_MAGIC (0xBC)
> +
> +/* Register a new backing device */
> +#define BCH_IOCTL_REGISTER_DEVICE      _IOWR(BCH_IOCTL_MAGIC, 1, struct =
bch_register_device)
> +
> +#endif
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 140f35dc0c45..95db3785a6e0 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -14,6 +14,7 @@
>  #include "request.h"
>  #include "writeback.h"
>  #include "features.h"
> +#include "control.h"
>
>  #include <linux/blkdev.h>
>  #include <linux/pagemap.h>
> @@ -1069,7 +1070,7 @@ int bch_cached_dev_run(struct cached_dev *dc)
>                 goto out;
>         }
>
> -       if (!d->c &&
> +       if (!d->c && dc->sb_disk &&
>             BDEV_STATE(&dc->sb) !=3D BDEV_STATE_NONE) {
>                 struct closure cl;
>
> @@ -1259,9 +1260,6 @@ int bch_cached_dev_attach(struct cached_dev *dc, st=
ruct cache_set *c,
>          */
>
>         if (bch_is_zero(u->uuid, 16)) {
> -               struct closure cl;
> -
> -               closure_init_stack(&cl);
>
>                 memcpy(u->uuid, dc->sb.uuid, 16);
>                 memcpy(u->label, dc->sb.label, SB_LABEL_SIZE);
> @@ -1271,8 +1269,14 @@ int bch_cached_dev_attach(struct cached_dev *dc, s=
truct cache_set *c,
>                 memcpy(dc->sb.set_uuid, c->set_uuid, 16);
>                 SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
>
> -               bch_write_bdev_super(dc, &cl);
> -               closure_sync(&cl);
> +               if (dc->sb_disk) {
> +                       struct closure cl;
> +
> +                       closure_init_stack(&cl);
> +                       bch_write_bdev_super(dc, &cl);
> +                       closure_sync(&cl);
> +               }
> +
>         } else {
>                 u->last_reg =3D rtime;
>                 bch_uuid_write(c);
> @@ -2403,14 +2407,14 @@ static int register_cache(struct cache_sb *sb, st=
ruct cache_sb_disk *sb_disk,
>
>  /* Global interfaces/init */
>
> -static ssize_t register_bcache(struct kobject *k, struct kobj_attribute =
*attr,
> +static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_attr=
ibute *attr,
>                                const char *buffer, size_t size);
>  static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
>                                          struct kobj_attribute *attr,
>                                          const char *buffer, size_t size)=
;
>
> -kobj_attribute_write(register,         register_bcache);
> -kobj_attribute_write(register_quiet,   register_bcache);
> +kobj_attribute_write(register,         register_bcache_sysfs);
> +kobj_attribute_write(register_quiet,   register_bcache_sysfs);
>  kobj_attribute_write(pendings_cleanup, bch_pending_bdevs_cleanup);
>
>  static bool bch_is_open_backing(dev_t dev)
> @@ -2465,7 +2469,8 @@ static void register_bdev_worker(struct work_struct=
 *work)
>         dc =3D kzalloc(sizeof(*dc), GFP_KERNEL);
>         if (!dc) {
>                 fail =3D true;
> -               put_page(virt_to_page(args->sb_disk));
> +               if (args->sb_disk)
> +                       put_page(virt_to_page(args->sb_disk));
>                 blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | FMODE_E=
XCL);
>                 goto out;
>         }
> @@ -2495,7 +2500,8 @@ static void register_cache_worker(struct work_struc=
t *work)
>         ca =3D kzalloc(sizeof(*ca), GFP_KERNEL);
>         if (!ca) {
>                 fail =3D true;
> -               put_page(virt_to_page(args->sb_disk));
> +               if (args->sb_disk)
> +                       put_page(virt_to_page(args->sb_disk));
>                 blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | FMODE_E=
XCL);
>                 goto out;
>         }
> @@ -2525,7 +2531,7 @@ static void register_device_async(struct async_reg_=
args *args)
>         queue_delayed_work(system_wq, &args->reg_work, 10);
>  }
>
> -static ssize_t register_bcache(struct kobject *k, struct kobj_attribute =
*attr,
> +static ssize_t register_bcache_common(void *k, struct kobj_attribute *at=
tr,
>                                const char *buffer, size_t size)
>  {
>         const char *err;
> @@ -2587,9 +2593,14 @@ static ssize_t register_bcache(struct kobject *k, =
struct kobj_attribute *attr,
>         if (set_blocksize(bdev, 4096))
>                 goto out_blkdev_put;
>
> -       err =3D read_super(sb, bdev, &sb_disk);
> -       if (err)
> -               goto out_blkdev_put;
> +       if (!k) {
> +               err =3D read_super(sb, bdev, &sb_disk);
> +               if (err)
> +                       goto out_blkdev_put;
> +       } else {
> +               sb_disk =3D  NULL;
> +               memcpy(sb, (struct cache_sb *)k, sizeof(struct cache_sb))=
;
> +       }
>
>         err =3D "failed to register device";
>
> @@ -2651,7 +2662,8 @@ static ssize_t register_bcache(struct kobject *k, s=
truct kobj_attribute *attr,
>         return size;
>
>  out_put_sb_page:
> -       put_page(virt_to_page(sb_disk));
> +       if (!k)
> +               put_page(virt_to_page(sb_disk));
>  out_blkdev_put:
>         blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
>  out_free_sb:
> @@ -2666,6 +2678,18 @@ static ssize_t register_bcache(struct kobject *k, =
struct kobj_attribute *attr,
>         return ret;
>  }
>
> +static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_attr=
ibute *attr,
> +                              const char *buffer, size_t size)
> +{
> +       return register_bcache_common(NULL, attr, buffer, size);
> +}
> +
> +ssize_t register_bcache_ioctl(struct bch_register_device *brd)
> +{
> +       return register_bcache_common((void *)brd->sb, NULL, brd->dev_nam=
e, brd->size);
> +}
> +
> +
>
>  struct pdev {
>         struct list_head list;
> @@ -2819,6 +2843,7 @@ static void bcache_exit(void)
>  {
>         bch_debug_exit();
>         bch_request_exit();
> +       bch_ctrl_device_deinit();
>         if (bcache_kobj)
>                 kobject_put(bcache_kobj);
>         if (bcache_wq)
> @@ -2918,6 +2943,11 @@ static int __init bcache_init(void)
>         bch_debug_init();
>         closure_debug_init();
>
> +       if (bch_ctrl_device_init()) {
> +               pr_err("Cannot initialize control device\n");
> +               goto err;
> +       }
> +
>         bcache_is_reboot =3D false;
>
>         return 0;
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 1f0dce30fa75..2df5b114e821 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -379,6 +379,10 @@ STORE(__cached_dev)
>                 if (v < 0)
>                         return v;
>
> +               // Devices created via IOCTL don't support changing cache=
 mode
> +               if (!dc->sb_disk)
> +                       return -EINVAL;
> +
>                 if ((unsigned int) v !=3D BDEV_CACHE_MODE(&dc->sb)) {
>                         SET_BDEV_CACHE_MODE(&dc->sb, v);
>                         bch_write_bdev_super(dc, NULL);
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.=
h
> index 02b2f9df73f6..bd7b95bd2da7 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -135,7 +135,7 @@ static inline void bch_writeback_add(struct cached_de=
v *dc)
>  {
>         if (!atomic_read(&dc->has_dirty) &&
>             !atomic_xchg(&dc->has_dirty, 1)) {
> -               if (BDEV_STATE(&dc->sb) !=3D BDEV_STATE_DIRTY) {
> +               if (dc->sb_disk && BDEV_STATE(&dc->sb) !=3D BDEV_STATE_DI=
RTY) {
>                         SET_BDEV_STATE(&dc->sb, BDEV_STATE_DIRTY);
>                         /* XXX: should do this synchronously */
>                         bch_write_bdev_super(dc, NULL);
> --
> 2.25.1
>

--=20







The contents of this email are confidential. If the reader of this=20
message is not the intended recipient, you are hereby notified that any=20
dissemination, distribution or copying of this communication is strictly=20
prohibited. If you have received this communication in error, please notify=
=20
us immediately by replying to this message and deleting it from your=20
computer. Thank you.=C2=A0Devo, Inc; arco@devo.com <mailto:arco@devo.com>;=
=C2=A0=C2=A0
Calle Est=C3=A9banez Calder=C3=B3n 3-5, 5th Floor. Madrid, Spain 28020

