Return-Path: <linux-bcache+bounces-845-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDB7DA32D55
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Feb 2025 18:24:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6C31164691
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Feb 2025 17:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A2F25C6EB;
	Wed, 12 Feb 2025 17:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="Z2/YY0it"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail50.out.titan.email (mail50.out.titan.email [44.199.128.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC42625A353
	for <linux-bcache@vger.kernel.org>; Wed, 12 Feb 2025 17:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.199.128.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739380989; cv=none; b=iSEQMGfQGlFf46oboxjo2zZO79PUaEAOxRqF+gwC0uSUQWv2pyRMp42aDIa9H8Tgfjlwab+NIz+xweQgRcfP9T4czAZoBA8BJ7e5QiAkjeS7zWE9cv35vmLp0rvVyY1uIm8X9eNQH2ZpjfGEjR5mrmmKWwhmjikSs4qBfjD5g9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739380989; c=relaxed/simple;
	bh=SpJJRsxjvMzoag+/8U/c3dPxqH3msxnbTVJZ4wlWFpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTUYkVPwmFVRLtG8/zEnjugCpaKKNBIHt0DQ6CICn/XEqQXYQxKHzUVPRU66rqVUt1LKaYxyau+u4Ps/77HOcfsyIhGthsIQa/D30Tc2DOV2RPTvvfVaXdBN2427YZmoF0gaT6MatvS/8Zhcy6gNuXyykMaM1o/0xans67gNUa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=Z2/YY0it; arc=none smtp.client-ip=44.199.128.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
DKIM-Signature: a=rsa-sha256; bh=FrA11wHdAjI04fOkpguSq21Hbh1N/QWadWestOlAfEE=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=message-id:in-reply-to:cc:subject:mime-version:date:to:from:references:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1739379988; v=1;
	b=Z2/YY0itkQpuAHSuBStZWWBSpe3G7WEwRFYCa5Ygt41k8G+9COyyfwnU0oyGOEQ/2USAVdSS
	eXjZtSxH+qoG4csIY5vH6et4GxVhXBL7D/dCnRW0GHRXjYkNWzyBHobfOa5v7V2ffu7gbGuJcn8
	lvd8pCfRD/4uLAFKVbPGFhTU=
Received: from studio.local (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 61302E03C1;
	Wed, 12 Feb 2025 17:06:26 +0000 (UTC)
Date: Thu, 13 Feb 2025 01:06:23 +0800
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
To: Julian Sun <sunjunchao2870@gmail.com>
Cc: =?utf-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>, 
	linux-bcache <linux-bcache@vger.kernel.org>, colyli <colyli@kernel.org>
Subject: Re: [PATCH] bcache: Use the lastest writeback_delay value when
 writeback thread is woken up
Message-ID: <mtmlo6kdq52z47fz336anzolmfctrqtzrffqjikqd5ee7jgp5q@pcissxq7yx7h>
References: <20250212055126.117092-1-sunjunchao2870@gmail.com>
 <ALsAXgAaLhNhHzKQW2msV4pl.3.1739343977966.Hmail.mingzhe.zou@easystack.cn>
 <CAHB1Najgakh_J94FZBW1HnYRSTeGbo8TehE3jQ5LKn8D6J8DKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHB1Najgakh_J94FZBW1HnYRSTeGbo8TehE3jQ5LKn8D6J8DKw@mail.gmail.com>
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1739379988088772005.19601.3081821619308659484@prod-use1-smtp-out1004.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=Ntorc9dJ c=1 sm=1 tr=0 ts=67acd514
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
	a=Fqtvuo2cIafZQZ-0i1sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10

On Wed, Feb 12, 2025 at 03:41:54PM +0800, Julian Sun wrote:
> Hi, mingzhe
> 
> Thanks for your review and comments.
> 
> On Wed, Feb 12, 2025 at 3:06 PM 邹明哲 <mingzhe.zou@easystack.cn> wrote:
> >
> > Original:
> > From：Julian Sun <sunjunchao2870@gmail.com>
> > Date：2025-02-12 13:51:26(中国 (GMT+08:00))
> > To：linux-bcache<linux-bcache@vger.kernel.org>
> > Cc：colyli<colyli@kernel.org> , kent.overstreet<kent.overstreet@linux.dev> , Julian Sun <sunjunchao2870@gmail.com>
> > Subject：[PATCH] bcache: Use the lastest writeback_delay value when writeback thread is woken up
> > When users reset writeback_delay value and woke up writeback
> > thread via sysfs interface, expect the writeback thread
> > to do actual writeback work, but in reality, the writeback
> > thread probably continue to sleep.
> >
> > For example the following script set writeback_delay to 0 and
> > wake up writeback thread, but writeback thread just continue to
> > sleep:
> > echo 0 &gt; /sys/block/bcache0/bcache/writeback_delay
> > echo 1 &gt; /sys/block/bcache0/bcache/writeback_running
> >
> > Using the lastest value when writeback thread is woken up can
> > urge it to do actual writeback work.
> >
> > Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> > ---
> >  drivers/md/bcache/writeback.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> > index c1d28e365910..0d2d06aaacfe 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -825,8 +825,10 @@ static int bch_writeback_thread(void *arg)
> >
> > Hi, Julian Sun:
> >
> > We should first understand the role of writable_delay.
> >
> > The writeback thread only sleep when searched_full_index is True,
> > which means that there are very few dirty keys at this time, all
> > dirty keys are refilled at once.
> >
> >                         while (delay &amp;&amp;
> >                                !kthread_should_stop() &amp;&amp;
> >                                !test_bit(CACHE_SET_IO_DISABLE, &amp;c-&gt;flags) &amp;&amp;
> > -                              !test_bit(BCACHE_DEV_DETACHING, &amp;dc-&gt;disk.flags))
> > +                              !test_bit(BCACHE_DEV_DETACHING, &amp;dc-&gt;disk.flags)) {
> >                                 delay = schedule_timeout_interruptible(delay);
> > +                               delay = min(delay, dc-&gt;writeback_delay * HZ);
> > +                       }
> >
> >
> > > So, I don't think it is necessary to immediately adjust the sleep time
> > > unless the writeback_delay is set very large. We need to set a reasonable
> > > value for writable_delay at startup, rather than adjusting it at runtime.
> > >
> 
> I understand your point, but I still believe this is important.
> IMO, since /sys/block/bcacheX/bcache/writeback_delay allows adjusting
> the writeback_delay value at runtime,  bcache should ideally support
> this functionality. Otherwise, the current behavior may be confusing
> for users: "I've adjusted it, but why does it seem ineffective?" :)
> 

Hi Julian,

Correct me if I am wrong. I feel maybe that you misunderstodd the
functionality of sysfs parameter writeback_delay. It is NOT used to
control the writeback rate. 
You may want to check Documentation/admin-guide/bcache.rst at,

468 writeback_delay
469   When dirty data is written to the cache and it previously did not contain
470   any, waits some number of seconds before initiating writeback. Defaults to
471   30.

Thanks.

-- 
Coly Li

