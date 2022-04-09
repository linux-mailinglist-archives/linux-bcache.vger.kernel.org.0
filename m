Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10B24FA91F
	for <lists+linux-bcache@lfdr.de>; Sat,  9 Apr 2022 16:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiDIO7o (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 9 Apr 2022 10:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiDIO7n (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 Apr 2022 10:59:43 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CAB29D271
        for <linux-bcache@vger.kernel.org>; Sat,  9 Apr 2022 07:57:35 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v2so3219567wrv.6
        for <linux-bcache@vger.kernel.org>; Sat, 09 Apr 2022 07:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y9SW8EUbynKwNpuKQ9OPmftMxlUCcrsAkHcFgBA9rTE=;
        b=kRuuaKTswNy+4Q1SunQ8Z9aJalbMiGTcnwfPkBaKJP8BRSv6dwyZo2TQSA+uJKKNWE
         GzXjkVc3ORY9kGklwIZiw7kBumIERkVokLHmeKItSAAfiAnMnlFlk+wfhOEi+NW1ufVc
         /JkDAZYetPw2Q9MZrbxvzPTdfcjPmgbGPKOm0Uioj6gRs6H/d/iUywMcG2mMHdSUXy7K
         RB3+t4AJnDZRJMwmcd8TD5kRJhs7qLaFK5Dltr4VfiVZ7Jyk6dcTnmeccZ304SoqO5nk
         hPsVaHbbdkj8uDVEp4BwQAGOZS44TRvNO1fxES2Nu1aDWH3jI59SBl6YAbobPeAN8/pF
         M7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y9SW8EUbynKwNpuKQ9OPmftMxlUCcrsAkHcFgBA9rTE=;
        b=3fyySwZOEJJXfm8rseg4+ymZoUlMlCZ158VKc0ARolikDyDK8m5j69EG1IwdTXvCyy
         LrhQvOjxH4P2c0wrrl7C6wQUV9U6f8lmi3pt++6dqBsRSu2zh/KNsvmmFOFpTMyoOMnz
         4o42Pl3PnBJWqsZVV2lnlE9y11OR2Z+gtwkIz9k7f3hMtCfAL7nHWbfBtvRdSHgskyel
         cgX6iq1QPQYRvQanry5Bsx58do8Y4YBYjHFwZ0BJXapytwY3ZJe+fmDzZk/DzotqPMmk
         5wQFhUV0iqkAZOPPG0hu3clTn+b4Klu6TtwOLkN0ZVdyKNYh7pV0NdQbxoI6nXu4nmxy
         jzMg==
X-Gm-Message-State: AOAM530xNKCU4iKhZWldjIKaNfzJqZV6MiCFbfeWgrg+k1ZPAizBYFCt
        O3uSKI6XPAhS3YjUgkwPEIGzWDjDVensO4XL7qyO5GU1SYA=
X-Google-Smtp-Source: ABdhPJxoNnbT3VZPSVdriHTM3BaFx8qWCwM+Op1tcl6xPi6fJU9O08ezeMxYtKyyXaakPgA0ARQhrOA7BvWikOxDEBk=
X-Received: by 2002:a05:6000:1806:b0:207:a218:fcd2 with SMTP id
 m6-20020a056000180600b00207a218fcd2mr1018527wrh.706.1649516253926; Sat, 09
 Apr 2022 07:57:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220407171643.65177-1-colyli@suse.de> <CAMhKsXkfr6btADZbTcFEJ3y8Qi=A0cQk32pqwa7htbSGHrU_uA@mail.gmail.com>
 <8865472d-6579-92fc-20c9-c4cef430253b@suse.de>
In-Reply-To: <8865472d-6579-92fc-20c9-c4cef430253b@suse.de>
From:   =?UTF-8?B?5p2O56OK?= <noctis.akm@gmail.com>
Date:   Sat, 9 Apr 2022 22:57:36 +0800
Message-ID: <CAMhKsXkSTVmaacxNjqv=iknPzzE+dESDsqcLQWtALCj-ReA0Fg@mail.gmail.com>
Subject: Re: [PATCH] bcache: avoid unnecessary soft lockup in kworker update_writeback_rate()
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
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

>
> On 4/9/22 2:58 PM, =E6=9D=8E=E7=A3=8A wrote:
> >> The kworker routine update_writeback_rate() is schedued to update the
> >> writeback rate in every 5 seconds by default. Before calling
> >> __update_writeback_rate() to do real job, semaphore dc->writeback_lock
> >> should be held by the kworker routine.
> >>
> >> At the same time, bcache writeback thread routine bch_writeback_thread=
()
> >> also needs to hold dc->writeback_lock before flushing dirty data back
> >> into the backing device. If the dirty data set is large, it might be
> >> very long time for bch_writeback_thread() to scan all dirty buckets an=
d
> >> releases dc->writeback_lock.
> > Hi Coly,
> > cached_dev_write() needs dc->writeback_lock, if  the writeback thread
> >   holds writeback_lock too long, high write IO latency may happen. I wo=
nder
>
>  From my observation, such situation happens in one of the last scan
> before all dirty data gets flushed. If the cache device is very large,
> and dirty keys are only a few, such scan will take quite long time.
>
> It wasn't a problem years ago, but currently it is easy to have a 10TB+
> cache device, now the latency is observed.
>
>
> > if it is a nicer way to limit the scale of the scanning in writeback.
> > For example,
> > just scan 512GB in stead of the whole cache disk=E3=80=82
>
> Scan each 512GB space doesn't help too much. Because current btree
> iteration code doesn't handle continue-from-where-stopped very well,
> next time when continue form where stoppped, the previous key might be
> invalided already.
>
> An ideal way, might be split the single large btree into multiple ones.
> People suggested me to divide the single tree into e.g. 64 or 128 trees,
> and only lock a single tree when doing writeback on gc on one of the
> trees. Maybe now it is about time to think over it again...
>

I got it. Thanks for the detailed explanation.
