Return-Path: <linux-bcache+bounces-497-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9693D8D1410
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 07:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 438461F2290F
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 05:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69413EA83;
	Tue, 28 May 2024 05:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ViJYGIUS"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3051CF4EB
	for <linux-bcache@vger.kernel.org>; Tue, 28 May 2024 05:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716875462; cv=none; b=i5+iUspVtJ/oV1r2QrDRtNc0WZFpgVB+NTt3xevqJrhfmiwe1le/Xf5rV6kUX+BEECQY+TGVN51WKVRFwCQIgvaxm0Qk79deB8nMtMc1yRjYs8HNfIYgeXfR4hT4iVREzev8otTRSkmb0kLFotjWJMx0OKjpRShf427sEC4ZlNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716875462; c=relaxed/simple;
	bh=OSCm1Ipw6mBsTZJqpNUoxxjXJmB2T2lSrLK7JP6y6Io=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hc2DHKb5WhU7c5Bt+JtP6u1yGeq+MJ+wm6YL4AvikMIGncKydFQajIuLxaZdR+DJpEzc0SiZf2jyDQFtARhdvZzbb/0w98pcQwigBZtUIsW+op/YK6dqpV8PGgHnkRt4IBIQA/75CphPiRTyhyyxmURydXLfUsFNW/YPyYyOG7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ViJYGIUS; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-57863da0ac8so20565a12.1
        for <linux-bcache@vger.kernel.org>; Mon, 27 May 2024 22:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716875459; x=1717480259; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onGkmTjJSSziFcivyttH2YZ+/HDgvUqHM2OeKSFcrwM=;
        b=ViJYGIUS+ybILmEpL9PIeN0DfgfdmlmBdrvOiM7OkwuyMNxYVdRU5FMxY+CKLNTFnU
         6JAs3bOTGxOMHbTl4ozz7q3ENm0LIzZ+9gsQmyziSolK04iwFBOeTvCmDkepRfujWi4Q
         svWQ6EHngDV6m3s7oPaOsFH+oFLvc3tihZD/cP3lDeM6IdXkZNjftTTGxNCiilwRtK5K
         ixBhy+6QTim3g9Q+X1617UpORfF7nEjBG5WJwMqBsJMHReYgAi8MUJVdrsnDt51BTH2v
         f+Osdyk30kCE3OtUHlixq0vAM3KsXwd0oJdaYK869B5PE4FguerdyidZug/P0qtdOLvd
         dn2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716875459; x=1717480259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=onGkmTjJSSziFcivyttH2YZ+/HDgvUqHM2OeKSFcrwM=;
        b=I4gNQ9YVewZGx6+2/2A3Faw3RnWFEDF+yGFKR1874q2cteu2fn/dFx3b3+lpsIRBQ5
         jzDAYCE1hg9xGVpNLhk5/Zq6VcKRdnaKqeenC/CT37Tykn4xLbCmgiS10tLMqbu/vYcW
         rCeYGJUmbgtyfYFIi+5sxUDccZ813yq0fdf4hiyCbC8gE33hQ5MQsBdazdZoU6grZV92
         tFCm5wediC5AmjD3q2Dl1rvqmnIi8dOxEqTvXZ8R3vp1fFyKyY9m6xp70ILtWllg56GW
         eueD1L7DWWuMOi4HjNXosNZyqoYmH4Nj8NUuYSGumB5Z3PsCYEadFZ/vg0v2J1mgmY6H
         FUSg==
X-Forwarded-Encrypted: i=1; AJvYcCV8f6fNFf+dLRoK4v6+U7RNEz2QBVfht8GpDddAGZch/68UQutxy6m13+7trePxsgO6ZqlzhpV4j6XC+4RDJ92GvxEoVEqen2RMu+Lx
X-Gm-Message-State: AOJu0YzksCu2p/zTnBIy//MA3WNX6bKrnkK/QjSbe6foLgmbEuNVHl4W
	DtrTdhqRe2csRlfr+F2ggreoUhFVESKX6xsNNyE378y+MN0vB5r4NT5aOZdMd3xJ2CO1LvkLhND
	D3KxrvBvH4FKkPfuPv31FkZtPyHcpj+5FFCKucUM9/ds1PwBd2ML3
X-Google-Smtp-Source: AGHT+IFOwK/HDJp+YVuJ5T+yCUekbutUhNcG7S2KXL28tjEWs8FhYpHlRwdgw9v94hfWYHPkSydzZoJjoWYJ2XpgWsM=
X-Received: by 2002:a05:6402:1d27:b0:578:5f77:1e77 with SMTP id
 4fb4d7f45d1cf-578673f6657mr337466a12.0.1716875459131; Mon, 27 May 2024
 22:50:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de> <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de> <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
 <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de> <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
 <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com>
 <1B20E890-F136-496B-AF1F-C09DB0B45BE8@suse.de> <CAJhEC06FQPw3p7PHJpjN13CVjibbBVv-ZhwBb_6ducJP+XJ3gg@mail.gmail.com>
 <xbm4drbn7hdxedptocnc77m53kce3jdaedsvxh7dcwts7yivjx@jbvhh43wd3tp>
 <9c197420-2c46-222a-6176-8a3ecae1d01d@ewheeler.net> <3E11DC5E-92D1-43FF-8948-B99F665E445D@suse.de>
 <CAJhEC07Pdea5XKyMLVw=GeBZksNWoWpCmHs7shBPcgW3OoDonw@mail.gmail.com> <F310CA03-432E-4C8A-8054-EAF1BA5E8F12@suse.de>
In-Reply-To: <F310CA03-432E-4C8A-8054-EAF1BA5E8F12@suse.de>
From: Robert Pang <robertpang@google.com>
Date: Mon, 27 May 2024 22:50:45 -0700
Message-ID: <CAJhEC06ro134BKQ_41TLpbsQNE+WwiMpoxrSc3UpA3CF1VX_Fw@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Coly Li <colyli@suse.de>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Dongsheng Yang <dongsheng.yang@easystack.cn>, 
	=?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>, 
	Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 27, 2024 at 11:14=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
> > 2024=E5=B9=B45=E6=9C=8824=E6=97=A5 15:14=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Coly,
> >
> > I hope this email finds you well.
> >
> > I wanted to express my appreciation for your work.  I was curious if
> > you've had a chance to submit the patch yet? If so, would you mind
> > sharing the link to the Git commit?
> >
>
> The fix from me is posted on linux-bcache mailing list just a moment ago.

Thank you for that fix also. Appreciate your diligence in resolving
this stuck bypass.

> > The reason I ask is that some downstream Linux distributions are eager
> > to incorporate this fix into their upcoming releases once it lands.
>
> Can I know which Linux distributions are waiting for this? Just wonder an=
d want to know more Linux distribution officially bcache.

It is the Container-Optimized OS.

https://cloud.google.com/container-optimized-os/docs/legacy-release-notes#g=
ci-dev-54-8711-0-0

> > Any information you can provide would be greatly helpful in
> > coordinating those efforts.
>
>
> The test and code review from my side are done. It is in my for-next bran=
ch,  I will submit them to upstream soon if no complain from kernel test ro=
bot.

Great to hear that. Any estimate when the test will finish and the
patch can submit?

Best regards
Robert

