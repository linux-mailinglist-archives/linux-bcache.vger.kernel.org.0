Return-Path: <linux-bcache+bounces-310-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7487E8805AA
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 20:51:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 097ED284B9E
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C58A4CB30;
	Tue, 19 Mar 2024 19:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j8hm5QRA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8FF3B78D
	for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 19:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710877899; cv=none; b=qxqxwMxB/DCDrHumr/goofuC5+TIkSMU7uuJSEUBKzo1C83oi2w9q0P/b6cmr/4NejYM3yZklIiZjC7UvrSMjR7PV8YV5+EeZUNbwVLqxbZPWGayHCr/U37EX1JdbyM0IOkGBiptGQoiiKYMK7RqlnRd+wCJMBIsye1SuUuKeFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710877899; c=relaxed/simple;
	bh=u5ISTVgLFXBHPytLP7czQVcemEzdgRVw+u5krgsn5QA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mWUnC9kj1fCGa5FWdxhuThaT23fKsN0xHy46kMTAg0M7cKMte5UcqWvo8EWGHkYBIpUxQ2/bFGmXjb9ihCGqrJgDhwehNCjPCyeF99f5M30ddqM9swsc1Vft0Wbkp8jFT1a33VjBYcQvZsDucGLGKqc3QzZhniyTiINXmPGcdSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j8hm5QRA; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dee917abd5so1365ad.1
        for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 12:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710877897; x=1711482697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0TkXuhmLGM7c9bdHQNzOA0SGeCtxI5tN/gqKMMP6F0c=;
        b=j8hm5QRA91NoXNsZMtjBMmSRGagPsBzX2iJSVImfSyJi1LmFDYrJ5+c1pOezGlbZE0
         5/IY6Qfx73bArihTLDmlyihtIXP5CD3WhBdbfMfrjcf6eldPT8LfO+7LRfTEffCdnDbr
         isJYxwH5tFEaJlMoPvGalXe4zl1CiJoWeSO3zF5X9HAgLqoU0UekFmXDN3wEdIoKGR7Q
         pVP54A38wvPbEPm74idtfRxoQvqQbPhygeMlkatZmD6Ruho59H0SfwvbDrTo3KDBdIBk
         Xhsn0hPph7UEm8bhKXirnnKnTc/ahgALYj22WsLRLrzTEeRaam4WRlj5cvpVVBcpajcD
         X9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710877897; x=1711482697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0TkXuhmLGM7c9bdHQNzOA0SGeCtxI5tN/gqKMMP6F0c=;
        b=Ve7T/lQc6xQpnPmnk6Y4aXhNYlwd4GO59MTvzvNC0c8GSoRlzSRYIDlZkXQJC/NynT
         1qu+zQ4oOeSVd/PAGwwqED+rGsHeNswHJNJ8nOnre/ulkmrX7QE+cACrvsTZzJV4I2qb
         A1vQBzbRdSdeotyomFKBKVhtKecfXTX1wezbreV+Yb9RZW/SOXBP9RGdgwBYYZE92Xz9
         SBfGFco+XUi0R4It/rtlXCwbEWlkLclcwxKE2Vzv09ckJ9FJwZi0WXaxWHz7aUac7t5q
         zPTBrQPpGIij7BwhIa3h/nETKqB4BcxWuyLv6goKU7TlcjTghJev88vSRnvdo+emm6RO
         +0Aw==
X-Forwarded-Encrypted: i=1; AJvYcCVYoGguxvrGosMJpeGcWe5HFohcIoviPIAE9h/jbuVR9GgsFD2rE41MO8ByuNljp4uWY03/36P9GL8pTJkrSBGmocBRh00sMur11zri
X-Gm-Message-State: AOJu0Yyh3rQu+Msc8MlP/b6/RfFbw+bIQdRdCrA3I7vOUK3qVbifTPu2
	5EB3VLHIn/cUHF8WXRMcyzYXeBo9HR1pfnflB6ailIRtdNCvFy7Z9ekIy6KaR36PiI7truf6qCP
	myrAvwi/LGAkK2/Y44118eb1dDl0ga2Q6gYMM
X-Google-Smtp-Source: AGHT+IF+frKKJWR+nVJ2Vrwk/OC3+PDYLd1fNu1rRucHMrbQJorul6XLTLfqlvUhZfZc5d71eG8DO7rmDaJ3MYo16Z4=
X-Received: by 2002:a17:902:ecc8:b0:1de:ff9f:e760 with SMTP id
 a8-20020a170902ecc800b001deff9fe760mr68290plh.0.1710877897067; Tue, 19 Mar
 2024 12:51:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-6-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-6-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:51:22 -0700
Message-ID: <CAP-5=fW+FvUu8JL+KrtVv5uC++4AW=VhyEOgmdWzpH1mswQNzw@mail.gmail.com>
Subject: Re: [PATCH 05/13] lib min_heap: Add min_heap_init()
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
> Add min_heap_init() for initializing heap with data, nr, and size.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Should this change update lib/test_min_heap.c to use min_heap_init?

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index c3635a7fdb88..ed462f194b88 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -44,6 +44,18 @@ struct min_heap_callbacks {
>         void (*swp)(void *lhs, void *rhs);
>  };
>
> +/* Initialize a min-heap. */
> +static __always_inline
> +void __min_heap_init(struct __min_heap *heap, void *data, int size)
> +{
> +       heap->data =3D data;
> +       heap->nr =3D 0;
> +       heap->size =3D size;
> +}
> +
> +#define min_heap_init(_heap, _data, _size)     \
> +       __min_heap_init(&(_heap)->heap, _data, _size)
> +
>  /* Sift the element at pos down the heap. */
>  static __always_inline
>  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> --
> 2.34.1
>

