Return-Path: <linux-bcache+bounces-887-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5089FA9043B
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Apr 2025 15:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0023B1907089
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Apr 2025 13:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD001AF0D0;
	Wed, 16 Apr 2025 13:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="BNTHzyaw"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail65.out.titan.email (mail65.out.titan.email [34.235.186.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B9517A304
	for <linux-bcache@vger.kernel.org>; Wed, 16 Apr 2025 13:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.235.186.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744809588; cv=none; b=uTwSxqYIUG9l/RevC0oY1sqD+HmIIOLNt46iUqIkKYdE0Mreci6zkMW5afRtl3VcW0buAdz9rVeRTx0GrQxjuPR4Xj7wD4tY8xofIKQN6TM7wlrwNdK8KFLQWspho9iJKeWAl4qSKhv27Aio+cVU1SGRjJ65EFl8L5Aoem68WBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744809588; c=relaxed/simple;
	bh=Ht6eZtR2dGPmfEGjyCrUq849MUdJ/VDF2qys9jIGd+A=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Bzk1IV2v+SjzHfCcE25KbwXm6jUtcTMESC7g2VZNdt7IiaiVZik/FXj/ahCgQW2B/5EPM0RhloDH4ww8JISmujA1JKb/J8gAgCNqKeEUAs8JxPZ1ke6u2Y2Y4Xzvd2J2ITPkpzxPBH5Tj1fX9LzjvSam81LNx7Xx1l/OYLRrKjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=BNTHzyaw; arc=none smtp.client-ip=34.235.186.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 5A2DB100557;
	Wed, 16 Apr 2025 09:44:28 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=lifJ7vT6eeqRvvZhFHpiRDlW8iBsDGG82BiHQmdN/CY=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=mime-version:message-id:in-reply-to:cc:subject:date:references:to:from:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1744796668; v=1;
	b=BNTHzyawybOY5C6BNyVQq3Q6wmd3PY0NVjGYv93CRrGAinpDcVk82zthfQuB9V0Q6sZc3luO
	eduhvO1OXx1TXSm1Qhf+upq0oTxtgM53vyfLuZoekOOyZPh3/lvhqil5QpPSdGw+qTCJuXV8hZJ
	K62q/Ah+qSWTXZKVoS8oypws=
Received: from smtpclient.apple (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 3D69F100148;
	Wed, 16 Apr 2025 09:44:25 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH 1/1] bcache: process fewer btree nodes in incremental GC
 cycles
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <CAJhEC05LSFsDSKAfY9PPHz2zHYxu2geoZ6NO_umv3v9uJEEyZg@mail.gmail.com>
Date: Wed, 16 Apr 2025 17:44:13 +0800
Cc: Coly Li <colyli@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcache@vger.kernel.org,
 Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F3A62312-F568-499C-BAB4-017CEC11CDB5@coly.li>
References: <20250414224415.77926-1-robertpang@google.com>
 <20250414224415.77926-2-robertpang@google.com>
 <6bqyfgs2oq7fjn5an533yoi23fpttwdoyhrtqku6xm77j6zw45@mmptlxdk2ukm>
 <CAJhEC05LSFsDSKAfY9PPHz2zHYxu2geoZ6NO_umv3v9uJEEyZg@mail.gmail.com>
To: Robert Pang <robertpang@google.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1744796668145905276.20113.3064379065098782367@prod-use1-smtp-out1002.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=fZxXy1QF c=1 sm=1 tr=0 ts=67ff7bfc
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8
	a=p4c8xkjhECDg8DLnpREA:9 a=QEXdDO2ut3YA:10



> 2025=E5=B9=B44=E6=9C=8816=E6=97=A5 01:25=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Thank you for your prompt feedback, Coly.
>=20
> On Mon, Apr 14, 2025 at 7:08=E2=80=AFPM Coly Li <colyli@kernel.org> =
wrote:
>>=20
>> On Mon, Apr 14, 2025 at 03:44:04PM +0800, Robert Pang wrote:
>>> Current incremental GC processes a minimum of 100 btree nodes per =
cycle,
>>> followed by a 100ms sleep. For NVMe cache devices, where the average =
node
>>> processing time is ~1ms, this leads to front-side I/O latency =
potentially
>>> reaching tens or hundreds of milliseconds during GC execution.
>>>=20
>>> This commit resolves this latency issue by reducing the minimum node =
processing
>>> count per cycle to 10 and the inter-cycle sleep duration to 10ms. It =
also
>>> integrates a check of existing GC statistics to re-scale the number =
of nodes
>>> processed per sleep interval when needed, ensuring GC finishes well =
before the
>>> next GC is due.
>>>=20
>>> Signed-off-by: Robert Pang <robertpang@google.com>
>>> ---
>>> drivers/md/bcache/btree.c | 38 =
+++++++++++++++++---------------------
>>> drivers/md/bcache/util.h  |  3 +++
>>> 2 files changed, 20 insertions(+), 21 deletions(-)
>>>=20
>>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>>> index ed40d8600656..093e1edcaa53 100644
>>> --- a/drivers/md/bcache/btree.c
>>> +++ b/drivers/md/bcache/btree.c
>>> @@ -88,11 +88,8 @@
>>>  * Test module load/unload
>>>  */
>>>=20
>>> -#define MAX_NEED_GC          64
>>> -#define MAX_SAVE_PRIO                72
>>=20
>> You may compose another patch for the above changes, to separte them
>> from main idea of this patch.
>=20
> Certainly, Just sent this as a separate patch.
>=20
>>> -#define MAX_GC_TIMES         100
>>> -#define MIN_GC_NODES         100
>>> -#define GC_SLEEP_MS          100
>>> +#define GC_MIN_NODES         10
>>> +#define GC_SLEEP_MS          10
>>>=20
>>> #define PTR_DIRTY_BIT                (((uint64_t) 1 << 36))
>>>=20
>>> @@ -1585,25 +1582,24 @@ static unsigned int =
btree_gc_count_keys(struct btree *b)
>>>=20
>>> static size_t btree_gc_min_nodes(struct cache_set *c)
>>> {
>>> -     size_t min_nodes;
>>> +     size_t min_nodes =3D GC_MIN_NODES;
>>> +     uint64_t gc_max_ms =3D time_stat_average(&c->btree_gc_time, =
frequency, ms) / 2;
>>>=20
>>>      /*
>>> -      * Since incremental GC would stop 100ms when front
>>> -      * side I/O comes, so when there are many btree nodes,
>>> -      * if GC only processes constant (100) nodes each time,
>>> -      * GC would last a long time, and the front side I/Os
>>> -      * would run out of the buckets (since no new bucket
>>> -      * can be allocated during GC), and be blocked again.
>>> -      * So GC should not process constant nodes, but varied
>>> -      * nodes according to the number of btree nodes, which
>>> -      * realized by dividing GC into constant(100) times,
>>> -      * so when there are many btree nodes, GC can process
>>> -      * more nodes each time, otherwise, GC will process less
>>> -      * nodes each time (but no less than MIN_GC_NODES)
>>> +      * The incremental garbage collector operates by processing
>>> +      * GC_MIN_NODES at a time, pausing for GC_SLEEP_MS between
>>> +      * each interval. If historical garbage collection statistics
>>> +      * (btree_gc_time) is available, the maximum allowable GC
>>> +      * duration is set to half of this observed frequency. To
>>> +      * prevent exceeding this maximum duration, the number of
>>> +      * nodes processed in the current step may be increased if
>>> +      * the projected completion time based on the current pace
>>> +      * extends beyond the allowed limit. This ensures timely GC
>>> +      * completion before the next GC is due.
>>>       */
>>> -     min_nodes =3D c->gc_stats.nodes / MAX_GC_TIMES;
>>> -     if (min_nodes < MIN_GC_NODES)
>>> -             min_nodes =3D MIN_GC_NODES;
>>> +     if ((gc_max_ms >=3D GC_SLEEP_MS) &&
>>> +         (GC_SLEEP_MS * (c->gc_stats.nodes / min_nodes)) > =
gc_max_ms)
>>> +             min_nodes =3D c->gc_stats.nodes / (gc_max_ms / =
GC_SLEEP_MS);
>>>=20
>>=20
>> Is it possible that gc_max_ms becomes 0?
>=20
> Yes, gc_max_ms can be 0 initially when the cache is set up and stats =
are not
> collected yet. In that case, the check "gc_max_ms >=3D GC_SLEEP_MS" =
fails and
> we process at the default rate of 10 nodes per cycle.
>=20
> Importantly, this same check also serves to prevent a division-by-zero =
error
> when the number of nodes is re-scaled using the following calculation:
>=20
>  min_nodes =3D c->gc_stats.nodes / (gc_max_ms / GC_SLEEP_MS);
>=20
>>=20

Thanks. So the code itself I don=E2=80=99t have more comment, just look =
forward to more testing and benchmark results.

Thanks.

Coly Li




>>>      return min_nodes;
>>> }
>>> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
>>> index 539454d8e2d0..21a370f444b7 100644
>>> --- a/drivers/md/bcache/util.h
>>> +++ b/drivers/md/bcache/util.h
>>> @@ -305,6 +305,9 @@ static inline unsigned int local_clock_us(void)
>>> #define NSEC_PER_ms                  NSEC_PER_MSEC
>>> #define NSEC_PER_sec                 NSEC_PER_SEC
>>>=20
>>> +#define time_stat_average(stats, stat, units)                       =
         \
>>> +     div_u64((stats)->average_ ## stat >> 8, NSEC_PER_ ## units)
>>> +
>>=20
>> Could you please add a few code comments here to explain what does
>> time_stat_average() do?
>=20
> Will add the code comments with explanation in a new version promptly.
>=20
>>=20
>> Thanks in advance.
>>=20
>>> #define __print_time_stat(stats, name, stat, units)                  =
\
>>>      sysfs_print(name ## _ ## stat ## _ ## units,                    =
\
>>>                  div_u64((stats)->stat >> 8, NSEC_PER_ ## units))
>>> --
>>> 2.49.0.604.gff1f9ca942-goog
>>>=20
>>=20
>> --
>> Coly Li



