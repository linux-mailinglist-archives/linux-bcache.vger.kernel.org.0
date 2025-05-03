Return-Path: <linux-bcache+bounces-1025-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51003AA81DA
	for <lists+linux-bcache@lfdr.de>; Sat,  3 May 2025 19:33:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB5165A5564
	for <lists+linux-bcache@lfdr.de>; Sat,  3 May 2025 17:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646F71E7C12;
	Sat,  3 May 2025 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJ1eRNah"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5461BC41
	for <linux-bcache@vger.kernel.org>; Sat,  3 May 2025 17:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746293601; cv=none; b=XE5Rt/RfNm1zmq8FIz1MFyhmq/Yj7tf50wJCM/jO2P0lECrUFutcFdjkTGm53Q5tE21J5BHnFdeffb0xzM7e0UGSwPlO2BrG/nj1GrHz4Wda2XrnGkR/K2o8CVUIX22jVM4Zo4o5BhrMLKGcoyjhTkZkRJsn7IYAn4s0OAD+xI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746293601; c=relaxed/simple;
	bh=Rg46lY2DsgGzbb7+eR8IYe11kn/Ta/UsXHInGgmq7F4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLNXjaiWZUkusBj/BOw96iDqUk7w7qpecO0UjWJQZ+TFhLoZjpqMQwSaWizQ9Rd4eRm870K9dskxL+FwBSL2RQN69lkVqxslwtfinwzJf0dy9DVhaRn1L5L+r0fYahlDiUtzW34zQCfXFM47/6mCMfcwGotrEXjRkVNhBhRXp/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJ1eRNah; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A587C4CEE3;
	Sat,  3 May 2025 17:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746293600;
	bh=Rg46lY2DsgGzbb7+eR8IYe11kn/Ta/UsXHInGgmq7F4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dJ1eRNahSim/oDlTTmp/9mFZG5XQsThBmzgdHD73W2gMa0ZfZgeh5QrJ+cwnw2VIA
	 gFmY79+wrIoxsYKGkAbSVdVXZEnkJjU5C6W55K2XlgueJuQy7UMQwOOFQOLtSL5eIp
	 gv/OMws1B0RDg1Og5cCOZghDegeeNDZV+FShU5FifoQHBvW7W+So58DreWZ54nt+B+
	 3sdaxvM8Qp41Tcla9fgn+pziUFNBDzik8yyZq/+pELmQ94U2HapF1H09VTlSr7uUf4
	 FMHfuATKtH9mnCHx9AoRup0iOX7GyoK2HeCxNeQoV1bZi86VD8CnltpUvZ8HIIvD9a
	 Vx6UOYT19WcIQ==
Date: Sun, 4 May 2025 01:33:16 +0800
From: Coly Li <colyli@kernel.org>
To: Robert Pang <robertpang@google.com>
Cc: Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
Message-ID: <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
References: <20250414224415.77926-1-robertpang@google.com>
 <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
 <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>

On Thu, May 01, 2025 at 06:01:09PM +0800, Robert Pang wrote:
> Hi Coly,
> 
> Please disregard the test results I shared over a week ago. After digging
> deeper into the recent latency spikes with various workloads and by
> instrumenting the garbage collector, I realized that the earlier GC latency
> patch, "bcache: allow allocator to invalidate bucket in gc" [1], wasn't
> backported to the Linux 6.6 branch I tested my patch against. This omission
> explains the much higher latency observed during the extended test because the
> allocator was blocked for the entire GC. My sincere apologies for the
> inconsistent results and any confusion this has caused.
> 

Did you also backport commit 05356938a4be ("bcache: call force_wake_up_gc()
if necessary in check_should_bypass()") ? Last time when you pushed me to
add commit a14a68b76954 into mainline kernel, I tested a regression from this
patch and fixed it. Please add this fix if you didn't, otherwise the testing
might not be completed.


> With patch [1] back-patched and after a 24-hour re-test, the fio results clearly
> demonstrate that this patch effectively reduces front IO latency during GC due
> to the smaller incremental GC cycles, while the GC duration increase is still
> well within bounds.
>

From the performance result in [2], it seems the max latency are reduced,
but higher latency period are longer. I am not sure whether this is a happy
result.

Can I have a download link for the whole log? Then I can look at the
performance numbers more close.
 
> Here's a summary of the improved latency:
> 
> Before:
> 
> Median latency (P50): 210 ms
> Max latency (P100): 3.5 sec
> 
> btree_gc_average_duration_ms:381138
> btree_gc_average_frequency_sec:3834
> btree_gc_last_sec:60668
> btree_gc_max_duration_ms:825228
> bset_tree_stats:
> btree nodes: 144330
> written sets: 283733
> unwritten sets: 144329
> written key bytes: 24993783392
> unwritten key bytes: 11777400
> floats: 30936844345385
> failed: 5776
> 
> After:
> 
> Median latency (P50): 25 ms
> Max latency (P100): 0.8 sec
> 
> btree_gc_average_duration_ms:622274
> btree_gc_average_frequency_sec:3518
> btree_gc_last_sec:8931
> btree_gc_max_duration_ms:953146
> bset_tree_stats:
> btree nodes: 175491
> written sets: 339078
> unwritten sets: 175488
> written key bytes: 29821314856
> unwritten key bytes: 14076504
> floats: 90520963280544
> failed: 6462
> 
> The complete latency data is available at [2].
> 
> I will be glad to run further tests to solidify these findings for the inclusion
> of this patch in the coming merge window. Let me know if you'd like me to
> conduct any specific tests.

Yes, more testing are necessary, from 512 Bytes block size to 1 MiB or
8MiB block size. We need to make sure it won't introduce performance
regression in other workload or circumstances.

I don't have plan to submit this patch in this merge window, and please don't
push me. For performance improvement change, I prefer the defalt
configuration will cover most of work loads, so more testing and perforamce
data are desired. E.g. the patch you mentioned (commit a14a68b76954 "bcache:
allow allocator to invalidate bucket in gc"), it had been deployed in Easy
Stack product environment for 20+ months before it got merged.

Thanks.

> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a14a68b76954e73031ca6399abace17dcb77c17a
> [2[ https://gist.github.com/robert-pang/cc7c88f356293ea6d43103e6e5f9180f

[snipped]

-- 
Coly Li

