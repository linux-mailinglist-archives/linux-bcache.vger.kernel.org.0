Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDF41AD89
	for <lists+linux-bcache@lfdr.de>; Sun, 12 May 2019 19:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfELRlI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 May 2019 13:41:08 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:45347 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfELRlI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 May 2019 13:41:08 -0400
Received: by mail-ed1-f41.google.com with SMTP id g57so13793674edc.12
        for <linux-bcache@vger.kernel.org>; Sun, 12 May 2019 10:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=978dXp/RXp5I0zEI1BF0PifRQGt4maofjUU8Fz+pi3U=;
        b=Yc1AHnBx3Sk3klWVPshX6oizWacwfTWjFBS3zLNgcqWXVj7PP82UwjaZRp6Son7WSr
         u1Pska3EaYtSanlRSS8ctTcvTydwkkFHUN/pd3nThajD16BwzZYl6lvdMPJeRcFgCiWI
         D520PrEi5e2fpnMwaXHOZky42wgjSwsx11AexI4/cXu/OQBfXxvRB92Gwm7Z+nSZrRyv
         wjqC9oTOLDWjvKMpljMW78JHjriKh3qpjSoX8cJiZpAyzp1lH+q4obdzed7b2v1iNrM3
         RJ6U/uthBLQKmoaNPqT607PcrRXm50VLPXKNu5/Iud9fU/B0JjcAgJhvtdgNXDtKT90g
         02dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=978dXp/RXp5I0zEI1BF0PifRQGt4maofjUU8Fz+pi3U=;
        b=nWWo7aYuJtNb58fK7LAxQNyjN7g7pd/rbGnLTL5g2Frf3FtXnZx+obXx511xIWIk8x
         Ep0Nx9nkiX6paPJAfKxImqbjf1Gvly1NIGdf7GFs+mfcwEkfE/1YkNvDd01mZa4Oz+Y6
         yda6zsUYtgf7qexPANmXvfxdk1Qm4h+mCK4MT104ruUFN0KKltBg/Lgupuw5Ocao6H6a
         2f1DfwDHLMjPo/1m4I+N74YU0/+O6BBP8icmtVu2wrov0KA6wjbtM65GO9GMbFsdbqrp
         ofoaqdMjEUoozn15UIpbKVOYGbwdHncpQ2+uDfpqtTOdVYeWinqpOchACDz5i0oxsvI+
         DbtQ==
X-Gm-Message-State: APjAAAWxYgReoNux8QnfXrbs6NgDwXDmYGcxB4KBB0LLQ6NVz3kXRYFN
        kC+IOB5cxilAU28KhhvsZ3aQ0g==
X-Google-Smtp-Source: APXvYqyz0YKz4saHUpafW3Afm06inCkHm40bANA/EAx22sR47OcFLOwh50BySuGrl9wJy8Ot+n2Lng==
X-Received: by 2002:a50:86fb:: with SMTP id 56mr25068264edu.83.1557682866635;
        Sun, 12 May 2019 10:41:06 -0700 (PDT)
Received: from home07.rolf-en-monique.lan ([89.188.16.145])
        by smtp.gmail.com with ESMTPSA id n55sm3132765edd.93.2019.05.12.10.41.05
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 May 2019 10:41:05 -0700 (PDT)
Subject: Re: bcache & Fedora 30: massive corruption 100% reproducable
From:   Rolf Fokkens <rolf@rolffokkens.nl>
To:     Coly Li <colyli@suse.de>
References: <dfa0b47d-a1c6-3faa-b377-48677502a794@rolffokkens.nl>
 <6d386198-49d0-495e-a8d1-1bc7d0191bee@rolffokkens.nl>
 <ed7ad425-6dcc-d2de-d22a-053a8c3bcd10@rolffokkens.nl>
Cc:     linux-bcache@vger.kernel.org, pierre.juhen@orange.fr
Message-ID: <ce68f754-25fb-14d5-5728-10d8e94910bb@rolffokkens.nl>
Date:   Sun, 12 May 2019 19:41:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ed7ad425-6dcc-d2de-d22a-053a8c3bcd10@rolffokkens.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: nl-NL
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/12/19 7:11 PM, Coly Li wrote:
>  From the dmesg.lis file, it seems fc30 uses 5.0.11-300, so what is the
> kernel version of fc29 ?

The reproducability extends to any kernel I tested for Fedora 30. And 
each of these is available for Fedora 29 too.

Kernels I tested so far (they all broke the FS):

- kernel-5.0.11-300.fc30 (gcc 9.0)

- kernel-5.0.13-300.fc30 (gcc 9.0)

- kernel-5.0.14-300.fc30 (gcc 9.1)

Kernels I tested so far which worked fine:

- kernel-5.0.11-200.fc29 (gcc 8)

- kernel-5.0.13-200.fc29 (gcc 8)

- kernel-5.0.14-200.fc29 (gcc 8)

So the pattern seems to be that they all break storage when built on 
Fedora 30, and they work fine when built on Fedora 29.

Reproducing is easy:

  * Download the kvm image by means of this torrent (part of the bug
    report below): https://bugzilla.redhat.com/attachment.cgi?id=1567288
  * Install the VM (have a look at the included libvirt xml, and tweak
    it if required)
  * There is a user testuser with password testuser.
  * Next do:
  * A) dnf update "kernel*", reboot. Do another reboot and enjoy a
    stable system.
  * B) dnf --release=30 update "kernel*", reboot. Try another reboot and
    have a look at dmesg, it contains ext4 errors. It may not even boot

On 5/11/19 10:06 AM, Rolf Fokkens wrote:
> FYI:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=203573
> https://bugzilla.redhat.com/show_bug.cgi?id=1708315
>
> On 5/9/19 7:21 PM, Rolf Fokkens wrote:
>> Hi,
>>
>> The reproducability is 100%. It's enough to only upgrade to a Fedora 
>> 30 kernel on a Fedora 29 system. The next reboot will probably be the 
>> last reboot ever.
>>
>> My Fedora bug report is here:
>>
>> If it's gcc9 related, the cause may be somewhere between "Fedora's 
>> decision to use gcc9" and "bcache needing a fix".
>>
>> Rolf
>>
>> On 5/6/19 7:45 PM, Rolf Fokkens wrote:
>>>
>>> Hi,
>>>
>>> I helped in 2013 to get bcache-tools integrated in Fedora 21 
>>> (https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/thread/UEGAUSP377TB3KMUO7XK42KREHOUDZPG/).
>>>
>>> Ever since it worked like a charm, and bcache laptops (we have 
>>> several at work) survived upgrading to a next Fedora release 
>>> flawlessly. Since Fedora 30 this has changed however: laptops using 
>>> bcache mess up backing store big time. It seems as if the backing 
>>> device is corrupted by random writes all over the place. It's hard 
>>> to narrow down the cause of this issue, and I'm still in the process 
>>> of trial and error. May be later on I'll have more info.
>>>
>>> Some info:
>>>
>>>   * The laptops are using writeback caching
>>>   * The laptops have a bcache'd root file system
>>>   * It seems like the issue is in the Fedora kernel 5.0.10 for Fedora
>>>     30, but not kernel 5.0.10 for Fedora 29.
>>>   * One notable difference between the Fedora 29 and Fedora 30 kernels
>>>     is that Fedora 30 uses gcc 9 to build the kernel.
>>>
>>> As mentioned i'm still in the process of narrowing down the cause of 
>>> the issue. But any suggestions are welcome.
>>>
>>> Rolf
>>>
>>
>

