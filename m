Return-Path: <linux-bcache+bounces-319-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8A38805ED
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 21:13:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C2C71C22CA1
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 20:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E511258100;
	Tue, 19 Mar 2024 20:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gtAnEDUV"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B055FB8F
	for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 20:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710879228; cv=none; b=JRhdMtbnlsEqyyP9LAj2iRTqUbcg8e84OwOS162YrNjFAZVX5P0dPGbUqlMOGu8g2cqvXR65EKhXkQGNl6/XDLXWvXe4Je5D0oKfFC0g13K+dFkhhPLJZ72EVwcWYDQJeTbPpyZYSeg8fd5PxjkZ3soMvM63i3ciThmfJLDm9K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710879228; c=relaxed/simple;
	bh=TEI1l16U8O229iRg+bnRlquzTRC42x/8zMW3wG5XbLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KsadZ4ZMYcaLkn9IWJZIQvacMNi0FrtRTnXMeA52/11Px7XY0FdaC/KrQpUQjckhkpOrd7XBUiXAY3sLVtOm7RG+z30NnrinjNzOHN0WUJ4kUkcSWbyWybUv/Nuyywf39gB6QJphgM0fLJ2UK/aQLCPx5SJ65N3eALDFC9a3PGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gtAnEDUV; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dee917abd5so5795ad.1
        for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 13:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710879225; x=1711484025; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61E5NQ6/YcOhVh/0k2iDBO7WpqpNwA0nbieT/ua9ouc=;
        b=gtAnEDUVnZvHgfuPvOALSV92laz8czMB1cfJmNpfaAI3SDF8yI8PpIvoIB8wspgUSY
         5w0y9kN4RgfF7ReI8e8vf1xrpiVTr17eG083oEne+DYTGEmE3qgXtLu/7Ad3h+kW1gPX
         GaL5y0w+oY/C33fvFIQYF30A396dqMPN2qPiGBAs5sjCkxnV2Y//egkHXxm/fJGBrhdf
         dVx0alJ9xtYq+nY2azq325TtMfdnKGeP6rsk6yUV/UwKP91IqIs2bgxXabJsNoAZbrI4
         hbursat8QPTCctysg1URfQUtJoyMy7Oc3+xw9D8pgDaTrccOhuEab4eNJr7jzdEgQiLA
         Vuqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710879225; x=1711484025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61E5NQ6/YcOhVh/0k2iDBO7WpqpNwA0nbieT/ua9ouc=;
        b=tkdiGT710T30tCAFVveIp4UCH7Jtzne1NNn8HVbdm/FX7UdTHx2RCLX5YrP00uW8Da
         pw70MkuxcKhcFAyjfpySxTFMxgORv3tDjQVW5+nr/GgG9tbV3gaXDmrrcKKO3thRMNQi
         YJkewHxNvC22XHHHnpnjd/cOd0cdCf7+GMnu//MEP4GOBCrUw7dBqDJGnsWMz5qTpmAs
         yebAFQsj7xHRmiK1MCMUoPztN4TWqC8ZNm4l5BYCOwfEdJ0lhPZzKCjjIDTnkAj4kqdp
         hlE+0euTE0c2vImYLyR6O0u1tQ770lzMVkBKFb/RaDElJ/D7W1m5Q4z0cnPNPOTPssB1
         98aQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5ej9fSAuLHFJONrLp8YAhC1hdiKcuMtMmSv6JKphVzVBcRh+ayfntiAPyge4dxYojlzX6U1r9xdsla3+/RRmmfDeYdFdXMH1GZ+sP
X-Gm-Message-State: AOJu0Yypiuzft3dQGvMVMyk+W8V0ClbzIIDQTqqM6vvy3/QymUVjdcG0
	tX5KWJOGMKIzOHZF0G3d2KqUj0Dd6SzzdXaaHspEouPb72esucoagUf84i8jQkp1IZfUkWCTb8o
	hcaFPfQGDY2T8T0zZLZ2PBXzxU7t8KaJzOmpR
X-Google-Smtp-Source: AGHT+IFREg9SwBdMDFnHH3n5tmN6yW8u/tyc7IrpIagXi7ukyBFEM1dN3wdN7uqPHmnG3vaEtYonkph3M4qPe2lMJDA=
X-Received: by 2002:a17:902:f691:b0:1de:f0f0:90aa with SMTP id
 l17-20020a170902f69100b001def0f090aamr68484plg.26.1710879225101; Tue, 19 Mar
 2024 13:13:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-4-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-4-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 13:13:33 -0700
Message-ID: <CAP-5=fUy=m2_f7jKO_kn4+onto5As2fUwrcNBtKEh8uObsNvYA@mail.gmail.com>
Subject: Re: [PATCH 03/13] bcachefs: Fix typo
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 11:00=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.co=
m> wrote:
>
> Replace 'utiility' with 'utility'.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  fs/bcachefs/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index 216fadf16928..f5a16ad65424 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * random utiility code, for bcache but in theory not specific to bcache
> + * random utility code, for bcache but in theory not specific to bcache
>   *
>   * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
>   * Copyright 2012 Google, Inc.
> --
> 2.34.1
>

