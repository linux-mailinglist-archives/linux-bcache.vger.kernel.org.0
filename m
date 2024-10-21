Return-Path: <linux-bcache+bounces-775-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C8DF9A6026
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Oct 2024 11:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A754A1C20D2A
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Oct 2024 09:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B5B1E284E;
	Mon, 21 Oct 2024 09:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TKqDrK4Z"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C5D1E105F;
	Mon, 21 Oct 2024 09:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729503224; cv=none; b=T6QayznAoQfzHiy5dH+0KjEOwBXQ0mGmYri0KEnxA43IV7Y7jUOgJRLKCywssUYuF9iQX9pfyPlgCO5NPGNOnLOyH5OoF93kjrHpjrL+WBknsUeX/eT4mDS0HrP2lRNULP79wryoadJ6vuWvHXCNKdxWQm0M1AdwfvEcisrK3rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729503224; c=relaxed/simple;
	bh=+hvwglD+xMIZQSpeY8TNOenvPPVT8cBwFOr0rdwiYac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cj7M5FgJq2+243EztZS27PL0xfzgWiFugBmFJwS4CMx15oxAufJ4pr13ISMpKN+uVBniAxmVVUFHC2mQqATKVXy04x6g1axm6vQ6H5WXyGYX/94B3WlugNzPP/b/onYF+sZmT7Q2MI5OhKWtbmb9vQdqCqju1IyPExCoVx4E9gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TKqDrK4Z; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3e6075cba82so802645b6e.0;
        Mon, 21 Oct 2024 02:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729503222; x=1730108022; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+hvwglD+xMIZQSpeY8TNOenvPPVT8cBwFOr0rdwiYac=;
        b=TKqDrK4ZHHexPu241KbOYrz7beOcgqJY2cdu6h/Ttf1Va/pXkux39IazndxGVfs7Qt
         O9AcIX+cKv84C4QtYDcpK0+URkiUF0YaVpNIDcyn2bQYvuidmRL/kHYmmkSw+wpKGfHz
         q/hxu+KActzJBXF8z/i0NfkJB2WCX4pK34pwLzXH2WCcFFWNLVENTMx/5IzRZMY+jBOO
         MWw52sJMAxXlMjEjyejCDxgjKGKCNAigryXKklFMwsFXD9QtMaDw31NHb4jo1UHz9XSD
         sKrDs67iLr5xmQLJAic95QC2+V5zaygc2raUO6B2HcqS5DedryDAHMvGJ2AmhBJl8MAN
         /N9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729503222; x=1730108022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+hvwglD+xMIZQSpeY8TNOenvPPVT8cBwFOr0rdwiYac=;
        b=mUGcbI5t6WD4T40k++DEPwL3o80AtG+36fFFL7dInmJb9+CZF6bwRCPCeip3BWKcW3
         p9evn8attXCWrA44kUPi98OzXeKtmQGJiX/crLGFFzgUf8H3JgULdkLq6DNqE8bvueFG
         VGaS9diRAqwjrdcntdeUf0HpetFrhzDG3/7WTprDp80HjIj0bepB3TxWcFFNSNX88L1o
         2J78bHB3mcMwcFU/xuPuI7NhMozwnXIcgSdJAzDZYIFxneZxqK6tE1tNSFfhaMYyp+ny
         EAfYFF1V6TeRv21thedIU0cajQ8+cRqvgGI9w9DEZvtshlDBWf3sx6NldJUxy0tPMiG1
         0XRg==
X-Forwarded-Encrypted: i=1; AJvYcCUnYraZn/ebn0SgOX200PkN+Kw8/zrkb8I0nmZidmBoyfYxeGZEmxcioZ+NLcWAmL+68+KQcStVgftFNnro@vger.kernel.org, AJvYcCVQ6eAEbsidRpyzxOECMMMAh/kO0eWYHg9I2Rrrk/NUFUIXe/hlm5vvxbjsTq7+4e5yDGdaiqcPVP6q2HfKws8=@vger.kernel.org, AJvYcCWMZup/cxxBZSzBk0Fsri26mj4IYXd+8cPv2tWUaz5EqahP/fryT9V3YCjIJ4hTV6LxnfuiyOMyhWGpN6DTvmYX6A==@vger.kernel.org, AJvYcCXc+ZqwWc8usuKaDoKmaLjxf3BQfwTBt6tnjv3+cOXYGIP+cU4/wKDNxbeTk8OLJca+TUfaHDBrc1kD@vger.kernel.org, AJvYcCXselr8F6nm3S2Hg/1DJOKkgEZFC4atPplgOnitqQG9Ge1zGOXZQKWau/dYVY/dt0mR5K2fMESFFrqar1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtyaA2Ow+eXVvwHB6xxvGokJuk+/JOksFUiee1ztKJU+yi+ozY
	JfGTZcQ8Q4pPNAImRciqBvHbx/8y+MxZ0kWpEm4EAz9rpKWk2Xm0
X-Google-Smtp-Source: AGHT+IHEqtcKiYTdbqqfRyoy/XfAUa5oXZdBUPYTVW5peAzxo1UMbv5yHBrUak4k0TnoMhvzjBSbUQ==
X-Received: by 2002:a05:6808:13c4:b0:3e3:a99a:433f with SMTP id 5614622812f47-3e602c87dc9mr8847801b6e.13.1729503221785;
        Mon, 21 Oct 2024 02:33:41 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeaafd36esm2637774a12.6.2024.10.21.02.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 02:33:40 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 87E574396293; Mon, 21 Oct 2024 16:33:37 +0700 (WIB)
Date: Mon, 21 Oct 2024 16:33:37 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>, colyli@suse.de,
	kent.overstreet@linux.dev, msakai@redhat.com, corbet@lwn.net,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org
Cc: mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, willy@infradead.org,
	jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Enhance min heap API with non-inline functions
 and optimizations
Message-ID: <ZxYf8VvQIZv9_Y1j@archie.me>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AZgPemEmi7boKc4w"
Content-Disposition: inline
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>


--AZgPemEmi7boKc4w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 20, 2024 at 12:01:50PM +0800, Kuan-Wei Chiu wrote:
> Add non-inline versions of the min heap API functions in lib/min_heap.c
> and updates all users outside of kernel/events/core.c to use these
> non-inline versions. To mitigate the performance impact of indirect
> function calls caused by the non-inline versions of the swap and
> compare functions, a builtin swap has been introduced that swaps
> elements based on their size. Additionally, it micro-optimizes the
> efficiency of the min heap by pre-scaling the counter, following the
> same approach as in lib/sort.c. Documentation for the min heap API has
> also been added to the core-api section.

What tree (and commit) this series is based on?

Confused...

--=20
An old man doll... just what I always wanted! - Clara

--AZgPemEmi7boKc4w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZxYf7AAKCRD2uYlJVVFO
oxXdAP9wQqt51VFB/Z0o1sG9jAlrumF8GTPSGUKzrPnp/NQr1wD/SJT0xCbRALqQ
/PjGaG28z15cfomZT4A3WrBSIvSSmgo=
=BKhT
-----END PGP SIGNATURE-----

--AZgPemEmi7boKc4w--

