Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F1C25D8AD
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Sep 2020 14:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIDMdx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Sep 2020 08:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728588AbgIDMdq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Sep 2020 08:33:46 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D821AC061244
        for <linux-bcache@vger.kernel.org>; Fri,  4 Sep 2020 05:33:42 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id nw23so8384552ejb.4
        for <linux-bcache@vger.kernel.org>; Fri, 04 Sep 2020 05:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MaN+T0Dgpo26Vfv8AG4N5QnFQ7fes2ZEDCtIHh8czzI=;
        b=OVYpcrFTze/IX8Wwrp2UVd5vxNu+fWbneleMBkBVvnAeIYWD+9MjkI2cF854ZfOJuS
         SmHN1TkUw8NKT8xNdd2vRc6nAnvYZQ9cth+zWrd5Aa8qfTXFpvnw7OAhA9rdYsg1aHmJ
         SgkERoE8WCcJtj3LXivEs0jLCYGYymccs+ctIj+pxSb4r1dw+hPggbkrKP0x9UuTQ94k
         v6tfoQc4cC/NDp8zo9Dp6ZVrJ5TVpbG47GdFIq2/+ptW33eIwXvSFnatnb4DVYHsjvU6
         GKY766FRax+v26GID8Jikxzb9UCIYOouhKH87YvbPtRnXroB+T3E8j2F086rGYgQ31Lw
         bAUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MaN+T0Dgpo26Vfv8AG4N5QnFQ7fes2ZEDCtIHh8czzI=;
        b=tDjZrzItjvPMH3sWofQrschxJ6NqhDMkFF0+b0RCRTBg1pxo32gN0BS1/Dat+WVEMp
         abdMyXUNi+sEQlam7C5f388+OAcaPVUWx91VJUfF6jTuIgytUvoVgY0lI82b5+me/M15
         g5V60QLxSK0vCFkzAzyFkFSa/rbT/HI6N/yNG/lUslnokbitHdxwrzeHE89A8X0ToTHW
         VmctFAS7qP+GsWu85pADHkeB7oKb96/YplOLNBt41AM3QFTdFLBlBqk1Txw/H90KPXYi
         sjBQU7BdBr1BQMVl+lb8dYKrAECXGv8qxdOumiax8YXj92tX3bzyhISoui6AezchQHvD
         QdHQ==
X-Gm-Message-State: AOAM532Kvj6oE6xWE2Itk4I1+p9gd1L5uiha5QWwX5Awl517Rljimz/m
        VL/2DhmaV51tr6YH7LR14Lu0tL53EETH5VWHP5U=
X-Google-Smtp-Source: ABdhPJzsiY9jAnwvW7oKe2uynztPgb4rlqX1wiCAjR3eDcIyPwCTADSXzS+EqcJe6Al0+380Av3pvlJD3nxjkJMX/0k=
X-Received: by 2002:a17:906:fcc7:: with SMTP id qx7mr7615007ejb.254.1599222821435;
 Fri, 04 Sep 2020 05:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAKkfZL0FR=PX5roCpB9HQe5=F6T70F7+8EFL_yTZPEbqWWHKPA@mail.gmail.com>
 <CAO9xwp3hniUNqVj14=TpZAoQMjA5v_BOSENcj423_qRqps5H5w@mail.gmail.com>
In-Reply-To: <CAO9xwp3hniUNqVj14=TpZAoQMjA5v_BOSENcj423_qRqps5H5w@mail.gmail.com>
From:   Brendan Boerner <bboerner.biz@gmail.com>
Date:   Fri, 4 Sep 2020 07:33:29 -0500
Message-ID: <CAKkfZL2DRqg-gv-vEqGSB0RabV-ggHDAeKgJf7DQXNJzwzH0vg@mail.gmail.com>
Subject: Re: Bcache in Ubuntu 18.04 kernel panic
To:     Mauricio Oliveira <mauricio.oliveira@canonical.com>,
        bcache@mfedv.net
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Thank you Matthias and Mauricio for your replies and guidance.

Since I'm not exactly sure it's the same bug I'll open a ticket.

Fwiw mine occurred while rsyncing a large (approx 1.4T) home dir from
an XFS w/no bcache to an XFS on bcache which didn't have a cache set
e.g.  make-bcache -B /dev/vg-bfd02/t3home_bc and not attach a cache
set. With between 100-200GB remaining kernel panic.

I also encountered it with a larger (~2.5T) rsnapshot tree.

I did not encounter it when rsyncing 4.3T tree containing zip files
ranging from 10s of MBs to approx 2GB.

The bcache device was available after reboot and I was able to finish
the rsync.

The obvious workaround was to always ensure the bcache dev is attached
to a cache set. With that configuration full rsyncs completed as
expected.

Regards,
Brendan

On Wed, Sep 2, 2020 at 10:37 AM Mauricio Oliveira
<mauricio.oliveira@canonical.com> wrote:
>
> Hi Brendan,
>
> The correct place for Ubuntu bugs is Launchpad, initially.
> (It might be the case that it turns out to be an upstream/not
> Ubuntu-specific bug, but we'll go from there.)
>
> As Matthias mentioned, recently the patch for the non-512/4k block size
> (which was an upstream issue, actually) has been released to Ubuntu
> 18.04 4.15-based kernel.
>
> You can check if your stack trace is listed in LP#1867916 [1], for example.
> And/or test whether the newer kernel version with its fix addresses your issue.
>
> If not, please click 'Report a bug' against the 'linux' package in [2].
>
> Hope this helps,
>
> [1] https://bugs.launchpad.net/bugs/1867916
> [2] https://launchpad.net/ubuntu/
>
> On Tue, Sep 1, 2020 at 5:43 PM Brendan Boerner <bboerner.biz@gmail.com> wrote:
> >
> > Hi,
> >
> > I spent the weekend verifying and isolating a kernel panic in bcache
> > on Ubuntu 18.04 (4.15.0-112-generic #113-Ubuntu SMP Thu Jul 9 23:41:39
> > UTC 2020).
> >
> > Is this the place to report it? I have kernel crash dumps.
> >
> > Thanks!
> > Brendan
>
>
>
> --
> Mauricio Faria de Oliveira
