Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9842C447A7D
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Nov 2021 07:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhKHGie (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Nov 2021 01:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhKHGid (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Nov 2021 01:38:33 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB0AC061570
        for <linux-bcache@vger.kernel.org>; Sun,  7 Nov 2021 22:35:49 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id a129so40731945yba.10
        for <linux-bcache@vger.kernel.org>; Sun, 07 Nov 2021 22:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FQ/NYGnaDiNXnRwmnnv+m5N4WxJqRWnOlxcLSt58kDc=;
        b=EI5s/MAbmEIsohGbmv4Xy/VXdTJCZp/iiGztpHu2MY95hKhXYZSwBW354+EA9ZbWX2
         cBHk7x89Lv+avivQpHVJJclh3vcZVTI5JJC8LTwoiFMXGq1cdHPdZtqDjAJN7yQy7EaE
         26oQdExSuAaW8Pp4mPbBeKjIhqEDYz1CLN4lU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FQ/NYGnaDiNXnRwmnnv+m5N4WxJqRWnOlxcLSt58kDc=;
        b=zJsgajd3IMEUaNUSYtgK8IO5xwC7HAMHpAiL3QAWfy04V0jrdEH1cfKlZIKXnOXUqZ
         IMdxLJRquQBACAzyMzz7cVwck7ykPwooZ1W4BESTmPQYFq5i/fiyYegpz+FxAuLd1V/D
         sdl9bu83yjl9Em8b6Jh7bcz1HvANmSeOwqEiJeaAzh3lk1t/qwF2OiVRgIFYL4jb+DPi
         PGsW73ElNExKq67mwqcJtiT+E5+MRXFgiiG0wY2C7CKxOSSu+74yzQd3hqiGEfD2+Dbk
         w79/oC/zsEfYmplDtaCgT6c0pNxb32dOkK79VQoAs96LTyeWvKoqIZKH1ipJuVaUyZ2d
         PyrA==
X-Gm-Message-State: AOAM531Q1Sjf3RGuX0KUxqS0/o41/sGhlu/00Y538ylXBuFeLXBWuH7v
        WpGULcsJJ93Opmzw2cYUwgpcxVeNGSHtqyzjP1hfAqsdyR8=
X-Google-Smtp-Source: ABdhPJwhO/OjyiVpeDBS9XMKPigVEsPvHySZwkWgkOuYn9S82PIg/8T6dBsDd64lP1V/FxpxvS6J6Dg2b71c4cFjAx4=
X-Received: by 2002:a05:6902:72d:: with SMTP id l13mr58594094ybt.368.1636353346529;
 Sun, 07 Nov 2021 22:35:46 -0800 (PST)
MIME-Version: 1.0
References: <10612571636111279@vla5-f98fea902492.qloud-c.yandex.net> <CAJS8hV+KdLA6c8c5OV=z_KmJN2TSWROR6k9Y6_qut4EavJ0=tA@mail.gmail.com>
In-Reply-To: <CAJS8hV+KdLA6c8c5OV=z_KmJN2TSWROR6k9Y6_qut4EavJ0=tA@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Mon, 8 Nov 2021 07:35:35 +0100
Message-ID: <CAC2ZOYu36PAJO-b-vWYJftFT2PQ-JwiP9q79yqXDS_1z6V7M3g@mail.gmail.com>
Subject: Re: A lot of flush requests to the backing device
To:     Dongdong Tao <dongdong.tao@canonical.com>
Cc:     Aleksei Zakharov <zakharov.a.g@yandex.ru>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Mo., 8. Nov. 2021 um 06:38 Uhr schrieb Dongdong Tao
<dongdong.tao@canonical.com>:
>
> My understanding is that the bcache doesn't need to wait for the flush
> requests to be completed from the backing device in order to finish
> the write request, since it used a new bio "flush" for the backing
> device.

That's probably true for requests going to the writeback cache. But
requests that bypass the cache must also pass the flush request to the
backing device - otherwise it would violate transactional guarantees.
bcache still guarantees the presence of the dirty data when it later
replays all dirty data to the backing device (and it can probably
reduce flushes here and only flush just before removing the writeback
log from its cache).

Personally, I've turned writeback caching off due to increasingly high
latencies as seen by applications [1]. Writes may be slower
throughput-wise but overall latency is lower which "feels" faster.

I wonder if maybe a lot of writes with flush requests may bypass the cache...

That said, initial releases of bcache felt a lot smoother here. But
I'd like to add that I only ever used it for desktop workflows, I
never used ceph.

Regards,
Kai

[1]: And some odd behavior where bcache would detach dirty caches on
caching device problems, which happens for me sometimes at reboot just
after bcache was detected (probably due to a SSD firmware hiccup, the
device temporarily goes missing and re-appears) - and then all dirty
data is lost and discarded. In consequence, on next reboot, cache mode
is set to "none" and the devices need to be re-attached. But until
then, dirty data is long gone.
