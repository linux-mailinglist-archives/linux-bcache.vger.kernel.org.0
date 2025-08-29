Return-Path: <linux-bcache+bounces-1199-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65524B3C252
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Aug 2025 20:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20BA8A60F85
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Aug 2025 18:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947E3250BF2;
	Fri, 29 Aug 2025 18:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NwMOw6JD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE277111
	for <linux-bcache@vger.kernel.org>; Fri, 29 Aug 2025 18:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756491452; cv=none; b=cw/C9Mc6ud30DHh0h6upiR/vkc96Pmm96s0OOug07TgF4YHe2AT8ejeNIH57M80wIosDjjRzDCsluUd0auq/7+IXNQI0TkK6bA3QWXFRWuOu04dpU6Hke8F/BpWde5i3z7/o5XIjaNj/A6/+VSkyDf8aIVH3wkO0d+6vcacUDmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756491452; c=relaxed/simple;
	bh=Opzg0fksQlccqwICCb0LeoitqtWcA9kAj78ponxPPV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7ljnV0FLs2LhJlBuvtWloI0yDUAY5TD1Y08D57TXR5vnDW7hqZWSGch012t97GpeEKsxXSSK9P7/c9vFhuPsc2jauD8TGCbYqEWlRjaAPaerGJuD3DqDgWpu/wN9XY/Z1Oyt2aYjjBJfh8a9autP6lukWxLA50VsegLv0hfKSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NwMOw6JD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6400AC4CEF0;
	Fri, 29 Aug 2025 18:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756491452;
	bh=Opzg0fksQlccqwICCb0LeoitqtWcA9kAj78ponxPPV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NwMOw6JDNmPsDPr9YI99KdK1VJZ7EVT2Zl8ZN0h3IDIbsVHZ0+GMRSguo6u8q+c31
	 Bdhsh4ibtriQ5HZ3mZXrmBg6XKkjN1umcsKt2ZH1DLXco7Y46WeKcIkcVMZNUnUjBw
	 hzD0na+xHr51a/JtlsrqCFwFTc4hiMUaFpzn0hppQSl8sqbQ18XBPE2Eo5GdDpgqBE
	 tEKC9yJLgLtWArSK6E52Zhfcwg7jhuQu3e7EBJ9/PlhxgS7mDmR3LnFy++U0COuV0+
	 4q68T4DaHqaVFotR9xNyeU+OJEbLrZW1tEFgTNm8UXS5AzrLl4/QfsXcdiSfRGloxc
	 +QRSVVfb4cunA==
Date: Sat, 30 Aug 2025 02:17:29 +0800
From: Coly Li <colyli@kernel.org>
To: jifeng zhou <z583340363@gmail.com>
Cc: linux-bcache@vger.kernel.org, Coly Li <colyli@fnnas.com>
Subject: Re: [PATCH] bcache: improve writeback throughput when frontend I/O
 is idle
Message-ID: <2wpmy6joztl2uc5v5mrv4v4edkqtijpbwe7pqlfrbv6hh3mgks@bgab27rwjkka>
References: <20250828161951.33615-1-colyli@kernel.org>
 <CAOtvtNA++zLk0TcMwScJitDNGKUiVAVpMw803cYVG5vrtK2P_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOtvtNA++zLk0TcMwScJitDNGKUiVAVpMw803cYVG5vrtK2P_g@mail.gmail.com>

On Fri, Aug 29, 2025 at 03:56:42PM +0800, jifeng zhou wrote:
> On Fri, 29 Aug 2025 at 00:20, <colyli@kernel.org> wrote:
> >
> > Currently in order to write dirty blocks to backend device in LBA order
> > for better performance, inside write_dirty() the I/O is issued only when
> > its sequence matches current expected sequence. Otherwise the kworker
> > will repeat check-wait-woken loop until the sequence number matches.
> >
> > When frontend I/O is idle, the writeback rate is set to INT_MAX, but the
> > writeback thoughput doesn't increase much. There are two reasons,
> > - The check-wait-woken loop is inefficient.
> > - I/O depth on backing device is every low.
> >
> > To improve the writeback throughput, this patch continues to use LBA re-
> > order idea, but improves it by the following means,
> > - Do the reorder from write_dirty() to read_dirty().
> >   Inside read_dirty(), use a min_heap to order all the to-be-writebacked
> >   keys, and read dirty blocks in LBA order. Although each read requests
> >   are not completed in issue order, there is no check-wait-woken loop so
> >   that the dirty blocks are issued in a small time range and they can be
> >   ordered by I/O schedulers efficiently.
> >
> > - Read more dirty keys when frontend I/O is idle
> >   Define WRITEBACKS_IN_PASS (5), MAX_WRITEBACKS_IN_PASS (80) for write-
> >   back dirty keys in each pass, and define WRITESIZE_IN_PASS (5000) and
> >   MAX_WRITESIZE_IN_PASS (80000) for total writeback data size in each
> >   pass. When frontend I/O is idle, new values MAX_WRITEBACKS_IN_PASS and
> >   MAX_WRITESIZE_IN_PASS are used to read more dirty keys and data size
> >   from cache deice, then more dirty blocks will be written to backend
> >   device in almost LBA order.
> >
> > By this effort, when there is frontend I/O, the IOPS and latency almost
> > has no difference observed, identical from previous read_dirty() and
> > write_dirty() implementation. When frontend I/O is idle, with this patch
> > the average queue size increases from 2.5 to 21, writeback thoughput on
> > backing device increases from 12MiB/s to 20MiB/s.
> >
> > Writeback throughput increases around 67% when frontend I/O is idle.
> >
> > Signed-off-by: Coly Li <colyli@fnnas.com>
> > ---
> >  drivers/md/bcache/bcache.h    |  1 +
> >  drivers/md/bcache/util.h      |  8 ++++
> >  drivers/md/bcache/writeback.c | 82 +++++++++++++++++------------------
> >  drivers/md/bcache/writeback.h |  6 ++-
> >  4 files changed, 52 insertions(+), 45 deletions(-)
> >
> > diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> > index d43fcccf297c..88fb9bb69ce9 100644
> > --- a/drivers/md/bcache/bcache.h
> > +++ b/drivers/md/bcache/bcache.h
> > @@ -345,6 +345,7 @@ struct cached_dev {
> >         struct workqueue_struct *writeback_write_wq;
> >
> >         struct keybuf           writeback_keys;
> > +       DECLARE_HEAP(struct keybuf_key *, read_dirty_heap);
> >
> >         struct task_struct      *status_update_thread;
> >         /*
> > diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> > index f61ab1bada6c..3f5f85bdeafe 100644
> > --- a/drivers/md/bcache/util.h
> > +++ b/drivers/md/bcache/util.h
> > @@ -46,6 +46,14 @@ struct closure;
> >         (heap)->data;                                                   \
> >  })
> >
> > +#define reset_heap(heap)                                               \
> > +({                                                                     \
> > +       size_t _bytes;                                                  \
> > +       _bytes = (heap)->size * sizeof(*(heap)->data);                  \
> > +       memset((heap)->data, 0, _bytes);                                \
> > +       (heap)->used = 0;                                               \
> > +})
> > +
> >  #define free_heap(heap)                                                        \
> >  do {                                                                   \
> >         kvfree((heap)->data);                                           \
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> > index 302e75f1fc4b..4f0e47c841aa 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -406,26 +406,6 @@ static CLOSURE_CALLBACK(write_dirty)
> >         struct keybuf_key *w = io->bio.bi_private;
> >         struct cached_dev *dc = io->dc;
> >
> > -       uint16_t next_sequence;
> > -
> > -       if (atomic_read(&dc->writeback_sequence_next) != io->sequence) {
> > -               /* Not our turn to write; wait for a write to complete */
> > -               closure_wait(&dc->writeback_ordering_wait, cl);
> > -
> > -               if (atomic_read(&dc->writeback_sequence_next) == io->sequence) {
> > -                       /*
> > -                        * Edge case-- it happened in indeterminate order
> > -                        * relative to when we were added to wait list..
> > -                        */
> > -                       closure_wake_up(&dc->writeback_ordering_wait);
> > -               }
> > -
> > -               continue_at(cl, write_dirty, io->dc->writeback_write_wq);
> > -               return;
> > -       }
> > -
> > -       next_sequence = io->sequence + 1;
> > -
> >         /*
> >          * IO errors are signalled using the dirty bit on the key.
> >          * If we failed to read, we should not attempt to write to the
> > @@ -443,7 +423,6 @@ static CLOSURE_CALLBACK(write_dirty)
> >                 closure_bio_submit(io->dc->disk.c, &io->bio, cl);
> >         }
> >
> > -       atomic_set(&dc->writeback_sequence_next, next_sequence);
> >         closure_wake_up(&dc->writeback_ordering_wait);
> >
> >         continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
> > @@ -471,18 +450,25 @@ static CLOSURE_CALLBACK(read_dirty_submit)
> >         continue_at(cl, write_dirty, io->dc->writeback_write_wq);
> >  }
> >
> > +static uint64_t keybuf_key_cmp(const struct keybuf_key *l,
> > +                              const struct keybuf_key *r)
> > +{
> > +       if (unlikely((KEY_INODE(&l->key) != KEY_INODE(&r->key))))
> > +               return KEY_INODE(&l->key) > KEY_INODE(&r->key);
> > +       else
> > +               return KEY_OFFSET(&l->key) > KEY_OFFSET(&r->key);
> > +}
> > +
> >  static void read_dirty(struct cached_dev *dc)
> >  {
> >         unsigned int delay = 0;
> > -       struct keybuf_key *next, *keys[MAX_WRITEBACKS_IN_PASS], *w;
> > -       size_t size;
> > -       int nk, i;
> > +       struct keybuf_key *next, *w;
> >         struct dirty_io *io;
> >         struct closure cl;
> > -       uint16_t sequence = 0;
> > +       size_t size;
> > +       int nk, i;
> >
> >         BUG_ON(!llist_empty(&dc->writeback_ordering_wait.list));
> > -       atomic_set(&dc->writeback_sequence_next, sequence);
> >         closure_init_stack(&cl);
> >
> >         /*
> > @@ -495,46 +481,49 @@ static void read_dirty(struct cached_dev *dc)
> >         while (!kthread_should_stop() &&
> >                !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
> >                next) {
> > +               size_t max_size_in_pass;
> > +               int max_writebacks_in_pass;
> > +
> >                 size = 0;
> >                 nk = 0;
> > +               reset_heap(&dc->read_dirty_heap);
> >
> >                 do {
> >                         BUG_ON(ptr_stale(dc->disk.c, &next->key, 0));
> >
> > +                       if (atomic_read(&dc->disk.c->at_max_writeback_rate)) {
> > +                               max_writebacks_in_pass = MAX_WRITEBACKS_IN_PASS;
> > +                               max_size_in_pass = MAX_WRITESIZE_IN_PASS;
> > +                       } else {
> > +                               max_writebacks_in_pass = WRITEBACKS_IN_PASS;
> > +                               max_size_in_pass = WRITESIZE_IN_PASS;
> > +                       }
> > +
> >                         /*
> >                          * Don't combine too many operations, even if they
> >                          * are all small.
> >                          */
> > -                       if (nk >= MAX_WRITEBACKS_IN_PASS)
> > +                       if (nk >= max_writebacks_in_pass)
> >                                 break;
> >
> >                         /*
> >                          * If the current operation is very large, don't
> >                          * further combine operations.
> >                          */
> > -                       if (size >= MAX_WRITESIZE_IN_PASS)
> > +                       if (size >= max_size_in_pass)
> >                                 break;
> >
> > -                       /*
> > -                        * Operations are only eligible to be combined
> > -                        * if they are contiguous.
> > -                        *
> > -                        * TODO: add a heuristic willing to fire a
> > -                        * certain amount of non-contiguous IO per pass,
> > -                        * so that we can benefit from backing device
> > -                        * command queueing.
> > -                        */
> > -                       if ((nk != 0) && bkey_cmp(&keys[nk-1]->key,
> > -                                               &START_KEY(&next->key)))
> > +                       if (!heap_add(&dc->read_dirty_heap, next,
> > +                                     keybuf_key_cmp))
> >                                 break;
> 
> The bkeys retrieved from the dc->writeback_keys rbtree are in a specific order.
> Can the heap sorting here be omitted?

Indeed the keys in dc->writeback_keys are not in a specific order, yes they are
in the order from oldest to newest, but there is *NO* overlap betwen any two
keys in dc->writeback_keys. See RB_INSERT() inside refill_keybuf_fn().

Because there is no overlap inside keys of dc->writeback_keys, re-order them by
LBA incremental order won't make trouble here.

Thanks.

Coly Li

 

