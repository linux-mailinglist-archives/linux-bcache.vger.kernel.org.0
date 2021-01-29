Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5FE308A6A
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Jan 2021 17:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhA2Qhw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Jan 2021 11:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhA2QhS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Jan 2021 11:37:18 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59DFC061574
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:36:37 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id l11so4735205qvt.1
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x1+LDnedTkdP/VaRZv1JE4HVdVpfxkFhAFeFPbR3ohc=;
        b=etAOiGx2lXSIFYMbz6VE6TlxM3iz+VKknlL/H1qb93v4D53PwWmPmIBEVRgdgFMhr4
         oLX1d0oMbkQjLIRsjmXBHktxToS3JTG+OOL2MfKp7xlCW3vaSwjUS/nl25r/pLGPmOZM
         ijynSZxZJ9cU1kZ/ErtmZplu5sJDPzx9ltBoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x1+LDnedTkdP/VaRZv1JE4HVdVpfxkFhAFeFPbR3ohc=;
        b=B8OMf14aqASsEJvv1YNzPJzEqq5gFPZwtiZGUCU+bejWSBEw8hP+7gVxlNuSaoxwve
         Qr6q/LvuXwmeVle8tninBfzEP/mWauAYh5z2M0anntHpOzh/G8qEZhKCTj6rR/bTEjoM
         dwj4Ogn66ufYHF4BPewIh4qRJMiSuwZMnznZfbZlMWz9lbprr7ZNFN4FvGi2plwnDU+K
         nOZYD5WYm9F1v/45lmxR/sM48zU0f8vh25HfvPmh7mBsiIEz8KkeJpkvizi4LXpWMl1K
         qgk8azKjzbCM0v48ycTnnba+o7U2v0Hem0wDU250fmsYsCJZQveMaojpOK+UA9MFqk12
         d1hA==
X-Gm-Message-State: AOAM530mIRwCGDRfmhJcJAMIf8c6zX5/n56A7WGCSebW4OpAZfPi+V9Q
        4OZaZR8NGfyf/fMDdZpRFsyxDkDFpBUaDBrN9H5t077jpWU=
X-Google-Smtp-Source: ABdhPJwZZjsDZEZlU+LLA914dSL3JmcUieLMhNFemOU51+NHbvxAHN3XNmM00wFr1KIHhjaGbnCtmJ/M870Ah3ULnyY=
X-Received: by 2002:ad4:4993:: with SMTP id t19mr4593258qvx.41.1611938197086;
 Fri, 29 Jan 2021 08:36:37 -0800 (PST)
MIME-Version: 1.0
References: <20210127132350.557935-1-kai@kaishome.de> <20210128105034.176668-1-kai@kaishome.de>
 <20210128105034.176668-2-kai@kaishome.de> <CAC2ZOYtvMEQDhwdcRJnUwTWyGkmD0vue6V7+B2-3Q5-SoZsyGw@mail.gmail.com>
 <CAC2ZOYuxoh6=vUje8FTKD8=+V_n8a9wO50+ADvH+Vme0NtP4Rg@mail.gmail.com> <988ba514-c607-688b-555d-18fbbb069f48@suse.de>
In-Reply-To: <988ba514-c607-688b-555d-18fbbb069f48@suse.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Fri, 29 Jan 2021 17:36:26 +0100
Message-ID: <CAC2ZOYuhDxYpdYHZaqFSK1ZRoZS9_Mr7ZyNDq+QUtYkUQtKsUw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] bcache: Move journal work to new background wq
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Fr., 29. Jan. 2021 um 17:01 Uhr schrieb Coly Li <colyli@suse.de>:
>
> On 1/29/21 12:41 AM, Kai Krakow wrote:
> >> As far as I understand the code, this would trigger an immediate
> >> journal flush then under memory reclaim because this background wq is
> >> only used to reschedule journal flush some time in the future (100ms?)

> For a typical 1000HZ jiffies, 100ms is extended 1 jiffy by
> msecs_to_jiffies().

Ah, you mean in the sense of lagging at least 1 jiffy behind because
work is dispatched asynchronously?

BTW: I'm using a 300 Hz system for my desktop, that's usually good
enough and maybe even a better choice for 60 Hz applications, as 300
divides easily by typical refresh rates (25, 30, 50, 60). But this is
useful information for the xpadneo driver I'm developing. Thanks.

> >>>         } else if (!w->dirty) {
> >>>                 w->dirty = true;
> >>> -               schedule_delayed_work(&c->journal.work,
> >>> -                                     msecs_to_jiffies(c->journal_delay_ms));
> >>> +               queue_delayed_work(bch_background_wq, &c->journal.work,
> >>> +                                  msecs_to_jiffies(c->journal_delay_ms));
> >>>                 spin_unlock(&c->journal.lock);
> >>>         } else {
> >
> > This would mean we start performing worse under memory reclaim...
>
> A journal write buffer is 8 pages, for 4KB kernel page size, it won't be
> a large occupation.

As far as I can see the called routine would only spawn the actual
writes in a closure anyways. So if this was used for memory reclaim,
effects would lag behind anyways.

Still, I'm seeing a huge difference if this queue gets allocated with
`WQ_MEM_RECLAIM`. It works fine for most filesystems but for btrfs
there are probably at least twice that many outstanding requests.

But I don't think we need to discuss whether it should run under
memory reclaim, when the original implementation using `system_wq`
didn't do that in the first place. I was just curious and wanted to
understand the context better.

I think it's important to design carefully to not have vastly
different behavior whether we had a 100 Hz or a 1000 Hz kernel. For
example, my server builds usually run a 100 Hz kernel.

Thanks,
Kai
