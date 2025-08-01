Return-Path: <linux-bcache+bounces-1164-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 235DBB17B7C
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Aug 2025 05:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C45643AA1AF
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Aug 2025 03:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF30018DB01;
	Fri,  1 Aug 2025 03:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uYZycEjr"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E896DCE1;
	Fri,  1 Aug 2025 03:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754019712; cv=none; b=dpggPg9f57qIC/VRkv1qB8oOiCO3MiouZR6XBdVKEhkDENSQjnAUM4xSNlrlQPAS3H1mO4btmCs1l5FUMPorjA4mYw4Xp3IIIatRNGAsjOUPLPYfaxQPCW2qfVb0X8mkDPGY59a48P4BWOTew6hvCduzlutDQqkTZrntyn2Sci4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754019712; c=relaxed/simple;
	bh=NbuiyPlcl6yBOaHsRU90yTEmUk3EZ7e5ypMUGAvdpOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQ3QVcsTWyevm1ODUhvuT3f4DwilPakzO05UD7F+m0v0waVloG05qVw+IvNFzh8KWbNcuGLzhVQw26XsMy3z6dJztSiBF/ANksmiSvYh+zKBJq/cNmpSgDNAreqIGoeFzMSJgMLwUbK85vvgvDSiNRINPSmFweqM/d9J//t6how=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uYZycEjr; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 31 Jul 2025 23:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754019707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tDexvHAZJ1D5BY5280SKchK48oT8mrpVatJcXim8Cq8=;
	b=uYZycEjr4wFOHO2DqoNpFaEomgeG8CuIPl56vVAot31iT+fzcI4OT3VwVwcPvBb//edhpa
	xIxiHvoWHvd+BDWmjgLpFESo8hDTEMjWMLNnTpotyHncO7O6a3eGdRj68EEy+JRrHL2Gew
	JH/C28KBuwwLV7UsSHBbPShZpGstoQg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Cc: Coly Li <colyli@kernel.org>, 
	linux-bcache <linux-bcache@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Message-ID: <wxyamy7fkf7of4olnvqju2ldflnpj3k5u6qsufvesb3mtoaxwb@fuu5brsbgjwf>
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
 <etlu4r6gxbe2jc3eemj3n4slg6xraxtxxydvxvmhv77xv42uss@7aw3yxbdgrdl>
 <tencent_656F159830BC538C2D26CD68@qq.com>
 <zcxdklyr2ugq7cfbed4olcsfcboy3nksxtpjs2g76bauvef5cq@4akbspw3ydiw>
 <tencent_22DE1AC52BA931BD442CE823@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_22DE1AC52BA931BD442CE823@qq.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 01, 2025 at 11:30:43AM +0800, Zhou Jifeng wrote:
> On Fri, 1 Aug 2025 at 10:37, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Aug 01, 2025 at 10:27:21AM +0800, Zhou Jifeng wrote:
> > > In the writeback mode, the current bcache code uses the
> > > REQ_OP_WRITE operation to handle dirty data, and clears the bkey
> > > dirty flag in the btree during the bio completion callback. I think
> > > there might be a potential risk: if in the event of an unexpected
> > > power outage, the data in the HDD hardware cache may not have
> > > had time to be persisted, then the data in the HDD hardware cache
> > > that is pending processing may be lost. Since at this time the bkey
> > > dirty flag in the btree has been cleared, the data status recorded
> > > by the bkey does not match the actual situation of the SSD and
> > > HDD.
> > > Am I understanding this correctly?
> >
> > For what you're describing, we need to make sure the backing device is
> > flushed when we're flushing the journal.
> >
> > It's possible that this isn't handled correctly in bcache; bcachefs
> > does, and I wrote that code after bcache - but the bcache version would
> > look quite different.
> >
> > You've read that code more recently than I have - have you checked for
> > that?
> 
> In the `write_dirty_finish` function, there is an attempt to update the
> `bkey` status, but I did not observe any logging writing process. In the
> core function `journal_write_unlocked` of bcache for writing logs, I
> also couldn't find the code logic for sending a FLUSH command to the
> backend HDD.

The right place for it would be in the journal code: before doing a
journal write, issue flushes to the backing devices.

Can you check for that?

