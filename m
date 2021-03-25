Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3B3349374
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Mar 2021 14:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhCYN5q (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 25 Mar 2021 09:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbhCYN51 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Mar 2021 09:57:27 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41692C06174A
        for <linux-bcache@vger.kernel.org>; Thu, 25 Mar 2021 06:57:22 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id c3so32148qvz.7
        for <linux-bcache@vger.kernel.org>; Thu, 25 Mar 2021 06:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rn4iQsmhk3IbSdSE1CkcIgZtVP5cL/NgE0TEkQjVtnM=;
        b=I6Z8ptwWey30RNBJOK9jPX/PppyZGaGgyc+yorumwzbUCfiNXRz0ivItfP/HLmxsWo
         ahISSpL7PVWz6WWekJwZHutsEyI5PZEC+18QgRoNsctBOmMbkp+Vy3i0ZQNiIddkV4A6
         HRbJBzHVeNzea3NWD+ljkoBLs6UshgfnqQoUQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rn4iQsmhk3IbSdSE1CkcIgZtVP5cL/NgE0TEkQjVtnM=;
        b=qUSoXYHYZqxl8wfZkWUybWOkWC1IDTpkTLAqvz/lOwChg/nBesrH3da636Js+m1YH/
         O5SBSGfyJ/eAXhP/bODLecPjF8SBh1n3rAuC3BvBNZlXOQdI7z+P1nacgEiI/m+kX0yv
         CNPS4O8KxYaShRLPWDufCEek6+Kvr1ypd8Zl+HhE35j9NsH27YHlMj/tz0NbDG14UV2z
         A5IoUbey+uVLr+kgZ97IWCUhXcBrRPvhlqrRWmRNMzOZe6Xkx8aab1xzGpSTTq/y7w9F
         XygKtPz/OG55nWxomPANsPsdAlVYOtoVs6o5++IYMEZfbtTNAeV9bXnsFUPNIKSJFFLu
         nkwg==
X-Gm-Message-State: AOAM532p15i6f37Mv++CHjxRwJQSV5SfRJvjjroFguJOxLsrE38sS8om
        sjftXip3mOr9dn7nfGSipguMpcLBCksevradV6JXH1mv85M=
X-Google-Smtp-Source: ABdhPJxFMN7rfpQ51QsoQ4MBqFPF+JF11Cek97w2mCKGtJFiKGF6R6OLPGiJL4pFk/q4Tok3TQtkbVydDTTqs1wurfo=
X-Received: by 2002:a05:6214:1870:: with SMTP id eh16mr8260202qvb.23.1616680641476;
 Thu, 25 Mar 2021 06:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <CANA18Uzd6FK-vEOjakAPW5ZXPG=7OrzYSQvD8ycE5jyxDfAr6g@mail.gmail.com>
 <e0969226-5352-6b57-8fe7-9e672e30174b@suse.de> <CANA18UzWzTKsku_M1z38UCsFOnsxL5pN0998g9KVNeqD05ffpQ@mail.gmail.com>
In-Reply-To: <CANA18UzWzTKsku_M1z38UCsFOnsxL5pN0998g9KVNeqD05ffpQ@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Thu, 25 Mar 2021 14:57:10 +0100
Message-ID: <CAC2ZOYvoVfpNh-4hcYxPJkgA9kkK2Scbqg_ce2LO+Xk7D-6drQ@mail.gmail.com>
Subject: Re: A note and a question on discarding, from a novice bcache user
To:     Martin Kennedy <hurricos@gmail.com>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Martin!

Am Do., 25. M=C3=A4rz 2021 um 14:06 Uhr schrieb Martin Kennedy <hurricos@gm=
ail.com>:
>
> I don't think the garbage collection performed by bcache actually
> sends TRIMs to the SSD unless you turn on discard. Without sending
> TRIMs you cannot expect a cheap SSD (or pair of cheap ones in RAID1)
> to keep up performance.
>
> After some small load over the month past, I've done another test to
> verify that performance has not degraded:

If you want to make use of trimmed space without using online discard,
your best chance is to create a blank partition on the caching device
after the bcache partition, blkdiscard that, and never touch it. Now
re-create bcache in the first partition. The blank partition should be
around 10-20% of your device size. This way, the SSD firmware can
still do background wear-leveling by swapping flash pages with the
untouched partition and do background gc/erase. This will keep bcache
latency low, and performance should be stable.
