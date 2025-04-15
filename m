Return-Path: <linux-bcache+bounces-880-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31B6FA8A558
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 19:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F82C188E445
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 17:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4743421C9E9;
	Tue, 15 Apr 2025 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G2qr882z"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9FF1BC2A
	for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744737969; cv=none; b=LKcD+zomr6f4npPkOdOx3QksdYnlJ8+YxDGzOhHogl4cGQKSjI74TE6Bmh/XNg5ZyYfy4tNbDAse97yYiG8T8kKUsZ6r8wbMRe0X4n8jYc3QThWWyeoeCh++7n6t04gdiATCe2Ist95DX2OcSE7Rw99bBvIVh/FYYf520/6hY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744737969; c=relaxed/simple;
	bh=fXcsLXHHsRWhGOpGAJk5xHWJ15mSE8pz/Ufz6pIlR9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O9jDKaZnIa1BMi2UMscCqSdW9D6vMK03eT+onsHRSuk9jsd0RUYjczVui+8rgMdO8/P+BX7qUx3j84gwq+2/c3ZDBcazGURAPGIlRCwXEfZ1010dfUsH5HZ4OchXPQI6/47sK43CpLTsPhK4rxPq8sGYOmfjuWLBt9tkE3/SPJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G2qr882z; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e5cbd8b19bso919a12.1
        for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 10:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744737965; x=1745342765; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bV8nCeNhwFfuaGG/T6YdyIGF6o0I4I0C9SuQOxnyW6g=;
        b=G2qr882zIpqF3TPPXqJyxpl21DwPRLOlE6AdO4La14sBr9Q8euVT66JuFoQH14PGka
         YWtCKu2Yk1wddsHD3MUeO8ipL91EcH6HMBMiX730xKG+1PWV6Dd9dsQSY5SnXX8LI7bz
         6nf36Blh/UwZbD0QduCqnF7e6jIjrN0dGG3kxUudb1k30Grnjgy0e9uvo7yjkc2QmPh6
         WuGMbDkFaIokwd5QzbR6iblhQb1vUshrGBBai/Nl5XPB7zzHx6HWeWIOeWDyBgG9IgZI
         I6wrUQoLRTfT2l9elgONkKODJ5LUtPzgn3zqHaJFrVJxFEwlLQQDBRPU+oPAO2N5Ua5v
         oXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744737965; x=1745342765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bV8nCeNhwFfuaGG/T6YdyIGF6o0I4I0C9SuQOxnyW6g=;
        b=O8bMNGeqbuA1TyDgm8RWaX8fBJ7Cg9CYPtbmgWVjuxKr3CH0NciKfziQTHk9nHtFfW
         1R7XWn8pHmNtw9fDTxw9a4njnNa4IxVReqDX5b4VNL8KaMqlX8ukjj0RLp/CP1e4Wbup
         Yw9tWUMnU7BfRyt7mF6yo+nKyx6OmhRfZELH2HQe/QEljX9KFGRZOyeYYo8It8fWiE1d
         m1f2PQkfqiDRJidq5F8tUZ18U83M88Gtd86uMWIIihWjN6m/u1ZXANAMatLY+ykCbdjL
         8nlLQU1IYDTK8tdzRMowlnaxU0XO8a0QHPVGunlBq42zHhaNzXSa6WZEKEwkGePJWUbK
         3HvA==
X-Forwarded-Encrypted: i=1; AJvYcCWqGsOli5pmHBcq6yuN0y7DdlpQwwIIhWRKl7MyVRbfrbqHLROtAT8LvSvtVIBrYbbZZrgwnEjgZjljAis=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQB1WboU3Axsgt5HziJpIkiOTP2/XnMuc1o6emCxhs7sGg+LUt
	YSC0fiZg4xyY/kocPYWwUDrysHpRVmwsQEEs2t+KESN8TOZjnKB3//5E2KK2YmgUNW3i4OZwfTF
	WA16sqoV5vSzKEMFwhAlFt/1Iu6xYkF6apjM8
X-Gm-Gg: ASbGncu7cCenm1ygSHSB7teplmW9FHsNDfp3qRrvFAImr+c57Qww8VMKloUpVqiInn8
	qgUn6DveyvkA50VSLfUDsGRpDQRGN6Q6ifEo1vjP/nr04SypmJd+yNNs7wWcFHDucejhpuFoI6K
	MaWc+nlpqH0ByT1anYfghYsitAfR9yB94MLhinruMrKxWNt7jsT0Ce
X-Google-Smtp-Source: AGHT+IF13ufQj6m5na4L8NFYw2WwCQI9chCWuNs+T7jqvKMaRiXn8iUDhcTcdegbVtQiyR47scuMQf03uyeLAGJNxyk=
X-Received: by 2002:a50:cd93:0:b0:5dc:5ae8:7e1 with SMTP id
 4fb4d7f45d1cf-5f461609935mr116877a12.6.1744737965022; Tue, 15 Apr 2025
 10:26:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414224415.77926-1-robertpang@google.com> <20250414224415.77926-2-robertpang@google.com>
 <6bqyfgs2oq7fjn5an533yoi23fpttwdoyhrtqku6xm77j6zw45@mmptlxdk2ukm>
In-Reply-To: <6bqyfgs2oq7fjn5an533yoi23fpttwdoyhrtqku6xm77j6zw45@mmptlxdk2ukm>
From: Robert Pang <robertpang@google.com>
Date: Tue, 15 Apr 2025 10:25:53 -0700
X-Gm-Features: ATxdqUGQqxxrOpfhkGN1yx5Ez7OvbpKHYFiVvWGum5iGcZtBhrRW29IUaARi_eQ
Message-ID: <CAJhEC05LSFsDSKAfY9PPHz2zHYxu2geoZ6NO_umv3v9uJEEyZg@mail.gmail.com>
Subject: Re: [PATCH 1/1] bcache: process fewer btree nodes in incremental GC cycles
To: Coly Li <colyli@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcache@vger.kernel.org, 
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your prompt feedback, Coly.

On Mon, Apr 14, 2025 at 7:08=E2=80=AFPM Coly Li <colyli@kernel.org> wrote:
>
> On Mon, Apr 14, 2025 at 03:44:04PM +0800, Robert Pang wrote:
> > Current incremental GC processes a minimum of 100 btree nodes per cycle=
,
> > followed by a 100ms sleep. For NVMe cache devices, where the average no=
de
> > processing time is ~1ms, this leads to front-side I/O latency potential=
ly
> > reaching tens or hundreds of milliseconds during GC execution.
> >
> > This commit resolves this latency issue by reducing the minimum node pr=
ocessing
> > count per cycle to 10 and the inter-cycle sleep duration to 10ms. It al=
so
> > integrates a check of existing GC statistics to re-scale the number of =
nodes
> > processed per sleep interval when needed, ensuring GC finishes well bef=
ore the
> > next GC is due.
> >
> > Signed-off-by: Robert Pang <robertpang@google.com>
> > ---
> >  drivers/md/bcache/btree.c | 38 +++++++++++++++++---------------------
> >  drivers/md/bcache/util.h  |  3 +++
> >  2 files changed, 20 insertions(+), 21 deletions(-)
> >
> > diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > index ed40d8600656..093e1edcaa53 100644
> > --- a/drivers/md/bcache/btree.c
> > +++ b/drivers/md/bcache/btree.c
> > @@ -88,11 +88,8 @@
> >   * Test module load/unload
> >   */
> >
> > -#define MAX_NEED_GC          64
> > -#define MAX_SAVE_PRIO                72
>
> You may compose another patch for the above changes, to separte them
> from main idea of this patch.

Certainly, Just sent this as a separate patch.

> > -#define MAX_GC_TIMES         100
> > -#define MIN_GC_NODES         100
> > -#define GC_SLEEP_MS          100
> > +#define GC_MIN_NODES         10
> > +#define GC_SLEEP_MS          10
> >
> >  #define PTR_DIRTY_BIT                (((uint64_t) 1 << 36))
> >
> > @@ -1585,25 +1582,24 @@ static unsigned int btree_gc_count_keys(struct =
btree *b)
> >
> >  static size_t btree_gc_min_nodes(struct cache_set *c)
> >  {
> > -     size_t min_nodes;
> > +     size_t min_nodes =3D GC_MIN_NODES;
> > +     uint64_t gc_max_ms =3D time_stat_average(&c->btree_gc_time, frequ=
ency, ms) / 2;
> >
> >       /*
> > -      * Since incremental GC would stop 100ms when front
> > -      * side I/O comes, so when there are many btree nodes,
> > -      * if GC only processes constant (100) nodes each time,
> > -      * GC would last a long time, and the front side I/Os
> > -      * would run out of the buckets (since no new bucket
> > -      * can be allocated during GC), and be blocked again.
> > -      * So GC should not process constant nodes, but varied
> > -      * nodes according to the number of btree nodes, which
> > -      * realized by dividing GC into constant(100) times,
> > -      * so when there are many btree nodes, GC can process
> > -      * more nodes each time, otherwise, GC will process less
> > -      * nodes each time (but no less than MIN_GC_NODES)
> > +      * The incremental garbage collector operates by processing
> > +      * GC_MIN_NODES at a time, pausing for GC_SLEEP_MS between
> > +      * each interval. If historical garbage collection statistics
> > +      * (btree_gc_time) is available, the maximum allowable GC
> > +      * duration is set to half of this observed frequency. To
> > +      * prevent exceeding this maximum duration, the number of
> > +      * nodes processed in the current step may be increased if
> > +      * the projected completion time based on the current pace
> > +      * extends beyond the allowed limit. This ensures timely GC
> > +      * completion before the next GC is due.
> >        */
> > -     min_nodes =3D c->gc_stats.nodes / MAX_GC_TIMES;
> > -     if (min_nodes < MIN_GC_NODES)
> > -             min_nodes =3D MIN_GC_NODES;
> > +     if ((gc_max_ms >=3D GC_SLEEP_MS) &&
> > +         (GC_SLEEP_MS * (c->gc_stats.nodes / min_nodes)) > gc_max_ms)
> > +             min_nodes =3D c->gc_stats.nodes / (gc_max_ms / GC_SLEEP_M=
S);
> >
>
> Is it possible that gc_max_ms becomes 0?

Yes, gc_max_ms can be 0 initially when the cache is set up and stats are no=
t
collected yet. In that case, the check "gc_max_ms >=3D GC_SLEEP_MS" fails a=
nd
we process at the default rate of 10 nodes per cycle.

Importantly, this same check also serves to prevent a division-by-zero erro=
r
when the number of nodes is re-scaled using the following calculation:

  min_nodes =3D c->gc_stats.nodes / (gc_max_ms / GC_SLEEP_MS);

>
> >       return min_nodes;
> >  }
> > diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> > index 539454d8e2d0..21a370f444b7 100644
> > --- a/drivers/md/bcache/util.h
> > +++ b/drivers/md/bcache/util.h
> > @@ -305,6 +305,9 @@ static inline unsigned int local_clock_us(void)
> >  #define NSEC_PER_ms                  NSEC_PER_MSEC
> >  #define NSEC_PER_sec                 NSEC_PER_SEC
> >
> > +#define time_stat_average(stats, stat, units)                         =
       \
> > +     div_u64((stats)->average_ ## stat >> 8, NSEC_PER_ ## units)
> > +
>
> Could you please add a few code comments here to explain what does
> time_stat_average() do?

Will add the code comments with explanation in a new version promptly.

>
> Thanks in advance.
>
> >  #define __print_time_stat(stats, name, stat, units)                  \
> >       sysfs_print(name ## _ ## stat ## _ ## units,                    \
> >                   div_u64((stats)->stat >> 8, NSEC_PER_ ## units))
> > --
> > 2.49.0.604.gff1f9ca942-goog
> >
>
> --
> Coly Li

