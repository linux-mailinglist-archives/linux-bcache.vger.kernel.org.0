Return-Path: <linux-bcache+bounces-226-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7EC1826859
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jan 2024 08:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DBA3FB2118E
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jan 2024 07:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C852E79CD;
	Mon,  8 Jan 2024 07:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mz4cbGlW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D668BE7
	for <linux-bcache@vger.kernel.org>; Mon,  8 Jan 2024 07:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-7ce603b9051so52310241.2
        for <linux-bcache@vger.kernel.org>; Sun, 07 Jan 2024 23:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704697260; x=1705302060; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XaSGSt7oo6/seLu3rOawrEq2RYwxc9+YcD3xNECSKxo=;
        b=mz4cbGlWmu2Uu8wFoQHHxihIOv89NYNRw0n3LMop/QOh8jxXpM5a61paBLxr8TcyO/
         PnOiZTvnnRjbR/qU/XOBUSxu+F8lALws2j9UZZAEtNTU1dteAhgRe/xWGXsKjdtmM7yN
         WWlKn70CHA/L/H96Bm6QttmjFvrr7bhuMquACNU1EmYt+vCE0dQATpyqAqCD5x3Rq/Pt
         ApwrvdJ81kHBxb5Jmg3BVcj8pH8dPXDbb6ljQzqMGsvBsP9ti1Fv51gEgTfmGIpP/nnG
         5BLH8Wux8IyPGKO/+KJbAYool8aMVEcyTUkUR6VN933qsjYLJ3OpCBzF+wX4uAqAlyKU
         eCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704697260; x=1705302060;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XaSGSt7oo6/seLu3rOawrEq2RYwxc9+YcD3xNECSKxo=;
        b=Cgl1w3r/Qyeoh4Hsz0BamKX9ekJEG7b70ZdN8X+qxZglDcpA3JS5z41M5WFgZsmu+c
         pDXUkmfUi+wMGBNlpxlZTTyLgUpf53XJOedi3vEL/xEGK2xFrReC57wdynfCoSsc9fmm
         76Hh9wZZG+M5RzPTGzsxwsn1OexK3Go3IHgixZ1Fk5SqRBWscH3FIs0wPeWwj01EuDqo
         +/12OvEaPcenHvenYIUU+AM2K0tAEoV79+utXOklwmFcavAdQESANfrkjmcMyHzsLuCk
         aDC5e2ahoLfOjaQnSyASJ1w6Jb4qV5vPr9QAoKREJydMj1UdCPfBM7aCO2sWZG44xFzD
         O2hw==
X-Gm-Message-State: AOJu0YwlWZ6xDz3/h5vTyLx2uCLNthAUWUCb1VpVSZWxtC3J9L6F1Yo+
	4+AOzKznHVc0hcXC3QhaFPmHF1srJSo8upKMoIT9T0wFFvRg
X-Google-Smtp-Source: AGHT+IFpUN6pC7xCIbsApGCrJl55CBrGAh6IirKLDVKz3A3mm7X38w82LDyi08a6WKg/Zz3amwxxsgoI1/gJIOwtPq4=
X-Received: by 2002:a05:6102:304b:b0:467:ac41:856d with SMTP id
 w11-20020a056102304b00b00467ac41856dmr1575462vsa.20.1704697260063; Sun, 07
 Jan 2024 23:01:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104164937.424320-1-pierre.gondois@arm.com> <CANpmjNOwqoEbmuyE_LeMmJ=x9-3CkpXqYsi6m3Gniudyj+RFzw@mail.gmail.com>
In-Reply-To: <CANpmjNOwqoEbmuyE_LeMmJ=x9-3CkpXqYsi6m3Gniudyj+RFzw@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Mon, 8 Jan 2024 08:00:00 +0100
Message-ID: <CANpmjNMK3hiBPG2UwEV14YZoee08a7ULw4cwcsxfV=E5+FcTTg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] list: Add hlist_count_nodes()
To: Pierre Gondois <pierre.gondois@arm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, Coly Li <colyli@suse.de>, 
	Kent Overstreet <kent.overstreet@gmail.com>, Kees Cook <keescook@chromium.org>, 
	Jani Nikula <jani.nikula@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Ingo Molnar <mingo@kernel.org>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jan 2024 at 18:16, Marco Elver <elver@google.com> wrote:
> On Thu, 4 Jan 2024 at 17:50, Pierre Gondois <pierre.gondois@arm.com> wrote:
> >
> > v2:
> > - Add usages of the function to avoid considering it as dead code.
> > v1:
> > - https://lore.kernel.org/all/20240103090241.164817-1-pierre.gondois@arm.com/
> >
> > Add a generic hlist_count_nodes() function.
> >
> > This function aims to be used in a private module. As suggested by
> > Marco, having it used would avoid to consider it as dead code.
> > Thus, add some usages of the function in two drivers.
>
> Whether or not it's used in a private module is probably irrelevant
> from an upstream perspective.
>
> But this is a reasonable cleanup, and at the same time adds API
> symmetry with the already existing list_count_nodes().
>
> > Pierre Gondois (3):
> >   list: Add hlist_count_nodes()
> >   binder: Use of hlist_count_nodes()
> >   bcache: Use of hlist_count_nodes()
> >
> >  drivers/android/binder.c  |  4 +---
> >  drivers/md/bcache/sysfs.c |  8 +-------
> >  include/linux/list.h      | 15 +++++++++++++++
> >  3 files changed, 17 insertions(+), 10 deletions(-)
>
> For the series:
>
> Acked-by: Marco Elver <elver@google.com>

Btw, there doesn't appear to be a clear maintainer or tree for
include/linux/list.h. Since there have been several Acks/Reviews by
now, did you have a particular tree in mind?
Perhaps Andrew (+Cc) can help.

Thanks,
-- Marco

