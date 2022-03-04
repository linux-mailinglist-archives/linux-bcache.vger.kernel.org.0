Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188F94CD04F
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Mar 2022 09:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbiCDIn0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Mar 2022 03:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbiCDInY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Mar 2022 03:43:24 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10EA251
        for <linux-bcache@vger.kernel.org>; Fri,  4 Mar 2022 00:42:33 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9828B21115;
        Fri,  4 Mar 2022 08:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646383352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17iNOWRst7arjIZ30fW5wgrAfIv7O8k6BRE1wXWGgVk=;
        b=0CbtC7dY99KYtvQRm7KFad4Dm19stRnkCl6eWmeZiQAnWaEP+37TmVa6I3Ehuv/Ok3S7lB
        gPERJwBUUe+kWqqIhWELTXxN6gpK0yVAUmHo1sbI9W0jRvbFRLLXWpxPOYRLxOgBMYwz3l
        1gghFt1XE/KBhDDLxV8sLDydYXyeVM0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646383352;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17iNOWRst7arjIZ30fW5wgrAfIv7O8k6BRE1wXWGgVk=;
        b=1MzL8sI3ZCH+ndrYPDougXgITcAOXbfDPdDgDMcIKCZrK/DYzVm2tfAsd+iH7W4CmWDBYt
        MXsY/2UW2ndiIpCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 659E113AF7;
        Fri,  4 Mar 2022 08:42:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wklOC/fQIWIbawAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 04 Mar 2022 08:42:31 +0000
Message-ID: <81a09386-1c4b-810c-a387-c636a0c3d5a5@suse.de>
Date:   Fri, 4 Mar 2022 16:42:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: bcache detach lead to xfs force shutdown
Content-Language: en-US
To:     Zhang Zhen <zhangzhen.email@gmail.com>, Nix <nix@esperi.org.uk>
Cc:     linux-bcache@vger.kernel.org, jianchao.wan9@gmail.com
References: <e6c45b07-769c-575b-0d9c-929aba6ab21a@gmail.com>
 <da192278-8d05-2cce-0301-abafeff3c2fb@suse.de>
 <252588da-1e44-71d9-95a0-39a70c5d3f42@gmail.com>
 <6cab50d8-8771-8b6f-cd09-d318fc3986d3@suse.de>
 <055868d2-1363-da7f-ff4a-d232884d35b9@gmail.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <055868d2-1363-da7f-ff4a-d232884d35b9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/4/22 4:22 PM, Zhang Zhen wrote:
>
> On 3/2/22 5:19 PM, Coly Li wrote:
>> On 2/23/22 8:26 PM, Zhang Zhen wrote:
>>>
>>> 在 2022/2/23 下午5:03, Coly Li 写道:
>>>> On 2/21/22 5:33 PM, Zhang Zhen wrote:
>>>>> Hi coly，
>>>>>
>>>>> We encounted a bcache detach problem, during the io process，the 
>>>>> cache device become missing.
>>>>>
>>>>> The io error status returned to xfs， and in some case， the xfs do 
>>>>> force shutdown.
>>>>>
>>>>> The dmesg as follows:
>>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
>>>>> IO error on writing btree.
>>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p44: 
>>>>> IO error on writing btree.
>>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p44: 
>>>>> IO error on writing btree.
>>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: 
>>>>> IO error on writing btree.
>>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
>>>>> IO error on writing btree.
>>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: 
>>>>> IO error on writing btree.
>>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
>>>>> IO error on writing btree.
>>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
>>>>> "xfs_buf_iodone_callback_error" at daddr 0x80034658 len 32 error 12
>>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() bcache: 
>>>>> error on 004f8aa7-561a-4ba7-bf7b-292e461d3f18:
>>>>> Feb  2 20:59:23  kernel: journal io error
>>>>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() , disabling 
>>>>> caching
>>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>>> Feb  2 20:59:23  kernel: bcache: conditional_stop_bcache_device() 
>>>>> stop_when_cache_set_failed of bcache43 is "auto" and cache is 
>>>>> clean, keep it alive.
>>>>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
>>>>> "xlog_iodone" at daddr 0x400123e60 len 64 error 12
>>>>> Feb  2 20:59:23  kernel: XFS (bcache43): 
>>>>> xfs_do_force_shutdown(0x2) called from line 1298 of file 
>>>>> fs/xfs/xfs_log.c. Return address = 00000000c1c8077f
>>>>> Feb  2 20:59:23  kernel: XFS (bcache43): Log I/O Error Detected. 
>>>>> Shutting down filesystem
>>>>> Feb  2 20:59:23  kernel: XFS (bcache43): Please unmount the 
>>>>> filesystem and rectify the problem(s)
>>>>>
>>>>>
>>>>> We checked the code, the error status is returned in 
>>>>> cached_dev_make_request and closure_bio_submit function.
>>>>>
>>>>> 1180 static blk_qc_t cached_dev_make_request(struct request_queue *q,
>>>>> 1181                     struct bio *bio)
>>>>> 1182 {
>>>>> 1183     struct search *s;
>>>>> 1184     struct bcache_device *d = bio->bi_disk->private_data;
>>>>> 1185     struct cached_dev *dc = container_of(d, struct 
>>>>> cached_dev, disk);
>>>>> 1186     int rw = bio_data_dir(bio);
>>>>> 1187
>>>>> 1188     if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
>>>>> &d->c->flags)) ||
>>>>> 1189              dc->io_disable)) {
>>>>> 1190         bio->bi_status = BLK_STS_IOERR;
>>>>> 1191         bio_endio(bio);
>>>>> 1192         return BLK_QC_T_NONE;
>>>>> 1193     }
>>>>>
>>>>>  901 static inline void closure_bio_submit(struct cache_set *c,
>>>>>  902                       struct bio *bio,
>>>>>  903                       struct closure *cl)
>>>>>  904 {
>>>>>  905     closure_get(cl);
>>>>>  906     if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
>>>>>  907         bio->bi_status = BLK_STS_IOERR;
>>>>>  908         bio_endio(bio);
>>>>>  909         return;
>>>>>  910     }
>>>>>  911     generic_make_request(bio);
>>>>>  912 }
>>>>>
>>>>> Can the cache set detached and don't return error status to fs?
>>>>
>>>>
>>>> Hi Zhang,
>>>>
>>>>
>>>> What is your kernel version and where do you get the kernel?
>>>> My kernel version is 4.18 of Centos.
>>> The code of this part is same with upstream kernel.
>>>> It seems like an as designed behavior, could you please describe 
>>>> more detail about the operation sequence?
>>>>
>>> Yes, i think so too.
>>> The reproduce opreation as follows:
>>> 1. mount a bcache disk with xfs
>>>
>>> /dev/bcache1 on /media/disk1 type xfs
>>>
>>> 2. run ls in background
>>> #!/bin/bash
>>>
>>> while true
>>> do
>>>   echo 2 > /proc/sys/vm/drop_caches
>>>   ls -R /media/disk1 > /dev/null
>>> done
>>>
>>>
>>> 3. remove cache disk sdc
>>> echo 1 >/sys/block/sdc/device/delete
>>>
>>> 4. dmesg should get xfs error
>>>
>>> I write a patch to improve，please help to review it, thanks.
>
>>
>> Hold on. Why do you think it should be fixed? As I said, it is 
>> as-designed behavior.
>>
> We use bcache in writearound mode, just cache read io.
> Currently, bcache return io error during detach, randomly lead to
> xfs force shutdown.
>
> After bcache auto detach finished, some dir read write normaly, but
> the others can't read write because of xfs force shutdown.
> This inconsistency confuses filesystem users.


Hi Zhen and Nix,

OK, I come to realize the motivation. Yes you are right, this is an 
awkward issue and good to be fixed.


Coly Li

