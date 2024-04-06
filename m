Return-Path: <linux-bcache+bounces-384-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9080F89AC7A
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 19:32:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CC25282B18
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 17:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CEA40853;
	Sat,  6 Apr 2024 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qVCVk5mo"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23CD3FB92;
	Sat,  6 Apr 2024 17:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712424713; cv=none; b=eF/vfA6X2cyrb6V+Mt/tkYGhFRh5G8jRHz+S/JuA+8V+3wpkpwxooSTvAEWSWo4lHkSZS4s9JMbb9/QVyAIKaw97moA81BR1eugHEDb7YQvKcVIY2iIZ1pa/O45CfO7i+ptVDrm30Mf8WZpa+eU6/NO3bmy/PLdHHHf0N9Yzl0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712424713; c=relaxed/simple;
	bh=vZ8hOquufdNKiyCJecLeixIcMnrnV1AW3oXr5DxC8CU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d51g6F4sOrv5Kgfob578ZH1Jj1RGnG+rVyhKcTohxsK/f2fm85Mkl6Tm8Ct9I1jnsoSXIi5mbg6upmor98tSFhGlWd12LL8HqSywvsnQvGFIXxvocUw/2DtvVTti1AygXivx/+r1l9uiGaa4ohmemkxo4CoGnWRBOFFup5OApYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qVCVk5mo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=5v76W08TT679PKia3IEz1oLMJe/sls4wnfr6gKUBWtQ=; b=qVCVk5moDyycimdiGI9lb20ivU
	+bUKgCMQn2i7dGau9Yj4YI18gbUtwisM3meIjdLI3kVbGwa8PKbwhJ7JZz2dk0908QC+eRTAkr6D+
	RkuKXz2HX+CYJn+t7/mhcyQyCWNvn2+nU+qw7ipMn3shNoyk6lnkrz8d2o6NsivsWkyqF1G/7OELq
	JST25fzpSg9ygATfKklKt+N6DgP6GeQyxZIYMAjh1vWJ1cl0M/jq9dqG435fF+ioFCA0LddV6A8Ud
	/cCP6CLuGq8ooK/o37+2HBimh+Xh/k/it3HgKFuBy8nleqRoKynnS63U4ltWtPsdSMlJqFfOGSAkq
	cW9He2Bg==;
Received: from [50.53.2.121] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rt9tE-0000000Ajxe-1mzp;
	Sat, 06 Apr 2024 17:31:40 +0000
Message-ID: <bce1e749-1317-446b-a07a-6381ceb599e8@infradead.org>
Date: Sat, 6 Apr 2024 10:31:39 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/17] bcachefs: Fix typo
To: Kuan-Wei Chiu <visitorckw@gmail.com>, colyli@suse.de,
 kent.overstreet@linux.dev, msakai@redhat.com, peterz@infradead.org,
 mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
 akpm@linux-foundation.org
Cc: bfoster@redhat.com, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com,
 adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
 linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240406164727.577914-1-visitorckw@gmail.com>
 <20240406164727.577914-4-visitorckw@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20240406164727.577914-4-visitorckw@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/6/24 9:47 AM, Kuan-Wei Chiu wrote:
> Replace 'utiility' with 'utility'.
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Reviewed-by: Ian Rogers <irogers@google.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  fs/bcachefs/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index 92c6ad75e702..05ac1b3b0604 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * random utiility code, for bcache but in theory not specific to bcache
> + * random utility code, for bcache but in theory not specific to bcache
>   *
>   * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
>   * Copyright 2012 Google, Inc.

-- 
#Randy

