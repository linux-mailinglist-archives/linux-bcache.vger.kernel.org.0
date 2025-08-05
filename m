Return-Path: <linux-bcache+bounces-1173-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F86FB1AC16
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Aug 2025 03:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CF5F17F8C6
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Aug 2025 01:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFE11B7F4;
	Tue,  5 Aug 2025 01:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ztsplcth"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878CF10FD
	for <linux-bcache@vger.kernel.org>; Tue,  5 Aug 2025 01:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754357507; cv=none; b=FrWpM3TQYxpA2rgHnNwcPfo4qN8cIuv+LYA1eYgif1Hs8pjjByBTfn9W9C54bP1Rll95775YJ4HT+TU90lGP2SLaA/WBevHlkhLBNo2KsErpAt3TYZCzzmpO117D8QTegnvNGH+2kZnVAACvf9M6trIg5dUPBvK5NqtPOUdxeEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754357507; c=relaxed/simple;
	bh=I5dqHXamKVUu13/5/nldq304P5WwWu8P17/HsIsp364=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fTVqVPliJrGydMjpQJe5ZrH0iTXBiAyiQwfCBlD/XxL6EzI2U2cvD983aXotQUieVIK8tPTxnN/0qO8EEQQe/n/yaXDHWjRfXjONaHfmLUChpouO/JM0DC9BKuxAqFySeaSYQduvylInq4M41z7pFG0VgCipNzV8Cxqn7+C8msE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ztsplcth; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 4 Aug 2025 21:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754357502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yO3tMSVJU956aT+DOTGrVPksCiyFmpy9uzCL1e6htMs=;
	b=Ztsplcth0jngTbqq7hCMwy/DCWM9xydE763U464mxKhq7T5ycJtk8chsahQPo7e9JN8GpP
	XdYKxIb3d6Gu+Xp307SS/YkWDu45jKw4IoZqYd222HGRRxdbhbL+Qde7oU7ZKLGKfdlSPw
	Rz7u2HvFrlXsm6GbAUXt5eqyddVkPVE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Cc: Coly Li <colyli@kernel.org>, 
	linux-bcache <linux-bcache@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Message-ID: <mu7u23kbguzgzfovqpadr6id2pi5a3l6tca2gengjiqgndutw2@qu4aj5didb4h>
References: <zcxdklyr2ugq7cfbed4olcsfcboy3nksxtpjs2g76bauvef5cq@4akbspw3ydiw>
 <tencent_22DE1AC52BA931BD442CE823@qq.com>
 <wxyamy7fkf7of4olnvqju2ldflnpj3k5u6qsufvesb3mtoaxwb@fuu5brsbgjwf>
 <tencent_6FE47FFD5A5D8EF818ACD926@qq.com>
 <p4uhjrka2rdj67ph5puvaixxhstcyfitzq63pwrafdwtabtjwn@fbie2x77lqee>
 <tencent_31215CC45AD29EC835D34AD8@qq.com>
 <c2awlgl4ih23npqa3k2ilbrbhciv3nfd7wg5xnsjjxikcmednb@nwn3qc7aqhou>
 <20250804153130.igwkb6baf3vtjhzu@P16.>
 <gc54e3mk6ftv5qhuqvuguuguq3nbrwhty543egvictmiua5me7@nrzyczdgceyr>
 <tencent_418348EE386ED24E54E87AD7@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_418348EE386ED24E54E87AD7@qq.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 05, 2025 at 09:17:31AM +0800, Zhou Jifeng wrote:
> On Tue, 5 Aug 2025 at 00:07, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > On Mon, Aug 04, 2025 at 11:31:30PM +0800, Coly Li wrote:
> > > On Mon, Aug 04, 2025 at 12:17:28AM -0400, Kent Overstreet wrote:
> > > > On Mon, Aug 04, 2025 at 11:47:57AM +0800, Zhou Jifeng wrote:
> > > > > On Sun, 3 Aug 2025 at 01:30, Coly Li <colyli@kernel.org> wrote:
> > > > > >
> > > > > > On Fri, Aug 01, 2025 at 02:10:12PM +0800, Zhou Jifeng wrote:
> > > > > > > On Fri, 1 Aug 2025 at 11:42, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > > > > > > >
> > > > > > > > On Fri, Aug 01, 2025 at 11:30:43AM +0800, Zhou Jifeng wrote:
> > > > > > > > > On Fri, 1 Aug 2025 at 10:37, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > > > > > > > > >
> > > > > > > > > > On Fri, Aug 01, 2025 at 10:27:21AM +0800, Zhou Jifeng wrote:
> > > > > > > > > > > In the writeback mode, the current bcache code uses the
> > > > > > > > > > > REQ_OP_WRITE operation to handle dirty data, and clears the bkey
> > > > > > > > > > > dirty flag in the btree during the bio completion callback. I think
> > > > > > > > > > > there might be a potential risk: if in the event of an unexpected
> > > > > > > > > > > power outage, the data in the HDD hardware cache may not have
> > > > > > > > > > > had time to be persisted, then the data in the HDD hardware cache
> > > > > > > > > > > that is pending processing may be lost. Since at this time the bkey
> > > > > > > > > > > dirty flag in the btree has been cleared, the data status recorded
> > > > > > > > > > > by the bkey does not match the actual situation of the SSD and
> > > > > > > > > > > HDD.
> > > > > > > > > > > Am I understanding this correctly?
> > > > > > > > > >
> > > > > > > > > > For what you're describing, we need to make sure the backing device is
> > > > > > > > > > flushed when we're flushing the journal.
> > > > > > > > > >
> > > > > > > > > > It's possible that this isn't handled correctly in bcache; bcachefs
> > > > > > > > > > does, and I wrote that code after bcache - but the bcache version would
> > > > > > > > > > look quite different.
> > > > > > > > > >
> > > > > > > > > > You've read that code more recently than I have - have you checked for
> > > > > > > > > > that?
> > > > > > > > >
> > > > > > > > > In the `write_dirty_finish` function, there is an attempt to update the
> > > > > > > > > `bkey` status, but I did not observe any logging writing process. In the
> > > > > > > > > core function `journal_write_unlocked` of bcache for writing logs, I
> > > > > > > > > also couldn't find the code logic for sending a FLUSH command to the
> > > > > > > > > backend HDD.
> > > > > > > >
> > > > > > > > The right place for it would be in the journal code: before doing a
> > > > > > > > journal write, issue flushes to the backing devices.
> > > > > > > >
> > > > > > > > Can you check for that?
> > > > > > > >
> > > > > > >
> > > > > > > I checked and found that there was no code for sending a flush request
> > > > > > > to the backend device before the execution log was written. Additionally,
> > > > > > > in the callback function after the dirty data was written back, when it
> > > > > > > updated the bkey, it did not insert this update into the log.
> > > > > > >
> > > > > >
> > > > > > It doesn't have to. If the previous dirty version of the key is on cache device
> > > > > > already, and power off happens, even the clean version of the key is gone, the
> > > > > > dirty version and its data are all valid. If the LBA range of this key is
> > > > > > allocated to a new key, a GC must have alrady happened, and the dirty key is
> > > > > > invalid due to bucket generation increased. So don't worry, the clean key is
> > > > > > unncessary to go into journal in the writeback scenario.
> > > > > >
> > > > > > IMHO, you may try to flush backing device in a kworker before calling
> > > > > > set_gc_sectors() in bch_gc_thread(). The disk cache can be flushed in time
> > > > > > before the still-dirty-on-disk keys are invalidated by increase bucket key
> > > > > > gen. And also flushing backing device after searched_full_index becomes
> > > > > > true in the writeback thread main loop (as you did now).
> > > > > >
> > > > >
> > > > > The "flush" command previously issued by GC was supposed to alleviate
> > > > > the problems in some scenarios. However, I thought of a situation where
> > > > > this "flush" command issued before GC might not be sufficient to solve
> > > > > the issue.
> > > > >
> > > > > Suppose such a scenario: after a power failure, some hardware cache data
> > > > > in the HDD is lost, while the corresponding bkey(with the dirty flag cleared)
> > > > > update in the SSD has been persisted. After the power is restored, if
> > > > > bcache sends a flush before GC, will this cause data loss?
> > > >
> > > > Yes.
> > >
> > > The cleared key is updated in-place within the in-memory btree node,
> > > flushing backing devices before committing journal doesn't help.
> >
> > Yes, it would, although obviously we wouldn't want to do a flush every
> > time we clear the dirty bit - it needs batching.
> >
> > Any time you're doing writes to multiple devices that have ordering
> > dependencies, a flush needs to be involved.
> >
> > > I try to avoid adding the cleared key into journal, in high write pressure,
> > > such synchronized link between writeback, gc and journal makes me really
> > > uncomfortable.
> > >
> > > Another choice might be adding a tag in struct btree, and set the tag when
> > > the cleared key in-place updated in the btree node. When writing a bset and
> > > the tag is set, then flush corresponding backing devcie before writing the
> > > btree node. Maybe hurts less performance than flushing backing device before
> > > committing journal set.
> > >
> > > How do you think of it, Kent?
> >
> > Have a look at the code for this in bcachefs, fs/bcachefs/journal_io.c,
> > journal_write_preflush().
> >
> > If it's a multi device filesystem, we issue flushes separately from the
> > journal write and wait for them to complete before doing the REQ_FUA
> > journal write - that ensures that any cross device IO dependencies are
> > ordered correctly.
> >
> > That approach would work in bcache as well, but it'd have higher
> > performance overhead than in bcachefs because bcache doesn't have the
> > concept of noflush (non commit) journal writes - every journal write is
> > FLUSH/FUA, and there's also writes that bypass the cache, which we we'll
> > be flushing unnecessarily.
> >
> > Having a flag/bitmask for "we cleared dirty bits, these backing
> > device(s) need flushes" would probably have acceptable performance
> > overhead.
> >
> > Also, we're getting damn close to being ready to lift the experimental
> > label on bcachefs, so maybe have a look at that too :)
> >
> 
> Could we consider the solution I submitted, which is based on the
> following main principle:
> 1. Firstly, in the write_dirty_finish stage, the dirty marking bkeys are
> not inserted into the btree immediately. Instead, they are temporarily
> stored in an internal memory queue called Alist.
> 2. Then, when the number of bkeys in Alist exceeds a certain limit, a
> flush request is sent to the backend HDD.
> 3. After the flush is sent, the bkeys recorded in Alist are then
> inserted into the btree.
> This process ensures that the written dirty data is written to the disk
> before the btree is updated. The length of Alist can be configured,
> allowing for better control of the flush sending frequency and reducing
> the impact of the flush on the write speed.

That approach should work as well. You'll want to make the list size
rather bit, and add statistics for how ofter flushes are being issued.

