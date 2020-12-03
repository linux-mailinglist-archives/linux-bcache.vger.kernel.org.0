Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B092CD217
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 10:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgLCJH0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Dec 2020 04:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbgLCJHZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Dec 2020 04:07:25 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B40C061A4D;
        Thu,  3 Dec 2020 01:06:45 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id j13so758889pjz.3;
        Thu, 03 Dec 2020 01:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x090Pi/p4YdcyRoV862Kj0ZiAvBp3vZ9F7IWYK4ZvKQ=;
        b=ckqlCtgiG+ueA5VyNM+O63WETRQ7o586/ee4FYil95hEwBqRa6XNfo9DmTIRJhtGvU
         yM/nMHEzU0A54LWTZkNZnkYQajIPFM2hViIbMZnao4fBrcdOAEe0SdbnrQnsQMwak2HP
         wWEa70jJ+oC7e1NOAJoR/SmfkphdRmqSfLbmrSr1zOilYivX8qTIAyhvVaRKLWP9xoD1
         9YWJL8QInRf55bH0dmDdQft226UAtNeuQsX+ROB7Bnz4sY66IxcroM1nlAsEA50JhEc0
         bp3J/CAx5nd+UXkJsTkhURdof2tlIjC4jYzKMhMEpz8CtEYb0R6uTHvoeYVzEphjcTSF
         DVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x090Pi/p4YdcyRoV862Kj0ZiAvBp3vZ9F7IWYK4ZvKQ=;
        b=AwCuv7ey3bgu6fYXDmyEkeQ6n36fI4rCXwEmSDTOigCbBk7S4wxbeXlOcEzQLUugsI
         Pyy239ekCV1PrFcTcUAprk5TSVgoHwlY1lYFXwl6JPICDP3drD8vMI4S0c6eIgcsjmQt
         4jdIKAQdtdvMC+JojcpVo7atd6UxRUPhXOK+FEwDLgHFPj0Ln6/9N3H8eBVDjkr4uIQ/
         FqldR6rQgfZ+qEbYfkuMy5B6ifbhtBfbsn2fcEMXlQcttYyucEEgooF4q9CNKktXZ84h
         Ahu4fX3Msp5z7k6aJZrM1KpKKJAV18yig8mw0tVhyn2Vx2iOGXQwSKE9M/1mThGYZ+Rh
         Q44A==
X-Gm-Message-State: AOAM531SaQErBYGVbifCHqsuetK6sogRLoZwWLIOR9b5mDZzYATtjgGE
        Fsw4q8SzXeXrpK3IuhnSgxhMHDdxSfTXkJ9jnRe8ocXdTJo=
X-Google-Smtp-Source: ABdhPJxBpL93a9A1Kw9XZK+wssGAmhgxWbnJ6xbNVEzFbIPfkDK2Lq0Rb/qA8hxQQ/DUxisYvpqdtkBglwBoBth9FrI=
X-Received: by 2002:a17:902:bd98:b029:d9:7b0:e1e5 with SMTP id
 q24-20020a170902bd98b02900d907b0e1e5mr2151870pls.77.1606986404968; Thu, 03
 Dec 2020 01:06:44 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90a:7886:0:0:0:0 with HTTP; Thu, 3 Dec 2020 01:06:44
 -0800 (PST)
In-Reply-To: <79fde596-254a-510c-547a-b1525985de9d@suse.de>
References: <20201130112137.587437-1-yili@winhong.com> <CAJfdMYDnDJXFVfEECtQ9-E4F9kfsF035PH+x3kaVn6PPSYCydA@mail.gmail.com>
 <b838b790-e1e3-d644-2b1c-5de02a10669f@suse.de> <CAJfdMYCbkAZtWpJ6sgsrRnV4i+5sRahaq-ktMjqcG1JXoazmGQ@mail.gmail.com>
 <79fde596-254a-510c-547a-b1525985de9d@suse.de>
From:   Yi Li <yilikernel@gmail.com>
Date:   Thu, 3 Dec 2020 17:06:44 +0800
Message-ID: <CAJfdMYDLydAtoxvPGzaQ+K5jLvwAXg6MvpE-OM9sFjZgz_01sQ@mail.gmail.com>
Subject: Re: [PATCH] bcache: fix panic due to cache_set is null
To:     Coly Li <colyli@suse.de>
Cc:     Yi Li <yili@winhong.com>, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo Chao <guochao@winhong.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The root cause:

After just  cached_dev_free do cancel_writeback_rate_update_dwork
without bch_register_lock
.
at the same time. Wirting the writeback_percent by sysfs witch
bch_register_lock will insert a writeback_rate_update work.

cached_dev_free with bch_register_lock to do bcache_device_free.

(it is introduce by patch 80265d8dfd77792e133793cef44a21323aac2908)

pls=EF=BC=9A
1=EF=BC=9A run the shell script
#!/bin/bash
while [ true ]
do
        echo 0 > /sys/block/bcache0/bcache/writeback_percent
done

2: hotplug the cache disk


On 12/3/20, Coly Li <colyli@suse.de> wrote:
> On 12/3/20 2:25 PM, Yi Li wrote:
>>> On 12/1/20 12:35 PM, Yi Li wrote:
>>>> sorry, This patch will cause deadlock, i will check and redo it.
>>>
>>> Can you try latest upstream kernel firstly ? Before spending more time
>>> on the fix.
>>>
>>
>> This issue just happened three times =EF=BC=88xenserver7.5 dom0 kernel=
=EF=BC=89 on the
>> same machine and cannot reproduce it now. and have not reproduce it
>> using the lastest uptream kernel.
>>
>
> Hmm, this is something very probably that I am not able to help. It
> seems the kernel is a third-part maintained Linux v4.4 based kernel +
> bcache backport, which is out of my view.
>
> If similar problem happens on latest upstream kernel, or at least v5.8+
> kernel, I can help to take a look.
>
>
>>> If I remember correctly, when cancel_writeback_rate_update_dwork() is
>>> not timed out, the cache set memory won't be freed before the
>>> writeback_rate_update worker terminates. It is possible that I miss
>>> something in the code, but I suggest to test with a kernel after v5.3,
>>> and better a v5.8+ kernel.
>>>
>>> Coly Li
>>>
>> Thanks.
>>
>> it is  confused that why writeback_rate_update worker run  again after
>> cancel_delayed_work_sync( kernel log telled).
>>
>
> [snipped]
>
> Coly Li
>
