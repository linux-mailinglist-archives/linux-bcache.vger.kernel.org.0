Return-Path: <linux-bcache+bounces-779-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD969B2518
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Oct 2024 07:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B02AEB20D42
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Oct 2024 06:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D079D18DF71;
	Mon, 28 Oct 2024 06:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gIAErrbr"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C6018CC12;
	Mon, 28 Oct 2024 06:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730095830; cv=none; b=CBGt9AvTJEOqDZJ+30ouLhXh0/nB5VjVwQTcduyjmdQVVPGuEcCU67VJY6USB3b36jvwfzjYjoCJYzGzoCq1n6FDFYIQSUdDp4N6IaPjzebdkWAqYGxkMbrhgrOM4gqtD/il4n1yuuOzCL7azvL+V8nzRPX2rLXjEDZwSuhALSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730095830; c=relaxed/simple;
	bh=KZQQWIa0NmTXTrvgtfvfI9/FAmsddMyzm4sTOgHcISU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XpgTxoNqrnw0OJLFVePpGEZBX8Jum08lwmgQUHSRlfXguH5DwQT4HfBW2DSGyiX2EpouhKEhJ08Mpgf4jolE13BiwvhLLfyojmMyAOlbkttMoQKJvRitJSAIK+1NudAPFGUsfKzsLCaY3XGbuTNQp+4+owITU+/ONF7W6VAD/6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gIAErrbr; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2e91403950dso158656a91.3;
        Sun, 27 Oct 2024 23:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730095828; x=1730700628; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KZQQWIa0NmTXTrvgtfvfI9/FAmsddMyzm4sTOgHcISU=;
        b=gIAErrbrq/rfW6kpv6cAW1j8ST3mx6kmfQsRWQfhM52jAogG6Tz/b+yZ+yPC8B3cTr
         RQ3SpzZ8wi8JFa+XZMzVUvqkLstrHh3q1776kmIxNxxZPcQvJ8SbKYcyZcbhAvBeyB2g
         XWFWl0gcjSGKfXzyxLJXFyd0ex2jUTliasReIqpOU0NtS4hBxu3Eod8GyiP+8Q2l1Wuc
         YZlaGlCQFqkGO+MqNt+D6NWInQXHvBThgfjZiyOyVyMBiMkkHcOiU6SIFKygGx/Ddrzu
         HEJYgTRDzUfZCAxO+pW93r3h0+qSBTLjS/5QK+RLC2d3wFrANoE6gc2KsYOiZJ782E0u
         YENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730095828; x=1730700628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZQQWIa0NmTXTrvgtfvfI9/FAmsddMyzm4sTOgHcISU=;
        b=AXwrvU4VRjZXJtBO5C/G1fhCMogg9ijeJq2SsvALC0Iizu3TTCO9a/LmEI04terTBr
         mtDxasaEfGSFSsykhdy2mi5wH5fgaBBnwJxAow0LYB7Ty5uercOK+hnvBBkEYFIx7Ezs
         8T3y8UBqxdGkhm92O31JtCaF0rUNJE9WI92RUTwU6IMmcYKc7hweLK2z29OjI6TonTnS
         kzNnmoeSYJTWcFTlmRxMkCaMgkfDN51Nq9SDWRRNCbbtMOfHMzqjlyvRzbMmSAibbn39
         o43G2TSXdqYVsVlSeDpj/RGaDuVhIiEgdzZ5CFvRxBOtjWNtx+cg7TjnvKEN1+J3ATEL
         2AKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfAzg2BckHw1+p4tiPuS/gYEBdtUKu2EIMlY47jD249aVSqU171kD+YmRwxapWPRLj7azi/huOdrbqFMxd@vger.kernel.org, AJvYcCVNzZGu6tnx8lVjRY2kJlS41oA6ZX09hm27tHcohU33ZdO6C1/MWPmLUhV1NvxSSpZsP5cKWlCpX5MeDK8=@vger.kernel.org, AJvYcCVumhveR07IHfEiO+X1tnwh4mVgLrqHOlc/jchYJV1PpPY+ikgC7zNiPPILG+PzURVlQ5bekUDWSxaKzM89Teh8tg==@vger.kernel.org, AJvYcCWeqYxmMZ8WY2ZvoFtnAjPNpRn8vxtYNWtdryCGeBAD+OrVcJclADLE8uIMZvrZ6wy0stW2WY9jkzSe@vger.kernel.org, AJvYcCWiAlvBOc4VhiGG9N32r7WZO4SxvcykHKGbUcusRNRciqmOnIuXMMogB/8Oj6V4qpWHjcm1BmJYBvbOzD36Klo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx+aMrw/W5uvIbg1mkdtS5jF/dv1NvnsCuR9wue06bjUKdLHQH
	3ps+MvgVlTRPri/+sCjcLDgtD1fedhBWYp7sJxBP9xtCfFXoal48
X-Google-Smtp-Source: AGHT+IGY/C3RpGygdeotrpMgURVeqHdXpqhUm2OR3yBXK+vE2HSGrXjWe+261uWQUYpiIK17xtVVKw==
X-Received: by 2002:a17:90a:9a8c:b0:2c9:9658:d704 with SMTP id 98e67ed59e1d1-2e8f11dcf62mr7128993a91.40.1730095828058;
        Sun, 27 Oct 2024 23:10:28 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e8e3572d4esm6331419a91.15.2024.10.27.23.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 23:10:26 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 50A114229D6A; Mon, 28 Oct 2024 13:10:24 +0700 (WIB)
Date: Mon, 28 Oct 2024 13:10:24 +0700
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
Subject: Re: [PATCH v2 10/10] Documentation/core-api: Add min heap API
 introduction
Message-ID: <Zx8q0C6NhVPwqLgG@archie.me>
References: <20241020040200.939973-1-visitorckw@gmail.com>
 <20241020040200.939973-11-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9FVjYyjZ5YvF0M+J"
Content-Disposition: inline
In-Reply-To: <20241020040200.939973-11-visitorckw@gmail.com>


--9FVjYyjZ5YvF0M+J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 20, 2024 at 12:02:00PM +0800, Kuan-Wei Chiu wrote:
> Introduce an overview of the min heap API, detailing its usage and
> functionality. The documentation aims to provide developers with a
> clear understanding of how to implement and utilize min heaps within
> the Linux kernel, enhancing the overall accessibility of this data
> structure.
>=20

The doc LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--9FVjYyjZ5YvF0M+J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZx8qywAKCRD2uYlJVVFO
oxK8AQCkweSLHKQum/kN2ZlFuOSI7PY2IFPhUHf7EgVFWMUZ1QD/fIPIofBxwULy
ZiQmQ7b0Lko4m4TJTzn6NFKQGFQ8tAY=
=8Dk+
-----END PGP SIGNATURE-----

--9FVjYyjZ5YvF0M+J--

