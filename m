Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3BA21C708
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Jul 2020 05:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgGLDGt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 11 Jul 2020 23:06:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21685 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727793AbgGLDGt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 11 Jul 2020 23:06:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594523207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDpQCH601Fy+lpqdsfj+RGQw6oiIHz69RMS5AAEumjk=;
        b=jUF5hu2D8w3V5TDki5/BnrHTjvrUQF1e4Qv5eULBPV9BKozzmJOOiSDmYEmHnQjeUE4NjG
        bPXJoqvzXIG1cdOZaj9o7K3Ez4FoM+a1iSk7ZfoYAluHXeVaJwPftvyFrwm8iaSijlEyTy
        MlC6mWeQKScYmQARxpRWf1fslMQgCwY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-JM5l6QIzOiuupEfbXW3QZw-1; Sat, 11 Jul 2020 23:06:45 -0400
X-MC-Unique: JM5l6QIzOiuupEfbXW3QZw-1
Received: by mail-wr1-f71.google.com with SMTP id i12so12290765wrx.11
        for <linux-bcache@vger.kernel.org>; Sat, 11 Jul 2020 20:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=NDpQCH601Fy+lpqdsfj+RGQw6oiIHz69RMS5AAEumjk=;
        b=kVyFWiZpeUcNEU2ixPnYvlWntyFX074V4nMoJOpTZGKFjvDde5kCs83bu5XYJE6Nqr
         yhaNBc60M7FAbGKGtAE2f05GP7ainpLB8vsK3Q5sFZR2HrqKpEmVffR7yyyT0mynbdVo
         6aOmbCGHmJaPYMK0tcPjaqMrPLMv/Y8oX4shMZVKqsGDLOSksdpYh7M93m3rkKYuL0zH
         Yv7aRAiuJpZhGp/D3dqygmXI8VClkL3+470/QsJG8Mh4d7UNWfNcHBtvTc12cMmAtSIG
         d2NZBN8kBgRTLjo8sdg03VUfrS8pVLliYWIW3+KVtSFrS5nbokhRRB8Qtw2U9g60lOAG
         lo2A==
X-Gm-Message-State: AOAM530cN1NH/MTYJCLfuW0E91ave1wspv75drNP02z7fSJulnN822Wy
        HNmaFBEz9W0eQqn43Mpho+lieoou3/zfRqKWZYplJX45mpKlV/MiQtj70stnrq7u4UGyDvmKWTW
        V8+eU+qm55w5fJD3+HM/u1P0j
X-Received: by 2002:a5d:6342:: with SMTP id b2mr73348101wrw.262.1594523203847;
        Sat, 11 Jul 2020 20:06:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9s3z1q547dcxjNKb+VsF+mn27FBEGzjNu3rGa5WQZwiOPSY0k+N7fw1zJS7EWnmc99ewr0Q==
X-Received: by 2002:a5d:6342:: with SMTP id b2mr73348088wrw.262.1594523203630;
        Sat, 11 Jul 2020 20:06:43 -0700 (PDT)
Received: from [192.168.23.174] (c-73-253-167-23.hsd1.ma.comcast.net. [73.253.167.23])
        by smtp.gmail.com with ESMTPSA id k131sm1330291wmb.36.2020.07.11.20.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 20:06:43 -0700 (PDT)
Subject: Re: bcache integer overflow for large devices w/small io_opt
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <878sfrdm23.fsf@redhat.com>
 <4baea764-ba86-e17d-5e75-6acf22f2bbea@suse.de>
From:   Ken Raeburn <raeburn@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <1de4ebce-c62f-e357-9827-3fa263f6b36a@redhat.com>
Date:   Sat, 11 Jul 2020 23:06:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <4baea764-ba86-e17d-5e75-6acf22f2bbea@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/11/20 11:28 AM, Coly Li wrote:

> On 2020/7/11 06:47, Ken Raeburn wrote:
>> The long version is written up at
>> https://bugzilla.redhat.com/show_bug.cgi?id=1783075 but the short
>> version:
>>
>> There are devices out there which set q->limits.io_opt to small values
>> like 4096 bytes, causing bcache to use that for the stripe size, but the
>> device size could still be large enough that the computed stripe count
>> is 2**32 or more. That value gets stuffed into a 32-bit (unsigned int)
>> field, throwing away the high bits, and then that truncated value is
>> range-checked and used. This can result in memory corruption or faults
>> in some cases.
>>
>> The problem was brought up with us on Red Hat's VDO driver team by a
>> bcache user on a 4.17.8 kernel, has been demonstrated in the Fedora
>> 5.3.15-300.fc31 kernel, and by inspection appears to be present in
>> Linus's tree as of this morning.
>>
>> The easy fix would be to keep the quotient in a 64-bit variable until
>> it's validated, but that would simply limit the size of such devices as
>> bcache backing storage (in this case, limiting VDO volumes to under 8
>> TB). Is there a way to still be able to use larger devices? Perhaps
>> scale up the stripe size from io_opt to the point where the stripe count
>> falls in the allowed range?
>>
>> Ken Raeburn
>> (Red Hat VDO driver developer)
>>
> We cannot extend the bit width of nr_stripes, because
> d->full_dirty_stripes memory allocation depends on it.
>
> For the 18T volume, and stripe_size is 4KB, there are 4831838208
> stripes. Then size of d->full_dirty_stripes will be
> 4831838208*sizeof(atomic_t) > 140GB. This is too large for kernel memory
> allocation.
I didn't intend for nr_stripes to be made 64 bits. Just a temporary 
variable for the purposes of validation, to ensure that you won't be 
losing high bits when coercing to unsigned int.
> Does it help of we have a option in bcache-tools to specify a
> stripe_size number to overwrite limit->io_opt ? Then you may specify a
> larger stripe size which may avoid nr_stripes overflow.
>
> Thanks for the report.
>
> Coly Li
>
Yes, I think letting the user choose a stripe size would be a good way 
to address the problem. Of course, the driver must still defend itself 
against memory corruption anyway, if the user doesn't do so, by 
rejecting or adjusting the values. But whereas I wouldn't recommend the 
driver alter the stripe size by more than necessary to make the stripe 
count fit, the user can make it as big as they want, if they want to 
bring the memory requirement down further, or if they've done some 
performance measurements of different configurations, or they know 
something interesting about their workload's access patterns, etc.

Ken

