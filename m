Return-Path: <linux-bcache+bounces-1105-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 559ADAD0253
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 14:37:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1084A1620DB
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 12:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643C423BD06;
	Fri,  6 Jun 2025 12:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrKEag6Q"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B901F2356B9
	for <linux-bcache@vger.kernel.org>; Fri,  6 Jun 2025 12:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749213462; cv=none; b=j6sbix5ribdC0TGDb1kjCKgLIB/5yTnO9Go+uEp25vP9vmY6KDdr0jj3lRb3rknee/voDFMuj2kIDn6n3a+jCVdACGm3nJN8o3Pp6TXJMHFuVeGR04e+vm4jmVg1+TNN9Az2pA+9iLvDBDkjB//J4YaMwsnBzve0FcfbPxP1yoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749213462; c=relaxed/simple;
	bh=P69Ni/fRyPajJFI9txu392s2F0dUPljqKUi4lk6TibY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VaTY/e8vrklZaj0K2To94k5NAcFBszFahSJtBPBUmjbawCxSsqpu5copMeCPBnEO9zKI0FKRG5PJewE4bCVlGtNQqVV8NiDFA3/0hGNVNsNVms7lF9kSylFtEpMg+0gDVXDbbjxtrJu3gKWf75YummcbTKBGdjJDKxvatwNiJG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XrKEag6Q; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-742caef5896so1825402b3a.3
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jun 2025 05:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749213460; x=1749818260; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DyDf7iV37J0LIKHyjGt7g4wsqKVb8cLGrZSCutrIjSo=;
        b=XrKEag6Q3VFOxCqFZWZ6YsIsCHcdlk6r+MjXQkk81rvC17hXEyb5wSUZ/IPLtdoZ+D
         yLQ0anx3vifCYQ4UjzMIYKR7sYakTJFIQWdkHjusqkY6lYTPYddHH3CNvviquxpwdXFT
         +ShQB7tfWj3J5D9sJjKWq1ovKz4rWcbh0KWk96z++XL/PjyKKS+bKdTrbPtText4Ejai
         oasJgWw2879p/YO9DLFSROERr+uN8wFqSnOfsTgJzMGH4eRmMNI0zOOwU4KyDzy9bAIe
         2JmgpZPpep5Z2u6T97CMcRN53I7rd3r0QVYt04yGoOiQ5B8h6Hq7w9uUzUdmNlWBEqxU
         DzIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749213460; x=1749818260;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DyDf7iV37J0LIKHyjGt7g4wsqKVb8cLGrZSCutrIjSo=;
        b=oBFgtHI10XtdhWvA66Prw3cDUY7yrEFWaYIq1HtZv5rdoWucwXakvYlIECEumQXUNZ
         zRrGDG4F4qkSogVcP8muM4gVV623M3gxIUIZgi1U9reYq8fLgIYHItDqgFh7HUDsYb/i
         D2PRlV1FM19WrQLomZO1YEqN3FdyyPXp5VP3UvANtkOk7F/4akUL18kifuR2vKuAMjGM
         UrPCiAmzGbDAsGAD6Le8bQjrXpu0s4t38PfiNVNSgVb7pzQBFPyBufmOiTy3+Ar1gEIH
         gVREGJSWqglOA+ttvm6Fn7+XwLJ4hwZNsDuB+bgxUOEbKgci4Cu0ZFfAzuW1Q992OQ3V
         XEOA==
X-Forwarded-Encrypted: i=1; AJvYcCXnxsViU3jpYqtE+DDJ64FsASXWiBLE9Mfc1CKc93casyi6YZgGjBl/kEWorLZXARvYNRVrExCdNMVzEuA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9uYELkaf6lYNnnJtHGqxgWf55deJnba09usquTZs95aoG7GKm
	EMtvLKs4RMBNoFt8fVnsDIXa8V3MPzDLp8MG3F+O9Jr7YankVBG2pfYV
X-Gm-Gg: ASbGncstBpr8Qsq9nY1OadwLRaQ6CkIUw/ytIKl4zNH5w+LkDXeeTUxJ3t84YVLP+zR
	P6WwXxIwj/UtzUI3VqsRV5KI9Qs1Dn5vr1bFa4G6ygUEE+Y1iQwRRMhshggIAwui1ey2OoHpONG
	rzGVZfMITWRJnhCFXfRtn/UFEeYPcf5rE7s+klnx60MxuyU2YD+ClSlUCmj8nhkzW1aWqvdnQ4U
	IPmxGO9hXcbNFJ/+dSi0xzPT0980Fj06Ea+wXtYhRlU861r3OHEDr6kYYGWL1C5KAe2sNouEwFi
	mB+NE6M059mbs1dKCrHOJOyp6hrJbDo1al4PnG69oSUFitU7FzxZ4JGIKNFOUAiSVEziY058Hxe
	vJSp4itMyWNYxjQ==
X-Google-Smtp-Source: AGHT+IFDtgsQ7T2PsCvrCzHdWhWo9QoHlLPvHW/ThGulRLYAfzDTkhbe3p4frkGPMs1x71/lrflmPQ==
X-Received: by 2002:a05:6a00:710f:b0:748:2e7b:3308 with SMTP id d2e1a72fcca58-7482e7b5a0emr1778932b3a.6.1749213459691;
        Fri, 06 Jun 2025 05:37:39 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b0e8163sm1218432b3a.145.2025.06.06.05.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 05:37:39 -0700 (PDT)
Date: Fri, 6 Jun 2025 20:37:34 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Robert Pang <robertpang@google.com>
Cc: Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@linux.dev>,
	Coly Li <colyli@kernel.org>, linux-bcache@vger.kernel.org,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
Message-ID: <aELhDsIqAJhglud6@visitorckw-System-Product-Name>
References: <aCWTxp7/t8nnBuzD@visitorckw-System-Product-Name>
 <CAJhEC04qo8CFcFi6tmn9Y28MpasVB93Duboj1gqR1nfOXO+Z2g@mail.gmail.com>
 <aCdkgzPGWzcjXCrf@visitorckw-System-Product-Name>
 <AD23C0A6-E754-4E43-AF54-BCFF82B19450@coly.li>
 <aCxszsXC1QnHYTzS@visitorckw-System-Product-Name>
 <8CA66E96-4D39-4DB1-967C-6C0EDA73EBC1@coly.li>
 <aCx04pakaHTU5zD4@visitorckw-System-Product-Name>
 <79D96395-FFCF-43F8-8CCE-B1F9706A31DB@coly.li>
 <aC3l2J0zBj/OnKwj@visitorckw-System-Product-Name>
 <CAJhEC07ZZrLYbGq5D+iB2G_a2LNn=fnTMAaZzXg3qzdVBoJFsA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJhEC07ZZrLYbGq5D+iB2G_a2LNn=fnTMAaZzXg3qzdVBoJFsA@mail.gmail.com>

On Fri, Jun 06, 2025 at 12:39:52AM -0700, Robert Pang wrote:
> Hi Kuan-Wei,
> 
> I'm circling back on our plan to address this regression. Based on our
> discussions to-date, it seems a separate min_heap API that uses the
> conventional top-down sift-down strategy is the preferred approach.
> 
> I've prototyped this idea and sent out a patch series [1] to kick off
> the discussion on this approach. The patch has been running for over
> 12 hours and is looking promising. The API name is only my initial
> thoughts and suggestions are welcome.
> 
> Given that this regression was introduced in Linux 6.11 and affects
> versions up to 6.15 (including 6.12 LTS), a timely solution will be
> important.
> 

I'm terribly sorry for not submitting the patch to fix this regression
earlier. I had something drafted, but I got sick, and the issue
unfortunately slipped off my radar and I ended up forgetting about it.

Regards,
Kuan-Wei

> Best regress
> Robert Pang
> 
> [1] https://lore.kernel.org/linux-bcache/20250606071959.1685079-1-robertpang@google.com/T/#t
> 
> 
> On Wed, May 21, 2025 at 7:40 AM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> >
> > On Tue, May 20, 2025 at 09:13:09PM +0800, Coly Li wrote:
> > >
> > >
> > > > 2025年5月20日 20:26，Kuan-Wei Chiu <visitorckw@gmail.com> 写道：
> > > >
> > > > On Tue, May 20, 2025 at 08:13:47PM +0800, Coly Li wrote:
> > > >>
> > > >>
> > > >>> 2025年5月20日 19:51，Kuan-Wei Chiu <visitorckw@gmail.com> 写道：
> > > >>>
> > > >>> On Sat, May 17, 2025 at 07:02:06PM +0800, Coly Li wrote:
> > > >>>>
> > > >>>>
> > > >>>>> 2025年5月17日 00:14，Kuan-Wei Chiu <visitorckw@gmail.com> 写道：
> > > >>>>>
> > > >>>>> On Thu, May 15, 2025 at 08:58:44PM -0700, Robert Pang wrote:
> > > >>>>>> Hi Kuan-Wei,
> > > >>>>>>
> > > >>>>>> Thank you for your prompt response. I tested your suggested patch to
> > > >>>>>> inline the min heap operations for 8 hours and it is still ongoing.
> > > >>>>>> Unfortunately, basing on the results so far, it didn't resolve the
> > > >>>>>> regression, suggesting inlining isn't the issue.
> > > >>>>>>
> > > >>>>>> After reviewing the commits in lib/min_heap.h, I noticed commit
> > > >>>>>> c641722 ("lib min_heap: optimize number of comparisons in
> > > >>>>>> min_heapify()") and it looked like a potential candidate. I reverted
> > > >>>>>> this commit (below) and ran the tests. While the test is still
> > > >>>>>> ongoing, the results for the past 3 hours show that the latency spikes
> > > >>>>>> during invalidate_buckets_lru() disappeared after this change,
> > > >>>>>> indicating that this commit is likely the root cause of the
> > > >>>>>> regression.
> > > >>>>>>
> > > >>>>>> My hypothesis is that while commit c641722 was designed to reduce
> > > >>>>>> comparisons with randomized input [1], it might inadvertently increase
> > > >>>>>> comparisons when the input isn't as random. A scenario where this
> > > >>>>>> could happen is within invalidate_buckets_lru() before the cache is
> > > >>>>>> fully populated. In such cases, many buckets are unfilled, causing
> > > >>>>>> new_bucket_prio() to return zero, leading to more frequent
> > > >>>>>> compare-equal operations with other unfilled buckets. In the case when
> > > >>>>>> the cache is populated, the bucket priorities fall in a range with
> > > >>>>>> many duplicates. How will heap_sift() behave in such cases?
> > > >>>>>>
> > > >>>>>> [1] https://lore.kernel.org/linux-bcache/20240121153649.2733274-6-visitorckw@gmail.com/
> > > >>>>>>
> > > >>>>>
> > > >>>>> You're very likely correct.
> > > >>>>>
> > > >>>>> In scenarios where the majority of elements in the heap are identical,
> > > >>>>> the traditional top-down version of heapify finishes after just 2
> > > >>>>> comparisons. However, with the bottom-up version introduced by that
> > > >>>>> commit, it ends up performing roughly 2 * log₂(n) comparisons in the
> > > >>>>> same case.
> > > >>>>
> > > >>>> For bcache scenario for ideal circumstances and best performance, the cached data
> > > >>>> and following requests should have spatial or temporal locality.
> > > >>>>
> > > >>>> I guess it means for the heap usage, the input might not be typical random.
> > > >>>>
> > > >>>>
> > > >>>>>
> > > >>>>> That said, reverting the commit would increase the number of
> > > >>>>> comparisons by about 2x in cases where all elements in the heap are
> > > >>>>> distinct, which was the original motivation for the change. I'm not
> > > >>>>> entirely sure what the best way would be to fix this regression without
> > > >>>>> negatively impacting the performance of the other use cases.
> > > >>>>
> > > >>>> If the data read model are fully sequential or random, bcache cannot help too much.
> > > >>>>
> > > >>>> So I guess maybe we still need to old heapify code? The new version is for full random input,
> > > >>>> and previous version for not that much random input.
> > > >>>>
> > > >>>
> > > >>> I think we have two options here. One is to add a classic heapify
> > > >>> function to min_heap.h, allowing users to choose based on whether they
> > > >>> expect many duplicate elements in the heap. While having two heapify
> > > >>> variants might be confusing from a library design perspective, we could
> > > >>> mitigate that with clear kernel-doc comments. The other option is to
> > > >>> revert to the old bcache heap code. I'm not sure which approach is
> > > >>> better.
> > > >>>
> > > >>
> > > >> I prefer to have two min_heap APIs, but how to name them, this is a question from me.
> > > >>
> > > >> Also if the full-random min_heap version has no user in kernel, whether to keep it in kernel also is a question.
> > > >
> > > > From the perspective of the number of comparisons in heapify, what
> > > > matters more is whether the data contains many equal elements, rather
> > > > than whether it's truly random. I assume that for most other kernel
> > > > users, their use cases don't typically involve a large number of equal
> > > > elements?
> > > >
> > >
> > > Yes, you are right.  Maybe dm-vdo also has similar I/O pattern?
> > >
> > > Deduplication may also have duplicated items in heap I guess.
> > >
> >
> > Thanks for pointing out this potential issue.
> > I'll check with Matthew to confirm.
> >
> > Regards,
> > Kuan-Wei
> >
> > > Thanks.
> > >
> > >
> > > >>
> > > >> Kent,
> > > >> Could you please offer your opinion?
> > > >>
> > > >> Thanks.
> > > >>
> > > >> Coly Li
> > >
> > >

