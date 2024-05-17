Return-Path: <linux-bcache+bounces-463-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C78F8C7F3D
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2024 02:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A126B21A73
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2024 00:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E87389;
	Fri, 17 May 2024 00:34:35 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E567E2
	for <linux-bcache@vger.kernel.org>; Fri, 17 May 2024 00:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715906075; cv=none; b=iw/XyO7qyPM1Lp67N5IuGrv8jz1gVyZhluosTU8O4guDHo4+F5hBm+qTmEw79R4P75HlLplIvgXvc9cZ6Ay2rcVkZ+DABD4yQDuY3VcSH8wuX0sm4dmq4qKIY5pk46FnX549y+MOrsn2a8YeWUITYZ0jJcfXpPMHMx8kpWXw9/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715906075; c=relaxed/simple;
	bh=X+yWZAuLWMHL6cZ7woEG6zZkbXBtxRd1P//KDejlZ+4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=e8ej1zkQB65G4BQL5smDtuOz2sRKI1rbrtUZlHWs5REnNQBiWO5bisdDuRnbQw8Tvngg/T+8/oDlTXtyahcpqBNnKI5wrO1wDIGq/cSeKxtnbXJ6K3d0ZluEAANc8VmFAiJCaAUMaqC3bILuZOr+SJBAhAfNC11Y8D4cHUoulCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 178C58B;
	Thu, 16 May 2024 17:34:33 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id SZQ72f5qsZUX; Thu, 16 May 2024 17:34:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 767AA47;
	Thu, 16 May 2024 17:34:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 767AA47
Date: Thu, 16 May 2024 17:34:28 -0700 (PDT)
From: Eric Wheeler <bcache@lists.ewheeler.net>
To: Coly Li <colyli@suse.de>
cc: "Pierre Juhen (IMAP)" <pierre.juhen@orange.fr>, 
    Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: Kernel error with 6.8.9
In-Reply-To: <FCB4406D-192D-46A1-BB6D-2153B527ED87@suse.de>
Message-ID: <ad9d8aa-a6f2-1ec6-1e64-e848c55fd33@ewheeler.net>
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de> <20240315224527.694458-1-robertpang@google.com> <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de> <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com> <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de>
 <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com> <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com> <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de> <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de> <C659682B-4EAB-4022-A669-1574962ECE82@suse.de> <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com> <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de> <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
 <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com> <1be3d08b-4c85-4031-b674-549289395e45@orange.fr> <FCB4406D-192D-46A1-BB6D-2153B527ED87@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-2045106892-1715906068=:9489"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2045106892-1715906068=:9489
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 13 May 2024, Coly Li wrote:

> 
> 
> > 2024年5月12日 17:41，Pierre Juhen (IMAP) <pierre.juhen@orange.fr> 写道：
> > 
> > Hi,
> > 
> > I use bcache on an nvme partition as frontend and md array ass backend.
> > 
> > I have the following error since I updated to kernel 6.8.9.
> > 
> >  UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1098:3
> > [    7.138127] index 4 is out of range for type 'btree_iter_set [4]'
...
> 
> The fix is in linux-next and will be in 6.10 as expecting.

Thank you Coly!

Two questions:

	- What is the commit hash for this fix? 

	- Does it need to be backported to older kernels?


--
Eric Wheeler


> 
> Thanks.
> 
> Coly Li
> 
> 
> 
--8323328-2045106892-1715906068=:9489--

