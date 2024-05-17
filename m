Return-Path: <linux-bcache+bounces-466-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D80E58C8DDC
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2024 23:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FB8A1C21D36
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2024 21:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8E81DFD2;
	Fri, 17 May 2024 21:48:00 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD561A2C20
	for <linux-bcache@vger.kernel.org>; Fri, 17 May 2024 21:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715982480; cv=none; b=LTiMTKFRVs7QRH1mDs4/ubYGG7ZyXPNd1hx+cSbUzyBt2m/DGZZn3IzKCpwA3Mh1TYl7gtxMQfTnGKA3UFNw7oMouiIeUNgH8qRlf6B/P/W8/IazO3uJ/hnChVmu+jNRRaGJFxFLSWu2LHvlwAfInh7zWrFTJFfWWNXt07Rp6t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715982480; c=relaxed/simple;
	bh=JoacYGIFh7MEmqt/PnA6uTCX/gngoDnt2+11Qx6asMc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ee25b6M6LzY5JjJM6XzY/ivulD2l1aywQtMTP1VryFW9r81c4tz1KSDMGywt2Tx2v9uS7AqeM7ZyWoy0RR5m1VrJYdWQ6ZdSWKL+UfYBDH3jU3lxFpHMcbr1oUhNlpcR+enc9JDZiwvbwotToT88Slw0s4OKhN2UVh5qhmTnXjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 0DCE185;
	Fri, 17 May 2024 14:47:57 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id leaR63pGVle0; Fri, 17 May 2024 14:47:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 8780B48;
	Fri, 17 May 2024 14:47:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 8780B48
Date: Fri, 17 May 2024 14:47:52 -0700 (PDT)
From: Eric Wheeler <bcache@lists.ewheeler.net>
To: Coly Li <colyli@suse.de>
cc: Robert Pang <robertpang@google.com>, 
    Dongsheng Yang <dongsheng.yang@easystack.cn>, 
    =?GB2312?B?197D99Xc?= <mingzhe.zou@easystack.cn>, 
    Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
In-Reply-To: <3E11DC5E-92D1-43FF-8948-B99F665E445D@suse.de>
Message-ID: <5925155-cc27-3b46-9143-37e3cc44d6b@ewheeler.net>
References: <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de> <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com> <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de> <C659682B-4EAB-4022-A669-1574962ECE82@suse.de> <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de> <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn> <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com> <1B20E890-F136-496B-AF1F-C09DB0B45BE8@suse.de> <CAJhEC06FQPw3p7PHJpjN13CVjibbBVv-ZhwBb_6ducJP+XJ3gg@mail.gmail.com>
 <xbm4drbn7hdxedptocnc77m53kce3jdaedsvxh7dcwts7yivjx@jbvhh43wd3tp> <9c197420-2c46-222a-6176-8a3ecae1d01d@ewheeler.net> <3E11DC5E-92D1-43FF-8948-B99F665E445D@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1147745001-1715982472=:9489"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1147745001-1715982472=:9489
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 18 May 2024, Coly Li wrote:

> 
> 
> > 2024年5月17日 08:30，Eric Wheeler <bcache@lists.ewheeler.net> 写道：
> > 
> > On Wed, 15 May 2024, Coly Li wrote:
> >> On Mon, May 13, 2024 at 10:15:00PM -0700, Robert Pang wrote:
> >>> Dear Coly,
> >>> 
> >> 
> >> Hi Robert,
> >> 
> >> Thanks for the email. Let me explain inline.
> >> 
> >>> Thank you for your dedication in reviewing this patch. I understand my
> >>> previous message may have come across as urgent, but I want to
> >>> emphasize the significance of this bcache operational issue as it has
> >>> been reported by multiple users.
> >>> 
> >> 
> >> What I concerned was still the testing itself. First of all, from the
> >> following information, I see quite a lot of testings are done. I do
> >> appreciate for the effort, which makes me confident for the quality of
> >> this patch.
> >> 
> >>> We understand the importance of thoroughness, To that end, we have
> >>> conducted extensive, repeated testing on this patch across a range of
> >>> cache sizes (375G/750G/1.5T/3T/6T/9TB) and CPU cores
> >>> (2/4/8/16/32/48/64/80/96/128) for an hour-long run. We tested various
> >>> workloads (read-only, read-write, and write-only) with 8kB I/O size.
> >>> In addition, we did a series of 16-hour runs with 750GB cache and 16
> >>> CPU cores. Our tests, primarily in writethrough mode, haven't revealed
> >>> any issues or deadlocks.
> >>> 
> >> 
> >> An hour-long run is not enough for bcache. Normally for stability prupose
> >> at least 12-36 hours continue I/O pressure is necessary. Before Linux
> >> v5.3 bcache will run into out-of-memory after 10 ~ 12 hours heavy randome
> >> write workload on the server hardware Lenovo sponsored me.
> > 
> > FYI:
> > 
> > We have been running the v2 patch in production on 5 different servers 
> > containing a total of 8 bcache volumes since April 7th this year, applied 
> > to 6.6.25 and later kernels. Some servers run 4k sector sizes, and others 
> > run 512-byte sectors for the data volume. For the cache volumes, their all 
> > cache devices use 512 byte sectors.
> > 
> > The backing storage on these servers range from 40-350 terabytes, and the 
> > cache sizes are in the 1-2 TB range.  We log kernel messages with 
> > netconsole into a centralized log server and have not had any bcache 
> > issues.
> 
> 
> Thanks for the information. The issue I stated didn’t generate kernel 
> message. It just causes all I/Os bypass the almost fully occupied cache 
> even it is all clean data. Anyway this is not directly caused by this 
> patch, this patch just makes it more easier to arrive such situation 
> before I found and fixed it.

I am glad that you were able to fix it. Did you already post the patch 
with that fix, or can you point me add a commit hash?  I am eager to try 
your fix.

--
Eric Wheeler


> 
> 
> And to all contributors (including Dongsheng, Mingzhe, Robert, Eric and others),
> 
> At this moment I see it works fine on my server. I am about to submit it to Jens next week, if no other issue pops up.
> 
> Thanks.
> 
> Coly Li
--8323328-1147745001-1715982472=:9489--

