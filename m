Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D016307B3C
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jan 2021 17:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhA1QpJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 11:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbhA1Qm2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 11:42:28 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CBFC0613D6
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 08:41:38 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id a12so5811997qkh.10
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 08:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zVnQgUKBMc9P9AY1rULp32psQue14k2Mx5T9ufYiKFM=;
        b=Ef1QkLaKJ5+AG9eneWFAz9gTq8Mr1eIQXvjdL042Vmki9JSbVbFSNYh5BPqjYELwds
         bNwYIhhUe+lihBKVINtlEBDWCkX+cnCtxE0D7tRRHU40/hMUoe2TTbzXxqsYbMELd+eo
         X4Gv1mblenNwX1GNqw+hXcq4ohwTaiaiNpY1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zVnQgUKBMc9P9AY1rULp32psQue14k2Mx5T9ufYiKFM=;
        b=jOPX534ZyFqBvA5AxykFdmVtHoZK+E0OqguAQaSrHxShdATpDmnnKrQU8efUYoxRUf
         /CW4GvLRROisjcFMfdN9Y/MBgcr7kWFG08JvizwszBZBBsMxYGBkkCqqsOAGE4fEW5Lx
         Y95rzC0ZpnNbDL7+GSFYNDMR5/lBApq0ZZ7KBXgUgCvOaNtdbwjSbO2JdLjuricVwaQW
         qCGFsTnUCvTPqH0kwXpbdDqDlerFC/UO+MzBy1cOBFc72Rvj8Gv39hjGFtwkEPEtSEl/
         vcYpTjpDDhkWqzX/UQEySwGkqT2N78DYsmruqQ0MTj3RRy222OH7EjIY2YepOVNIjW/5
         XZSQ==
X-Gm-Message-State: AOAM5329emWhsO9dqNzWMGdUxK7b8bOVwLkcOIg0ogobN6FN0iRp3POA
        u9DNxKu65Tba7jmTNJugEf9/o6+mKW6Lzv3ti8ivmQ==
X-Google-Smtp-Source: ABdhPJxRDFdSRBKb3U5CZiO5V2nE/yce+UtqCa4+e9F7NDH2PYz01Y15uGa3bcT4lH/u0qEPGNnuawcRG7vbWvo5JAA=
X-Received: by 2002:a37:a692:: with SMTP id p140mr5417qke.37.1611852098289;
 Thu, 28 Jan 2021 08:41:38 -0800 (PST)
MIME-Version: 1.0
References: <20210127132350.557935-1-kai@kaishome.de> <20210128105034.176668-1-kai@kaishome.de>
 <20210128105034.176668-2-kai@kaishome.de> <CAC2ZOYtvMEQDhwdcRJnUwTWyGkmD0vue6V7+B2-3Q5-SoZsyGw@mail.gmail.com>
In-Reply-To: <CAC2ZOYtvMEQDhwdcRJnUwTWyGkmD0vue6V7+B2-3Q5-SoZsyGw@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Thu, 28 Jan 2021 17:41:27 +0100
Message-ID: <CAC2ZOYuxoh6=vUje8FTKD8=+V_n8a9wO50+ADvH+Vme0NtP4Rg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] bcache: Move journal work to new background wq
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> As far as I understand the code, this would trigger an immediate
> journal flush then under memory reclaim because this background wq is
> only used to reschedule journal flush some time in the future (100ms?)
> if there's nothing to write just now:

Thinking about this again, the code looks like it tries to coalesce
journal flushes into windows of 100ms, and the dirty flag is just used
as an indicator to know whether the flush has already been queued. Is
that true?

> >         } else if (!w->dirty) {
> >                 w->dirty = true;
> > -               schedule_delayed_work(&c->journal.work,
> > -                                     msecs_to_jiffies(c->journal_delay_ms));
> > +               queue_delayed_work(bch_background_wq, &c->journal.work,
> > +                                  msecs_to_jiffies(c->journal_delay_ms));
> >                 spin_unlock(&c->journal.lock);
> >         } else {

This would mean we start performing worse under memory reclaim...

Thanks,
Kai
