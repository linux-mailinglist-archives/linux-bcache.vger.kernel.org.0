Return-Path: <linux-bcache+bounces-1259-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3149CC6D5B8
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Nov 2025 09:16:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 6E1D52D45D
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Nov 2025 08:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BE32ED844;
	Wed, 19 Nov 2025 08:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QAKFkFy8"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34771C84DE
	for <linux-bcache@vger.kernel.org>; Wed, 19 Nov 2025 08:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763539978; cv=none; b=fAHLlGWWmZbZVJegwoMNcBowEvdOmi1vXaZGiaNOzfhLcUCc79ao4L012LQtXjJkwghEYZR+ZQfFx86HgYdrKULWLPdkb/poo6t0t3NX+Li3pR7qOg9+KzYUR9e0oABgqNdLz+4Yd8F3B0DvBtuZzvMOstfL8VTd+BJqK/GaoSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763539978; c=relaxed/simple;
	bh=DnuOXgxfU6qtybWZtlQwa3TZWZgnfr3HBeC6+Wa6oA0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dXF8rejONooC9reziYhuas+ZYmNgAwpE8YQ7MCk7uwaMe4Xjd5mkp5GB4ERYhiBU6BXTvi3+nmxcAfDPSddOPrEmSl/pdF1JohdXl9AiIwO1ssuB+KI0x+oQYOkGhLWVc6fWkOW5ztMDX/8uY/LBCi5U8uAHL+oI/mppeiXHr8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QAKFkFy8; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-88245cc8c92so41273036d6.0
        for <linux-bcache@vger.kernel.org>; Wed, 19 Nov 2025 00:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763539975; x=1764144775; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/tU5N9FC1VC2jhsjwqPUnanjm4jcyQCilLFFNyoSH3g=;
        b=QAKFkFy8cSKK11VANVCoC8FF/sLaGUVjMDEiEquoZnYsCBTGnvRDzFmV7DCDrHDgUm
         d7vRoX44qiVFOmflB5NucCZEXxzse2XEgCU2KlR1Gv/Jsb6in0S75LFtVQavHlT0x+QF
         7XAKY8sn5l2LTnxRCxTqRjAztKTrNsg143v0kXK25RRlopDHRuxNPvy3xDS/JXWd9Tol
         zR5Fnj9jgujLtK8U0pWf5bg0Bkbfr3y8/SwnldIoD19zDoQQrgDFyHbU6wom5Du+TF88
         hsAYjTjo+K+nG6rWxNl1u+KxmnmMJK9k2sSxRr/iwCyGA9FICimu8QOQV6Rm9bhN0Fic
         VF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763539975; x=1764144775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/tU5N9FC1VC2jhsjwqPUnanjm4jcyQCilLFFNyoSH3g=;
        b=Y+7L5SpVUp4DmhibjFfINhS+MIJR8N2ZcK2gsqzZxhQHjGou4EVfKz5vIND3sikLqs
         ioTQyaRcCKr3zSgB5und30SKf1U9GGUwQ2UncMQfM2xhd9Uf8i481Zu6BmpYspX4O8Dd
         UgHFGXWczbRs/uigNwBtMd85iAzaqNXDPCRaM15g/q72CqrlHBTz3BI1ZIIgTIktj5Dr
         YKSITHXz0yq8SCE8aV+Q2r5nQgqPCF0QEtecE76t4pr3Cj+QPMyr8voAXhm4KeDjxhct
         QhTZKTlaiKBafuUpt4VYoOXK7DFA1xoC70iQwHSVzXxYjtfCMFM96FDZ/3SlyTZSVMyw
         vTTA==
X-Forwarded-Encrypted: i=1; AJvYcCU4NdGgmkwE05Ui4RwQTrzP/vLgWz3mNh/ux0IOqd+n6f5sAkqpGCFkmOUCabdNm69RwaoWEaRICrqAzqI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRa2nIYJ2DBnI8kU7dOrgIjD6EKN3RrAfD+j0NqdFJoT8N0RA5
	znZb4ZulOyjWgcjuM6yjimlxs1NkWE0nLpqqWjOco49rDco+mqD+CK2504MEirmgXJ8eJXlItJB
	ELOpH4DZhfOWRkU562td7rmkGtK4gd13DUOoB0Ng=
X-Gm-Gg: ASbGncueHmbk94Nxs6fVSydSOxEb/ZuyQSzVUehnRLi3nh0pWAzGXItvaoI/Wv1TPvj
	+Bnp6rY6WDYjVDXmt+nwyGczCXc+JJSaFxw8f6eTdgGCPikmthQabw7XPdA4h5ySIul+OdBOLlH
	2YAB5MtcxiuRAwdIXQA11xmWI5+yawLBp8uuGRwzwlAKkSrX3qNpwHFsaRDyKUKKXIdT/AM0wf0
	3juoRE5AasdFlYHoN/htyqi/QPRNbuSo9yg/An8bw7dmxp6OKoKoOOlpWo6CvK5+zu8UOSmym3S
	MtQNxA==
X-Google-Smtp-Source: AGHT+IFpr/4m7kqFyVp6wv7lGNWYepzTg8Zt7CTxQPr9rwyqLTHTilIDdohkSa0G6a38Dwte5D8WBF80QQAULjpMjVA=
X-Received: by 2002:a05:6214:29ce:b0:880:4c73:9e3b with SMTP id
 6a1803df08f44-882925c47f5mr247916706d6.15.1763539975325; Wed, 19 Nov 2025
 00:12:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAsfc_ry+u771V_dTQMiXpaz2iGbQOPmZfhwnyF56pM+FjXdsw@mail.gmail.com>
 <4y5xucuqqqe4ppxu46nwsr6g34bu7ixc5xwwogdvkdpl3zhqi6@c6lj7rk5giem>
 <CAAsfc_pa=AwaaN6Fy2jU6nPwnGET0oZgWZtSc3LtQ9_oJ6supA@mail.gmail.com>
 <CAAsfc_rRK1rBVYFOzdioQSj5BL_t--Sbg6y5KhS+uiSeKz51xw@mail.gmail.com> <CAAsfc_pafORaG_PrVpOB9GBK+YCjdzJMd2Ww=ya2PbcPkw04+w@mail.gmail.com>
In-Reply-To: <CAAsfc_pafORaG_PrVpOB9GBK+YCjdzJMd2Ww=ya2PbcPkw04+w@mail.gmail.com>
From: liequan che <liequanche@gmail.com>
Date: Wed, 19 Nov 2025 16:12:43 +0800
X-Gm-Features: AWmQ_bmyegNzM53loB2ULYV1djoH10Q3gCydOmPFKqamxldxo_z4on5kqXJPRrA
Message-ID: <CAAsfc_p4KWYgkfny0BqS8G7jOiXf_r1QCb0x0Sh56je=GBdUXw@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: fix UAF in cached_dev_free and safely flush/destroy
To: Coly Li <colyli@fnnas.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 Hi Coly and Kent,

Sorry for the earlier omissions. Here is a concise correction and completio=
n.

1) Could you please point out exactly which reference is still held?
From the crash we analyzed, there isn=E2=80=99t a leaked struct cached_dev
reference causing the panic. The long-lived references during teardown
behave as expected:

dc->disk.cl (closure) is taken/released around detach/free paths.

dc->count (refcount) gates device lifetime.

The actual failure is a stop-ownership race on dc->writeback_thread:
one path stops the kthread and it exits (freeing the task), while
another racing path still calls kthread_stop() on a stale pointer,
triggering the refcount_t warning and subsequent fault. In short, it=E2=80=
=99s
not a missing cached_dev_put(), but a second kthread_stop() against an
already exited thread.


2) Could you please point out all the locations where writeback_wq is stopp=
ed?
If by =E2=80=9Cstopped=E2=80=9D you mean flush/destroy of the per-device wr=
iteback
workqueue (dc->writeback_write_wq), there is only one place:

At the tail of bch_writeback_thread():

if (dc->writeback_write_wq) {
    flush_workqueue(dc->writeback_write_wq);
    destroy_workqueue(dc->writeback_write_wq);
}

Other sites stop the thread (see next paragraph), but do not
flush/destroy the workqueue.

For completeness, there are exactly three call sites that may call
kthread_stop(dc->writeback_thread):

cached_dev_detach_finish()

bch_cached_dev_attach() error path when bch_cached_dev_run() fails
(and error !=3D -EBUSY)

cached_dev_free()

Note: bch_writeback_thread() does not call kthread_stop() on itself;
it only tears down its WQ, then cached_dev_put(dc) and
wait_for_kthread_stop().


The per-device writeback workqueue is flushed/destroyed at one place:

1=E3=80=81bch_writeback_thread() tail =E2=80=94 it does not call kthread_st=
op(); it
only tears down dc->writeback_write_wq (flush + destroy), then
cached_dev_put(dc) and
 wait_for_kthread_stop().

3=EF=BC=89how the panic comes in code logic

I/O errors -> bch_cache_set_error()
   -> set_bit(CACHE_SET_IO_DISABLE)
   -> conditional_stop_bcache_device()
        -> bcache_device_stop() -> cached_dev_flush()
             -> continue_at(..., cached_dev_free, system_wq)
                   -> cached_dev_free():
kthread_stop(writeback_thread) [Thread stop site #3]

Meanwhile writeback thread observes IO_DISABLE:
   bch_writeback_thread():
      exit path:
        - flush/destroy dc->writeback_write_wq (single owner)
        - cached_dev_put(dc)
        - wait_for_kthread_stop()

If last ref:
   queue detach once:
      cached_dev_detach_finish():
         - cancel writeback-rate dwork
         - kthread_stop(writeback_thread) if still present [Thread stop sit=
e #1]
         - bcache_device_detach(), list moves, clear flags, closure_put()

Attach error path:
   bch_cached_dev_attach():
      if bch_cached_dev_run() fails && err !=3D -EBUSY:
         - kthread_stop(writeback_thread) [Thread stop site #2]
         - cancel writeback-rate dwork

I/O errors (e.g., NVMe remove/journal error)
   |
   v
bch_cache_set_error()
   |-- set_bit(CACHE_SET_IO_DISABLE, &c->flags)
   |-- conditional_stop_bcache_device()
          |
          v
       bcache_device_stop()
          |
          v
       cached_dev_flush()
          |
          v
       (system "events" WQ) -> cached_dev_free(dc)
                                |
                                +-- kthread_stop(dc->writeback_thread)   [A=
]
                                +-- kthread_stop(dc->status_update_thread)
                                '-- cancel writeback-rate dwork, unlink, fr=
ee...

Meanwhile:
bch_writeback_thread(dc) sees IO_DISABLE or should_stop and exits:
   |
   +-- flush/destroy dc->writeback_write_wq      [sole WQ teardown site]
   +-- cached_dev_put(dc)
   '-- wait_for_kthread_stop()

Race:
- One path already ended the thread and freed its task_struct.
- A second path still calls kthread_stop(dc->writeback_thread) on the
stale pointer
  -> refcount splat / GPF (what we observe).

Thanks again, and apologies for the earlier incomplete answer.

Best regards,
cheliequan

liequan che <liequanche@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8813=E6=
=97=A5=E5=91=A8=E5=9B=9B 19:38=E5=86=99=E9=81=93=EF=BC=9A
>
> stop writeback thread and rate-update work exactly once across teardown p=
aths,
> - Add STOP_THREAD_ONCE() and use it at all three places that stop
>   dc->writeback_thread: cached_dev_detach_finish(), cached_dev_free(),
>   and the bch_cached_dev_attach() error path.
> - In cached_dev_detach_finish(), also clear WB_RUNNING and cancel the
>   periodic writeback-rate delayed work to avoid a UAF window after
>   detach is initiated.
> - Keep the per-dc writeback workqueue flush/destroy in the writeback
>   thread exit tail, avoiding double-destroy.
> Signed-off-by: cheliequan <cheliequan@inspur.com>
> ---
>  drivers/md/bcache/bcache.h    | 11 +++++++++++
>  drivers/md/bcache/super.c     | 14 ++++++--------
>  drivers/md/bcache/writeback.c |  7 +++++--
>  3 files changed, 22 insertions(+), 10 deletions(-)
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 1d33e40d26ea..66dc5dca5c20 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -961,6 +961,17 @@ static inline void wait_for_kthread_stop(void)
>         }
>  }
>
> +/*
> + * Stop a kthread exactly once by taking ownership of the pointer.
> + * Safe against concurrent callers and against already-stopped threads.
> + */
> +#define STOP_THREAD_ONCE(dc, member)                                    =
\
> +       do {                                                             =
\
> +               struct task_struct *t__ =3D xchg(&(dc)->member, NULL);   =
  \
> +               if (t__ && !IS_ERR(t__))                                 =
\
> +               kthread_stop(t__);                                       =
\
> +       } while (0)
> +
>  /* Forward declarations */
>
>  void bch_count_backing_io_errors(struct cached_dev *dc, struct bio *bio)=
;
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 1492c8552255..b4da0a505d4a 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1143,8 +1143,7 @@ static void cached_dev_detach_finish(struct
> work_struct *w)
>                 cancel_writeback_rate_update_dwork(dc);
>
>         if (!IS_ERR_OR_NULL(dc->writeback_thread)) {
> -               kthread_stop(dc->writeback_thread);
> -               dc->writeback_thread =3D NULL;
> +               STOP_THREAD_ONCE(dc, writeback_thread);
>         }
>
>         mutex_lock(&bch_register_lock);
> @@ -1308,8 +1307,9 @@ int bch_cached_dev_attach(struct cached_dev *dc,
> struct cache_set *c,
>                  * created previously in bch_cached_dev_writeback_start()
>                  * have to be stopped manually here.
>                  */
> -               kthread_stop(dc->writeback_thread);
> -               cancel_writeback_rate_update_dwork(dc);
> +               if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.f=
lags))
> +                       cancel_writeback_rate_update_dwork(dc);
> +               STOP_THREAD_ONCE(dc, writeback_thread);
>                 pr_err("Couldn't run cached device %pg\n", dc->bdev);
>                 return ret;
>         }
> @@ -1349,10 +1349,8 @@ static CLOSURE_CALLBACK(cached_dev_free)
>         if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
>                 cancel_writeback_rate_update_dwork(dc);
>
> -       if (!IS_ERR_OR_NULL(dc->writeback_thread))
> -               kthread_stop(dc->writeback_thread);
> -       if (!IS_ERR_OR_NULL(dc->status_update_thread))
> -               kthread_stop(dc->status_update_thread);
> +       STOP_THREAD_ONCE(dc, writeback_thread);
> +       STOP_THREAD_ONCE(dc, status_update_thread);
>
>         mutex_lock(&bch_register_lock);
>
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.=
c
> index 302e75f1fc4b..50e67a784acd 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -741,6 +741,7 @@ static int bch_writeback_thread(void *arg)
>         struct cached_dev *dc =3D arg;
>         struct cache_set *c =3D dc->disk.c;
>         bool searched_full_index;
> +       struct workqueue_struct *wq =3D NULL;
>
>         bch_ratelimit_reset(&dc->writeback_rate);
>
> @@ -832,8 +833,10 @@ static int bch_writeback_thread(void *arg)
>                 }
>         }
>
> -       if (dc->writeback_write_wq)
> -               destroy_workqueue(dc->writeback_write_wq);
> +       wq =3D xchg(&dc->writeback_write_wq, NULL);
> +       if (wq) {
> +           destroy_workqueue(wq);
> +        }
>
>         cached_dev_put(dc);
>         wait_for_kthread_stop();
> --
> 2.25.1

