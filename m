Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9282C308AE1
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Jan 2021 18:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhA2RDG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Jan 2021 12:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhA2RBj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Jan 2021 12:01:39 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422CBC0613ED
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:59:15 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id k193so9346477qke.6
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oktbdsfMxCoAFwk1z6YwGI/XRwTZIHH96RTtoH8mj+w=;
        b=TWJ9RJ/HPzue98BS0DVuOIz64pozSUgqbtENurT8hE399Ef51NAqtV2kNWIwdXF8Mb
         +1QyDgy4GzGtyh1XrkXtFTkEH6N3vKuKAmFwYG2Ut8zEANspqua0xkaXE3bMjFyimff3
         kN7102KG1009y8MxbN61cGYUirPmKTroReajs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oktbdsfMxCoAFwk1z6YwGI/XRwTZIHH96RTtoH8mj+w=;
        b=RW3JB52mmFI5blAULlmMpmHak9hUSsBwk0v099MxURVNqHyKlaLsNIkhGsofwhjsbn
         e6sT50Yc1mscHSyyZe8PgWzIpYFJWcSusfBYl0pgqWNrr85ms3lQntHND8M09M35oRnY
         vAZQeV7PMNuZXYnGuzUjUTGMGNGKtqvuTPMFWTD4XoiKY+UJxORCQpPgSwA143jL3E3c
         Vb4+x+MJBKdj3MAeuth4zPqYsG4z1gXDCIqWnf4WAsPNJz+hOKehW5lVwKPGwT88xvqq
         Pa/56syY+zT7PiU5Hr0FkRUhWXoLsMPcyPBSQCdBtBMUgHGLS8w7TRxPHBe3I8jKlmKk
         PQ1g==
X-Gm-Message-State: AOAM531y1bNefk9C8KlOP8tuc77EjW3bw3EjdshMtMiWWKH+mzEyrjDm
        1ySPnX76Zf1tcF4W9zCaXIqgBqWXj3PQbNE8F7wzvw==
X-Google-Smtp-Source: ABdhPJwVVbHO5MhP+oznroR8KMVeO2ZlSYiXYOeNZZX2WnQ6QPn/K++yJ5etVZd2dOhxa3i3OCZrup9FUWxWFJLWe3I=
X-Received: by 2002:a37:8dc1:: with SMTP id p184mr4788017qkd.70.1611939554466;
 Fri, 29 Jan 2021 08:59:14 -0800 (PST)
MIME-Version: 1.0
References: <20210127132350.557935-1-kai@kaishome.de> <20210128232825.18719-1-kai@kaishome.de>
 <4fe07714-e5bf-4be3-6023-74b507ee54be@suse.de>
In-Reply-To: <4fe07714-e5bf-4be3-6023-74b507ee54be@suse.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Fri, 29 Jan 2021 17:59:02 +0100
Message-ID: <CAC2ZOYu=Opf2O=5r+uFk8XO+qP0-KGPyndGCc2mAaHSVJO0-0A@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] Revert "bcache: Kill btree_io_wq"
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Fr., 29. Jan. 2021 um 16:30 Uhr schrieb Coly Li <colyli@suse.de>:
>
> On 1/29/21 7:28 AM, Kai Krakow wrote:
> > This reverts commit 56b30770b27d54d68ad51eccc6d888282b568cee.
> >
> > With the btree using the `system_wq`, I seem to see a lot more desktop
> > latency than I should.
> >
> > After some more investigation, it looks like the original assumption
> > of 56b3077 no longer is true, and bcache has a very high potential of
> > congesting the `system_wq`. In turn, this introduces laggy desktop
> > performance, IO stalls (at least with btrfs), and input events may be
> > delayed.
> >
> > So let's revert this. It's important to note that the semantics of
> > using `system_wq` previously mean that `btree_io_wq` should be created
> > before and destroyed after other bcache wqs to keep the same
> > assumptions.
> >
> > Cc: Coly Li <colyli@suse.de>
> > Signed-off-by: Kai Krakow <kai@kaishome.de>
>
> The patch is OK to me in general. I just feel it might be unnecessary to
> use ordered work queue. The out-of-order system_wq is used for many
> years and works well with bcache journal.

This is why in v3 and later, I migrated this to an unordered queue. I
just wanted to keep the revert as-is, and then the follow-up patch
will fix this. Is that okay or should I squash both commits?

Thanks,
Kai

> > ---
> >  drivers/md/bcache/bcache.h |  2 ++
> >  drivers/md/bcache/btree.c  | 21 +++++++++++++++++++--
> >  drivers/md/bcache/super.c  |  4 ++++
> >  3 files changed, 25 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> > index 1d57f48307e66..b1ed16c7a5341 100644
> > --- a/drivers/md/bcache/bcache.h
> > +++ b/drivers/md/bcache/bcache.h
> > @@ -1042,5 +1042,7 @@ void bch_debug_exit(void);
> >  void bch_debug_init(void);
> >  void bch_request_exit(void);
> >  int bch_request_init(void);
> > +void bch_btree_exit(void);
> > +int bch_btree_init(void);
> >
> >  #endif /* _BCACHE_H */
> > diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > index 910df242c83df..952f022db5a5f 100644
> > --- a/drivers/md/bcache/btree.c
> > +++ b/drivers/md/bcache/btree.c
> > @@ -99,6 +99,8 @@
> >  #define PTR_HASH(c, k)                                                       \
> >       (((k)->ptr[0] >> c->bucket_bits) | PTR_GEN(k, 0))
> >
> > +static struct workqueue_struct *btree_io_wq;
> > +
> >  #define insert_lock(s, b)    ((b)->level <= (s)->lock)
> >
> >
> > @@ -308,7 +310,7 @@ static void __btree_node_write_done(struct closure *cl)
> >       btree_complete_write(b, w);
> >
> >       if (btree_node_dirty(b))
> > -             schedule_delayed_work(&b->work, 30 * HZ);
> > +             queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
> >
> >       closure_return_with_destructor(cl, btree_node_write_unlock);
> >  }
> > @@ -481,7 +483,7 @@ static void bch_btree_leaf_dirty(struct btree *b, atomic_t *journal_ref)
> >       BUG_ON(!i->keys);
> >
> >       if (!btree_node_dirty(b))
> > -             schedule_delayed_work(&b->work, 30 * HZ);
> > +             queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
> >
> >       set_btree_node_dirty(b);
> >
> > @@ -2764,3 +2766,18 @@ void bch_keybuf_init(struct keybuf *buf)
> >       spin_lock_init(&buf->lock);
> >       array_allocator_init(&buf->freelist);
> >  }
> > +
> > +void bch_btree_exit(void)
> > +{
> > +     if (btree_io_wq)
> > +             destroy_workqueue(btree_io_wq);
> > +}
> > +
> > +int __init bch_btree_init(void)
> > +{
> > +     btree_io_wq = create_singlethread_workqueue("bch_btree_io");
> > +     if (!btree_io_wq)
> > +             return -ENOMEM;
> > +
> > +     return 0;
> > +}
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 2047a9cccdb5d..77c5d8b6d4316 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -2821,6 +2821,7 @@ static void bcache_exit(void)
> >               destroy_workqueue(bcache_wq);
> >       if (bch_journal_wq)
> >               destroy_workqueue(bch_journal_wq);
> > +     bch_btree_exit();
> >
> >       if (bcache_major)
> >               unregister_blkdev(bcache_major, "bcache");
> > @@ -2876,6 +2877,9 @@ static int __init bcache_init(void)
> >               return bcache_major;
> >       }
> >
> > +     if (bch_btree_init())
> > +             goto err;
> > +
> >       bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0);
> >       if (!bcache_wq)
> >               goto err;
> >
>
