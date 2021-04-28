Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0764936DF37
	for <lists+linux-bcache@lfdr.de>; Wed, 28 Apr 2021 20:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbhD1SwG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 28 Apr 2021 14:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhD1SwG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Apr 2021 14:52:06 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3172DC061573
        for <linux-bcache@vger.kernel.org>; Wed, 28 Apr 2021 11:51:21 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id a18so23664211qtj.10
        for <linux-bcache@vger.kernel.org>; Wed, 28 Apr 2021 11:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=66ObDa+Hv8JAGUM//x2Rl1v0btq/Md2B0Kv//fbE/9g=;
        b=JpaNHv1J6sQglviAfwd+NUb+Ujb+StGgckk5gXgccPS1f6/ApWi65fF6DvRCaVolv9
         WawJPHY7dyGdNrGsFam6K4NRGyAQfvuY8Lbvdb7VcmWE9ek1K+Vt74+r2yLR2V9jp7dp
         qhxFHrnzJEoXqZV5xBDcNgNlwR3X43Zh3s9RE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=66ObDa+Hv8JAGUM//x2Rl1v0btq/Md2B0Kv//fbE/9g=;
        b=YyJ+wT09LfZJIkAc87Kgk7DiIuumpCxASfJ7CLBCNVWkc9z1seqoHXSs3xmJo9azra
         qIn+v24LxVez/bqwlLo1k4mz4rQTW/U1Ee2RGTTESqauNv6LMjeWPDs9AyD9YDLMy1VQ
         2c34OLzCrrmMSQBvewh3dZxMmiwZFCQC6DLZdSlkh27B0Rvtp2FWpM1QLhKR+lW5A4Op
         Dpdpv8t5PHQyQFISUttTvNIlUNmeTbm1q9GxOOWfYC0Kw+NLXOhrH4AeO1IF9zgkaGT7
         lvXi6ygOTrcT505tTTQmg/jnprNNl1CO/Z6q6xKNKoJPnycj66yyAerp/WoTbAl/8NMR
         6WOg==
X-Gm-Message-State: AOAM531WknCrAwdjz1345xVt5Eglh9JVB84OpE4Z1yvwZy30JqpaiQc4
        9L8So/mlrnA4CXWwyU21eJrojF32RwIbpq1aXWbN2yGrpBlqhg==
X-Google-Smtp-Source: ABdhPJyIPJ6PtFO7t9kvIdzPhPkk+PuVlrKCVfGb0a8ZTfHfJ1c3LnFTpV++4mF/RrPQ8F+lq0A2MiQrV9rMCD62FKI=
X-Received: by 2002:ac8:739a:: with SMTP id t26mr11526525qtp.381.1619635880462;
 Wed, 28 Apr 2021 11:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
 <CAC2ZOYugQAw9NbMk_oo_2iC5GsZUN=uTO5FuvdRTMy9M6ASNEg@mail.gmail.com> <CAC2ZOYtg4P_CYrTH6kQM1vCuU4Bai7v8K3Nmu3Yz7fNuHfEnRw@mail.gmail.com>
In-Reply-To: <CAC2ZOYtg4P_CYrTH6kQM1vCuU4Bai7v8K3Nmu3Yz7fNuHfEnRw@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Wed, 28 Apr 2021 20:51:09 +0200
Message-ID: <CAC2ZOYuBhFbpZeRnnc-1-Vt-tV_3iwkf3i21+YjVukYkx7J7YQ@mail.gmail.com>
Subject: Re: Dirty data loss after cache disk error recovery
To:     =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo/lt54p?= 
        <wubenqing@ruijie.com.cn>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> I think this behavior was introduced by https://lwn.net/Articles/748226/
>
> So above is my late review. ;-)
>
> (around commit 7e027ca4b534b6b99a7c0471e13ba075ffa3f482 if you cannot
> access LWN for reasons[tm])

The problem may actually come from a different code path which retires
the cache on metadata error:

commit 804f3c6981f5e4a506a8f14dc284cb218d0659ae
"bcache: fix cached_dev->count usage for bch_cache_set_error()"

It probably should consider if there's any dirty data. As a first
step, it may be sufficient to run a BUG_ON(there_is_dirty_data) (this
would kill the bcache thread, may not be a good idea) or even freeze
the system with an unrecoverable error, or at least stop the device to
prevent any IO with possibly stale data (because retiring throws away
dirty data). A good solution would be if the "with dirty data" error
path could somehow force the attached file system into read-only mode,
maybe by just reporting IO errors when this bdev is accessed through
bcache.

Thanks,
Kai
