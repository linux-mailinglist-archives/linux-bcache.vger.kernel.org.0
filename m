Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5917175DC8
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Mar 2020 16:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCBPB7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 10:01:59 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38263 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgCBPB7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 10:01:59 -0500
Received: by mail-io1-f67.google.com with SMTP id s24so11859912iog.5
        for <linux-bcache@vger.kernel.org>; Mon, 02 Mar 2020 07:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qihmoD83dlx2UdkzRIwQHSPZTcBU16FDDrjf79PR52Q=;
        b=TDUydw2hE8MW4D+0jWYJtk1e43FYbSEytENeZvXaGDktl8liVT6Gt3MjGljbvgqZuc
         RG3JsCgP6s5FzljK2gyZk+KC6ys91+kQPzt7dTUHvPBq8I7NrfkAU0cb0hBlwz+Ge3tg
         M2j+mcS/odv3zIEjQS/9mQjUPxK9YaklNgK735WfBY7DzsUOJtGcjnP008qPzWBFEyH3
         vLlW9PnADh1RbKD7+HlGLvGFbq/BI/ShF+9cfcx6Ir+fzbnieNCBp7uhiX3oiyvZv6QI
         98jA+WEomtVfg35H0DyayPrv6wes0hqJP2OLXaasthDUQGGdFbRhtSoZHOb/yM9/BFO/
         yLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qihmoD83dlx2UdkzRIwQHSPZTcBU16FDDrjf79PR52Q=;
        b=qgTCDzjpXiV79DD1ooA3pG2DfJDh5uKkrBivzypV3W3qW+znKFxj7TukI07/6hm7lU
         RMDqxJQ2HvUXBNZlv++VVp+EnIy6hWD//N5gGgodWAvEvAKyFsp1y0ARScvLwZ0kSbuB
         pvYL7q2N1hlXFSJSXz+Lq3bA5Io6utRk8orZ+WoYXJ4WTpWfcxvxUpGw8hLgcU9p1IlA
         dRzU84B2tWdb4TLIE4og8U8ow4l0n//2R1zFXeAkQ20NK2oKfAJh+5m9BTmscaakXawA
         gCB3qFi9DLr5mokkkogzQPUrMkfqqnpWf1KaLiEvvfCcj3bnflDxEibmzdK0znq0mItB
         lYSA==
X-Gm-Message-State: APjAAAUO8q2EPQ/TF9b2SsuBPwoluD+605No4BUGhXqubCQnciXn+1lS
        nWEce7jhxmElhjfSc/TRZFr6Gg==
X-Google-Smtp-Source: APXvYqz+bd8MGcypER7i3EmoVclQ6zpfDlSJx9wXSgMOBjhSW63XSciAIHNogDjdKWORAk/mwF6C2g==
X-Received: by 2002:a6b:400b:: with SMTP id k11mr13507493ioa.256.1583161318801;
        Mon, 02 Mar 2020 07:01:58 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q21sm4275591ion.73.2020.03.02.07.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 07:01:58 -0800 (PST)
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
To:     Michal Hocko <mhocko@kernel.org>, Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com, Oleg Nesterov <oleg@redhat.com>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <429df503-00b7-a433-5f6f-08b3f232a1bf@kernel.dk>
Date:   Mon, 2 Mar 2020 08:01:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302122748.GH4380@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/2/20 5:27 AM, Michal Hocko wrote:
> [Cc Oleg]
> 
> On Mon 02-03-20 17:34:49, Coly Li wrote:
>> When cache device and cached device are registered simuteneously and
>> register_cache() firstly acquires bch_register_lock. register_bdev()
>> has to wait before register_cache() finished, it might be a very long
>> time.
>>
>> If the registration is from udev rules in system boot up time, and
>> registration is not completed before udev timeout (default 180s), the
>> registration process will be killed by udevd. Then the following calls
>> to kthread_run() or kthread_create() will fail due to the pending
>> signal (they are implemented this way at this moment).
>>
>> For boot time, this is not good, because it means a cache device with
>> huge cached data will always fail in boot time, just because it
>> spends too much time to check its internal meta data (btree and dirty
>> sectors).
>>
>> The failure for cache device registration is solved by previous
>> patches, but failure due to timeout also exists in cached device
>> registration. As the above text explains, cached device registration
>> may also be timeout if it is blocked by a timeout cache device
>> registration process. Then in the following code path,
>>     bioset_init() <= bcache_device_init() <= cached_dev_init() <=
>>     register_bdev() <= register_bcache()
>> bioset_init() will fail because internally kthread_create() will fail
>> for pending signal in the following code path,
>>     bioset_init() => alloc_workqueue() => init_rescuer() =>
>>     kthread_create()
>>
>> Maybe fix kthread_create() and kthread_run() is better method, but at
>> this moment a fast workaroudn is to flush pending signals before
>> calling bioset_init() in bcache_device_init().
> 
> I cannot really comment on the bcache part because I am not familiar
> with the code. It is quite surprising to see an initialization taking
> that long though.
> 
> Anyway
> 
>> This patch calls flush_signals() in bcache_device_init() if there is
>> pending signal for current process. It avoids bcache registration
>> failure in system boot up time due to bcache udev rule timeout.
> 
> this sounds like a wrong way to address the issue. Killing the udev
> worker is a userspace policy and the kernel shouldn't simply ignore it.
> Is there any problem to simply increase the timeout on the system which
> uses a large bcache?

On top of that, what if signals were sent for other reasons than just
terminate it? Flushing a fatal signal from "some task" seems bad enough
on its own, but we could be losing others as well.

Coly, this seems like a very bad idea. And the same goes for the
existing flush_signals() in bcache. It's just not the right way to deal
with it, and it could be causing other issues.

-- 
Jens Axboe

