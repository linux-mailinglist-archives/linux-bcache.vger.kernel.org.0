Return-Path: <linux-bcache+bounces-896-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 036C0A912A4
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 07:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B85519063D5
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 05:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D42C1DE4C8;
	Thu, 17 Apr 2025 05:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AIfYkFcg"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151A218DB2B
	for <linux-bcache@vger.kernel.org>; Thu, 17 Apr 2025 05:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744867674; cv=none; b=m1Set/K+KRVswczHyAb2lEgj38rkIZXG7Q64dyqbCl3fY772CVw8a4szSz88q+FW4sS6F5tl0fnjLNW59/649yVEiDydVdMMT2wjt4DkN1pDeV3pFlgV8TlrcEEut0uptNbWaK+WOenz2mZ8yyfqhK0IzIhFuvA+lhxKX2e9+xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744867674; c=relaxed/simple;
	bh=cdfbNlSSYNTWomLKejfopoWkPO/EVrv37gekGZmTtWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dXjnxnymMlW41B04EU7vD2U3UXkRRhfu3sCA7NHdVYSkIoSHcc107RqqLp3Yyp9VReyX1fyX59Ows+oiCHqz3YLm6mZNocxSCMBVVkCeaD7r5DicDoPH4o5xd+n1NYzY3Lmm9nW7XK3gKNBfzsTncoOK+irxuMASllxLbry1epM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AIfYkFcg; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5f09f2b3959so6456a12.0
        for <linux-bcache@vger.kernel.org>; Wed, 16 Apr 2025 22:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744867670; x=1745472470; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYexaaD/XfjLpPFvDW5lXRpDFj4TDj59maFzOcDuYgA=;
        b=AIfYkFcgH7b3KeVWQZGra16tGrq3+NI1yBeUYsqcCi/+0rx3e1FrGNqKj5GMeI8YC0
         JrUVOurd8aCMftkp2oNmUCyI7CFhE2RMb4ch0ulaQq7u7QcHh+cesZw3vSOvluR5iTHP
         KX9Vp/ctSylb07UrQSYeigTKblnshNFmup/xBjcEQaWQSmb2xLxG6XNiEtY4DFjjhGby
         D2S1Trlrfmr0xcVwQ07DmtEUiVcN3wwyKaRGnVCFcYqLsBwBgMmBenjv8KGtSbtgLfK2
         W6GjueMx7MfRT7jRlOIghrDEZ4iBokU5XoXinVEZg1QSQrdkVyDNgYmidTMtvSlfZn0f
         uVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744867670; x=1745472470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYexaaD/XfjLpPFvDW5lXRpDFj4TDj59maFzOcDuYgA=;
        b=KQUifE82eWH3JFbVfyCpD+YM/wxnLkrAf3Nhzszqhk/dP9djhro+QytvdnJKxOPxS+
         ndF6i1O+POIZiMtWEygpHY7/V0l/Q5j2MuKFDRRzTNFhYkeDYGiuwKDWl7bi95cM/fVe
         UnUD9N2n1vr3kBM5Gf79AmdiEPCRfzE6sPktmjmwrbfcXZh3x6eCkDTRACjiFghkqTC2
         05bBI7P3RapKjP+B3LlfH9NeqStKWwSd1zll6ZvztIYBNVfMt4+sNymRT44lp97f5EOZ
         TTycM7MorQlhKXxLWJRxOEu67UrOn6IJLyQxGIqNa9tjEMD913b5pKp77CdNx4KkNueT
         0Uug==
X-Forwarded-Encrypted: i=1; AJvYcCWZXaggkcHq5YHgmo5YDFfrRzVCiV93hjJEOXotVhNxLz2p1rkxYZRwtQVj81N4h72QZhHRJZvRBH0D/rY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrU20X0O4n04KFsAHTjhTOH7ouV9ASv1K0b4qWqPkKeY91f+WT
	GORWb1Ka6W6zWLmdVGKKLcafJAn/pF4s9kpAJEmkazgnwo9Yx6ivv9jZHTAWiA16KJFQaq5CSbf
	9wwjqCTrIcjyzwUUS3I1aBBrfwAsgQ5ajaS1l
X-Gm-Gg: ASbGncugYV7DHvxTg//ZJcbcaCcHdAwCxvNh8nkao6xGJ7aOGKIchk4hlU1at7UtEpI
	GlFF2LSSKFvZDh/VFcpyNJ4ANTeOE2epCn0a+SuRbQnpf1tkSXroT7ikvUVnQVIb0RDu2PCTErB
	JLB8OOdrTuc8i6f3LeK/dP6CFSoRr7F74=
X-Google-Smtp-Source: AGHT+IEfnYTjDb2YDNT31bGOjtTYJLMFM5bvrKmSyvizNQt90dhBUYdSlJhYai9Fe5wl0HrbKs+J1t32rN6Ov3qRbgg=
X-Received: by 2002:aa7:cb47:0:b0:5dc:5ae8:7e1 with SMTP id
 4fb4d7f45d1cf-5f4cb1ee7d2mr54266a12.6.1744867669932; Wed, 16 Apr 2025
 22:27:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250415174145.346121-2-robertpang@google.com>
 <202504171044.TFdtTfEh-lkp@intel.com> <CAJhEC05SjwDBis3rfDw4-gg+tEyQ-aCkTSFVFs+Zw9xSSZUekw@mail.gmail.com>
In-Reply-To: <CAJhEC05SjwDBis3rfDw4-gg+tEyQ-aCkTSFVFs+Zw9xSSZUekw@mail.gmail.com>
From: Robert Pang <robertpang@google.com>
Date: Wed, 16 Apr 2025 22:27:38 -0700
X-Gm-Features: ATxdqUFjHyCjORk3eB-_sluj8w7gnJsdcVWCqMLgq27w3d3pK3-noa_m90Pbfxg
Message-ID: <CAJhEC05=knZ-rFRLDk1K85GAJZJUOja_SAKPw0edXy9rK05_=w@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] bcache: process fewer btree nodes in incremental
 GC cycles
To: kernel test robot <lkp@intel.com>
Cc: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Revised version sent.

On Wed, Apr 16, 2025 at 8:13=E2=80=AFPM Robert Pang <robertpang@google.com>=
 wrote:
>
> Please accept my apologies for the build error. It appears that the curre=
nt
> patch is missing a macro for 64-bit integer division needed for the i386
> architecture. I will address this issue and submit a revised version prom=
ptly.
>
> On Wed, Apr 16, 2025 at 7:31=E2=80=AFPM kernel test robot <lkp@intel.com>=
 wrote:
> >
> > Hi Robert,
> >
> > kernel test robot noticed the following build errors:
> >
> > [auto build test ERROR on linus/master]
> > [also build test ERROR on v6.15-rc2 next-20250416]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Robert-Pang/bcac=
he-process-fewer-btree-nodes-in-incremental-GC-cycles/20250416-133615
> > base:   linus/master
> > patch link:    https://lore.kernel.org/r/20250415174145.346121-2-robert=
pang%40google.com
> > patch subject: [PATCH v2 1/1] bcache: process fewer btree nodes in incr=
emental GC cycles
> > config: i386-buildonly-randconfig-001-20250417 (https://download.01.org=
/0day-ci/archive/20250417/202504171044.TFdtTfEh-lkp@intel.com/config)
> > compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58=
df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20250417/202504171044.TFdtTfEh-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202504171044.TFdtTfEh-l=
kp@intel.com/
> >
> > All errors (new ones prefixed by >>, old ones prefixed by <<):
> >
> > >> ERROR: modpost: "__udivdi3" [drivers/md/bcache/bcache.ko] undefined!
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki

