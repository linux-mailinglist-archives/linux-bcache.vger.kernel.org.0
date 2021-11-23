Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C46B45AF31
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Nov 2021 23:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhKWWiE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Nov 2021 17:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhKWWiD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Nov 2021 17:38:03 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772D1C061574
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 14:34:54 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so1125788otj.7
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 14:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FMrRWiGLt4l876HlE9CmUz5Yuns20EzwHu1M3oHZK/Q=;
        b=Nq8PrIo2dzU9igeoRCV4+A9k8BIixXi0RMIEPkbBSiHbZRee/xRfYfhXPQaoLAjVbz
         N8apxnN3IhFvkViwzRhdCIIbAWtBWo7e7RoYGxdb0GBsQ1CBKFeErJk682D4nxJBqcIh
         g9M7wRggSFM4FRonDOJ+iAw5qYt/6PTqyzRxJWMz6V6EEdLpOkn8+RoeHERyVKVlZaCC
         xCPPZO6z98plr4r6d+0PxX0LAQYoLei2b5/Kb3E6B/lD0uLiqBf1M++cSvJcND4Rm3Hy
         M4q71NMGQUkKpx6DQa4uarKWucyaOMf3dxLI3KkQ/LS5bYRk2v2tMEnn2Mq5aDrKAAjv
         6hmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FMrRWiGLt4l876HlE9CmUz5Yuns20EzwHu1M3oHZK/Q=;
        b=h9J4CeJoPNSfeq2sPQe7Tf3bc8FmCsC8BqvxCObm/d9C/jPf/TbhcZYNB5fK9C1ajm
         MP5epm0eXYEPIQnr2Vx1LNvlH0k1NLMb1nF/kOr32xniXaxSd5Gx4uhVEbGSOJxdeFIT
         h+YgTTv9pc6Q4vq4+Tx9GSYsyZ6fT9VRcMldUDTZtikF9czLu2ATINBhQlRFEXDZUmGJ
         hjcdbNb9xpKpgbPY0fSwVYzaGpqbzkVDEwtb+z4anMbUKYDHtVX9r3RLpIWqVbH7uJiR
         iRo6luVhiJKtHOHwsa2fFyVFAAxPAkkJfwgB0QgxAADyS6uJmxLZLbUPHIXqjo9BTKEF
         d8MQ==
X-Gm-Message-State: AOAM531eBkfLlrt9MUiuEFhz4K6GSAvIF8doGRZXAUAaoxUR2uVWbzq1
        9A4PLbKV+DAE+oQ5NJKbYit0+suJq7SOZXpjKbInmOjOC1w=
X-Google-Smtp-Source: ABdhPJyScYRbmiq9m6+nPQ/n7dLVDeLLdgdX58iJD5LrAqXeSiI6AHDrqgMtYFk+S2x0vqlJYi7nEUMAfL7k0qIclng=
X-Received: by 2002:a05:6830:1c70:: with SMTP id s16mr7915308otg.59.1637706893823;
 Tue, 23 Nov 2021 14:34:53 -0800 (PST)
MIME-Version: 1.0
References: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com>
 <CAC2ZOYs6iVbqgw8RiiTN7TrHwy3LDTc2AVXm53+2BNjOx04Cmw@mail.gmail.com> <CAC2ZOYtJXL=WOJ6bLvNNnq7SHzHfmzt6AkOSR1m=g95hrggP4w@mail.gmail.com>
In-Reply-To: <CAC2ZOYtJXL=WOJ6bLvNNnq7SHzHfmzt6AkOSR1m=g95hrggP4w@mail.gmail.com>
From:   =?UTF-8?Q?Tobiasz_Karo=C5=84?= <unfa00@gmail.com>
Date:   Tue, 23 Nov 2021 23:34:42 +0100
Message-ID: <CAOsCCbM04NjDR67uZpxz6JC2Tx5a-_eVjvwMnhhyJADGccuqOw@mail.gmail.com>
Subject: Re: Bcache is not caching anything. cache state=inconsistent, how to clear?
To:     Kai Krakow <kai@kaishome.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Thank you for your detailed reply and sharing your experience and solution.

So it seems Bcache and Btrfs are fundamentally incompatible when it
comes to caching writes? It has worked fine for 2 months, and then it
just imploded. I'll stay in writearound mode to be safe.

I've checked and my cache device has a block size of 512 bytes. That's
a strange value, as the backing device is a AF HDD (like all of them
in the past decade or more), so the block size should be 4Kb.
I guess this also works until it doesn't.

Can I destroy and recreate the cache device on a live system (my root
filesystem is on this bcache set).
I guess I can't. This is probably what I've done wrong today - I did
not unregister the whole cset before attempting to recreate the cache
device.

I am honestly a little afraid to touch it, after what happened.

I hope Bcachefs will eliminate these problems and provide a stable
unified solution.

Take care
- unfa

wt., 23 lis 2021 o 18:40 Kai Krakow <kai@kaishome.de> napisa=C5=82(a):
>
> Oops:
>
> > # echo 1 >/sys/fs/bcache/CSETUUID/unregister
> > # bcache make -C -w 4096 -l LABEL --force /dev/BPART
>
> CPART of course!
>
> # bcache make -C -w 4096 -l LABEL --force /dev/CPART
>
> Bye
> Kai



--=20
- Tobiasz 'unfa' Karo=C5=84

www.youtube.com/unfa000
