Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DFA552A8D
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Jun 2022 07:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiFUFlO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 Jun 2022 01:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiFUFlM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Jun 2022 01:41:12 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99A515726
        for <linux-bcache@vger.kernel.org>; Mon, 20 Jun 2022 22:41:10 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id w20so20499739lfa.11
        for <linux-bcache@vger.kernel.org>; Mon, 20 Jun 2022 22:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s+8pM1BZW+QQZuSvauuBojn8I5OeYbqAoyr8T4nlhfI=;
        b=Z1DThxPkQ9A8KE9q0msiNO6YMlwoQJoV49NjiF3ek0YiSjYyNLj+fOEuHvUMZGTuM5
         5zEWday67RvPeKU2r4zv/VcpPR0RIW7c2WSnfEmwto832YIxcDEGSIKH1BpH6jSVkwQf
         UlSUzGnfhxUYcu5VMN2kjjKZGJAOw1y9K2upgslai1DhieC6XisSXgKL+LGBKG3vXL3r
         PPwUBKCR0EvUGiHyR5XUo+2EgIBZsWz0fh8MqB/WwhRBZW4om7QaTinFS10TIMKE0bBa
         s/PshjzzatB6sa4tMRJCVetxNgQ47Te7m8QdyT68W1GVzxBRmniJTop0CGnkHMQX16Fc
         /Vbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s+8pM1BZW+QQZuSvauuBojn8I5OeYbqAoyr8T4nlhfI=;
        b=fiunM+z90PtkLvWEyHeKvWH8PTfmH/o3DxIWgsr6PVRUScmmSEcl0ZLMj9WFFtuk9f
         Cfp10DN1jMhNB089JCYDFdYTsIzZRvtWYkw4p59DbDfqvaUYT+SMabIlOD4i3tdriNuE
         loQCaiUlGKnipjSDkjoFkh6iHY3044alGWvItRAwR1BeqAW+CFUU0rbx50lMDfQi4b5l
         y1S9WyNeuSDUswguKjHo4kaTU3FwYdz696LrZa+GSk8xw7JfEiuTS7N6iVlVZ5f7D2Rg
         ifaywT69R8tlPuYpRN3Xi8ZmqQZQkknSiZLu9kv+PydpAXRFtDsHK8TZBq2pOjhmurUT
         JUhA==
X-Gm-Message-State: AJIora+u4vGXnJkxkBdzYuAWuzbPfYInnx48Qe2bPEmclbQn2Qm8wWGU
        /6jmAehcfy8lIRRhTRWws3Phaz/DoT+xHcRNuuY=
X-Google-Smtp-Source: AGRyM1uRcjYOdYsbn6J65hhJsQ2TRwmQnbY+Qxt+Bez+5OmlKEVEy6FsoJkDCE5Ka+gH4yPBFB4zqi0oX8gSYmZYER8=
X-Received: by 2002:a05:6512:1592:b0:47f:6b63:878e with SMTP id
 bp18-20020a056512159200b0047f6b63878emr6176263lfb.32.1655790069008; Mon, 20
 Jun 2022 22:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv1hTHhPdZNOhbSOzQTW+pBfAXfpGkxJfjjBmS8bYaHfZw@mail.gmail.com>
 <20220621043543.zvxgekvcs34abim6@moria.home.lan> <CAC6jXv27xfHQVFTX_U944qSStY=k9WLzPENh-tpBimcA7kms-w@mail.gmail.com>
In-Reply-To: <CAC6jXv27xfHQVFTX_U944qSStY=k9WLzPENh-tpBimcA7kms-w@mail.gmail.com>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Tue, 21 Jun 2022 11:10:56 +0530
Message-ID: <CAC6jXv3Ar-Xb-tGOMQX4PsPc5GSu=7zf_37yWvGkss=HqYfBmw@mail.gmail.com>
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

I figured later that you probably meant for me to change the
SB_JOURNAL_BUCKETS to 8 in bcache-tools and not the kernel?

Regards,
Nikhil.

On Tue, 21 Jun 2022 at 11:06, Nikhil Kshirsagar <nkshirsagar@gmail.com> wro=
te:
>
> Thank you Kent,
>
> I've made this change, in include/uapi/linux/bcache.h and will build
> the kernel with it to attempt to reproduce the issue, and create a new
> bcache device. Just wondering if the note about it being divisible by
> BITS_PER_LONG may restrict it to a minimum value of 32?
>
> #define SB_JOURNAL_BUCKETS              8
> /* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
>
>  I have a "cache" nvme disk of about 350 tb and some slow disks, each
> approx 300tb  which I will use to create the bcache device once the
> kernel is installed. My bcache setup typically would look like,
>
> NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> sdb         8:16   0 279.4G  0 disk
> =E2=94=94=E2=94=80bcache0 252:0    0 279.4G  0 disk
> sdc         8:32   0 279.4G  0 disk
> =E2=94=94=E2=94=80bcache2 252:256  0 279.4G  0 disk
> sdd         8:48   0 279.4G  0 disk
> =E2=94=94=E2=94=80bcache1 252:128  0 279.4G  0 disk
> nvme0n1   259:0    0 372.6G  0 disk
> =E2=94=9C=E2=94=80bcache0 252:0    0 279.4G  0 disk
> =E2=94=9C=E2=94=80bcache1 252:128  0 279.4G  0 disk
> =E2=94=94=E2=94=80bcache2 252:256  0 279.4G  0 disk
>
> Regards,
> Nikhil.
>
> On Tue, 21 Jun 2022 at 10:05, Kent Overstreet <kent.overstreet@gmail.com>=
 wrote:
> >
> > On Tue, Jun 21, 2022 at 09:11:10AM +0530, Nikhil Kshirsagar wrote:
> > > Hello all,
> > >
> > > I am trying to reproduce the problem that
> > > 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 fixes, but I am not sure how=
.
> > > This is to verify and test its backport
> > > (https://pastebin.com/fEYmPZqC) onto kernel 4.15 (Thanks Kent for the
> > > help with that backport!)
> > >
> > > Could this be reproduced by creating a bcache device with a smaller
> > > journal size? And if so, is there some way to pass the journal size
> > > argument during the creation of the bcache device?
> >
> > Change SB_JOURNAL_BUCKETS to 8 and make a new cache, it's used in the
> > initialization path.
> >
> > Bonus points would be to tweak journal reclaim so that we're slower to =
reclaim
> > to makes sure the journal stays full, and then test recovery.
