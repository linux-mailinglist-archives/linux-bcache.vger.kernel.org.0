Return-Path: <linux-bcache+bounces-857-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7397A7F452
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 07:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EF21189725D
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 05:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D3F228CA9;
	Tue,  8 Apr 2025 05:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mOGe76Xr"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880022063FA;
	Tue,  8 Apr 2025 05:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744090979; cv=none; b=JnfXwpMUSO10ik5MuwTFCIz7aM4tAYKTOJDxITCD6lm5NAxjSHXXg7FnHWiVA9W0tDqdww16kDcyCOASBjQjnp0R9H+c5Dtu2WdhjkE4tZnPH0DldRNzNFFpCFPoXdPvfO8BKs7c4bNyBY+44RoVAhGmX1dy9tTTUu4zfLeLzbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744090979; c=relaxed/simple;
	bh=sYlu/zxZtd7jHwos4fIUG+rHHrsp1iz1KzM6QEIoWrI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OxkursEgT6VUYZv2R/1oDWMUU7Jksp1CG1qMutBgx7ARgnhWc2D4qam9FLIjjCYuOVezm+LgbSp22NYir/ywgmz0XpIlRuNymuE7/Sf+lzdHGY4zQ1osTu1++/n1u6ZDBeTQ/9aWN6pmLpfbhF8lFZof+jWLo+bvxyLFTRq7CA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mOGe76Xr; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7c7913bab2cso122992685a.0;
        Mon, 07 Apr 2025 22:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744090975; x=1744695775; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTuC1yLkVLw0KDJ1sl/fXI1uube15Zl0sXYbNMZgOck=;
        b=mOGe76Xrj7rK7ENLDwlw5vfHJyOgThuDdAejds4MUOvxdDzGxcaOKllMi5LX3Dzrta
         u7GxfdMZldzbByb1WYNIS8zk5U4VmX0qEFTNdah/U3w5QnX7bp6+k30S0aKoYZXOqioq
         A+aEMFE027+FEVcxgphjLjhMIES0dxynbSjP0uGa2ihdcgaCTAYieYOv8rqqpmF+ZYop
         CvLNF+0niyiUXUld1egsvxRMLR/cvtEvyVGtQiUHby+VDZmu5suLH5LJt9RYov+q083M
         7GSybx1sMy9xQWFAQ2Q2u4jz8XTAUw3FhLPF4J7574a2uAuQuyWhJvvKJ3VFU1KYsmFg
         8z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744090975; x=1744695775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BTuC1yLkVLw0KDJ1sl/fXI1uube15Zl0sXYbNMZgOck=;
        b=olur+zGa00lHpxjWX2PAAw6VocimtAQIw7WAbE01Tu1WD2QUj/FDEIsu7q2RZQDwFg
         HplhkECHY1NHg/DYje78F9UHtEAX0oxmoVYrK2PW4f6wFnKfWF3GfA19gKBsgyLdab2K
         BsNP7+Xj5kK5KxTZ/JnOx3F5SmD5L3QQrDw/11IdInjFDuUcxOkaYnplzQSvaJaEQvtO
         ewE9W9qOC36uhIfRbs93WO9ZKcHB2ptlZUxLlfCB73fZDNemifYDyHv/o83CgsSns+tS
         2yD+IszhSmNzN8Xp8wm8J372ceU+q5exsi+E5X4YeV28JFB4E46jvhrBz+omVNwcaLKQ
         eV9g==
X-Forwarded-Encrypted: i=1; AJvYcCUJdM28nS3LblcaxY67IrgpAC6ejiuE34UlVPKNZ0FBOtdaGCRzPRUYriHwypAm0tPOwhXiPhU/kFawrD+p@vger.kernel.org, AJvYcCXMraXSlAYuSI90phR/tmw5nma+h1gnsL6UFyykJuqC9j5JjvDO15xg319lTh51pgp1FsWx+tT3sKpiKKA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjPcsFXYhFxI6lKKI6oNkJXR+HvvMU0Qq15lyBPBoDX7p/XUZa
	NiqHcbc5YsL7VfOMLYRirb4MohvzwVaB9NzoMKKf9ZMuQzjLO6pXAgAfdTQl6oHDR3VtswnFVd9
	EKegBQp8xhWydz265LCOtb8Ls1DM=
X-Gm-Gg: ASbGnctaJ0Qk/g6WaftN8A1i5IZn7ZBaHWge+n/91FFznPI/jjnrnh13tbPdCiMuV2z
	Ll+9wJQzBygcZA0gbB119H8y0byfEskHTzdWpmOYZSDOXDS90cEFy72oIzOGpeDGXjYR720cZxe
	l8g84IQURS9r90SziZ9QTG+CwkY7lUPir2/yD45SM+2wmX+nv6RM0F003IAg==
X-Google-Smtp-Source: AGHT+IG3Uf49ROht+s7nR72iOxuW28S1zEz3Tl9TWHw9A08Rv7qvVW4zSIDvBxg+BxfLb4weJfS3eDrTmYQc9Xkm7cw=
X-Received: by 2002:a05:620a:170d:b0:7c5:dfe5:ea78 with SMTP id
 af79cd13be357-7c774d1c4d7mr2354805385a.8.1744090975309; Mon, 07 Apr 2025
 22:42:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250408033322.401680-1-gshahrouzi@gmail.com> <20250408033322.401680-2-gshahrouzi@gmail.com>
 <6s4hsqctezmwk73bgz4u6clielbbndijfk6hpciqfbjc53yzhq@hm4ybp4splhl>
In-Reply-To: <6s4hsqctezmwk73bgz4u6clielbbndijfk6hpciqfbjc53yzhq@hm4ybp4splhl>
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Date: Tue, 8 Apr 2025 01:42:00 -0400
X-Gm-Features: ATxdqUEDaPQxYlUXn9iw3QrX_i6bAlfEvLqG-LtPUN95gSF_j8N5amPFx0RxHu4
Message-ID: <CAKUZ0zJUgFmoKv1oDguhEYWYxxFaKthCp6wY-ahsR8KWy-nqKg@mail.gmail.com>
Subject: Re: [PATCH 1/2] bcache: Fix undeclared symbol warning for bcache_is_reboot
To: Coly Li <colyli@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	kernelmentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 12:55=E2=80=AFAM Coly Li <colyli@kernel.org> wrote:
>
> On Mon, Apr 07, 2025 at 11:33:21PM +0800, Gabriel Shahrouzi wrote:
> > Add extern declaration for bcache_is_reboot to bcache.h. Ensure proper
> > visibility for use across multiple files (super.c, sysfs.c) and follow
> > the declaration pattern for other forward declarations.
> >
> > Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
> > ---
> >  drivers/md/bcache/bcache.h | 1 +
> >  drivers/md/bcache/sysfs.c  | 2 --
> >  2 files changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> > index 785b0d9008fac..531933351b8b8 100644
> > --- a/drivers/md/bcache/bcache.h
> > +++ b/drivers/md/bcache/bcache.h
> > @@ -1007,6 +1007,7 @@ extern struct workqueue_struct *bch_journal_wq;
> >  extern struct workqueue_struct *bch_flush_wq;
> >  extern struct mutex bch_register_lock;
> >  extern struct list_head bch_cache_sets;
> > +extern bool bcache_is_reboot;
> >
>
> NACK. It is uncessary to make more .c files to be aware of
> bcache_is_reboot. Current code is in better form IMHO.
Ah I see. It's only used in sysfs.c and super.c compared to the other
forward declarations. Limiting the scope to only those files makes the
most sense instead of including it in the header file.
>
>
> >  extern const struct kobj_type bch_cached_dev_ktype;
> >  extern const struct kobj_type bch_flash_dev_ktype;
> > diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> > index e8f696cb58c05..47ef0167b9d23 100644
> > --- a/drivers/md/bcache/sysfs.c
> > +++ b/drivers/md/bcache/sysfs.c
> > @@ -17,8 +17,6 @@
> >  #include <linux/sort.h>
> >  #include <linux/sched/clock.h>
> >
> > -extern bool bcache_is_reboot;
> > -
> >  /* Default is 0 ("writethrough") */
> >  static const char * const bch_cache_modes[] =3D {
> >       "writethrough",
> > --
> > 2.43.0
> >
>
> --
> Coly Li

