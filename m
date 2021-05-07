Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A05137674F
	for <lists+linux-bcache@lfdr.de>; Fri,  7 May 2021 16:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhEGO5k (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 May 2021 10:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbhEGO5k (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 May 2021 10:57:40 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4051AC061574
        for <linux-bcache@vger.kernel.org>; Fri,  7 May 2021 07:56:39 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id k127so8680714qkc.6
        for <linux-bcache@vger.kernel.org>; Fri, 07 May 2021 07:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNwS0W/JFFuzSa0gBJNxcWZaTa+oXWHUZo15hurqYj4=;
        b=K4+zw2ImqCmzfLlNHf8AAM0TA6lQIJ39/vE+NNPbzHfqYFI/FNmpo4l4rfZczVVBBU
         vuN8wGc2A510Kxw8klgZ92wZWpI/rfgVAYIyQssQILMOBmZWvJJkH6qYu7ToRy5A35Oi
         qtIM4qkJmyt3K8xtf2OQJ0JP09PDnCufs/JXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNwS0W/JFFuzSa0gBJNxcWZaTa+oXWHUZo15hurqYj4=;
        b=HDJgpxgMi+2d/jAXLciXMnGXZfabvW6SYMYiemfoomgsEzAbrRuz74lzB/bDgfu6PU
         Td0xJM2v81uN9L2RC5j67D1m5ZPEOlCjv6ma5pWmyIEfs5AvgWVTZgoGCN+LI4wDs0Wz
         PlSkO51WYRrxVbVEl4fU5Ldr+6NYRra4lKqKzW7tzTzMdAFoNMdAZEhRs7PpbR8bccEh
         KvVcF3abWAiDD7g0v+cvYLduvf/k4yCQ2U/30MI1D6RhoUMhsU7FGZwHavunKTWVWNiT
         aqH2eMOJ6ztzW9o+CpxAWngTypgiLVhhH4/M7tfA4TS55jWpsympYYV5NSWx3PUZIx5Y
         ZiTw==
X-Gm-Message-State: AOAM532iWO4EQnUH7f/t8m35+0VM0VlIwfwbZVfqeYiul8ECNC/CCmKd
        TnP7vMhgYvNMiF4mdn4MZuM994tFs6T1EOAfbwnnYA==
X-Google-Smtp-Source: ABdhPJyRlsu5KxzAZNNAyd+EXxEdhmdOrY850xo/RMGassbb2kEIlJR+Nt1TzWmD0SlNhI2uXdD8ti++SCb1RZRX+pw=
X-Received: by 2002:a37:a042:: with SMTP id j63mr10009683qke.477.1620399398389;
 Fri, 07 May 2021 07:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
 <CAC2ZOYugQAw9NbMk_oo_2iC5GsZUN=uTO5FuvdRTMy9M6ASNEg@mail.gmail.com>
 <CAC2ZOYtg4P_CYrTH6kQM1vCuU4Bai7v8K3Nmu3Yz7fNuHfEnRw@mail.gmail.com>
 <CAC2ZOYuBhFbpZeRnnc-1-Vt-tV_3iwkf3i21+YjVukYkx7J7YQ@mail.gmail.com> <70b9cdd0-ace9-9ee7-19c7-5c47a4d2fce9@suse.de>
In-Reply-To: <70b9cdd0-ace9-9ee7-19c7-5c47a4d2fce9@suse.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Fri, 7 May 2021 16:56:27 +0200
Message-ID: <CAC2ZOYuCLQpD___YBua7yEuuG85+OQ+HiRGDy=FRLS9cgMg4rA@mail.gmail.com>
Subject: Re: Dirty data loss after cache disk error recovery
To:     Coly Li <colyli@suse.de>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo/lt54p?= 
        <wubenqing@ruijie.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi!

> There is an option to panic the system when cache device failed. It is
> in errors file with available options as "unregister" and "panic". This
> option is default set to "unregister", if you set it to "panic" then
> panic() will be called.

Hmm, okay, I didn't find "panic" documented somewhere. I'll take a
look at it again. If it's missing, I'll create a patch to improve
documentation.

> If the cache set is attached, read-only the bcache device does not
> prevent the meta data I/O on cache device (when try to cache the reading
> data), if the cache device is really disconnected that will be
> problematic too.

I didn't completely understand the sentence, it seems to miss a word.
But whatever it is, it's probably true. ;-)

> The "auto" and "always" options are for "unregister" error action. When
> I enhance the device failure handling, I don't add new error action, all
> my work was to make the "unregister" action work better.

But isn't the failure case here that it hits both code paths: The one
that unregisters the device, and the one that then retires the cache?

> Adding a new "stop" error action IMHO doesn't make things better. When
> the cache device is disconnected, it is always risky that some caching
> data or meta data is not updated onto cache device. Permit the cache
> device to be re-attached to the backing device may introduce "silent
> data loss" which might be worse....  It was the reason why I didn't add
> new error action for the device failure handling patch set.

But we are actually now seeing silent data loss: The system f'ed up
somehow, needed a hard reset, and after reboot the bcache device was
accessible in cache mode "none" (because they have been unregistered
before, and because udev just detected it and you can use bcache
without an attached cache in "none" mode), completely hiding the fact
that we lost dirty write-back data, it's even not quite obvious that
/dev/bcache0 now is detached, cache mode none, but accessible
nevertheless. To me, this is quite clearly "silent data loss",
especially since the unregister action threw the dirty data away.

So this:

> Permit the cache
> device to be re-attached to the backing device may introduce "silent
> data loss" which might be worse....

is actually the situation we are facing currently: Device has been
unregistered, after reboot, udev detects it has clean backing device
without cache association, using cache mode none, and it is readable
and writable just fine: It essentially permitted access to the stale
backing device (tho, it didn't re-attach as you outlined, but that's
more or less the same situation).

Maybe devices that become disassociated from a cache due to IO errors
but have dirty data should go to a caching mode "stale", and bcache
should refuse to access such devices or throw away their dirty data
until I decide to force them back online into the cache set or force
discard the dirty data. Then at least I would discover that something
went badly wrong. Otherwise, I may not detect that dirty data wasn't
written. In the best case, that makes my FS unmountable, in the worst
case, some file data is simply lost (aka silent data loss), besides
both situations are the worst-case scenario anyways.

The whole situation probably comes from udev auto-registering bcache
backing devices again, and bcache has no record of why the device was
unregistered - it looks clean after such a situation.

> Sorry I just find this thread from my INBOX. Hope it is not too late.

No worries. ;-)

It was already too late when the dirty cache was discarded but I have
daily backups. My system is up and running again, but it's probably
not a question of IF it happens again but WHEN it does. So I'd like to
discuss how we can get a cleaner fail situation because currently it's
just unclean because every status is lost after reboot, and devices
look clean, and caching mode is simply "none", which is completely
fine for the boot process.

Thanks,
Kai
