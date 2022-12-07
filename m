Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30823646009
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Dec 2022 18:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiLGRWU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Dec 2022 12:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiLGRWN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Dec 2022 12:22:13 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BF11DDC9
        for <linux-bcache@vger.kernel.org>; Wed,  7 Dec 2022 09:22:13 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id n63so7744626iod.7
        for <linux-bcache@vger.kernel.org>; Wed, 07 Dec 2022 09:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EpTDLOhW0V3+1aR8vlaV9Hai3rR7JGPJvFehDEM1z0k=;
        b=WuLBfeGFwu+0r21caxzCY0+TP72iv0Vmz6j4f2nARaTkZ6MmLakC7hya4ycSRvqMDI
         SuzvbugdfQlsXrJGaT4MBJtrovZDXTkclAPuy4ARX/NXLtySpWY43xZIWrBasgcQugq8
         vQhfZ35UxQngr2AbHjR8VvqDdM2S7bawB1nbVd8IAIAtAJ6QIM0groms0cVRZmf/5hJ5
         gYRuWN4pmn37QJI13DuMnWpuKPm3dQxH/KlZ9pWGQ70mwlSqfH7NoBL0xtcoQk0ex4xM
         qbmg7ziYNHJJjBjTSvOZVicehGzE9TQ8n7q/GwtauEdZJAs9Wa7FXxqQQfBLwFZUidsz
         /Q3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EpTDLOhW0V3+1aR8vlaV9Hai3rR7JGPJvFehDEM1z0k=;
        b=qTW8RFJffeqxH3m+CJExUZx3MdKNqooiepFlSxZfBU486otIAnPUKdpyERRFoy/10Q
         7fIKv5nqev30OHMz7TyKRraN1WXBj5loA1OhgHbCAkZcDFxewX1LBg40I5vlaFFQSpFU
         SUFwFfBodBCPZNIQqZN1pvhXbD4w8cjnzCuBDDZHRz08+6BymJG16E2BDLIvx1HA16hW
         1uMNF6r1pHl7KFy72CifamQhVgmcDtbO5CPW/o0+eIQE6UD+zcvUOkxAqcVJgs7xO+WB
         uJhrVpsJig8C/gH2+LwBm9D61vT60SX1ah1bLdcUuJlfwH45ke2y9Z4a/cYrXqKRG1a1
         KzOQ==
X-Gm-Message-State: ANoB5pkDPrXJiGC+36JxfUfySedAhRJK8VLhjMh1jdGk2L1IF6Y+lJqT
        00EXmW6e2+oAbf4QPgtVYzp3Qw==
X-Google-Smtp-Source: AA0mqf7/gBf7/XEEClF7Gq7hMc0QmhQHunFYc2f4SCWfcKxA9tFoQkk2RXV+JEDjVFWOG2u7WxQZig==
X-Received: by 2002:a05:6602:4296:b0:6e0:1464:a7d7 with SMTP id cd22-20020a056602429600b006e01464a7d7mr5843517iob.60.1670433732410;
        Wed, 07 Dec 2022 09:22:12 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q34-20020a056638346200b0038a44dbbd8fsm3597816jav.123.2022.12.07.09.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 09:22:11 -0800 (PST)
Message-ID: <b8deb6fa-8a09-c1af-278f-24e66afe367d@kernel.dk>
Date:   Wed, 7 Dec 2022 10:22:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC] block: Change the granularity of io ticks from ms to ns
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, Ming Lei <ming.lei@redhat.com>
Cc:     Gulam Mohamed <gulam.mohamed@oracle.com>,
        linux-block@vger.kernel.org, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
        minchan@kernel.org, ngupta@vflare.org, senozhatsky@chromium.org,
        colyli@suse.de, kent.overstreet@gmail.com, agk@redhat.com,
        snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, junxiao.bi@oracle.com,
        martin.petersen@oracle.com, kch@nvidia.com,
        drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, konrad.wilk@oracle.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20221206181536.13333-1-gulam.mohamed@oracle.com>
 <936a498b-19fe-36d5-ff32-817f153e57e3@huaweicloud.com>
 <Y5AFX4sxLRLV4uSt@T590>
 <aadfc6d2-ad04-279c-a1d6-7f634d0b2c99@huaweicloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aadfc6d2-ad04-279c-a1d6-7f634d0b2c99@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/7/22 6:09 AM, Yu Kuai wrote:
> Hi,
> 
> 在 2022/12/07 11:15, Ming Lei 写道:
>> On Wed, Dec 07, 2022 at 10:19:08AM +0800, Yu Kuai wrote:
>>> Hi,
>>>
>>> 在 2022/12/07 2:15, Gulam Mohamed 写道:
>>>> Use ktime to change the granularity of IO accounting in block layer from
>>>> milli-seconds to nano-seconds to get the proper latency values for the
>>>> devices whose latency is in micro-seconds. After changing the granularity
>>>> to nano-seconds the iostat command, which was showing incorrect values for
>>>> %util, is now showing correct values.
>>>
>>> This patch didn't correct the counting of io_ticks, just make the
>>> error accounting from jiffies(ms) to ns. The problem that util can be
>>> smaller or larger still exist.
>>
>> Agree.
>>
>>>
>>> However, I think this change make sense consider that error margin is
>>> much smaller, and performance overhead should be minimum.
>>>
>>> Hi, Ming, how do you think?
>>
>> I remembered that ktime_get() has non-negligible overhead, is there any
>> test data(iops/cpu utilization) when running fio or t/io_uring on
>> null_blk with this patch?
> 
> Yes, testing with null_blk is necessary, we don't want any performance
> regression.

null_blk is fine as a substitute, but I'd much rather run this on my
test bench with actual IO and devices.

> BTW, I thought it's fine because it's already used for tracking io
> latency.

Reading a nsec timestamp is a LOT more expensive than reading jiffies,
which is essentially free. If you look at the amount of work that's
gone into minimizing ktime_get() for the fast path in the IO stack,
then that's a testament to that.

So that's a very bad assumption, and definitely wrong.

-- 
Jens Axboe


