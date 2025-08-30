Return-Path: <linux-bcache+bounces-1200-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 496A9B3C8E7
	for <lists+linux-bcache@lfdr.de>; Sat, 30 Aug 2025 09:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 054CBA02CE9
	for <lists+linux-bcache@lfdr.de>; Sat, 30 Aug 2025 07:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32FB926C385;
	Sat, 30 Aug 2025 07:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="d25xlACG"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail85.out.titan.email (mail85.out.titan.email [3.216.99.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C33264624
	for <linux-bcache@vger.kernel.org>; Sat, 30 Aug 2025 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.216.99.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756540047; cv=none; b=XCYzMWXQ38ryL7KQ45s4o0mPqcVe4bsyR7nkeFHoZv+Fbj51t52JX8ogSkH2Jcq6MPfy3ZnzbcZturtn0ZmzaY7HVMJ5v0yObnVsNL3hyz5/9Xlno3lZStXw42HDTzyB/1QGyRpXrxjvOpG1HmdG4PyZ88H8a6vJzb7dCAJrDUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756540047; c=relaxed/simple;
	bh=vUrZMGsdgn758dFhlL/pte6r4VNg0B9IvP3nV2fC3v0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=FON9nuTrEh8ExQXE4d3P5B+2g5IuwXT3hRx56xFaDmXUgxnvMsNabnubfhR9gFhTx+AQ5Q76YoRaNxF9KTa+wSYDEDI9AIXpstaSIzW0avJMac3pFXu94tIeLKoY+kA4SfH7j0aF0Mx9ATuMbHYt5IHoy+dBaqC6R30HfqWV+1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=d25xlACG; arc=none smtp.client-ip=3.216.99.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 5A1B910000A;
	Sat, 30 Aug 2025 07:28:56 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=+wKDeWIXngC305Ix6UMS86kEdR/xv5z7k7Dz6PRiMNo=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=in-reply-to:references:mime-version:subject:from:date:cc:to:message-id:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1756538936; v=1;
	b=d25xlACGGLIxOS9ML58cYNQ5H4Yno/Mqs26647j4E04z0pRmp+t45TrxoTZkrIdz2ufFjlWO
	wrvjVxcCoJrlq8GqfmAqOdWiKR2YHeF4pVIR31YwwIXDMPj+I3a64zSv0LW75Gnv1sbM/oGAAgT
	CqvGETGiuMoyQwU757gQMB0c=
Received: from smtpclient.apple (42-200-231-247.static.imsbiz.com [42.200.231.247])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 8A53E100009;
	Sat, 30 Aug 2025 07:28:54 +0000 (UTC)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] bcache: improve writeback throughput when frontend I/O is
 idle
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <2wpmy6joztl2uc5v5mrv4v4edkqtijpbwe7pqlfrbv6hh3mgks@bgab27rwjkka>
Date: Sat, 30 Aug 2025 15:28:41 +0800
Cc: linux-bcache@vger.kernel.org,
 Coly Li <colyli@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5AFD45AB-C0B6-47BF-82A2-99BD38CD453D@coly.li>
References: <20250828161951.33615-1-colyli@kernel.org>
 <CAOtvtNA++zLk0TcMwScJitDNGKUiVAVpMw803cYVG5vrtK2P_g@mail.gmail.com>
 <2wpmy6joztl2uc5v5mrv4v4edkqtijpbwe7pqlfrbv6hh3mgks@bgab27rwjkka>
To: jifeng zhou <z583340363@gmail.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1756538936211889879.8766.4108097239299940848@prod-use1-smtp-out1002.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=evQlzppX c=1 sm=1 tr=0 ts=68b2a838
	a=1SoAjZNkZYAIyhvPV8pctQ==:117 a=1SoAjZNkZYAIyhvPV8pctQ==:17
	a=kj9zAlcOel0A:10 a=CEWIc4RMnpUA:10 a=VwQbUJbxAAAA:8 a=tJLSzyRPAAAA:8
	a=HR2vvlNUXTs0e8t3QwIA:9 a=CjuIK1q_8ugA:10 a=H0xsmVfZzgdqH4_HIfU3:22

On Sat, Aug 30, 2025 at 02:17:29AM +0800, Coly Li wrote:
> On Fri, Aug 29, 2025 at 03:56:42PM +0800, jifeng zhou wrote:
>> On Fri, 29 Aug 2025 at 00:20, <colyli@kernel.org> wrote:
>>>=20
>>> Currently in order to write dirty blocks to backend device in LBA =
order
>>> for better performance, inside write_dirty() the I/O is issued only =
when
>>> its sequence matches current expected sequence. Otherwise the =
kworker
>>> will repeat check-wait-woken loop until the sequence number matches.
>>>=20
>>> When frontend I/O is idle, the writeback rate is set to INT_MAX, but =
the
>>> writeback thoughput doesn't increase much. There are two reasons,
>>> - The check-wait-woken loop is inefficient.
>>> - I/O depth on backing device is every low.
>>>=20
>>> To improve the writeback throughput, this patch continues to use LBA =
re-
>>> order idea, but improves it by the following means,
>>> - Do the reorder from write_dirty() to read_dirty().
>>>  Inside read_dirty(), use a min_heap to order all the =
to-be-writebacked
>>>  keys, and read dirty blocks in LBA order. Although each read =
requests
>>>  are not completed in issue order, there is no check-wait-woken loop =
so
>>>  that the dirty blocks are issued in a small time range and they can =
be
>>>  ordered by I/O schedulers efficiently.
>>>=20
>>> - Read more dirty keys when frontend I/O is idle
>>>  Define WRITEBACKS_IN_PASS (5), MAX_WRITEBACKS_IN_PASS (80) for =
write-
>>>  back dirty keys in each pass, and define WRITESIZE_IN_PASS (5000) =
and
>>>  MAX_WRITESIZE_IN_PASS (80000) for total writeback data size in each
>>>  pass. When frontend I/O is idle, new values MAX_WRITEBACKS_IN_PASS =
and
>>>  MAX_WRITESIZE_IN_PASS are used to read more dirty keys and data =
size
>>>  from cache deice, then more dirty blocks will be written to backend
>>>  device in almost LBA order.
>>>=20
>>> By this effort, when there is frontend I/O, the IOPS and latency =
almost
>>> has no difference observed, identical from previous read_dirty() and
>>> write_dirty() implementation. When frontend I/O is idle, with this =
patch
>>> the average queue size increases from 2.5 to 21, writeback thoughput =
on
>>> backing device increases from 12MiB/s to 20MiB/s.
>>>=20
>>> Writeback throughput increases around 67% when frontend I/O is idle.
>>>=20
>>> Signed-off-by: Coly Li <colyli@fnnas.com>
>>> ---
>>> drivers/md/bcache/bcache.h    |  1 +
>>> drivers/md/bcache/util.h      |  8 ++++
>>> drivers/md/bcache/writeback.c | 82 =
+++++++++++++++++------------------
>>> drivers/md/bcache/writeback.h |  6 ++-
>>> 4 files changed, 52 insertions(+), 45 deletions(-)
>>>=20

[snipped]
>>> static void read_dirty(struct cached_dev *dc)
>>> {
>>>        unsigned int delay =3D 0;
>>> -       struct keybuf_key *next, *keys[MAX_WRITEBACKS_IN_PASS], *w;
>>> -       size_t size;
>>> -       int nk, i;
>>> +       struct keybuf_key *next, *w;
>>>        struct dirty_io *io;
>>>        struct closure cl;
>>> -       uint16_t sequence =3D 0;
>>> +       size_t size;
>>> +       int nk, i;
>>>=20
>>>        BUG_ON(!llist_empty(&dc->writeback_ordering_wait.list));
>>> -       atomic_set(&dc->writeback_sequence_next, sequence);
>>>        closure_init_stack(&cl);
>>>=20
>>>        /*
>>> @@ -495,46 +481,49 @@ static void read_dirty(struct cached_dev *dc)
>>>        while (!kthread_should_stop() &&
>>>               !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
>>>               next) {
>>> +               size_t max_size_in_pass;
>>> +               int max_writebacks_in_pass;
>>> +
>>>                size =3D 0;
>>>                nk =3D 0;
>>> +               reset_heap(&dc->read_dirty_heap);
>>>=20
>>>                do {
>>>                        BUG_ON(ptr_stale(dc->disk.c, &next->key, 0));
>>>=20
>>> +                       if =
(atomic_read(&dc->disk.c->at_max_writeback_rate)) {
>>> +                               max_writebacks_in_pass =3D =
MAX_WRITEBACKS_IN_PASS;
>>> +                               max_size_in_pass =3D =
MAX_WRITESIZE_IN_PASS;
>>> +                       } else {
>>> +                               max_writebacks_in_pass =3D =
WRITEBACKS_IN_PASS;
>>> +                               max_size_in_pass =3D =
WRITESIZE_IN_PASS;
>>> +                       }
>>> +
>>>                        /*
>>>                         * Don't combine too many operations, even if =
they
>>>                         * are all small.
>>>                         */
>>> -                       if (nk >=3D MAX_WRITEBACKS_IN_PASS)
>>> +                       if (nk >=3D max_writebacks_in_pass)
>>>                                break;
>>>=20
>>>                        /*
>>>                         * If the current operation is very large, =
don't
>>>                         * further combine operations.
>>>                         */
>>> -                       if (size >=3D MAX_WRITESIZE_IN_PASS)
>>> +                       if (size >=3D max_size_in_pass)
>>>                                break;
>>>=20
>>> -                       /*
>>> -                        * Operations are only eligible to be =
combined
>>> -                        * if they are contiguous.
>>> -                        *
>>> -                        * TODO: add a heuristic willing to fire a
>>> -                        * certain amount of non-contiguous IO per =
pass,
>>> -                        * so that we can benefit from backing =
device
>>> -                        * command queueing.
>>> -                        */
>>> -                       if ((nk !=3D 0) && =
bkey_cmp(&keys[nk-1]->key,
>>> -                                               =
&START_KEY(&next->key)))
>>> +                       if (!heap_add(&dc->read_dirty_heap, next,
>>> +                                     keybuf_key_cmp))
>>>                                break;
>>=20
>> The bkeys retrieved from the dc->writeback_keys rbtree are in a =
specific order.
>> Can the heap sorting here be omitted?
>=20
> Indeed the keys in dc->writeback_keys are not in a specific order, yes =
they are
> in the order from oldest to newest, but there is *NO* overlap betwen =
any two
> keys in dc->writeback_keys. See RB_INSERT() inside refill_keybuf_fn().
>=20
> Because there is no overlap inside keys of dc->writeback_keys, =
re-order them by
> LBA incremental order won't make trouble here.
>=20

I want to say thank you! I re-read the refill_dirty() implementation, it =
seems in
read_dirty(), it is unnecessary to call bch_keybuf_del(). Let me try =
whethere
there is chance to do more improvement.

Coly Li


