Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A3A307B22
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jan 2021 17:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhA1Qif (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 11:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhA1QiC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 11:38:02 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C6EC061573
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 08:37:21 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id t17so4517356qtq.2
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 08:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b2ZGTawGlK5Yw0zmcmeflkgkMr7OU/doRCMg6hs3zIs=;
        b=AlqWlbxALRseBPb8SrPdFPeqoSEITz6IIzt2sIwsDNc9wrWOhLU+ZtWX5U+0DktJXm
         cOcIwkh8Od5CnEKMlhraHUzZo5WRjjWc+yXyM2FpX02jYvav37IV/qD2L1n5xb546NDM
         QNl+lfmr5wWzI/QGOI/ScAjlDo6INyrnToAGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b2ZGTawGlK5Yw0zmcmeflkgkMr7OU/doRCMg6hs3zIs=;
        b=nP4HwrrdT8Zt0PjVvOcOyP4bISdtaqW2LJQHRbknGwXTPS25Rle/FSCwwdW6AxTyKo
         /ySVhDsvszcZk+ACE+/5lZY2Q2J+c5CKEQAXYfzlR4Vhk+I5YEz3r637kBHc0XWGH1Dw
         eqaQvB+9bSty/vnbxQOv08z5jgSYTsp1n/q3PNJumzkZdhuTUVUIT1hmn+wLUNiw/pO1
         xOrFgopFw1ave78F3v/GmanMW1tIjpDDoHfswRHcKdhZrk7wtq0b/VmAduEMYqDL4L+3
         7/Foh19h9WRe0rbLO5oOVHX2N24d4MaBMYtJXLO5qUjq4NhhkG5g11+7jg8UyqtRbG3n
         P25A==
X-Gm-Message-State: AOAM5321tbn6/BefhvKwfgwQsbqPSKeE12pBsuvYYzHvBQJZP5xJflVo
        cbE4GrNqaB2YOxMVpmgty2UkJ6qsIiih4wBdFngbXOKIK6ssDw==
X-Google-Smtp-Source: ABdhPJySvt4uTg3fJy8wNPhSi3LXqwj4rJCBS2Ywb1kn4wf2e/HSClFUkOYcqWdJ9qR8ng15GlfZls6gjKlK50CebfU=
X-Received: by 2002:ac8:6d16:: with SMTP id o22mr273432qtt.383.1611851840991;
 Thu, 28 Jan 2021 08:37:20 -0800 (PST)
MIME-Version: 1.0
References: <20210127132350.557935-1-kai@kaishome.de> <20210128105034.176668-1-kai@kaishome.de>
 <20210128105034.176668-2-kai@kaishome.de>
In-Reply-To: <20210128105034.176668-2-kai@kaishome.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Thu, 28 Jan 2021 17:37:09 +0100
Message-ID: <CAC2ZOYtvMEQDhwdcRJnUwTWyGkmD0vue6V7+B2-3Q5-SoZsyGw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] bcache: Move journal work to new background wq
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly!

With v2, I added WQ_MEM_RECLAIM to the background wq. But with it, I
consistently get 50% worse boot times (20 -> 30s), when set the value
to 0 again, boot times are better again. The desktop also reacts to
clicks earlier right after boot.

Is there memory reclaim pressure during boot?

As far as I understand the code, this would trigger an immediate
journal flush then under memory reclaim because this background wq is
only used to reschedule journal flush some time in the future (100ms?)
if there's nothing to write just now:

>         } else if (!w->dirty) {
>                 w->dirty = true;
> -               schedule_delayed_work(&c->journal.work,
> -                                     msecs_to_jiffies(c->journal_delay_ms));
> +               queue_delayed_work(bch_background_wq, &c->journal.work,
> +                                  msecs_to_jiffies(c->journal_delay_ms));
>                 spin_unlock(&c->journal.lock);
>         } else {

Do you have an explanation? Will it be safe to return to the previous
init using no WQ_MEM_RECLAIM for background wq? Like this:

-       bch_background_wq = alloc_workqueue("bch_background",
WQ_MEM_RECLAIM, 0);
+       bch_background_wq = alloc_workqueue("bch_background", 0, 0);

Maybe we should find a better name for this - not bch_background?

Thanks,
Kai

Am Do., 28. Jan. 2021 um 11:50 Uhr schrieb Kai Krakow <kai@kaishome.de>:
>
> This is potentially long running and not latency sensitive, let's get
> it out of the way of other latency sensitive events.
>
> As observed in the previous commit, the system_wq comes easily
> congested by bcache, and this fixes a few more stalls I was observing
> every once in a while.
>
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Kai Krakow <kai@kaishome.de>
> ---
>  drivers/md/bcache/bcache.h  | 1 +
>  drivers/md/bcache/journal.c | 4 ++--
>  drivers/md/bcache/super.c   | 7 +++++++
>  3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index b1ed16c7a5341..70565ed5732d7 100644
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
> index aefbdb7e003bc..942e97dd17554 100644
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
> index dc4fe7eeda815..5206c037c13f3 100644
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
> +       bch_background_wq = alloc_workqueue("bch_background", WQ_MEM_RECLAIM, 0);
> +       if (!bch_background_wq)
> +               goto err;
> +
>         bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
>         if (!bch_journal_wq)
>                 goto err;
> --
> 2.26.2
>
