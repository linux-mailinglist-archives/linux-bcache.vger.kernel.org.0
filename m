Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A2E30610B
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Jan 2021 17:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343973AbhA0Q3g (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Jan 2021 11:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343951AbhA0Q3e (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Jan 2021 11:29:34 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972BEC061574
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 08:28:53 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id c12so1804925qtv.5
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 08:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=8hXVViVFBk/Rx95uneNdlgeuiu/LyaA5TMU59ef7w00=;
        b=QLuBphdoveDZ4SBThZ0AnrB9YTkz8M5RfEjWtPZgBiqH0/xfLAtRxdFNaq6F7LJCPG
         QmGMZaQaN/5x2HVld6t6C4fovkQyljsmAMv9jqDoZilE33bkXh9se5T6mSTxXQ8wZcYT
         LGuxSgtml4Z3AWvoRzAHWnpiTNc2RaXD656/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=8hXVViVFBk/Rx95uneNdlgeuiu/LyaA5TMU59ef7w00=;
        b=R3en+eip/4Q34GF/BWE9alU2bkemr0RRwpW5HNsKy4uV2T9HnHLdL0kVOuuckTaz5m
         JoTxr+MrnyhXM+QJm38XPlXnexWnwdmJ3CP2+xlYqY9v2pkDIY4+E+jNUcIrsq3RX7uK
         vEJm9Kchgks8zEDmwAHKD399BLszMvRP1r1GHH5qsf24GvxWrhBMS5YJCHKidDJkjpPy
         ERybEOic0AuHNOY11XI85qRuhh0sroBihhL6kAL6ZbUFg7pzjbPeP8Ls+blIWYLbh1FN
         DBQ2jCWYKIeyqvzpJoidqQLkDVoEDEQIphhTouuehoDufK1pshXHPxwe9uJe8Jq9lgDJ
         uy1Q==
X-Gm-Message-State: AOAM533b5owJLPXIyXPCmKFmZq8msL5pK++tI2+iDbhCQ9C7MCKf81f5
        nUmpyb0Axs6rAYyG86aUv1Ny2DH6K2nsP9C5xIu148hiN9i6CA==
X-Google-Smtp-Source: ABdhPJzhXv3y+mvhdziwtxgiZ/gV1gDzjM3KoxfqHriHQv603gev4IiM/GG11KriYt24oyJW0D3Up7jFsQzmx/Vr5ek=
X-Received: by 2002:ac8:4d93:: with SMTP id a19mr10227472qtw.356.1611764931817;
 Wed, 27 Jan 2021 08:28:51 -0800 (PST)
MIME-Version: 1.0
References: <20210127132350.557935-1-kai@kaishome.de> <20210127132350.557935-2-kai@kaishome.de>
In-Reply-To: <20210127132350.557935-2-kai@kaishome.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Wed, 27 Jan 2021 17:28:41 +0100
Message-ID: <CAC2ZOYvb+KKx+2QestxQv8ux+cxgQ_V7h9rFrkUEz9bT5x4wxA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Revert "bcache: Kill btree_io_wq"
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Please ignore this patch with missing IRP, will re-post to the intro mail.

Am Mi., 27. Jan. 2021 um 14:24 Uhr schrieb Kai Krakow <kai@kaishome.de>:
>
> This reverts commit 56b30770b27d54d68ad51eccc6d888282b568cee.
>
> With the btree using the system_wq, I seem to see a lot more desktop
> latency than I should. So let's revert this.
> ---
>  drivers/md/bcache/bcache.h |  2 ++
>  drivers/md/bcache/btree.c  | 21 +++++++++++++++++++--
>  drivers/md/bcache/super.c  |  4 ++++
>  3 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 1d57f48307e6..b1ed16c7a534 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -1042,5 +1042,7 @@ void bch_debug_exit(void);
>  void bch_debug_init(void);
>  void bch_request_exit(void);
>  int bch_request_init(void);
> +void bch_btree_exit(void);
> +int bch_btree_init(void);
>
>  #endif /* _BCACHE_H */
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 910df242c83d..952f022db5a5 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -99,6 +99,8 @@
>  #define PTR_HASH(c, k)                                                 \
>         (((k)->ptr[0] >> c->bucket_bits) | PTR_GEN(k, 0))
>
> +static struct workqueue_struct *btree_io_wq;
> +
>  #define insert_lock(s, b)      ((b)->level <= (s)->lock)
>
>
> @@ -308,7 +310,7 @@ static void __btree_node_write_done(struct closure *cl)
>         btree_complete_write(b, w);
>
>         if (btree_node_dirty(b))
> -               schedule_delayed_work(&b->work, 30 * HZ);
> +               queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
>
>         closure_return_with_destructor(cl, btree_node_write_unlock);
>  }
> @@ -481,7 +483,7 @@ static void bch_btree_leaf_dirty(struct btree *b, atomic_t *journal_ref)
>         BUG_ON(!i->keys);
>
>         if (!btree_node_dirty(b))
> -               schedule_delayed_work(&b->work, 30 * HZ);
> +               queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
>
>         set_btree_node_dirty(b);
>
> @@ -2764,3 +2766,18 @@ void bch_keybuf_init(struct keybuf *buf)
>         spin_lock_init(&buf->lock);
>         array_allocator_init(&buf->freelist);
>  }
> +
> +void bch_btree_exit(void)
> +{
> +       if (btree_io_wq)
> +               destroy_workqueue(btree_io_wq);
> +}
> +
> +int __init bch_btree_init(void)
> +{
> +       btree_io_wq = create_singlethread_workqueue("bch_btree_io");
> +       if (!btree_io_wq)
> +               return -ENOMEM;
> +
> +       return 0;
> +}
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 2047a9cccdb5..dc4fe7eeda81 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2815,6 +2815,7 @@ static void bcache_exit(void)
>  {
>         bch_debug_exit();
>         bch_request_exit();
> +       bch_btree_exit();
>         if (bcache_kobj)
>                 kobject_put(bcache_kobj);
>         if (bcache_wq)
> @@ -2880,6 +2881,9 @@ static int __init bcache_init(void)
>         if (!bcache_wq)
>                 goto err;
>
> +       if (bch_btree_init())
> +               goto err;
> +
>         bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
>         if (!bch_journal_wq)
>                 goto err;
> --
> 2.26.2
>
