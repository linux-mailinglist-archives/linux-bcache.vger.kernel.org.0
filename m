Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEC91B456
	for <lists+linux-bcache@lfdr.de>; Mon, 13 May 2019 12:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfEMKw7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 May 2019 06:52:59 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:38176 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729188AbfEMKw6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 May 2019 06:52:58 -0400
Received: by mail-lf1-f44.google.com with SMTP id y19so8676121lfy.5
        for <linux-bcache@vger.kernel.org>; Mon, 13 May 2019 03:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NWkCQPkpjv+dvY5nCweUhzUK7dv7i0Q2oRHDDE5vOrs=;
        b=mcSjokpFFhRhpU/gsXpDCp3OlBos/3hBBBV7vk5nyC+4EpxGe14DB58GQEAHe6bN0E
         EP7tRN5AeUlQWCNs+yutfAcHK1zyV0omU0Z9aXyDgOBzfv6Vojne2Zl4gi4fTWJfkknR
         cEmp5JOK2QQMfo9YdQh8HIade36a10XAqZ9q0JIjhACaPhKrByJ88I/5yi6V1tcsPWxF
         Nxyw3JS5uiYg9EjneN4naWisVvSWGEK5aCBSfq3v4+vyResn/WLiHEf32YIbz/ELgjHm
         WWSCLnZ2exGoh62IpFVPyXefzn0XeSDmFbFFX2RSse1Irhv0vLIXIcvDF6NpyJRURYS+
         Usvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NWkCQPkpjv+dvY5nCweUhzUK7dv7i0Q2oRHDDE5vOrs=;
        b=PG/48oVXXrl6R/CnALgVHp9vMlQCJWZpDxTiFMmypERm6mS9ttX4vBTy/C8yhJ4mKs
         YzBPk55QgRbl4LQTO7+WtgvCPyGwww5+mQeTaenEyWhrA1MmjfiHxko62mFotNRyZjtM
         z59CgOnafDmhYCDg98I4cKi/nUULwzLQHQDfaEGc0XyglEKzzIrXDSTkiU50BJB1NFqK
         czn0yD/717TyCZOfVhI/LFZBn/wPVBpkDCcaUtG9tIYp1pbgCgBSzxE7a4XiD1F1UEhI
         +ZPeULc1t1zHOnkSeXE+BLYGgCh7kc92uiw1K0zhSNcajAKkN8ZRhvzF7rP2/yJEohMw
         mjLA==
X-Gm-Message-State: APjAAAXpB+fheCHvaoLYhkn9wVSvkG8O5Wtx/f9SkVfzh74AfFCLd4KA
        k/YZckaN9LnAEXwTyr6dIx0mJwiQwO2Y9iCoDZIHXWfRJDQ=
X-Google-Smtp-Source: APXvYqzHelmbgwcwHEISMIOquCDWUAx/I5h4Lswri1rg2m02bI8VDGBpfVYhLcikAmmBfFKj2drdNPBH50+CvC7/+Dg=
X-Received: by 2002:a19:97c8:: with SMTP id z191mr12784295lfd.167.1557744776535;
 Mon, 13 May 2019 03:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <dfa0b47d-a1c6-3faa-b377-48677502a794@rolffokkens.nl>
 <6d386198-49d0-495e-a8d1-1bc7d0191bee@rolffokkens.nl> <CACTVTQHhSZ0AneRoGKhu=wJn+X3MvYs+nT0Oa=PMaOKCuS6rpw@mail.gmail.com>
In-Reply-To: <CACTVTQHhSZ0AneRoGKhu=wJn+X3MvYs+nT0Oa=PMaOKCuS6rpw@mail.gmail.com>
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Date:   Mon, 13 May 2019 12:52:44 +0200
Message-ID: <CACTVTQFvNSbyzUrVAMF0isuEo0qVt8vOLrrPc6HYTsuFg95z0A@mail.gmail.com>
Subject: Re: bcache & Fedora 30: massive corruption
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

For those interrested in the matter, actual info on the issue can be
found here: https://bugzilla.redhat.com/show_bug.cgi?id=1708315

Bottomline is that it seems like using the cache device specifically
results in data corruption.


On Mon, May 13, 2019 at 12:49 PM Rolf Fokkens <rolf@rolffokkens.nl> wrote:
>
> For those interrested in the matter, actual info on the issue can be found here: https://bugzilla.redhat.com/show_bug.cgi?id=1708315
>
> Bottomline is that it seems like using the cache device specifically results in data corruption.
>
> On Thu, May 9, 2019 at 7:21 PM Rolf Fokkens <rolf@rolffokkens.nl> wrote:
>>
>> Hi,
>>
>> The reproducability is 100%. It's enough to only upgrade to a Fedora 30
>> kernel on a Fedora 29 system. The next reboot will probably be the last
>> reboot ever.
>>
>> My Fedora bug report is here:
>>
>> If it's gcc9 related, the cause may be somewhere between "Fedora's
>> decision to use gcc9" and "bcache needing a fix".
>>
>> Rolf
>>
>> On 5/6/19 7:45 PM, Rolf Fokkens wrote:
>> >
>> > Hi,
>> >
>> > I helped in 2013 to get bcache-tools integrated in Fedora 21
>> > (https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/thread/UEGAUSP377TB3KMUO7XK42KREHOUDZPG/).
>> >
>> > Ever since it worked like a charm, and bcache laptops (we have several
>> > at work) survived upgrading to a next Fedora release flawlessly. Since
>> > Fedora 30 this has changed however: laptops using bcache mess up
>> > backing store big time. It seems as if the backing device is corrupted
>> > by random writes all over the place. It's hard to narrow down the
>> > cause of this issue, and I'm still in the process of trial and error.
>> > May be later on I'll have more info.
>> >
>> > Some info:
>> >
>> >   * The laptops are using writeback caching
>> >   * The laptops have a bcache'd root file system
>> >   * It seems like the issue is in the Fedora kernel 5.0.10 for Fedora
>> >     30, but not kernel 5.0.10 for Fedora 29.
>> >   * One notable difference between the Fedora 29 and Fedora 30 kernels
>> >     is that Fedora 30 uses gcc 9 to build the kernel.
>> >
>> > As mentioned i'm still in the process of narrowing down the cause of
>> > the issue. But any suggestions are welcome.
>> >
>> > Rolf
>> >
>>
