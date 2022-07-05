Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BE5566564
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jul 2022 10:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiGEIsk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Jul 2022 04:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiGEIsa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Jul 2022 04:48:30 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2159C28
        for <linux-bcache@vger.kernel.org>; Tue,  5 Jul 2022 01:48:28 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id z13so12734001qts.12
        for <linux-bcache@vger.kernel.org>; Tue, 05 Jul 2022 01:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nh21LPL1YxnuB7CtIfEbcXEXdykvCmhFflJYG7l0HtM=;
        b=E4/UwNtIp4ElImKcQnl12RtVggr34ONpylpm96u/9rp8PcM7ympJad4Zx2OM4Ye/jv
         UyPKBZFsp6Z4Vhzmm1N/XNqQFqP4NwNmABALsuveR4RsgDeYPawXa9BRLSjeuYEiV2b+
         RPKDJMb3VjYjWakEhfKlqa12XfYpRA4WAUH6oI2ciLA+MQhskQVuIP4v4YP/Jl/GWifi
         23W1ITnIdbmT6vbjsIlmXkcf/XCUuAIdfANBrjs5Amn3hmFWId9fVSft/o8Ws5ti1OYq
         hBZLgj1gqBbXJEKhOk/RY0ndz8kJM5BbOIMx+gqkPRP+05Pfvn6wMKl+vTYB1EKQhSk3
         9pPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nh21LPL1YxnuB7CtIfEbcXEXdykvCmhFflJYG7l0HtM=;
        b=hV85cbr88e0zzxGgToi302nIS2WCTfIcSVFRQZ+zhmJCC21tminLFR3QFcztwghQq7
         2RwU+doa6TCMXk9g2PKb2Cbq3TpQYRY2GfPygVS3CJrXqbCrI2d5EYZdnywUUQZsTnV8
         vRXCqlhlUYhH0hoyyvm5Az5ZsK7C50kGoG0jtwWWbIFWeH6OVNCVf1kXIQj6pOrTCFaz
         D9iXv7C8GbbuEdKrT7T2lLFbifd+NZ3iSt45jMFQJ+2malNxmFvwBqqXBxXzzZi/mvnA
         uIF+qBMLvLDeV0yKBFmL+j9OnAiwh2m3Aor1PqAYv+q2yNDuxce22TlBmxLve7Q9S+ZK
         EuAQ==
X-Gm-Message-State: AJIora/0Jz+BQ04RZYYKrIW51XlU/vk2nvPacib5xUqxyrA731AgOTbD
        eek4gyOU9VO0U7GTXqc1038JgUFv1vrMkzHIhdRsasOTHYw4q5glA34=
X-Google-Smtp-Source: AGRyM1vN96zZLU90Y2+5ZH5I+KMm+jT4jAqGFBVxUqB+Ez+qhfXTZJOqy7/soUaS1HmBLmvArVEJzF7lQypqCH9raJ8=
X-Received: by 2002:ac8:5fc3:0:b0:31d:2637:7ed6 with SMTP id
 k3-20020ac85fc3000000b0031d26377ed6mr25556132qta.282.1657010907748; Tue, 05
 Jul 2022 01:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220704151320.78094-1-andrea.tomassetti-opensource@devo.com> <B18A4668-47F5-4219-8336-EDB00D0292C2@suse.de>
In-Reply-To: <B18A4668-47F5-4219-8336-EDB00D0292C2@suse.de>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Tue, 5 Jul 2022 10:48:17 +0200
Message-ID: <CAHykVA48C-8JBsyZG8_iGzBJ9rjDMrW7O0mk9L4PDpRAP0yUXQ@mail.gmail.com>
Subject: Re: [PATCH] bcache: Use bcache without formatting existing device
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>
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

On Mon, Jul 4, 2022 at 5:29 PM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2022=E5=B9=B47=E6=9C=884=E6=97=A5 23:13=EF=BC=8CAndrea Tomassetti <andr=
ea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Introducing a bcache control device (/dev/bcache_ctrl)
> > that allows communicating to the driver from user space
> > via IOCTL. The only IOCTL commands currently implemented,
> > receives a struct cache_sb and uses it to register the
> > backing device without any need of formatting them.
> >
> > Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com=
>
> > ---
> > Hi all,
> > At Devo we started to think of using bcache in our production systems
> > to boost performance. But, at the very beginning, we were faced with
> > one annoying issue, at least for our use-case: bcache needs the backing
> > devices to be formatted before being able to use them. What's really
> > needed is just to wipe any FS signature out of them. This is definitely
> > not an option we will consider in our production systems because we wou=
ld
> > need to move hundreds of terabytes of data.
> >
> > To circumvent the "formatting" problem, in the past weeks I worked on s=
ome
> > modifications to the actual bcache module. In particular, I added a bca=
che
> > control device (exported to /dev/bcache_ctrl) that allows communicating=
 to
> > the driver from userspace via IOCTL. One of the IOCTL commands that I
> > implemented receives a struct cache_sb and uses it to register the back=
ing
> > device. The modifications are really small and retro compatible. To the=
n
> > re-create the same configuration after every boot (because the backing
> > devices now do not present the bcache super block anymore) I created an
> > udev rule that invokes a python script that will re-create the same
> > scenario based on a yaml configuration file.
> >
> > I'm re-sending this patch without any confidentiality footer, sorry for=
 that.
>
> Thanks for removing that confidential and legal statement, that=E2=80=99s=
 the reason I was not able to reply your email.
>
Thank you for your patience and sorry for the newbie mistake.
> Back to the patch, I don=E2=80=99t support this idea. For the problem you=
 are solving, indeed people uses device mapper linear target for many years=
, and it works perfectly without any code modification.
>
> That is, create a 8K image and set it as a loop device, then write a dm t=
able to combine it with the existing hard drive. Then you run =E2=80=9Cbcac=
he make -B <combined dm target>=E2=80=9D, you will get a bcache device whos=
e first 8K in the loop device and existing super block of the hard driver l=
ocated at expected offset.
>
We evaluated this option but we weren't satisfied by the outcomes for,
at least, two main reasons: complexity and operational drawbacks.
For the complexity side: in production we use more than 20 HD that
need to be cached. It means we need to create 20+ header for them, 20+
loop devices and 20+ dm linear devices. So, basically, there's a 3x
factor for each HD that we want to cache. Moreover, we're currently
using ephemeral disks as cache devices. In case of a machine reboot,
ephemeral devices can get lost; at this point, there will be some trouble
to mount the dm-linear bcache backing device because there will be no
cache device.

For the operational drawbacks: from time to time, we exploit the
online filesystem resize capability of XFS to increase the volume
size. This would be at least tedious, if not nearly impossible, if the
volume is mapped inside a dm-linear.
> It is unnecessary to create a new IOCTL interface, and I feel the way how=
 it works is really unconvinced for potential security risk.
>
Which potential security risks concern you?

Thank you,
Andrea
> Thanks.
>
> Coly Li
>
> >
> > drivers/md/bcache/Makefile      |   2 +-
> > drivers/md/bcache/control.c     | 117 ++++++++++++++++++++++++++++++++
> > drivers/md/bcache/control.h     |  12 ++++
> > drivers/md/bcache/ioctl_codes.h |  19 ++++++
> > drivers/md/bcache/super.c       |  50 +++++++++++---
> > 5 files changed, 189 insertions(+), 11 deletions(-)
> > create mode 100644 drivers/md/bcache/control.c
> > create mode 100644 drivers/md/bcache/control.h
> > create mode 100644 drivers/md/bcache/ioctl_codes.h
> >
> > diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
> > index 5b87e59676b8..46ed41baed7a 100644
> > --- a/drivers/md/bcache/Makefile
> > +++ b/drivers/md/bcache/Makefile
> > @@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)  +=3D bcache.o
> >
> > bcache-y              :=3D alloc.o bset.o btree.o closure.o debug.o ext=
ents.o\
> >       io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace=
.o\
> > -     util.o writeback.o features.o
> > +     util.o writeback.o features.o control.o
> > diff --git a/drivers/md/bcache/control.c b/drivers/md/bcache/control.c
> > new file mode 100644
> > index 000000000000..69b5e554d093
> > --- /dev/null
> > +++ b/drivers/md/bcache/control.c
> > @@ -0,0 +1,117 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/cdev.h>
> > +#include <linux/fs.h>
> > +#include <linux/vmalloc.h>
> > +
> > +#include "control.h"
> > +
> > +struct bch_ctrl_device {
> > +     struct cdev cdev;
> > +     struct class *class;
> > +     dev_t dev;
> > +};
> > +
> > +static struct bch_ctrl_device _control_device;
> > +
> > +/* this handles IOCTL for /dev/bcache_ctrl */
> > +/*********************************************/
> > +static long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd=
,
> > +             unsigned long arg)
> > +{
> > +     int retval =3D 0;
> > +
> > +     if (_IOC_TYPE(cmd) !=3D BCH_IOCTL_MAGIC)
> > +             return -EINVAL;
> > +
> > +     if (!capable(CAP_SYS_ADMIN)) {
> > +             /* Must be root to issue ioctls */
> > +             return -EPERM;
> > +     }
> > +
> > +     switch (cmd) {
> > +     case BCH_IOCTL_REGISTER_DEVICE: {
> > +             struct bch_register_device *cmd_info;
> > +
> > +             cmd_info =3D vmalloc(sizeof(struct bch_register_device));
> > +             if (!cmd_info)
> > +                     return -ENOMEM;
> > +
> > +             if (copy_from_user(cmd_info, (void __user *)arg,
> > +                             sizeof(struct bch_register_device))) {
> > +                     pr_err("Cannot copy cmd info from user space\n");
> > +                     vfree(cmd_info);
> > +                     return -EINVAL;
> > +             }
> > +
> > +             retval =3D register_bcache_ioctl(cmd_info);
> > +
> > +             vfree(cmd_info);
> > +             return retval;
> > +     }
> > +
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +}
> > +
> > +static const struct file_operations _ctrl_dev_fops =3D {
> > +     .owner =3D THIS_MODULE,
> > +     .unlocked_ioctl =3D bch_service_ioctl_ctrl
> > +};
> > +
> > +int __init bch_ctrl_device_init(void)
> > +{
> > +     struct bch_ctrl_device *ctrl =3D &_control_device;
> > +     struct device *device;
> > +     int result =3D 0;
> > +
> > +     result =3D alloc_chrdev_region(&ctrl->dev, 0, 1, "bcache");
> > +     if (result) {
> > +             pr_err("Cannot allocate control chrdev number.\n");
> > +             goto error_alloc_chrdev_region;
> > +     }
> > +
> > +     cdev_init(&ctrl->cdev, &_ctrl_dev_fops);
> > +
> > +     result =3D cdev_add(&ctrl->cdev, ctrl->dev, 1);
> > +     if (result) {
> > +             pr_err("Cannot add control chrdev.\n");
> > +             goto error_cdev_add;
> > +     }
> > +
> > +     ctrl->class =3D class_create(THIS_MODULE, "bcache");
> > +     if (IS_ERR(ctrl->class)) {
> > +             pr_err("Cannot create control chrdev class.\n");
> > +             result =3D PTR_ERR(ctrl->class);
> > +             goto error_class_create;
> > +     }
> > +
> > +     device =3D device_create(ctrl->class, NULL, ctrl->dev, NULL,
> > +                     "bcache_ctrl");
> > +     if (IS_ERR(device)) {
> > +             pr_err("Cannot create control chrdev.\n");
> > +             result =3D PTR_ERR(device);
> > +             goto error_device_create;
> > +     }
> > +
> > +     return result;
> > +
> > +error_device_create:
> > +     class_destroy(ctrl->class);
> > +error_class_create:
> > +     cdev_del(&ctrl->cdev);
> > +error_cdev_add:
> > +     unregister_chrdev_region(ctrl->dev, 1);
> > +error_alloc_chrdev_region:
> > +     return result;
> > +}
> > +
> > +void bch_ctrl_device_deinit(void)
> > +{
> > +     struct bch_ctrl_device *ctrl =3D &_control_device;
> > +
> > +     device_destroy(ctrl->class, ctrl->dev);
> > +     class_destroy(ctrl->class);
> > +     cdev_del(&ctrl->cdev);
> > +     unregister_chrdev_region(ctrl->dev, 1);
> > +}
> > diff --git a/drivers/md/bcache/control.h b/drivers/md/bcache/control.h
> > new file mode 100644
> > index 000000000000..3e4273db02a3
> > --- /dev/null
> > +++ b/drivers/md/bcache/control.h
> > @@ -0,0 +1,12 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __BCACHE_CONTROL_H__
> > +#define __BCACHE_CONTROL_H__
> > +
> > +#include "ioctl_codes.h"
> > +
> > +int __init bch_ctrl_device_init(void);
> > +void bch_ctrl_device_deinit(void);
> > +
> > +ssize_t register_bcache_ioctl(struct bch_register_device *brd);
> > +
> > +#endif
> > diff --git a/drivers/md/bcache/ioctl_codes.h b/drivers/md/bcache/ioctl_=
codes.h
> > new file mode 100644
> > index 000000000000..b004d60c29ff
> > --- /dev/null
> > +++ b/drivers/md/bcache/ioctl_codes.h
> > @@ -0,0 +1,19 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __BCACHE_IOCTL_CODES_H__
> > +#define __BCACHE_IOCTL_CODES_H__
> > +
> > +#include <linux/ioctl.h>
> > +#include <linux/types.h>
> > +
> > +struct bch_register_device {
> > +     const char *dev_name;
> > +     size_t size;
> > +     struct cache_sb *sb;
> > +};
> > +
> > +#define BCH_IOCTL_MAGIC (0xBC)
> > +
> > +/* Register a new backing device */
> > +#define BCH_IOCTL_REGISTER_DEVICE    _IOWR(BCH_IOCTL_MAGIC, 1, struct =
bch_register_device)
> > +
> > +#endif
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 140f35dc0c45..339a11d00fef 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -14,6 +14,7 @@
> > #include "request.h"
> > #include "writeback.h"
> > #include "features.h"
> > +#include "control.h"
> >
> > #include <linux/blkdev.h>
> > #include <linux/pagemap.h>
> > @@ -340,6 +341,9 @@ void bch_write_bdev_super(struct cached_dev *dc, st=
ruct closure *parent)
> >       struct closure *cl =3D &dc->sb_write;
> >       struct bio *bio =3D &dc->sb_bio;
> >
> > +     if (!dc->sb_disk)
> > +             return;
> > +
> >       down(&dc->sb_write_mutex);
> >       closure_init(cl, parent);
> >
> > @@ -2403,14 +2407,14 @@ static int register_cache(struct cache_sb *sb, =
struct cache_sb_disk *sb_disk,
> >
> > /* Global interfaces/init */
> >
> > -static ssize_t register_bcache(struct kobject *k, struct kobj_attribut=
e *attr,
> > +static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_at=
tribute *attr,
> >                              const char *buffer, size_t size);
> > static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
> >                                        struct kobj_attribute *attr,
> >                                        const char *buffer, size_t size)=
;
> >
> > -kobj_attribute_write(register,               register_bcache);
> > -kobj_attribute_write(register_quiet, register_bcache);
> > +kobj_attribute_write(register,               register_bcache_sysfs);
> > +kobj_attribute_write(register_quiet, register_bcache_sysfs);
> > kobj_attribute_write(pendings_cleanup,        bch_pending_bdevs_cleanup=
);
> >
> > static bool bch_is_open_backing(dev_t dev)
> > @@ -2465,7 +2469,8 @@ static void register_bdev_worker(struct work_stru=
ct *work)
> >       dc =3D kzalloc(sizeof(*dc), GFP_KERNEL);
> >       if (!dc) {
> >               fail =3D true;
> > -             put_page(virt_to_page(args->sb_disk));
> > +             if (args->sb_disk)
> > +                     put_page(virt_to_page(args->sb_disk));
> >               blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | FMODE_E=
XCL);
> >               goto out;
> >       }
> > @@ -2495,7 +2500,8 @@ static void register_cache_worker(struct work_str=
uct *work)
> >       ca =3D kzalloc(sizeof(*ca), GFP_KERNEL);
> >       if (!ca) {
> >               fail =3D true;
> > -             put_page(virt_to_page(args->sb_disk));
> > +             if (args->sb_disk)
> > +                     put_page(virt_to_page(args->sb_disk));
> >               blkdev_put(args->bdev, FMODE_READ | FMODE_WRITE | FMODE_E=
XCL);
> >               goto out;
> >       }
> > @@ -2525,7 +2531,7 @@ static void register_device_async(struct async_re=
g_args *args)
> >       queue_delayed_work(system_wq, &args->reg_work, 10);
> > }
> >
> > -static ssize_t register_bcache(struct kobject *k, struct kobj_attribut=
e *attr,
> > +static ssize_t register_bcache_common(void *k, struct kobj_attribute *=
attr,
> >                              const char *buffer, size_t size)
> > {
> >       const char *err;
> > @@ -2587,9 +2593,14 @@ static ssize_t register_bcache(struct kobject *k=
, struct kobj_attribute *attr,
> >       if (set_blocksize(bdev, 4096))
> >               goto out_blkdev_put;
> >
> > -     err =3D read_super(sb, bdev, &sb_disk);
> > -     if (err)
> > -             goto out_blkdev_put;
> > +     if (!k) {
> > +             err =3D read_super(sb, bdev, &sb_disk);
> > +             if (err)
> > +                     goto out_blkdev_put;
> > +     } else {
> > +             sb_disk =3D  NULL;
> > +             memcpy(sb, (struct cache_sb *)k, sizeof(struct cache_sb))=
;
> > +     }
> >
> >       err =3D "failed to register device";
> >
> > @@ -2651,7 +2662,8 @@ static ssize_t register_bcache(struct kobject *k,=
 struct kobj_attribute *attr,
> >       return size;
> >
> > out_put_sb_page:
> > -     put_page(virt_to_page(sb_disk));
> > +     if (!k)
> > +             put_page(virt_to_page(sb_disk));
> > out_blkdev_put:
> >       blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
> > out_free_sb:
> > @@ -2666,6 +2678,18 @@ static ssize_t register_bcache(struct kobject *k=
, struct kobj_attribute *attr,
> >       return ret;
> > }
> >
> > +static ssize_t register_bcache_sysfs(struct kobject *k, struct kobj_at=
tribute *attr,
> > +                            const char *buffer, size_t size)
> > +{
> > +     return register_bcache_common(NULL, attr, buffer, size);
> > +}
> > +
> > +ssize_t register_bcache_ioctl(struct bch_register_device *brd)
> > +{
> > +     return register_bcache_common((void *)brd->sb, NULL, brd->dev_nam=
e, brd->size);
> > +}
> > +
> > +
> >
> > struct pdev {
> >       struct list_head list;
> > @@ -2819,6 +2843,7 @@ static void bcache_exit(void)
> > {
> >       bch_debug_exit();
> >       bch_request_exit();
> > +     bch_ctrl_device_deinit();
> >       if (bcache_kobj)
> >               kobject_put(bcache_kobj);
> >       if (bcache_wq)
> > @@ -2918,6 +2943,11 @@ static int __init bcache_init(void)
> >       bch_debug_init();
> >       closure_debug_init();
> >
> > +     if (bch_ctrl_device_init()) {
> > +             pr_err("Cannot initialize control device\n");
> > +             goto err;
> > +     }
> > +
> >       bcache_is_reboot =3D false;
> >
> >       return 0;
> > --
> > 2.37.0
> >
>
