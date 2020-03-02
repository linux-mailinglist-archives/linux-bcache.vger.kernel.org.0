Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2422D1760EB
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Mar 2020 18:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgCBRTw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 12:19:52 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:37958 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBRTw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 12:19:52 -0500
Received: by mail-il1-f196.google.com with SMTP id f5so176975ilq.5
        for <linux-bcache@vger.kernel.org>; Mon, 02 Mar 2020 09:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uWuKgNmXAn+nY0mp5ruzBbGAh1vhy0hRNShqzy5Qq2Y=;
        b=Wh7DU1pN0KLi3ekXVH15ZKP4j3r/90l9Itn4hL1PKgs2Zy2Ayw56G+Go2cw/eNZHEy
         JgPjEqKcZoe8cPlcCIgxUIyVVzNS3RZDoW+o5xQ+u59oX44pzAcLk03/3TNiae6GDt0M
         clU8q/MvC6vZ+F7nNLwiyE0tvXjnYsHCX6JaGGimnsRRWVaTYACaxo5URJRNAqNOytIV
         zz2+zpttjaL4+grorGQNnAzgDgUBViUgTmJYpyjxzQhgBvWHo8di50BBHcT20gevUjF8
         kcowoDR99V8bL7ROVYoWT1f1d+u2KjvDglJdLLeGKP//KinyKCD889SGLVKCnujOde/k
         yvKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uWuKgNmXAn+nY0mp5ruzBbGAh1vhy0hRNShqzy5Qq2Y=;
        b=CKD7kyvp4ElE49MFx3CGPV775Ncf6Qy1KfO5LT74uA3wTMsIkeIJuQRmYNMOSj9TKz
         VD531P7zdIPTsRnFnMQcAPxEGOr6HYD4N1SXsjRXvQxQuTnEbvzFK4JM/iUg8/ZArWZq
         wQlWkj+5/Ukp3eiR5I8HXpfZUG0RKLObWIlNEcWvddtzdNPmp3cpQ+qy6PaJRyhkdpU1
         +2VdNAVVdgPksf2cgyvhJrkURZPMjUjPozau/SabXUXgC8zQPmqXXKVHL9Uw5EhEKcyI
         yId8P1ce6B8XL+bGo5ksdJDyr7WBlXjKtjrkrYR/DZ0ByVz6hHys2yJVqNZB5Tx86JOO
         EMWA==
X-Gm-Message-State: ANhLgQ1CsVmcZr2ZkwK5Zsj3tOVp9ch5y8oXbDxEC4WFvX+zZ9gTxkpF
        WJIolyuGCgcal60EDs5HTK1E8A==
X-Google-Smtp-Source: ADFU+vt1KcpZigTvPaNuzCbAqPeMINODmYZZkpLaCeHE5did4FEpbbfoo5v5s+zHJGBc4ApH1GHt6A==
X-Received: by 2002:a92:405a:: with SMTP id n87mr605840ila.299.1583169590174;
        Mon, 02 Mar 2020 09:19:50 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q1sm6754642ile.71.2020.03.02.09.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 09:19:49 -0800 (PST)
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
To:     Coly Li <colyli@suse.de>, Oleg Nesterov <oleg@redhat.com>
Cc:     Michal Hocko <mhocko@kernel.org>, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz> <20200302134919.GB9769@redhat.com>
 <48c6480a-3b26-fb7f-034d-923f9b8875f1@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dfcd5b4d-592d-fe2a-5c25-ac22729b479e@kernel.dk>
Date:   Mon, 2 Mar 2020 10:19:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <48c6480a-3b26-fb7f-034d-923f9b8875f1@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/2/20 10:16 AM, Coly Li wrote:
> On 2020/3/2 9:49 下午, Oleg Nesterov wrote:
>> On 03/02, Michal Hocko wrote:
>>>
>>> I cannot really comment on the bcache part because I am not familiar
>>> with the code.
>>
>> same here...
>>
>>>> This patch calls flush_signals() in bcache_device_init() if there is
>>>> pending signal for current process. It avoids bcache registration
>>>> failure in system boot up time due to bcache udev rule timeout.
>>>
>>> this sounds like a wrong way to address the issue. Killing the udev
>>> worker is a userspace policy and the kernel shouldn't simply ignore it.
>>
>> Agreed. If nothing else, if a userspace process has pending SIKILL then
>> flush_signals() is very wrong.
>>
>>> Btw. Oleg, I have noticed quite a lot of flush_signals usage in the
>>> drivers land and I have really hard time to understand their purpose.
>>
>> Heh. I bet most if not all users of flush_signals() are simply wrong.
>>
>>> What is the actual valid usage of this function?
>>
>> I thinks it should die... It was used by kthreads, but today
>> signal_pending() == T is only possible if kthread does allow_signal(),
>> and in this case it should probably use kernel_dequeue_signal().
>>
>>
>> Say, io_sq_thread(). Why does it do
>>
>> 		if (signal_pending(current))
>> 			flush_signals(current);
>>
>> afaics this kthread doesn't use allow_signal/allow_kernel_signal, this
>> means that signal_pending() must be impossible even if this kthread sleeps
>> in TASK_INTERRUPTIBLE state. Add Jens.
> 
> Hi Oleg,
> 
> Can I use disallow_signal() before the registration begins and use
> allow_signal() after the registration done. Is this a proper way to
> ignore the signal sent by udevd for timeout ?
> 
> For me the above method seems to solve my problem too.

Really seems to me like you're going about this all wrong. The issue is
that systemd is killing the startup, because it's taking too long. Don't
try and work around that, ensure the timeout is appropriate.

What if someone else tried to kill the startup? It'd be pretty
frustrating that it was impossible, just because signals were blocked or
flushed. The assumption that systemd is the ONLY task that would want to
kill it is flawed.

-- 
Jens Axboe

