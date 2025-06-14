Return-Path: <linux-bcache+bounces-1134-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA4EAAD9977
	for <lists+linux-bcache@lfdr.de>; Sat, 14 Jun 2025 03:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 702AD4A079D
	for <lists+linux-bcache@lfdr.de>; Sat, 14 Jun 2025 01:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBED10A1E;
	Sat, 14 Jun 2025 01:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o4wUnS8G"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECC62E11CF;
	Sat, 14 Jun 2025 01:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749864688; cv=none; b=MoTjOqfwEyzo4YJDH/UuNC3xf15RJGwtwWlajqoBXa2owr34idu1eQGQV/mxAMJJ4qN/ktv9otVErNwK3KO2fOodXk6PoNuJtap5Ipe9Jcb4U43wHgnRc9dpbDN6y/GL0SQfSXMyHCB9okeFexgRNIVc7mPsryrpVZLo5q62ReY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749864688; c=relaxed/simple;
	bh=D0at5//Awrh06HYuevfzb4zRyl2X0q3tzcu+Lc0TD4A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=mpXWoMP3xV15n76sx2+baFVBWY1jfQ2ZBFpUOS8TIR1wEd7NayKCgy1omAOdfcaGSW+yMfWXugqvC7tZjYJhTyTOYDB2acrRmUUEPUEsQ4DnE0JZ6mb8HVuAb9rt/ikAGoskXVbIFrjXSYzXw6M5Uh51ZOWpygADlKjjoDg8fHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o4wUnS8G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A24C4CEE3;
	Sat, 14 Jun 2025 01:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749864687;
	bh=D0at5//Awrh06HYuevfzb4zRyl2X0q3tzcu+Lc0TD4A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=o4wUnS8G3zUU2+8wmH8J2wfk9no5dUui43QE5ExzG8iXlMm/IzTo2mDiafSjMZdGQ
	 H4tQW9iWokIuNVc0GXuM7a1xQJhjBHdtrSgPzMBIwVd/IXmpmh22CTyLtFlnenfWm8
	 v/NBXMA96kTlcx8s4UPLo3a2QnP0F7IEMn374JIE=
Date: Fri, 13 Jun 2025 18:31:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Robert Pang <robertpang@google.com>, corbet@lwn.net, colyli@kernel.org,
 kent.overstreet@linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-bcache@vger.kernel.org,
 jserv@ccns.ncku.edu.tw, stable@vger.kernel.org
Subject: Re: [PATCH 0/8] Fix bcache regression with equality-aware heap APIs
Message-Id: <20250613183126.9bd25d84b912f18c249bb010@linux-foundation.org>
In-Reply-To: <aEyyF9SsTGguEBGd@visitorckw-System-Product-Name>
References: <20250610215516.1513296-1-visitorckw@gmail.com>
	<20250611184817.bf9fee25d6947a9bcf60b6f9@linux-foundation.org>
	<aEvCHUcNOe1YPv37@visitorckw-System-Product-Name>
	<CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com>
	<20250613110415.b898c62c7c09ff6e8b0149e9@linux-foundation.org>
	<aEyyF9SsTGguEBGd@visitorckw-System-Product-Name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sat, 14 Jun 2025 07:19:51 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> Sure, I'll prepare a revert patch to address the issue and plan to
> submit it for backporting to -stable.
> 
> However, I'd like to confirm whether the following patch series
> structure would be appropriate:
> 
> - Patch 1: Revert 866898efbb25 and CC it to stable
> - Patch 2–8: Introduce the new equality-aware heap API
> - Patch 9: Revert Patch 1 and switch bcache to use the new API
> 
> In this case, we would only backport Patch 1 to stable.
> 
> Alternatively, would you prefer we simply revert 866898efbb25 without
> introducing and using the new API in the same series?

Yes, just the revert for now, please.  Let's not make that dependent on
new development.

