Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B2A4CCFD7
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Mar 2022 09:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiCDIXH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Mar 2022 03:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbiCDIXE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Mar 2022 03:23:04 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62FF199D57
        for <linux-bcache@vger.kernel.org>; Fri,  4 Mar 2022 00:22:17 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v4so6785010pjh.2
        for <linux-bcache@vger.kernel.org>; Fri, 04 Mar 2022 00:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=haQwXEy1aixxhhzlnMq6GeB8n4GW0AmqHywrZavZ6hM=;
        b=VD0KfTE3o6rbuMD7LVwwYNksASveJLV2+J2DnG86DsJsTxEQnp2cR2EBIUNEviBTTP
         RUJlRa92C5FzjE+Yu2xwh62hdC+6zLjQnzFPPJYc0KOKO88PPRC/9BB51CS/O7MHaIBp
         XL3rXtBGPZV35QbxX8m9vUiKFmh6exvMLnT7d0JzpKyyM+8kydSvjKqdHcM8M/Wzc2w8
         N3VrSjkXElEccwceOCEYmnqnC0vgtjUVX0f9gYvfGrL0eQcej5VFfnfHavVlXBhfj9f1
         foO78DfOJ7KA2i7ot8TS3AzEbj+Wxe40CJw5Sif7XqFxx+SbHuVmhhwagY5Zp/pr0KU6
         UfVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=haQwXEy1aixxhhzlnMq6GeB8n4GW0AmqHywrZavZ6hM=;
        b=edHnxkA5yMNovqvh+FZJAboHgkHDNxN1gB5snvvhct4ct6EA3ds2qqCdjNGJia8TA3
         iF6Rjej9Yyd+Zi1YjSQFoQBJPfdOYqIF4ezbp8NkdRbHrpgJvx5lQINtfk6GdxjGhX7Q
         PVJXjao/R7GsD3O9FiEMSYIUn/0261rSC2fA624/RbEYMldZ+C3qgqTZqjpHQyf/W2Hp
         fvsJjTnmBu1WjR6v5fftmTlh7sT2y7kNkg+HE8q1AHmY7Xi/ZMK53S2uBfmPqniCP4A2
         8uYfup2ypCyF04IgI2XqH91LfbggodEgc3GBlTbVZv1epRKh3zTBRPJsrU1CXvynU64x
         GPUg==
X-Gm-Message-State: AOAM533hwznJ8V0NtBgHandslxScKlKJOkIrSscpmiwAWth46ykMzXD6
        BF+FiskGlgiUwNaPOvfTygmS/g2tZtnZXUvD
X-Google-Smtp-Source: ABdhPJyDTzU2et+9uC1ekPh7zvQvypUHdkB3k4J32hH4NdH03PKs8BpVGl2JcVtLIQuWIAdznRJ6yQ==
X-Received: by 2002:a17:90b:1193:b0:1bc:1b5a:84e4 with SMTP id gk19-20020a17090b119300b001bc1b5a84e4mr9572236pjb.113.1646382137265;
        Fri, 04 Mar 2022 00:22:17 -0800 (PST)
Received: from [172.20.104.100] ([162.219.34.248])
        by smtp.gmail.com with ESMTPSA id o11-20020a056a0015cb00b004ce19332265sm5188169pfu.34.2022.03.04.00.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 00:22:17 -0800 (PST)
Message-ID: <055868d2-1363-da7f-ff4a-d232884d35b9@gmail.com>
Date:   Fri, 4 Mar 2022 16:22:14 +0800
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
 <6cab50d8-8771-8b6f-cd09-d318fc3986d3@suse.de>
From:   Zhang Zhen <zhangzhen.email@gmail.com>
In-Reply-To: <6cab50d8-8771-8b6f-cd09-d318fc3986d3@suse.de>
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


On 3/2/22 5:19 PM, Coly Li wrote:
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
> Hold on. Why do you think it should be fixed? As I said, it is 
> as-designed behavior.
> 
We use bcache in writearound mode, just cache read io.
Currently, bcache return io error during detach, randomly lead to
xfs force shutdown.

After bcache auto detach finished, some dir read write normaly, but
the others can't read write because of xfs force shutdown.
This inconsistency confuses filesystem users.

Thanks.
> 
> Coly Li
> 
