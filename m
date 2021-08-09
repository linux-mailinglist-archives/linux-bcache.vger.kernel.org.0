Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727A93E44EA
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Aug 2021 13:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbhHILbX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Aug 2021 07:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbhHILbV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Aug 2021 07:31:21 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B65C061796
        for <linux-bcache@vger.kernel.org>; Mon,  9 Aug 2021 04:31:01 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id a4so3369788uae.6
        for <linux-bcache@vger.kernel.org>; Mon, 09 Aug 2021 04:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IV6BRlu5nqWBo0sf/tGMiDpNp/29jpZe7hZGlMgK9TE=;
        b=pd99atNghWR2EXFgv8XZJakjfWaxf7WhyknLM8kIoOHa4YgdfnoTPB5B5yZKzpLLeL
         8Obky1Touzww7JJ1LPkDR5ussYz78TDCT/aOUVtyInKRanV+yhskxWy13r4ELz5Zt3+W
         j9ZgRTqbG9Kk64HZ1JdseYys90ZGg5RbdLCoMBVBvfCnnouHZHy1qNjIffFsLIDWhKR3
         uEtKIcbj7BvqzUXb9yfl6fU6G44H8iNCHs0xPANj5Q3vS42f1YwZgr2i8eKmWNKpr9uz
         y4W3Mq4knk8u4HtsRKPZJo69FOfCe9ybgJAnEPiZm5i2N8d8t0qXR+Sy+nPjW/M5xCMV
         9Ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IV6BRlu5nqWBo0sf/tGMiDpNp/29jpZe7hZGlMgK9TE=;
        b=sERIOShXVvJ/eiov2/KQ1qnHzSMIoId6/GEw9wY8tJkvXVyL0GdBDNzavT6OyQ34ch
         /Nyiyn79famGNM5+LUadTV/PWF/YZaXcIJToTe4YRaDYPNDQ+EPnpAFr1wu2/v+856Ax
         OZaqX0JwiFJ30+yKsOPegGyN9jSMd2KvinFSg7/8JofVI6MTuy27n+lmAf54OGq61r4s
         zrUerVexCoBWCKMyIQDIEBcHPQ8p673m+2KqC9FYnW6TcFkQj2Fj67kXkhxd73mBLXvj
         iTgR1S4VRL4tntIt/ZjAz/ehIoTSg4rDL5HhuLU/7OSNFI6ukiJYkPnfyYfqKwpe9XfF
         o4hw==
X-Gm-Message-State: AOAM532Q3iq/ByAyJ5IN8scHscKJW1VSancgpy/m06fe0JMyssIEM1mV
        kS3c3U4k0ygO6UJzTeUMY8iFhoP5K4/HJ9UEpqKbZw==
X-Google-Smtp-Source: ABdhPJy6uKMGreNLvF0Ki8YaGC8NZzCCp3R6j9fbKII+5cbhRx2RkmK8Ng+IHjA2Ta3Qj2A+jSG6gNmoplJ+Wp8abWQ=
X-Received: by 2002:ab0:6f4b:: with SMTP id r11mr15007620uat.104.1628508660724;
 Mon, 09 Aug 2021 04:31:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210809064028.1198327-1-hch@lst.de> <20210809064028.1198327-3-hch@lst.de>
In-Reply-To: <20210809064028.1198327-3-hch@lst.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 9 Aug 2021 13:30:24 +0200
Message-ID: <CAPDyKFoSKwamqRdQNkgwKTixSwXPEf9dB4jSiOh73DqXOZ1yGg@mail.gmail.com>
Subject: Re: [PATCH 2/8] mmc: block: cleanup gendisk creation
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

On Mon, 9 Aug 2021 at 08:44, Christoph Hellwig <hch@lst.de> wrote:
>
> Restructure mmc_blk_probe to avoid a failure path with a half created
> disk.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Let's try to funnel this via Jens' tree. As long as his tree is based
upon v5.14-rc3 or later I don't think we should have any problem with
conflicts.

Kind regards
Uffe


> ---
>  drivers/mmc/core/block.c | 49 ++++++++++++++--------------------------
>  1 file changed, 17 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index 4ac3e1b93e7e..4c11f171e56d 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -2328,7 +2328,8 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
>                                               sector_t size,
>                                               bool default_ro,
>                                               const char *subname,
> -                                             int area_type)
> +                                             int area_type,
> +                                             unsigned int part_type)
>  {
>         struct mmc_blk_data *md;
>         int devidx, ret;
> @@ -2375,6 +2376,7 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
>         kref_init(&md->kref);
>
>         md->queue.blkdata = md;
> +       md->part_type = part_type;
>
>         md->disk->major = MMC_BLOCK_MAJOR;
>         md->disk->minors = perdev_minors;
> @@ -2427,6 +2429,10 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
>                 md->disk->disk_name, mmc_card_id(card), mmc_card_name(card),
>                 cap_str, md->read_only ? "(ro)" : "");
>
> +       /* used in ->open, must be set before add_disk: */
> +       if (area_type == MMC_BLK_DATA_AREA_MAIN)
> +               dev_set_drvdata(&card->dev, md);
> +       device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
>         return md;
>
>   err_kfree:
> @@ -2456,7 +2462,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
>         }
>
>         return mmc_blk_alloc_req(card, &card->dev, size, false, NULL,
> -                                       MMC_BLK_DATA_AREA_MAIN);
> +                                       MMC_BLK_DATA_AREA_MAIN, 0);
>  }
>
>  static int mmc_blk_alloc_part(struct mmc_card *card,
> @@ -2470,10 +2476,9 @@ static int mmc_blk_alloc_part(struct mmc_card *card,
>         struct mmc_blk_data *part_md;
>
>         part_md = mmc_blk_alloc_req(card, disk_to_dev(md->disk), size, default_ro,
> -                                   subname, area_type);
> +                                   subname, area_type, part_type);
>         if (IS_ERR(part_md))
>                 return PTR_ERR(part_md);
> -       part_md->part_type = part_type;
>         list_add(&part_md->part, &md->part);
>
>         return 0;
> @@ -2674,20 +2679,13 @@ static int mmc_blk_alloc_parts(struct mmc_card *card, struct mmc_blk_data *md)
>
>  static void mmc_blk_remove_req(struct mmc_blk_data *md)
>  {
> -       struct mmc_card *card;
> -
> -       if (md) {
> -               /*
> -                * Flush remaining requests and free queues. It
> -                * is freeing the queue that stops new requests
> -                * from being accepted.
> -                */
> -               card = md->queue.card;
> -               if (md->disk->flags & GENHD_FL_UP)
> -                       del_gendisk(md->disk);
> -               mmc_cleanup_queue(&md->queue);
> -               mmc_blk_put(md);
> -       }
> +       /*
> +        * Flush remaining requests and free queues. It is freeing the queue
> +        * that stops new requests from being accepted.
> +        */
> +       del_gendisk(md->disk);
> +       mmc_cleanup_queue(&md->queue);
> +       mmc_blk_put(md);
>  }
>
>  static void mmc_blk_remove_parts(struct mmc_card *card,
> @@ -2876,7 +2874,7 @@ static void mmc_blk_remove_debugfs(struct mmc_card *card,
>
>  static int mmc_blk_probe(struct mmc_card *card)
>  {
> -       struct mmc_blk_data *md, *part_md;
> +       struct mmc_blk_data *md;
>         int ret = 0;
>
>         /*
> @@ -2904,19 +2902,6 @@ static int mmc_blk_probe(struct mmc_card *card)
>         if (ret)
>                 goto out;
>
> -       dev_set_drvdata(&card->dev, md);
> -
> -       device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> -       if (ret)
> -               goto out;
> -
> -       list_for_each_entry(part_md, &md->part, part) {
> -               device_add_disk(part_md->parent, part_md->disk,
> -                               mmc_disk_attr_groups);
> -               if (ret)
> -                       goto out;
> -       }
> -
>         /* Add two debugfs entries */
>         mmc_blk_add_debugfs(card, md);
>
> --
> 2.30.2
>
