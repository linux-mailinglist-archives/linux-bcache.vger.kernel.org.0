Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B521353988
	for <lists+linux-bcache@lfdr.de>; Sun,  4 Apr 2021 21:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhDDTmI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 4 Apr 2021 15:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhDDTmG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 4 Apr 2021 15:42:06 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BA7C061756
        for <linux-bcache@vger.kernel.org>; Sun,  4 Apr 2021 12:42:00 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c3so9843614qkc.5
        for <linux-bcache@vger.kernel.org>; Sun, 04 Apr 2021 12:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dMLhR+aP0iV1lpMRRjVJynM5v+M9IqApQfb4HErFX9E=;
        b=Tg2YBWNa5Gv3GmpTIgUXoPzxDA3CEfs2qhRo5fcmjKa4OjLAgr/1KeiFGqDii/sslF
         F1wiH6YgEdR8H0Rzem8Z/sX3kkfLneOqs10eWqBWPOc7D/i0dfFe+5mT+bp5koyhc8uG
         grRikfYLs4YPNSm5ojmOrSsLyrLcyP0IthJn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dMLhR+aP0iV1lpMRRjVJynM5v+M9IqApQfb4HErFX9E=;
        b=W+g3d/aC+vbMk92Eow5uuUHZSlru+Pk/S1HSkT0c7zhEzSHBsZd+ZU8tdmXM39SRwH
         E9CzgFwolO6Gmvaavowc+7T9dRmjuBjUqAzjEhhmQQKRbcVv3NaGclPtscMz2PD87CZ8
         tNylskvkJae1eo3Y8iNmu4gDYiUfxxVzmm5SbEP7hU5/t4cJugaMU/zuOUK+NrTruBpr
         wMB57szQo8AtzA5PsSgVKpXW6TSOSVc2EnyODjzpPIt01np/zAYIsr0SQ+jS2Vfm1oia
         OswXON3M8VF8f9a+HenQ140eFJ7bGIHNi7Jg9Perl8sUdz6qstMxWiQgaLrbdu1DipLR
         Zx0A==
X-Gm-Message-State: AOAM531oKGjg/0I352am077d+XJfh+PTO/lFN/yNEfzmUUVTMaSNLJ5e
        z2g2hsK/HXINxxEHZYHzc2O4lW6qwKswuvAiDbPqBF3/vQEFeg==
X-Google-Smtp-Source: ABdhPJyvuLVBsobdHmPaSwtmeSSaLzydnjrCWtEqazgdpIK4PIt2CE4cHvtvjURI1Pyo1IBz59i9FDzT78bffjJ8EGY=
X-Received: by 2002:a05:620a:1650:: with SMTP id c16mr21600812qko.477.1617565319886;
 Sun, 04 Apr 2021 12:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <4639704.31r3eYUQgx@exnet.gdb.it>
In-Reply-To: <4639704.31r3eYUQgx@exnet.gdb.it>
From:   Kai Krakow <kai@kaishome.de>
Date:   Sun, 4 Apr 2021 21:41:48 +0200
Message-ID: <CAC2ZOYsWXUQ+AtQkoXXx50_XSQGMx9xBrgFNP7k0Mt8c79XMcQ@mail.gmail.com>
Subject: Re: [CACHE DEVICE] Space usage
To:     Giuseppe Della Bianca <giusdbg@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi!

Am So., 4. Apr. 2021 um 18:23 Uhr schrieb Giuseppe Della Bianca
<giusdbg@gmail.com>:
> In SSDs, full use of available space causes speed and durability problems.
>
> bcahe uses all the available space in the cache device?
>
> I could not find information on the maximum space used or how to set it.

There's no option for that in bcache. Instead, create a smaller
partition for bcache, then create a second partition filling the rest
of the device. You may want to use a size ratio of 80:20 for these
partitions tho modern drives usually already have an internal reserve
area, so 90:10 may be fine, too.

Now, use the blkdiscard command to trim the second partition. That way
the SSD knows that this is unused space it can use for wear leveling.
You may remove this second partition if you want to. In either case,
don't write anything to this space in the future.

Now continue to install bcache to the first partition created.

I've never seen any performance or endurance gains here using modern
Samsung drives so I've gone with using 100% for bcache. But my older
smaller drives had seen a benefit (usually better performance than
better lifetime) from using 80:20 or 90:10. So I'd say the bigger the
drive, the less likely you need to reserve any trimmed space.

So currently I'm using a hybrid approach and made the second partition
into a big swap partition: Most of it will stay trimmed but if the
system has to swap, it will at least find fast swap space here, and it
can be used for cold hibernation. You should not do that, tho, if your
system is low on memory: Swap isn't meant as emergency memory, and it
isn't meant as an extension to installed RAM. It's a space where the
system can put anonymous memory that's never used to make space for
disk caching. Only in that case, it's hardly ever written to or read
from.

Regards,
Kai
