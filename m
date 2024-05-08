Return-Path: <linux-bcache+bounces-428-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B21AC8C0101
	for <lists+linux-bcache@lfdr.de>; Wed,  8 May 2024 17:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6825C1F28A39
	for <lists+linux-bcache@lfdr.de>; Wed,  8 May 2024 15:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6F9127B53;
	Wed,  8 May 2024 15:32:48 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m25485.xmail.ntesmail.com (mail-m25485.xmail.ntesmail.com [103.129.254.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8242E7641B
	for <linux-bcache@vger.kernel.org>; Wed,  8 May 2024 15:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.129.254.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715182368; cv=none; b=Q31btAojltp6Hlh0INdpnkgSJSEWqn7dg0M7dIOtlvMkg6E62RCwrdZ0R3jhQcT8TgzuwD4kCsd+6RnSc3NPNVWrtVFGUQmH8oQXjhCjc31UEHkGhjHPP80LpncrixgFBdSf9c8ZK6hAGSe5uIlbII+mVFjLGnH8hRW+R/CbP10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715182368; c=relaxed/simple;
	bh=b7YzN2IYvYBan0VOB0nDz30Zkjvu1Kh6OHpAcdigdjo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RX1z3O7UMyIARAbgilZXsgtrqLDuOnxB5/2vwm9TMygCzsCDIn5JBniBypULD7yQoYKCc8hXI2p6r5l1hH9EO17Rv+NNLA5518wdKBWsoEwPEN1SB2yAynaVNk/M8lCL/MoQrTXxYoJvcjU0RE8N46wlLL0kweVnkKYmpV3VOO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn; spf=none smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=103.129.254.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=easystack.cn
Received: from [192.168.122.189] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 78483860192;
	Wed,  8 May 2024 10:34:09 +0800 (CST)
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Coly Li <colyli@suse.de>, Robert Pang <robertpang@google.com>,
 mingzhe.zou@easystack.cn
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de>
 <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de>
 <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de>
 <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
 <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com>
 <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
 <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de>
 <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
 <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de>
From: Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
Date: Wed, 8 May 2024 10:34:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCH0lLVhpOHk9OHUlKH0hJQlUZERMWGhIXJBQOD1
	lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a8f560d1789023ckunm78483860192
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRQ6Qyo4Gjc*M1EsKB0NIxYM
	Dy0KCglVSlVKTEpOSkhOTU5LSkpNVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
	V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTUlPQzcG



在 2024/5/4 星期六 上午 11:08, Coly Li 写道:
> 
> 
>> 2024年5月4日 10:04，Robert Pang <robertpang@google.com> 写道：
>>
>> Hi Coly,
>>
>>> Can I know In which kernel version did you test the patch?
>>
>> I tested in both Linux kernels 5.10 and 6.1.
>>
>>> I didn’t observe obvious performance advantage of this patch.
>>
>> This patch doesn't improve bcache performance. Instead, it eliminates the IO stall in bcache that happens due to bch_allocator_thread() getting blocked and waiting on GC to finish when GC happens.
>>
>> /*
>> * We've run out of free buckets, we need to find some buckets
>> * we can invalidate. First, invalidate them in memory and add
>> * them to the free_inc list:
>> */
>> retry_invalidate:
>> allocator_wait(ca, ca->set->gc_mark_valid &&  <--------
>>         !ca->invalidate_needs_gc);
>> invalidate_buckets(ca);
>>
>>  From what you showed, it looks like your rebase is good. As you already noticed, the original patch was based on 4.x kernel so the bucket traversal in btree.c needs to be adapted for 5.x and 6.x kernels. I attached the patch rebased to 6.9 HEAD for your reference.
>>
>> But to observe the IO stall before the patch, please test with a read-write workload so GC will happen periodically enough (read-only or read-mostly workload doesn't show the problem). For me, I used the "fio" utility to generate a random read-write workload as follows.
>>
>> # Pre-generate a 900GB test file
>> $ truncate -s 900G test
>>
>> # Run random read-write workload for 1 hour
>> $ fio --time_based --runtime=3600s --ramp_time=2s --ioengine=libaio --name=latency_test --filename=test --bs=8k --iodepth=1 --size=900G  --readwrite=randrw --verify=0 --filename=fio --write_lat_log=lat --log_avg_msec=1000 --log_max_value=1
>>
>> We include the flags "--write_lat_log=lat --log_avg_msec=1000 --log_max_value=1" so fio will dump the second-by-second max latency into a log file at the end of test so we can when stall happens and for how long:
>>
> 
> Copied. Thanks for the information. Let me try the above command lines on my local machine with longer time.
> 
> 
> 
>> E.g.
>>
>> $ more lat_lat.1.log
>> (format: <time-ms>,<max-latency-ns>,,,)
>> ...
>> 777000, 5155548, 0, 0, 0
>> 778000, 105551, 1, 0, 0
>> 802615, 24276019570, 0, 0, 0 <---- stalls for 24s with no IO possible
>> 802615, 82134, 1, 0, 0
>> 804000, 9944554, 0, 0, 0
>> 805000, 7424638, 1, 0, 0
>>
>> I used a 375 GB local SSD (cache device) and a 1 TB network-attached storage (backing device). In the 1-hr run, GC starts happening about 10 minutes into the run and then happens at ~ 5 minute intervals. The stall duration ranges from a few seconds at the beginning to close to 40 seconds towards the end. Only about 1/2 to 2/3 of the cache is used by the end.
>>
>> Note that this patch doesn't shorten the GC either. Instead, it just avoids GC from blocking the allocator thread by first sweeping the buckets and marking reclaimable ones quickly at the beginning of GC so the allocator can proceed while GC continues its actual job.
>>
>> We are eagerly looking forward to this patch to be merged in this coming merge window that is expected to open in a week to two.
> 
> In order to avoid the no-space deadlock, normally there are around 10% space will not be allocated out. I need to look more close onto this patch.
> 
> 
> Dongsheng Yang,
> 
> Could you please post a new version based on current mainline kernel code ?

Hi Coly,
	Mingzhe will send a new version based on mainline.

Thanx
> 
> Thanks.
> 
> Coly Li
> 
> 
> 

