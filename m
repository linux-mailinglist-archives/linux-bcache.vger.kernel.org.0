Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D413E44E6
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Aug 2021 13:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbhHILbQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Aug 2021 07:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbhHILbP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Aug 2021 07:31:15 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DA2C061799
        for <linux-bcache@vger.kernel.org>; Mon,  9 Aug 2021 04:30:55 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id e9so1934224vst.6
        for <linux-bcache@vger.kernel.org>; Mon, 09 Aug 2021 04:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fOiX5Fq3KXnBSLuawZfkvyDmjzsFYZZ+98EOQpFNGTM=;
        b=Uqs8Zs2QVxW19OPp6ZaYropMD8wq8XzkZj7QkVLqpPM9d4D1VE73zWGn2Wd4wVWWKo
         dCiEE20W3t4lEemNh9QhNYlHhoPpHwiij4/ziwEVih9Dv2II0zRp36htHJQnUV2V3WAN
         O3jpAmIUQ6x2uVTrMnu5r3hD17yyOicUYsFwihDXtVyLWJBVa8NqrtYlkcV1Lf7YLJMn
         9ILGVliAuaAmSDBjeEjxnw2gB0BnYc2oZAxv7NlNmtNgoZDf251iTf/dNeOLBlVK2opR
         GfIiXhpUH1vkvSo3w0n/gNe2zE30sKnNIiqxyZ0E3/cg3vcOLsR06s9dCjztnYA6RJQZ
         CeKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fOiX5Fq3KXnBSLuawZfkvyDmjzsFYZZ+98EOQpFNGTM=;
        b=oEd16KIt/Qvk1h/umG9Tn8eDqQMpyegxmqO1q8rUzLGuir65ujI8KptcZNHOu1CrC1
         8bcjc1sFwQZ6KJzXs1A+Sap1rcm55NhSNmBDRpo123Publ6awjLPrGA79IUUB0HAeN4N
         ewOIxcg5oDFnVWwTPdSU9fEKN9US9faAXYXyiW8mL+jEhmayKhzQG4TShBKpQk4V1eCg
         l9hni3ScB9DPyPllg3EORB+ufv0hTNNkgofBW/k31mAxGLSiGQhyJHM8nuU69+u/vakb
         0RHaj4JI6HRHzv8oaugB75q/gjJJgHLh+yw7Ivc4MVM2wHpn6WIey/5snds+ZMH2ogNr
         03oQ==
X-Gm-Message-State: AOAM530uKnrArl3leacj2neRmRAjdYsOvyoqmP4lzp7cPp2KnbU93tpU
        La9MEpiv4HBONbbBtHe43vyrMpoNF6LeUFv/uwSejQ==
X-Google-Smtp-Source: ABdhPJzFsvgytRJWqLZxvtQilzSUmLu3e4lpYoG45hUphYdCxvnwzfo5c76bu9iRy/GrvrZdQeDel/HkqPDrIvVs0T8=
X-Received: by 2002:a67:7c11:: with SMTP id x17mr15676775vsc.55.1628508654832;
 Mon, 09 Aug 2021 04:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210809064028.1198327-1-hch@lst.de> <20210809064028.1198327-2-hch@lst.de>
In-Reply-To: <20210809064028.1198327-2-hch@lst.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 9 Aug 2021 13:30:18 +0200
Message-ID: <CAPDyKFrpKqadCXZNypdk2rp8n1T1Xk-BO2B0FQ=rzbKyz_k8wg@mail.gmail.com>
Subject: Re: [PATCH 1/8] mmc: block: let device_add_disk create disk attributes
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 9 Aug 2021 at 08:43, Christoph Hellwig <hch@lst.de> wrote:
>
> Pass the attribute group for the attributes on the gendisk to
> device_add_disk so that they are created atomically with the
> disk creation.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Let's try to funnel this via Jens' tree. As long as his tree is based
upon v5.14-rc3 or later I don't think we should have any problem with
conflicts.

Kind regards
Uffe


> ---
>  drivers/mmc/core/block.c | 102 +++++++++++++++++----------------------
>  1 file changed, 45 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index ce8aed562929..4ac3e1b93e7e 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -128,8 +128,6 @@ struct mmc_blk_data {
>          * track of the current selected device partition.
>          */
>         unsigned int    part_curr;
> -       struct device_attribute force_ro;
> -       struct device_attribute power_ro_lock;
>         int     area_type;
>
>         /* debugfs files (only in main mmc_blk_data) */
> @@ -281,6 +279,9 @@ static ssize_t power_ro_lock_store(struct device *dev,
>         return count;
>  }
>
> +static DEVICE_ATTR(ro_lock_until_next_power_on, 0,
> +               power_ro_lock_show, power_ro_lock_store);
> +
>  static ssize_t force_ro_show(struct device *dev, struct device_attribute *attr,
>                              char *buf)
>  {
> @@ -313,6 +314,44 @@ static ssize_t force_ro_store(struct device *dev, struct device_attribute *attr,
>         return ret;
>  }
>
> +static DEVICE_ATTR(force_ro, 0644, force_ro_show, force_ro_store);
> +
> +static struct attribute *mmc_disk_attrs[] = {
> +       &dev_attr_force_ro.attr,
> +       &dev_attr_ro_lock_until_next_power_on.attr,
> +       NULL,
> +};
> +
> +static umode_t mmc_disk_attrs_is_visible(struct kobject *kobj,
> +               struct attribute *a, int n)
> +{
> +       struct device *dev = container_of(kobj, struct device, kobj);
> +       struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
> +       umode_t mode = a->mode;
> +
> +       if (a == &dev_attr_ro_lock_until_next_power_on.attr &&
> +           (md->area_type & MMC_BLK_DATA_AREA_BOOT) &&
> +           md->queue.card->ext_csd.boot_ro_lockable) {
> +               mode = S_IRUGO;
> +               if (!(md->queue.card->ext_csd.boot_ro_lock &
> +                               EXT_CSD_BOOT_WP_B_PWR_WP_DIS))
> +                       mode |= S_IWUSR;
> +       }
> +
> +       mmc_blk_put(md);
> +       return mode;
> +}
> +
> +static const struct attribute_group mmc_disk_attr_group = {
> +       .is_visible     = mmc_disk_attrs_is_visible,
> +       .attrs          = mmc_disk_attrs,
> +};
> +
> +static const struct attribute_group *mmc_disk_attr_groups[] = {
> +       &mmc_disk_attr_group,
> +       NULL,
> +};
> +
>  static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
>  {
>         struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
> @@ -2644,15 +2683,8 @@ static void mmc_blk_remove_req(struct mmc_blk_data *md)
>                  * from being accepted.
>                  */
>                 card = md->queue.card;
> -               if (md->disk->flags & GENHD_FL_UP) {
> -                       device_remove_file(disk_to_dev(md->disk), &md->force_ro);
> -                       if ((md->area_type & MMC_BLK_DATA_AREA_BOOT) &&
> -                                       card->ext_csd.boot_ro_lockable)
> -                               device_remove_file(disk_to_dev(md->disk),
> -                                       &md->power_ro_lock);
> -
> +               if (md->disk->flags & GENHD_FL_UP)
>                         del_gendisk(md->disk);
> -               }
>                 mmc_cleanup_queue(&md->queue);
>                 mmc_blk_put(md);
>         }
> @@ -2679,51 +2711,6 @@ static void mmc_blk_remove_parts(struct mmc_card *card,
>         }
>  }
>
> -static int mmc_add_disk(struct mmc_blk_data *md)
> -{
> -       int ret;
> -       struct mmc_card *card = md->queue.card;
> -
> -       device_add_disk(md->parent, md->disk, NULL);
> -       md->force_ro.show = force_ro_show;
> -       md->force_ro.store = force_ro_store;
> -       sysfs_attr_init(&md->force_ro.attr);
> -       md->force_ro.attr.name = "force_ro";
> -       md->force_ro.attr.mode = S_IRUGO | S_IWUSR;
> -       ret = device_create_file(disk_to_dev(md->disk), &md->force_ro);
> -       if (ret)
> -               goto force_ro_fail;
> -
> -       if ((md->area_type & MMC_BLK_DATA_AREA_BOOT) &&
> -            card->ext_csd.boot_ro_lockable) {
> -               umode_t mode;
> -
> -               if (card->ext_csd.boot_ro_lock & EXT_CSD_BOOT_WP_B_PWR_WP_DIS)
> -                       mode = S_IRUGO;
> -               else
> -                       mode = S_IRUGO | S_IWUSR;
> -
> -               md->power_ro_lock.show = power_ro_lock_show;
> -               md->power_ro_lock.store = power_ro_lock_store;
> -               sysfs_attr_init(&md->power_ro_lock.attr);
> -               md->power_ro_lock.attr.mode = mode;
> -               md->power_ro_lock.attr.name =
> -                                       "ro_lock_until_next_power_on";
> -               ret = device_create_file(disk_to_dev(md->disk),
> -                               &md->power_ro_lock);
> -               if (ret)
> -                       goto power_ro_lock_fail;
> -       }
> -       return ret;
> -
> -power_ro_lock_fail:
> -       device_remove_file(disk_to_dev(md->disk), &md->force_ro);
> -force_ro_fail:
> -       del_gendisk(md->disk);
> -
> -       return ret;
> -}
> -
>  #ifdef CONFIG_DEBUG_FS
>
>  static int mmc_dbg_card_status_get(void *data, u64 *val)
> @@ -2919,12 +2906,13 @@ static int mmc_blk_probe(struct mmc_card *card)
>
>         dev_set_drvdata(&card->dev, md);
>
> -       ret = mmc_add_disk(md);
> +       device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
>         if (ret)
>                 goto out;
>
>         list_for_each_entry(part_md, &md->part, part) {
> -               ret = mmc_add_disk(part_md);
> +               device_add_disk(part_md->parent, part_md->disk,
> +                               mmc_disk_attr_groups);
>                 if (ret)
>                         goto out;
>         }
> --
> 2.30.2
>
