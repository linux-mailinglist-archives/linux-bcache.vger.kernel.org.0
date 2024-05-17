Return-Path: <linux-bcache+bounces-462-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F948C7F36
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2024 02:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2659280CAB
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2024 00:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4689A622;
	Fri, 17 May 2024 00:30:21 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09437FD
	for <linux-bcache@vger.kernel.org>; Fri, 17 May 2024 00:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715905821; cv=none; b=M/vniD+moMAHBoTEIRUPK61zpE9/LAvUrNkITAZHgU3SDrpoMR5F7RT7FOmbpg4qWHPbdFaDo+tDEIzZnwg6But5NIRN1RCfOSl4A5evAdJIl7VEo1i1Qum0w3WcybzVsG/s9isuUwNeccxgLrQIj97pU9NO0S/hqARFg+9qgfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715905821; c=relaxed/simple;
	bh=iGwXjOkixolmMraYWttL8WtjQCHsdiOUHhAf/OLy0qM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kbRTsrlErUD2eOXPtRtqgfozMaVIVLgUz2ZYzwXbI/ZLpkT8UMP40m5bvBuHurmpWxSCnMEDSSj6jSG8JWNOHAzLf9EUDkLYPlenf9SawA0NDQFAaR/+OKm6IVK8hojOwjADl6t54ibb/J69euWHd+Y7RN1AfjqiUP31aJo4PmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id E4A3347;
	Thu, 16 May 2024 17:30:18 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id brjSbDugR980; Thu, 16 May 2024 17:30:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id A4FF040;
	Thu, 16 May 2024 17:30:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net A4FF040
Date: Thu, 16 May 2024 17:30:17 -0700 (PDT)
From: Eric Wheeler <bcache@lists.ewheeler.net>
To: Coly Li <colyli@suse.de>
cc: Robert Pang <robertpang@google.com>, 
    Dongsheng Yang <dongsheng.yang@easystack.cn>, 
    =?GB2312?B?197D99Xc?= <mingzhe.zou@easystack.cn>, 
    Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
In-Reply-To: <xbm4drbn7hdxedptocnc77m53kce3jdaedsvxh7dcwts7yivjx@jbvhh43wd3tp>
Message-ID: <9c197420-2c46-222a-6176-8a3ecae1d01d@ewheeler.net>
References: <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de> <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com> <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de> <C659682B-4EAB-4022-A669-1574962ECE82@suse.de> <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de> <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn> <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com> <1B20E890-F136-496B-AF1F-C09DB0B45BE8@suse.de> <CAJhEC06FQPw3p7PHJpjN13CVjibbBVv-ZhwBb_6ducJP+XJ3gg@mail.gmail.com>
 <xbm4drbn7hdxedptocnc77m53kce3jdaedsvxh7dcwts7yivjx@jbvhh43wd3tp>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 15 May 2024, Coly Li wrote:
> On Mon, May 13, 2024 at 10:15:00PM -0700, Robert Pang wrote:
> > Dear Coly,
> >
> 
> Hi Robert,
> 
> Thanks for the email. Let me explain inline.
>  
> > Thank you for your dedication in reviewing this patch. I understand my
> > previous message may have come across as urgent, but I want to
> > emphasize the significance of this bcache operational issue as it has
> > been reported by multiple users.
> > 
> 
> What I concerned was still the testing itself. First of all, from the
> following information, I see quite a lot of testings are done. I do
> appreciate for the effort, which makes me confident for the quality of
> this patch.
> 
> > We understand the importance of thoroughness, To that end, we have
> > conducted extensive, repeated testing on this patch across a range of
> > cache sizes (375G/750G/1.5T/3T/6T/9TB) and CPU cores
> > (2/4/8/16/32/48/64/80/96/128) for an hour-long run. We tested various
> > workloads (read-only, read-write, and write-only) with 8kB I/O size.
> > In addition, we did a series of 16-hour runs with 750GB cache and 16
> > CPU cores. Our tests, primarily in writethrough mode, haven't revealed
> > any issues or deadlocks.
> >
> 
> An hour-long run is not enough for bcache. Normally for stability prupose
> at least 12-36 hours continue I/O pressure is necessary. Before Linux
> v5.3 bcache will run into out-of-memory after 10 ~ 12 hours heavy randome
> write workload on the server hardware Lenovo sponsored me.

FYI:

We have been running the v2 patch in production on 5 different servers 
containing a total of 8 bcache volumes since April 7th this year, applied 
to 6.6.25 and later kernels. Some servers run 4k sector sizes, and others 
run 512-byte sectors for the data volume. For the cache volumes, their all 
cache devices use 512 byte sectors.

The backing storage on these servers range from 40-350 terabytes, and the 
cache sizes are in the 1-2 TB range.  We log kernel messages with 
netconsole into a centralized log server and have not had any bcache 
issues.


--
Eric Wheeler


> 
> This patch tends to offer high priority to allocator than gc thread, I'd
> like to see what will happen if most of the cache space are allocated.
> 
> In my testing, still on the Lenovo SR650. The cache device is 512G Intel
> optane memory by pmem driver, the backing device is a 4TB nvme SSD,
> there are 2-way Intel Xeon processors with 48 cores and 160G DRAM on the
> system. An XFS with default configuration created on the writeback mode
> bcache device, and following fio job file is used,
> [global]
> direct=1
> thread=1
> lockmem=1
> ioengine=libaio
> random_generator=tausworthe64
> group_reporting=1
> 
> [job0]
> directory=/mnt/xfs/
> readwrite=randwrite
> numjobs=20
> blocksize=4K/50:8K/30:16K/10:32K/10
> iodepth=128
> nrfiles=50
> size=80G
> time_based=1
> runtime=36h
> 
> After around 10~12 hours, the cache space is almost exhuasted, and all
> I/Os go bypass the cache and directly into the backing device. On this
> moment, cache in used is around 96% (85% is dirty data, rested might be
> journal and btree nodes). This is as expected.
> 
> Then stop the fio task, wait for writeback thread flush all dirty data
> into the backing device. Now the cache space is occupied by clean data
> and betree nodes. Now restart the fio writing task, an unexpected
> behavior can be observed: all I/Os still go bypass the cache device and
> into the backing device directly, even the cache only contains clean
> data.
> 
> The above behavior turns out to be a bug from existed bcache code. When
> cache space is used more than 95%, all write I/Os will go bypass the
> cache. So there won't be chance to decrease the sectors counter to be
> negative value to trigger garbage collection. The result is clean data
> occupies all cache space but cannot be collected and re-allocate again.
> 
> Before this patch, the above issue was a bit harder to produce. Since
> this patch trends to offer more priority to allocator threads than gc
> threads, with very high write workload for quite long time, it is more
> easier to observe the above no-space issue.
> 
> Now I fixed it and the first 8 hours run looks fine. I just continue
> another 12 hours run on the same hardware configuration at this moment.
>  
> > We hope this additional testing data proves helpful. Please let us
> > know if there are any other specific tests or configurations you would
> > like us to consider.
> 
> The above testing information is very helpful. And bcache now is widely
> deployed on business critical workload, I/O pressure testing with long
> time is necessary, otherwise such regression will escape from our eyes.
> 
> Thanks. 
> 
> [snipped]
> 
> -- 
> Coly Li
> 
> 

