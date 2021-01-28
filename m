Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840F630736F
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jan 2021 11:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhA1KKQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 05:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbhA1KKI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 05:10:08 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2099FC061573
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 02:09:28 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id h21so2505258qvb.8
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 02:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sGB7ryjbXLkQduBYek9fsCh9WrkOkBjJkxgDruP6hs0=;
        b=WJkhmpNdph1A7yG3Asn79OlHMpel0LxmSOMSUezW5of6izZ0NDLuzRfo9SwHvQJIKv
         SEWlSUTVB74aL31U/+kNz5XWKMuz8m8JnaeglqdIfzrdKsTmp/Bj9NNYn01/u6F44uoX
         LQAeAv5BOxskSRgfWwHfCMyxUtfrhZTLIMRZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sGB7ryjbXLkQduBYek9fsCh9WrkOkBjJkxgDruP6hs0=;
        b=Dd54FE6VljH7fucFxp2dI9OS5VbcDZ41kkvFpCdjZ7lVALZ6W0g6xKADXE1NiV0T/x
         kZTeUFKqWCnIFRjMi+qWwObyNehAEedzNcNC/w1HIbE201Z6x7PB1MPigx+8wiDqIz2Y
         g7T3NmmTlh1nUMJm2dALBrjeYn5EwkTeG79JW5yg6lj/ju64Mm9sF6qJ6sn6hOoiYJFG
         zMkhCYvUiA6StYth0HkgzTVZlS71VNhkSwyEtZLmQ2LN19wqt/KbHkbqj+kerhS7OU00
         08Qb2lp8JCF1szUKD3oQoo2zCWmlPuuKfT+9Sh3pyNx0RNltbNJcE1gdSmtCTb19W42M
         CHhQ==
X-Gm-Message-State: AOAM530kTj/02ZyrXxwq1YX3vK67uLuJrb6RpkyEx7UjgR7khuhqFsXO
        /QmFCRyb8PzHXVvfzwjkEoxgOPKRBTekdlN+6Ku/nA==
X-Google-Smtp-Source: ABdhPJwDzq4eV0Oj0ZaCXacO1KpNZ5WdoEDR2ptAgstD3dy5+SV8Of0Xa7Ht8z45Y3enAeqGpz/Gwr98hQ0wczczksk=
X-Received: by 2002:a0c:c687:: with SMTP id d7mr14480374qvj.17.1611828567348;
 Thu, 28 Jan 2021 02:09:27 -0800 (PST)
MIME-Version: 1.0
References: <20210127132350.557935-1-kai@kaishome.de>
In-Reply-To: <20210127132350.557935-1-kai@kaishome.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Thu, 28 Jan 2021 11:09:16 +0100
Message-ID: <CAC2ZOYtrrOXD35ZWLer8R8n1dcyqGi_dipHp+y1JNt_eaue_9A@mail.gmail.com>
Subject: Re: Fix degraded system performance due to workqueue overload
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Kent!

Any objections about the following patches? Coly wanted to wait for
your confirmation.

Thanks.

Am Mi., 27. Jan. 2021 um 14:24 Uhr schrieb Kai Krakow <kai@kaishome.de>:
>
> In the past months (and looking back, even years), I was seeing system
> performance and latency degrading vastly when bcache is active.
>
> Finally, with kernel 5.10, I was able to locate the problem:
>
> [250336.887598] BUG: workqueue lockup - pool cpus=2 node=0 flags=0x0 nice=0 stuck for 72s!
> [250336.887606] Showing busy workqueues and worker pools:
> [250336.887607] workqueue events: flags=0x0
> [250336.887608]   pwq 10: cpus=5 node=0 flags=0x0 nice=0 active=3/256 refcnt=4
> [250336.887611]     pending: psi_avgs_work, psi_avgs_work, psi_avgs_work
> [250336.887619]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=15/256 refcnt=16
> [250336.887621]     in-flight: 3760137:psi_avgs_work
> [250336.887624]     pending: psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work
> [250336.887637]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
> [250336.887639]     pending: psi_avgs_work
> [250336.887643] workqueue events_power_efficient: flags=0x80
> [250336.887644]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
> [250336.887646]     pending: do_cache_clean
> [250336.887651] workqueue mm_percpu_wq: flags=0x8
> [250336.887651]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=2/256 refcnt=4
> [250336.887653]     pending: lru_add_drain_per_cpu BAR(60), vmstat_update
> [250336.887666] workqueue bcache: flags=0x8
> [250336.887667]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
> [250336.887668]     pending: cached_dev_nodata
> [250336.887681] pool 4: cpus=2 node=0 flags=0x0 nice=0 hung=72s workers=2 idle: 3760136
>
> I was able to track that back to the following commit:
> 56b30770b27d54d68ad51eccc6d888282b568cee ("bcache: Kill btree_io_wq")
>
> Reverting that commit (with some adjustments due to later code changes)
> improved my desktop latency a lot, I mean really a lot. The system was
> finally able to handle somewhat higher loads without stalling for
> several seconds and without spiking load into the hundreds while doing a
> lot of write IO.
>
> So I dug a little deeper and found that the assumption of this old
> commit may no longer be true and bcache simply overwhelms the system_wq
> with too many or too long running workers. This should really only be
> used for workers that can do their work almost instantly, and it should
> not be spammed with a lot of workers which bcache seems to do (look at
> how many kthreads it creates from workers):
>
> # ps aux | grep 'kworker/.*bc' | wc -l
> 131
>
> And this is with a mostly idle system, it may easily reach 700+. Also,
> with my patches in place, that number seems to be overall lower.
>
> So I added another commit (patch 2) to move another worker queue over
> to a dedicated worker queue ("bcache: Move journal work to new
> background wq").
>
> I tested this by overloading my desktop system with the following
> parallel load:
>
>   * A big download at 1 Gbit/s, resulting in 60+ MB/s write
>   * Active IPFS daemon
>   * Watching a YouTube video
>   * Fully syncing 4 IMAP accounts with MailSpring
>   * Running a Gentoo system update (compiling packages)
>   * Browsing the web
>   * Running a Windows VM (Qemu) with Outlook and defragmentation
>   * Starting and closing several applications and clicking in them
>
> IO setup: 4x HDD (2+2+4+4 TB) btrfs RAID-0 with 850 GB SSD bcache
> Kernel 5.10.10
>
> Without the patches, the system would have come to a stop, probably not
> recovering from it (last time I tried, a clean shutdown took 1+ hour).
> With the patches, the system easily survives and feels overall smooth
> with only a small perceivable lag.
>
> Boot times are more consistent, too, and faster when bcache is mostly
> cold due to a previous system update.
>
> Write rates of the system are more smooth now, and can easily sustain a
> constant load of 200-300 MB/s while previously I would see long stalls
> followed by vastly reduces write performance (down to 5-20 MB/s).
>
> I'm not sure if there are side-effects of my patches that I cannot know
> of but it works great for me: All write-related desktop stalling is
> gone.
>
> --
> Regards,
> Kai
>
>
