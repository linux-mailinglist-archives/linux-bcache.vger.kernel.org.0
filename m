Return-Path: <linux-bcache+bounces-1080-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF27AC2482
	for <lists+linux-bcache@lfdr.de>; Fri, 23 May 2025 15:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BA2C3A55B6
	for <lists+linux-bcache@lfdr.de>; Fri, 23 May 2025 13:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5687E293754;
	Fri, 23 May 2025 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="nhBlbk2c";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dDnM+kpu"
X-Original-To: linux-bcache@vger.kernel.org
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B07F23BF8F;
	Fri, 23 May 2025 13:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748008228; cv=none; b=OoU5+vPsrib+55RouNoAfXVX9XlgEtMlj74KNVRoPiN9uYCRT9he7QAy+eZoFi059giOBdJVRzHsKcH8tiDmPdNhfNPkZ3PpjuQG9jpwpNSA/XoHpsWZZvx4yisV2f6wg4fB97Tk4wO+/ZGTP5pw/WpIct+jXswa5O6mCv6dHf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748008228; c=relaxed/simple;
	bh=gvDSFMftq2xvBxLAPiKF4U6sgwwEgE5IbEI/MR89zMg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=tLZEcj8gmecRc9oWlRD8aKTrzOszNk9OIYTh1Dk8yWl/hrNvbI1idJqs9O9yh40WzP6XV7UU/656xhvbhBtJzEziYYdS8l7xi2MxT9BmvaKilQRYR65e/ORLompvp84VObiYy3vKBLEv0OvswCTrAgkzrODR0hIsMFyDVkvgqys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=nhBlbk2c; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dDnM+kpu; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 818A61380430;
	Fri, 23 May 2025 09:50:25 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-05.internal (MEProxy); Fri, 23 May 2025 09:50:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1748008225;
	 x=1748094625; bh=+GVMWy7OrkM+vnJGAFlSms2EGq4iQQRcyXCmmXQgscg=; b=
	nhBlbk2cCVe6mzid/dfALYxotsUGBbHlr9LyRVdc8N9SJ9JowaW/2WRqyo/MsRWs
	dKIrlU/obH6bIpj1Vh0iOzRmfUVkHAjtcZqpHJ+nRk3s480DsvjXLjlx0Bk9vqhs
	0ccbhkRKL1wFXGu1fPpB+vi4F9cxkmq0EZR3PTBThLbo+GPAIcuH1Km9O9hs8OPx
	7iXGvD3hLRgjAEGnQxxTujzePL0U6vi38ZmgXDlGaxGzuaM1hDk3uf30rIweVKpT
	3tarX2e96x+NZw3l/nwEcr32vTolIuVaUBMOzb2dDABj+1YbQlA0VguOboSiJAVH
	2ohARpIsKK+LbXZFKVmJWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1748008225; x=
	1748094625; bh=+GVMWy7OrkM+vnJGAFlSms2EGq4iQQRcyXCmmXQgscg=; b=d
	DnM+kpuKMDgLosPDAu7oo2jxJyRoBVFFH2iQkTlEtMQef8Zo+1nOZ00hzgOLlJ+i
	wLPDWzC13urorrRrtiVZWGJQBjks+mP71JCWJQB9tYkOi8frGvPuHtJUWUXZWkjj
	jvTvIIeLnFSciMeXXnReUVhaWgHIoKjGwm6SXKT01OByHkPMSj6cRi3SVltjR+62
	zoic1rEc0ks/x0/Hbq/GwyZxsOBAyZqFwwVc3WCB7O4e+xdxV3vkqpc3z8kIBdme
	FOnyIXHOF5J1nqKlSF9mJFBkKQzMH5Yha7+zaiHO6/s5e9hwGPSGaoWrnzZuFXye
	3JuuGhBEPmUBXJSs725MQ==
X-ME-Sender: <xms:IX0waMgUMb-o54dXNBq5s4jK4er7iTVbqZPPgJSv4dZGJN5i1lBalA>
    <xme:IX0waFCl52CqZiJaOfId6BXaPdGS8N_GEiZt3LlRtm5j8BXKLcdQRJYtVj8DkblnW
    wI_9ntQTF5OkrbqmrI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddtgdeltddvucdltddurdegfedvrddttd
    dmucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgf
    nhhsuhgsshgtrhhisggvpdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttd
    enucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgj
    fhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuc
    eorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvghrnhephfdthfdvtdefhedu
    keetgefggffhjeeggeetfefggfevudegudevledvkefhvdeinecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdp
    nhgspghrtghpthhtohepkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghnug
    gvrhhsrdhrohigvghllheslhhinhgrrhhordhorhhgpdhrtghpthhtohepuggrnhdrtggr
    rhhpvghnthgvrheslhhinhgrrhhordhorhhgpdhrtghpthhtohepnhgrrhgvshhhrdhkrg
    hmsghojhhusehlihhnrghrohdrohhrghdprhgtphhtthhopehkvghnthdrohhvvghrshht
    rhgvvghtsehlihhnuhigrdguvghvpdhrtghpthhtoheplhhkfhhtqdhtrhhirghgvgeslh
    hishhtshdrlhhinhgrrhhordhorhhgpdhrtghpthhtoheprhgvghhrvghsshhiohhnshes
    lhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdgstggrtghhvg
    esvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgv
    lhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:IX0waEGbRx6_44RMxP5zm6ixDdwcLqiNm5RoLrN4kPNk15D8zdLu_g>
    <xmx:IX0waNTsyPz-Ani2Bd9WO8-fTk1aYvifLNb9zL4QGuFSJbXNNvbELA>
    <xmx:IX0waJwSB45iN4X_Pr7eNEzeMLOBf1FHG1rmc1JnM8BaRgEFYg25VA>
    <xmx:IX0waL6wccRI3HD-SU6M8ogfQtMQt3wMrQj3kkuLJC3bRutFZ3oEPA>
    <xmx:IX0waB4WRM5_OXIncPJKkQO57U01ApJvWO_ARH0pfIFPRV1RKcWu4rFs>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 32AD81060060; Fri, 23 May 2025 09:50:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Tddf37e9d72974a2b
Date: Fri, 23 May 2025 15:49:54 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org, "open list" <linux-kernel@vger.kernel.org>,
 lkft-triage@lists.linaro.org,
 "Linux Regressions" <regressions@lists.linux.dev>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "Anders Roxell" <anders.roxell@linaro.org>
Message-Id: <6247de76-d1f5-4357-83bd-4dd9268f44aa@app.fastmail.com>
In-Reply-To: 
 <CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
References: 
 <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
 <6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
 <CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
Subject: Re: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is larger
 than 2048 bytes [-Werror=frame-larger-than=]
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, May 23, 2025, at 15:19, Naresh Kamboju wrote:
> On Thu, 22 May 2025 at 22:18, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>>
>> On Thu, May 22, 2025 at 06:59:53PM +0530, Naresh Kamboju wrote:
>> > Regressions on riscv allyesconfig build failed with gcc-13 on the Linux next
>> > tag next-20250516 and next-20250522.
>> >
>> > First seen on the next-20250516
>> >  Good: next-20250515
>> >  Bad:  next-20250516
>> >
>> > Regressions found on riscv:
>> >  - build/gcc-13-allyesconfig
>> >
>> > Regression Analysis:
>> >  - New regression? Yes
>> >  - Reproducible? Yes
>> >
>> > Build regression: riscv gcc-13 allyesconfig error the frame size of
>> > 2064 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
>>
>> Is this a kmsan build? kmsan seems to inflate stack usage by quite a
>> lot.

KMSAN is currently a clang-only feature.

> This is allyesconfig build which has KASAN builds.
>
> CONFIG_HAVE_ARCH_KASAN=y
> CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
> CONFIG_CC_HAS_KASAN_GENERIC=y
> CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
> CONFIG_KASAN=y
> CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX=y
> CONFIG_KASAN_GENERIC=y
> # CONFIG_KASAN_OUTLINE is not set
> CONFIG_KASAN_INLINE=y
> CONFIG_KASAN_STACK=y

I reproduced the problem locally and found this to go down to
1440 bytes after I turn off KASAN_STACK. next-20250523 has
some changes that take the number down further to 1136 with
KASAN_STACK and or 1552 with KASAN_STACK.

I've turned bcachefs with kasan-stack on for my randconfig
builds again to see if there are any remaining corner cases.

     Arnd

