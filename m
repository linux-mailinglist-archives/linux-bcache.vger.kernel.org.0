Return-Path: <linux-bcache+bounces-885-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E756A8B000
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Apr 2025 08:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C577C1900D57
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Apr 2025 06:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE2522A4E3;
	Wed, 16 Apr 2025 06:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jkHC0Wyt"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DD918FDD2
	for <linux-bcache@vger.kernel.org>; Wed, 16 Apr 2025 06:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744783728; cv=none; b=qjBc9p0tiqzNcG3jE+WwXkoiUM1ETrofBElo+m1qFe4vAa6nHn31RlbDheis1MtDpZSo4uYVOYcO0gy8RnE4y350kbB+vZ7qUYHHrxqmiBzYnOM8FGz+gDM2EncS3pGtykWB7sOt0Hjhi4hP7OiR4U0VFKzH9SF87c+D5KZNczQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744783728; c=relaxed/simple;
	bh=S1hfwxWvddOHrR2LujD9OnylZrLvihKEOzv4l90MvuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ObjSYoiMQ6eMbgxnpiD2Q63+kv15G9DSnoXi/wEYpXz0dLuu0DbHzHxDBh+AgI+0BInIlgrYHwuD7AOhmwOVZ8sktlSAJMLTlMBsZ21BwJT14DS/gP2AKXyQinOANXi8ZaGOhg9jdTckv5qlVmkzhEMaUuaGIiVs1Oj8KG8E0rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jkHC0Wyt; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <07f93a57-6459-46e2-8ee3-e0328dd67967@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744783714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDlzw9n3dMf2bJtTmXN0wtIQIhVbVUue8+JMQPzg3aY=;
	b=jkHC0WytKU6OpaEV1nK9F6q3mzOB80piLbfVb3zy+c0gMXjhYmdstAHQZdZWz5aez3KDeT
	vfxMbnv7mvcZyUVVJIOQJluUNrWcrSy95MZVAs+ZfQzpI2h/yLuPScMA6PJqGlLqDDXBe3
	pMRgsp5raEOvMdvAvTrDK9ShTl57ODk=
Date: Wed, 16 Apr 2025 14:08:25 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 00/11] pcache: Persistent Memory Cache for Block
 Devices
To: Jens Axboe <axboe@kernel.dk>, Dan Williams <dan.j.williams@intel.com>,
 hch@lst.de, gregory.price@memverge.com, John@groves.net,
 Jonathan.Cameron@huawei.com, bbhushan2@marvell.com, chaitanyak@nvidia.com,
 rdunlap@infradead.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-bcache@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20250414014505.20477-1-dongsheng.yang@linux.dev>
 <67fe9ea2850bc_71fe294d8@dwillia2-xfh.jf.intel.com.notmuch>
 <15e2151a-d788-48eb-8588-1d9a930c64dd@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <15e2151a-d788-48eb-8588-1d9a930c64dd@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 2025/4/16 9:04, Jens Axboe wrote:
> On 4/15/25 12:00 PM, Dan Williams wrote:
>> Thanks for making the comparison chart. The immediate question this
>> raises is why not add "multi-tree per backend", "log structured
>> writeback", "readcache", and "CRC" support to dm-writecache?
>> device-mapper is everywhere, has a long track record, and enhancing it
>> immediately engages a community of folks in this space.
> Strongly agree.


Hi Dan and Jens,
Thanks for your reply, that's a good question.

     1. Why not optimize within dm-writecache?
     From my perspective, the design goal of dm-writecache is to be a 
minimal write cache. It achieves caching by dividing the cache device 
into n blocks, each managed by a wc_entry, using a very simple 
management mechanism. On top of this design, it's quite difficult to 
implement features like multi-tree structures, CRC, or log-structured 
writeback. Moreover, adding such optimizations—especially a read 
cache—would deviate from the original semantics of dm-writecache. So, we 
didn't consider optimizing dm-writecache to meet our goals.

     2. Why not optimize within bcache or dm-cache?
     As mentioned above, dm-writecache is essentially a minimal write 
cache. So, why not build on bcache or dm-cache, which are more complete 
caching systems? The truth is, it's also quite difficult. These systems 
were designed with traditional SSDs/NVMe in mind, and many of their 
design assumptions no longer hold true in the context of PMEM. Every 
design targets a specific scenario, which is why, even with dm-cache 
available, dm-writecache emerged to support DAX-capable PMEM devices.

     3. Then why not implement a full PMEM cache within the dm framework?
     In high-performance IO scenarios—especially with PMEM 
hardware—adding an extra DM layer in the IO stack is often unnecessary. 
For example, DM performs a bio clone before calling __map_bio(clone) to 
invoke the target operation, which introduces overhead.

Thank you again for the suggestion. I absolutely agree that leveraging 
existing frameworks would be helpful in terms of code review, and 
merging. I, more than anyone, hope more people can help review the code 
or join in this work. However, I believe that in the long run, building 
a standalone pcache module is a better choice.

Thanx
Dongsheng

>

