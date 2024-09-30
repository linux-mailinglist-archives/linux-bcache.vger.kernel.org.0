Return-Path: <linux-bcache+bounces-744-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED94F98A9BB
	for <lists+linux-bcache@lfdr.de>; Mon, 30 Sep 2024 18:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92FC31F219E2
	for <lists+linux-bcache@lfdr.de>; Mon, 30 Sep 2024 16:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7487F192D93;
	Mon, 30 Sep 2024 16:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="bOQbwi1e"
X-Original-To: linux-bcache@vger.kernel.org
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAEE19259E;
	Mon, 30 Sep 2024 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727713605; cv=none; b=YSPtQVeN5tUIqDb6tYdvb+kJVN7tVoBrDmN74PYJVZQnvR1yW1YGFNdlkhYvkn6Qdfh8r0Z8fbitog5GRUJK4SyGzOQJlmIDEz1/jtijPNXWU5XAxyA9AtQxojkDLLuqMa66jauAVmZ9F1FwD9BXFyOADr7g+7ebX9vxToEiO6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727713605; c=relaxed/simple;
	bh=1MqNgWIzr7ogSi3wMunAub2ovk+uhX/K99oDzhLUCfo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mFSuzmndyfscESmylguaNNM12lyZQiVsXIe6HjoyOcvpeYrJbo6fpNHtJYnRUcPWwfChZe4AbZj6VqpkdDnn4QQGfI6LPtdcN0++5bCUUFJKzqTvMIzTgDoTrxbsezbTdYbOCMzizk6XHQfjaK9haGpSzsZwjU/+fFkStkmkSzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=bOQbwi1e; arc=none smtp.client-ip=217.70.183.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 444CF240003;
	Mon, 30 Sep 2024 16:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1727713595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F5fY6vmbXZmGi/YFQGI3QYA0A4g0No5R3ujeFb7Po5Y=;
	b=bOQbwi1e2Fqr7/xgoKfZhzl3gbXgMl+Fkdsw3N9swZcz4LBPYCVVetRz8bBgBTJk3twC2l
	/VB4lAzR1x6hFSg0jlNyVT/WR50YMzhA49j3/ck+QLodWDkINb/r/H/HvUZ6onNNaXy8BT
	yqIGPy1+1Nh+bhBh47UoW7rOcLniquF1MvD4ipyifhBuGQw9HkGcHJNDLShlW6teLLnGbu
	qb3vkhzBQghNDLIRtdw7SmA38Au69UztL+qPcRjAHgKdaWPehnD31RNh0J6lFk0VRi8PrL
	QjqbHWYg6ooZIwUAsonoihw5/IT+2gpco60vlaV6vlwmI520eM/IbOoVpozbVA==
Date: Mon, 30 Sep 2024 18:26:33 +0200
From: Herve Codina <herve.codina@bootlin.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet
 <kent.overstreet@linux.dev>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, linux-bcache@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
Subject: Re: Build regressions/improvements in v6.12-rc1
Message-ID: <20240930182633.6b5ce8ed@bootlin.com>
In-Reply-To: <6464b079-372d-d3f-d774-a7c05916fbe2@linux-m68k.org>
References: <CAHk-=wiwVOCZsC6a4dLdb1UjL2fS_CnLNjrPL0XGFbDd9C26Cg@mail.gmail.com>
	<20240930145322.129875-1-geert@linux-m68k.org>
	<6464b079-372d-d3f-d774-a7c05916fbe2@linux-m68k.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-GND-Sasl: herve.codina@bootlin.com

Hi Geert,

On Mon, 30 Sep 2024 17:11:09 +0200 (CEST)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Mon, 30 Sep 2024, Geert Uytterhoeven wrote:
> > Below is the list of build error/warning regressions/improvements in
> > v6.12-rc1[1] compared to v6.11[2].  

...

 powerpc-gcc13/ppc64_book3e_allmodconfig
> 
> drivers/soc/fsl/qe/qmc.c: In function 'qmc_qe_init_resources':
> include/linux/err.h:28:49: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>     28 | #define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
>        |                                                 ^
> include/linux/compiler.h:77:45: note: in definition of macro 'unlikely'
>     77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>        |                                             ^
> drivers/soc/fsl/qe/qmc.c:1764:13: note: in expansion of macro 'IS_ERR_VALUE'
>   1764 |         if (IS_ERR_VALUE(info)) {
>        |             ^~~~~~~~~~~~
> 
> IS_ERR_VALUE() is meant for pointers (fix available)

I saw your patch, tested and acked it.
Thanks for the patch.

Hervé

