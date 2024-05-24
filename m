Return-Path: <linux-bcache+bounces-472-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 838808CE165
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 09:14:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B591C1C20F2F
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 07:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985BC128814;
	Fri, 24 May 2024 07:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MINNwwRB"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A45128374
	for <linux-bcache@vger.kernel.org>; Fri, 24 May 2024 07:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716534857; cv=none; b=c5WDzLFvgJQPr9onrUP/XWMaXRRcRqgW3xSf4+/o0VQnUWWiWYmZidmvmnPHgLep5LVZeuvXR52WnGQcl1wu9bKN9PoW2aXlPzEMpSO3E/dqI+o/DxexHnLUdZ3/52c38W1d263CjlK/8RA9pEqE9KuG89PbOaKsfUuTBJ9ExR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716534857; c=relaxed/simple;
	bh=7lyrMzRLi2grTQui81vKwkKGRK5hKB2lsZESQHcWb00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ROC8J2iAO9So+ZnMMstZYcs5sGRGFuSMnsF7OQqOTQVWiKP0U3mC0ktT1d761/39gm/71mWEgpi2sRALix13n3UxJ4SIVaaGzh+K6Zf9ZKaACN9Lwp83yW5Olr4e2fbvEZt4rDq8IIeGDuwvNEdgYKNV8isDwq9NZ7wCd+Ef9Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MINNwwRB; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-420107286ecso53775e9.0
        for <linux-bcache@vger.kernel.org>; Fri, 24 May 2024 00:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716534854; x=1717139654; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gqgEfdaZEBJfnayfapiuQTwBATwCf6t8lNCJGJgb/4I=;
        b=MINNwwRBGJ+SFFUyTrVCYJOraWR9o4LtXzR6cQtaHWW0PcQD/KgHgj6wP+bgPKxIwB
         A88d8DGS628iZdYeI7JuBE6Mv99iPVH18qdMRThbzBtMMGfbamD7+6LZibZk/VyFfLPl
         oP8k/xTqBOrY32qcDkNcBqlDTOg6a9RYRQ12k/y2MDbmGviseBnQZ46uP+HEBiHm7rjq
         WsS7NSkgckZ/qC7xuJbucdmLPPyODfszyyq2bO54ySqJZk3ZEGqbK2Ym8R96DfTxX6qX
         L6HUcsbVA3DXp3Y1Cv0mYFO1r1Vd4qJL53depzVn22P3lQ6bAuej1H4j7qg88T7RWqqm
         bZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716534854; x=1717139654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gqgEfdaZEBJfnayfapiuQTwBATwCf6t8lNCJGJgb/4I=;
        b=tI+nA4J4YRbU+k4xb1fZ2UdNS43hm6yv9RM6QC72yX2b5zu8FArNCfT8D3CNex9VZ+
         NToz03RnpUvcEY0FVldMzxnnd6Uw8ThtgVBcOvPE7H2i8Tjkp6xLOvZYdesi3T2jmC2/
         572dIxBnpjw5BNVjLaCmHjXk6p+bZfexXv6nW8SJuD6wRjBUcq57/47BW+/y50yg3zyk
         D6sJWWeneEpqYSOrOSz3pCdvSwDao+KhBhTv+GTiMZKjMMCZhx1tlqIcBgiHIufVbSBm
         GnGwLozJGbjm9FR9+UjPdLNi7MmQt6O6GTtlEQHANkvWRURzKW2ZuRJxDTKE/Zww5OH2
         bHOg==
X-Forwarded-Encrypted: i=1; AJvYcCXm8Aa00v7A4zrasQeDrj0le3jpkcIrCUckp/Omqi9G4RkEjIXtKa0p4LWBiKGwugIlC169eH32Oumq/bUAAz1LtdpDok9+JWmVTFNa
X-Gm-Message-State: AOJu0Ywo/rBER9g8ZeCsalj7ISyJJ+MvS8uWPcQ0kFDTYrdmJr06kIja
	ct2oakr6xZ9XN8GhKpUo8TJyKtwUK5Arzk/k6++/lTT94OWBQlIKh2M245gvPP9tV7VXu94rZDd
	+N4Z8GaGXuXvTs1Fcg3V0PeJ9VQb1UMaA+HoiGVappB/bQ46E6wDU
X-Google-Smtp-Source: AGHT+IE1Ha3BS1PTYSeIAhRpRbZHV4yrK74or27y7uyGFAifj6s5R0Rv2s/hRLkHUd/HLuBqulSol/fpT7IBqYSHahc=
X-Received: by 2002:a05:600c:3d8f:b0:41f:a15d:220a with SMTP id
 5b1f17b1804b1-42108625e09mr1230405e9.4.1716534853813; Fri, 24 May 2024
 00:14:13 -0700 (PDT)
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
In-Reply-To: <3E11DC5E-92D1-43FF-8948-B99F665E445D@suse.de>
From: Robert Pang <robertpang@google.com>
Date: Fri, 24 May 2024 00:14:01 -0700
Message-ID: <CAJhEC07Pdea5XKyMLVw=GeBZksNWoWpCmHs7shBPcgW3OoDonw@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Coly Li <colyli@suse.de>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Dongsheng Yang <dongsheng.yang@easystack.cn>, 
	=?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>, 
	Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly,

I hope this email finds you well.

I wanted to express my appreciation for your work.  I was curious if
you've had a chance to submit the patch yet? If so, would you mind
sharing the link to the Git commit?

The reason I ask is that some downstream Linux distributions are eager
to incorporate this fix into their upcoming releases once it lands.
Any information you can provide would be greatly helpful in
coordinating those efforts.

Thank you again for your assistance and for your contribution to this proje=
ct.

Best regards,
Robert

On Fri, May 17, 2024 at 9:06=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
> And to all contributors (including Dongsheng, Mingzhe, Robert, Eric and o=
thers),
>
> At this moment I see it works fine on my server. I am about to submit it =
to Jens next week, if no other issue pops up.
>
> Thanks.
>
> Coly Li

