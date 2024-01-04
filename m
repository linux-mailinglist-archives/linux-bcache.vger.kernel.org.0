Return-Path: <linux-bcache+bounces-213-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 681C682474D
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 18:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B6CA1F248AE
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 17:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE4224A13;
	Thu,  4 Jan 2024 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GMTh1lUr"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4EB25578
	for <linux-bcache@vger.kernel.org>; Thu,  4 Jan 2024 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6dbd445f395so382531a34.2
        for <linux-bcache@vger.kernel.org>; Thu, 04 Jan 2024 09:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704388606; x=1704993406; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BzJFC4+5nZ6yAzq+bloN7utl+lUKkE6hgp23HUFKe90=;
        b=GMTh1lUrRevWju+hohKal/X2PohtT3aYGD65G5ikjadoYOcqrGJKyVFG+8Yn+BwMz8
         lwTDuuO3YFbYP55xzNXRx7nIlIQh8wmG/pM2aTSIfVx4uegqWIu5wT2LMpqwWJ+1RTvs
         L4atSof4NzvJniqhp0WWzzZc3iZNcfGZzCTorJ4qTjLJCvVo3uGLGuubMJ7vVkq71t2Q
         qsjQrIdR53IwodBpuZt/HmBZuw5KE2otqk4DeTZ3wSK7PtmHmIaI+kGkz+DmWRGYJ3Kt
         oJhPDjecp0R8nt49dFdaCcXGItU00RyEqTns+OQOTRgRllGmvhEtMk5Zl2hfYSiE7n77
         qCRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704388606; x=1704993406;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BzJFC4+5nZ6yAzq+bloN7utl+lUKkE6hgp23HUFKe90=;
        b=HLNiwcF1+W8cxLp66mtc6B2OtNm5Ua4rG8a/IRZNiIwLfjJOfXa4rtIdPJbQ3FnU3U
         IgflyQGfWU6FUPtrFWBXzdy5cdvt2mBEGGNF3t4oHx3AHwgqx5LMYptdVFMOEfs//Asl
         4EWMM+hdtLNzeVZErMPVYTPU68JRZKxgGp6JN+dw5kfwLqKoXprbzuY2EtWpg8N6KTDC
         q5CPbqn2bljIUoaEoAGPoqEDs359IOywKS6rmNdEIj2in7Zipp+QWi/UCZzUl4dSRFOt
         hUthC9BwR2pPP2N47vzUYgBeQDgMJ6XGyzfiekoSpGKOjtftU+AjlCt1a72hx7N8jeYt
         6NMw==
X-Gm-Message-State: AOJu0YxEe7+xUyX4TZ8C8Mc4tVs3H6CI/AKye7tG886ZqVEuvBwe/H0i
	NpccJkwkJXg5gZALzdjks8FgXHlQ+JENAFr1vP72gQNVXpPe
X-Google-Smtp-Source: AGHT+IF2iv7nl0RNRoyGLkWRAZJre+84MhB16C64uZcZBk0j0DgnqciZxHulKXmccHo18z/sa4PjFnsvTtoCv7VhzJw=
X-Received: by 2002:a05:6830:6b93:b0:6dc:17a:663e with SMTP id
 dd19-20020a0568306b9300b006dc017a663emr929870otb.70.1704388605828; Thu, 04
 Jan 2024 09:16:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104164937.424320-1-pierre.gondois@arm.com>
In-Reply-To: <20240104164937.424320-1-pierre.gondois@arm.com>
From: Marco Elver <elver@google.com>
Date: Thu, 4 Jan 2024 18:16:09 +0100
Message-ID: <CANpmjNOwqoEbmuyE_LeMmJ=x9-3CkpXqYsi6m3Gniudyj+RFzw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] list: Add hlist_count_nodes()
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: linux-kernel@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, Coly Li <colyli@suse.de>, 
	Kent Overstreet <kent.overstreet@gmail.com>, Kees Cook <keescook@chromium.org>, 
	Jani Nikula <jani.nikula@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Ingo Molnar <mingo@kernel.org>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jan 2024 at 17:50, Pierre Gondois <pierre.gondois@arm.com> wrote:
>
> v2:
> - Add usages of the function to avoid considering it as dead code.
> v1:
> - https://lore.kernel.org/all/20240103090241.164817-1-pierre.gondois@arm.com/
>
> Add a generic hlist_count_nodes() function.
>
> This function aims to be used in a private module. As suggested by
> Marco, having it used would avoid to consider it as dead code.
> Thus, add some usages of the function in two drivers.

Whether or not it's used in a private module is probably irrelevant
from an upstream perspective.

But this is a reasonable cleanup, and at the same time adds API
symmetry with the already existing list_count_nodes().

> Pierre Gondois (3):
>   list: Add hlist_count_nodes()
>   binder: Use of hlist_count_nodes()
>   bcache: Use of hlist_count_nodes()
>
>  drivers/android/binder.c  |  4 +---
>  drivers/md/bcache/sysfs.c |  8 +-------
>  include/linux/list.h      | 15 +++++++++++++++
>  3 files changed, 17 insertions(+), 10 deletions(-)

For the series:

Acked-by: Marco Elver <elver@google.com>

Thanks.

