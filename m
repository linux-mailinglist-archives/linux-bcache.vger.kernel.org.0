Return-Path: <linux-bcache+bounces-508-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6DC08FD9D9
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jun 2024 00:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A7761F27213
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jun 2024 22:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6E715FA7D;
	Wed,  5 Jun 2024 22:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFxXQNVD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05478621;
	Wed,  5 Jun 2024 22:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717626463; cv=none; b=TiZI5xq+xxdOxbC1E1A6ba/s5+EGLbvmNdQqiTSXnbWJlLqGBiKdpHIACpe28TNH+SaBrJbxTigkHzI6O34ExyKlf5VCiv7XwsxWLkqatQfdT0O0mvWn4SMCyXOyIvc/1Rf0auuD99RieTinzf3smdYApQUuRGixp9VN8MiBLQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717626463; c=relaxed/simple;
	bh=zl+XN4junHxfzNRNgZTOGK2SrlWTfl4TOqLE7f86obk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EnXG1D/SP9HLldVWc3MKIa5CkJ8txX2c2wg9v4UFcdyn4a139vTiQv08gr2PzRpDsqodHSjL1sB6RF5ThG21B3r/SLDnoPMryRTq1ARg4SAqH6QNduM4CPeFqh6+j615PkEOmN6todykaC56TYjHUx8xZeDD0/zAo83se32nSL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFxXQNVD; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7024494f7daso237908b3a.3;
        Wed, 05 Jun 2024 15:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717626461; x=1718231261; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=toEEg0KZ6dGQnJwtPH4evK1WmjlVqa6UA7LKv3x9NPA=;
        b=BFxXQNVDEpQh2aI/8VP5ozFZAJvuT6S5sUJf9tjkZg1CmoN9sOs1JoSf4doDFpZMDK
         l7TAPaidMmFP3/ic+aFR/ZQrDdvhiKE0ZjP5bS99RKLiYwgzeTsfRgqjuXi25Z6AGGDq
         WeYDM+wcG1Nf83WwnOBbBTpX0I95vy1TWflS6imETNZWYcQE0Vq5QfqRMu850ZFz+erG
         mldCipzzPUjifJLAhX320F9owzTNWzgY7ELJ9RNYMFEQvKM6Rg+iUDuSMbhuP9jPTbvP
         iNNaVRrpOOkS+fjyaFT93BC/MlCX1Z4a12dh270+/DbkujKtiumcdSbthM8f4146gV8q
         t3Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717626461; x=1718231261;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=toEEg0KZ6dGQnJwtPH4evK1WmjlVqa6UA7LKv3x9NPA=;
        b=m5gfjpH7tf6VbYoFDo1lEJdemPQ2Fmmct9LsvVsbgn0vhfD/T4DopV0q6gj0SwpBuN
         oHcyFhTyv1+gs9lctqKYiLZ8Pw4e/OZhQO6WcdzhL1ZccLAUAIC++OFTuLpndaQZO/2A
         XuLE3d22s5PzWns6jTXY/27kowpZg2PmTq3N6B0wziNhfKsJFD1h1ldocGOXTWRUJs9U
         LcOY6PXpORHIMlLnPeiQ1r2v0dGCWgV+mfVWq80Y4Qus2Igrs9+kf7JAv4GkVxgKTmQD
         cW1nFAMh9arg7Mgg6SBfgdljTgkX1a/ztI/V2FxkR1QcQtLSKZUaRqBWC3cCT15txnq1
         mZiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnCodnrELllvQ7RcO53DO1yqHKYS455f3i3R7T090gJtf3gQdzC594xphBXsvWHvQhnaI1BS9epI9qzXAQ6ZHh/lkgNizosavd+S6Vyshxjw7PEL3Kwq1I/xrPbydNnjD07UH31N4k6XNp
X-Gm-Message-State: AOJu0YzcD+HUa3FT01jZhCuiHHHHOmP0ovOtGHnx2k/5hIGxsD/RzHto
	8qM5JxrKXmle/x27lzBg2wTkqxBi4JDWKqxO9XolT1CSmIAquZk4
X-Google-Smtp-Source: AGHT+IHINrkZOpt3UhU9lY/8BQQRvuojzkqBE7EVX8mI3EqpwvKTDQPIVhaRBk08r60v44DZx6Kcaw==
X-Received: by 2002:a05:6a00:1acd:b0:702:56c0:299 with SMTP id d2e1a72fcca58-703e59b653amr4384469b3a.20.1717626461180;
        Wed, 05 Jun 2024 15:27:41 -0700 (PDT)
Received: from ?IPV6:2804:431:cfd3:42f5:2c15:cfc8:6375:4391? ([2804:431:cfd3:42f5:2c15:cfc8:6375:4391])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703fd4f8847sm6618b3a.171.2024.06.05.15.27.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 15:27:40 -0700 (PDT)
Message-ID: <cba4f849-8443-405b-8318-a7208e6b80cc@gmail.com>
Date: Wed, 5 Jun 2024 19:27:36 -0300
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcache: Fix compiler warnings
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>,
 Javier Carrasco <javier.carrasco.cruz@gmail.com>,
 linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240605034057.2671663-1-marilene.agarcia@gmail.com>
Content-Language: en-US
From: Marilene Andrade Garcia <marilene.agarcia@gmail.com>
In-Reply-To: <20240605034057.2671663-1-marilene.agarcia@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/06/2024 00:40, Marilene A Garcia wrote:
> It fixes the following compiler warnings by
> using "/*" instead of "/**" in the comments
> 
> drivers/md/bcache/request.c:309: warning:
> Function parameter or struct member 'bch_data_insert'
> not described in 'CLOSURE_CALLBACK'
> 
> drivers/md/bcache/request.c:309: warning: expecting
> prototype for bch_data_insert(). Prototype was for
> CLOSURE_CALLBACK() instead
> 
> Signed-off-by: Marilene A Garcia <marilene.agarcia@gmail.com>
> ---
> Hello,
> These warnings happen using GCC compiler the command 'make W=1'.
> 
> Thank you.
> 
>   drivers/md/bcache/request.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index af345dc6fde1..457b9605aff9 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -285,7 +285,7 @@ static CLOSURE_CALLBACK(bch_data_insert_start)
>   	}
>   }
>   
> -/**
> +/*
>    * bch_data_insert - stick some data in the cache
>    * @cl: closure pointer.
>    *

Hello,
I have realized that even though this change could fix the warning, it 
is not the correct fix to it, because it breaks the format of kernel 
function comments.

So please discard the patch.
Thank you.

