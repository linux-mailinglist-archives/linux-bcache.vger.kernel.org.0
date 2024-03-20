Return-Path: <linux-bcache+bounces-351-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E1D88182D
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 20:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A7E0B22CDE
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 19:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407368565E;
	Wed, 20 Mar 2024 19:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d2F4V4P4"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F4A4F214
	for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710964688; cv=none; b=PnbYTc5pd+MsjOEAwdiWMPVnY9wQ9nIXDQHbxfIpb7GXkjYQWatYCWJ/jwJDWvRRUngyZg37MxMVnWbbZ6ETV0xvzmX3KDpgK9p72jrVhDsn5eyyu40zsBhFX412PosN7nCHvkBKMBQg+AuI+ZOPV13bJ39/KIuVqH2grGrXztE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710964688; c=relaxed/simple;
	bh=pEG22NwYFyFmWvY2wmyPkiIdnK/c+xHCUdLEhr5WMZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpYPRrXDK+sVmXridjhRSM6offhun2SUqEcngzKBwiVqifu1dPFdjKlgKcADMDXzyq2D40qo1I33Gxjb3eyj0wWi4wjS6ZpTHGxdn5MhiC8iGoz/104204oLRd5PkN0FLLm5hTA6qPBmZobVtDYv3D33LCnYcqO0BhGGAtELwGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d2F4V4P4; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 20 Mar 2024 15:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710964684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pEG22NwYFyFmWvY2wmyPkiIdnK/c+xHCUdLEhr5WMZA=;
	b=d2F4V4P4bPTRcE2lpe+a6XWprf6h5GK9jnuoWgPaJ7mE0xvoMbWvpdgvK1X+H93iwYmH6t
	W+bSB2V9OOJddBA4EyhOk3RMBpTziueWbPAosBX4fPGZmBC3c/moYCGmLSMr5VFLui/NS3
	s22KyXrwvNzMjcMnpmvfRWH/GA8vWOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org, 
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org, 
	bfoster@redhat.com, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 00/15] treewide: Refactor heap related implementation
Message-ID: <ofjgwiygmyl4fmstibtrckzdoibsmxqypjg2aohwpsg57urqhw@5bikquw6kwew>
References: <20240320145417.336208-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240320145417.336208-1-visitorckw@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 20, 2024 at 10:54:02PM +0800, Kuan-Wei Chiu wrote:
> This patch series focuses on several adjustments related to heap
> implementation. Firstly, a type-safe interface has been added to the
> min_heap, along with the introduction of several new functions to
> enhance its functionality. Additionally, the heap implementation for
> bcache and bcachefs has been replaced with the generic min_heap
> implementation from include/linux. Furthermore, several typos have been
> corrected.

looks like something's busted:

https://evilpiepirate.org/~testdashboard/ci?branch=refactor-heap

