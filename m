Return-Path: <linux-bcache+bounces-1157-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C68B0970D
	for <lists+linux-bcache@lfdr.de>; Fri, 18 Jul 2025 00:53:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9327C1C4725E
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Jul 2025 22:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534B3238142;
	Thu, 17 Jul 2025 22:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xRMJnpCU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5A21DE4E1
	for <linux-bcache@vger.kernel.org>; Thu, 17 Jul 2025 22:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752792793; cv=none; b=qUJyYa45XIZYWIQy/YHCHQrZ9hojx55rWTFPLfmoZaeYpSlsIHC8z6hkmN02xw9XPZnr/9d676vae42TXp0evTwz41JRVbHX6yxcoXgeVi49MdnjIU/QIlJ5WhvHIphJEtaI1tmXi91YFpmSxlwzyZDrpK25z/z71YJdgOiCEgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752792793; c=relaxed/simple;
	bh=wlsHPd3EmOSbq8fvn8s3/PwSghxL6c9CMGZTIV1Uir8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sMVwqLrh+C9IlZUIFDb7FbXQHZDJossqCEgarzLZj4VuQbop2JAzAY/DyC0pqfTCjZkrvtELzXQYu3h+v47tGRiVyuywJsjRTsn95OZUrPpDpdjLB/mBODTln9uleNyscAzh0Y9UZMx4rLnm0pmVOUMUbm9GK5DvSkfbHytme5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xRMJnpCU; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab86a29c98so169551cf.0
        for <linux-bcache@vger.kernel.org>; Thu, 17 Jul 2025 15:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752792790; x=1753397590; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OeVupfoy40zkjAVZI/F50owmOt7715ML1iwKt/3cBs0=;
        b=xRMJnpCUFAQmGollRKpb/CYbUHAqLzvT5aWA8x3zDSO+1UMCYQVhxtwEjMFfn/tPOk
         3uOEfw9J86KkU1sO3qKQfQomrsUyPrmdGu+rBF1/QQ8JXeJ+bDFdSboPHigaOgjhItAE
         wQAYl7bN9pxjteSaLk5NTyXm+SHN032i7v76QfEVBeWUVAo8yaxz3g3T54FEgzkiBq1A
         f/Luhv7VluHAeG1FFJmXmw3rac4spqZge1Jzxn8cD7zNoUcYfyEIRvqxD2zv8pdFPu35
         rZAdjsQAaZyjpfhpVBgzMm46LbziHwctBiV6x5LfCdMzAvCE0UXiJnCxkT+oMpAhLWHK
         DZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752792790; x=1753397590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OeVupfoy40zkjAVZI/F50owmOt7715ML1iwKt/3cBs0=;
        b=HRa+JZKxZ8JzLqzD0BeeNE1F4ylYyQ8q8YJIXzhWqYaDikBvedxWA9DE5cwn+Zpz39
         rSHO3ECyhcdpr2Mz8yuZ5EExF5OiKd63xUdjWJVDmzOsi2H/HrOg8azmv9pfg7Ztq2Y0
         GoVvB9fWDdccuFOputz0brkU+ODSrtF6tm3tCP25yD31omBY7wwXq/V28cOf033zt0F9
         6MlKj2wYzYeUkSh615uWCfxs8oeJwM3p/wNI7m0N51VMsZtbT77iC0dFEvsXNUs9yz+U
         IHR4fyJeQlQmhZzEabW1lOyn/fU5C+lTPG/uKyelEtAUgl9s1fXJJ9d+zyegjV+5uYxN
         KiKA==
X-Forwarded-Encrypted: i=1; AJvYcCWZTmnKNDf8PpC7/KcMusaavEhT5wtj3ibf7+9nSHFmQXJ8ArtWFnmo1jXx8jc6FDDiQWI+mG0GXFFBzQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzkBE5y3zwztfd6DVYiNlMvzbqbFo7Vt+mJLvpQu2whtsy0lDk
	jwsC6zkNAKN1iop8ej4+ZdO/5PEswy0ZYHd4sPGJlcokXfrwPlhTs8rghTEBNk5QeLWNZo6kUT3
	MJLkytf8eu18Ts2R9I00qIDm07BsWwMtIA+dpnZXp
X-Gm-Gg: ASbGncvDZOoq6DFS2t20p0kxMFsEdOJtk6l8HnOanXprJlBselHGkocbb2lxkqdlc7F
	fdLuP8ylcNAlSunihS/TJFjIvc1V8wHhmSJ2Jf0XRh5KLx4si0j35u47gGwqO/GEHCYEOm8qmoX
	4F/5CaYjGuIAXXHFWmk0zPUijl9Njw6xOXJgpdl5ToYu35yaeR+PSIBO1WB0mjmx+wlmaKS1rmT
	1Tjkw==
X-Google-Smtp-Source: AGHT+IEY1E28B93GbCtVr/CoLL/qFAS7RbCgZnkeGvctSgY+yLv2dWW3qmMpTdNBA6FeOmyLKCEWtWJ6Eim24YdR2Gw=
X-Received: by 2002:a05:622a:8596:b0:4a9:8b69:6537 with SMTP id
 d75a77b69052e-4abb147e8fbmr1766731cf.22.1752792790247; Thu, 17 Jul 2025
 15:53:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414224415.77926-1-robertpang@google.com> <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
 <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
 <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
 <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
 <CAJhEC05tF6zthgSD2VmUHap2kYGgTWXz+uq4KOrGg_GAV_KKQQ@mail.gmail.com>
 <10F3457F-FC71-4D21-B2CA-05346B68D873@coly.li> <A52B16E2-DF9C-4C8A-9853-464385D1A7FA@coly.li>
In-Reply-To: <A52B16E2-DF9C-4C8A-9853-464385D1A7FA@coly.li>
From: Robert Pang <robertpang@google.com>
Date: Thu, 17 Jul 2025 15:52:58 -0700
X-Gm-Features: Ac12FXybxv5h0t8mBqK6hSd7ftL0lWta2Us4bW1pCbx4Wz4SzDUckTT4Cr3Fv8Q
Message-ID: <CAJhEC06jacpCiautzfmnXUmt8x2d2nv-hEgmjnVX9yriDiV45Q@mail.gmail.com>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
To: Coly Li <i@coly.li>
Cc: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, Mingzhe Zou <mingzhe.zou@easystack.cn>, 
	Kuan-Wei Chiu <visitorckw@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly

>> With the min heap regression addressed by the recent revert [1], I am
>> going to initiate a rerun of our last test set [2]. I will share the
>> results as soon as they are available.

My apologies for the delay in sharing the results due to my work schedule.

I've completed the rerun of the tests, and the results are available
for your review in [1]. As expected, the data confirms the desired
latency improvements. Furthermore, I've checked for any unintended
side effects and can confirm that no regressions were observed.

Please take a look and let me know what you think. If there are any
other specific scenarios or tests you would like me to execute to
further validate the changes, please don't hesitate to let me know.

Best regards
Robert Pang

[1] https://gist.github.com/robert-pang/a22b7c5dee2600be3260f4db57e5776d#fi=
le-test-results-md

On Thu, Jul 3, 2025 at 9:47=E2=80=AFAM Coly Li <i@coly.li> wrote:
>
>
>
> > 2025=E5=B9=B47=E6=9C=883=E6=97=A5 23:34=EF=BC=8CColy Li <i@coly.li> =E5=
=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Robert,
> >
> >> 2025=E5=B9=B47=E6=9C=883=E6=97=A5 23:28=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> Hi Coly
> >>
> >> I'm writing to provide an update on this bcache GC latency patch.
> >>
> >> With the min heap regression addressed by the recent revert [1], I am
> >> going to initiate a rerun of our last test set [2]. I will share the
> >> results as soon as they are available.
> >>
> >> To ensure this patch is fully qualified for the next merge window, I'm
> >> eager to perform any further tests you deem necessary. What additional
> >> test scenarios would you recommend?"
> >>
> >
> > Can you also do some full random write (4K and 64K block size) performa=
nce testing?
> >
> > If there is no performance regression (and I believe improvement will b=
e observed), then let=E2=80=99s go ahead.
>
> BTW,  I don=E2=80=99t commit that this patch will go into next merge wind=
ow.
>
> Thanks.
>
> Coly Li
>
>
>

