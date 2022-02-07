Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48A24AB637
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Feb 2022 09:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbiBGIFY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Feb 2022 03:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244852AbiBGH4F (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Feb 2022 02:56:05 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315FDC0401C5
        for <linux-bcache@vger.kernel.org>; Sun,  6 Feb 2022 23:56:05 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DD8E7210EA;
        Mon,  7 Feb 2022 07:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644220563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k8pKhFwq5Y4fIb6IMNB+2KRHmXCv7E0WFXTwS8LXMKs=;
        b=vSsymPfJBJOxhCqaW0BHsspnFwYomjo6+bHEyscM8aYUFi+UH4DHKPE6UovqUQaWDl3eRl
        4QbV3FY73H7e9AZ+H1kFDe+yjBcsk3/m5z6xjkMFOV+sbREKHePgC4unpqZrSFXIdwrZyH
        armwSNVBatbwt42cziphiBzGZo0TC/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644220563;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k8pKhFwq5Y4fIb6IMNB+2KRHmXCv7E0WFXTwS8LXMKs=;
        b=GpNtpO8x9jj83czTQsIMwDDBb08K8CxUMNlYzOwETap/81k4Pcz4B8/SDDaLc8UG14Z+IG
        UT7icER1Wocp9eCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 263B013ABC;
        Mon,  7 Feb 2022 07:56:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0enpMZLQAGJUawAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 07 Feb 2022 07:56:02 +0000
Message-ID: <aeee8f71-0a0d-a78c-eb5c-a32b7b7444f2@suse.de>
Date:   Mon, 7 Feb 2022 15:56:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: Bad/Unaligned block number requested
Content-Language: en-US
From:   Coly Li <colyli@suse.de>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org
References: <alpine.LRH.2.11.1804132229570.9848@mail.ewheeler.net>
 <3d9f59c0-663c-6523-add5-5374ee1f20af@suse.de>
 <alpine.LRH.2.11.1804162231170.12553@mail.ewheeler.net>
 <0a52f7b7-336d-2eb8-f068-7956065369da@suse.de>
 <alpine.LRH.2.11.1804190010390.11343@mail.ewheeler.net>
 <f9a3f6db-2d24-4cee-9f47-2a5dc13c5a50@suse.de>
 <alpine.LRH.2.11.1804191629090.25046@mail.ewheeler.net>
 <2cd3be1c-9095-701e-d4e7-dbb67d1d128f@suse.de>
 <alpine.LRH.2.11.1804262010420.12327@mail.ewheeler.net>
 <alpine.LRH.2.11.1804262029550.12327@mail.ewheeler.net>
 <09e2074f-defd-7eb7-f8fc-23c2aabe1562@suse.de>
 <alpine.LRH.2.11.1805051927520.28587@mail.ewheeler.net>
 <9e567cb0-38b1-8a93-7065-d7d394a60f98@suse.de>
 <alpine.LRH.2.11.1805072237260.9131@mail.ewheeler.net>
 <7aa118bf-f0bc-f6a8-f300-d7429c2ae430@suse.de>
 <alpine.LRH.2.11.1805081646200.20954@mail.ewheeler.net>
 <9bea1638-2d47-bd3d-86e5-8b52efee452b@suse.de>
In-Reply-To: <9bea1638-2d47-bd3d-86e5-8b52efee452b@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/9/18 3:36 PM, Coly Li wrote:
> On 2018/5/9 12:57 AM, Eric Wheeler wrote:
>> On Tue, 8 May 2018, Coly Li wrote:
>
>> Hi Coly,
>>
>> We did get traces over night, so hopefully these are useful. In summary,
>> these are the ones that hit:
>>
>>   check_4k_alignment() KEY_OFFSET(&w->key) is not 4KB aligned
>>   check_4k_alignment() KEY_OFFSET(l) + KEY_SIZE(r) is not 4KB aligned
>>   check_4k_alignment() KEY_START(k) is not 4KB aligned
>>
>> The whole dmesg output that we have is here: https://pastebin.com/nuYFi66K
>>
>> And some of the traces separated by error message are shown below. The
>> ones below have a unique backtrace, but they may not cover all unique
>> backtraces.
>>
>> ====================================================================
>>
>> Of those that hit, These are the ones that were accompanied by SCSI errors:
>>
>> [54947.892574] bcache: check_4k_alignment() KEY_OFFSET(&w->key) is not 4KB aligned: 15724561783
>> [54947.893173] CPU: 5 PID: 1166 Comm: bcache_writebac Tainted: G           O    4.1.49-5.el7.x86_64 #1
>> [54947.893757] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.10 01/09/2014
>> [54947.894323]  0000000000000286 8c136ca15cff4205 ffff8807ebea3d58 ffffffff816ff534
>> [54947.894907]  ffff88080a7b6aa0 ffff88080a7b0000 ffff8807ebea3d68 ffffffffa05beb63
>> [54947.895515]  ffff8807ebea3e08 ffffffffa05be174 00000003a93e4e90 ffff8807ef36c4c0
>> [54947.896132] Call Trace:
>> [54947.896705]  [<ffffffff816ff534>] dump_stack+0x63/0x81
>> [54947.897285]  [<ffffffffa05beb63>] check_4k_alignment.part.9+0x24/0x26 [bcache]
>> [54947.897853]  [<ffffffffa05be174>] read_dirty+0x444/0x4a0 [bcache]
>> [54947.898418]  [<ffffffffa05be1d0>] ? read_dirty+0x4a0/0x4a0 [bcache]
>> [54947.898980]  [<ffffffffa05be5cc>] bch_writeback_thread+0x3fc/0x4e0 [bcache]
>> [54947.899544]  [<ffffffffa05be1d0>] ? read_dirty+0x4a0/0x4a0 [bcache]
>> [54947.900121]  [<ffffffff810c10d8>] kthread+0xd8/0xf0
>> [54947.900673]  [<ffffffff810c1000>] ? kthread_create_on_node+0x1b0/0x1b0
>> [54947.901226]  [<ffffffff817074d2>] ret_from_fork+0x42/0x70
>> [54947.901783]  [<ffffffff810c1000>] ? kthread_create_on_node+0x1b0/0x1b0
>> [54947.902401] sd 0:0:0:2: [sdc] Unaligned block number requested: sector_size=4096, block=353041024, blk_rq=23
>> [54947.903054] bcache: bch_count_io_errors() dm-6: IO error on reading dirty data from cache, recovering
>> [54947.903874] sd 0:0:0:1: [sdb] Unaligned block number requested: sector_size=4096, block=15724561760, blk_rq=23
>>
>>
>> [54958.301274] bcache: check_4k_alignment() KEY_OFFSET(&w->key) is not 4KB aligned: 15725385535
>> [54958.301889] CPU: 2 PID: 1166 Comm: bcache_writebac Tainted: G           O    4.1.49-5.el7.x86_64 #1
>> [54958.302532] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.10 01/09/2014
>> [54958.303144]  0000000000000286 8c136ca15cff4205 ffff8807ebea3d58 ffffffff816ff534
>> [54958.303805]  ffff88080a7b7dc0 ffff88080a7b0000 ffff8807ebea3d68 ffffffffa05beb63
>> [54958.304423]  ffff8807ebea3e08 ffffffffa05be174 00000003a949ec10 ffff8807ef36c4c0
>> [54958.305080] Call Trace:
>> [54958.305728]  [<ffffffff816ff534>] dump_stack+0x63/0x81
>> [54958.306371]  [<ffffffffa05beb63>] check_4k_alignment.part.9+0x24/0x26 [bcache]
>> [54958.307049]  [<ffffffffa05be174>] read_dirty+0x444/0x4a0 [bcache]
>> [54958.307694]  [<ffffffffa05be1d0>] ? read_dirty+0x4a0/0x4a0 [bcache]
>> [54958.308338]  [<ffffffffa05be5cc>] bch_writeback_thread+0x3fc/0x4e0 [bcache]
>> [54958.308986]  [<ffffffffa05be1d0>] ? read_dirty+0x4a0/0x4a0 [bcache]
>> [54958.309631]  [<ffffffff810c10d8>] kthread+0xd8/0xf0
>> [54958.310267]  [<ffffffff810c1000>] ? kthread_create_on_node+0x1b0/0x1b0
>> [54958.310914]  [<ffffffff817074d2>] ret_from_fork+0x42/0x70
>> [54958.311533]  [<ffffffff810c1000>] ? kthread_create_on_node+0x1b0/0x1b0
>> [54958.312265] sd 0:0:0:2: [sdc] Unaligned block number requested: sector_size=4096, block=387084760, blk_rq=31
>> [54958.313064] bcache: bch_count_io_errors() dm-6: IO error on reading dirty data from cache, recovering
>> [54958.314154] sd 0:0:0:1: [sdb] Unaligned block number requested: sector_size=4096, block=15725385504, blk_rq=31
>>
> Hi Eric,
>
> Wow, the above lines are very informative, thanks!
> I will start to look into what happens here. And at the meantime I will
> compose another patch which does extra LBA 4k alignment check in
> make_request() entries, to make sure I don't miss anything.

Hi Eric,

Now I have two 4Kn SSD (format by intelmas with your hint), I use the 
800G SSD as cache device and another 2TB SSD as backing device. They are 
all formatted as 4K sector size by intelmas.

Currently I run fio with random 4K size write on Linux v5.16 kernel, and 
try to run it overnight. Do you have any suggestion to run some workload 
similar to your condition?

Thanks.

Coly Li


