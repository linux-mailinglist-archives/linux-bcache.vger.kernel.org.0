Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548345533B3
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Jun 2022 15:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiFUNhR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 Jun 2022 09:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351725AbiFUNgg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Jun 2022 09:36:36 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDA32C667
        for <linux-bcache@vger.kernel.org>; Tue, 21 Jun 2022 06:35:26 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id a11so6683746ljb.5
        for <linux-bcache@vger.kernel.org>; Tue, 21 Jun 2022 06:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yvQLHKM/e6aBQcYbdqWGviuWykyEBB71TmZli3nxLAU=;
        b=N0v1D6LMTS6XJS5DVmrPy53L9BbxpEKKfAq9ECI2/Rgmy75Izv8M3bwMGdmkyoghMS
         SOfSrASzwM/wt7qswzhcY0fmPPBLxrlOYnqVtb36nGTpEs7jw0nEqafOzyraTR8GpoWt
         8/WIhF1LhN+Pa9kHEWUWO4uSJe+V8g8Zr8F3YE4oIKQV3TTls0ooSX0aCSWPn38XqVi2
         dEiebA9S9wIW3h+96PPI0F0AsvUtTzCixA+H35ivMcgQv8RcUMXiEK7T/x0ia6nh5/tz
         UHi1KJ0MTlAyYSzEvdbFLOUgzt29ZRL3MU85CozuDQLfzBiBW5Q6r6k+qKwV53unhZ5l
         p3LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yvQLHKM/e6aBQcYbdqWGviuWykyEBB71TmZli3nxLAU=;
        b=I090w/FIMIEja9++rYtbNLihGq7mh7QUOzkc6xwOAWR8gkl0Hld0y44WLRYrHExOEh
         tF7rzBAEGrciShO7EHcHRqKF2Pq+Q5c7JMHTcmEoUKpW+IqlkkkgllSRZR0JnYxyFl8O
         BxXjIPG7rQGUdNyy1iYM9BXr6fW5XKDzMoQCAXuUIXEIiD+peuRS9k25oB9R6zofnvIV
         I2+o9qNvcr5sSumqZ8w9AkDLz9Y85Bwa2p07uLtaPdvoCGpJXXnJBOIiqkZ4EuRfJjC+
         4MQgb59Oka2BaNUiZJOa4aQAjzAxjB0Exo5RlshdFIq+9ysM5Pc3VBAWNvGZ8tOUrR9g
         OMUw==
X-Gm-Message-State: AJIora9ELKZ5lVLVFbo3oON1g9ZyMv0xWFNmu6GEkLcXRZ0sbAMWLEby
        ws6hueveJIkQt/T2JK3QH/Bm8yS3YEClMEUU4+8=
X-Google-Smtp-Source: AGRyM1vpVkSDZW/szg6kjKKAnOj2wm3Hp6YHA1Z5/QNcYq2BuMEibb8VnK2UfSHZKgIoMYnmGGjElXxIb45pJM/6fU0=
X-Received: by 2002:a05:651c:b1f:b0:25a:29ee:fcce with SMTP id
 b31-20020a05651c0b1f00b0025a29eefccemr14714710ljr.113.1655818524580; Tue, 21
 Jun 2022 06:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv1hTHhPdZNOhbSOzQTW+pBfAXfpGkxJfjjBmS8bYaHfZw@mail.gmail.com>
 <20220621043543.zvxgekvcs34abim6@moria.home.lan> <CAC6jXv27xfHQVFTX_U944qSStY=k9WLzPENh-tpBimcA7kms-w@mail.gmail.com>
 <CAC6jXv3Ar-Xb-tGOMQX4PsPc5GSu=7zf_37yWvGkss=HqYfBmw@mail.gmail.com> <44F3206D-9807-4416-9183-A613BEB4A1E2@suse.de>
In-Reply-To: <44F3206D-9807-4416-9183-A613BEB4A1E2@suse.de>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Tue, 21 Jun 2022 19:05:12 +0530
Message-ID: <CAC6jXv0FkOzyRk5aObkCWwWuwyEbDWNY2qvU=VQNrCr9jPx2EA@mail.gmail.com>
Subject: Re: trying to reproduce bcache journal deadlock https://www.spinics.net/lists/kernel/msg4386275.html
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

thanks, so , I will also change uapi/linux/bcache.h SB_JOURNAL_BUCKETS
to 8 but I noted the note in the kernel header file, which said "/*
SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */" which I
think is 32..

As of now I have not built the backported patch into the kernel
(Ubuntu-4.15.0-183.192) which I am simply using to reproduce the
issue. Then I will build the patch into the kernel and verify that the
deadlock isn't ever seen. My problem is simply reproducing it for now
(without the fix compiled in). What I'm trying is (modify
SB_JOURNAL_BUCKETS to 8 both in bcache-tools and kernel, and then
created the bcache device and then filled it up by fio random writes
of about 250 gb data, and then run constantly.. -
https://pastebin.com/Sh3q6fXv .. not a reboot. Do you think in fact a
reboot is needed to reproduce it, and this approach of
de-register/register would not work to see the deadlock?)

Once I reproduce it successfully a few times, I'll compile in the
backported patch and then verify I never see the deadlock again,
that's the best I can do I guess in the circumstances.

Thank you (and to Kent++ for helping me with the backport patch) for
all the help with this! I am very grateful for your help and
responses.

Regards,
Nikhil.

On Tue, 21 Jun 2022 at 18:53, Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2022=E5=B9=B46=E6=9C=8821=E6=97=A5 13:40=EF=BC=8CNikhil Kshirsagar <nks=
hirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > I figured later that you probably meant for me to change the
> > SB_JOURNAL_BUCKETS to 8 in bcache-tools and not the kernel?
> >
> > Regards,
> > Nikhil.
>
>
> Hi Nikhil,
>
> As I said in previous offline email, you should modify both bcache-tool a=
nd kernel code for SB_JOURNAL_BUCKETS, to 8 or 16, and recompile both.
> With the patch it is very hard to reproduce the deadlock (because it is f=
ixed by this patch), you may observe the free journal space in run time and=
 reboot time. If there is alway at least 1 journal bucket reserved during r=
un time, then you won=E2=80=99t observe the journal no-space deadlock in bo=
ot time.
>
> But 4.15 kernel is not robust enough for bcache (5.4+ is good and 5.10+ i=
s better), if you are stucked by other bugs during this testing, it is poss=
ible.
>
> Coly Li
>
>
> >
> > On Tue, 21 Jun 2022 at 11:06, Nikhil Kshirsagar <nkshirsagar@gmail.com>=
 wrote:
> >>
> >> Thank you Kent,
> >>
> >> I've made this change, in include/uapi/linux/bcache.h and will build
> >> the kernel with it to attempt to reproduce the issue, and create a new
> >> bcache device. Just wondering if the note about it being divisible by
> >> BITS_PER_LONG may restrict it to a minimum value of 32?
> >>
> >> #define SB_JOURNAL_BUCKETS              8
> >> /* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
> >>
> >> I have a "cache" nvme disk of about 350 tb and some slow disks, each
> >> approx 300tb  which I will use to create the bcache device once the
> >> kernel is installed. My bcache setup typically would look like,
> >>
> >> NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> >> sdb         8:16   0 279.4G  0 disk
> >> =E2=94=94=E2=94=80bcache0 252:0    0 279.4G  0 disk
> >> sdc         8:32   0 279.4G  0 disk
> >> =E2=94=94=E2=94=80bcache2 252:256  0 279.4G  0 disk
> >> sdd         8:48   0 279.4G  0 disk
> >> =E2=94=94=E2=94=80bcache1 252:128  0 279.4G  0 disk
> >> nvme0n1   259:0    0 372.6G  0 disk
> >> =E2=94=9C=E2=94=80bcache0 252:0    0 279.4G  0 disk
> >> =E2=94=9C=E2=94=80bcache1 252:128  0 279.4G  0 disk
> >> =E2=94=94=E2=94=80bcache2 252:256  0 279.4G  0 disk
> >>
> >> Regards,
> >> Nikhil.
> >>
> >> On Tue, 21 Jun 2022 at 10:05, Kent Overstreet <kent.overstreet@gmail.c=
om> wrote:
> >>>
> >>> On Tue, Jun 21, 2022 at 09:11:10AM +0530, Nikhil Kshirsagar wrote:
> >>>> Hello all,
> >>>>
> >>>> I am trying to reproduce the problem that
> >>>> 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 fixes, but I am not sure ho=
w.
> >>>> This is to verify and test its backport
> >>>> (https://pastebin.com/fEYmPZqC) onto kernel 4.15 (Thanks Kent for th=
e
> >>>> help with that backport!)
> >>>>
> >>>> Could this be reproduced by creating a bcache device with a smaller
> >>>> journal size? And if so, is there some way to pass the journal size
> >>>> argument during the creation of the bcache device?
> >>>
> >>> Change SB_JOURNAL_BUCKETS to 8 and make a new cache, it's used in the
> >>> initialization path.
> >>>
> >>> Bonus points would be to tweak journal reclaim so that we're slower t=
o reclaim
> >>> to makes sure the journal stays full, and then test recovery.
>
