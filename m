Return-Path: <linux-bcache+bounces-353-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA60F881CAE
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Mar 2024 08:00:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5804C1F21E05
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Mar 2024 07:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB1B58ACB;
	Thu, 21 Mar 2024 07:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZVNT3/no"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7715820D;
	Thu, 21 Mar 2024 07:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711004421; cv=none; b=tI4ta9Jz4kIukJu8XVJLL3jEABQHlkqf1iNgkpP3vs2WqqaXCQ2B81wdcl3VwS/cQzRVhKuwC9SacESLXcGwjEytUA0bm7oCthDJnc/LDnjE9c68WgRg30IC0YKssCx5NOvCBlV432/oZ3Ty+RyQ2m9amJ/JpA1ui7s2dnXlJno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711004421; c=relaxed/simple;
	bh=C6RQygeMnW/XJWtdkg9o9IMsvbD+zCntQd3itTZvF3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ai7oJ4H/OaOW97kVI6gsFaKAacqRX4ojWhCqOks/tMp6ielIcY60SdtUYnB0S/vpGrP+JmHKw1waoxhqvyHxYWwW4+vec9WPxwKjt13Tc9iZBgqAFta6SpU1voH0uXIg0zAnjwO2aLH14dBIym7z0MiaSkscZllCd1/kd0Ny25k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZVNT3/no; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1dee6672526so1250625ad.1;
        Thu, 21 Mar 2024 00:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711004419; x=1711609219; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yuRYtnmCnecoco60awXI1rXerQ2CUVZkzhEeKkO92PI=;
        b=ZVNT3/nopOOkG0BRC7l0YPUZLCZ0kDjd3wVql8tiy8S+A9eh8ohyUOOwvVvsoAHn8n
         IxXhs81ngSljsGL7+EQy0GoHcZJ/jzkZHOBcPTW31dOOFxE5hMsVTuTIPc27aBwGSyfU
         vQuwTFsIn2P7UQYnrBQGzmPS5WzPk51w19aFjymQELmDtXr5PaIta8XgfEIldhWo79Qz
         ITbYLmXz386/6E6lpcF2C5JP/IAve9n/DFDzoVs+b1tmMIDSKkk1Z2hwUJBnf9DrHzMB
         Cd26QaPa0DXig6fRUNt/25RxE+80PWTetTCm+xqHpZW8lV165k5tJEgMdJIRBBcXFa0j
         H5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711004419; x=1711609219;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuRYtnmCnecoco60awXI1rXerQ2CUVZkzhEeKkO92PI=;
        b=RwUS+i5L0M0lahCUKJfVAp1rOR4cULa4s0MrN6e73xwgVO552vcQiT3d6b3qTq7vLw
         ieoMxV4zA3fPWxlFgVSVgz9bFZVI/dlzOqSOzl3QYQkwCOn3kf6h1+boHBDbUHUeACDm
         WFTzLf6zidUhshFtznsBR4uDNrmjagjXUCFtMqb3Xs0w80hV7FpBUgD/wZPNGrgTAwwK
         uPZ8UzrMeZR8FD+xIWrTnhdj2t2bIQ9jvQK6uZlmB9+vkGcyE24QCtzYbLIuQwWZqmeL
         6fOF1wezQUvXu2ZIBaN6QAP46QJMILXIJJohMKqMcIeXX44XhKIEnY9vFp26anvJGo1E
         TeRA==
X-Forwarded-Encrypted: i=1; AJvYcCVeXTZlFVr/KYgYACEHqs+DVfnhlb+ZeodDCxL523BXl0mcBZ+gzwel+vB2+UolUDZyXKzDGi+6OSbZw1imPUl0lNBxLoB4NFliwL0MVE/oFx4lcQ8mwz6YUqr0FdznedAIYT3eUqyVoko+HUUl/rkxrWGGrf293+WeAVQbi1rR5L/SS/xbM0DD5tIJCW8yHbHLL8C7Q4ZfxznpqGkeCNRJpytarVG+78+xNPIT
X-Gm-Message-State: AOJu0Yxie1RPlmg5rcrA4u+M2ezThlFxFoQoav/yP/+u1MBd2jQlL1rO
	A5WOucJIUE7Ketc1Obrt8I62GUoiA4Oa7a2FBFefGkhOrRijxqWq
X-Google-Smtp-Source: AGHT+IGetQAA3uKa4M11qYFc4ZpIk2cFDmpiqBhR080pzhKlAYhF5Nq5NnMOAwNr6bGazui6FenSig==
X-Received: by 2002:a17:902:ea03:b0:1dd:a3d6:3aff with SMTP id s3-20020a170902ea0300b001dda3d63affmr22699523plg.3.1711004419070;
        Thu, 21 Mar 2024 00:00:19 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d4-20020a170903230400b001db5ecd115bsm13468894plh.276.2024.03.21.00.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 00:00:18 -0700 (PDT)
Date: Thu, 21 Mar 2024 15:00:14 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Ian Rogers <irogers@google.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org, bfoster@redhat.com,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 09/15] lib min_heap: Add min_heap_sift_up()
Message-ID: <Zfva/gJ8h5G+1YfC@visitorckw-System-Product-Name>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <20240320145417.336208-10-visitorckw@gmail.com>
 <CAP-5=fWAF33f+RnaXNQd6NNJUr=UQzNGAEo_-G07CD5q8Xmrow@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP-5=fWAF33f+RnaXNQd6NNJUr=UQzNGAEo_-G07CD5q8Xmrow@mail.gmail.com>

On Wed, Mar 20, 2024 at 10:15:08AM -0700, Ian Rogers wrote:
> On Wed, Mar 20, 2024 at 7:55 AM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> >
> > Add min_heap_sift_up() to sift up the element at index 'idx' in the
> > heap.
> 
> Thanks, should min_heap_push be updated to use this sift up rather
> than its inline version?
> 
It's better to do it that way.
I'll make that change in v3.

Regards,
Kuan-Wei
> 
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > ---
> >  include/linux/min_heap.h | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index 36023e0be232..af12531474a4 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -194,6 +194,26 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
> >  #define min_heap_push(_heap, _element, _func)  \
> >         __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
> >
> > +/* Sift up ith element from the heap, O(log2(nr)). */
> > +static __always_inline
> > +void __min_heap_sift_up(struct __min_heap *heap, size_t elem_size, size_t idx,
> > +               const struct min_heap_callbacks *func, void *args)
> > +{
> > +       void *data = heap->data;
> > +       size_t parent;
> > +
> > +       while (idx) {
> > +               parent = (idx - 1) / 2;
> > +               if (func->less(data + parent * elem_size, data + idx * elem_size, args))
> > +                       break;
> > +               func->swp(data + parent * elem_size, data + idx * elem_size, args);
> > +               idx = parent;
> > +       }
> > +}
> > +
> > +#define min_heap_sift_up(_heap, _idx, _func, _args)    \
> > +       __min_heap_sift_up(&(_heap)->heap, __minheap_obj_size(_heap), _idx, _func, _args)
> > +
> >  /* Remove ith element from the heap, O(log2(nr)). */
> >  static __always_inline
> >  bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t idx,
> > --
> > 2.34.1
> >

