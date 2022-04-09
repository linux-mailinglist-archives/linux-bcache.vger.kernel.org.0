Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E20E4FA8F3
	for <lists+linux-bcache@lfdr.de>; Sat,  9 Apr 2022 16:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbiDIOcr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 9 Apr 2022 10:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiDIOcq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 Apr 2022 10:32:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D934FFD5
        for <linux-bcache@vger.kernel.org>; Sat,  9 Apr 2022 07:30:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4013F210E4;
        Sat,  9 Apr 2022 14:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649514637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kw2lRfjbFuzb6cXAIcS/k4RcsYfPL83thJfRsUjcbg8=;
        b=tkt/9Da/K0evcKvJK2O7UgsmeA7V5KMAMukomOx5FffB4gOoJE2JND7vSEjC88Z4v4+3SE
        fSPyQJn/ySLanoiQneTIQG1W+CR6127LMEOyJ6d1fI94/pn/ZGB+F0iHnvsTa2Dsl3J4Mm
        sRahEIJCeOUaBw9NmJneNaGdz/5IOfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649514637;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kw2lRfjbFuzb6cXAIcS/k4RcsYfPL83thJfRsUjcbg8=;
        b=Gn1y0b0Uo/1lVBiGBDiwVIlpQmrnC9nXH+EAqQcH5t+ZqwmufDZWHLtED9JT8uarRtgli1
        vz1y229w/fRqewBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 470F913A77;
        Sat,  9 Apr 2022 14:30:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pgthN4uYUWJGIgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 09 Apr 2022 14:30:35 +0000
Message-ID: <8865472d-6579-92fc-20c9-c4cef430253b@suse.de>
Date:   Sat, 9 Apr 2022 22:30:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] bcache: avoid unnecessary soft lockup in kworker
 update_writeback_rate()
Content-Language: en-US
To:     =?UTF-8?B?5p2O56OK?= <noctis.akm@gmail.com>
Cc:     linux-bcache@vger.kernel.org
References: <20220407171643.65177-1-colyli@suse.de>
 <CAMhKsXkfr6btADZbTcFEJ3y8Qi=A0cQk32pqwa7htbSGHrU_uA@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAMhKsXkfr6btADZbTcFEJ3y8Qi=A0cQk32pqwa7htbSGHrU_uA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/9/22 2:58 PM, 李磊 wrote:
>> The kworker routine update_writeback_rate() is schedued to update the
>> writeback rate in every 5 seconds by default. Before calling
>> __update_writeback_rate() to do real job, semaphore dc->writeback_lock
>> should be held by the kworker routine.
>>
>> At the same time, bcache writeback thread routine bch_writeback_thread()
>> also needs to hold dc->writeback_lock before flushing dirty data back
>> into the backing device. If the dirty data set is large, it might be
>> very long time for bch_writeback_thread() to scan all dirty buckets and
>> releases dc->writeback_lock.
> Hi Coly,
> cached_dev_write() needs dc->writeback_lock, if  the writeback thread
>   holds writeback_lock too long, high write IO latency may happen. I wonder

 From my observation, such situation happens in one of the last scan 
before all dirty data gets flushed. If the cache device is very large, 
and dirty keys are only a few, such scan will take quite long time.

It wasn't a problem years ago, but currently it is easy to have a 10TB+ 
cache device, now the latency is observed.


> if it is a nicer way to limit the scale of the scanning in writeback.
> For example,
> just scan 512GB in stead of the whole cache disk。

Scan each 512GB space doesn't help too much. Because current btree 
iteration code doesn't handle continue-from-where-stopped very well, 
next time when continue form where stoppped, the previous key might be 
invalided already.

An ideal way, might be split the single large btree into multiple ones. 
People suggested me to divide the single tree into e.g. 64 or 128 trees, 
and only lock a single tree when doing writeback on gc on one of the 
trees. Maybe now it is about time to think over it again...


Coly Li

