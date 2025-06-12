Return-Path: <linux-bcache+bounces-1125-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 893EDAD653D
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Jun 2025 03:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 410CD178CE8
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Jun 2025 01:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8566215ECD7;
	Thu, 12 Jun 2025 01:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a4fpncla"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B50101DE;
	Thu, 12 Jun 2025 01:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749692899; cv=none; b=lNg+En4+8vjYqrU01W+/3RSGspR6Z1KsxA4XTzVjqTomDUzHMckCOmn3GHarAaeYmEZ40eb3w96W9a4Oi/o6EtBadMq5JdF91BEjYo70oZno74qD/IgOSqfw6kah25cj8hjr0pLf03J2RbFcmvNl9qI4MvXkLokqaaHZ/QD3cBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749692899; c=relaxed/simple;
	bh=YIM5rjA0nqx+LZ4XlvstnUSBCVZR05FXT4rNVTEZQxk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=CBPP71BVFMDZLbdaid14+QCHsahDL1FW+rNX+wB1JLPAFRhWToWRBernq3xVM1BEcNoeXdQu7pFQHmqFw1HSUlEZNIrXM8k3L7ebGoPIItjkoH0nBe4pKPoimzVTJoB3s8yfi/5tS3rPU0GE0sKV2jrtHb2TZE6eMqsFpkOfPJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a4fpncla; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D76CC4CEE3;
	Thu, 12 Jun 2025 01:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749692898;
	bh=YIM5rjA0nqx+LZ4XlvstnUSBCVZR05FXT4rNVTEZQxk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a4fpnclaANpqpXGrmLcI/n+ZIveELb+FLe/ZOCGYsk5CKZ33f0dskjrnJEkrHG2kg
	 thQRYhDofqy84bMd5P/cKKcwxpWXDvYFpGOmEHNMje9NqRybxJCe/xqEXL3sfAUqn0
	 R/9w2e46KP9H0rlNcKoBna/0fAgi9PGRgSZCPzco=
Date: Wed, 11 Jun 2025 18:48:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: corbet@lwn.net, colyli@kernel.org, kent.overstreet@linux.dev,
 robertpang@google.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-bcache@vger.kernel.org,
 jserv@ccns.ncku.edu.tw, stable@vger.kernel.org
Subject: Re: [PATCH 0/8] Fix bcache regression with equality-aware heap APIs
Message-Id: <20250611184817.bf9fee25d6947a9bcf60b6f9@linux-foundation.org>
In-Reply-To: <20250610215516.1513296-1-visitorckw@gmail.com>
References: <20250610215516.1513296-1-visitorckw@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Jun 2025 05:55:08 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> This patch series introduces equality-aware variants of the min heap
> API that use a top-down heapify strategy to improve performance when
> many elements are equal under the comparison function. It also updates
> the documentation accordingly and modifies bcache to use the new APIs
> to fix a performance regression caused by the switch to the generic min
> heap library.
> 
> In particular, invalidate_buckets_lru() in bcache suffered from
> increased comparison overhead due to the bottom-up strategy introduced
> in commit 866898efbb25 ("bcache: remove heap-related macros and switch
> to generic min_heap"). The regression is addressed by switching to the
> equality-aware variants and using the inline versions to avoid function
> call overhead in this hot path.
> 
> Cc: stable@vger.kernel.org

To justify a -stable backport this performance regression would need to
have a pretty significant impact upon real-world userspace.  Especially
as the patchset is large.

Unfortunately the changelog provides no indication of the magnitude of
the userspace impact.   Please tell us this, in detail.

Also, if we are to address this regression in -stable kernels then
reverting 866898efbb25 is an obvious way - it is far far safer.  So
please also tell us why the proposed patchset is a better way for us to
go.

(Also, each patch should have a fixes:866898efbb25 to help direct the
backporting efforts)


I'll add the patches to mm.git to get you some testing but from what
I'm presently seeing the -stable backporting would be unwise.

