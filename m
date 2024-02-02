Return-Path: <linux-bcache+bounces-259-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A159D847690
	for <lists+linux-bcache@lfdr.de>; Fri,  2 Feb 2024 18:48:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FA311F24916
	for <lists+linux-bcache@lfdr.de>; Fri,  2 Feb 2024 17:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F5E14A4F0;
	Fri,  2 Feb 2024 17:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a7EDp+ok"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213B9148FFF
	for <linux-bcache@vger.kernel.org>; Fri,  2 Feb 2024 17:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706896104; cv=none; b=H8Kb6mWb67VgB6rk+/fHM0EtvmESr9EuF4SaO2bFE1p1HH+n29MZEixcxGZhsEQZAa12xoiYORe2WxmzyMJSl5DikDsWYnX52PejGNMyaiRHcicWJ4e2MHMh7QeHN/q/HpuBEeWiOvsT+Oj5usMoh2GFxHXa1WINfKhfiYgPUog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706896104; c=relaxed/simple;
	bh=/NBDqJvpvCEQgaSYXeRT89BHRWWbe2o2eJLW5S0h5tk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ebh+m77PEo77SCmfrDkGs8uNbUjTx+dJIruv3+cq4OGD+Kqus72jLarxLutZ6VjFhuolteJUmkMCDSwOwVNit+vC5htsctHihqK9JESgI/MN9tpJGvM1rdnHTGUZAKxrLDmTh3W476I9MZ1tT2Wlc/LKjA7FGiCk2bTYEoq/g3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a7EDp+ok; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-2191b085639so487608fac.0
        for <linux-bcache@vger.kernel.org>; Fri, 02 Feb 2024 09:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706896102; x=1707500902; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/NBDqJvpvCEQgaSYXeRT89BHRWWbe2o2eJLW5S0h5tk=;
        b=a7EDp+okC9GfRtgHSBDzwEAB8nKXhkFQqAJEeiBB3NpH+BSyFWW1iET/W+5voiBb9O
         3C58fJ4fQxeK2a560tN4bD8ccCJ4dgzpqkO2SHehy4ywANS3PwYlixub8kP/ukLU54Dh
         HKi6hLAV6FHVlytcsdcRcn5UMjETICjdWhzMp1iA4jJdc2M8+joPUgbwfr18sksmQ+Ql
         qQbsqFwW5+lxT9jNNjcdKA+D5fxalBgNaJaOs1niY1df3jjxVj4V3EcndvrSqlo02Plr
         aEpi0N0jgekM22Yfi8Dk4EOmGg3LCSumICqCVp7q9HP4MvivwK6SJB6YxIC3tEmZI3Os
         C/TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706896102; x=1707500902;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/NBDqJvpvCEQgaSYXeRT89BHRWWbe2o2eJLW5S0h5tk=;
        b=X/xrWMLbVCmcZy1/P3t9EJLo+01SzkMPpy9+RHi9xep8Nrj6DAJGlUSQhGsmjvl9jy
         gNvldyltvxSG0Ubh3Z0SB2rvXtA2huk7kpaxjvr8glmx7l00xNol4RAgXXMYjvn8DdCr
         dIBrhuV9/5I+9OsWYDsnzJybFYPOuE8f4Fh6COwfRw3mJFMInZ3bAMk30F/cbUD5N26Z
         /2HA//Cq1qY2UQM5pAjKIVhVXm4VCALzhb/B8HHVxSHdjOfJDhJGbljwIfd2y7acWnSU
         fiwmZCuIBx2RK72/Q9HKnCHRZx2SvBFsN3x3aVXsCqzdHGYk4maBceZrEiYssp6OYItG
         RxTw==
X-Gm-Message-State: AOJu0YzCqBf6fb5lLgVtinXJIiEX00kwsIkS3psr89laqO4qr7RvxbRn
	/7hDy7ylRJ/49AjZnbmnaLbrdBXEhaWj/mYyrigm8R3DptRbFShjGPH0U3dVmO+VEvoVsuMAoeo
	k/khMxjtaadt51SCFBDJJYbj2f0y75DMssane
X-Google-Smtp-Source: AGHT+IEaxtIRCQye9kUcmomeWqgs9Z6nIshF5tWIYyxkoLcZM83OBjuGYSz49h3cbul1E4fiLaWllun9lprd1Rmxles=
X-Received: by 2002:a05:6870:9d86:b0:214:fbcf:4a4a with SMTP id
 pv6-20020a0568709d8600b00214fbcf4a4amr509719oab.2.1706896101960; Fri, 02 Feb
 2024 09:48:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANF=pgrX7h26TjA9bPUm9umRA-9KvELb9z3-bJsHm+t6SYbE1w@mail.gmail.com>
 <2944152A-ADF8-4B92-A9A2-D550BC51AF5E@suse.de>
In-Reply-To: <2944152A-ADF8-4B92-A9A2-D550BC51AF5E@suse.de>
From: Arnaldo Montagner <armont@google.com>
Date: Fri, 2 Feb 2024 09:48:10 -0800
Message-ID: <CANF=pgrictityuTm4Uv_KqUn=LnbSf9VW7-EMYUS+MvCSdMqvQ@mail.gmail.com>
Subject: Re: I/O error on cache device can cause user observable errors
To: Coly Li <colyli@suse.de>
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Thanks for clarifying.

Regarding the documentation, the first sentence in
https://docs.kernel.org/admin-guide/bcache.html#error-handling says:
"Bcache tries to transparently handle IO errors to/from the cache
device without affecting normal operation"

I guess I interpreted it in absolute terms, as some kind of guarantee
that normal operation would not be affected.

