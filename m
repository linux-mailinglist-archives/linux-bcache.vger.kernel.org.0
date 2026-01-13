Return-Path: <linux-bcache+bounces-1366-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C264AD1A3FA
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 17:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 35D9C3065158
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 16:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE96D1A2392;
	Tue, 13 Jan 2026 16:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="aWv/852N"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-19.ptr.blmpb.com (sg-1-19.ptr.blmpb.com [118.26.132.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864DA1F5825
	for <linux-bcache@vger.kernel.org>; Tue, 13 Jan 2026 16:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768321388; cv=none; b=H86xEkdlyk/mprlvgxFBZ2/Tm5lT1quO33pPEKNDkoT4dWATEHAI9OgD2JH1tqGpG1RMDMLjOmHvBQTrXG4ApQiN+hA9UPwxJTgtv+HWK463/tjWMtXd+LDFzCib+klpy3aE5fXcZcWtng7OBJi9BeEQPDTh4+VGAi5erGwLSz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768321388; c=relaxed/simple;
	bh=7CfmFoq7I+S+WiQ8cKHFUDPldkcAOfFOZIawspnCLpU=;
	h=Subject:In-Reply-To:Cc:Message-Id:Date:Content-Disposition:
	 Content-Type:To:From:References:Mime-Version; b=uYLJs9idsZgrLST5abPrwBtq+tySdbJC7bAiQjYgdE/tdDWdJkHnSnCf7EyG6zguHKa9P5g0RSaIeFeuREVhn+Vvj4FZu9x8fs0ZQq6iAMof1bV6fi3ieGIO+9+lRCGHxIW44fj9rr02iko6BYqvBngM3qX0tzowlzkmu3skXhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=aWv/852N; arc=none smtp.client-ip=118.26.132.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768321380;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bNq/lYaLdIPww6NNywM9E7Dj+tufsVWAHsCFwcVSWE0=;
 b=aWv/852N0/KT9ny1ITMaYCyE0Zs/MDQvXxCRbFOY+ruSKMPOofviGwJbJeFLLdjx86ddQ9
 i2i3EofcaOugvyqyfecQOt1VwuhEDgte04Mzv2J6DKCvEyv4u7Gk/NlhnpBnTp5CbWlE5w
 hS60xsMi47wGDd577xUyBYXYLr5hRg8QFVodBKUPgZdS60JESWHuQfwu17y0quWJgx5Sqn
 s/BLpGXPPdyVya3JNITRxRz45kpLCuBzZt896YUolV0OYUOss2CNjCqMC3Qb9EtkWBv7sZ
 cVWHAKKnW2P0nS1V8erGT29qNc05QFosiVsrC68J5Jd9GMaVjEifBj3pRbNx3Q==
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
In-Reply-To: <aWX9WmRrlaCRuOqy@infradead.org>
Received: from studio.local ([120.245.64.3]) by smtp.feishu.cn with ESMTPS; Wed, 14 Jan 2026 00:22:58 +0800
Content-Transfer-Encoding: 7bit
Cc: <axboe@kernel.dk>, <linux-block@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, "Shida Zhang" <zhangshida@kylinos.cn>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>
Message-Id: <aWZwlE0JdtEvhh9g@studio.local>
Date: Wed, 14 Jan 2026 00:22:56 +0800
X-Lms-Return-Path: <lba+269667163+9d5847+vger.kernel.org+colyli@fnnas.com>
Content-Disposition: inline
Content-Type: text/plain; charset=UTF-8
To: "Christoph Hellwig" <hch@infradead.org>
From: "Coly Li" <colyli@fnnas.com>
References: <20260113060940.46489-1-colyli@fnnas.com> <aWX9WmRrlaCRuOqy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fnnas.com>

On Tue, Jan 13, 2026 at 12:07:54AM +0800, Christoph Hellwig wrote:
> On Tue, Jan 13, 2026 at 02:09:39PM +0800, colyli@fnnas.com wrote:
> > From: Coly Li <colyli@fnnas.com>
> > 
> > This reverts commit 53280e398471f0bddbb17b798a63d41264651325.
> > 
> > The above commit tries to address the race in bio chain handling,
> > but it seems in detached_dev_end_io() simply using bio_endio() to
> > replace bio->bi_end_io() may introduce potential regression.
> > 
> > This patch revert the commit, let's wait for better fix from Shida.
> 
> That's a pretty vague commit message for reverting a clear API
> violation that has caused trouble.  What is the story here?
> 

The discussion happens in stable mailing list. Also I admitted my fault.
Though I didn't ack commit 53280e398471 ("bcache: fix improper use of
bi_end_io"), I read it and overlooked the bio_endio() duplicated entry
issue.

Coly Li

