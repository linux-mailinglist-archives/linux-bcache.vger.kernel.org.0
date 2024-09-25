Return-Path: <linux-bcache+bounces-738-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ACA1985606
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Sep 2024 11:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 372901F246E0
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Sep 2024 09:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 465301591FC;
	Wed, 25 Sep 2024 09:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HzZIdLDM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7966F156661
	for <linux-bcache@vger.kernel.org>; Wed, 25 Sep 2024 09:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727255130; cv=none; b=f+9Cl3G1B8mEAqCuHk+0PhPjVz2v2qlCQ+whOptvWA0dtq9hSSU8w2qmRmuPqAmJFY9PWPdYH59rFoThr8r9xR3UkHmUH4fQbUMF6jI0Q74Bf8LAaEU4AKN18q63BjPzRNii6ac+L0PVeb35f699vZV1IoljdtUW4CvEwqgqxTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727255130; c=relaxed/simple;
	bh=+cONzHrk7zpOTzu5yxEITF6cqEnqFLEKXmn44uaJRp4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mw9YRQFsw+EVSVrlmUGBYr9cp/OyMLWOBez9N7Nx22HDR+E+PekMKSqp7kfc4bgCHcD7bWDH3QUccBd8KtXELgYTB+EPvLmlScFaD/Q8w1jbCbkKVRK8LhRa3iuV5PAHjHGYTIsDpq8QAqwbn0ujN/3s41BugLTEnoQwul8cI6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HzZIdLDM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727255127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CsaacKXy3sl3N6SSRdjs/BVpOGZEc2AswllD9kisABA=;
	b=HzZIdLDMueLmyQia5UVgdKJA/RoRhlJZyG1DBL1r2UBWkzfwab0GBggJXQHCqUFKs3z8OC
	DmAQIv6sOVovfnO2bOXYejQZqC5WgB/8ItLGLjAetHNVjwKuC6tUk/LeWxDTQ4CQeKLXiq
	Fs56/6pM8ECWrhGBOgymviC2vUKqUMM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-CW2EtpPNNhqVDtPiLXNdxA-1; Wed,
 25 Sep 2024 05:05:26 -0400
X-MC-Unique: CW2EtpPNNhqVDtPiLXNdxA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E0EE1955F3D;
	Wed, 25 Sep 2024 09:05:24 +0000 (UTC)
Received: from [10.45.226.79] (unknown [10.45.226.79])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB367195608A;
	Wed, 25 Sep 2024 09:05:19 +0000 (UTC)
Date: Wed, 25 Sep 2024 11:05:15 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Song Liu <song@kernel.org>
cc: Shen Lichuan <shenlichuan@vivo.com>, colyli@suse.de, 
    kent.overstreet@linux.dev, agk@redhat.com, snitzer@kernel.org, 
    yukuai3@huawei.com, linux-bcache@vger.kernel.org, 
    linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
    linux-raid@vger.kernel.org
Subject: Re: [PATCH v1] md: Correct typos in multiple comments across various
 files
In-Reply-To: <CAPhsuW51S=WfyNoP_cWvNVq3rPW0+iBrhzRVaKK=q3PLRA94UA@mail.gmail.com>
Message-ID: <d3bfe143-1b96-c28b-8ef1-f7d86c8e5b54@redhat.com>
References: <20240924091733.8370-1-shenlichuan@vivo.com> <d95d7419-7bac-802f-a5d6-456900539c32@redhat.com> <CAPhsuW51S=WfyNoP_cWvNVq3rPW0+iBrhzRVaKK=q3PLRA94UA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-289647186-1727255124=:2979785"
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-289647186-1727255124=:2979785
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Tue, 24 Sep 2024, Song Liu wrote:

> Hi Mikulas,
> 
> On Tue, Sep 24, 2024 at 6:30 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > Hi
> >
> > I've applied the device mapper part of the patch.
> 
> Would you mind taking the whole patch instead? You can add
> 
> Acked-by: Song Liu <song@kernel.org>
> 
> Thanks,
> Song

I'm not a maintainer of MD and BCACHE. The MD and BCACHE part of the patch 
should go through their tree.

Mikulas
---1463811712-289647186-1727255124=:2979785--


