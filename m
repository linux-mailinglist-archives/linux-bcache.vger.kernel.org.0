Return-Path: <linux-bcache+bounces-503-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB798D2962
	for <lists+linux-bcache@lfdr.de>; Wed, 29 May 2024 02:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18E941C231DE
	for <lists+linux-bcache@lfdr.de>; Wed, 29 May 2024 00:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118E9819;
	Wed, 29 May 2024 00:16:51 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21079FD
	for <linux-bcache@vger.kernel.org>; Wed, 29 May 2024 00:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716941811; cv=none; b=OZUUNBQeTbx3zNhD6l4ym5bmX8Y91h8xYDOIaBbcs1dYL8uvLLh67q4dpnyQJuTe/YXGV4Vw2QN+SxWdsX1//YJLDBTIJpETbbVABNcdlw7pBd5H1ppr1VtaNuKzZYmzPo/wVUfA6w10QrQRovH9XYxNz9XPStD8sbb0E4fKpq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716941811; c=relaxed/simple;
	bh=86y5DSsQVuwgHjNoEuAeoHQ2U9yl2i3gqTZ7oSXF6ag=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IbRsT4pIqf0mhn64kTNbBMFa0iH/w449fhFTyzaSRnmF9pzUmb+P3KZ/HntJHbUNl0/dzfKMMivTk2i/UEU5s41NZB8jXDi3mS9hBU7git68UuaqDf40CFDcYAo2g3Abg8o5K2HLEGT1UQ08rYmrOtx5ZETDQ7tnPFaoPsTBslI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id C04DA86;
	Tue, 28 May 2024 17:16:48 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ZXSlqnikj2ni; Tue, 28 May 2024 17:16:44 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 49A9040;
	Tue, 28 May 2024 17:16:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 49A9040
Date: Tue, 28 May 2024 17:16:44 -0700 (PDT)
From: Eric Wheeler <bcache@lists.ewheeler.net>
To: Coly Li <colyli@suse.de>
cc: Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH 2/3] bcache: call force_wake_up_gc() if necessary in
 check_should_bypass()
In-Reply-To: <F380E42C-9F6A-4659-A3DF-EAB97E69073F@suse.de>
Message-ID: <915ded95-d5c1-7354-e3bd-2f71eabe36f9@ewheeler.net>
References: <20240527174733.16351-1-colyli@suse.de> <1f87c967-d593-b11c-55e8-a2b7a0a75c2@ewheeler.net> <F380E42C-9F6A-4659-A3DF-EAB97E69073F@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-2060132305-1716941804=:9489"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2060132305-1716941804=:9489
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 28 May 2024, Coly Li wrote:
> > 2024年5月28日 06:31，Eric Wheeler <bcache@lists.ewheeler.net> 写道：
> > 
> > On Tue, 28 May 2024, Coly Li wrote:
> > 
> >> If there are extreme heavy write I/O continuously hit on relative small
> >> cache device (512GB in my testing), it is possible to make counter
> >> c->gc_stats.in_use continue to increase and exceed CUTOFF_CACHE_ADD.
> >> 
> >> If 'c->gc_stats.in_use > CUTOFF_CACHE_ADD' happens, all following write
> >> requests will bypass the cache device because check_should_bypass()
> >> returns 'true'. Because all writes bypass the cache device, counter
> >> c->sectors_to_gc has no chance to be negative value, and garbage
> >> collection thread won't be waken up even the whole cache becomes clean
> >> after writeback accomplished. The aftermath is that all write I/Os go
> >> directly into backing device even the cache device is clean.
> >> 
> >> To avoid the above situation, this patch uses a quite conservative way
> >> to fix: if 'c->gc_stats.in_use > CUTOFF_CACHE_ADD' happens, only wakes
> >> up garbage collection thread when the whole cache device is clean.
> > 
> > Nice fix.
> > 
> > If I understand correctly, even with this fix, bcache can reach a point 
> > where it must wait until garbage collection frees a bucket (via 
> > force_wake_up_gc) before buckets can be used again.  Waiting to call 
> > force_wake_up_gc until `c->gc_stats.in_use` exceeds CUTOFF_CACHE_ADD may 
> > not respond as fast as it could, and IO latency is important.
> > 
> 
> CUTOFF_CACHE_ADD is not for this purpose.
> GC is triggered by c->sectors_to_gc, it works as
> - initialized as 1/16 size of cache device.
> - every allocation decreases cached size from it.
> - once c->sectors_go_gc is negative value, wakeup gc thread and reset the value to 1/16 size of cache device.
> 
> CUTOFF_CACHE_ADD is to avoid something like no-space deadlock in cache 
> space. If cache space is allocated more than CUTOFF_CACHE_ADD (95%), 
> cache space will not be allocated out anymore and all read/write will 
> bypass and go directly into backing device. In my testing, after 10+ 
> hours I can see c->gc_stats.in_use is 96%. Which is a bit more than 95%, 
> but c->sectors_go_gc is still larger than 0. This is how the 
> forever-bypass happens. It has nothing to do with the latency of neither 
> I/O nor gc.

Understood, thank you for the explanation!

You said that this bug exists an older version even though it is difficult 
trigger. Perhaps it is a good idea to CC stable:

	Cc: stable@vger.kernel.org

Also, 
	Reviewed-by: "Eric Wheeler" <bcache@linux.ewheeler.net>

--
Eric Wheeler

> 
> 
> > It may be a good idea to do `c->gc_stats.in_use > CUTOFF_CACHE_ADD/2` to
> > start garbage collection when it is half-way "full".
> > 
> 
> No, it is not designed to work in this way. By the above change, all I/O will bypass the cache device and go directly into backing device when cache device is occupied only 50% space.
> 
> 
> 
> > Reaching 50% is still quite conservative, but if you want to wait longer, 
> > then even 80% or 90% would be fine; however, I think 100% is too far.  We 
> > want to avoid the case where bcache is completely "out" of buckets and we 
> > have to wait for garbage collection latency before a cache bucket can 
> > fill, since buckets should be available.
> > 
> > For example on our system we have 736824 buckets available:
> > # cat /sys/devices/virtual/block/dm-9/bcache/nbuckets
> > 736824
> > 
> > There should be no reason to wait until all buckets are exhausted. Forcing 
> > garbage collection at 50% (368412 buckets "in use") would be good house 
> > keeping.
> > 
> > You know this code very well so if I have misinterpreted something here, 
> > then please fill me in on the details.
> 
> As I said, this patch is just to avoid a forever-bypass condition, and this is an extreme condition which is rare to happen for normal workload.
> 
> Thanks.
> 
> Coly Li
--8323328-2060132305-1716941804=:9489--

