Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B27169F08F
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Feb 2023 09:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjBVInE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 22 Feb 2023 03:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjBVInD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Feb 2023 03:43:03 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143E986B7
        for <linux-bcache@vger.kernel.org>; Wed, 22 Feb 2023 00:43:02 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1722c48a773so5734681fac.2
        for <linux-bcache@vger.kernel.org>; Wed, 22 Feb 2023 00:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EpQSKRWPmR+JSJo5hqn45c9XmYpXU/mB3sDivHoOnn8=;
        b=mNVxERoImNl+DCcV3LXKpU5qH/Y5Zd19ivctK7PbG95KjgaYcyjj1jh2Wx8s1BnlDE
         C5EcBapkznbtytifv0QdvpDxcK/iYAu/7QKZsnwY1RJmj6hAndR7E2G5UGRfZLY6SWif
         fIejbuLccEgS+Cb71BKhBD8uBamMNK55SoBbSYjuvQjwYoTcBWh2nGow04TzP+LjMyJm
         OzJ+ZhkXK86aZRCrdkB17hOug0rdIZAhknmBswjohQinylo2xfEU9t2LDmrrlzER1gA/
         PeCedXrhK6dybLet/Wr00vK98yIlKGIxBccKDQUqbygNSaH8SS8W2MaeAfWjeU8Ixx+6
         TRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EpQSKRWPmR+JSJo5hqn45c9XmYpXU/mB3sDivHoOnn8=;
        b=doU7YjhROtNyN7+d3M2/FdeFmvajCzTXfsuT0qNOIKjH5746MBKEszzuT6ao0ySs95
         +EJuufH8DiohYxTo4jFgwRe41Tet5QZBpOsPsFU+hDjI1jDc5x4sX5ACePsv1r1PDnGU
         BfYtdDal7odDnm8Jc1FHFwP8ZL6PVcPDKxgYN3b+B/2FlH0Jqi26aGbaGP4RaOuKEHwV
         tinsdlDSo45578STzBRc7UZqBvF1AjfwPRLt+2pqSQ+CSTnPglZIUNvVIRCcxS3oVCSF
         d6QW0RxNfUNrUqOL51uoPPO9t1iSPE9bqwdwUSpbHBrZYvrPEqnq4IdpogxnmdOKRdH2
         bEeA==
X-Gm-Message-State: AO0yUKWQpNhTIFSP70NUs/gaEvjYadhWBCosCma0jueWztJFUoDgZH/j
        TqaJdxp/a4fKBAdJ9JFMF+VzAdHxxwmGZeFUb+7b6w==
X-Google-Smtp-Source: AK7set9ZNFcbE2PfrK/dojkwRz7Z10FNLprCoQ8he/VvEqWHO/Qzt0Yk1d8C0ptItrDnEnrUUpmNsd9cA/qSwWSRvyY=
X-Received: by 2002:a05:6870:d148:b0:16d:dc93:691d with SMTP id
 f8-20020a056870d14800b0016ddc93691dmr967205oac.6.1677055381374; Wed, 22 Feb
 2023 00:43:01 -0800 (PST)
MIME-Version: 1.0
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net> <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com> <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
 <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
 <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de> <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com>
 <755CAB25-BC58-4100-A524-6F922E1C13DC@suse.de> <50e64fcd-3bd8-4175-c96e-5fa2ffe051d4@devo.com>
 <8C5EA413-6FBB-4483-AAFA-2BC0A083C30D@suse.de> <cd023413-a05c-0f63-cde7-ed019b811575@easystack.cn>
 <266DA9D9-CD6A-420F-8FB2-CE47489D74E1@suse.de>
In-Reply-To: <266DA9D9-CD6A-420F-8FB2-CE47489D74E1@suse.de>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Wed, 22 Feb 2023 09:42:50 +0100
Message-ID: <CAHykVA5rpx7zOK2QqHsMKaJW6m6uMdRMSc_0NLfuF4tVGd7B-Q@mail.gmail.com>
Subject: Re: [RFC] Live resize of backing device
To:     Coly Li <colyli@suse.de>
Cc:     mingzhe <mingzhe.zou@easystack.cn>,
        Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

On Mon, Feb 20, 2023 at 1:30 PM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2023=E5=B9=B42=E6=9C=8820=E6=97=A5 16:27=EF=BC=8Cmingzhe <mingzhe.zou@e=
asystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
> >
> >
> >
> > =E5=9C=A8 2023/2/19 17:39, Coly Li =E5=86=99=E9=81=93:
> >>> 2023=E5=B9=B41=E6=9C=8827=E6=97=A5 20:44=EF=BC=8CAndrea Tomassetti <a=
ndrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>
> >>> From 83f490ec8e81c840bdaf69e66021d661751975f2 Mon Sep 17 00:00:00 200=
1
> >>> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> >>> Date: Thu, 8 Sep 2022 09:47:55 +0200
> >>> Subject: [PATCH v2] bcache: Add support for live resize of backing de=
vices
> >>>
> >>> Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.c=
om>
> >> Hi Andrea,
> >> I am fine with this patch and added it in my test queue now. Do you ha=
ve an updated version, (e.g. more coding refine or adding commit log), then=
 I can update my local version.
Thank you very much. I appreciate it. I don't have any other version,
there's just some code in common with `bcache_device_init` but I
couldn't find an elegant way to avoid copy paste of those few lines.

> >> BTW, it could be better if the patch will be sent out as a separated e=
mail.
I'll send it right now on a separate thread.

Thank you,
Andrea

> >> Thanks.
> >> Coly Li
> > Hi, Coly
> >
> > I posted some patchsets about online resize.
> >
> > -[PATCH v5 1/3] bcache: add dirty_data in struct bcache_device
> > -[PATCH v5 2/3] bcache: allocate stripe memory when partial_stripes_exp=
ensive is true
> > -[PATCH v5 3/3] bcache: support online resizing of cached_dev
> >
> > There are some differences:
> > 1. Create /sys/block/bcache0/bcache/size in sysfs to trigger resize
> > 2. Allocate stripe memory only if partial_stripes_expensive is true
> > 3. Simplify bcache_dev_sectors_dirty()
> >
> > Since the bcache superblock uses some sectors, the actual space of the =
bcache device is smaller than the backing. In order to provide a bcache dev=
ice with a user-specified size, we need to create a backing device with a l=
arger space, and then resize bcache. So resize can specify the size is very=
 necessary.
> >
> >
>
> Yes, they are in my for-test queue already. I will test both and make a c=
hoice.
>
> Thanks.
>
> Coly Li
>
> [snipped]
>
