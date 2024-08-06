Return-Path: <linux-bcache+bounces-710-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26C52949902
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Aug 2024 22:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D40E328311F
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Aug 2024 20:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588D315B0FD;
	Tue,  6 Aug 2024 20:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mzr30dZ+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DF2155C83
	for <linux-bcache@vger.kernel.org>; Tue,  6 Aug 2024 20:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722976033; cv=none; b=SaK12QC6uzN9z1tzgMK6OnHfFl6Sqcoa3Ji9r1+cKN9Ht3wbih/++6xhRprFuJDmZo4cIF1R9skYgJAWR6QvehjMkD0xpC1lsoZxGYMYdJ/jky4Q4m38pIjRmm/qwKliHjkc4EcrlQbzd1ZuqIzDrw/kRmowTI/zxfHfNf58Hm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722976033; c=relaxed/simple;
	bh=btUfqlgIPsW5xmoTNva6xF0qhko+vUw4cMAgKjEZ1Dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BM8UxgoCdL9tXs5SWG/Bn+uXaRyE+sLsElL+F2Gebkfqx2vPIN6EuYiDI3HIIB/COlQMbHKfjFVG/pYGTq9OmGrDjkiP9WRkQIQC8gz5bHpsx+/P9SR0POwEoCHkPP7nGEd9SDV6OQnEb70PRQsGuxrqHQ2oXaoHmBLF9KUEcLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mzr30dZ+; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 6 Aug 2024 16:27:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722976028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JjlADmA1+ph94gpKdf2QjHWMGzUXadMDhnq/CMyNQUo=;
	b=mzr30dZ+1RFTovgPsdrFQtpIPDRNovN9Lv0lrRb87ZG9sURHkfj+dsFOjHA8ttBbek7dAM
	EsKMlFj2yfjWJx4D9LbPVSgkAcON60SmiH5T/bhjFWxGHQ2uNK00C58/chKklU0sRcxCpZ
	8IK85TzJun/0ECHnbE2+PjkdHJ7zL00=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jonathan Carter <jcc@debian.org>
Cc: linux-bcache@vger.kernel.org, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, slava@dubeiko.com
Subject: Re: bcachefs mount issue
Message-ID: <qxaz6togfw4w6bd5viau5wrvlieff5lyt3ijuj3fukutatdyem@zhn6hoqmkqlv>
References: <0D2287C8-F086-43B1-85FA-B672BFF908F5@dubeyko.com>
 <6l34ceq4gzigfv7dzrs7t4eo3tops7e5ryasdzv4fo5steponz@d5uqypjctrem>
 <21872462-7c7c-4320-9c46-7b34195b92de@debian.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21872462-7c7c-4320-9c46-7b34195b92de@debian.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 06, 2024 at 05:21:04PM GMT, Jonathan Carter wrote:
> Hi Kent
> 
> On 2024/08/06 09:50, Kent Overstreet wrote:
> > Debian hasn't been getting tools updates, you can't get anything modern
> > because of, I believe, a libsodium transition (?), and modern 1.9.x
> > versions aren't getting pushed out either.
> > 
> > I'll have to refer you to them - Jonathan, what's going on?
> 
> 1.9.1 is in unstable. 1.9.4 would be good to go if it wasn't for a build
> failure I haven't had time to figure out, although I e-mailed you about it
> on the 26th (Message-ID: <2250a9ef-39e0-4afc-8d0d-2d26fbddbdaa@debian.org>)
> but haven't received any reply yet.

I get no hits searching for that?

