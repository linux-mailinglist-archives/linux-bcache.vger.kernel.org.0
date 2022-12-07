Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53156645A72
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Dec 2022 14:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiLGNJS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Dec 2022 08:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLGNJR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Dec 2022 08:09:17 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADED554E8;
        Wed,  7 Dec 2022 05:09:15 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NRyKc2Vfmz4f3w0Q;
        Wed,  7 Dec 2022 21:09:08 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBni9h0kJBjx41CBw--.7669S3;
        Wed, 07 Dec 2022 21:09:11 +0800 (CST)
Subject: Re: [RFC] block: Change the granularity of io ticks from ms to ns
To:     Ming Lei <ming.lei@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Gulam Mohamed <gulam.mohamed@oracle.com>,
        linux-block@vger.kernel.org, axboe@kernel.dk,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        christoph.boehmwalder@linbit.com, minchan@kernel.org,
        ngupta@vflare.org, senozhatsky@chromium.org, colyli@suse.de,
        kent.overstreet@gmail.com, agk@redhat.com, snitzer@kernel.org,
        dm-devel@redhat.com, song@kernel.org, dan.j.williams@intel.com,
        vishal.l.verma@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, junxiao.bi@oracle.com,
        martin.petersen@oracle.com, kch@nvidia.com,
        drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, konrad.wilk@oracle.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20221206181536.13333-1-gulam.mohamed@oracle.com>
 <936a498b-19fe-36d5-ff32-817f153e57e3@huaweicloud.com>
 <Y5AFX4sxLRLV4uSt@T590>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <aadfc6d2-ad04-279c-a1d6-7f634d0b2c99@huaweicloud.com>
Date:   Wed, 7 Dec 2022 21:09:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Y5AFX4sxLRLV4uSt@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBni9h0kJBjx41CBw--.7669S3
X-Coremail-Antispam: 1UD129KBjvJXoWrKF13ZrWDCw43Cw15CF1DAwb_yoW8Jr4kpr
        y3A3ZIkw48WFyFkwnFya1UJrWYvrn3ArZ8uFW5K3s7trn0kas3Jr4UG3WDCF92gFsIkF12
        gay2gas8ur48C3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9F14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
        3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
        sGvfC2KfnxnUUI43ZEXa7VUbJ73DUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

在 2022/12/07 11:15, Ming Lei 写道:
> On Wed, Dec 07, 2022 at 10:19:08AM +0800, Yu Kuai wrote:
>> Hi,
>>
>> 在 2022/12/07 2:15, Gulam Mohamed 写道:
>>> Use ktime to change the granularity of IO accounting in block layer from
>>> milli-seconds to nano-seconds to get the proper latency values for the
>>> devices whose latency is in micro-seconds. After changing the granularity
>>> to nano-seconds the iostat command, which was showing incorrect values for
>>> %util, is now showing correct values.
>>
>> This patch didn't correct the counting of io_ticks, just make the
>> error accounting from jiffies(ms) to ns. The problem that util can be
>> smaller or larger still exist.
> 
> Agree.
> 
>>
>> However, I think this change make sense consider that error margin is
>> much smaller, and performance overhead should be minimum.
>>
>> Hi, Ming, how do you think?
> 
> I remembered that ktime_get() has non-negligible overhead, is there any
> test data(iops/cpu utilization) when running fio or t/io_uring on
> null_blk with this patch?

Yes, testing with null_blk is necessary, we don't want any performance
regression.

BTW, I thought it's fine because it's already used for tracking io
latency.
> 
> 
> Thanks,
> Ming
> 
> 
> .
> 

