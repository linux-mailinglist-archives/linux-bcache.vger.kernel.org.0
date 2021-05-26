Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD99391040
	for <lists+linux-bcache@lfdr.de>; Wed, 26 May 2021 07:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhEZGAk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 26 May 2021 02:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbhEZGAj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 26 May 2021 02:00:39 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BF4C061574
        for <linux-bcache@vger.kernel.org>; Tue, 25 May 2021 22:59:07 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 66-20020a9d02c80000b02903615edf7c1aso9077483otl.13
        for <linux-bcache@vger.kernel.org>; Tue, 25 May 2021 22:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yQEGjS6sbWOdltlUF8WrSHfRcyNdhw3R2mSLo2DanqM=;
        b=ksmsQSlbgYDBBbh4JLcSfpIBqnbTOyK3DI32byz7coujz9ViQsQlug4otzYzJHBY0F
         p7Qiw8w2P1k2N055B2YmvLMnPDFcnugzsGUHl5BNjxLOy5VSnHhC8iYb6T3tpCkMlWSp
         HcUj9CPEQci4zm9HI1BNPVAKtUK1SBQaTXaTJ15WnE6CAgjBv05vkzXZy4rRbQcw1Dz6
         HUAlOmMSqhmxAz07seBV8PkFrFkhzXOWG5wB1A/Bkao8txNO4U3/wFlf9ELtRp1TKjEW
         xaSZb8XUAS28m+i8nQr4ESOSY3UGA+eHUwIO9o855UbmUlh6mITAAF3TUpCkqwWaCjB0
         RMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yQEGjS6sbWOdltlUF8WrSHfRcyNdhw3R2mSLo2DanqM=;
        b=j8goJBp430/jJxdtAVRf2zujeYeDKiCEOCSkjF635jitl87PFFgl24unybskRXCd5i
         WQ0J1fBXcR7CpuFugJITXWuDtWLps1W3ED2Glj++4jPV6FZSBvm4RHiqg/vFUhWBOsma
         Pz5jQzpFzyIGsnSkY03UQCt2cvaxSwNUMirSyEN8xqb6D/mdmBHOYES73W9eXNpVFyjO
         cYN61pnv9FG4HFR3JkmkRLT4l+R5lVrdCdy1PDHrBU553ssyL6eWIWFfBH2/mbgt2K5h
         k48+89g9zqLH8cU4OLe0Rg87qsXziU1TF8mBDTC1p/a87Mr+eFUYWn2OXT8sRmUVB56e
         NF2Q==
X-Gm-Message-State: AOAM531lfkEEhxiYmtwRfu0Bg1y7zHPeJmAyIXo4IOik5Ut5umzIJEbW
        UY8zPrVlcTO05iT+FuWD6HHgS6/4YJgXqoXlV/RnJ2GT+VQ=
X-Google-Smtp-Source: ABdhPJz4UHFcH0Q5XR43AkgWhBLifxklBQWN0pdrFv0RfrgRUA7EU8w9i48kAPihRmvByJwW3fuaWjMbBqNzPjDOq5U=
X-Received: by 2002:a05:6830:1594:: with SMTP id i20mr1018261otr.279.1622008747139;
 Tue, 25 May 2021 22:59:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAG9eTxRG8zqe1r47wgtv_fhVAk13fmeB=Fyx-Z6Fq8W0i=om6Q@mail.gmail.com>
 <6c9fded6-30f8-b3cd-527b-0ca95fdca6ba@suse.de>
In-Reply-To: <6c9fded6-30f8-b3cd-527b-0ca95fdca6ba@suse.de>
From:   Jim Guo <jimmygc2008@gmail.com>
Date:   Wed, 26 May 2021 13:58:46 +0800
Message-ID: <CAG9eTxTMOqs0kUEGhWYhUj2VkpgwBmtZQ_AJEkT=02oksep3yQ@mail.gmail.com>
Subject: Re: IO hang when cache do not have enough buckets on small SSD
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> What is the kernel version in your system? And where the kernel package
> is from?
I am using kernel version 4.19.142, I compile it from source code
downloaded from kernel.org.

> Do you have a testing result on this idea?
Sorry, the testing environment is not owned by me and I did not keep
any testing result currently. I will test for this later in my own
testing environment.

Coly Li <colyli@suse.de> =E4=BA=8E2021=E5=B9=B45=E6=9C=8817=E6=97=A5=E5=91=
=A8=E4=B8=80 =E4=B8=8B=E5=8D=887:53=E5=86=99=E9=81=93=EF=BC=9A

>
> On 5/17/21 11:54 AM, Jim Guo wrote:
> > Hello, Mr. Li.
> > Recently I was experiencing frequent io hang when testing with fio
> > with 4K random write. Fio iops dropped  to 0 for about 20 seconds
> > every several minutes.
> > After some debugging, I discovered that it is the incremental gc that
> > cause this problem.
> > My cache disk is relatively small (375GiB with 4K block size and 512K
> > bucket size), backing hdds are 4 x 1 TiB. I cannot reproduce this on
> > another environment with bigger cache disk.
> > When running 4K random write fio bench, the buckets are consumed  very
> > quickly and soon it has to invalidate some bucket (this happens quite
> > often). Since the cache disk is small, a lot of write io will soon
> > reach sectors_to_gc and trigger gc thread. Write io will also increase
> > search_inflight, which cause gc thread to sleep for 100ms. This will
> > cause gc procedure to execute for a long time, and invalidating bucket
> > for the write io will wait for the whole gc procedure.
> > After removing the 100ms sleep from the incremental gc patch,  the io
> > never hang any more.
>
> What is the kernel version in your system? And where the kernel package
> is from?
>
>
> > I think for small ssd, sleeping for 100ms seems too long or maybe
> > write io should not trigger gc thread to sleep for 100ms?
> > Thank you very much.
> >
>
> Do you have a testing result on this idea?
>
>
> Thanks.
>
> Coly Li
