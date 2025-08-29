Return-Path: <linux-bcache+bounces-1198-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1DBB3B529
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Aug 2025 10:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F2711C853D5
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Aug 2025 08:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D1F299A94;
	Fri, 29 Aug 2025 07:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WuwOZXyQ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A6728980F
	for <linux-bcache@vger.kernel.org>; Fri, 29 Aug 2025 07:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756454216; cv=none; b=eYh3i5YEqoa+iDqBwXPmwFDNi27oawqpse9nC2QTPUn/cJYrCfhnNKzbkFWZcN8N7dU155UMiM/R/FN321k/34ctJKdlWqZ7JHy2tQuhul6tP+ggTNBnKKtRuk1dC/jpaSqpzi8sEKcRnqqlysxp2UpMW/98MRtXp9qLV4gIc6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756454216; c=relaxed/simple;
	bh=PoRJbQOXv0kU6GZLbltWxOrqt9GRc/3gYXV37iJ99A4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FXoFjhOuwlnLgdq6MXP/PTPqsyUFAur0w8P6tifiWxqPZXymEe/6sI4nzscPuonmzHogspzAKA2mwDd4GaWVzmhEnSRDO/fAcxeHDMNb0h74Kj2cPK3HRokiEaSSzjDHvMCuXcujKdSN7xphd4sIrmAJPGM+nQfOAsv8jVRheGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WuwOZXyQ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61ce9bcc624so1602927a12.1
        for <linux-bcache@vger.kernel.org>; Fri, 29 Aug 2025 00:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454212; x=1757059012; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eknZpVzC2l5forejYgCmvi9SebG3fKo/GsmJfhSS5x0=;
        b=WuwOZXyQ1mKfq+jS8sg4filKXdXiVv0UUikq77rDY85H9ADlDb2t9n2eSnmvvvpXKv
         r+LgBZXbjHpjEQnaPWrE9Y4VcOFPtNLKW8mChimGLpaAmKsvb1IZOnEAGIimaDwim6Au
         dH85yBHvyfvehgEEBe7M7/w+/q1gDfZkwwn3DN6IE2/FrSJXDXn/iWsTRhGeXstojciZ
         AemxO98P8Pq8XmMP1W/e0nXr44/ZdbbGDghPlNgtEiQQnIXqUzHYCYzfx79rfySnGylM
         sJ6AM4Si6oER8h6hBFhA7/y6MEML4ENk0gYyBibLkmW9bVqE57nxxXE6hCWfbx126kwl
         fJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454212; x=1757059012;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eknZpVzC2l5forejYgCmvi9SebG3fKo/GsmJfhSS5x0=;
        b=FnCJNgrut7YA+7zSHH6efksZ+XxPCnTO2qJJc+XOe+0FW81/15iBcFJgI9TklrsOmJ
         OycLX4HlIFXoT3D0FHaTpirk/G1N+DkcbJTcDbhM6ZEJneW+XnaNHTyU+6SsJffVWYFj
         tnNfFpzc9kJR3BFxCpFGOTGzM7aIaHqUM1iZJvmF/fXowCZFrA9tufsDu/zswK3ebKIp
         82Ijye7mcb2CtWKinyb8ANkaP5tUXGyXSwm9SObaV7hUOo2Y5i4d+nNmCv4IwyFf1Zoa
         wBVQSw4eBQWpl6HIVu7eip+eoXR3YBQ07I4+HQH+MtPIx9DBgduk87kqLYXbM3wq7Jq/
         AE8w==
X-Gm-Message-State: AOJu0YzqXunfA6ZYHk0HavX57CTQN0IbQlmC+Vuf2485oUkfsENJvCAW
	3efYFt2shiDmMKzekCOmcj0pNto7dAdMufdhkOm9iTdeiH/QLOZ/YjdGNkMTQ3NaM5eatXpFT7D
	YeHEnBmHsu2b0eXw8fbmfI6flfXDBYdM=
X-Gm-Gg: ASbGnctQD3Jgsa41dPzNTC4GI6DLspwY+YWsBAF7BxGlKwxXpOI8BOZvUc/VasJSomo
	vUknPeGUL/8ymrJPLfvyetT4t+9knto3eZdHHjFcexu+oqLvFca0bmoaS4K/Lb+wsYXMAxZjHcX
	dqbiqkHWhOQHeXqiRLUjIRiMNHamWONpUmWv2fphxOmjGbFyWh8iCnWGgABxZFhO3QQc8+Fyf9T
	jJ0Wj/ywv9whk+ElM3YLTaHzso4Og==
X-Google-Smtp-Source: AGHT+IGW6vDsPULZUvXmWTbhnj6HX0Fk2O49qy9/7w8XblUz0djXMEoRqODN1tDARf3CG/EtHt9QJuEFtgYE2OMhBa8=
X-Received: by 2002:a05:6402:358d:b0:61c:d118:6182 with SMTP id
 4fb4d7f45d1cf-61cd11892c6mr4624656a12.29.1756454212106; Fri, 29 Aug 2025
 00:56:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250828161951.33615-1-colyli@kernel.org>
In-Reply-To: <20250828161951.33615-1-colyli@kernel.org>
From: jifeng zhou <z583340363@gmail.com>
Date: Fri, 29 Aug 2025 15:56:42 +0800
X-Gm-Features: Ac12FXzWWEJ1GVszLUkQCk6OBbFEMc-uLCgSya7HgCOjMoh6Z_o6iJX0LUxwxNc
Message-ID: <CAOtvtNA++zLk0TcMwScJitDNGKUiVAVpMw803cYVG5vrtK2P_g@mail.gmail.com>
Subject: Re: [PATCH] bcache: improve writeback throughput when frontend I/O is idle
To: colyli@kernel.org
Cc: linux-bcache@vger.kernel.org, Coly Li <colyli@fnnas.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 Aug 2025 at 00:20, <colyli@kernel.org> wrote:
>
> Currently in order to write dirty blocks to backend device in LBA order
> for better performance, inside write_dirty() the I/O is issued only when
> its sequence matches current expected sequence. Otherwise the kworker
> will repeat check-wait-woken loop until the sequence number matches.
>
> When frontend I/O is idle, the writeback rate is set to INT_MAX, but the
> writeback thoughput doesn't increase much. There are two reasons,
> - The check-wait-woken loop is inefficient.
> - I/O depth on backing device is every low.
>
> To improve the writeback throughput, this patch continues to use LBA re-
> order idea, but improves it by the following means,
> - Do the reorder from write_dirty() to read_dirty().
>   Inside read_dirty(), use a min_heap to order all the to-be-writebacked
>   keys, and read dirty blocks in LBA order. Although each read requests
>   are not completed in issue order, there is no check-wait-woken loop so
>   that the dirty blocks are issued in a small time range and they can be
>   ordered by I/O schedulers efficiently.
>
> - Read more dirty keys when frontend I/O is idle
>   Define WRITEBACKS_IN_PASS (5), MAX_WRITEBACKS_IN_PASS (80) for write-
>   back dirty keys in each pass, and define WRITESIZE_IN_PASS (5000) and
>   MAX_WRITESIZE_IN_PASS (80000) for total writeback data size in each
>   pass. When frontend I/O is idle, new values MAX_WRITEBACKS_IN_PASS and
>   MAX_WRITESIZE_IN_PASS are used to read more dirty keys and data size
>   from cache deice, then more dirty blocks will be written to backend
>   device in almost LBA order.
>
> By this effort, when there is frontend I/O, the IOPS and latency almost
> has no difference observed, identical from previous read_dirty() and
> write_dirty() implementation. When frontend I/O is idle, with this patch
> the average queue size increases from 2.5 to 21, writeback thoughput on
> backing device increases from 12MiB/s to 20MiB/s.
>
> Writeback throughput increases around 67% when frontend I/O is idle.
>
> Signed-off-by: Coly Li <colyli@fnnas.com>
> ---
>  drivers/md/bcache/bcache.h    |  1 +
>  drivers/md/bcache/util.h      |  8 ++++
>  drivers/md/bcache/writeback.c | 82 +++++++++++++++++------------------
>  drivers/md/bcache/writeback.h |  6 ++-
>  4 files changed, 52 insertions(+), 45 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index d43fcccf297c..88fb9bb69ce9 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -345,6 +345,7 @@ struct cached_dev {
>         struct workqueue_struct *writeback_write_wq;
>
>         struct keybuf           writeback_keys;
> +       DECLARE_HEAP(struct keybuf_key *, read_dirty_heap);
>
>         struct task_struct      *status_update_thread;
>         /*
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index f61ab1bada6c..3f5f85bdeafe 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -46,6 +46,14 @@ struct closure;
>         (heap)->data;                                                   \
>  })
>
> +#define reset_heap(heap)                                               \
> +({                                                                     \
> +       size_t _bytes;                                                  \
> +       _bytes = (heap)->size * sizeof(*(heap)->data);                  \
> +       memset((heap)->data, 0, _bytes);                                \
> +       (heap)->used = 0;                                               \
> +})
> +
>  #define free_heap(heap)                                                        \
>  do {                                                                   \
>         kvfree((heap)->data);                                           \
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 302e75f1fc4b..4f0e47c841aa 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -406,26 +406,6 @@ static CLOSURE_CALLBACK(write_dirty)
>         struct keybuf_key *w = io->bio.bi_private;
>         struct cached_dev *dc = io->dc;
>
> -       uint16_t next_sequence;
> -
> -       if (atomic_read(&dc->writeback_sequence_next) != io->sequence) {
> -               /* Not our turn to write; wait for a write to complete */
> -               closure_wait(&dc->writeback_ordering_wait, cl);
> -
> -               if (atomic_read(&dc->writeback_sequence_next) == io->sequence) {
> -                       /*
> -                        * Edge case-- it happened in indeterminate order
> -                        * relative to when we were added to wait list..
> -                        */
> -                       closure_wake_up(&dc->writeback_ordering_wait);
> -               }
> -
> -               continue_at(cl, write_dirty, io->dc->writeback_write_wq);
> -               return;
> -       }
> -
> -       next_sequence = io->sequence + 1;
> -
>         /*
>          * IO errors are signalled using the dirty bit on the key.
>          * If we failed to read, we should not attempt to write to the
> @@ -443,7 +423,6 @@ static CLOSURE_CALLBACK(write_dirty)
>                 closure_bio_submit(io->dc->disk.c, &io->bio, cl);
>         }
>
> -       atomic_set(&dc->writeback_sequence_next, next_sequence);
>         closure_wake_up(&dc->writeback_ordering_wait);
>
>         continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
> @@ -471,18 +450,25 @@ static CLOSURE_CALLBACK(read_dirty_submit)
>         continue_at(cl, write_dirty, io->dc->writeback_write_wq);
>  }
>
> +static uint64_t keybuf_key_cmp(const struct keybuf_key *l,
> +                              const struct keybuf_key *r)
> +{
> +       if (unlikely((KEY_INODE(&l->key) != KEY_INODE(&r->key))))
> +               return KEY_INODE(&l->key) > KEY_INODE(&r->key);
> +       else
> +               return KEY_OFFSET(&l->key) > KEY_OFFSET(&r->key);
> +}
> +
>  static void read_dirty(struct cached_dev *dc)
>  {
>         unsigned int delay = 0;
> -       struct keybuf_key *next, *keys[MAX_WRITEBACKS_IN_PASS], *w;
> -       size_t size;
> -       int nk, i;
> +       struct keybuf_key *next, *w;
>         struct dirty_io *io;
>         struct closure cl;
> -       uint16_t sequence = 0;
> +       size_t size;
> +       int nk, i;
>
>         BUG_ON(!llist_empty(&dc->writeback_ordering_wait.list));
> -       atomic_set(&dc->writeback_sequence_next, sequence);
>         closure_init_stack(&cl);
>
>         /*
> @@ -495,46 +481,49 @@ static void read_dirty(struct cached_dev *dc)
>         while (!kthread_should_stop() &&
>                !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
>                next) {
> +               size_t max_size_in_pass;
> +               int max_writebacks_in_pass;
> +
>                 size = 0;
>                 nk = 0;
> +               reset_heap(&dc->read_dirty_heap);
>
>                 do {
>                         BUG_ON(ptr_stale(dc->disk.c, &next->key, 0));
>
> +                       if (atomic_read(&dc->disk.c->at_max_writeback_rate)) {
> +                               max_writebacks_in_pass = MAX_WRITEBACKS_IN_PASS;
> +                               max_size_in_pass = MAX_WRITESIZE_IN_PASS;
> +                       } else {
> +                               max_writebacks_in_pass = WRITEBACKS_IN_PASS;
> +                               max_size_in_pass = WRITESIZE_IN_PASS;
> +                       }
> +
>                         /*
>                          * Don't combine too many operations, even if they
>                          * are all small.
>                          */
> -                       if (nk >= MAX_WRITEBACKS_IN_PASS)
> +                       if (nk >= max_writebacks_in_pass)
>                                 break;
>
>                         /*
>                          * If the current operation is very large, don't
>                          * further combine operations.
>                          */
> -                       if (size >= MAX_WRITESIZE_IN_PASS)
> +                       if (size >= max_size_in_pass)
>                                 break;
>
> -                       /*
> -                        * Operations are only eligible to be combined
> -                        * if they are contiguous.
> -                        *
> -                        * TODO: add a heuristic willing to fire a
> -                        * certain amount of non-contiguous IO per pass,
> -                        * so that we can benefit from backing device
> -                        * command queueing.
> -                        */
> -                       if ((nk != 0) && bkey_cmp(&keys[nk-1]->key,
> -                                               &START_KEY(&next->key)))
> +                       if (!heap_add(&dc->read_dirty_heap, next,
> +                                     keybuf_key_cmp))
>                                 break;

The bkeys retrieved from the dc->writeback_keys rbtree are in a specific order.
Can the heap sorting here be omitted?

Zhou Jifeng

>
>                         size += KEY_SIZE(&next->key);
> -                       keys[nk++] = next;
> +                       nk++;
>                 } while ((next = bch_keybuf_next(&dc->writeback_keys)));
>
>                 /* Now we have gathered a set of 1..5 keys to write back. */
>                 for (i = 0; i < nk; i++) {
> -                       w = keys[i];
> +                       heap_pop(&dc->read_dirty_heap, w, keybuf_key_cmp);
>
>                         io = kzalloc(struct_size(io, bio.bi_inline_vecs,
>                                                 DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS)),
> @@ -544,7 +533,6 @@ static void read_dirty(struct cached_dev *dc)
>
>                         w->private      = io;
>                         io->dc          = dc;
> -                       io->sequence    = sequence++;
>
>                         dirty_init(w);
>                         io->bio.bi_opf = REQ_OP_READ;
> @@ -835,6 +823,7 @@ static int bch_writeback_thread(void *arg)
>         if (dc->writeback_write_wq)
>                 destroy_workqueue(dc->writeback_write_wq);
>
> +       free_heap(&dc->read_dirty_heap);
>         cached_dev_put(dc);
>         wait_for_kthread_stop();
>
> @@ -1080,12 +1069,19 @@ int bch_cached_dev_writeback_start(struct cached_dev *dc)
>         if (!dc->writeback_write_wq)
>                 return -ENOMEM;
>
> +       if (!init_heap(&dc->read_dirty_heap, MAX_WRITEBACKS_IN_PASS,
> +                      GFP_KERNEL)) {
> +               destroy_workqueue(dc->writeback_write_wq);
> +               return -ENOMEM;
> +       }
> +
>         cached_dev_get(dc);
>         dc->writeback_thread = kthread_create(bch_writeback_thread, dc,
>                                               "bcache_writeback");
>         if (IS_ERR(dc->writeback_thread)) {
> -               cached_dev_put(dc);
>                 destroy_workqueue(dc->writeback_write_wq);
> +               free_heap(&dc->read_dirty_heap);
> +               cached_dev_put(dc);
>                 return PTR_ERR(dc->writeback_thread);
>         }
>         dc->writeback_running = true;
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index 31df716951f6..7e6b75768cad 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -8,8 +8,10 @@
>  #define CUTOFF_WRITEBACK_MAX           70
>  #define CUTOFF_WRITEBACK_SYNC_MAX      90
>
> -#define MAX_WRITEBACKS_IN_PASS  5
> -#define MAX_WRITESIZE_IN_PASS   5000   /* *512b */
> +#define WRITEBACKS_IN_PASS             5
> +#define MAX_WRITEBACKS_IN_PASS         80
> +#define WRITESIZE_IN_PASS              5000  /* *512b */
> +#define MAX_WRITESIZE_IN_PASS          80000 /* *512b */
>
>  #define WRITEBACK_RATE_UPDATE_SECS_MAX         60
>  #define WRITEBACK_RATE_UPDATE_SECS_DEFAULT     5
> --
> 2.47.2
>
>

