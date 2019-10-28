Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 703CCE7B85
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Oct 2019 22:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731465AbfJ1Vlk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Oct 2019 17:41:40 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:36936 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731001AbfJ1Vlk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Oct 2019 17:41:40 -0400
Received: by mail-qt1-f182.google.com with SMTP id g50so16958151qtb.4
        for <linux-bcache@vger.kernel.org>; Mon, 28 Oct 2019 14:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cLu75wovGIHvGkBgW5EzPv9syf+H5wwrgraA6CrdxwQ=;
        b=HT0raVqLL1eyFzH3CJyj8kPiObLw4YXCfE3KZG86PDK8ubMezRgNO7B2Sbo6hSHir1
         vOyWpC9PZaloK3/9gwH6jY9kxy0oi9UCpn+9hjyHwgGKmWkFoURSgr6bV0+Ndbs/YnIV
         yqqHxnJIvxJ2O5ZwcasqytFMynC1jyKKQdmYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cLu75wovGIHvGkBgW5EzPv9syf+H5wwrgraA6CrdxwQ=;
        b=K2bHswMZ/iolh1DI96hL+SrMuuRhI4PT8UCqAi7CkXqq2sGKew0wmXTj4y87jVDrHR
         pcCT4THfl7rf1oxs/hMj9OzvFzkLPuf5kxvSFOXNKZVz9G9m03CqBTEZKqlSnNIzUozC
         S7ybS76uDM7kSn9SqXkmG0bfTmp5wUbCSlqPCaiMNEbIJnXI/OOUqImtjtamU8/TDExq
         zsEbXMjIdKAjAlm8AtW/WwTeXsw5AIxIBuPy0c89p54pP3DAsdQPBJW+02GObo3yzf6M
         xH6qX7j9jGK1nLhCNbdpuqDnWIa1JWp3V56N3FD7vKgsElnHy/vzs9UPqfOmGv9mGAeO
         /s/A==
X-Gm-Message-State: APjAAAXasuQq8TT7zJDLyOBTrk4foRCgNXA+apUhcCwlOF49QPhBqs0o
        jKvKy6AE10iMI2K7kFIvxx+i96cdV/uOAdUR623XDLj/f08=
X-Google-Smtp-Source: APXvYqxXDG3B1/J7JeT7dsl3CQgi9dhOnlgbZkom9rmAQAq7BN2aluVSGdx2XL93On1V9VABjh9HLHgCRzq5ilRdV9I=
X-Received: by 2002:ac8:1604:: with SMTP id p4mr767934qtj.276.1572298898241;
 Mon, 28 Oct 2019 14:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <4d6fe8a0-ecae-738b-165b-ee66683a2df6@nuclearwinter.com>
 <alpine.LRH.2.11.1910242322110.25870@mx.ewheeler.net> <fa7a7125-195f-a2ad-4b5e-287c02cd9327@suse.de>
 <89f29562-409b-7b4e-e299-1c8e8db77ea5@nuclearwinter.com>
In-Reply-To: <89f29562-409b-7b4e-e299-1c8e8db77ea5@nuclearwinter.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Mon, 28 Oct 2019 22:41:26 +0100
Message-ID: <CAC2ZOYvCfYSKau==KJJW5ymgf9NveS+pMGAGASMNDNVvAFrtYA@mail.gmail.com>
Subject: Re: bcache writeback infinite loop?
To:     Larkin Lowrey <llowrey@nuclearwinter.com>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi!

Am Mo., 28. Okt. 2019 um 16:14 Uhr schrieb Larkin Lowrey
<llowrey@nuclearwinter.com>:
> Reverting to 5.2.18 didn't make a difference not did moving forward to
> 5.3.7.
>
> I noticed that on each reboot the point where it got stuck changed. It
> had been stuck at 14.3MiB dirty then a couple of reboots later it was
> down to 10.7MiB. For example...
>
> On reboot, the dirty was 42.9MiB and proceeded to shrink until it got
> stuck at 10.7MiB. I then rebooted and it was 44.9MiB and shrank to
> 10.0MiB. I rebooted again, and got unlucky, it started at 45.4MiB and
> got stuck at 10.3MiB (an increase from the prior run). I assume that
> mounting and unmounting the fs does generate some small amount of writes
> which may explain the differences.

I'm not sure if I'm seeing the same issue but I'm seeing a similar effect.

Could you try two different settings independently from each other,
and see if it changes behavior? These settings can be applied without
reboot but you may confirm it across reboots (which would need a udev
rule):

You could try setting `writeback_rate_minimum` to a higher value, i.e.
set it to 8192 to let it write 4 MB/s at minimum (it's counted in
sectors).

You could try setting `writeback_percent` to a lower value, i.e. set
it to 0 to aggressively write back all data instead of keeping some
dirty amount around (it's a percent value).

Chances are that it's simply not writing back data fast enough. But
then, there's some other process generating the writes for you, not
bcache itself.

PS: udev rule:

# /etc/udev/rules.d/99-bcache-settings.conf

# Just remove the comment here:
#ACTION=="add|change", KERNEL=="bcache*",
ATTR{bcache/writeback_rate_minimum}="8192"

# or here:
#ACTION=="add|change", KERNEL=="bcache*", ATTR{bcache/writeback_percent}="0"

Regards,
Kai
