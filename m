Return-Path: <linux-bcache+bounces-1076-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3A1ABF7FF
	for <lists+linux-bcache@lfdr.de>; Wed, 21 May 2025 16:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1617C8C71E6
	for <lists+linux-bcache@lfdr.de>; Wed, 21 May 2025 14:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 270B51A23BB;
	Wed, 21 May 2025 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UN+USksk"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867C314A627
	for <linux-bcache@vger.kernel.org>; Wed, 21 May 2025 14:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747838431; cv=none; b=dd0YNmcnwodm++jdQhLXPXwiUZzb6NyasCjf8+mBdIJBTQCC6YJQHz9QDkVW4mWcB3TbElcn6iYCX/lCL9PIh/mUfXoz6ixSvUnrGRFO9IkhTFqFq4QJ16YtgwGy8Y+TZhLD4e6nJPCLlio/XR9KHcYQSdvvwjrR1k94e8bKhwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747838431; c=relaxed/simple;
	bh=HPqbpXTpX960SO4VqOl9qF7bYXxNIhtkU1X0Fl/8uyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NyBoupu4LAfB87ufELbseyFtGTpE09Qqf7W3sTBiJJFx8h1SEYTbAE5jZ6R69jZ3DE8s1XwDocwKA1aVCnsrQ7GowToE6Dk15uW5LlddJ+BxhfolfpWCbT06id1l5tn7976GmYrcQtRifycSQbnbWZEHA76ra9vJgGLViZ5pCvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UN+USksk; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-742c46611b6so5122442b3a.1
        for <linux-bcache@vger.kernel.org>; Wed, 21 May 2025 07:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747838429; x=1748443229; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q9KsS35gm1ptiR9LVXn0dsrOt1QPg+8u8qnwRSOVqmM=;
        b=UN+USkskeNTGwTJKv+KZQIBXOBeiYRtk/RGgYOp3hjpBl+WeCu4KyEx6FvoIiXfJyr
         nRvKKSBFoo4ukUHuaTs2KAWSX4H7ro/uOBYS6Fsy9tkFV7HfhhrWw8qTW8KZ95uR9oSM
         B5X09MMO3/nQIMJnDGxcAuXNgIeJRlwpihukQdL7L5Y19311mszT2A9+IAWcxArN1Fme
         /wUBusOXGn7jitrEm6OhYlgrmqU0xOi//JCT6jOGaRJKyPoSzkUHwPtSeHXITaJD6ek1
         Y9PxmIEqC1CCUWXH1KvpWPOU7TE3tpux1vMciN6RPzKCuLR/S1S/It9RfhJ7UsnLLBl9
         u/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747838429; x=1748443229;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9KsS35gm1ptiR9LVXn0dsrOt1QPg+8u8qnwRSOVqmM=;
        b=X5peukTAwoPTJJqAXpVToHV1Fy/uamIAycFpJtqDScXZpeaelfinEynU1RIV/Pvxqg
         JTVUmABoZjfqob+zRQUoajQ69SX7GR9pGuOO/0h0G64FsZfWxzts8JyNQdy5LP/vrEmM
         VSgGuqu2L1WHRJeq8pNplgHRZAYihPndqkQXGon4irkqrXW87TPR1yVX8hDcOs8HU9KJ
         NJZhU+FTtCXR1+R9oIEKpKVYVEL/ykNar1aiBi6IgChR0+h3ZjoyJZz1GFeMk0kkscho
         eG3DrS/fCOnMeN8FfHYKXQ8bRHTHN67zGJfjGJVc6yrMuqjRbmlBrUBJNK1+JPV8HroO
         jmzw==
X-Forwarded-Encrypted: i=1; AJvYcCUu1Acsm24Wvf9CBVXaT7TIeobm3WCBQwf5+o/l1HOZLAuPUdUnRu8PnC7sLl4K4KNVNzOLXH5ZXcfEgec=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIcALVpPLc1Z8uLr4iem4YtMeMgLXtdGeRLEkJ4deheOR0zNnH
	05B6bGyIJVutcwYZH5MmzQVdwy8afseMB1P2RISmRtyRpCqhAFvyCgvWoogqLqCM
X-Gm-Gg: ASbGnctbDRPiSBs1AVSo4i3tfoTtwD084FuwsL3DROrh5Mfr+8eO+tnjXuA8W0TWozj
	KUYJCOtJOBexJXmjNi145EyLX9F3sUSdwg7EWI4vzj39GoyOlzVw8tmSzODfbDEYGamv5HgHq3Z
	HSJ9pNxPUIV2rn0XCYvG5VAAZ6ytIY3jaQpL3XzIfMB8e3pn7l1S3NzsIM2QsPdwzxgAU23b5z+
	OjxprCm8XV0HlD3dDCC2TH0gz4rT5Yqlk+DV/4nP4NaNftmd9kUnXZGdfSVjgeOdPXOC72Q74pa
	bE13FtpfRODSCK/Y0VAQuffGSk1M9FXuuDQBRpvygPrXtvnzR/GH5I7I2sLWvXNwlLK+98+ywk7
	m04o=
X-Google-Smtp-Source: AGHT+IENFeWTlRHBKQfVzrQa3sAbXULaMTWMg2ks+2bFhONO7WfJ5jywPOr2XrJrrjnaoVRIN+OLTQ==
X-Received: by 2002:a05:6a21:3385:b0:1fa:9819:b064 with SMTP id adf61e73a8af0-2170cb407f7mr29628951637.18.1747838428581;
        Wed, 21 May 2025 07:40:28 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a98a4755sm9964159b3a.179.2025.05.21.07.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 07:40:28 -0700 (PDT)
Date: Wed, 21 May 2025 22:40:24 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Coly Li <i@coly.li>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Robert Pang <robertpang@google.com>, Coly Li <colyli@kernel.org>,
	linux-bcache@vger.kernel.org,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
Message-ID: <aC3l2J0zBj/OnKwj@visitorckw-System-Product-Name>
References: <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
 <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
 <aCWTxp7/t8nnBuzD@visitorckw-System-Product-Name>
 <CAJhEC04qo8CFcFi6tmn9Y28MpasVB93Duboj1gqR1nfOXO+Z2g@mail.gmail.com>
 <aCdkgzPGWzcjXCrf@visitorckw-System-Product-Name>
 <AD23C0A6-E754-4E43-AF54-BCFF82B19450@coly.li>
 <aCxszsXC1QnHYTzS@visitorckw-System-Product-Name>
 <8CA66E96-4D39-4DB1-967C-6C0EDA73EBC1@coly.li>
 <aCx04pakaHTU5zD4@visitorckw-System-Product-Name>
 <79D96395-FFCF-43F8-8CCE-B1F9706A31DB@coly.li>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79D96395-FFCF-43F8-8CCE-B1F9706A31DB@coly.li>

On Tue, May 20, 2025 at 09:13:09PM +0800, Coly Li wrote:
> 
> 
> > 2025年5月20日 20:26，Kuan-Wei Chiu <visitorckw@gmail.com> 写道：
> > 
> > On Tue, May 20, 2025 at 08:13:47PM +0800, Coly Li wrote:
> >> 
> >> 
> >>> 2025年5月20日 19:51，Kuan-Wei Chiu <visitorckw@gmail.com> 写道：
> >>> 
> >>> On Sat, May 17, 2025 at 07:02:06PM +0800, Coly Li wrote:
> >>>> 
> >>>> 
> >>>>> 2025年5月17日 00:14，Kuan-Wei Chiu <visitorckw@gmail.com> 写道：
> >>>>> 
> >>>>> On Thu, May 15, 2025 at 08:58:44PM -0700, Robert Pang wrote:
> >>>>>> Hi Kuan-Wei,
> >>>>>> 
> >>>>>> Thank you for your prompt response. I tested your suggested patch to
> >>>>>> inline the min heap operations for 8 hours and it is still ongoing.
> >>>>>> Unfortunately, basing on the results so far, it didn't resolve the
> >>>>>> regression, suggesting inlining isn't the issue.
> >>>>>> 
> >>>>>> After reviewing the commits in lib/min_heap.h, I noticed commit
> >>>>>> c641722 ("lib min_heap: optimize number of comparisons in
> >>>>>> min_heapify()") and it looked like a potential candidate. I reverted
> >>>>>> this commit (below) and ran the tests. While the test is still
> >>>>>> ongoing, the results for the past 3 hours show that the latency spikes
> >>>>>> during invalidate_buckets_lru() disappeared after this change,
> >>>>>> indicating that this commit is likely the root cause of the
> >>>>>> regression.
> >>>>>> 
> >>>>>> My hypothesis is that while commit c641722 was designed to reduce
> >>>>>> comparisons with randomized input [1], it might inadvertently increase
> >>>>>> comparisons when the input isn't as random. A scenario where this
> >>>>>> could happen is within invalidate_buckets_lru() before the cache is
> >>>>>> fully populated. In such cases, many buckets are unfilled, causing
> >>>>>> new_bucket_prio() to return zero, leading to more frequent
> >>>>>> compare-equal operations with other unfilled buckets. In the case when
> >>>>>> the cache is populated, the bucket priorities fall in a range with
> >>>>>> many duplicates. How will heap_sift() behave in such cases?
> >>>>>> 
> >>>>>> [1] https://lore.kernel.org/linux-bcache/20240121153649.2733274-6-visitorckw@gmail.com/
> >>>>>> 
> >>>>> 
> >>>>> You're very likely correct.
> >>>>> 
> >>>>> In scenarios where the majority of elements in the heap are identical,
> >>>>> the traditional top-down version of heapify finishes after just 2
> >>>>> comparisons. However, with the bottom-up version introduced by that
> >>>>> commit, it ends up performing roughly 2 * log₂(n) comparisons in the
> >>>>> same case.
> >>>> 
> >>>> For bcache scenario for ideal circumstances and best performance, the cached data
> >>>> and following requests should have spatial or temporal locality.
> >>>> 
> >>>> I guess it means for the heap usage, the input might not be typical random.
> >>>> 
> >>>> 
> >>>>> 
> >>>>> That said, reverting the commit would increase the number of
> >>>>> comparisons by about 2x in cases where all elements in the heap are
> >>>>> distinct, which was the original motivation for the change. I'm not
> >>>>> entirely sure what the best way would be to fix this regression without
> >>>>> negatively impacting the performance of the other use cases.
> >>>> 
> >>>> If the data read model are fully sequential or random, bcache cannot help too much.
> >>>> 
> >>>> So I guess maybe we still need to old heapify code? The new version is for full random input,
> >>>> and previous version for not that much random input.
> >>>> 
> >>> 
> >>> I think we have two options here. One is to add a classic heapify
> >>> function to min_heap.h, allowing users to choose based on whether they
> >>> expect many duplicate elements in the heap. While having two heapify
> >>> variants might be confusing from a library design perspective, we could
> >>> mitigate that with clear kernel-doc comments. The other option is to
> >>> revert to the old bcache heap code. I'm not sure which approach is
> >>> better.
> >>> 
> >> 
> >> I prefer to have two min_heap APIs, but how to name them, this is a question from me.
> >> 
> >> Also if the full-random min_heap version has no user in kernel, whether to keep it in kernel also is a question.
> > 
> > From the perspective of the number of comparisons in heapify, what
> > matters more is whether the data contains many equal elements, rather
> > than whether it's truly random. I assume that for most other kernel
> > users, their use cases don't typically involve a large number of equal
> > elements?
> > 
> 
> Yes, you are right.  Maybe dm-vdo also has similar I/O pattern?
> 
> Deduplication may also have duplicated items in heap I guess.
> 

Thanks for pointing out this potential issue.
I'll check with Matthew to confirm.

Regards,
Kuan-Wei

> Thanks.
> 
> 
> >> 
> >> Kent,
> >> Could you please offer your opinion?
> >> 
> >> Thanks.
> >> 
> >> Coly Li
> 
> 

