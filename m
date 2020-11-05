Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFA12A810B
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Nov 2020 15:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbgKEOgI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Nov 2020 09:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgKEOgI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Nov 2020 09:36:08 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0187BC0613CF;
        Thu,  5 Nov 2020 06:36:08 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id b3so887127vsc.5;
        Thu, 05 Nov 2020 06:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e6FZfgNltS8LHqafeymHjSnUqkGPEBNzljEgVx0yVKw=;
        b=BxrvL/xbyD783kok4uqCYc27JoHX44Em1tyPrztMEiiNA1crlRy09Ufw8girnFcGaQ
         FNSbgo2uqf8MfGA9fF0sgLKKMFYCYTHgl4ms2bSxZcL1xU/lbZGuizRxYb9bF4B8kgx1
         xbKgBYkMcg6nxA2sJsjqpUGTP6OG1u82JCFeyEsTJkxKfnU9VlWSOAfQwuTbBgpS5n3I
         8qnDW9o/vjOstKxUU2eD8NtSgnGqj5/SXVPeSSxPPLlDbace+p0xYS9bQve47QviW6+1
         MUjy2QSNR5vnxJp6CYB6Eki/GoEb56RUHtGH62QuBCvkH9CICqWgFeIZbIcJBEwVq2Wt
         Ht6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e6FZfgNltS8LHqafeymHjSnUqkGPEBNzljEgVx0yVKw=;
        b=RmNR9ApRonbIuCe4jyJL+HFJILN3rjfI6q72wBDwsf0VhswIwcBhBVNXOVrHhM3JnG
         eXMikyssdtgVdrB9K4lbmIVJzvuBEbW8eCJKLENdLpj41f+H9nbkf3gXt/h9mcVIdW5Y
         pA2h0/30fKUFDibrYDMvcoYKeNwV8+IEXD1sDMwcugr1WhkzxZBZ6fP/Mx6adg642MPR
         v/rlootyoWA4U4nCBoCQiWnbalXXo2rV9fRguzqrSI1N1DgS1GPQK7QCUZBUII9B9uR8
         TUsdRThdUV16JpWv8VROuRS9bJvRtXKPLDenFq8gFCoRMmwta+HQnrEm63YLHPxVusqp
         +d/w==
X-Gm-Message-State: AOAM531G/kSQbcIZJcsstnS/V/c7ZsZddrI2GiomtQuR+TjWDHasucmm
        IP55cM3AW/Oa0M/guDjEcYNGfzzjyp926v2BlAE=
X-Google-Smtp-Source: ABdhPJwVG3ykpy3ylK6m6Mn3dboiKHHeBejWegB4UMkBdG43JZfWpGvz232/3/8D7gO2ZhX8tsmoNMsWQAivNMyrqVk=
X-Received: by 2002:a67:774c:: with SMTP id s73mr1524975vsc.1.1604586967123;
 Thu, 05 Nov 2020 06:36:07 -0800 (PST)
MIME-Version: 1.0
References: <20201105141939.9223-1-tdd21151186@gmail.com> <14dd22de-030e-c7af-494b-a4317afeb795@suse.de>
In-Reply-To: <14dd22de-030e-c7af-494b-a4317afeb795@suse.de>
From:   =?UTF-8?B?6Zm25Yas5Yas?= <tdd21151186@gmail.com>
Date:   Thu, 5 Nov 2020 22:35:55 +0800
Message-ID: <CAJ6dUx6O2a4YJvzQ052h9eZWAOSPSSofe6O2GN6kw-ACPmkrHQ@mail.gmail.com>
Subject: Re: [PATCH] bcache: make writeback_cutoff and writeback_cutoff_sync writeable
To:     Coly Li <colyli@suse.de>
Cc:     dongdong tao <dongdong.tao@canonical.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Ah, I missed the second part, only saw the first paragraph.
But I kind of hope it can be configurable :)
Anyway, thanks for the clarification.

Coly Li <colyli@suse.de> =E4=BA=8E2020=E5=B9=B411=E6=9C=885=E6=97=A5=E5=91=
=A8=E5=9B=9B =E4=B8=8B=E5=8D=8810:23=E5=86=99=E9=81=93=EF=BC=9A
>
> On 2020/11/5 22:19, Dongdong Tao wrote:
> > From: dongdong tao <dongdong.tao@canonical.com>
> >
> > commit 9aaf51654672 ("bcache: make cutoff_writeback and
> > cutoff_writeback_sync tunable") intend to make these two option
> > configurable by user, but these two are still read-only.
> >
> > Signed-off-by: dongdong tao <dongdong.tao@canonical.com>
> > ---
> >  drivers/md/bcache/sysfs.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> > index 554e3afc9b68..81f4a681705c 100644
> > --- a/drivers/md/bcache/sysfs.c
> > +++ b/drivers/md/bcache/sysfs.c
> > @@ -102,8 +102,8 @@ read_attribute(writeback_keys_done);
> >  read_attribute(writeback_keys_failed);
> >  read_attribute(io_errors);
> >  read_attribute(congested);
> > -read_attribute(cutoff_writeback);
> > -read_attribute(cutoff_writeback_sync);
> > +rw_attribute(cutoff_writeback);
> > +rw_attribute(cutoff_writeback_sync);
> >  rw_attribute(congested_read_threshold_us);
> >  rw_attribute(congested_write_threshold_us);
> >
> > @@ -902,6 +902,8 @@ STORE(__bch_cache_set)
> >       sysfs_strtoul_bool(copy_gc_enabled,     c->copy_gc_enabled);
> >       sysfs_strtoul_bool(idle_max_writeback_rate,
> >                          c->idle_max_writeback_rate_enabled);
> > +     sysfs_strtoul_clamp(cutoff_writeback, bch_cutoff_writeback, 1, 10=
0);
> > +     sysfs_strtoul_clamp(cutoff_writeback_sync, bch_cutoff_writeback_s=
ync, 1, 100);
> >
>
> NACK, we only support the default value. Commit 9aaf51654672 ("bcache:
> make cutoff_writeback and cutoff_writeback_sync tunable") clearly
> announced the purpose was for research and experiment.
>
> Coly Li
