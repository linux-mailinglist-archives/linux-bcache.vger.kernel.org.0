Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DD84D3F1E
	for <lists+linux-bcache@lfdr.de>; Thu, 10 Mar 2022 03:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiCJCCa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 9 Mar 2022 21:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiCJCC3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 9 Mar 2022 21:02:29 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BDF6663E
        for <linux-bcache@vger.kernel.org>; Wed,  9 Mar 2022 18:01:29 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id n7so4563743oif.5
        for <linux-bcache@vger.kernel.org>; Wed, 09 Mar 2022 18:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=E6CghDD+Dx6aUY+JLznBpQ55HIwhnubm/OBspnZxPCQ=;
        b=aZ6c9TcZ68SEmguz+t/S3dcUkJvbjtxluC7GRCtT/jSsimv18CFYWbv17CPTkdbKVi
         DnAIYdxycHk2Qfl0ghL40q3LXuz/uI7o9Axn7NHu8uWh000EimhwH9gXtmYa0T8QD3IN
         49zNLFXYQ6mwRuBj5RrnTwrC1HN3ZRAVsnljketukQBccVf/8E0l1Mx+FQ3u3crzWZeR
         aTBlpQs4/olPscq6zmODUiY4ugKDKj5pEkYo8eepw9Jm0EsgRRIrues5aZfaMgQGnLvw
         uRMzJ7BnTBQMM7KtT9IZ9kxi0FskO8vElt/ferBr8O9gVVdvit+kOgC9Riu/+bpyVSIA
         QqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E6CghDD+Dx6aUY+JLznBpQ55HIwhnubm/OBspnZxPCQ=;
        b=35YT3u+PRFKwXA8sTSgGU9nmFK+72YLE7ao5RRRGotGNGucUwGHLRPT66EvIEG1/xm
         xpZj1CeuZ3YbdEbSMPA9OuF/erUECIuG2ZnOpd82b/fWaC21bMoEdujs3rCwZyEYvlNX
         GMlI9HhP2OJd1UuuSJLED+bytphlMPLNmlRk9uTbYHxzgmlzFFda6CypkODe1ZYI7ln9
         uwer9dStRP2cQq/XtBy68LHFD6gqVXysP3raQOzdYhfpkz40VYT/nXLnTx56YMf7QZfT
         UcqeT3lwT7yQLf/nusHnjH03VULhJiO4RCI4BU94qXn6vu0UXhb0c8E6qFC48lMW76id
         E/Bg==
X-Gm-Message-State: AOAM531P+RJOK9qsDT2ah8g5NFbRgOULQVj7ZLTykY/ltR0JV+Rufhe0
        u/ASt4ep+rfdr+STyXWC5LRMebMBxyD3Z/Rn
X-Google-Smtp-Source: ABdhPJykbxSvoj+XFCnNWCDDmHQA0MdsgGa8RqAvRb42FsbqRnEdGOY+rKkmgicHF//vqC8PsvTr7A==
X-Received: by 2002:a17:90b:3c5:b0:1bf:9766:2ed2 with SMTP id go5-20020a17090b03c500b001bf97662ed2mr10075603pjb.165.1646877677602;
        Wed, 09 Mar 2022 18:01:17 -0800 (PST)
Received: from [172.20.104.115] ([162.219.34.248])
        by smtp.gmail.com with ESMTPSA id lb1-20020a17090b4a4100b001bfb76e56d1sm2813743pjb.36.2022.03.09.18.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 18:01:17 -0800 (PST)
Message-ID: <3c56fa3b-f819-5468-796c-b47fd38e0a82@gmail.com>
Date:   Thu, 10 Mar 2022 10:01:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: bcache detach lead to xfs force shutdown
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, jianchao.wan9@gmail.com
References: <e6c45b07-769c-575b-0d9c-929aba6ab21a@gmail.com>
 <da192278-8d05-2cce-0301-abafeff3c2fb@suse.de>
 <252588da-1e44-71d9-95a0-39a70c5d3f42@gmail.com>
 <7047dc56-13cd-b333-4bd4-7b0aa33846a1@suse.de>
From:   Zhang Zhen <zhangzhen.email@gmail.com>
In-Reply-To: <7047dc56-13cd-b333-4bd4-7b0aa33846a1@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 3/9/22 9:14 PM, Coly Li wrote:
> On 2/23/22 8:26 PM, Zhang Zhen wrote:
>>
>> 在 2022/2/23 下午5:03, Coly Li 写道:
>>> On 2/21/22 5:33 PM, Zhang Zhen wrote:
>>>> Hi coly，
>>>>
>>>> We encounted a bcache detach problem, during the io process，the 
>>>> cache device become missing.
>>>>
>>>> The io error status returned to xfs， and in some case， the xfs do 
>>>> force shutdown.
>>>>
>>>> The dmesg as follows:
>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
>>>> IO error on writing btree.
>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p44: 
>>>> IO error on writing btree.
>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p44: 
>>>> IO error on writing btree.
>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: 
>>>> IO error on writing btree.
>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
>>>> IO error on writing btree.
>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: 
>>>> IO error on writing btree.
>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
>>>> IO error on writing btree.
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
>>>> "xfs_buf_iodone_callback_error" at daddr 0x80034658 len 32 error 12
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() bcache: error 
>>>> on 004f8aa7-561a-4ba7-bf7b-292e461d3f18:
>>>> Feb  2 20:59:23  kernel: journal io error
>>>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() , disabling 
>>>> caching
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: bcache: conditional_stop_bcache_device() 
>>>> stop_when_cache_set_failed of bcache43 is "auto" and cache is clean, 
>>>> keep it alive.
>>>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
>>>> "xlog_iodone" at daddr 0x400123e60 len 64 error 12
>>>> Feb  2 20:59:23  kernel: XFS (bcache43): xfs_do_force_shutdown(0x2) 
>>>> called from line 1298 of file fs/xfs/xfs_log.c. Return address = 
>>>> 00000000c1c8077f
>>>> Feb  2 20:59:23  kernel: XFS (bcache43): Log I/O Error Detected. 
>>>> Shutting down filesystem
>>>> Feb  2 20:59:23  kernel: XFS (bcache43): Please unmount the 
>>>> filesystem and rectify the problem(s)
>>>>
>>>>
>>>> We checked the code, the error status is returned in 
>>>> cached_dev_make_request and closure_bio_submit function.
>>>>
>>>> 1180 static blk_qc_t cached_dev_make_request(struct request_queue *q,
>>>> 1181                     struct bio *bio)
>>>> 1182 {
>>>> 1183     struct search *s;
>>>> 1184     struct bcache_device *d = bio->bi_disk->private_data;
>>>> 1185     struct cached_dev *dc = container_of(d, struct cached_dev, 
>>>> disk);
>>>> 1186     int rw = bio_data_dir(bio);
>>>> 1187
>>>> 1188     if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
>>>> &d->c->flags)) ||
>>>> 1189              dc->io_disable)) {
>>>> 1190         bio->bi_status = BLK_STS_IOERR;
>>>> 1191         bio_endio(bio);
>>>> 1192         return BLK_QC_T_NONE;
>>>> 1193     }
>>>>
>>>>  901 static inline void closure_bio_submit(struct cache_set *c,
>>>>  902                       struct bio *bio,
>>>>  903                       struct closure *cl)
>>>>  904 {
>>>>  905     closure_get(cl);
>>>>  906     if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
>>>>  907         bio->bi_status = BLK_STS_IOERR;
>>>>  908         bio_endio(bio);
>>>>  909         return;
>>>>  910     }
>>>>  911     generic_make_request(bio);
>>>>  912 }
>>>>
>>>> Can the cache set detached and don't return error status to fs?
>>>
>>>
>>> Hi Zhang,
>>>
>>>
>>> What is your kernel version and where do you get the kernel?
>>> My kernel version is 4.18 of Centos.
>> The code of this part is same with upstream kernel.
>>> It seems like an as designed behavior, could you please describe more 
>>> detail about the operation sequence?
>>>
>> Yes, i think so too.
>> The reproduce opreation as follows:
>> 1. mount a bcache disk with xfs
>>
>> /dev/bcache1 on /media/disk1 type xfs
>>
>> 2. run ls in background
>> #!/bin/bash
>>
>> while true
>> do
>>   echo 2 > /proc/sys/vm/drop_caches
>>   ls -R /media/disk1 > /dev/null
>> done
>>
>>
>> 3. remove cache disk sdc
>> echo 1 >/sys/block/sdc/device/delete
>>
>> 4. dmesg should get xfs error
>>
>> I write a patch to improve，please help to review it, thanks.
> 
> 
> Could you please post the patch in email body? Otherwise I am not able 
> to reply you in line. I read your patch, it is unacceptable in general, 
> but I'd like to provide my point for your reference.
> 
Ok，i will send the patch in another email.

Thanks.
> 
> Coly Li
> 
> 
> 
> 
