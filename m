Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22685308A70
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Jan 2021 17:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhA2Qir (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Jan 2021 11:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbhA2Qid (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Jan 2021 11:38:33 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1F9C061573
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:37:51 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id j13so4698527qvu.10
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eAJ+G00y1VXMGnbLxyOTEUmlv2RmSiWuFo4JzPpAKiA=;
        b=mLkwROCez1xg3O3EArPdjpykIij61lt5Za2SFIXjq2OIupqxaCcv9PeGs2M5Z4n6+S
         cKzWC0F+kmHbH2KoaAp+b6QrWXtiQAwNK2s98+3XfJSd2u5phM6qnQnMy3aR8o6A8tuE
         qbUbtq5tCGx/KGPihbiY0P7MO/TTx/iamw3t4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eAJ+G00y1VXMGnbLxyOTEUmlv2RmSiWuFo4JzPpAKiA=;
        b=UciNjuMHJUkP953lhHJeOuzXjxJsIERKTWebCK1l1/noxVDdHF1241mNt+k5B+yQ+3
         xuDlvZjAEWmHVkScuvJ5Bs8hkNaA7T4cNI8cggN/yqyTjcKsw2uwDeF3cQztesiqUHpe
         e7CMIFu0HVMpeKwsfim/L4cENXqZ445jGsnN1S+FeKO1Y2CBbYS8BNM8gyK+uRgggTCd
         BwyTFV1NxHM9Q7IUvR7bJpa0O46N4/sDv6o+LKgOTkik6/xC7WxlbnkTrPHPuwQ1c2u4
         JRcg6+xoWYkQUwn+Mvdq4k+CE1WfLdy/MngYth1xZwB5SQeLvCrct/gxC4n03YlBx1Rg
         +ytQ==
X-Gm-Message-State: AOAM53229ET7ycH10bdNh4y/RdDe4PwLW3Csz8l0OJGyziOBILuzT8mH
        tQNKCL4R2aMhnb2JlGxKRw2tMI62S5bgnet4jhTDOA==
X-Google-Smtp-Source: ABdhPJykO1ErTg0ovYYZbE2D4f15wV/to8ph6vRnZ2wniuaWD+YxrAv35Jk2zs42vI2lI7gobrGqVYSUXXff58i5oW8=
X-Received: by 2002:a05:6214:14f4:: with SMTP id k20mr4503572qvw.27.1611938271038;
 Fri, 29 Jan 2021 08:37:51 -0800 (PST)
MIME-Version: 1.0
References: <20210127132350.557935-1-kai@kaishome.de> <20210128232825.18719-1-kai@kaishome.de>
 <20210128232825.18719-3-kai@kaishome.de> <a52b9107-7e84-0fea-6095-84a9576d7cc4@suse.de>
In-Reply-To: <a52b9107-7e84-0fea-6095-84a9576d7cc4@suse.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Fri, 29 Jan 2021 17:37:39 +0100
Message-ID: <CAC2ZOYt3pZ4c-qd-9J3nbp4z_Jrw=Kv=9GxdaDOmi7Hu1w2q0w@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] bcache: Move journal work to new background wq
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Fr., 29. Jan. 2021 um 17:06 Uhr schrieb Coly Li <colyli@suse.de>:
>
> On 1/29/21 7:28 AM, Kai Krakow wrote:
> > This is potentially long running and not latency sensitive, let's get
> > it out of the way of other latency sensitive events.
> >
> > As observed in the previous commit, the `system_wq` comes easily
> > congested by bcache, and this fixes a few more stalls I was observing
> > every once in a while.
> >
> > Let's not make this `WQ_MEM_RECLAIM` as it showed to reduce performance
> > of boot and file system operations in my tests. Also, without
> > `WQ_MEM_RECLAIM`, I no longer see desktop stalls. This matches the
> > previous behavior as `system_wq` also does no memory reclaim:
> >
> >> // workqueue.c:
> >> system_wq = alloc_workqueue("events", 0, 0);
> >
>
> Your text is convinced. I am OK with this patch. One more request, could
> you please add a comment at alloc_workqueue() to explain why setting
> flags as 0 and no WQ_MEM_RECLAIM. It should be helpful to others who
> don't read our discussion.

I'll post a v4.

> > Cc: Coly Li <colyli@suse.de>
> > Signed-off-by: Kai Krakow <kai@kaishome.de>
> > ---
> >  drivers/md/bcache/bcache.h  | 1 +
> >  drivers/md/bcache/journal.c | 4 ++--
> >  drivers/md/bcache/super.c   | 7 +++++++
> >  3 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> > index b1ed16c7a5341..e8bf4f752e8be 100644
> > --- a/drivers/md/bcache/bcache.h
> > +++ b/drivers/md/bcache/bcache.h
> > @@ -1001,6 +1001,7 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
> >
> >  extern struct workqueue_struct *bcache_wq;
> >  extern struct workqueue_struct *bch_journal_wq;
> > +extern struct workqueue_struct *bch_flush_wq;
> >  extern struct mutex bch_register_lock;
> >  extern struct list_head bch_cache_sets;
> >
> > diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> > index aefbdb7e003bc..c6613e8173337 100644
> > --- a/drivers/md/bcache/journal.c
> > +++ b/drivers/md/bcache/journal.c
> > @@ -932,8 +932,8 @@ atomic_t *bch_journal(struct cache_set *c,
> >               journal_try_write(c);
> >       } else if (!w->dirty) {
> >               w->dirty = true;
> > -             schedule_delayed_work(&c->journal.work,
> > -                                   msecs_to_jiffies(c->journal_delay_ms));
> > +             queue_delayed_work(bch_flush_wq, &c->journal.work,
> > +                                msecs_to_jiffies(c->journal_delay_ms));
> >               spin_unlock(&c->journal.lock);
> >       } else {
> >               spin_unlock(&c->journal.lock);
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 77c5d8b6d4316..817b36c39b4fc 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -49,6 +49,7 @@ static int bcache_major;
> >  static DEFINE_IDA(bcache_device_idx);
> >  static wait_queue_head_t unregister_wait;
> >  struct workqueue_struct *bcache_wq;
> > +struct workqueue_struct *bch_flush_wq;
> >  struct workqueue_struct *bch_journal_wq;
> >
> >
> > @@ -2821,6 +2822,8 @@ static void bcache_exit(void)
> >               destroy_workqueue(bcache_wq);
> >       if (bch_journal_wq)
> >               destroy_workqueue(bch_journal_wq);
> > +     if (bch_flush_wq)
> > +             destroy_workqueue(bch_flush_wq);
> >       bch_btree_exit();
> >
> >       if (bcache_major)
> > @@ -2884,6 +2887,10 @@ static int __init bcache_init(void)
> >       if (!bcache_wq)
> >               goto err;
> >
> > +     bch_flush_wq = alloc_workqueue("bch_flush", 0, 0);
> > +     if (!bch_flush_wq)
> > +             goto err;
> > +
> >       bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
> >       if (!bch_journal_wq)
> >               goto err;
> >
>
