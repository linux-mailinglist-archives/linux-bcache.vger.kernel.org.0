Return-Path: <linux-bcache+bounces-1178-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C6D4B1B883
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Aug 2025 18:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3552017DE77
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Aug 2025 16:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74A76291C0F;
	Tue,  5 Aug 2025 16:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6Saer3C"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8C372630;
	Tue,  5 Aug 2025 16:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754411361; cv=none; b=duJPtqZnuR7joiimwtRwl1lJOUx6OReyLEELOj0uBObbwgqIeq4otDzG2pos7PQZy0hQaBrUQDq2n3sR+l55mM62AkPxbAIc3Kux+L9NmPU701FPsQd2rzXqe++4NG9sowE9/EnKm9iCTobczOOdEqI0hW7UPicQme/JR8UfUbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754411361; c=relaxed/simple;
	bh=z2f5E5qduYyTuQDNdWrkJD60BxEll0QTORUTvnlrshY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUmbCCsKTh6PQcLZsmAkChjJk3+W5RKpqBrQCMJ9zixl+BnjSwGWk2RtDThE+0OuPHtXyg562Crf7vj8qXnyhFKZtOXSm1GL5zjlRzyYzVYIYJ8gsCtZhW6CJDykbr5GKgCPSidRX44ZOWmkZjlEY6fi5W/fYeDVZde8DXmCDTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6Saer3C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A8EC4CEF0;
	Tue,  5 Aug 2025 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754411360;
	bh=z2f5E5qduYyTuQDNdWrkJD60BxEll0QTORUTvnlrshY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f6Saer3CTW7RcCIGPsuQSY5QFQeHJlgaUXlXrIhCRuFM+ycTnj66AnazqTez7pFow
	 vEBcEJjRXx/9FxRVq7JH/nDCIfhVcf3+pnHh6KiWQRfckzEoAfdvnTCNT1zuji/0nn
	 tCBgcvxbZwu++FuDjwpUwGv7Y1XtQUaSktRCFbFe7RR8yDMt7ly37boUX2/9KRlUBc
	 GY535s59QFu7id9ILARy1ROg1HQ9wBJUoyAwCqOqNRWVLvVkoF6CryB1DkPtpdm2p9
	 mPkj3lQHX2jUFXOuIi3MIIMXEkT69aikWHvXjxfYWejczA0KFUTw9uOjddkg+KIbU1
	 dWOgsMrmq89Hg==
Date: Wed, 6 Aug 2025 00:29:15 +0800
From: Coly Li <colyli@kernel.org>
To: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Cc: "kent.overstreet" <kent.overstreet@linux.dev>,
	linux-bcache <linux-bcache@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Message-ID: <20250805162915.3kaqbxjbwfuj6u6w@P16.>
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
 <20250805045745.iu4ukc6tfdm3j7xn@P16.>
 <tencent_29AAD4111647BCD160DCFD85@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tencent_29AAD4111647BCD160DCFD85@qq.com>

On Tue, Aug 05, 2025 at 05:37:44PM +0800, Zhou Jifeng wrote:
> On Tue, 5 Aug 2025 at 13:00, Coly Li <colyli@kernel.org> wrote:
> >
> > On Thu, Jul 31, 2025 at 02:21:40PM +0800, Zhou Jifeng wrote:
> > > There is a potential data consistency risk in bcache's writeback mode:when
> > > the application calls fsync, bcache returns success after completing the
> > > log write, persisting the cache disk data, and persisting the HDD internal
> > > cache. However, at this point, the actual application data may still be in
> > > a dirty state and remain stuck in the cache disk. when these data are
> > > subsequently written back to the HDD asynchronously through REQ_OP_WRITE,
> > > there is no forced refresh mechanism to ensure physical placement on the
> > > disk, and there may be no power-off protection measures, which poses a risk
> > > of data loss. This mechanism may cause the application to misjudge that the
> > > data has been persisted, which is different from the actual storage state,
> > > and also violates the semantic agreement that fsync should ensure data
> > > persistence.
> > >
> >
> > [snipped]
> >
> >
> >
> > If before the cleared key inserted into the btree, there are new write
> > into overlapped LBA range of the cleared key and a dirty key inserted.
> > Then the cleared key is inserted and overwrites the dirty key, but the
> > dirty data on cache is not written back to backing device yet. How to
> > handle such situation?
> >
> 
> There are indeed some issues here. I have initially come up with a
> solution: Utilize the existing dc->writeback_keys mechanism for
> protection. The general processing flow is as follows:
> 1. In the write_dirty_finish() function, remove the operation of 
> updating bkey insertion, and delete the code bch_keybuf_del(&dc
> ->writeback_keys, w).
> 2. After executing the read_dirty(dc) code, perform flush, then
> insert the updated bkey, and finally remove the bkey from dc->
> writeback_keys. This process is equivalent to sending a flush
> every KEYBUF_NR bkeys are written back.
> 3. Support configurable KEYBUF_NR to indirectly control the
> frequency of flush.
> 
> Is this plan appropriate? Or are there any better ways to handle it?

No, I won't suggest this way. It sounds complicaed and changes the main
code flow too much in an implicit way, this should be avoided.

So it seems Kent's suggestion to flush backing device before committing
jset is the proper method I can see now.

Coly Li 

