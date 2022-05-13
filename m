Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FAB5265D5
	for <lists+linux-bcache@lfdr.de>; Fri, 13 May 2022 17:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377250AbiEMPR3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 13 May 2022 11:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352924AbiEMPR2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 May 2022 11:17:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011305DA0C
        for <linux-bcache@vger.kernel.org>; Fri, 13 May 2022 08:17:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B1EEA21AAC;
        Fri, 13 May 2022 15:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652455046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgzHWCVSXbaQuTfBvigH/Py+Yk7WuUF5pNuO7TdQ+kQ=;
        b=mHwdDX61yRE6wHm1q5L8YeHcDTKT3wZ7Lx/QDNUdezVJq1eT2p/OUkmgTzaz6JXCLsa5qk
        37nEUSzg98EpxHg0eUqZKfc3Oouafat7eB6OL8tqbrY1LRPoYhFY9pJfPMSZFt8QsAszFo
        ZPc8D2SjXvWJ/opY65mazP6QAUIeniY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652455046;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgzHWCVSXbaQuTfBvigH/Py+Yk7WuUF5pNuO7TdQ+kQ=;
        b=z3QpvHd08XporHTwlfF2a1GhCduA3N2yZ6/9WGYXtBjmFWnK6t3EWA6vkpSjO12GF0wUHb
        RBhotxptPKFLclBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3842213446;
        Fri, 13 May 2022 15:17:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3n+pAIV2fmJJIQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 13 May 2022 15:17:25 +0000
Message-ID: <428a70b3-f671-e6fb-93d1-0a975da35ad8@suse.de>
Date:   Fri, 13 May 2022 23:17:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH] bcache: remove unnecessary flush_workqueue
Content-Language: en-US
To:     =?UTF-8?B?5p2O56OK?= <noctis.akm@gmail.com>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        Li Lei <lilei@szsandstone.com>
References: <20220327072038.12385-1-lilei@szsandstone.com>
 <40862b68-e81d-089b-d713-b0e6e2bd7e04@suse.de>
 <CAMhKsXnLdAjSN00WpCrq4P-3Z6PEf+vp_QfiHcwCLuVH9s5z_Q@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAMhKsXnLdAjSN00WpCrq4P-3Z6PEf+vp_QfiHcwCLuVH9s5z_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/9/22 9:17 AM, 李磊 wrote:
> Coly Li <colyli@suse.de> 于2022年4月8日周五 00:54写道：
>> On 3/27/22 3:20 PM, Li Lei wrote:
>>> All pending works will be drained by destroy_workqueue(), no need to call
>>> flush_workqueue() explicitly.
>>>
>>> Signed-off-by: Li Lei <lilei@szsandstone.com>
>>> ---
>>>    drivers/md/bcache/writeback.c | 5 ++---
>>>    1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>>> index 9ee0005874cd..2a6d9f39a9b1 100644
>>> --- a/drivers/md/bcache/writeback.c
>>> +++ b/drivers/md/bcache/writeback.c
>>> @@ -793,10 +793,9 @@ static int bch_writeback_thread(void *arg)
>>>                }
>>>        }
>>>
>>> -     if (dc->writeback_write_wq) {
>>> -             flush_workqueue(dc->writeback_write_wq);
>>> +     if (dc->writeback_write_wq)
>>>                destroy_workqueue(dc->writeback_write_wq);
>>> -     }
>>> +
>>>        cached_dev_put(dc);
>>>        wait_for_kthread_stop();
>>>
>> The above code is from commit 7e865eba00a3 ("bcache: fix potential
>> deadlock in cached_def_free()"). I explicitly added extra
>> flush_workqueue() was because of workqueue_sysfs_unregister(wq) in
>> destory_workqueue().
>>
>> workqueue_sysfs_unregister() is not simple because it calls
>> device_unregister(), and the code path is long. During reboot I am not
>> sure whether extra deadlocking issue might be introduced. So the safe
>> way is to explicitly call flush_workqueue() firstly to wait for all
>> kwork finished, then destroy it.
>>
>> It has been ~3 years passed, now I am totally OK with your above change.
>> But could you please test your patch with lockdep enabled, and see
>> whether there is no lock warning observed? Then I'd like to add it into
>> my test directory.
>>
> OK，I will test this scenario.


Any progress?


Coly Li

