Return-Path: <linux-bcache+bounces-893-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F1F2A911EB
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 05:13:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA124445D5D
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 03:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DEC01C3BEA;
	Thu, 17 Apr 2025 03:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MM3RYQj1"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3372E1AF0D0
	for <linux-bcache@vger.kernel.org>; Thu, 17 Apr 2025 03:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744859618; cv=none; b=bu+3AGpxJ5sTjf5MhK0dvaSRf4fuHatDmC8XeXLbYwUKpnGcNo40VWlHjervIzs6tkVUi315+EoN4AIdWak1P3H8YMQxdh1OwWUJ9txJFPEvAs7X0Rk5j1xUtilNSnhXbpztikgtDYNlWwcNq4IlWAk9GBc63wzy1/wbgJZQx+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744859618; c=relaxed/simple;
	bh=8Lg76RDATX5nrSmqI25cRjIK96XzW42HFvsjBBBNz7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DQa3n7OA8zqwkCIQXTysmPoRRf3VNzDOhkOccSnSWr6vd+4OH12zzDB4uqXlIkg6a+1+hxe8RnPTKuyImDD2Wlz3K1xpjMVK3DETqeMplFlJceTs3vPD1ARD3Q5KpPZDF2GXqWlI4IrXvandI6P6pnMBosHxdD+FqhSZ/PndT4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MM3RYQj1; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e5cbd8b19bso3419a12.1
        for <linux-bcache@vger.kernel.org>; Wed, 16 Apr 2025 20:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744859615; x=1745464415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=znyb38ry2bcKrLD3m+0rc/cT6gNSpjuqkU+5HpltG+o=;
        b=MM3RYQj1s/4v30eOd36U2kAFt8772EDxq96SIfJjwZpgo1sWBRlKJWzzrrneZjpFEN
         syYWERGpjm457CpGD0ztOj9fjkR3M6wijuhba8a7a/Ak0wGpRRTAw5L/rC8X4BWnWbT2
         R4pjW8b8eKMVbK2muYbBcEusD+netTGcpH402PKy6s84owtHmnD/m7K2HZs3PdMjoUBG
         z0otQVcrnPX2Gu7iURx57PoM8dIHwSVjqwFdPu/0FgmDq1PCcidY4itTUva6o0dCUsdO
         4lW5nTQTNKmWY44ZzRHPmKBiJixsTsCUvCIQT1sexcTCi6jFE+MeIYjs7W6gY+/kRR9E
         MYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744859615; x=1745464415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=znyb38ry2bcKrLD3m+0rc/cT6gNSpjuqkU+5HpltG+o=;
        b=IHLNSDBQ8j5hBKnPkctxUMqPT4yP1Ft1L6wnWLQu+lDK9C92gIz1tqquDdg4/g6VRl
         4McTBqrIDRwq0b031rGOsjmm0fcEFGRh5cMBB0ZMIB5m0yQeiWb4TZM/2Y+dCt8edkTS
         FRadOh/bDKg2pUNtceDZKJjtZHCx6vMKoxN7q27lWqXn7aeJjTinDHjdZyRvJ99dgr1W
         b9kX45kbpbn/dt5ZZJWOqTACrQID0sM9gX4SUfINyW8jHeGOfQqjWFvvZZUmA7p2kTe1
         dRcN9qLJT8kPj3P233BgXiQlS79WYjmTFe00EgmVyeqlRFuk83xxc6UMlPgyKyS4sa+d
         NMkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWt7YhvY07NIvFe4/OTYeF/sIQrjuvAb+RBALQihRdtXHyjSxpVTddmNtsbKWmGtuksgGi3GJQP880PR0E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5Bqfhc/ZFvVy5/P8tv/D5dT1SXh5msBmd/IcfgYxlmnLFWQIY
	g3nR/PMFquMJ7jLn7S4JySXzQ6G8FN8ihfQNb/PKv0RXDuOV1Zt92GxCpef9rUwSBgFMFDnGsRq
	kjMlgBt9mj8hMlMi+Y+pwHVe0IfgzxmwGcLRjmAmqAwGm3/DxB88Dk0o=
X-Gm-Gg: ASbGnctmtyKygB0AofU2QugOuUWw02eL/zv0roVWcGvOKsI8T7JYKf/8+LpeOs8iIhh
	l/tc94svBCy/8tjl6LDb9AJSb4Wwibny9ZVw0cb4RondYChL5Qq5o5uI2NntIi4tfZb+2RHBut2
	QjCxsnbtuImI3R/mKLKwiY
X-Google-Smtp-Source: AGHT+IFw7kF7r3vqgCR+cGVl4G2MtxTmmev5AUh8oAejDfyWDC9AK+zMJ11T151RgjPuKZOmNsKzWzgm73emQolRzkw=
X-Received: by 2002:a05:6402:175c:b0:5e6:15d3:ffe7 with SMTP id
 4fb4d7f45d1cf-5f4d2927f8fmr28040a12.7.1744859615261; Wed, 16 Apr 2025
 20:13:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250415174145.346121-2-robertpang@google.com> <202504171044.TFdtTfEh-lkp@intel.com>
In-Reply-To: <202504171044.TFdtTfEh-lkp@intel.com>
From: Robert Pang <robertpang@google.com>
Date: Wed, 16 Apr 2025 20:13:24 -0700
X-Gm-Features: ATxdqUFBgiAHFh1P-CiVkjQQGtPiTBX0iJ-hw-ydXq4hjwl8qjDqcXLZwoair-I
Message-ID: <CAJhEC05SjwDBis3rfDw4-gg+tEyQ-aCkTSFVFs+Zw9xSSZUekw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] bcache: process fewer btree nodes in incremental
 GC cycles
To: kernel test robot <lkp@intel.com>
Cc: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please accept my apologies for the build error. It appears that the current
patch is missing a macro for 64-bit integer division needed for the i386
architecture. I will address this issue and submit a revised version prompt=
ly.

On Wed, Apr 16, 2025 at 7:31=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Robert,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on linus/master]
> [also build test ERROR on v6.15-rc2 next-20250416]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Robert-Pang/bcache=
-process-fewer-btree-nodes-in-incremental-GC-cycles/20250416-133615
> base:   linus/master
> patch link:    https://lore.kernel.org/r/20250415174145.346121-2-robertpa=
ng%40google.com
> patch subject: [PATCH v2 1/1] bcache: process fewer btree nodes in increm=
ental GC cycles
> config: i386-buildonly-randconfig-001-20250417 (https://download.01.org/0=
day-ci/archive/20250417/202504171044.TFdtTfEh-lkp@intel.com/config)
> compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df=
0ef89dd64126512e4ee27b4ac3fd8ddf6247)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20250417/202504171044.TFdtTfEh-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202504171044.TFdtTfEh-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>, old ones prefixed by <<):
>
> >> ERROR: modpost: "__udivdi3" [drivers/md/bcache/bcache.ko] undefined!
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

