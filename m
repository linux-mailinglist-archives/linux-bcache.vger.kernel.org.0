Return-Path: <linux-bcache+bounces-778-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D099B23FD
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Oct 2024 06:05:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BBFB1C21046
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Oct 2024 05:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9512518C34D;
	Mon, 28 Oct 2024 05:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XC9uW5+X"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6F918A922;
	Mon, 28 Oct 2024 05:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730091896; cv=none; b=OnEcsHOQYSii8QeU4g9Vt6ni4M/pdIcPs3VBTZYfOOiafp5rj+1wh2QJbea7tHnBAmd2HOdP6OXG7ExnCIa+X7qlvO2Xzx8HOh/MNpIya7g1AL7HJXI0GJqy08GGzkuulECp4t1bLX5DbrFNDJVk48RxxgxyuSuZMvGaZ2MteMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730091896; c=relaxed/simple;
	bh=KuSSNhqQmzngUtpZ6jNSAOFuo/FQ56fjZ1xFMr/wqYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rvZUov9ghAXFLkoZMz4FVeTL6kns0ySv5viwZ0YxR50KXTr16352Mjg3S13T78rInTAVIaFn5l4sjXmEVkzlW9JV7x6G/f2Bu3yF3Xgl466TLgAZVIJ4SoKN33qtQpBpRO9PIvxjpLMI9owNnm0WtEgQL6C6HKFN5QzqI2L1OEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XC9uW5+X; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20c7ee8fe6bso31680155ad.2;
        Sun, 27 Oct 2024 22:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730091894; x=1730696694; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KuSSNhqQmzngUtpZ6jNSAOFuo/FQ56fjZ1xFMr/wqYI=;
        b=XC9uW5+XczWtbwH8VkSC4XYfJFtYoctLkL+RHQawyW2AtS7fRDB+2b29RydMoewZhv
         HdZQnMJfxBZk6uBbc0MBGs8syquc/daT9eItGIU+OmfuLPneB/9sB5bQL2cEtrhXik2j
         FIWiJZHOuxjxcYZjTrqSODOakZPRHyK95PEZpYnZYl8CR24SjCr+RTGTcNth+YSFzqv8
         nXeU1JJAga4ReahdcLigpd8zcw6lY+OZgcR0uMrA6Vfl6oycXvI1M0jTvqYYjALhMJ26
         NB5GiovNNoM5v0oc4IKCPR+NJDs1JCYPeIcW3Sk4zkgMML2lKf7k4XXl/dblO+pqg85g
         pv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730091894; x=1730696694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KuSSNhqQmzngUtpZ6jNSAOFuo/FQ56fjZ1xFMr/wqYI=;
        b=vGJJMPj7gyuPNdXzSN0dDbzBh9/I15qobw3ihh1p5IsaKr5JstHJWwUQpGwFvqUOYZ
         Oqz0E8iv0sqcGphjLbzq+Ub7bzma+Jtfh1PFOpyO6Q/GDEaC/4dh22YQN6kaiCMCRziL
         /CcKIQ3yfEB847r/jGLVFLc6n/PZRdQr4vFDfl+d//nbefxvrK7pU1HPJ8wvoIoE+cHd
         EQWF4II6ZvlW97Zj55bpKhHswas1lUy6yffTCvn6c6yMDYeX/MvuCivYQlbr1EZE3EGQ
         fFDF8PAB2RKVM6Qw2w4ig/lhmKZaGqnBeSQ+T7X048t0GDbGLxQcScYAFeI2YWPICuCi
         CgMg==
X-Forwarded-Encrypted: i=1; AJvYcCUJO1j2StY18lqaR1iMZnlmalRD3LkgBzqrxpGYi+B41lE8fgt+jHYWjItzkMLBuytsMhATZvAXcq/jzkk=@vger.kernel.org, AJvYcCW1NeXoHrtLzJaYgpZ2uu35bfLoW1W1imk1kDYKfUNwX/tBOu59yzrWql9i2cVwfPIcsVZxjtMLLZm44N5QvlzfAg==@vger.kernel.org, AJvYcCWa0dVTCpQoR/BuaXatsEFbBvdkchr4opz55GhsZooftf+0NLPNYtYSxTq5bGAI7qmy9AD6DF8qRHoQJVqd@vger.kernel.org, AJvYcCWuBFWTGZFbL5WPyBitsrqiNtGb5EB8Tu0f5JvDN+ePiTlNB1HI3CPtcRKzVp3+AgQktnZFgqQdoC2H@vger.kernel.org, AJvYcCXRDsaycE7DJSUfLnGV2GeCYt0xacJokEvHT2Z4lbCTdd7eod14zrc4bFj54xLwoU5ox5DACpqiGeboBmoOBH4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO/Ekhbm8HQpYsmJ65p/n+6Sz9e6E5IJSWTJzVZADCD+kIO+dU
	Tr34/IQI/QUSG8VsqjazHdjz78RCPdzPIn9/UectwFiH63CMTHF1
X-Google-Smtp-Source: AGHT+IFjK2HF1Z+Lhqb8mZhwem9i4EjiyHfk2esq+mfa/s946c5Oe9L6ORNV02D3IRkDrGQj3ss3Jg==
X-Received: by 2002:a17:903:2286:b0:20c:f648:e3a3 with SMTP id d9443c01a7336-210c6ccf557mr87225585ad.60.1730091893804;
        Sun, 27 Oct 2024 22:04:53 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bc012fd7sm42876435ad.180.2024.10.27.22.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 22:04:52 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 6BFB54433471; Mon, 28 Oct 2024 12:04:50 +0700 (WIB)
Date: Mon, 28 Oct 2024 12:04:50 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, willy@infradead.org,
	jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Enhance min heap API with non-inline functions
 and optimizations
Message-ID: <Zx8bcny4yPuLTxD7@archie.me>
References: <20241020040200.939973-1-visitorckw@gmail.com>
 <ZxYf8VvQIZv9_Y1j@archie.me>
 <ZxZbgWc2IsztAOOx@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Zbhjczx96AMnlB/2"
Content-Disposition: inline
In-Reply-To: <ZxZbgWc2IsztAOOx@visitorckw-System-Product-Name>


--Zbhjczx96AMnlB/2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 09:47:45PM +0800, Kuan-Wei Chiu wrote:
> On Mon, Oct 21, 2024 at 04:33:37PM +0700, Bagas Sanjaya wrote:
> > On Sun, Oct 20, 2024 at 12:01:50PM +0800, Kuan-Wei Chiu wrote:
> > > Add non-inline versions of the min heap API functions in lib/min_heap=
=2Ec
> > > and updates all users outside of kernel/events/core.c to use these
> > > non-inline versions. To mitigate the performance impact of indirect
> > > function calls caused by the non-inline versions of the swap and
> > > compare functions, a builtin swap has been introduced that swaps
> > > elements based on their size. Additionally, it micro-optimizes the
> > > efficiency of the min heap by pre-scaling the counter, following the
> > > same approach as in lib/sort.c. Documentation for the min heap API has
> > > also been added to the core-api section.
> >=20
> > What tree (and commit) this series is based on?
> >=20
> > Confused...
> >=20
> This patchset is based on Linus' tree, commit 715ca9dd687f ("Merge tag
> 'io_uring-6.12-20241019' of git://git.kernel.dk/linux"). Since it
> touches multiple subsystems, I'm not entirely sure which tree I should
> base it on. Should it be linux-next, perhaps?

Nope.

Anyway, series applied for docs review. Thanks!

--=20
An old man doll... just what I always wanted! - Clara

--Zbhjczx96AMnlB/2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZx8bbgAKCRD2uYlJVVFO
o6sgAQDOkl5ght0n7cwDsycgwxL9nCtWIpsch3Hr4knwbp1t6gEAy9bIkKuWrBqb
t32VfpdXUndKdvmFzkg/I0/Jqw1yvAc=
=BNr4
-----END PGP SIGNATURE-----

--Zbhjczx96AMnlB/2--

