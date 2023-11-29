Return-Path: <linux-bcache+bounces-91-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B51BB7FE0CF
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Nov 2023 21:13:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FF35281F2E
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Nov 2023 20:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D945EE95;
	Wed, 29 Nov 2023 20:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NSwW7BGM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B429131
	for <linux-bcache@vger.kernel.org>; Wed, 29 Nov 2023 12:13:18 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6cdcef8b400so174181b3a.1
        for <linux-bcache@vger.kernel.org>; Wed, 29 Nov 2023 12:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701288797; x=1701893597; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wGNO/FU6EbIMJxkiiI7PYYT8RbUNVHzpIkE2CHH5mhE=;
        b=NSwW7BGMjMuVUUuyJsckqVA2ZjLRzOGxhvTnAkQBjucTSPmzM1G4AZOeB/VxQ29MaU
         ez/ac/su8xhqonQikcx/9eBeGBhX6sCZ7y+leSFyE8aa6vzKYUdat9e7ZZZKd/bAq9sN
         Mu0G4ArZYrPsxM/EKyDhIdhWaIBtTkbJmHtBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701288797; x=1701893597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGNO/FU6EbIMJxkiiI7PYYT8RbUNVHzpIkE2CHH5mhE=;
        b=XdNjRVmNSOHi7ri3UOyMv9C3s3RhS563iRdxjTMd1s6LQ+FtIqZQDYlT8Oeq4kljO/
         EppqDj+96P6pTxIooJ1ps/6GdpPVJg2+RSRENfQk/h/zmcZ1vx716Nwex74K2WQetQn0
         VBhRyGf3DuyBeqe4D0HZSnvZLIAvNYk7HWzN3qUuNSj6pA0GeDfR1Wte/Ht9ytGj71xD
         bn1+rGBe3Sa6qA2q322OtE66fzeSWRdGq1dq+Cz0gULInCQuCslMlnT7XvZERXT2tAr1
         FNm+PgLX/N3jHTCSj/waZtJwjgLIj+U5p5stcqC9AP9tnXhCjLklL7cLx146+affwuaU
         vVyQ==
X-Gm-Message-State: AOJu0Yy15ipB5Nhf1u4mXalxUzq6HO2fnkqz6O34nSmwr1f/VpqXweTG
	bainFssab568s9kJBqH47wuF6Q==
X-Google-Smtp-Source: AGHT+IGLRLEmidEeUyhKevGVc4UsmZ87Z0IfhEoUik0F4rdAevbEg58uIkhKRgMt0cR609AqHC53bQ==
X-Received: by 2002:a05:6a00:15cb:b0:6cd:85a4:bbbc with SMTP id o11-20020a056a0015cb00b006cd85a4bbbcmr14837775pfu.9.1701288797589;
        Wed, 29 Nov 2023 12:13:17 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id fi35-20020a056a0039a300b006c2d53e0b5fsm11133448pfb.57.2023.11.29.12.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 12:13:17 -0800 (PST)
Date: Wed, 29 Nov 2023 12:13:16 -0800
From: Kees Cook <keescook@chromium.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: Re: [PATCH] closures: CLOSURE_CALLBACK() to fix type punning
Message-ID: <202311291212.7955AF30D1@keescook>
References: <20231120030729.3285278-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120030729.3285278-1-kent.overstreet@linux.dev>

On Sun, Nov 19, 2023 at 10:07:25PM -0500, Kent Overstreet wrote:
> Control flow integrity is now checking that type signatures match on
> indirect function calls. That breaks closures, which embed a work_struct
> in a closure in such a way that a closure_fn may also be used as a
> workqueue fn by the underlying closure code.
> 
> So we have to change closure fns to take a work_struct as their
> argument - but that results in a loss of clarity, as closure fns have
> different semantics from normal workqueue functions (they run owning a
> ref on the closure, which must be released with continue_at() or
> closure_return()).
> 
> Thus, this patc introduces CLOSURE_CALLBACK() and closure_type() macros
> as suggested by Kees, to smooth things over a bit.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Thanks for doing this! This looks reasonable to me. I look forward to
being able to do fancier CFI prototype partitioning in the future...

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook

