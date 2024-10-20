Return-Path: <linux-bcache+bounces-774-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 351529A5287
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 07:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9D991F224A2
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 05:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB08BD515;
	Sun, 20 Oct 2024 05:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKTtG7Tj"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CB5747F;
	Sun, 20 Oct 2024 05:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729401328; cv=none; b=ZxjvICL1AwaC2cgvat+7POd/HUdLClB9MJXkAoDsBaFAqjmEImJZfopI3yWTQCRaQArLUYUlQunFUK88+b76dszCLLum45x33LuGZA7/9Hs42cCUzdcQ0v37HKcjpEOytVlh5jwb45k8aB/MT3qlM7QUcR782j7WCp2ausAQGvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729401328; c=relaxed/simple;
	bh=EiS1xJd1Mm5kFjrRr9U5CfecgYtGUDFHb98U0Psae/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfbQOXx46+ZoGlR4eZqV48PQjGsuUY3EfB2iC8glfltz05l3hVvefuVJ1qSy+2VoiC4uc27fhBzTt2Nb2wCEnUFKlfFp5nVifWv5AMDibog8dsS3QU1+24JmOdDV/rLJPAC2rN+wpDVpQswsoVWZmZgvt5lKNCXr9zX9cC5pIOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QKTtG7Tj; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20cceb8d8b4so20015995ad.1;
        Sat, 19 Oct 2024 22:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729401326; x=1730006126; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mPLTUkSwRn/ADCNGu4AGpEmYT7rtlb2CMdwqNdOxpTA=;
        b=QKTtG7TjOstHNeIvKZ3umi8kdnWBls6FPY1U4KIZpeDb6CwQ2LpjEltMFQAuyNcEvX
         fgQXWDsAa4o9CbeOyrmbIxzM5tVFLAJwjAL5lc2q5PDkz010JNlqp9ursrPz28M6YTkl
         ZIha354g2WaVFeKHkGh1Qkev58tZ6dOHJUH2JMKDP03T8dCg2in1Nm05OWyd+D8mMlxs
         +ZXfZJIIubl0bHXZ7Y2R2/RXrk9DNost0DgaLG2YJaXfuqKyWo/p+yBn/HUZm2TqdozK
         5Ge7IwRCznCP5xlvPkA0vHTsgjn2/uBFV6Hy9CNTn2VXqlg1oQXh9StNrfKceAvMegPL
         YJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729401326; x=1730006126;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPLTUkSwRn/ADCNGu4AGpEmYT7rtlb2CMdwqNdOxpTA=;
        b=wJx0IPOGaYzYxohIDgFKrTejasMXZhwpai0HFytJJ31QEFUPqo/7vWba5AZbAUb/YD
         YqoaZNtBWB3LCLNFLSNDd+gV6h7+TLh+68psdLqnhdARK5GQSBAKejxXhT9oWo3FpEG0
         u4FuSHaxgYVTMJMCWaUKFxwnEdFnor8nUwfX2u5ttG0JCkdV7Cn5vqCrZCH8cEyroFMJ
         4Qxg3MMGZWfNsuhR8RhEeOf2fprfFRw7mMN4QJAoZjzkuggv4VYl0PZuW/mmT+t+YqED
         K5zfUkkLBU7kbt8JkURa4aAC6LJ6zSlrWL+oWoO5o19mB36UfgTxlM6am41vmnCI/Ape
         hPWw==
X-Forwarded-Encrypted: i=1; AJvYcCUjrU6i6CTyaKkIDzuGU8rL9yMntdPoDvMG6iR2mAyIEvPG+FYdR7z6nhMmuBEzh3IIL8GliH5tnPEW@vger.kernel.org, AJvYcCWS1S4RnVsFLtqfziCKymX9dhTwk0sQwsW+CmLCR38lG/MfanQTdJy27M4RzUKAH889BNzOhiOUCA8655Vm@vger.kernel.org, AJvYcCXLyRZwQBR+TZwJfAvovZAgDiNVCcpOiY6JHpdrDxMxUA9Qe9NJuLfmE0PCC2g/vMKVrmh3UAUAWrSgXzw=@vger.kernel.org, AJvYcCXMWtU6YraYQQ2WvRwfbbk3TNckgituUls2EZEgOY/IetL1deKImGLooTI0zgoiXUS54/oyB7BNaXvQS8xs+5U=@vger.kernel.org, AJvYcCXP9b9B5Wke35+YC7La4vKRTJ3HfpBPt2ERDHTxoT/qv24yoxmWkiwkg8W7z+oTZ/TCauj/NuB5FheyVFImSfhpwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBkDwb3gophCq+V3OljVPK2BnljDrL3Wo87ISP8rWEUQdwxQyp
	QvlKNT8FkMazjxua27WhdtamnglobE8eUqTy166wXLvOe+l9EfUckJQtpA==
X-Google-Smtp-Source: AGHT+IE2fzzFACXVkzcnLBp5pcAmsooXt9koAwUC1XLg/0exaP+5fY0FgX9aH1MGPibSba2Conm9sg==
X-Received: by 2002:a17:902:d4c9:b0:20b:c043:3873 with SMTP id d9443c01a7336-20e5c29ab00mr108315935ad.21.1729401326147;
        Sat, 19 Oct 2024 22:15:26 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0de39fsm4857465ad.206.2024.10.19.22.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 22:15:24 -0700 (PDT)
Date: Sun, 20 Oct 2024 13:15:19 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/min_heap: Introduce non-inline versions of min
 heap API functions
Message-ID: <ZxSR50u0qLYPUeH+@visitorckw-System-Product-Name>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-2-visitorckw@gmail.com>
 <20241014081358.GS17263@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014081358.GS17263@noisy.programming.kicks-ass.net>

On Mon, Oct 14, 2024 at 10:13:58AM +0200, Peter Zijlstra wrote:
> On Mon, Oct 14, 2024 at 02:47:01AM +0800, Kuan-Wei Chiu wrote:
> > All current min heap API functions are marked with '__always_inline'.
> > However, as the number of users increases, inlining these functions
> > everywhere leads to a significant increase in kernel size.
> > 
> > In performance-critical paths, such as when perf events are enabled and
> > min heap functions are called on every context switch, it is important
> > to retain the inline versions for optimal performance. To balance this,
> > the original inline functions are kept, and additional non-inline
> > versions of the functions have been added in lib/min_heap.c.
> 
> The reason it is all __always_inline is because then the whole
> min_heap_callbacks thing can be constant propagated and the func->less()
> etc calls become direct calls.
> 
> Doing out of line for this stuff, makes them indirect calls, and
> indirect calls are super retarded expensive ever since spectre. But also
> things like kCFI add significant cost to indirect calls.
> 
> Something that would be a trivial subtract instruction becomes this
> giant mess of an indirect function call.
> 
> Given the whole min_heap thing is basically a ton of less() and swp()
> calls, I really don't think this trade off makes any kind of sense.

BTW, Regarding the concerns about the efficiency impact of indirect
function calls, should we also consider converting some calls to
sort()/list_sort() into inline function calls? The comparison functions
they require could lead to a significant number of indirect calls.

For instance, the comparison function passed to list_sort() in ubifs
calls cond_resched(), which implies that the linked list could be
lengthy, further increasing the likelihood of numerous indirect calls.

Regards,
Kuan-Wei

