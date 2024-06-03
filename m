Return-Path: <linux-bcache+bounces-506-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DA4C8D7C22
	for <lists+linux-bcache@lfdr.de>; Mon,  3 Jun 2024 09:04:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5851F28436E
	for <lists+linux-bcache@lfdr.de>; Mon,  3 Jun 2024 07:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD2E39850;
	Mon,  3 Jun 2024 07:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HHTzZ8JN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D994AEF2
	for <linux-bcache@vger.kernel.org>; Mon,  3 Jun 2024 07:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717398262; cv=none; b=tNvfVO78h52L8eKDX5pX/Kb/w6iC2FavbXXk3BJ1HciszARj5V9h+GVWtBES9PbXu3e4hA5eUN9JEXc5rLHEQZybaVjcTSbajA/0hCoqTidILYMBBLHxYU4MOJlwHR/OCgw02NHPmPZns56GSHn6dWb3paHqfJiyGXDaNmoRk90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717398262; c=relaxed/simple;
	bh=EQpBVA3iYYvQj2cME3rxaw4If5OVTesvhnu5Usf/qGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lHVzIOnlU4qPRwN66v2aMm4DI4kf1BbURJmFA7tLpCaE1qATgcnGriDTE0LJo+z8J+o9d3cl45U1ye+W7L1UQXyDiaCCnP3JXybSwH55DEFhW4MsSW6h/PG2ML2cUe6I011bhmY/imnOt+6SZn+Wrt07N0UXXJbQWMq3/zDfFOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HHTzZ8JN; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42135a497c3so63775e9.0
        for <linux-bcache@vger.kernel.org>; Mon, 03 Jun 2024 00:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717398259; x=1718003059; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQpBVA3iYYvQj2cME3rxaw4If5OVTesvhnu5Usf/qGU=;
        b=HHTzZ8JNSScfDAmETA8RcSMszJHAK3vAzxkm8/4VcWySUi4SGxIQvIFnU+HOIRdLBJ
         yPrvJknClAHQqT3vSZUwr58xVMrmrVc8jTC9taABZwoZuC7QnwRnvCLGx45cIZcrutWb
         49tVHguT7dYxAqOBiFP87qDDesdKj8pazLbDfiuNse4ZlHkJhDy3IKApBvRNGvKzrG6+
         rSX2AHXXp3Y+8W9IjgK5+Dj/wBm24ntMApCNt7Vh2BwXrXD3hOVr4lfextbHvuUXUwz1
         lo46+SQcOI2eyVrE2lB/E2m/irIxWw3MCfd79PnE8+uMMwsNZ7XVNcIIWFcJ2CX3YpXX
         PeIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717398259; x=1718003059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EQpBVA3iYYvQj2cME3rxaw4If5OVTesvhnu5Usf/qGU=;
        b=DQibz3QiI9/0GeAJVKyfWLqqAR0j7BPH3tRpKgwC/C+yhOUUDcX3yOf9oTzObTQOL1
         +FTpuOeSE58AqtoX9Rxm1shbLxiNvetJ0hnVpEP7iAgfiMMb3oGBbT/VRXBnWZfEBrzj
         tagc0SNiu3CA05jy4ht5Ma9Mmi+VBr5eii52KfFQfsI91bhcNYsNgyI3ZoYTlTMUt4Rd
         IVN5qY6l5eO4Fh8nPM4L/AkLcqgsmSqn49noNP14xlsJrKG7wMOLRPP3KIm746YL2RtC
         884PugkNhw3o5u0ptH7wDmwAoFcoDXgOfWQmKj6eslg+dyLnONYa3VG1dN6hjQ2iL0oE
         62Xw==
X-Forwarded-Encrypted: i=1; AJvYcCVkSDcO4eYsBwz8jaSJMSRj0Rvy2/mDeQgX7n45yaiSuQ9idbTmMgCs8nzlRRscKHdMbCNJAiclJhEwFeV3F4J97SwPAUf7tF57eKyC
X-Gm-Message-State: AOJu0YzG/gEurmGEmbvhT23G1opMhAsafdkKGaVZ3bfK75nl+hvfJ8if
	UCe3vaR/nzRt7qxIibryjH/zL1sQQk18UP6eGMFc+03rNIXv47qZnljivl3PcxXnRK/7KFeEk3M
	aohG9JAzgPUk/VBrzT1/l8URQqmHTpR0kR1tLCM7eL+QtXbGGe8D8
X-Google-Smtp-Source: AGHT+IGooPDdXOb9Xx53ktdMqKMv3DO7jStpsOX+iIqeKOKjVtmULU2LsNRDn2radt4OO+IflyoG5EeIvF0ARX+GlPY=
X-Received: by 2002:a7b:c8d0:0:b0:41f:9dd0:7168 with SMTP id
 5b1f17b1804b1-42134ed7084mr3066795e9.2.1717398259180; Mon, 03 Jun 2024
 00:04:19 -0700 (PDT)
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
 <CAJhEC07Pdea5XKyMLVw=GeBZksNWoWpCmHs7shBPcgW3OoDonw@mail.gmail.com>
 <F310CA03-432E-4C8A-8054-EAF1BA5E8F12@suse.de> <CAJhEC06ro134BKQ_41TLpbsQNE+WwiMpoxrSc3UpA3CF1VX_Fw@mail.gmail.com>
 <355ABD73-04C8-45AF-9F8D-D912DABCA716@suse.de>
In-Reply-To: <355ABD73-04C8-45AF-9F8D-D912DABCA716@suse.de>
From: Robert Pang <robertpang@google.com>
Date: Sun, 2 Jun 2024 21:04:07 -1000
Message-ID: <CAJhEC05LuV8m8EMTgvoi0uP-rAU-AbB2tzkiVk15_mpZPfcipQ@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Coly Li <colyli@suse.de>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Dongsheng Yang <dongsheng.yang@easystack.cn>, 
	=?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>, 
	Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly

I am pleased to see 6.10-rc2 released today with this patch. I really
want to thank you and Dongsheng for this patch and your contributions
to bcache. Much appreciated.

Best regards
Robert

On Wed, May 29, 2024 at 6:24=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
> > 2024=E5=B9=B45=E6=9C=8828=E6=97=A5 13:50=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Great to hear that. Any estimate when the test will finish and the
> > patch can submit?
>
> It is in linux-block already, will be in next -rc quite soon as expecting=
.
>
> Thanks.
> Coly Li

