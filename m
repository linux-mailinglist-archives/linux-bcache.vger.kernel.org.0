Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2FE36DEF9
	for <lists+linux-bcache@lfdr.de>; Wed, 28 Apr 2021 20:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243465AbhD1Sb5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 28 Apr 2021 14:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbhD1Sb5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Apr 2021 14:31:57 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AD3C061573
        for <linux-bcache@vger.kernel.org>; Wed, 28 Apr 2021 11:31:11 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id dm16so6439081qvb.3
        for <linux-bcache@vger.kernel.org>; Wed, 28 Apr 2021 11:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zKPRu7t1P6rV5o+6nkahn6I+s7ScNALc8JhhM0UtW5Y=;
        b=bN1YBXpVUbEk/qLpqP/GC+ScVUo+5Emxn56lx8VjVcOB+v3eDcvwS8UadUfp4PsIiT
         e4Ja/KKVickEexMUOdu6NBtzrvrOc+YSbvj4xrGZbPilMceMuoNJk7xLD+vQJTNK5hxE
         oS9xtor4ZB2Qdj8j0QlFYHaCydBz7t5xlntdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zKPRu7t1P6rV5o+6nkahn6I+s7ScNALc8JhhM0UtW5Y=;
        b=MJKIaE88S1eqIFq7UtgLkQe2yrV77PKaLg+p70Un7CnLFzHgjIm0pBg621LPrlC73a
         CahRzQDdNM6GhQi68oj0pwB5627EOFOoXgbr3k6ZSKsVBiop1IQ4b2HK7DJMd6nzZlSx
         eZE2tq5ZWAGyU3iljCL7cq4NPjIyHHocb6X4JzuqdD/GigdrQLQVXyizTJD8XgLARm3u
         ToaPRYZcVq7sc7ncS5Y/4NMi2ZsBjrzFNWBW8kERYvOKxV1sWuqLoefq3Fh9qrhrYiAS
         mrre4RFhe/L1lEQtNF1QtELVA7/LD/629mGE5HHfBv87SlryQme2kNykyyuS/gyI/mjU
         Fv5Q==
X-Gm-Message-State: AOAM532MzTTRBeFsf0AjtzbcmO+oby0JvbTzeWTlduqLO1pks+UV32SB
        9936uIiIucyXTVYJpNgRjemV75uqvMGu1i97CfNPXov2B2o=
X-Google-Smtp-Source: ABdhPJxVuflN4UD67/jhcPr4Qpo8/sajF5lw9YhLlqB+3dq5s0+VPFfpMa5DqlIZtIElH5YdtMfEYvw/uIk6iJHfT7E=
X-Received: by 2002:a0c:9e0f:: with SMTP id p15mr30244500qve.27.1619634670811;
 Wed, 28 Apr 2021 11:31:10 -0700 (PDT)
MIME-Version: 1.0
References: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
In-Reply-To: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
From:   Kai Krakow <kai@kaishome.de>
Date:   Wed, 28 Apr 2021 20:30:59 +0200
Message-ID: <CAC2ZOYugQAw9NbMk_oo_2iC5GsZUN=uTO5FuvdRTMy9M6ASNEg@mail.gmail.com>
Subject: Re: Dirty data loss after cache disk error recovery
To:     =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo/lt54p?= 
        <wubenqing@ruijie.com.cn>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello!

Am Di., 20. Apr. 2021 um 05:24 Uhr schrieb =E5=90=B4=E6=9C=AC=E5=8D=BF(=E4=
=BA=91=E6=A1=8C=E9=9D=A2 =E7=A6=8F=E5=B7=9E)
<wubenqing@ruijie.com.cn>:
>
> Hi, Recently I found a problem in the process of using bcache. My cache d=
isk was offline for some reasons. When the cache disk was back online, I fo=
und that the backend in the detached state. I tried to attach the backend t=
o the bcache again, and found that the dirty data was lost. The md5 value o=
f the same file on backend's filesystem is different because dirty data los=
s.
>
> I checked the log and found that logs:
> [12228.642630] bcache: conditional_stop_bcache_device() stop_when_cache_s=
et_failed of bcache0 is "auto" and cache is dirty, stop it to avoid potenti=
al data corruption.

"stop it to avoid potential data corruption" is not what it actually
does: neither it stops it, nor it prevents corruption because dirty
data becomes thrown away.

> [12228.644072] bcache: cached_dev_detach_finish() Caching disabled for sd=
b
> [12228.644352] bcache: cache_set_free() Cache set 55b9112d-d52b-4e15-aa93=
-e7d5ccfcac37 unregistered
>
> I checked the code of bcache and found that a cache disk IO error will tr=
igger __cache_set_unregister, which will cause the backend to be datach, wh=
ich also causes the loss of dirty data. Because after the backend is reatta=
ched, the allocated bcache_device->id is incremented, and the bkey that poi=
nts to the dirty data stores the old id.
>
> Is there a way to avoid this problem, such as providing users with option=
s, if a cache disk error occurs, execute the stop process instead of detach=
.
> I tried to increase cache_set->io_error_limit, in order to win the time t=
o execute stop cache_set.
> echo 4294967295 > /sys/fs/bcache/55b9112d-d52b-4e15-aa93-e7d5ccfcac37/io_=
error_limit
>
> It did not work at that time, because in addition to bch_count_io_errors,=
 which calls bch_cache_set_error, there are other code paths that also call=
 bch_cache_set_error. For example, an io error occurs in the journal:
> Apr 19 05:50:18 localhost.localdomain kernel: bcache: bch_cache_set_error=
() bcache: error on 55b9112d-d52b-4e15-aa93-e7d5ccfcac37:
> Apr 19 05:50:18 localhost.localdomain kernel: journal io error
> Apr 19 05:50:18 localhost.localdomain kernel: bcache: bch_cache_set_error=
() , disabling caching
> Apr 19 05:50:18 localhost.localdomain kernel: bcache: conditional_stop_bc=
ache_device() stop_when_cache_set_failed of bcache0 is "auto" and cache is =
dirty, stop it to avoid potential data corruption.
>
> When an error occurs in the cache device, why is it designed to unregiste=
r the cache_set? What is the original intention? The unregister operation m=
eans that all backend relationships are deleted, which will result in the l=
oss of dirty data.
> Is it possible to provide users with a choice to stop the cache_set inste=
ad of unregistering it.

I think the same problem hit me, too, last night.

My kernel choked because of a GPU error, and that somehow disconnected
the cache. I can only guess that there was some sort of timeout due to
blocked queues, and that introduced an IO error which detached the
caches.

Sadly, I only realized this after I already reformatted and started
restore from backup: During the restore I watched the bcache status
and found that the devices are not attached.

I don't know if I could have re-attached the devices instead of
formatting. But I think the dirty data would have been discarded
anyways due to incrementing bcache_device->id.

This really needs a better solution, detaching is one of the worst,
especially on btrfs this has catastrophic consequences because data is
not updated inline but via copy on write. This requires updating a lot
of pointers. Usually, cow filesystem would be robust to this kind of
data-loss but the vast amount of dirty data that is lost puts the tree
generations too far behind of what btrfs is expecting, making it
essentially broken beyond repair. If some trees in the FS are just a
few generations behind, btrfs can repair itself by using a backup tree
root, but when the bcache is lost, generation numbers usually lag
behind several hundred generations. Detaching would be fine if there'd
be no dirty data - otherwise the device should probably stop and
refuse any more IO.

@Coly If I patched the source to stop instead of detach, would it have
made anything better? Would there be any side-effects? Is it possible
to atomically check for dirty data in that case and take either the
one or the other action?

Thanks,
Kai
