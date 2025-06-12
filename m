Return-Path: <linux-bcache+bounces-1126-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF8F3AD6546
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Jun 2025 03:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEFE9189F7B5
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Jun 2025 01:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A095F18132A;
	Thu, 12 Jun 2025 01:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vUgQYu+p"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A282A1C9;
	Thu, 12 Jun 2025 01:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693266; cv=none; b=sk0e7qeBOxu4f7HF4CtVtUbbY0Im02HiVMhZOxEC7E432DiDa03c54NL2s9VumUYTnUtNkRxR5iwEKpBP2mNW2Mv+KNnyltI85jWhXxkxXblgdBmONRH204bxhq1i2jwcKyhdmC2leI+Lxylhqmn2Xq/TYHSFclHU3PwY2hInlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693266; c=relaxed/simple;
	bh=eMDfTk/BBqYcq/CPfA/Bjkk2xIKYHif8ciTCELud91g=;
	h=Date:From:To:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Uk4CUTPzulctpOutCTDl2rlbR/TCiTfPQ6OsNgHa+XlEg3ef52f3ADGGszeWkzJ5FdW+hG1evfN3DcYMQcNkuWdqIOrd6rngIuhfSDQwLbTtFAyP4B7hfn8Ys5k9GEWWjybzljtBT8ckKUJqTufdDCNNCm6seGkVe9u+iJQb0DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vUgQYu+p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165D4C4CEE3;
	Thu, 12 Jun 2025 01:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749693265;
	bh=eMDfTk/BBqYcq/CPfA/Bjkk2xIKYHif8ciTCELud91g=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=vUgQYu+p69fTs1R9l5r3U3jL6CjvORXv7iAGZbWgBviMc7lewUaS/XdnldptbWOwu
	 gJTFy4ogvTcWrxBzdrvWckAd2GJLErY7Onr3eQl0xwoAPITHl1c2DZ5A5ESRwFR129
	 XS+Y40t0IdDILfp1/evcUFHiavCafFVHQ8trAmlo=
Date: Wed, 11 Jun 2025 18:54:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>, corbet@lwn.net, colyli@kernel.org,
 kent.overstreet@linux.dev, robertpang@google.com,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-bcache@vger.kernel.org, jserv@ccns.ncku.edu.tw,
 stable@vger.kernel.org
Subject: Re: [PATCH 0/8] Fix bcache regression with equality-aware heap APIs
Message-Id: <20250611185424.79f3cf82da78c2b271629657@linux-foundation.org>
In-Reply-To: <20250611184817.bf9fee25d6947a9bcf60b6f9@linux-foundation.org>
References: <20250610215516.1513296-1-visitorckw@gmail.com>
	<20250611184817.bf9fee25d6947a9bcf60b6f9@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Jun 2025 18:48:17 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Unfortunately the changelog provides no indication of the magnitude of
> the userspace impact.   Please tell us this, in detail.

OK I found details in the 8th patch's Closes: link.  That was tricky ;)

It's impressively detailed but I'm still struggling to understand how
much pain this regression causes users in real life.  So some sort of
reader-friendly executive summary would be great, please.

