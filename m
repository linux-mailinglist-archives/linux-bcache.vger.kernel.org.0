Return-Path: <linux-bcache+bounces-1128-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA6F9AD8307
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Jun 2025 08:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8DFD17F366
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Jun 2025 06:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19F31DE3D9;
	Fri, 13 Jun 2025 06:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvvPzwJo"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D516259CB0;
	Fri, 13 Jun 2025 06:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749795363; cv=none; b=MYcZAD69TRPBU9afj9del1ZXiS6wAg8JeInmwWuDo0ZZt61jvdaCXhFDtVIBRWCizQAkcJYpoZdAQjWzZveyaXWekcH5YmsD4EzvGJUzRsqsJhbwic5YWxG6L+YFhLC1YHzGoMi5Ya/Wf/tRd9Cdm8f9KIXjHHCyH2wm8f28QG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749795363; c=relaxed/simple;
	bh=A7x6HR3awkaHrJYvKTix22WAo9uMjCW12r2Ub/QMie0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XH32D6a+OG6ipmvMgAWJ0WbsMB2ErHZLtyVapJHUmcs0/whs7XwmF/bEGnMs/T6WmlTU1XmbqXjnsvvES9lnnXyqyYsoB0lrqsD8j5bA59zI3unNmuIAGUJzzi5nHRoJvWuEZoh2FtN5VkkbXGk6K66hvdVIADj4h6OMIHSikvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvvPzwJo; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-235e1d4cba0so17251465ad.2;
        Thu, 12 Jun 2025 23:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749795361; x=1750400161; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pRiko2rbLjsvU6r51stSZP3eWjmH5GuALjIO6S1USnA=;
        b=GvvPzwJo1j/FK2dP//u7fMDmLolHcScZmo5IKeoP3b8kXWjB6WNLstt6Pqw+tUHa2p
         A69GNMuk773+CaVanhASMjYk6ie6F9DdjFnaOVLrf+Q8FTqwU/1AJZYS745H3LeqQchj
         3BLsIv6kvfXp9w95D60JqRTxDmMPFzwRZWgPHHgQKAneghhxtH4QNmukcMQ5Oso0RhGt
         zvfo5ipbHifpzSKzuoMPVj+bIo/HMUWgz1Hhvn5sVntIoATvVIimAQMlMWjvjXv58hu+
         /NULy3koqNayZUO/p2PuTpmQiMyQdRztotR92vGSW70lmVuMs7jG4jq6ftl+t8j/kK/R
         0PXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749795361; x=1750400161;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRiko2rbLjsvU6r51stSZP3eWjmH5GuALjIO6S1USnA=;
        b=pKy0CDPCOM5broerakXTF7jY4OVuYFqUn/VkSga1Y6EjqqUaMAElZBW8gF2vPK9HPf
         +wn+3uj/8y0gdgioM3kUzRHEVvZZk3YqKLJ2VNPLQcdZl7+yDK6M49PrVXf2sE+erSAp
         k6M4iHHegn0ZVFoIq4GwIWICSYR2uD81W64e0jmJyrMFW7vZBV1gexPBaaU6pl1PtADs
         8brvuOlmCdz5y50KeWvuUcVfD7WjL/gNEybCAC8DSuBe1AwaVgCD5iaiVXaktk3+0QIU
         VMQFb3g3S4HZB89ZCP9cnybNhjb0RL0J/YKVY6TwJZnGNIjzXByMlYCz0bwPa1eUk1Oa
         diiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKpR/B963YKuoB38GR3zN3xXDGur0Z7HYEZBRb7gKUnJMRNx8E22FptDcUac7w+MiAQG64R5HOGBKpze2i@vger.kernel.org, AJvYcCVJE36tVz++VPSf3K2puwne/rLlPopm2uX5pPf1UsN1Lg9660FjfD9tCdyU4iv9E5nwM54uNDgNttMrXTM=@vger.kernel.org, AJvYcCWDJaQkhqFLAy1agEd+2QcJGTLOUkG+7v39f8AALDK9vDDt/B/bwSIB4cZ0cRT3RU3XFovB0Ga5@vger.kernel.org, AJvYcCXDzA4BSC4oSPFEdDrX29cttN9nwIUbC2dCihYMSphHDgTwR4dsxA687l5xXFaxArFZmKCLCXSqoO7p@vger.kernel.org
X-Gm-Message-State: AOJu0YyAsEt5JUhHTa2XwKSTwcNipXdEnQ1ajI0utp4HVhv8QQMbp5lH
	i6Vwyty8jJ2E8+7M80q/3TsxsWT0e4uxvOUT3p2K9F/OLBrmOCZZXQnV
X-Gm-Gg: ASbGncucPNKVzAlXr9FScT80rqE1CghJhGWk6tQHbgfYhWbrzCIFv5fZWyJ8x1xdk6l
	+a9IASVOxXfN2V94UW59PR8OdQQi9QQwuTi0lD12+If+3TFY5HJxz/HUWt5SyvJyFdkyoJV+Ai8
	4DUd2bngspu2LEvy8PWYp/aSwgJ5NZd+n9vPmYgFc3gy6rjSgvDNOLg59Y7Tzm6J0cMlhK3gLmr
	JOLKbREK72O+bRiUpLDpCIW6GVRGvgIOf7vZiN2kpHUg4tTaVO0ziupkO25y5FdOSQIc0kvZRS8
	6kqvtZ3JahTH75T10r2pzIKvxAUm4ObJDIVIDUlkhPbbcA3TQr+vzX1a1nZt0VZWgX2NOxGyTCA
	O2qF6DwPHRcludA==
X-Google-Smtp-Source: AGHT+IHdwA1GAXrHqr0CaqLrmS9BTcaxxJ7z/qilRWCbaHa1XZCD4YPJOT+hjfbsOrWmhi7GlgjXpA==
X-Received: by 2002:a17:902:d4c9:b0:234:ed31:fc96 with SMTP id d9443c01a7336-2365da0744bmr28458085ad.26.1749795361245;
        Thu, 12 Jun 2025 23:16:01 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365dea8ff7sm7094245ad.171.2025.06.12.23.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 23:16:00 -0700 (PDT)
Date: Fri, 13 Jun 2025 14:15:57 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: corbet@lwn.net, colyli@kernel.org, kent.overstreet@linux.dev,
	robertpang@google.com, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-bcache@vger.kernel.org,
	jserv@ccns.ncku.edu.tw, stable@vger.kernel.org
Subject: Re: [PATCH 0/8] Fix bcache regression with equality-aware heap APIs
Message-ID: <aEvCHUcNOe1YPv37@visitorckw-System-Product-Name>
References: <20250610215516.1513296-1-visitorckw@gmail.com>
 <20250611184817.bf9fee25d6947a9bcf60b6f9@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611184817.bf9fee25d6947a9bcf60b6f9@linux-foundation.org>

Hi Andrew,

On Wed, Jun 11, 2025 at 06:48:17PM -0700, Andrew Morton wrote:
> On Wed, 11 Jun 2025 05:55:08 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> 
> > This patch series introduces equality-aware variants of the min heap
> > API that use a top-down heapify strategy to improve performance when
> > many elements are equal under the comparison function. It also updates
> > the documentation accordingly and modifies bcache to use the new APIs
> > to fix a performance regression caused by the switch to the generic min
> > heap library.
> > 
> > In particular, invalidate_buckets_lru() in bcache suffered from
> > increased comparison overhead due to the bottom-up strategy introduced
> > in commit 866898efbb25 ("bcache: remove heap-related macros and switch
> > to generic min_heap"). The regression is addressed by switching to the
> > equality-aware variants and using the inline versions to avoid function
> > call overhead in this hot path.
> > 
> > Cc: stable@vger.kernel.org
> 
> To justify a -stable backport this performance regression would need to
> have a pretty significant impact upon real-world userspace.  Especially
> as the patchset is large.
> 
> Unfortunately the changelog provides no indication of the magnitude of
> the userspace impact.   Please tell us this, in detail.
> 
I'll work with Robert to provide a more detailed explanation of the
real-world impact on userspace.

> Also, if we are to address this regression in -stable kernels then
> reverting 866898efbb25 is an obvious way - it is far far safer.  So
> please also tell us why the proposed patchset is a better way for us to
> go.
> 
I agree that reverting 866898efbb25 is a much safer and smaller change
for backporting. In fact, I previously raised the discussion of whether
we should revert the commit or instead introduce an equality-aware API
and use it. The bcache maintainer preferred the latter, and I also
believe that it is a more forward-looking approach. Given that bcache
has run into this issue, it's likely that other users with similar use
cases may encounter it as well. We wouldn't want those users to
continue relying on the current default heapify behavior. So, although
reverting may be more suitable for stable in isolation, adding an
equality-aware API could better serve a broader set of use cases going
forward.

> (Also, each patch should have a fixes:866898efbb25 to help direct the
> backporting efforts)
> 
Ack. Will do.

> 
> I'll add the patches to mm.git to get you some testing but from what
> I'm presently seeing the -stable backporting would be unwise.

Thanks!

Regards,
Kuan-Wei

