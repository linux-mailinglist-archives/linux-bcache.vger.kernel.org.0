Return-Path: <linux-bcache+bounces-897-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD20AA9131C
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 07:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A96718832BD
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 05:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBEF1E25EB;
	Thu, 17 Apr 2025 05:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XL+Rvxdl"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC811DD526
	for <linux-bcache@vger.kernel.org>; Thu, 17 Apr 2025 05:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744868665; cv=none; b=ImWVTWLR26w4xMYoOh4g0Q3usUyK8Qazf3vZG3yxTjbZfhqYqO9ds94JCiVj8roeQdTnSfm6ds0WvlPoit+u4V2QHvO6W1+LlfrMcFkfmXcHolIUJ6QVMtuVavv7JXQFt1GiHt6ADVPJdGDrx7U+ggtbX5sysjc9xu9qrt5ury4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744868665; c=relaxed/simple;
	bh=TiHjlkGxb3/A5beS5MR/47bbtuRyeboSgX+Nd5eQWoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c7t266X7BHzxblXET6J3ArlTe57hE4r5GOAuWuk2e8Vs8Du2b2LMZsDgvDXXel7RlFk5A9qb0RtJvzlX68d+KadLDUKKfFR3IITSl7pz/lkbIoX8sXswsW44OMM9PS0AwBOBx58EwSv9pT6a1n626ftXnpTMb86asLNZPSMkK6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XL+Rvxdl; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso4788a12.1
        for <linux-bcache@vger.kernel.org>; Wed, 16 Apr 2025 22:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744868661; x=1745473461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+N5ygn+dzpGF9Urh6RhjqZTPbRmevaFSc8XohGGHIo=;
        b=XL+Rvxdl3FmYUjwZTdV3vdX5nyFbZwBSaPi5Pdas+AbmCc5OkVSSJ9h9hivuZm55Ie
         sPBc/0MbzJAhTi9+strBroGN4SZmeIjAPeTLQhU1nfMEoRdi5vEjUtFqJtOV2Si5utN5
         cXXoryEmMSYwNoUNuZUu9NF7rmlngJItKvJSKG3BLMyL2WToT7lwyiPHvPdNo89h22G8
         P9xSxJj6s/4bENNNodpgKdScJEqOClwwpOOo5tehSWqdS54OSKgmHdFrNDLOalMMTA8B
         LhlAzp3abNZ/vABgzEH9RoXUU9O1yQBUX/e5DkyvvAiLvfcyrFKERCvsltKl/l2XbSvZ
         5kZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744868661; x=1745473461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P+N5ygn+dzpGF9Urh6RhjqZTPbRmevaFSc8XohGGHIo=;
        b=m+gt6vLneWk5aqA593+BsjeXiIWhFEO/kp3UVtD5hpL/KUfU9E01k0gPjG/Q5BIQFv
         iE9YcuUYBIfRwd5jhQ8mX8rgv+Eo6MWCIj6DzQV1NDh6SFCneLmn1NvnevVF1jOZQ4lM
         RLv4d+y8QXoRxh+SSxp0tkdk4tIY+63L2ILa/xVJgO0gVPYOlkZlMeDvN5cXH2A2rFNz
         rgNkcD9OsgIhVQmoeFv93tlRNxp/EnYFJxQY9uMY+Ou9WGTKwip7YJtcV2T3dmzRKfQd
         FJWUWkw6qhpzyk8bapWCuJ8/ih2NSIDk9CNed8cuNCS0AwjV4H7SpZgtIJvowMH8KAUf
         pGtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUU4+35RD2ZkUfI7duFsKR1hF4zTktRBRByj0izH0CdMQl+kVhO2VWCbo0ZACoWoc0+kZcPj+nlb6omUMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxhLHSPLYyXrGhFyBS7Uv/8JVuOCbV8PufwF6O+O7+NTrmre59
	9hX3ArOiiyOI+zMyETkiKD1dGpSpMd3GoLsK3T3iBMo394EyktCszEotes7IIbrD9okRrmWNtEB
	l+zkUaZkefqUakE0t+oQHuECPlSCd6hdGQLtS
X-Gm-Gg: ASbGncvbwO8mZiuyd7esDLbsb90rvNGlGXNrCB7YalsRoulzthApZ60GfKTWRC3HV1d
	uy/T2QGLgMitrROCSgKOZjgZGD2GC+Uc/3JEoZg0mDPrPvIODgbLFxUXY9xCDa3vf2jrS00cmn7
	gwD6rrzNTnrcFz9DKX9k/Z
X-Google-Smtp-Source: AGHT+IFwUXSYfRZVa/lEYN2TAdxdlE9YEm0mGwc4DSzTxKxGsLl86HE3jxS12QOhOdAfSG/uOewcPGntC+RhTDl13WU=
X-Received: by 2002:aa7:d98c:0:b0:5ed:f521:e06c with SMTP id
 4fb4d7f45d1cf-5f4d2927079mr34547a12.7.1744868660944; Wed, 16 Apr 2025
 22:44:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414224415.77926-1-robertpang@google.com> <20250414224415.77926-2-robertpang@google.com>
 <6bqyfgs2oq7fjn5an533yoi23fpttwdoyhrtqku6xm77j6zw45@mmptlxdk2ukm>
 <CAJhEC05LSFsDSKAfY9PPHz2zHYxu2geoZ6NO_umv3v9uJEEyZg@mail.gmail.com> <F3A62312-F568-499C-BAB4-017CEC11CDB5@coly.li>
In-Reply-To: <F3A62312-F568-499C-BAB4-017CEC11CDB5@coly.li>
From: Robert Pang <robertpang@google.com>
Date: Wed, 16 Apr 2025 22:44:09 -0700
X-Gm-Features: ATxdqUGMJDgddgBkKHf_5AS3CLp6831HHLRstECoBH8CL9yvxxG3UIs2zqcPLrc
Message-ID: <CAJhEC06uVCLfKMtMWKE88g_+4+PN1TinKWwKUUiRNgBECBWkJg@mail.gmail.com>
Subject: Re: [PATCH 1/1] bcache: process fewer btree nodes in incremental GC cycles
To: Coly Li <i@coly.li>
Cc: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for the positive feedback and your review.

Regarding testing, the 24-hour fio test is currently underway on a 6TB SSD
with an iodepth set to 128. I will provide an update with the findings upon
its conclusion.

On Wed, Apr 16, 2025 at 2:44=E2=80=AFAM Coly Li <i@coly.li> wrote:
>
>
>
> > 2025=E5=B9=B44=E6=9C=8816=E6=97=A5 01:25=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Thank you for your prompt feedback, Coly.
> >
> > On Mon, Apr 14, 2025 at 7:08=E2=80=AFPM Coly Li <colyli@kernel.org> wro=
te:
> >>
> >> On Mon, Apr 14, 2025 at 03:44:04PM +0800, Robert Pang wrote:
> >>> Current incremental GC processes a minimum of 100 btree nodes per cyc=
le,
> >>> followed by a 100ms sleep. For NVMe cache devices, where the average =
node
> >>> processing time is ~1ms, this leads to front-side I/O latency potenti=
ally
> >>> reaching tens or hundreds of milliseconds during GC execution.
> >>>
> >>> This commit resolves this latency issue by reducing the minimum node =
processing
> >>> count per cycle to 10 and the inter-cycle sleep duration to 10ms. It =
also
> >>> integrates a check of existing GC statistics to re-scale the number o=
f nodes
> >>> processed per sleep interval when needed, ensuring GC finishes well b=
efore the
> >>> next GC is due.
> >>>
> >>> Signed-off-by: Robert Pang <robertpang@google.com>
> >>> ---
> >>> drivers/md/bcache/btree.c | 38 +++++++++++++++++---------------------
> >>> drivers/md/bcache/util.h  |  3 +++
> >>> 2 files changed, 20 insertions(+), 21 deletions(-)
> >>>
> >>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> >>> index ed40d8600656..093e1edcaa53 100644
> >>> --- a/drivers/md/bcache/btree.c
> >>> +++ b/drivers/md/bcache/btree.c
> >>> @@ -88,11 +88,8 @@
> >>>  * Test module load/unload
> >>>  */
> >>>
> >>> -#define MAX_NEED_GC          64
> >>> -#define MAX_SAVE_PRIO                72
> >>
> >> You may compose another patch for the above changes, to separte them
> >> from main idea of this patch.
> >
> > Certainly, Just sent this as a separate patch.
> >
> >>> -#define MAX_GC_TIMES         100
> >>> -#define MIN_GC_NODES         100
> >>> -#define GC_SLEEP_MS          100
> >>> +#define GC_MIN_NODES         10
> >>> +#define GC_SLEEP_MS          10
> >>>
> >>> #define PTR_DIRTY_BIT                (((uint64_t) 1 << 36))
> >>>
> >>> @@ -1585,25 +1582,24 @@ static unsigned int btree_gc_count_keys(struc=
t btree *b)
> >>>
> >>> static size_t btree_gc_min_nodes(struct cache_set *c)
> >>> {
> >>> -     size_t min_nodes;
> >>> +     size_t min_nodes =3D GC_MIN_NODES;
> >>> +     uint64_t gc_max_ms =3D time_stat_average(&c->btree_gc_time, fre=
quency, ms) / 2;
> >>>
> >>>      /*
> >>> -      * Since incremental GC would stop 100ms when front
> >>> -      * side I/O comes, so when there are many btree nodes,
> >>> -      * if GC only processes constant (100) nodes each time,
> >>> -      * GC would last a long time, and the front side I/Os
> >>> -      * would run out of the buckets (since no new bucket
> >>> -      * can be allocated during GC), and be blocked again.
> >>> -      * So GC should not process constant nodes, but varied
> >>> -      * nodes according to the number of btree nodes, which
> >>> -      * realized by dividing GC into constant(100) times,
> >>> -      * so when there are many btree nodes, GC can process
> >>> -      * more nodes each time, otherwise, GC will process less
> >>> -      * nodes each time (but no less than MIN_GC_NODES)
> >>> +      * The incremental garbage collector operates by processing
> >>> +      * GC_MIN_NODES at a time, pausing for GC_SLEEP_MS between
> >>> +      * each interval. If historical garbage collection statistics
> >>> +      * (btree_gc_time) is available, the maximum allowable GC
> >>> +      * duration is set to half of this observed frequency. To
> >>> +      * prevent exceeding this maximum duration, the number of
> >>> +      * nodes processed in the current step may be increased if
> >>> +      * the projected completion time based on the current pace
> >>> +      * extends beyond the allowed limit. This ensures timely GC
> >>> +      * completion before the next GC is due.
> >>>       */
> >>> -     min_nodes =3D c->gc_stats.nodes / MAX_GC_TIMES;
> >>> -     if (min_nodes < MIN_GC_NODES)
> >>> -             min_nodes =3D MIN_GC_NODES;
> >>> +     if ((gc_max_ms >=3D GC_SLEEP_MS) &&
> >>> +         (GC_SLEEP_MS * (c->gc_stats.nodes / min_nodes)) > gc_max_ms=
)
> >>> +             min_nodes =3D c->gc_stats.nodes / (gc_max_ms / GC_SLEEP=
_MS);
> >>>
> >>
> >> Is it possible that gc_max_ms becomes 0?
> >
> > Yes, gc_max_ms can be 0 initially when the cache is set up and stats ar=
e not
> > collected yet. In that case, the check "gc_max_ms >=3D GC_SLEEP_MS" fai=
ls and
> > we process at the default rate of 10 nodes per cycle.
> >
> > Importantly, this same check also serves to prevent a division-by-zero =
error
> > when the number of nodes is re-scaled using the following calculation:
> >
> >  min_nodes =3D c->gc_stats.nodes / (gc_max_ms / GC_SLEEP_MS);
> >
> >>
>
> Thanks. So the code itself I don=E2=80=99t have more comment, just look f=
orward to more testing and benchmark results.
>
> Thanks.
>
> Coly Li
>
>
>
>
> >>>      return min_nodes;
> >>> }
> >>> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> >>> index 539454d8e2d0..21a370f444b7 100644
> >>> --- a/drivers/md/bcache/util.h
> >>> +++ b/drivers/md/bcache/util.h
> >>> @@ -305,6 +305,9 @@ static inline unsigned int local_clock_us(void)
> >>> #define NSEC_PER_ms                  NSEC_PER_MSEC
> >>> #define NSEC_PER_sec                 NSEC_PER_SEC
> >>>
> >>> +#define time_stat_average(stats, stat, units)                       =
         \
> >>> +     div_u64((stats)->average_ ## stat >> 8, NSEC_PER_ ## units)
> >>> +
> >>
> >> Could you please add a few code comments here to explain what does
> >> time_stat_average() do?
> >
> > Will add the code comments with explanation in a new version promptly.
> >
> >>
> >> Thanks in advance.
> >>
> >>> #define __print_time_stat(stats, name, stat, units)                  =
\
> >>>      sysfs_print(name ## _ ## stat ## _ ## units,                    =
\
> >>>                  div_u64((stats)->stat >> 8, NSEC_PER_ ## units))
> >>> --
> >>> 2.49.0.604.gff1f9ca942-goog
> >>>
> >>
> >> --
> >> Coly Li
>
>

