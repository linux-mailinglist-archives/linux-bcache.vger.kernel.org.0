Return-Path: <linux-bcache+bounces-383-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D079C89AC77
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 19:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CB552827A7
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 17:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6269645946;
	Sat,  6 Apr 2024 17:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UJRF6vJP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1793EA86;
	Sat,  6 Apr 2024 17:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712424678; cv=none; b=LhFGXR4NtsG6bScj07qmZP7U22F3EuyXRm31pL5RnK9A+2XLQdYlxynxyE9eT4kXEu+WjocPkW6GK7ACkHs2RlFZKie9b26NVkSNnZQybDjSnIA9/Bp086tZoMSXN+1/krcFAa1tGFLgx3iTZhktI+iVNVGkrp+ECJsswwSAZ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712424678; c=relaxed/simple;
	bh=ftckwan37Vhx83yVrQKbmqsR6b3/XLtHQxOvyo6XXc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUUlbkVY4Fd+Debo7D5CXjdtb1etgKn2ze6pUTAGlbgAmwJEnI7BCimphEvMu+iqHR4RBKyBd89SohkFn9yv9P5M8r5Gtk/A5GRFtV129Fe/RCe1CH5JwF/Ku3krjPBK0+tchXykWHtX+ai4Gji5jwXsPnh5Bs5xS/cEIyYdDnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UJRF6vJP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=VZyLlJtFuOzBAKWflJfhCLyZ2BZslEpytYrxNUzQ/TY=; b=UJRF6vJPl1+lUxFjEBKcV7oBLN
	r6n/l8OuJzzB00YI6wXw/Vnp2hc9lbY4zBRk9KC5pHIqZDakFN35Ow0KU22cPkQSFjQ4vQF30bfdS
	7wvRrHKPMCgFf9tV7YaO65MOJTleibRjqfd1XjNNaBiRe9MJDtRTk7X0UtMw962eMuidsLLANhVQ9
	llJqC61eDOB/k5tJieFZsepUQ6mxtC5z/41cASjwuMGNpmf6135cQKiTzUuRuEH9jo/sO8FvBV/+X
	SxXTcntxZNPH9rMZdAC77l01keiKUDI96zzKGeD7DzRSSTBWDDAg0U83nJD5lJImaNxjXny8YaJnX
	zZt8dBfg==;
Received: from [50.53.2.121] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rt9sm-0000000AjrC-0kOV;
	Sat, 06 Apr 2024 17:31:12 +0000
Message-ID: <af40f530-33f8-412e-aa3b-cf8a0bd41531@infradead.org>
Date: Sat, 6 Apr 2024 10:31:11 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/17] bcache: Fix typo
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
 <20240406164727.577914-3-visitorckw@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20240406164727.577914-3-visitorckw@gmail.com>
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
>  drivers/md/bcache/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index ae380bc3992e..410d8cb49e50 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
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

