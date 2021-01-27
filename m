Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5A8306109
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Jan 2021 17:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343991AbhA0Q3d (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Jan 2021 11:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343820AbhA0Q3N (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Jan 2021 11:29:13 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B43EC061573
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 08:28:32 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id r77so2238952qka.12
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 08:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Gy7X5g4BiwbMmUibDrMrdFVKh9o+L48DJA1luCPOPjQ=;
        b=OypjpAWOIuqktYTMXnYASxW5K/LSIBUzHDaNOsTxvF0fwoXZES+oQ0pTEkPXRbGM89
         S10iTjbaDDjqjvlRYd/QgcktaOjKV2xWP3vKZuq4EmZf99StVezxHlb1cA+UzFPmlCf1
         NCqFbWhhm0ESU3O9Omgshw5kOGKAEsBVQuNHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Gy7X5g4BiwbMmUibDrMrdFVKh9o+L48DJA1luCPOPjQ=;
        b=d4fp4HD4G6f5w6vBQ9l+KV/u8tYQu06/FFQvC6JPWeASEkM5UtAsCDbQK33qsz1xSh
         X7VzQ/CY72MorFytJqEhJJ26yTYk5wjiBfwHxeSVN0476D19L3riJyBY51YEKJ/x8Yu6
         TmnBgAphOUpi40pbhds3oBqU9cqFBAisypHqOAS6C+QfwCo2CkP+pWP8jPfUwcKBeu/B
         a4f3v1I5oztyjl6Qh6WD5anuoP03NNcs4hCzA14kaAnFSmbTxRKgTm7yah6OrvZOmsI1
         prSGq/m1jX/T3pboKrFc0y6HrZj2X2f3S9540Bn1rIhckNN2kTfAj2GpG94WvScCH1Nx
         Y/yQ==
X-Gm-Message-State: AOAM532ovf0naIxxcm81f6m2shNsd8gdvZ21vwv/LH7Wanf25Zq9uw3W
        AOvSdX7IPGMLHJ7Iey++DBFvn6Cpn8cI54cBb8eQxVxn5BA=
X-Google-Smtp-Source: ABdhPJx+j6eLnKXe3EA4DzEp8M25Y11gN3QkJb+/fB8PKW+YqhcXblDf2LQrpUlXo2ICsCHe167UcB/Lu6N4CfLJBxY=
X-Received: by 2002:a37:9505:: with SMTP id x5mr11076654qkd.295.1611764911477;
 Wed, 27 Jan 2021 08:28:31 -0800 (PST)
MIME-Version: 1.0
References: <20210127132350.557935-1-kai@kaishome.de> <20210127132350.557935-3-kai@kaishome.de>
In-Reply-To: <20210127132350.557935-3-kai@kaishome.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Wed, 27 Jan 2021 17:28:20 +0100
Message-ID: <CAC2ZOYvfaATryTrub01cjYBFPzYvqFZkdGzktoX__oS2-qOtUg@mail.gmail.com>
Subject: Re: [PATCH 2/2] bcache: Move journal work to new background wq
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Please ignore this patch with missing IRP, will re-post to the intro mail.

Am Mi., 27. Jan. 2021 um 14:24 Uhr schrieb Kai Krakow <kai@kaishome.de>:
>
> This is potentially long running and not latency sensitive, let's get
> it out of the way of other latency sensitive events.
> ---
>  drivers/md/bcache/bcache.h  | 1 +
>  drivers/md/bcache/journal.c | 4 ++--
>  drivers/md/bcache/super.c   | 7 +++++++
>  3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index b1ed16c7a534..70565ed5732d 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -1001,6 +1001,7 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
>
>  extern struct workqueue_struct *bcache_wq;
>  extern struct workqueue_struct *bch_journal_wq;
> +extern struct workqueue_struct *bch_background_wq;
>  extern struct mutex bch_register_lock;
>  extern struct list_head bch_cache_sets;
>
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index aefbdb7e003b..942e97dd1755 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -932,8 +932,8 @@ atomic_t *bch_journal(struct cache_set *c,
>                 journal_try_write(c);
>         } else if (!w->dirty) {
>                 w->dirty = true;
> -               schedule_delayed_work(&c->journal.work,
> -                                     msecs_to_jiffies(c->journal_delay_ms));
> +               queue_delayed_work(bch_background_wq, &c->journal.work,
> +                                  msecs_to_jiffies(c->journal_delay_ms));
>                 spin_unlock(&c->journal.lock);
>         } else {
>                 spin_unlock(&c->journal.lock);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index dc4fe7eeda81..9e1481917ce6 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -49,6 +49,7 @@ static int bcache_major;
>  static DEFINE_IDA(bcache_device_idx);
>  static wait_queue_head_t unregister_wait;
>  struct workqueue_struct *bcache_wq;
> +struct workqueue_struct *bch_background_wq;
>  struct workqueue_struct *bch_journal_wq;
>
>
> @@ -2822,6 +2823,8 @@ static void bcache_exit(void)
>                 destroy_workqueue(bcache_wq);
>         if (bch_journal_wq)
>                 destroy_workqueue(bch_journal_wq);
> +       if (bch_background_wq)
> +               destroy_workqueue(bch_background_wq);
>
>         if (bcache_major)
>                 unregister_blkdev(bcache_major, "bcache");
> @@ -2884,6 +2887,10 @@ static int __init bcache_init(void)
>         if (bch_btree_init())
>                 goto err;
>
> +       bch_background_wq = alloc_workqueue("bch_background", 0, 0);
> +       if (!bch_background_wq)
> +               goto err;
> +
>         bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
>         if (!bch_journal_wq)
>                 goto err;
> --
> 2.26.2
>
