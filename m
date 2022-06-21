Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A59552A8C
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Jun 2022 07:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344219AbiFUFgk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 Jun 2022 01:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345424AbiFUFg3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Jun 2022 01:36:29 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B959222A2
        for <linux-bcache@vger.kernel.org>; Mon, 20 Jun 2022 22:36:20 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id n15so2510781ljg.8
        for <linux-bcache@vger.kernel.org>; Mon, 20 Jun 2022 22:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=33/dg0itN84ySIvCRDWlUPuxMWgSRHsyRwmw2hIkfaQ=;
        b=N9oOcBvkmwHq3kRd0dMjpWenQf7KMqlxWrRD9MOfdPANn5fMNqrexC6Lj4W6QdDoOg
         PMV61TJa7GIxQiD1MqFjgTvrtepzHKKTfnBC2QRXPhR/2RnGoRq47jJNB+4VzgMjMrSP
         wiprINC/R3RNm2KlKuOZogwP6XXQ1I/J+h9pjltK78xXywDG5qul/w02XwfDx1BLMrc5
         3qXdwQ9qCTwMjue7SCDW5u005HGriivMt0gx5vVg6D3bG2lDBuJybJ/7Xri+GGwVH+O8
         rzF46eFes4gq44xl9647/+8cK152UHIgve4dr2EqC9LLtyUGT5CYj/RmCa8kRMkjua2c
         M6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=33/dg0itN84ySIvCRDWlUPuxMWgSRHsyRwmw2hIkfaQ=;
        b=bGEjfcjzvdbMi018IE5ooH4DPOOVyFA9MAKLDtYrtXtYF/OTXK9+lG+48dE2ZqlkkS
         +OrJJlPdX9r5ypr5Utx9wJZphtJjYIakpHlhPz+/yO/FhcoUBT2yMv46sGzCZHp54/BW
         qOZHrz5l08/Ky4944wc5zb4O/p9YdJxdDl39wWtqYP5TYrS61eArdF5UaO30/usnSw0e
         6eQ0C2td7U6jFN3VwqBfHwKSWbV9TbSY9QAqWVlRzr7dwMz9h8ILiHy6XA7wSaL9U7+/
         tiR8+bsUtVdtsiXF+61DgabmDmGlRuy0/YBQBLIC61vdg9BZA7bJ27nP/sdfC1+aBBU/
         ptTg==
X-Gm-Message-State: AJIora+LDnoc5bSfqfjZ69/CwePa6JVkBdJnHJKDUfes7lJmheV+S6Jf
        EQ42xL8AfYAEN5XRkpY94xaSNJNmWEleTbP7Pb37OykC0bxygA==
X-Google-Smtp-Source: AGRyM1vot1rrk+hy8z45xphnCuIK6SWhx2yNPDdAjGdLvsBAZtuPRapqnXxyj6pu225uM9plseE+36TVabdKtOKXTgU=
X-Received: by 2002:a2e:7d15:0:b0:25a:661d:6fc8 with SMTP id
 y21-20020a2e7d15000000b0025a661d6fc8mr6414324ljc.211.1655789778398; Mon, 20
 Jun 2022 22:36:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv1hTHhPdZNOhbSOzQTW+pBfAXfpGkxJfjjBmS8bYaHfZw@mail.gmail.com>
 <20220621043543.zvxgekvcs34abim6@moria.home.lan>
In-Reply-To: <20220621043543.zvxgekvcs34abim6@moria.home.lan>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Tue, 21 Jun 2022 11:06:05 +0530
Message-ID: <CAC6jXv27xfHQVFTX_U944qSStY=k9WLzPENh-tpBimcA7kms-w@mail.gmail.com>
Subject: Re: trying to reproduce bcache journal deadlock https://www.spinics.net/lists/kernel/msg4386275.html
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>
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

Thank you Kent,

I've made this change, in include/uapi/linux/bcache.h and will build
the kernel with it to attempt to reproduce the issue, and create a new
bcache device. Just wondering if the note about it being divisible by
BITS_PER_LONG may restrict it to a minimum value of 32?

#define SB_JOURNAL_BUCKETS              8
/* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */

 I have a "cache" nvme disk of about 350 tb and some slow disks, each
approx 300tb  which I will use to create the bcache device once the
kernel is installed. My bcache setup typically would look like,

NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb         8:16   0 279.4G  0 disk
=E2=94=94=E2=94=80bcache0 252:0    0 279.4G  0 disk
sdc         8:32   0 279.4G  0 disk
=E2=94=94=E2=94=80bcache2 252:256  0 279.4G  0 disk
sdd         8:48   0 279.4G  0 disk
=E2=94=94=E2=94=80bcache1 252:128  0 279.4G  0 disk
nvme0n1   259:0    0 372.6G  0 disk
=E2=94=9C=E2=94=80bcache0 252:0    0 279.4G  0 disk
=E2=94=9C=E2=94=80bcache1 252:128  0 279.4G  0 disk
=E2=94=94=E2=94=80bcache2 252:256  0 279.4G  0 disk

Regards,
Nikhil.

On Tue, 21 Jun 2022 at 10:05, Kent Overstreet <kent.overstreet@gmail.com> w=
rote:
>
> On Tue, Jun 21, 2022 at 09:11:10AM +0530, Nikhil Kshirsagar wrote:
> > Hello all,
> >
> > I am trying to reproduce the problem that
> > 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 fixes, but I am not sure how.
> > This is to verify and test its backport
> > (https://pastebin.com/fEYmPZqC) onto kernel 4.15 (Thanks Kent for the
> > help with that backport!)
> >
> > Could this be reproduced by creating a bcache device with a smaller
> > journal size? And if so, is there some way to pass the journal size
> > argument during the creation of the bcache device?
>
> Change SB_JOURNAL_BUCKETS to 8 and make a new cache, it's used in the
> initialization path.
>
> Bonus points would be to tweak journal reclaim so that we're slower to re=
claim
> to makes sure the journal stays full, and then test recovery.
