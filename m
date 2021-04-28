Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F6436DF07
	for <lists+linux-bcache@lfdr.de>; Wed, 28 Apr 2021 20:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243640AbhD1SkC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 28 Apr 2021 14:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243508AbhD1SkC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Apr 2021 14:40:02 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0B3C061573
        for <linux-bcache@vger.kernel.org>; Wed, 28 Apr 2021 11:39:16 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id v20so9742211qkv.5
        for <linux-bcache@vger.kernel.org>; Wed, 28 Apr 2021 11:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pRygfN/764VcwKqKLR1+Fcx2qjJD/6ol5MA9yrHz4Ps=;
        b=gVcb8Ptg9UVL6QWvtgRSfQVKhZyIuste+pc7IM6/KH5V++DmvLR3T2LVSb9jdzbeSz
         GguMBKbuiRIAersfYyJ75ECOrm5INojDNAkyILYIjvG1Z4r6WPXZTwvgt/Urm+XrgtZq
         mVDjc8zt8H+qFJb2GDTQVrYwlTSeKBYkxFoaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pRygfN/764VcwKqKLR1+Fcx2qjJD/6ol5MA9yrHz4Ps=;
        b=eKQXz9KU6Fi/dgBWpGJUvfJblKNyHNRcblkd6h0R0hWGlRdPBDN0a2uRmmZA2FAdoz
         PUiA7c73VBuTeevEe0r0EL2EN/Ry8Mh9qboad13kfvHWdS2AJnJ4GzXsV9ZiYyJ6Js32
         q5LY5yO8+Glu+ECS/okx38NkwnvbK3mwR7jp+wE3e9+RBymQ5XJ7ZTyRgqKYq4gRbx1F
         GCa+oofitVQXx9RKcu2o/2WUDmm6MeWmjEACN7a/z0pTiW7wYpp2PQtS2n9P4xtvmdAG
         uaTN2dApn15OEVtLNo1KxfQLkO1CCAUeFQj3alMF/zUnfLHCozw4dZuInibqxeKDXEJv
         LG5w==
X-Gm-Message-State: AOAM533i2HW/3YYVPaRum1E6lttfqtdfbJNAQLFDrzSKlpdIROdagDx+
        lgw4szgCyFsgc4QgmfNcNpiDTgFrppHBqZGpiTWY7AHxTS3Wnw==
X-Google-Smtp-Source: ABdhPJxQNf/kpN/IVogMk7yMpstEbzxCWw5nV30p+Dmz3DceRr9mBKzVbMRQcSf6ESqmQof4LWhcDfJKgdBu2KaRGFU=
X-Received: by 2002:a05:620a:2903:: with SMTP id m3mr17909441qkp.37.1619635156066;
 Wed, 28 Apr 2021 11:39:16 -0700 (PDT)
MIME-Version: 1.0
References: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn> <CAC2ZOYugQAw9NbMk_oo_2iC5GsZUN=uTO5FuvdRTMy9M6ASNEg@mail.gmail.com>
In-Reply-To: <CAC2ZOYugQAw9NbMk_oo_2iC5GsZUN=uTO5FuvdRTMy9M6ASNEg@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Wed, 28 Apr 2021 20:39:05 +0200
Message-ID: <CAC2ZOYtg4P_CYrTH6kQM1vCuU4Bai7v8K3Nmu3Yz7fNuHfEnRw@mail.gmail.com>
Subject: Re: Dirty data loss after cache disk error recovery
To:     =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo/lt54p?= 
        <wubenqing@ruijie.com.cn>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly!

Am Mi., 28. Apr. 2021 um 20:30 Uhr schrieb Kai Krakow <kai@kaishome.de>:
>
> Hello!
>
> Am Di., 20. Apr. 2021 um 05:24 Uhr schrieb =E5=90=B4=E6=9C=AC=E5=8D=BF(=
=E4=BA=91=E6=A1=8C=E9=9D=A2 =E7=A6=8F=E5=B7=9E)
> <wubenqing@ruijie.com.cn>:
> >
> > Hi, Recently I found a problem in the process of using bcache. My cache=
 disk was offline for some reasons. When the cache disk was back online, I =
found that the backend in the detached state. I tried to attach the backend=
 to the bcache again, and found that the dirty data was lost. The md5 value=
 of the same file on backend's filesystem is different because dirty data l=
oss.
> >
> > I checked the log and found that logs:
> > [12228.642630] bcache: conditional_stop_bcache_device() stop_when_cache=
_set_failed of bcache0 is "auto" and cache is dirty, stop it to avoid poten=
tial data corruption.
>
> "stop it to avoid potential data corruption" is not what it actually
> does: neither it stops it, nor it prevents corruption because dirty
> data becomes thrown away.
>
> > [12228.644072] bcache: cached_dev_detach_finish() Caching disabled for =
sdb
> > [12228.644352] bcache: cache_set_free() Cache set 55b9112d-d52b-4e15-aa=
93-e7d5ccfcac37 unregistered
> >
> > I checked the code of bcache and found that a cache disk IO error will =
trigger __cache_set_unregister, which will cause the backend to be datach, =
which also causes the loss of dirty data. Because after the backend is reat=
tached, the allocated bcache_device->id is incremented, and the bkey that p=
oints to the dirty data stores the old id.
> >
> > Is there a way to avoid this problem, such as providing users with opti=
ons, if a cache disk error occurs, execute the stop process instead of deta=
ch.
> > I tried to increase cache_set->io_error_limit, in order to win the time=
 to execute stop cache_set.
> > echo 4294967295 > /sys/fs/bcache/55b9112d-d52b-4e15-aa93-e7d5ccfcac37/i=
o_error_limit
> >
> > It did not work at that time, because in addition to bch_count_io_error=
s, which calls bch_cache_set_error, there are other code paths that also ca=
ll bch_cache_set_error. For example, an io error occurs in the journal:
> > Apr 19 05:50:18 localhost.localdomain kernel: bcache: bch_cache_set_err=
or() bcache: error on 55b9112d-d52b-4e15-aa93-e7d5ccfcac37:
> > Apr 19 05:50:18 localhost.localdomain kernel: journal io error
> > Apr 19 05:50:18 localhost.localdomain kernel: bcache: bch_cache_set_err=
or() , disabling caching
> > Apr 19 05:50:18 localhost.localdomain kernel: bcache: conditional_stop_=
bcache_device() stop_when_cache_set_failed of bcache0 is "auto" and cache i=
s dirty, stop it to avoid potential data corruption.
> >
> > When an error occurs in the cache device, why is it designed to unregis=
ter the cache_set? What is the original intention? The unregister operation=
 means that all backend relationships are deleted, which will result in the=
 loss of dirty data.
> > Is it possible to provide users with a choice to stop the cache_set ins=
tead of unregistering it.
>
> I think the same problem hit me, too, last night.
>
> My kernel choked because of a GPU error, and that somehow disconnected
> the cache. I can only guess that there was some sort of timeout due to
> blocked queues, and that introduced an IO error which detached the
> caches.
>
> Sadly, I only realized this after I already reformatted and started
> restore from backup: During the restore I watched the bcache status
> and found that the devices are not attached.
>
> I don't know if I could have re-attached the devices instead of
> formatting. But I think the dirty data would have been discarded
> anyways due to incrementing bcache_device->id.
>
> This really needs a better solution, detaching is one of the worst,
> especially on btrfs this has catastrophic consequences because data is
> not updated inline but via copy on write. This requires updating a lot
> of pointers. Usually, cow filesystem would be robust to this kind of
> data-loss but the vast amount of dirty data that is lost puts the tree
> generations too far behind of what btrfs is expecting, making it
> essentially broken beyond repair. If some trees in the FS are just a
> few generations behind, btrfs can repair itself by using a backup tree
> root, but when the bcache is lost, generation numbers usually lag
> behind several hundred generations. Detaching would be fine if there'd
> be no dirty data - otherwise the device should probably stop and
> refuse any more IO.
>
> @Coly If I patched the source to stop instead of detach, would it have
> made anything better? Would there be any side-effects? Is it possible
> to atomically check for dirty data in that case and take either the
> one or the other action?

I think this behavior was introduced by https://lwn.net/Articles/748226/

So above is my late review. ;-)

(around commit 7e027ca4b534b6b99a7c0471e13ba075ffa3f482 if you cannot
access LWN for reasons[tm])

Thanks,
Kai
