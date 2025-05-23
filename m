Return-Path: <linux-bcache+bounces-1084-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D752AC293A
	for <lists+linux-bcache@lfdr.de>; Fri, 23 May 2025 20:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1B451B67A74
	for <lists+linux-bcache@lfdr.de>; Fri, 23 May 2025 18:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB2628B509;
	Fri, 23 May 2025 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="2Vsmli+d";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SI85RS1b"
X-Original-To: linux-bcache@vger.kernel.org
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4231721ABD3;
	Fri, 23 May 2025 18:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748023318; cv=none; b=rmv1rP34DWVVITlu7tfcteWwxfVdzQniZgqUgtxFj4+STv7HgMuwcsvXQGx+PcC2cxo9oAVJixmyXs+wDczaEPCfvTtf6hMOcr2W2shfw7lOmSZY59ANMjUMDDvzqCfpMnMyJmFhn1ZtmDHJ5QOOE67/u+H3lYZPLdOZxcHSRAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748023318; c=relaxed/simple;
	bh=eLcMbXdwuNnvAUlO9CRu55Ndn59jGO1rx+ykDT5c1K0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=cioAzFldfDcoEPkOtsDZuWItU4Rg3myfPWzT+LpffgqCMC3TJROMMT+eMEYy+fRwspl20H3BViABAFi0+v9opvon2PSwIwKey1sJsFN91G4sZ6lFnU0XL8H4FBOTwIwJTFnV3ZTM4iE99V2nWDSe1Sm5BeP0kWcaIgwof51ITLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=2Vsmli+d; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SI85RS1b; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 1D75411400C0;
	Fri, 23 May 2025 14:01:55 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-05.internal (MEProxy); Fri, 23 May 2025 14:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1748023314;
	 x=1748109714; bh=etHm7ib5DqaWFk1XWWYwvr/YNJrq8Y1TAgZzJHn5gcM=; b=
	2Vsmli+dvja130EpShUHphEGFbPVJDvyPSZb0A6bmhnW1Qk1bru540h09TUFu180
	z0Wpd4ynhV7Zg6WsLzt834vz9cc+Bqj3Bu+IIfzWCvu9Qx5FqGThCYqwuCssUnHb
	mxIlEQViPjbaMEU77lnBXzqk6cM0lx1i0chvq5e9p+ifTefEyuObBzvs7L9EXWJP
	SMHzdKRoa1uDeiBeC2QJ7PUkHkyy1RA+ZMPE8ffZx03qbOnl9qFBjKGoVzsk5OY4
	YJIoNrBegB0pz0p5oU3N6gsrWM/QU1mE9BFXr4o/MzPwWTmfac2/EQwsRBDe/tN5
	J0ICFdjaut/iXLn6t18FxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1748023314; x=
	1748109714; bh=etHm7ib5DqaWFk1XWWYwvr/YNJrq8Y1TAgZzJHn5gcM=; b=S
	I85RS1b7dAIRflZ5rplYPidXo6iSIFKUkG5w1XtIPG+/+N8jqx2g1eW1Shu033cY
	tZS3kiOz5vlzKHjGGC/nC/8Gh+R0av5Z5Tg7EDM6Y222aHgDZghcFyTCSKmo08V2
	/TbVj7t3SyAFocZ0Imf2/zlEj1wlwkPTuYO8Jt2FBklt80rVbuuej/sOLr4svkHR
	juSGJIMGbdEeGM2ioOfSeVk72xyWYYKLXKvLj97VctkCS7WdlBSKRWnlIInNSuZb
	NDBVq2+CgwapxZPnJAuvnr7+fmw4PTNA6ardoEPPx+ows40Ci2c92waFYBjUS1iF
	clmuN55g0dliBWQdHvoWA==
X-ME-Sender: <xms:ErgwaF4VTF9t0dXQSdszMmdQTPsVIEdaMlrnUW12ogZiBZJnTv3-0Q>
    <xme:ErgwaC6pNW2GVsDS5Tm18svA_4fpUbxAV4K8HuwxgFvXfIVJskA6VmGGJmNX7TZjX
    18RunE6cqA5Vxrv7U8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddtgdelhedvucdltddurdegfedvrddttd
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
X-ME-Proxy: <xmx:ErgwaMe0oIf56Skend13df07ttI1F5HCefs-y414yDoWbgVNcYp6aA>
    <xmx:ErgwaOIuL6DRKH_C9SemZmzaKVCPykmy1tzHyUMvUJ_08_VIL8Y_zg>
    <xmx:ErgwaJLG0QhITT5OAV8utOikBh6qLXfQFeErjlPcfzh4f-3L80COZw>
    <xmx:ErgwaHxUN2VctTz5xzcnIGN_ivhIIu5Zj8krUjNyoUPHVim7Wbo7cA>
    <xmx:ErgwaEyAFwwaxCURHiIGUPrbRS5uYYsTVgXzbno-g7aXVa2MxdF3XhqA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6F3C31060063; Fri, 23 May 2025 14:01:54 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Tddf37e9d72974a2b
Date: Fri, 23 May 2025 20:01:33 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 linux-bcache@vger.kernel.org, "open list" <linux-kernel@vger.kernel.org>,
 lkft-triage@lists.linaro.org,
 "Linux Regressions" <regressions@lists.linux.dev>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "Anders Roxell" <anders.roxell@linaro.org>
Message-Id: <692e313d-ea31-45c0-8c66-36b25c9d955d@app.fastmail.com>
In-Reply-To: 
 <hplrd5gufo2feylgs4ieufticwemeteaaoilo2jllgauclua2c@o4erpizekm5y>
References: 
 <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
 <6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
 <CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
 <6247de76-d1f5-4357-83bd-4dd9268f44aa@app.fastmail.com>
 <7tsvzu2mubrpclr75yezqj7ncuzebpsgqskbehhjy6gll73rez@5cj7griclubx>
 <566aefc9-7cad-4eb8-8eb0-8640d745efa2@app.fastmail.com>
 <hplrd5gufo2feylgs4ieufticwemeteaaoilo2jllgauclua2c@o4erpizekm5y>
Subject: Re: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is larger
 than 2048 bytes [-Werror=frame-larger-than=]
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, May 23, 2025, at 19:11, Kent Overstreet wrote:
> On Fri, May 23, 2025 at 05:17:15PM +0200, Arnd Bergmann wrote:
>> 
>> - KASAN_STACK adds extra redzones for each variable
>> - KASAN_STACK further prevents stack slots from getting
>>   reused inside one function, in order to better pinpoint
>>   which instance caused problems like out-of-scope access
>> - passing structures by value causes them to be put on
>>   the stack on some architectures, even when the structure
>>   size is only one or two registers
>
> We mainly do this with bkey_s_c, which is just two words: on x86_64,
> that gets passed in registers. Is riscv different?

Not sure, I think it's mostly older ABIs that are limited,
either not passing structures in registers at all, or only
possibly one but not two of them.

>> - sanitizers turn off optimizations that lead to better
>>   stack usage
>> - in some cases, the missed optimization ends up causing
>>   local variables to get spilled to the stack many times
>>   because of a combination of all the above.
>
> Yeesh.
>
> I suspect we should be running with a larger stack when the sanitizers
> are running, and perhaps tweak the warnings accordingly. I did a bunch
> of stack usage work after I found a kmsan build was blowing out the
> stack, but then running with max stack usage tracing enabled showed it
> to be a largely non issue on non-sanitizer builds, IIRC.

Enabling KASAN does double the available stack space. However, I don't
think we should use that as an excuse to raise the per-function
warning limit, because

 - the majority of all function stacks do not grow that much when
   sanitizers are enabled
 - allmodconfig enables KASAN and should still catch mistakes
   where a driver accidentally puts a large structure on the stack
 - 2KB on 64-bit targes is a really large limit. At some point
   in the past I had a series that lowered the limit to 1536 byte
   for 64-bit targets, but I never managed to get all the changes
   merged.
  

     Arnd

