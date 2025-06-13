Return-Path: <linux-bcache+bounces-1133-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 408C8AD9898
	for <lists+linux-bcache@lfdr.de>; Sat, 14 Jun 2025 01:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F8F57B0BBA
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Jun 2025 23:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A5928ECC9;
	Fri, 13 Jun 2025 23:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ip4hUmyL"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA07F28EA76;
	Fri, 13 Jun 2025 23:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749856798; cv=none; b=TB0qbojmcmgdM7nNIkrNuNJd543kSgH4Evlozd+4WmE2Jw7dkmmlnIgFeVrnoyHVC75UpCqmKrzIxnBm34Ve2rVMwrgUKoTZ9KYGrQrLwgiWn/rj5+4lZsiCz5OHR8q0+Doe8s4oKDJwmJMcTNYKfRDPxMUqAZKRbHMU78d9H+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749856798; c=relaxed/simple;
	bh=bcZuyPoS5TY+Y74is6sExuoGp8BF7wkEybtx4YILCd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gdoGZ9PFZvtkBeXuKZbxjSvnVorlArj2SuqdCivaRJG3CT73ZugK36CicjaUzRGnVpr7ahZPzqtHhVqa7Ddl2Z9YCiMNARklWQjUBQ9mFWAxaBTCh9QKwNF5yNoecpl3IpOXSIttO8/vtgkbdd5Rt9HvE8P7AwGy7vLjGVRrL9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ip4hUmyL; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b3182c6d03bso431405a12.0;
        Fri, 13 Jun 2025 16:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749856796; x=1750461596; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GGkSjekPp20C8RFg/1qiK22k8lYciBn5l4gWbgxyXx8=;
        b=Ip4hUmyLqH1tU1Sk5oQkmxureT99KORcEvKyYoMUfbpvUcPlmi3/OyeET4mrtEMSry
         q3nQWiIMxxtX/LqnpSlBhl9D6CLIRlyMkOlskxvcSb4zBHOjloFWNU5wBARFB6pW+zxd
         OF39xmOekQ1unQu9JVAvNDBYZ3uSuCedkbSfS2ArHJ+1D4aZKl8QiARpEyXIa1BVVRbr
         /aQ0HnPVVDjQz42h75yNAfJQWxVbsyuJN4+Mt/860evnIAHt2BBxXthkjHLCINvGpv5a
         P/vAftA2tTPT1DFki1e+TfX6FpQFwH4TEvTeGWIATIYU3G2wHAjKm/0/q7hUWVJ1eqVB
         uBXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749856796; x=1750461596;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GGkSjekPp20C8RFg/1qiK22k8lYciBn5l4gWbgxyXx8=;
        b=TT0w0qLNITWar2p3Mz135dYlZbDxcvW7ty61f12D7grpuKtK/gDQWqqyk/V5lf0vfF
         09HAg6JkMHFFdau88LCCzkqNtULedxIh4d8DbjnD9+yG9ZmHkADN1HzmYv91YBE+UkjT
         gj9Az9Sh7Q6zQNQitNWE4WTDE5kBPfZ7o3A2TSRCQ9Hs8uICx0KyADY6bl4A8t3PU7jJ
         xf8bVLBuE4SscCE9Qq1bIBaDNy6yBpz7bru6ypFmYVsYkyqpuORSLsIgwK+Cz6Kg/3v4
         fKB2YAWIicWdsMrh0aw32IuvZXyBkaVx9/W4K065q8bV9MRA91PbOk+PkC7G7r2xpTtF
         r4uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHihxqsk4I3R/y1AhIpLCBXUBM8ryqTqBd1IVmFsnZnbSSrIRKn3ckgOH8snn9kqg0UZ/L1PrZ/Qi4GIso@vger.kernel.org, AJvYcCVguWvXHL6TsnoKkRdIgAJeS1XBFN8y9+NUWm7E4fORIh4PAUuz1Xfhe2UJfhnOq387TA22NAjqllVPevM=@vger.kernel.org, AJvYcCWe3S8kvfDwlFvwSvHiX+9FRwttJuuwA2f6Fz1fkTBSe/dVnjRweO9UyFCHZWXhnYkut36p56fr@vger.kernel.org, AJvYcCX3fqWvCgOooEZuodikr75r7WvMfiO/dbI2M8ypfnXbmM4ycUgclwhaBHaEa0ltGjohYycE5CWIO4IE@vger.kernel.org
X-Gm-Message-State: AOJu0YznFuRRl+IIqMNFl6vpo4ZTkG2L3qQoSCfIDasM8ixjDasnd9o/
	0LDC+lX5dhfUW3XIzgrq1RGLGgjM/audrfSb67raD/q6nb9jSSyLsZq7
X-Gm-Gg: ASbGncvBEc9mG1ibb7h+FGwhjskgIXDn92ts+IBbwlLzgJ+mxpzJM4uHUOJbpOGB+iK
	/1gR/IAofaWAlj8RQYOPfDWF3R+zndBHbngeDeaGy0usmKZkacINOfMlAAjRluTpbWZ9vbq5/aX
	caMmaYlBOlzyFNihD1sGsMyqRVg5M9xn7GaF1uw0JMRzqLLzKbjUjdICqrFfR9Nh5YokV7rg6EK
	JBkwWv13E1N4JGXQ0BbEWXkV4g16qe4oal6ffhBDviJx0+sakRW/DE96/1H0k0JXfGoC9wlEj+Y
	KduZU+Pgu8qWAcdoyB6ZJIAycsi3GwZ4RsO7C5512IobTT8DjbeV48bqxYvx4y05GqgAcBenrqp
	r2jGppIcwufKxIA==
X-Google-Smtp-Source: AGHT+IGRDA8rtHbr3BM4Iaal2yZGRiefv2wcGquxzfNqyO3WqlQTLD6NDZr/rAtztCW1hjT2NcSB6A==
X-Received: by 2002:a05:6a20:729f:b0:21a:3d97:e93a with SMTP id adf61e73a8af0-21fbd5d9253mr1546691637.42.1749856795963;
        Fri, 13 Jun 2025 16:19:55 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe1639fe0sm2354429a12.14.2025.06.13.16.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 16:19:55 -0700 (PDT)
Date: Sat, 14 Jun 2025 07:19:51 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Pang <robertpang@google.com>, corbet@lwn.net, colyli@kernel.org,
	kent.overstreet@linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-bcache@vger.kernel.org,
	jserv@ccns.ncku.edu.tw, stable@vger.kernel.org
Subject: Re: [PATCH 0/8] Fix bcache regression with equality-aware heap APIs
Message-ID: <aEyyF9SsTGguEBGd@visitorckw-System-Product-Name>
References: <20250610215516.1513296-1-visitorckw@gmail.com>
 <20250611184817.bf9fee25d6947a9bcf60b6f9@linux-foundation.org>
 <aEvCHUcNOe1YPv37@visitorckw-System-Product-Name>
 <CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com>
 <20250613110415.b898c62c7c09ff6e8b0149e9@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250613110415.b898c62c7c09ff6e8b0149e9@linux-foundation.org>

Hi Andrew,

On Fri, Jun 13, 2025 at 11:04:15AM -0700, Andrew Morton wrote:
> On Fri, 13 Jun 2025 23:26:33 +0900 Robert Pang <robertpang@google.com> wrote:
> 
> > Hi Andrew
> > 
> > Bcache is designed to boost the I/O performance of slower storage
> > (HDDs, network-attached storage) by leveraging fast SSDs as a block
> > cache. This functionality is critical in significantly reducing I/O
> > latency. Therefore, any notable increase in bcache's latency severely
> > diminishes its value. For instance, our tests show a P100 (max)
> > latency spike from 600 ms to 2.4 seconds every 5 minutes due to this
> > regression. In real-world environments, this  increase will cause
> > frequent timeouts and stalls in end-user applications that rely on
> > bcache's latency improvements, highlighting the urgent need to address
> > this issue.
> 
> Great, thanks.  Let's please incorporate this into the v2 changelogging.
> 
> > > > Also, if we are to address this regression in -stable kernels then
> > > > reverting 866898efbb25 is an obvious way - it is far far safer.  So
> > > > please also tell us why the proposed patchset is a better way for us to
> > > > go.
> > > >
> > > I agree that reverting 866898efbb25 is a much safer and smaller change
> > > for backporting. In fact, I previously raised the discussion of whether
> > > we should revert the commit or instead introduce an equality-aware API
> > > and use it. The bcache maintainer preferred the latter, and I also
> > > believe that it is a more forward-looking approach. Given that bcache
> > > has run into this issue, it's likely that other users with similar use
> > > cases may encounter it as well. We wouldn't want those users to
> > > continue relying on the current default heapify behavior. So, although
> > > reverting may be more suitable for stable in isolation, adding an
> > > equality-aware API could better serve a broader set of use cases going
> > > forward.
> 
> "much safer and smaller" is very desirable for backporting, please. 
> After all, 866898efbb25 didn't really fix anything and reverting that
> takes us back to a known-to-work implementation.
> 
> I of course have no problem making the changes in this patchset for
> "going forward"!
> 
> So if agreeable, please prepare a patch which reverts 866898efbb25. 
> Robert's words above are a great basis for that patch's description.
> 
Sure, I'll prepare a revert patch to address the issue and plan to
submit it for backporting to -stable.

However, I'd like to confirm whether the following patch series
structure would be appropriate:

- Patch 1: Revert 866898efbb25 and CC it to stable
- Patch 2–8: Introduce the new equality-aware heap API
- Patch 9: Revert Patch 1 and switch bcache to use the new API

In this case, we would only backport Patch 1 to stable.

Alternatively, would you prefer we simply revert 866898efbb25 without
introducing and using the new API in the same series?

Regards,
Kuan-Wei

