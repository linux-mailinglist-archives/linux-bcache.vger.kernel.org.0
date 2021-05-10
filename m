Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AC23798C2
	for <lists+linux-bcache@lfdr.de>; Mon, 10 May 2021 23:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhEJVHU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 10 May 2021 17:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhEJVHU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 May 2021 17:07:20 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB8FC061574
        for <linux-bcache@vger.kernel.org>; Mon, 10 May 2021 14:06:13 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id v8so5643675uau.12
        for <linux-bcache@vger.kernel.org>; Mon, 10 May 2021 14:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZYNRko0xqhmCOFLFgKPjTdv7koAtC9ON50H/HhEf/MQ=;
        b=JAi1tMGV2SSVB/3IWUfAT6VFUTpt29PcQ/VZdp5b38Q/eqeha0XOcHFuU77Oq/cDjf
         Hxp57xlPYlXc5X7tCcxe6+FG5WMskDRJJPVEoBPN+NXw7smmDzktsPIlYzUxUm1fm1gH
         DfOr1OZ/aRlmWb9ZAQb8dKKRLv6MYehCdUbPI52nUK2zdjmKxYjvAayf0I46udMB4kMH
         8fE7y1GLFaFjWMUHx3cAkBakuLrzoJGFs1rBTTNLPiZkAvkUjAwVShZcsYSD9dDqYZjV
         8Q4NEredfNEbwEOQgy0uES/tz3FXw3HGAakIKZrp8O2LStXjNioyZj/QIzBOs+QVkE8b
         joWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZYNRko0xqhmCOFLFgKPjTdv7koAtC9ON50H/HhEf/MQ=;
        b=HlnWFbX52qGx13c3IeNm24qzmhi62il70dggJMi+yD7w22KV/Jnlzilj3acD8WjkIk
         N8e2Q3RzwPuS+T9Hndr+saVr3mLM2wuEg0qBVxsC76XcJqdsGGPkxCa9eShbHwgubEdq
         Ar4ZLDSTKlw5Ke/DG9mn1URfpdorZZ6xZgdVqBDn3pmqSNhJRERL0/jpTkCaa46YiBJB
         rhw6lgtyHnoIYdre4l8BnAzPl4Lekylo9RpKFq9q7fu28Gtks67LMtdeEw8FFq81bfHn
         NbbXRQ4AyxEv9xns+4MAiHBv+gUeGr9+er3nH7mUEe8AeAJB1mDirMtKDNT7A37+1hFt
         usfA==
X-Gm-Message-State: AOAM53085mctLbCzdJv6V7dzH32OmAi8S95CPnOdt4UpU1ApxTse0R1d
        bNNDzxRmmR3hGt5SU3JXz0z9nGscpzqvwLQKPfXwGij14A/sQw==
X-Google-Smtp-Source: ABdhPJzKJd6PAYHn66CGFuTmUJxUKQVQ//rRdjXUeC/DQQRz+7D5rdvvW8Zoyz8yMImpM9RnIUxcL8wPdQzkuYAEXT0=
X-Received: by 2002:ab0:5a61:: with SMTP id m30mr21468530uad.125.1620680772855;
 Mon, 10 May 2021 14:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAH6h+hc2quJhhBindQwQdK5pfsJRZWk5tX95RT3U_shuN1D=eQ@mail.gmail.com>
 <d616e7c1-2406-472f-0653-39612250c2f0@suse.de>
In-Reply-To: <d616e7c1-2406-472f-0653-39612250c2f0@suse.de>
From:   Marc Smith <msmith626@gmail.com>
Date:   Mon, 10 May 2021 17:06:01 -0400
Message-ID: <CAH6h+hfXoRdsTQZJ-y2zAkCwcQiBN_fZtEuZdy3yCKoXRzpeVA@mail.gmail.com>
Subject: Re: [PATCH v2] RFC - Write Bypass Race Bug
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, May 6, 2021 at 12:09 AM Coly Li <colyli@suse.de> wrote:
>
> On 4/30/21 10:44 PM, Marc Smith wrote:
> > The problem:
> > If an inflight backing WRITE operation for a block is performed that
> > meets the criteria for bypassing the cache and that takes a long time
> > to complete, a READ operation for the same block may be fully
> > processed in the interim that populates the cache with the device
> > content from before the inflight WRITE. When the inflight WRITE
> > finally completes, since it was marked for bypass, the cache is not
> > subsequently updated, and the stale data populated by the READ request
> > remains in cache. While there is code in bcache for invalidating the
> > cache when a bypassed WRITE is performed, this is done prior to
> > issuing the backing I/O so it does not help.
> >
> > The proposed fix:
> > Add two new lists to the cached_dev structure to track inflight
> > "bypass" write requests and inflight read requests that have have
> > missed cache. These are called "inflight_bypass_write_list" and
> > "inflight_read_list", respectively, and are protected by a spinlock
> > called the "inflight_lock"
> >
> > When a WRITE is bypassing the cache, check whether there is an
> > overlapping inflight read. If so, set bypass = false to essentially
> > convert the bypass write into a writethrough write. Otherwise, if
> > there is no overlapping inflight read, then add the "search" structure
> > to the inflight bypass write list.
>
> Hi Marc,
>
> Could you please explain a bit more why the above thing is necessary ?
> Please help me to understand your idea more clear :-)
>

As stated previously, the race condition involves two requests attempting
I/O on the same block. One is a bypass write and the other is a normal
read that misses the cache.

The simplest form of the race is the following:

1.  BYPASS WRITER starts processing bcache request
2.  BYPASS WRITER invalidates block in the cache
3.  NORMAL READER starts processing bcache request
4.  NORMAL READER misses cache, issues READ request to backing device
5.  NORMAL READER processes completion of backing dev request
6.  NORMAL READER populates cache with stale data
7.  NORMAL READER completes
8.  BYPASS WRITER issues WRITE request to backing device
9.  BYPASS WRITER processes completion of backing dev request
10. BYPASS WRITER completes

An approach to avoiding the race is to add the following steps:

1.5 BYPASS WRITER adds the sector range to a data structure that holds
    inflight writes. (As currently coded, this data structure is an
    interval tree.)

5.5 NORMAL READER checks the data structure to see if there are any
    inflight bypass writers having overlapping sectors. If so, skip
    step 6.

9.5 BYPASS WRITER removes sector range added in step 1.5

If this were the only order of operations for the race, then the 3 added
steps would be sufficient and only inflight BYPASS WRITES would need
to be tracked.

However, consider the following ordering with new steps above added:

1.  NORMAL READER starts processing bcache request
2.  NORMAL READER misses cache, issues READ request to backing device
3.  NORMAL READER processes completion of backing dev request
4.  NORMAL READER checks the data structure to see if there are any
    inflight bypass writers having overlapping sectors. None are found.
5.  BYPASS WRITER starts processing bcache request
6.  BYPASS WRITER adds the sector range to a data structure that holds
    inflight writes.
7.  BYPASS WRITER invalidates block in the cache
8.  BYPASS WRITER issues WRITE request to backing device
9 . NORMAL READER populates cache with stale data
10. NORMAL READER completes
11. BYPASS WRITER processes completion of backing dev request
12. BYPASS WRITER removes sector range added in step 6.
13. BYPASS WRITER completes

With this order of operations, the added steps don't solve the problem
as stale data is added in step #9 and never corrected.

So to cover both scenarios (and potentially others), both inflight bypass
WRITEs and normal READs are tracked. If a BYPASS WRITE is being performed,
it checks for an inflight overlapping read. If one exists, the BYPASS
WRITE coverts itself to a WRITETHROUGH, which essentially "neutralizes" it
from the race. If, however, there are no overlapping READs, it adds itself
to a tracking data structure. When a normal read is issued that misses
the cache, a check is made for an inflight overlapping BYPASS WRITE. If
one exists, the READ sets the "do_not_cache" flag which neutralizes it
from the race. If, however, there are no inflight overlapping BYPASS
WRITEs, the sector range is added to the data structure holding
inflight reads.

This effectively adds/modifies the following steps:

1.5 NORMAL READER adds its sector range to a data structure that holds
    inflight writes.

5.5 BYPASS WRITER checks for the data structure to see if there is an
    inflight overlapping READ. There is one! So it coverts itself to
    a WRITETHROUGH write.

8.  [WRITETHROUGH] WRITER issues WRITE request to BOTH the cache
    and the backing device. A writethrough racing with a reader (step 9)
    is already correctly handled by bcache (I think.)

9.5 NORMAL READER removes the sector range added in step 1.5

In summary, when a BYPASS WRITE is racing with a normal READ,
one of them needs to take evasive maneuvers to avoid corruption. The
BYPASS WRITE can convert itself to a WRITETHROUGH WRITE or the READ
can skip populating the cache. To handle all order of operations, it
appears that support for both are needed depending on whether the
BYPASS WRITE or normal READ arrives first. Therefore, both BYPASS WRITES
and normal READS need to be tracked.


> >
> > When a READ misses cache, check whether there is an overlapping
> > inflight write. If so, set a new flag in the search structure called
> > "do_not_cache" which causes cache population to be skipped after the
> > backing I/O completes. Otherwise, if there is no overlapping inflight
> > write, then add the "search" structure to the inflight read list.
> >
> > The rest of the changes are to add a new stat called
> > "bypass_cache_insert_races" to track how many times the race was
> > encountered. Example:
> > cat /sys/fs/bcache/0c9b7a62-b431-4328-9dcb-a81e322238af/bdev0/stats_total/cache_bypass_races
> > 16577
> >
>
> The stat counters make sense.
>
> > Assuming this is the correct approach, areas to look at:
> > 1) Searching linked lists doesn't scale. Can something like an
> > interval tree be used here instead?
>
> Tree is not good. Heavy I/O may add and delete many nodes in and from
> the tree, the operation is heavy and congested, especially this is a
> balanced tree.
>
>
> > 2) Can this be restructured so that the inflight_lock doesn't have to
> > be accessed with interrupts disabled? Note that search_free() can be
> > called in interrupt context.
>
> Yes it is possible, with a lockless approach. What is needed is an array
> to atomic counter. Each element of the array covers a range of LBA, if a
> bypass write hits a range of LBA, increases the atomic counter from
> corresponding element(s). For the cache miss read, just do an atomic
> read without tree iteration and any lock protection.
>
> An array of atomic counters should work but not space efficient, memory
> should be allocated for all LBA ranges even most of the counters not
> touched during the whole system up time.
>
> Maybe xarray works, but I don't look into the xarray api carefully yet.

Okay, we'll look into using this data structure, thanks.


>
> > 3) Can do_not_cache just be another (1-bit) flag in the search
> > structure instead of occupying its own "int" ?
>
> At this moment, taking an int space is OK.
>
>
> Thanks for the patch.
>
> Coly Li
>
> >
> > v1 -> v2 changes:
> > - Use interval trees instead of linked lists to track inflight requests.
> > - Change code order to avoid acquiring lock in search_free().
> > ---
> >  drivers/md/bcache/bcache.h  |  4 ++
> >  drivers/md/bcache/request.c | 88 ++++++++++++++++++++++++++++++++++++-
> >  drivers/md/bcache/stats.c   | 14 ++++++
> >  drivers/md/bcache/stats.h   |  4 ++
> >  drivers/md/bcache/super.c   |  4 ++
> >  5 files changed, 113 insertions(+), 1 deletion(-)
> >
>
> [snipped]
>
