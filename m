Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4152354139
	for <lists+linux-bcache@lfdr.de>; Mon,  5 Apr 2021 12:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbhDEKl0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 5 Apr 2021 06:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbhDEKlZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Apr 2021 06:41:25 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6A5C061756
        for <linux-bcache@vger.kernel.org>; Mon,  5 Apr 2021 03:41:19 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id w3so16209530ejc.4
        for <linux-bcache@vger.kernel.org>; Mon, 05 Apr 2021 03:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cStDlLkCXFEQdZJWPQfAz+A4IxIqKe9/vYTRMlTv7Xw=;
        b=C6bwZn2l9buTeJNMbynHUnoc5GExyiOxNRGxdgyRU/9RlDcy0QDZy6ZW0ymMN8KXbw
         cCaoEhXyRiAqtGEAGpd5VAtN2vu3JwLhgIBb1/fFljYc2wDHaIoFHMwxhdqTVE4JCjlQ
         iRBheKPSVayFKdmEYD4mhGGNFZ81G+h81U0+7jKYOZCitq+Pm6Xo0kXIqL+8r7QzckJA
         kwoJxiFKowbPqg68E3p1U0Er7CEZNtH7NGgYp8siNaWrIO4ORsyWKc+miME1ivanoLTh
         tTKUJk5K5egfJHfpfQ+D9p9R1SLyX3z77QuYammCDfAPf57+MR5Cqt9/vj7Ui1SteoKZ
         UxbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cStDlLkCXFEQdZJWPQfAz+A4IxIqKe9/vYTRMlTv7Xw=;
        b=kWCOiNpSmkJy6k2co2RZ74BSQU5H1Z3yYGCWjPH5qAEjm4TzP7sip6IsLr2yVgRepr
         OcVabPgugazlkjfSiJ9pvceBm+hKPRS98q67XYtwLLHqSdz8Ocz+EZO9u6yrJIsXomaI
         ko3E3zINZXmau/opIwjMhPZmaDrNsCOoEjvkoRvDol627wwpUkVpZa/cCNy4WKJrO2qw
         5IfTGVLZpZStAwNyklJnv50UYbWWhdjQloq6+zuzdXTv8pL0cI0Gwx/zNhR3tR7dIF/Q
         LufDqRcVdiRKIT6wprW96P2F5B3xWiyb/SH6PtD7wBsAhfeDcksPMqTnsSdYICj9itlg
         hatQ==
X-Gm-Message-State: AOAM530p6MWZVjW+C5Yb8DSv+9pTZySyoA/AJuNyIYoztV6nc+8fs4d1
        YtFoEkDTj2wpzd0o45R081ZeDNRF/UsbxtJq/mD8tevmgo8=
X-Google-Smtp-Source: ABdhPJwSYnELHw2QMsd44ap5IqlMBjGteE1CWYFQQzYlRM1D4R6FbVMzEvshoj9KoJHRgCpERLde/aP2R63EuN+Nv2s=
X-Received: by 2002:a17:906:b296:: with SMTP id q22mr5873360ejz.161.1617619278420;
 Mon, 05 Apr 2021 03:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <4639704.31r3eYUQgx@exnet.gdb.it> <CAC2ZOYsWXUQ+AtQkoXXx50_XSQGMx9xBrgFNP7k0Mt8c79XMcQ@mail.gmail.com>
In-Reply-To: <CAC2ZOYsWXUQ+AtQkoXXx50_XSQGMx9xBrgFNP7k0Mt8c79XMcQ@mail.gmail.com>
From:   gius db <giusdbg@gmail.com>
Date:   Mon, 5 Apr 2021 12:43:33 +0200
Message-ID: <CAO6aweN7O1uVxauTXzCJQsXoovm3AhiQz1_K0z-b-75iymXZ1g@mail.gmail.com>
Subject: Re: [CACHE DEVICE] Space usage
To:     Kai Krakow <kai@kaishome.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi.

Thanks for the very clear explanation, and the various solutions provided.

My SSD is a 250GB Samsung, I'll do some checking and testing, but I
think I'll leave a 10% free.

Happy holidays.

gdb

Il giorno dom 4 apr 2021 alle ore 21:42 Kai Krakow <kai@kaishome.de> ha scritto:
>
> Hi!
>
> Am So., 4. Apr. 2021 um 18:23 Uhr schrieb Giuseppe Della Bianca
> <giusdbg@gmail.com>:
> > In SSDs, full use of available space causes speed and durability problems.
> >
> > bcahe uses all the available space in the cache device?
> >
> > I could not find information on the maximum space used or how to set it.
>
> There's no option for that in bcache. Instead, create a smaller
> partition for bcache, then create a second partition filling the rest
> of the device. You may want to use a size ratio of 80:20 for these
> partitions tho modern drives usually already have an internal reserve
> area, so 90:10 may be fine, too.
>
> Now, use the blkdiscard command to trim the second partition. That way
> the SSD knows that this is unused space it can use for wear leveling.
> You may remove this second partition if you want to. In either case,
> don't write anything to this space in the future.
>
> Now continue to install bcache to the first partition created.
>
> I've never seen any performance or endurance gains here using modern
> Samsung drives so I've gone with using 100% for bcache. But my older
> smaller drives had seen a benefit (usually better performance than
> better lifetime) from using 80:20 or 90:10. So I'd say the bigger the
> drive, the less likely you need to reserve any trimmed space.
>
> So currently I'm using a hybrid approach and made the second partition
> into a big swap partition: Most of it will stay trimmed but if the
> system has to swap, it will at least find fast swap space here, and it
> can be used for cold hibernation. You should not do that, tho, if your
> system is low on memory: Swap isn't meant as emergency memory, and it
> isn't meant as an extension to installed RAM. It's a space where the
> system can put anonymous memory that's never used to make space for
> disk caching. Only in that case, it's hardly ever written to or read
> from.
>
> Regards,
> Kai
