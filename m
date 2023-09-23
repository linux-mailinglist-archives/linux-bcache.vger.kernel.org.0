Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56777AC2A7
	for <lists+linux-bcache@lfdr.de>; Sat, 23 Sep 2023 16:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjIWO3a (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 23 Sep 2023 10:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjIWO33 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 23 Sep 2023 10:29:29 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FC319F
        for <linux-bcache@vger.kernel.org>; Sat, 23 Sep 2023 07:29:22 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-4054496bde3so18451765e9.1
        for <linux-bcache@vger.kernel.org>; Sat, 23 Sep 2023 07:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google; t=1695479361; x=1696084161; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NKGAzic/6A94/9gnqauzCtp08n/xFAbQaATDMzlJQIw=;
        b=I6NVXNs0EiGSMJh3MnTt+ZF33+HtqsefUuBg2b4OvXflF9HYrYGfSJxDjzRdQu1a9u
         5enwutBCtokzygXWjvB+HLQag3qQrIpT5d/zAO+BnxTHoE6mySKuLSTL+xRuUpyj8Pd5
         X2GKqE0ST8qXZyJrI8RRbnHbillSCEmN5UR6qE5jv3F+VUNc+Sz/vMQfO1+jOs3sjD5J
         lKnHoZIGzx4ETX/7KP0GsnvZ+uvKRxjZMhZE7SyraWAcukHm1g35jDXNxnKnsz+GonU8
         9X6MHpscakHEEWgL+lcsX3NT0JjPZ41R6EbYBWKki7Wk6xxatOMnIjF4x0DMAROlHfEd
         N4Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695479361; x=1696084161;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NKGAzic/6A94/9gnqauzCtp08n/xFAbQaATDMzlJQIw=;
        b=pU/0qsjhn9AFqnZnSCm0w4mm/Cb3sa3PqgtL3KZ4WhD+WH9uk8EgwykwFHeKiKjwBF
         ns8nbUAzXy2YvkMguhM9W9OPucaXNWfkErOLXQhisCyKxCFtqt3zUeULR0sGyN+Lh6a3
         YtN10MsD6YnqsVMvlgYvnYouUHj71yqkczbOwOdOj2c0RYIUCDFJerdXdMFH8El1S6b1
         p5RI63E+sw8Vzq3DOfuEe7E5PhezO3huJ288YEkudyR1MvNKd42i0Ql17zbWJl3R85B+
         gleWKPgJYdk/yY1I3gY6XIcQ0D/SP5gzjMf21HUi69Q9578z/8W5pcLM4vw2c3i9IaqV
         OGCg==
X-Gm-Message-State: AOJu0YxKGOyxnYBqmsxuuA6/iYZsyvKaPjuVhhlPkU6mpaa2wCzE+LmV
        IhS92FQsnaHfvYGca3OrEESCR2/8xYfPh+aXEGt8Ow==
X-Google-Smtp-Source: AGHT+IG3sSGekobM2ltVvG0qB6DGPT1s5rDjyvzv/InGJ2jl5ImajKJASJwmgJiPh0MlUP/cqFp8Gw==
X-Received: by 2002:a05:600c:152:b0:401:db82:3edf with SMTP id w18-20020a05600c015200b00401db823edfmr1770947wmm.39.1695479359994;
        Sat, 23 Sep 2023 07:29:19 -0700 (PDT)
Received: from [192.168.1.68] (37.238.14.37.dynamic.jazztel.es. [37.14.238.37])
        by smtp.gmail.com with ESMTPSA id v20-20020a05600c215400b00401b242e2e6sm4731391wml.47.2023.09.23.07.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Sep 2023 07:29:19 -0700 (PDT)
Message-ID: <f3bbd0b9-1783-e924-4b8c-c825d8eb2ede@devo.com>
Date:   Sat, 23 Sep 2023 16:29:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Unusual value of optimal_io_size prevents bcache initialization
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <4fd61b55-195f-8dc5-598e-835bd03a00ec@devo.com>
 <iymfluasxp5webd4hbgxqsuzq6jbeojti7lfue5e4wd3xcdn4x@fcpmy7uxgsie>
Content-Language: en-US
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
In-Reply-To: <iymfluasxp5webd4hbgxqsuzq6jbeojti7lfue5e4wd3xcdn4x@fcpmy7uxgsie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,
thank you very much for your quick reply.

On 22/9/23 16:22, Coly Li wrote:
> On Fri, Sep 22, 2023 at 03:26:46PM +0200, Andrea Tomassetti wrote:
>> Hi Coly,
>> recently I was testing bcache on new HW when, while creating a bcache device
>> with make-bcache -B /dev/nvme16n1, I got this kernel WARNING:
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 41 PID: 648 at mm/util.c:630 kvmalloc_node+0x12c/0x178
>> Modules linked in: nf_conntrack_netlink nf_conntrack nf_defrag_ipv6
>> nf_defrag_ipv4 nfnetlink_acct wireguard libchacha20poly1305 chacha_neon
>> poly1305_neon ip6_udp_tunnel udp_tunnel libcurve25519_generic libchacha
>> nfnetlink ip6table_filter ip6_tables iptable_filter bpfilter nls_iso8859_1
>> xfs libcrc32c dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua bcache
>> crc64 raid0 aes_ce_blk crypto_simd cryptd aes_ce_cipher crct10dif_ce
>> ghash_ce sha2_ce sha256_arm64 ena sha1_ce sch_fq_codel drm efi_pstore
>> ip_tables x_tables autofs4
>> CPU: 41 PID: 648 Comm: kworker/41:2 Not tainted 5.15.0-1039-aws
>> #44~20.04.1-Ubuntu
>> Hardware name: DEVO new fabulous hardware/, BIOS 1.0 11/1/2018
>> Workqueue: events register_bdev_worker [bcache]
>> pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : kvmalloc_node+0x12c/0x178
>> lr : kvmalloc_node+0x74/0x178
>> sp : ffff80000ea4bc90
>> x29: ffff80000ea4bc90 x28: ffffdfa18f249c70 x27: ffff0003c9690000
>> x26: ffff00043160e8e8 x25: ffff000431600040 x24: ffffdfa18f249ec0
>> x23: ffff0003c1d176c0 x22: 00000000ffffffff x21: ffffdfa18f236938
>> x20: 00000000833ffff8 x19: 0000000000000dc0 x18: 0000000000000000
>> x17: ffff20de6376c000 x16: ffffdfa19df02f48 x15: 0000000000000000
>> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
>> x11: 0000000000000000 x10: 0000000000000000 x9 : ffffdfa19df8d468
>> x8 : ffff00043160e800 x7 : 0000000000000010 x6 : 000000000000c8c8
>> x5 : 00000000ffffffff x4 : 0000000000012dc0 x3 : 0000000100000000
>> x2 : 00000000833ffff8 x1 : 000000007fffffff x0 : 0000000000000000
>> Call trace:
>>   kvmalloc_node+0x12c/0x178
>>   bcache_device_init+0x80/0x2e8 [bcache]
>>   register_bdev_worker+0x228/0x450 [bcache]
>>   process_one_work+0x200/0x4d8
>>   worker_thread+0x148/0x558
>>   kthread+0x114/0x120
>>   ret_from_fork+0x10/0x20
>> ---[ end trace e326483a1d681714 ]---
>> bcache: register_bdev() error nvme16n1: cannot allocate memory
>> bcache: register_bdev_worker() error /dev/nvme16n1: fail to register backing
>> device
>> bcache: bcache_device_free() bcache device (NULL gendisk) stopped
>>
>> I tracked down the root cause: in this new HW the disks have an
>> optimal_io_size of 4096. Doing some maths, it's easy to find out that this
>> makes bcache initialization fails for all the backing disks greater than 2
>> TiB. Is this a well-known limitation?
>>
>> Analyzing bcache_device_init I came up with a doubt:
>> ...
>> 	n = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
>> 	if (!n || n > max_stripes) {
>> 		pr_err("nr_stripes too large or invalid: %llu (start sector beyond end of
>> disk?)\n",
>> 			n);
>> 		return -ENOMEM;
>> 	}
>> 	d->nr_stripes = n;
>>
>> 	n = d->nr_stripes * sizeof(atomic_t);
>> 	d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
>> ...
>> Is it normal that n is been checked against max_stripes _before_ its value
>> gets changed by a multiply it by sizeof(atomic_t) ? Shouldn't the check
>> happen just before trying to kvzalloc n?
>>
> 
> The issue was triggered by d->nr_stripes which was orinially from
> q->limits.io_opt which is 8 sectors. Normally the backing devices announce
> 0 sector io_opt, then d->stripe_size will be 1<< 31 in bcache_device_init().
> Number n from DIV_ROUND_UP_ULL() will be quite small. When io_opt is 8
> sectors, number n from DIV_ROUND_UP_ULL() is possible to quite big for
> a large size backing device e.g. 2TB
> 
Thanks for the explanation, that was already clear to me but I didn't 
included in my previous message. I just quickly hided it with the 
expression "doing some maths".

> Therefore the key point is not checking n after it is multiplified by
> sizeof(atomic_t), the question is from n itself -- the value is too big.
> 
What I was trying to point out with when n gets checked is that there 
are cases in which the check (if (!n || n > max_stripes)) passes but 
then, because n gets multiplied by sizeof(atomic_t) the kvzalloc fails. 
We could have prevented this failing by checking n after multiplying it, no?
> Maybe bcache should not directly use q->limits.io_opt as d->stripe_size,
> it should be some value less than 1<<31 and aligned to optimal_io_size.
> 
> After the code got merged into kernel for 10+ years, it is time to improve
> this calculation :-) >
Yeah, one of the other doubts I had was exactly regarding this value and 
if it is still "actual" to calculate it that way. Unfortunately, I don't 
have the expertise to have an opinion on it. Would you be so kind to 
share your knowledge and let me understand why it is calculated this way 
and why is it using the optimal io size? Is it using it to "writeback" 
optimal-sized blokes?

>> Another consideration, stripe_sectors_dirty and full_dirty_stripes, the two
>> arrays allocated using n, are being used just in writeback mode, is this
>> correct? In my specific case, I'm not planning to use writeback mode so I
>> would expect bcache to not even try to create those arrays. Or, at least, to
>> not create them during initialization but just in case of a change in the
>> working mode (i.e. write-through -> writeback).
> 
> Indeed, Mingzhe Zou (if I remember correctly) submitted a patch for this
> idea, but it is blocked by other depending patches which are not finished
> by me. Yes I like the idea to dynamically allocate/free d->stripe_sectors_dirty
> and d->full_dirty_stripes when they are necessary. I hope I may help to make
> the change go into upstream sooner.
> 
> I will post a patch for your testing.
> 
This would be great! Thank you very much! On the other side, if there's 
anything I can do to help I would be glad to contribute.

Regards,
Andrea

> Thanks in advance.
> 
