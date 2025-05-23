Return-Path: <linux-bcache+bounces-1082-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8303DAC2638
	for <lists+linux-bcache@lfdr.de>; Fri, 23 May 2025 17:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AA13A24D86
	for <lists+linux-bcache@lfdr.de>; Fri, 23 May 2025 15:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236272063F0;
	Fri, 23 May 2025 15:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="O9I+RoBU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tcBite/x"
X-Original-To: linux-bcache@vger.kernel.org
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B69F625;
	Fri, 23 May 2025 15:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748013474; cv=none; b=ppYWP1zb3G+Yb191EfvvoFlTZs6rqCttI6OK+yLs5rv7C+iFmtNQlHIi1RQOnOhKAosbKVV540EoaNQ1mZ//gN7UqkngDPisubc+aTWKPRoNJJpOjzJg5pR9Hh9N1FAR2XY6dJvpOTQdPrYCf4d2s/sxrp2kdHzM9wQXyTbuQU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748013474; c=relaxed/simple;
	bh=No8xpjWnUSnnkXCYWEq+CoEgrYLunQ0PEcNxTthf7tc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=sLj2wPIEr9qj4k0jcRn6VQrn9897hqhKsXFU2BkMsV7Wm/e5V6ERIq1oOy0HwBdt70nFqak+MdyBlHhVRjRl0wwLnrgJbaIzAfPlJ/Ul/YgNpeiiMFziEGAlZGIw4v1JXAO0QmeGzV74oP1IIkxlgdzUVEUqL95RL4l8q8Ho8+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=O9I+RoBU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tcBite/x; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0EA921140106;
	Fri, 23 May 2025 11:17:51 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-05.internal (MEProxy); Fri, 23 May 2025 11:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1748013471;
	 x=1748099871; bh=kXM/3aDqkrjgcuqABElWAeHJjKc7GGEC2Po0EtVd4FY=; b=
	O9I+RoBU+nko7Ax+taYu1Y8riuEUt9KxWQypKkW1DlWMY5uPkjXCYH5ZAp6eqOIG
	vKSYfXRkAPQ4ufaExxo0oMu0iJl2B24ssn4BQnEN34Rv+u/ToekM5i0n5fWYaRc7
	e2I2f4OS+NdJO/blov35WPFa8CVnziOifYGDg1o6YcuO3zzabz2b0iFFd1+nHt3t
	NlGpP47VA64SATOaKRe1orQeQHLpcmR5PTiyfKchlpaw8c+UW8R7NS6CI/MUoJA+
	tR9Fyc0EqpGxsYUG0w7C8az1RsGE68UwADynCSEdPKL2FUEDQWPTKeG2Be+l6CtC
	tjbZNVKa0Xn7wVHOid8tlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1748013471; x=
	1748099871; bh=kXM/3aDqkrjgcuqABElWAeHJjKc7GGEC2Po0EtVd4FY=; b=t
	cBite/xVGP7VNaFP3G3lSxKrFm88rm1PLA4BSXZuYgk7to9iN7DNB5tTMaZIIEnD
	AcEGEeua3bohoUeiWylHU90Qp0eCi6N+syAqtdOQWUOTylWHyjTQNXbZ8UXBuSa3
	SZJCj/WW98h/ZKT5OOQBLstpCfbOdqkPt5xqXhaicAONkLDGsV2aJSc5lkwAjOrW
	Eg1InIEMiRIODJe8fa1WesojZaB6dAaKAgWWWRhz79lXCtFCgdIAmuKvAqjXlRmC
	/nmFmcxO6xvJjgQYOmi5mFiAFcuRlf/NdDwQp71mZuOjQ0jEROuf3/Y2COaMRm2x
	UnvVHmdYMBdMzdPtaN43A==
X-ME-Sender: <xms:npEwaF1LUu4uDq4ouupDtqYM0JX_9Y8ZPKAgZbg5aqTSf4_7qmJoLA>
    <xme:npEwaMHAcdD5ukO3NUQWBsOLt2EdEIiIgjcy1YTOQj353y_PQD-ezLNzQASF9dZp9
    4Kow8MAj-xwG5IVVgY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddtgdeludelucdltddurdegfedvrddttd
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
X-ME-Proxy: <xmx:npEwaF7Q6Pp9UcTqK5g6P3p92b1h-ckk2ony-GdVfkGUENTw9yzk4Q>
    <xmx:npEwaC2Y4N_QQaydL2o8K8r2DQAP2Io-QwwQwXcPYCLpn-h2kkvoVg>
    <xmx:npEwaIH9GKe2VOcBtQkNYtxOndUSoYe5Ztg9ylGUL8gD314InihrBQ>
    <xmx:npEwaD9yOKuoTdefO2qFtH8Hn7pX5gecKWjGOCxcy1m8AbCvDu3M8Q>
    <xmx:n5EwaGc3i00nwBeIJCFPNDwP-sBxFds3Xa3JrvoZ_Dye6u7pWomoAilD>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 798661060061; Fri, 23 May 2025 11:17:50 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Tddf37e9d72974a2b
Date: Fri, 23 May 2025 17:17:15 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 linux-bcache@vger.kernel.org, "open list" <linux-kernel@vger.kernel.org>,
 lkft-triage@lists.linaro.org,
 "Linux Regressions" <regressions@lists.linux.dev>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "Anders Roxell" <anders.roxell@linaro.org>
Message-Id: <566aefc9-7cad-4eb8-8eb0-8640d745efa2@app.fastmail.com>
In-Reply-To: 
 <7tsvzu2mubrpclr75yezqj7ncuzebpsgqskbehhjy6gll73rez@5cj7griclubx>
References: 
 <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
 <6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
 <CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
 <6247de76-d1f5-4357-83bd-4dd9268f44aa@app.fastmail.com>
 <7tsvzu2mubrpclr75yezqj7ncuzebpsgqskbehhjy6gll73rez@5cj7griclubx>
Subject: Re: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is larger
 than 2048 bytes [-Werror=frame-larger-than=]
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, May 23, 2025, at 16:08, Kent Overstreet wrote:
> On Fri, May 23, 2025 at 03:49:54PM +0200, Arnd Bergmann wrote:
>> On Fri, May 23, 2025, at 15:19, Naresh Kamboju wrote:
>
>> I reproduced the problem locally and found this to go down to
>> 1440 bytes after I turn off KASAN_STACK. next-20250523 has
>> some changes that take the number down further to 1136 with
>> KASAN_STACK and or 1552 with KASAN_STACK.
>> 
>> I've turned bcachefs with kasan-stack on for my randconfig
>> builds again to see if there are any remaining corner cases.
>
> Thanks for the numbers - that does still seem high, I'll have to have a
> look with pahole.

I agree it's still larger than it should be: having more than
a few hundred bytes on a function usually means that there is
both the risk for actual overflow and general inefficiency if
all the stack data gets accessed as well.

It's probably not actually structure data though, but a
combination of effects:

- KASAN_STACK adds extra redzones for each variable
- KASAN_STACK further prevents stack slots from getting
  reused inside one function, in order to better pinpoint
  which instance caused problems like out-of-scope access
- passing structures by value causes them to be put on
  the stack on some architectures, even when the structure
  size is only one or two registers
- sanitizers turn off optimizations that lead to better
  stack usage
- in some cases, the missed optimization ends up causing
  local variables to get spilled to the stack many times
  because of a combination of all the above.

The good news is that so far my randconfig builds have not
shown any more stack frame warnings on next-20230523 with
bcachefs force-enabled, now 55 builds into the change,
across arm32/arm64/x86 using gcc-15.1.

       Arnd

