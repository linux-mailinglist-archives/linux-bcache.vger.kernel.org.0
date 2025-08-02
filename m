Return-Path: <linux-bcache+bounces-1167-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB90B18FAB
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Aug 2025 20:49:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8643C3B6594
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Aug 2025 18:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90701BCA07;
	Sat,  2 Aug 2025 18:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wH0yv1Y8"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17492EB10
	for <linux-bcache@vger.kernel.org>; Sat,  2 Aug 2025 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160559; cv=none; b=LTaMe9a1yUAIOuHzs5o8lifgdzeDtCTZkguw2TKknNzNxtsvnXzJViMTasmUaoYF1Ar7Npa8dl88sa+byE7tjkQ5VP3J30UDJWwZx9wEXc38h9mzC0irGZFeafKiTwEWgPSQwd2X6vUkWDUFh5EO6ki61GCfUBOKG5RdPddvcQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160559; c=relaxed/simple;
	bh=70R+Ka6GrFK794f4b+fNmSpA1dewhiiKHIRrnBGaVhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k39uxrYIpbBqjoEx/K6XykgweCsOIat1Lis1at84XaXb4ZGtPh7o3FY/reSXJpnJFf1A98XJpAILOFL+PPSvUrrUWjRGeEIIPmW69Eg4YnnXzWmntsu/DR8M4jIdiTNlqZJS/zJ9lzghbY/yRt94/jgnAMurp1PwiPz93kz5qPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wH0yv1Y8; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 2 Aug 2025 14:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754160549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tyPdelSk5Qx6vby/aVW1/XXVLxtYnkZXvvvyOwbik/0=;
	b=wH0yv1Y81G2c+/M2PsisKwKlds+O1pnm0GVth4v6AgQh/jdnFgVz/6udAIUt32fWi1MmW5
	odrhCi4RwDa6ktFxrZ2ZDqiss2oXVao49fHTaVeKKYd+UaWtRZ9x4Ztz78lJPzSdutmpu/
	/SRJkZRJDqh+5cce7FPcgCSx8tnUpH8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Coly Li <colyli@kernel.org>
Cc: Zhou Jifeng <zhoujifeng@kylinos.com.cn>, 
	linux-bcache <linux-bcache@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Message-ID: <dkrr6obybksiq6p2purht5tvhktau2l2syemnvmtrpxlwfxmir@vca5yahzvniu>
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
 <etlu4r6gxbe2jc3eemj3n4slg6xraxtxxydvxvmhv77xv42uss@7aw3yxbdgrdl>
 <tencent_656F159830BC538C2D26CD68@qq.com>
 <zcxdklyr2ugq7cfbed4olcsfcboy3nksxtpjs2g76bauvef5cq@4akbspw3ydiw>
 <tencent_22DE1AC52BA931BD442CE823@qq.com>
 <wxyamy7fkf7of4olnvqju2ldflnpj3k5u6qsufvesb3mtoaxwb@fuu5brsbgjwf>
 <tencent_6FE47FFD5A5D8EF818ACD926@qq.com>
 <p4uhjrka2rdj67ph5puvaixxhstcyfitzq63pwrafdwtabtjwn@fbie2x77lqee>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p4uhjrka2rdj67ph5puvaixxhstcyfitzq63pwrafdwtabtjwn@fbie2x77lqee>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 03, 2025 at 01:29:55AM +0800, Coly Li wrote:
> On Fri, Aug 01, 2025 at 02:10:12PM +0800, Zhou Jifeng wrote:
> > On Fri, 1 Aug 2025 at 11:42, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > >
> > > On Fri, Aug 01, 2025 at 11:30:43AM +0800, Zhou Jifeng wrote:
> > > > On Fri, 1 Aug 2025 at 10:37, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > > > >
> > > > > On Fri, Aug 01, 2025 at 10:27:21AM +0800, Zhou Jifeng wrote:
> > > > > > In the writeback mode, the current bcache code uses the
> > > > > > REQ_OP_WRITE operation to handle dirty data, and clears the bkey
> > > > > > dirty flag in the btree during the bio completion callback. I think
> > > > > > there might be a potential risk: if in the event of an unexpected
> > > > > > power outage, the data in the HDD hardware cache may not have
> > > > > > had time to be persisted, then the data in the HDD hardware cache
> > > > > > that is pending processing may be lost. Since at this time the bkey
> > > > > > dirty flag in the btree has been cleared, the data status recorded
> > > > > > by the bkey does not match the actual situation of the SSD and
> > > > > > HDD.
> > > > > > Am I understanding this correctly?
> > > > >
> > > > > For what you're describing, we need to make sure the backing device is
> > > > > flushed when we're flushing the journal.
> > > > >
> > > > > It's possible that this isn't handled correctly in bcache; bcachefs
> > > > > does, and I wrote that code after bcache - but the bcache version would
> > > > > look quite different.
> > > > >
> > > > > You've read that code more recently than I have - have you checked for
> > > > > that?
> > > >
> > > > In the `write_dirty_finish` function, there is an attempt to update the
> > > > `bkey` status, but I did not observe any logging writing process. In the
> > > > core function `journal_write_unlocked` of bcache for writing logs, I
> > > > also couldn't find the code logic for sending a FLUSH command to the
> > > > backend HDD.
> > >
> > > The right place for it would be in the journal code: before doing a
> > > journal write, issue flushes to the backing devices.
> > >
> > > Can you check for that?
> > >
> > 
> > I checked and found that there was no code for sending a flush request
> > to the backend device before the execution log was written. Additionally,
> > in the callback function after the dirty data was written back, when it
> > updated the bkey, it did not insert this update into the log.
> >
> 
> It doesn't have to. If the previous dirty version of the key is on cache device
> already, and power off happens, even the clean version of the key is gone, the
> dirty version and its data are all valid. If the LBA range of this key is
> allocated to a new key, a GC must have alrady happened, and the dirty key is
> invalid due to bucket generation increased. So don't worry, the clean key is
> unncessary to go into journal in the writeback scenario.
>  
> IMHO, you may try to flush backing device in a kworker before calling
> set_gc_sectors() in bch_gc_thread(). The disk cache can be flushed in time
> before the still-dirty-on-disk keys are invalidated by increase bucket key
> gen. And also flushing backing device after searched_full_index becomes
> true in the writeback thread main loop (as you did now).
> 
> Flushing backing device after read_dirty() returns is too heavy, event with
> the flush hint keys. And the flushing operations are unnecessary before the
> keys are reclaimed by garbage collaction.

No, a flush is necessary.

And it's not after read_dirty, the flush just needs to happen before
bcache does its journal commit.

