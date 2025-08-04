Return-Path: <linux-bcache+bounces-1170-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A15A7B1A604
	for <lists+linux-bcache@lfdr.de>; Mon,  4 Aug 2025 17:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCC3F17FC84
	for <lists+linux-bcache@lfdr.de>; Mon,  4 Aug 2025 15:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D03205E2F;
	Mon,  4 Aug 2025 15:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cqbrqj56"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6042E36E7;
	Mon,  4 Aug 2025 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754321498; cv=none; b=RjYfsfwtKtmCoScPB08hpLcz2ef7GuQloh51l3QxP4m1VoXtplM9OzTX9R4703xdBj9dlfM7G2/e+BbLjdY+lrJT8eqRCRyfo688r0FjiqrpvcGnGyIfinLq4jmYY5zSGkKtnNvXib3DcIMa6jAMzTt02CJpRmLLsOOpGmCXUs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754321498; c=relaxed/simple;
	bh=BEG/Ye1JQt5JRZ7HueqxAHrGd3QNs1d8bzKhyitng5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=di7QXbSKU+MFcyDPmgP3M36YdinECq+izsJBM5LqH7JwNS56LBcbfRASZB01VVgdmyF5Qn+iy2reBJ3fX/KJjr2VT3F0cn+b2Mxa7+Xw9iZriml4yCoByg66NDZQ6wblldM2OU8XZjzbr/kJr9PPYKFksQd2D8S7nRsYnkeqF+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cqbrqj56; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CBAC4CEE7;
	Mon,  4 Aug 2025 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754321495;
	bh=BEG/Ye1JQt5JRZ7HueqxAHrGd3QNs1d8bzKhyitng5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cqbrqj56mQx6uQ90El8twgFggL/Ej/JJwRdZocf5UACMCxVZjz8hvT3I7jqZbq8v1
	 y1X3juwYLjjVrFoce4b3BbVeVl+tEFWmmlJbMfA+PDV/6k8h3hRMn0bJxAsvENwE+h
	 NgOYifE3mwFdN6f4odbcSnHGMz1x8dCiwvm0Mab+0LkynMFU9LAvt3lyp1rBc6U7XV
	 xnL+HMqXF4InCV3FgrumpWSO7cZFLaw3FFb8SUPlpdqhwhP2rHyLgwSiIh3E7KNFgf
	 q4GV4SsF6vFvJLzWuZIh6wTRyt4FbruWt+H0Kx7uyCdxFZsSDq6+cfUuAeWmelFwlp
	 Lq1tZpeQpFt7Q==
Date: Mon, 4 Aug 2025 23:31:30 +0800
From: Coly Li <colyli@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Zhou Jifeng <zhoujifeng@kylinos.com.cn>,
	linux-bcache <linux-bcache@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Message-ID: <20250804153130.igwkb6baf3vtjhzu@P16.>
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
 <etlu4r6gxbe2jc3eemj3n4slg6xraxtxxydvxvmhv77xv42uss@7aw3yxbdgrdl>
 <tencent_656F159830BC538C2D26CD68@qq.com>
 <zcxdklyr2ugq7cfbed4olcsfcboy3nksxtpjs2g76bauvef5cq@4akbspw3ydiw>
 <tencent_22DE1AC52BA931BD442CE823@qq.com>
 <wxyamy7fkf7of4olnvqju2ldflnpj3k5u6qsufvesb3mtoaxwb@fuu5brsbgjwf>
 <tencent_6FE47FFD5A5D8EF818ACD926@qq.com>
 <p4uhjrka2rdj67ph5puvaixxhstcyfitzq63pwrafdwtabtjwn@fbie2x77lqee>
 <tencent_31215CC45AD29EC835D34AD8@qq.com>
 <c2awlgl4ih23npqa3k2ilbrbhciv3nfd7wg5xnsjjxikcmednb@nwn3qc7aqhou>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c2awlgl4ih23npqa3k2ilbrbhciv3nfd7wg5xnsjjxikcmednb@nwn3qc7aqhou>

On Mon, Aug 04, 2025 at 12:17:28AM -0400, Kent Overstreet wrote:
> On Mon, Aug 04, 2025 at 11:47:57AM +0800, Zhou Jifeng wrote:
> > On Sun, 3 Aug 2025 at 01:30, Coly Li <colyli@kernel.org> wrote:
> > >
> > > On Fri, Aug 01, 2025 at 02:10:12PM +0800, Zhou Jifeng wrote:
> > > > On Fri, 1 Aug 2025 at 11:42, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > > > >
> > > > > On Fri, Aug 01, 2025 at 11:30:43AM +0800, Zhou Jifeng wrote:
> > > > > > On Fri, 1 Aug 2025 at 10:37, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > > > > > >
> > > > > > > On Fri, Aug 01, 2025 at 10:27:21AM +0800, Zhou Jifeng wrote:
> > > > > > > > In the writeback mode, the current bcache code uses the
> > > > > > > > REQ_OP_WRITE operation to handle dirty data, and clears the bkey
> > > > > > > > dirty flag in the btree during the bio completion callback. I think
> > > > > > > > there might be a potential risk: if in the event of an unexpected
> > > > > > > > power outage, the data in the HDD hardware cache may not have
> > > > > > > > had time to be persisted, then the data in the HDD hardware cache
> > > > > > > > that is pending processing may be lost. Since at this time the bkey
> > > > > > > > dirty flag in the btree has been cleared, the data status recorded
> > > > > > > > by the bkey does not match the actual situation of the SSD and
> > > > > > > > HDD.
> > > > > > > > Am I understanding this correctly?
> > > > > > >
> > > > > > > For what you're describing, we need to make sure the backing device is
> > > > > > > flushed when we're flushing the journal.
> > > > > > >
> > > > > > > It's possible that this isn't handled correctly in bcache; bcachefs
> > > > > > > does, and I wrote that code after bcache - but the bcache version would
> > > > > > > look quite different.
> > > > > > >
> > > > > > > You've read that code more recently than I have - have you checked for
> > > > > > > that?
> > > > > >
> > > > > > In the `write_dirty_finish` function, there is an attempt to update the
> > > > > > `bkey` status, but I did not observe any logging writing process. In the
> > > > > > core function `journal_write_unlocked` of bcache for writing logs, I
> > > > > > also couldn't find the code logic for sending a FLUSH command to the
> > > > > > backend HDD.
> > > > >
> > > > > The right place for it would be in the journal code: before doing a
> > > > > journal write, issue flushes to the backing devices.
> > > > >
> > > > > Can you check for that?
> > > > >
> > > >
> > > > I checked and found that there was no code for sending a flush request
> > > > to the backend device before the execution log was written. Additionally,
> > > > in the callback function after the dirty data was written back, when it
> > > > updated the bkey, it did not insert this update into the log.
> > > >
> > >
> > > It doesn't have to. If the previous dirty version of the key is on cache device
> > > already, and power off happens, even the clean version of the key is gone, the
> > > dirty version and its data are all valid. If the LBA range of this key is
> > > allocated to a new key, a GC must have alrady happened, and the dirty key is
> > > invalid due to bucket generation increased. So don't worry, the clean key is
> > > unncessary to go into journal in the writeback scenario.
> > >
> > > IMHO, you may try to flush backing device in a kworker before calling
> > > set_gc_sectors() in bch_gc_thread(). The disk cache can be flushed in time
> > > before the still-dirty-on-disk keys are invalidated by increase bucket key
> > > gen. And also flushing backing device after searched_full_index becomes
> > > true in the writeback thread main loop (as you did now).
> > >
> > 
> > The "flush" command previously issued by GC was supposed to alleviate
> > the problems in some scenarios. However, I thought of a situation where
> > this "flush" command issued before GC might not be sufficient to solve
> > the issue.
> > 
> > Suppose such a scenario: after a power failure, some hardware cache data
> > in the HDD is lost, while the corresponding bkey(with the dirty flag cleared)
> > update in the SSD has been persisted. After the power is restored, if
> > bcache sends a flush before GC, will this cause data loss?
> 
> Yes.

The cleared key is updated in-place within the in-memory btree node,
flushing backing devices before committing journal doesn't help.

I try to avoid adding the cleared key into journal, in high write pressure,
such synchronized link between writeback, gc and journal makes me really
uncomfortable.

Another choice might be adding a tag in struct btree, and set the tag when
the cleared key in-place updated in the btree node. When writing a bset and
the tag is set, then flush corresponding backing devcie before writing the
btree node. Maybe hurts less performance than flushing backing device before
committing journal set.

How do you think of it, Kent?

Thanks.

Coly Li


