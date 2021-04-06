Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C085355371
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Apr 2021 14:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243176AbhDFMQv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Apr 2021 08:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhDFMQu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Apr 2021 08:16:50 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2554BC06174A
        for <linux-bcache@vger.kernel.org>; Tue,  6 Apr 2021 05:16:43 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id k27so3144985vki.2
        for <linux-bcache@vger.kernel.org>; Tue, 06 Apr 2021 05:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j5cRRJRWcSsIN89DybXnBQXl7qpwwmnd97o5ThMX9Ro=;
        b=IUGQh0lXhfeZ6ikwK1psjV85MHlVMfxYVgG2nvTOlUYVhRQZ2pGTuZvE7yg/3Divjf
         R7m5wKqPgNvoWHm4LT7HSmH1y/ZOJ0seHkvH99rthgGW/vir1uDCOGUCwmkaa+Gif+hg
         fV8oZ2FK854h9XE3ICWK1uwtXv/3AcrclO62h7i9BSYNLM6zfYaaaX+rq/nQ8Sa1i0H6
         35N9r0Xu5WYsE/BMtqp5mQZj5LPqCDREwF4DQIKjQY3yfxLuM9h56HLw/xGpbpfpQCze
         X/Qbwi9BTwmbzIR2le+EKO2F+rtuRq6MYRp6uIq/Y6ijxjTo8rj8Ibu6z1nH+t94jRjv
         RZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j5cRRJRWcSsIN89DybXnBQXl7qpwwmnd97o5ThMX9Ro=;
        b=sC8MRcNdkBIGyfKVJVUgOFTEl7XdotLOVZWNnCwa0vmF+7E5qE+QHZFm68RdBy3zTX
         2rY26ZewvwePFfWUkY9Qww2M7Je4MZ3Ix7dSAbYzlu/hUhl22xszYVkCWO+M/3icgDIN
         7afwV2y/mqjetx9ZDBqjDxs44wkMsuPOx2nxolG3GwVBi7NoSPWukHKnt4FJ9uVlq6XM
         2zB8KAGiUxOO6UURpTtZsIIZgcuqygtFnP/GnoLWbRasJkw00Y6JIgO4ZBuqWEZvOMo7
         z/s+pLFS6IBDVNaT4KvGrdqhI4mFyczj/tC9OkCGWWnCaUXir8Np37STCT2vEvfARqjJ
         7QBA==
X-Gm-Message-State: AOAM532b/GoRLkdAz3kkmiicegespqff6aiRRsY2DiJarHYiwcvCUZ0v
        azeF0KBRr9hw/OdXv5EHHdTiZb52B6a2quA2li4=
X-Google-Smtp-Source: ABdhPJzhkRZJu2QFkqxS9b+fjqA5jUPPSGoawk2w3UDIxN4/+gzh3pWDW3fL2HQG1BFGl0XPzySPplV5TvA2e8a16n4=
X-Received: by 2002:ac5:c93a:: with SMTP id u26mr16421371vkl.17.1617711402103;
 Tue, 06 Apr 2021 05:16:42 -0700 (PDT)
MIME-Version: 1.0
References: <3030cad3-47e2-43b0-8a82-656c6b774c78@www.fastmail.com>
 <bcfeb53d-b8b0-883a-7a02-90b44b23f4dd@suse.de> <397bddb7-9750-4dd9-bf6e-2287d89778f1@www.fastmail.com>
In-Reply-To: <397bddb7-9750-4dd9-bf6e-2287d89778f1@www.fastmail.com>
From:   Marc Smith <msmith626@gmail.com>
Date:   Tue, 6 Apr 2021 08:16:31 -0400
Message-ID: <CAH6h+hfN=L+DKGAZv9TUUNmFF4jHzyEeo=9Tr7rw5haLeM3CMQ@mail.gmail.com>
Subject: Re: Undoing an "Auto-Stop" when Cache device has recovered?
To:     Nikolaus Rath <nikolaus@rath.org>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Mar 25, 2021 at 2:18 AM Nikolaus Rath <nikolaus@rath.org> wrote:
>
>
> On Thu, 25 Mar 2021, at 05:29, Coly Li wrote:
> > On 3/25/21 4:21 AM, Nikolaus Rath wrote:
> > > Hello,
> > >
> > > My (writeback enabled) bcache cache device had a temporary failure, b=
ut seems to have fully recovered (it may have been overheating or a loose c=
able).
> > >
> > > From the last kernel messages, it seems that bcache tried to flush th=
e dirty data, but failed, and then stopped the cache device.
> > >
> > > After a reboot, the bcacheX device indeed no longer has an associated=
 cache set..
> > >
> > > I think in my case the cache device is in perfect shape again and sti=
ll has all the data, so I would really like bcache to attach it again so th=
at the dirty cache data is not lost.
> > >
> > > Is there a way to do that?
> > >
> > > (Yes, I will still replace the device afterwards)
> > >
> > > (I am pretty sure that just re-attaching the cacheset will make bcach=
e forget that there was a previous association and will wipe the correspond=
ing metadata).
> > >
> >
> > Hi Nikolaus,
> >
> > Do you have the kernel log? It depends on whether the cache set is clea=
n
> > or not. For a clear cache set, the cache set is detached, and next
> > reattach will invalidate all existing cached data. If the cache set is
> > dirty and all existing data is wiped, that will be fishy....
>
> Hi Cody,
>
> I'm not sure I understand. I believe there is dirty data on the cacheset =
(it was effectively disconnected in the middle of operations). Also, if it =
wasn't dirty then there would be no need to re-attach it (all the important=
 data would be on the backing device).
>
> On the other hand, after a reboot the cache set shows up in /sys/fs/bcach=
e - just not associated with any backing device. So I guess from that point=
 of view it is clean?

I actually have experienced very similar behavior with a transient
cache device failure (it's not totally dead) and just posted here
recently: https://marc.info/?l=3Dlinux-bcache&m=3D161642940714578&w=3D1

My thought was to use "panic" in the 'errors' sysfs attribute so the
machine panics instead of detaching the cache device. Otherwise, it
seems the cache device gets detached with dirty data present, and the
backing device is started (yet data is not present).

I'll work on reproducing the original case with the "unregister" value
and provide logs, as it sounds like this behavior is unexpected (eg, a
cache device should only detach if there is NO dirty data present).

--Marc

>
> The kernel logs are on the affected bcache, and I have avoided doing anyt=
hing with it (including mounting). I took a few pictures of the last visibl=
e messages on the console before re-booting though. For example, here is wh=
en the problem starts
>
> First ATA errors: https://drive.google.com/file/d/1_vr-JBWZjajzbWyXUSmtn4=
faNH6072ut/view?usp=3Dsharing
> First bcache errors: https://drive.google.com/file/d/1XLCWDi6G2lP1JiVitZT=
tIqzB4QqxXv2-/view?usp=3Dsharing
>
> Does that help?
>
> Best,
> -Nikolaus
>
> --
> GPG Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F
>
>              =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
