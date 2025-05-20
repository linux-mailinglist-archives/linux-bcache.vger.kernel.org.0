Return-Path: <linux-bcache+bounces-1073-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E02ABD82D
	for <lists+linux-bcache@lfdr.de>; Tue, 20 May 2025 14:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46F181B60F2D
	for <lists+linux-bcache@lfdr.de>; Tue, 20 May 2025 12:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDDBA15B115;
	Tue, 20 May 2025 12:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m2OqwxOe"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511A682D98
	for <linux-bcache@vger.kernel.org>; Tue, 20 May 2025 12:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747743976; cv=none; b=Q7sTYXRs6Tbqw2ScYKQbVscCO8oXTbiC1otGInhTWj1Fxz10CYyj5VTROMl7oy8uXyHO3qLbe1xO7udjlM0z8fe9z0jk3Iu0POegguze5IMeorIqMcz9RNmf/Rnq9cCqCkY+zSzqip8mQs7FqXa7W3h/0ID/DNigG9jS9uspyQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747743976; c=relaxed/simple;
	bh=x1ussyM6luj7h6YL6eNAj+ACicyhaGpaSS4pDEuBsS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PhZvTH18Osvohe80T7s3KtEPAJP5rx3ghiF1K9JzGm39yaKo1t/P7Jo7PH/xoGrCtOlYIAriN+DVXo7IlRpe6SAff8tohJzSYdZr21TLD0fR97y1ySCMZtr/2p+2n7lzlB7RKPyt1lqdcKrKvThKoSW43vK07eIckSBR5KLxQjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m2OqwxOe; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7398d65476eso4373504b3a.1
        for <linux-bcache@vger.kernel.org>; Tue, 20 May 2025 05:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747743974; x=1748348774; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qBRJq/8VMeqUg5qxfvzzj1/Dw+iFHaLopX6RQDkphg8=;
        b=m2OqwxOe+D8OlkYQY4gjfqceMqp/o68ycN5YwrogD49ag3ijWZSp5R32E2/R2jr+X7
         2S7hpbasdYJHbwTzcQ7NS6yJnhVz4QeYH7RJtWhCSB0fCrhNlWJtu9Naet9gUITgdg9y
         Q8mCmDoGphZZMf1s9KuW9mpHpUOWQFcwbQ3GN02teyK7uA8ca1B94IFdgUi3RuNSBWug
         mNH2unpaV47gZUbM+xBtE+ezO507vV+9QWrm9asrq2Gex68Dt2zIi4t47xlc4KUPH6G3
         3qdSNTKkInmACPoFwK7D1E7BH0dqNGRz9XmdwCu3gu0TUn2EJ4DYum99MnAzZ1fPJvPC
         m5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747743974; x=1748348774;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBRJq/8VMeqUg5qxfvzzj1/Dw+iFHaLopX6RQDkphg8=;
        b=XEUyXa46hF6LiwQXBxE1Q/EjM/IDAtNUkzTrYDkrLJhMna+xX96+/Kqlnxv535KeRc
         tQBZy117nM+PlhvqVsZza1QooJr3NoTUewTttYjy2nPcqVixxyM0vnbX4sSKt/oAtpGW
         +0rUZ8bk8ywWjBI/brQzRj8R2eodbe/rwFy6Gqb9PgEK3+W8yQFDPSJ36IRwxyrnndUp
         JCAzvJ1fQXjGuqyLp8imee2BMMQduK4Elis10K2a9du0lMGfOetI0c+S0zFq/VCYhDUs
         HVRKo1UaKCHWZkzxdnlQ1YDzXI4FZgPsdW3hl7eTsNrFOhpkJIxUvq8V7UXnZuvHPH1t
         srKA==
X-Forwarded-Encrypted: i=1; AJvYcCVnob9JMd0d4dyuihkgPk2/15iPUz+AGMJFNLY9CqrPlG5FPsX5NNFCbjov/WllqpKDpFziu1sZN70F04M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Dfnssi6C0mxrU/jQJPwEMW1xSZlR9zU+veX3OrSaVAu29RW4
	HZRBX9ocIl1vsGQNeKOrsqPiTqPuX/vaUKP54pWT8uMNuDYASYbnn3GWbcx1HlfJ
X-Gm-Gg: ASbGncst9y35pEm2fpYRSiJ5yxQNKKjoel9Y1bC6SfKbWeAxaFspBSiwOktSV8CmlSs
	zrwSAx7ulPcwbzcbJdN3Ro/APhsvW0s0Jr9K8nPwJzy+5Cu3p1Hm6GCB5dXJTYLIeWMVKs/CjUV
	xJyP5Xe6WUqOO9lG2C41YYRsE8dcaTDkb7UFs/sQUqZ1W4njNEMekkDIou4gXdoG2kBpDtWF0R+
	hzu2FWSyLdhdV5jMqkJkGwZhqHjU8znwjcl9RXStvauAnBAZRvDi2U6zcbc4y1SPS/uAKzaV36Y
	PIpLvnwbfpMP7wKbA69eFHOwPmL57G2luGQgC6x2U3XAsOrwS9tP/uKei1x2Ke7AhUlihGPv9NN
	ay50=
X-Google-Smtp-Source: AGHT+IF2z8wCbnU1Lu25DZtENtQHVAfLDzxmc7rccobUIpRX/ZZPjVxJXixY9aQBygjQSKNiDol/Rw==
X-Received: by 2002:a05:6a20:c681:b0:218:2b6e:711f with SMTP id adf61e73a8af0-2182b6e7268mr12727960637.14.1747743974360;
        Tue, 20 May 2025 05:26:14 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2982c04d12sm845974a12.21.2025.05.20.05.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 05:26:13 -0700 (PDT)
Date: Tue, 20 May 2025 20:26:10 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Coly Li <i@coly.li>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Robert Pang <robertpang@google.com>, Coly Li <colyli@kernel.org>,
	linux-bcache@vger.kernel.org,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
Message-ID: <aCx04pakaHTU5zD4@visitorckw-System-Product-Name>
References: <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
 <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
 <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
 <aCWTxp7/t8nnBuzD@visitorckw-System-Product-Name>
 <CAJhEC04qo8CFcFi6tmn9Y28MpasVB93Duboj1gqR1nfOXO+Z2g@mail.gmail.com>
 <aCdkgzPGWzcjXCrf@visitorckw-System-Product-Name>
 <AD23C0A6-E754-4E43-AF54-BCFF82B19450@coly.li>
 <aCxszsXC1QnHYTzS@visitorckw-System-Product-Name>
 <8CA66E96-4D39-4DB1-967C-6C0EDA73EBC1@coly.li>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8CA66E96-4D39-4DB1-967C-6C0EDA73EBC1@coly.li>

On Tue, May 20, 2025 at 08:13:47PM +0800, Coly Li wrote:
> 
> 
> > 2025年5月20日 19:51，Kuan-Wei Chiu <visitorckw@gmail.com> 写道：
> > 
> > On Sat, May 17, 2025 at 07:02:06PM +0800, Coly Li wrote:
> >> 
> >> 
> >>> 2025年5月17日 00:14，Kuan-Wei Chiu <visitorckw@gmail.com> 写道：
> >>> 
> >>> On Thu, May 15, 2025 at 08:58:44PM -0700, Robert Pang wrote:
> >>>> Hi Kuan-Wei,
> >>>> 
> >>>> Thank you for your prompt response. I tested your suggested patch to
> >>>> inline the min heap operations for 8 hours and it is still ongoing.
> >>>> Unfortunately, basing on the results so far, it didn't resolve the
> >>>> regression, suggesting inlining isn't the issue.
> >>>> 
> >>>> After reviewing the commits in lib/min_heap.h, I noticed commit
> >>>> c641722 ("lib min_heap: optimize number of comparisons in
> >>>> min_heapify()") and it looked like a potential candidate. I reverted
> >>>> this commit (below) and ran the tests. While the test is still
> >>>> ongoing, the results for the past 3 hours show that the latency spikes
> >>>> during invalidate_buckets_lru() disappeared after this change,
> >>>> indicating that this commit is likely the root cause of the
> >>>> regression.
> >>>> 
> >>>> My hypothesis is that while commit c641722 was designed to reduce
> >>>> comparisons with randomized input [1], it might inadvertently increase
> >>>> comparisons when the input isn't as random. A scenario where this
> >>>> could happen is within invalidate_buckets_lru() before the cache is
> >>>> fully populated. In such cases, many buckets are unfilled, causing
> >>>> new_bucket_prio() to return zero, leading to more frequent
> >>>> compare-equal operations with other unfilled buckets. In the case when
> >>>> the cache is populated, the bucket priorities fall in a range with
> >>>> many duplicates. How will heap_sift() behave in such cases?
> >>>> 
> >>>> [1] https://lore.kernel.org/linux-bcache/20240121153649.2733274-6-visitorckw@gmail.com/
> >>>> 
> >>> 
> >>> You're very likely correct.
> >>> 
> >>> In scenarios where the majority of elements in the heap are identical,
> >>> the traditional top-down version of heapify finishes after just 2
> >>> comparisons. However, with the bottom-up version introduced by that
> >>> commit, it ends up performing roughly 2 * log₂(n) comparisons in the
> >>> same case.
> >> 
> >> For bcache scenario for ideal circumstances and best performance, the cached data
> >> and following requests should have spatial or temporal locality.
> >> 
> >> I guess it means for the heap usage, the input might not be typical random.
> >> 
> >> 
> >>> 
> >>> That said, reverting the commit would increase the number of
> >>> comparisons by about 2x in cases where all elements in the heap are
> >>> distinct, which was the original motivation for the change. I'm not
> >>> entirely sure what the best way would be to fix this regression without
> >>> negatively impacting the performance of the other use cases.
> >> 
> >> If the data read model are fully sequential or random, bcache cannot help too much.
> >> 
> >> So I guess maybe we still need to old heapify code? The new version is for full random input,
> >> and previous version for not that much random input.
> >> 
> > 
> > I think we have two options here. One is to add a classic heapify
> > function to min_heap.h, allowing users to choose based on whether they
> > expect many duplicate elements in the heap. While having two heapify
> > variants might be confusing from a library design perspective, we could
> > mitigate that with clear kernel-doc comments. The other option is to
> > revert to the old bcache heap code. I'm not sure which approach is
> > better.
> > 
> 
> I prefer to have two min_heap APIs, but how to name them, this is a question from me.
> 
> Also if the full-random min_heap version has no user in kernel, whether to keep it in kernel also is a question.

From the perspective of the number of comparisons in heapify, what
matters more is whether the data contains many equal elements, rather
than whether it's truly random. I assume that for most other kernel
users, their use cases don't typically involve a large number of equal
elements?

Regards,
Kuan-Wei

> 
> Kent,
> Could you please offer your opinion?
> 
> Thanks.
> 
> Coly Li
> 

