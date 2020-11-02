Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86AF2A2985
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Nov 2020 12:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgKBLaK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Nov 2020 06:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgKBLaK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Nov 2020 06:30:10 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED15C0617A6;
        Mon,  2 Nov 2020 03:30:05 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id t13so4671030ilp.2;
        Mon, 02 Nov 2020 03:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8sUFnRhpnLvg7Edccau1zP+dWkQRjNO5vrDkvqn3/Yo=;
        b=jLuIKgWriDRxMgI2AiuOdNFIgDsPVBJsLKxgfRIXXGVbdL6r8kSn+BSLm1lQXISCG6
         O0LNHKmTmYC4zDJpDa7M0SFjOEdxTEN8Ax9ezfwA3XBzKd1zzem9OtH+dftOfFllmBXZ
         QwpP7IMjL36MyfBKKfh22hQngXmxc8QrsFWOV6t8YrOKk0sqncnBsZiT7KfibIb9G+OU
         fldtoNWCAlh70Nm5A5VE/gR3iE7lmDy7OBbtAvBBLXmhFhwveqbLvH7ugaEHEaqsKE2U
         D7sIK9/xTPLckHko6qUcyq4805xHKFZfIYVyFl/yg+WcDgCxOQkzsYQdtRIMwmvPNZkB
         H7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8sUFnRhpnLvg7Edccau1zP+dWkQRjNO5vrDkvqn3/Yo=;
        b=mVfV1c6Bu1+s5F5dnuf7GP6DgIt89/kZkNWbJtQi1kcUN+wieGcmHurBAsGPDRJUbo
         o1Y8plVV/YJgRoiJfQAm+2k4wFQh/F+6F9dapG6Qwf9tEQhfY0kbyzjLt6zbo0AMLWj2
         wGjA/j4vuVCTxXCgNSj5b72q3ntT37e3bk7UGEzdN0Q6rvle8Wwbr0vtaS9rqsz/gaT7
         vNiHPpZlpNGborkfpj/TqLj7nQc8fk8GDTnuUu0etPSFC8WSdVlN1Lz0Mu3+t+/NX24r
         tB9jsapbswaLHVwMmJY1IAZ75A5p96LNB9Vl2mmTXgJNM2Njw8BoH3KdDx8ZDYZ42Wa1
         vAig==
X-Gm-Message-State: AOAM533oAYWoYwEaNo1Wf5tleEPD4CQNEZbCNNcFnoybtcwTl+PFlotH
        oPTXW9bijnXPvTqnAWqDE4CfzBR1FR//K9PhNek=
X-Google-Smtp-Source: ABdhPJzpyGmJV5pG8ZiDqRv2txjmaZQGWb7h3zlA7GiMfetk64KQGYmh/FJhJNPZ6zDF33Q1fRfyCjNzxRjhwa73XGA=
X-Received: by 2002:a92:1f43:: with SMTP id i64mr9932879ile.281.1604316605261;
 Mon, 02 Nov 2020 03:30:05 -0800 (PST)
MIME-Version: 1.0
References: <20201031085810.450489-1-hch@lst.de> <20201031085810.450489-6-hch@lst.de>
In-Reply-To: <20201031085810.450489-6-hch@lst.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 2 Nov 2020 12:30:05 +0100
Message-ID: <CAOi1vP_-GydZpwuR2DWpNmz2N2Wf7MHDbXudLB=t5xuEEq3Y=w@mail.gmail.com>
Subject: Re: [PATCH 05/11] rbd: implement ->set_read_only to hook into
 BLKROSET processing
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block <linux-block@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Oct 31, 2020 at 10:11 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Implement the ->set_read_only method instead of parsing the actual
> ioctl command.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/rbd.c | 41 ++++-------------------------------------
>  1 file changed, 4 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index f84128abade319..37f8fc28004acb 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -692,12 +692,9 @@ static void rbd_release(struct gendisk *disk, fmode_t mode)
>         put_device(&rbd_dev->dev);
>  }
>
> -static int rbd_ioctl_set_ro(struct rbd_device *rbd_dev, unsigned long arg)
> +static int rbd_set_read_only(struct block_device *bdev, bool ro)
>  {
> -       int ro;
> -
> -       if (get_user(ro, (int __user *)arg))
> -               return -EFAULT;
> +       struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
>
>         /*
>          * Both images mapped read-only and snapshots can't be marked
> @@ -706,47 +703,17 @@ static int rbd_ioctl_set_ro(struct rbd_device *rbd_dev, unsigned long arg)
>         if (!ro) {
>                 if (rbd_is_ro(rbd_dev))
>                         return -EROFS;
> -
>                 rbd_assert(!rbd_is_snap(rbd_dev));

If you repost, please leave this empty line.

>         }
>
> -       /* Let blkdev_roset() handle it */
> -       return -ENOTTY;
> -}
> -
> -static int rbd_ioctl(struct block_device *bdev, fmode_t mode,
> -                       unsigned int cmd, unsigned long arg)
> -{
> -       struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
> -       int ret;
> -
> -       switch (cmd) {
> -       case BLKROSET:
> -               ret = rbd_ioctl_set_ro(rbd_dev, arg);
> -               break;
> -       default:
> -               ret = -ENOTTY;
> -       }
> -
> -       return ret;
> -}
> -
> -#ifdef CONFIG_COMPAT
> -static int rbd_compat_ioctl(struct block_device *bdev, fmode_t mode,
> -                               unsigned int cmd, unsigned long arg)
> -{
> -       return rbd_ioctl(bdev, mode, cmd, arg);
> +       return 0;
>  }
> -#endif /* CONFIG_COMPAT */
>
>  static const struct block_device_operations rbd_bd_ops = {
>         .owner                  = THIS_MODULE,
>         .open                   = rbd_open,
>         .release                = rbd_release,
> -       .ioctl                  = rbd_ioctl,
> -#ifdef CONFIG_COMPAT
> -       .compat_ioctl           = rbd_compat_ioctl,
> -#endif
> +       .set_read_only          = rbd_set_read_only,
>  };
>
>  /*
> --
> 2.28.0
>

With that nit,

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
