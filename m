Return-Path: <linux-bcache+bounces-1149-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 037D4AF5A12
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Jul 2025 15:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B1753A9E57
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Jul 2025 13:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EEB2749E6;
	Wed,  2 Jul 2025 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zc7cxcWd"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6001E2609D6
	for <linux-bcache@vger.kernel.org>; Wed,  2 Jul 2025 13:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751464163; cv=none; b=q6aWgLcZhW1N1nUT3WFsZ/6al/1gd7z6JZqN6kxr5aidpbhCUWR3w2SKDzByjOtv4Q8QBWJOTRIf/qkamind0irvhkUz/9RbuflPcQgyvirLHDSttbALw19LWx12VniR1gM1225a2sTK7Q5cdsvkiq3rDpk2qiPFAYGeCi2ypak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751464163; c=relaxed/simple;
	bh=3dtWvOnwECnar+aU1A/C7ljCMWXFm3411P17BEniXz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SE+PQKiBhwDjhAJaVAR6phPar55cok8yGwZQgWWdlzPevjD7sLF+EDi80o50h0oun2xvGQ+jd7/k+0eO2andpYC1nU0IT5bM9/MBP+tYwC5FoG6XLSuFIn4EvW1HRvKMDjh2yqAANe30PP8S33oWv0Z+5yx6viKHW0c05k03M1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zc7cxcWd; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3ddb4a7ac19so24992575ab.3
        for <linux-bcache@vger.kernel.org>; Wed, 02 Jul 2025 06:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751464161; x=1752068961; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UmKPSiA+DMe0y1oOP3u6y81S9PUYI+S3s8c9kqvPo70=;
        b=zc7cxcWd9yJJbPxfge2cGndAqoL7RkjmWUWiK8Wi8DMHfPlYBo4u9fYaryc/7DC7R4
         y8xvar8boyh5utrHyJOYZ5yFc0eyctLlxW38c6B9AuV5dntf/ZHoopIfwjfuNfaW2ZqV
         SL12NUZNNO2usPD19ub+KJmJ6NuPJfs3bb3mwNQYBKQK19aXU6Mn+PLo4IggQ7J+Q+Ye
         K47IwYe0LYKBCWie0wxnqo075lhJRZNfuchS8rJKegITzyK0FlLFH8T4f+9jEwNUKMfH
         9nc1LdklAf5vd+RTHgQN9yM0OyyYJzSxJP9Cc4qk2UWzMMBUAGYOObLNt1tlRw67pAHR
         Nd3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751464161; x=1752068961;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UmKPSiA+DMe0y1oOP3u6y81S9PUYI+S3s8c9kqvPo70=;
        b=ht+t0hxRmPvlAWvhBw0QGakf9/JIDvMRKqVfv9VDItUFgFlyRqwGkp+M8uDiLwSWV0
         6egJmy6JlD77jHacGn9tnHK4Ynfr3H5uVRdzzHZkPi7MzcT80b9ZGKyjGtqu08/lzq6i
         O6LHzNNUOwC4rgJLE8yaxFusuprhCk3Ae74fJ84KyhBjU6B+BtWxtzLR93v86r/+jF1r
         ukphMS8qGoxIzYRes2DcBxeDAeBf7jzgci8K9grSpMn2V6PuIfG8r3qFtlA/ts2W9+SM
         rAzHiEjgsTdOKRdN8MLIuhzbtKltGnlTCtWw895lLeKQWM3UDrrth/uWS1I9beQrUlhQ
         t7qA==
X-Forwarded-Encrypted: i=1; AJvYcCU/Nv6QjguktPr8uzKiX9fRhAyeASVH5KZ14behbTI0CORRkKqKsLxNfMQ22DzYAXONOuS5w5/ZqpcDy8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuaHhsUCcWQByw5J0FCUF+Bg2ACpawnTeiBDGe45q5FLjJhpXx
	QPgFVifxmTBbhr/agU3lfEm3zYN9jwjWnLOWLXets71g0DCvDGFye2ALGDtNjAkBbYI=
X-Gm-Gg: ASbGncs3jIHCbcOeQAb7b4LWCAe+Fe5DPzdd6mBdhMwTVWa9GlQwjmZK1uJmOnXyvEd
	ZlDfL/8cCLtXUP5qUMOGIM1RVzPvryIcEI2soC+RQ5mLQfWGxiZ8vYz3hLRIl2CRMMGNt5hIE8F
	xeoV9H5qt5SlzlIxTgea0WM6E2UGI5uJRBmE4wZUKQIeO6abg8RblTCUkI7TLX0nFvWfOus4ByS
	Jd3pfrBQzFnvrXDyAp816eNcgwcfxCoyJSmEL4CzSB/VKU+N22RRqq8tTcg1caHS3GL/aPuugpA
	C9PT+c9kUJKQyWEkYWodGRK30ZZocN5yKHjnE0kpYY5z36S/SaAzjdRvuA4=
X-Google-Smtp-Source: AGHT+IFoDMrG3sdUp3ZtKwsQ1EnFvJM6JH+Yf5SDSq0ZsPF51vMD1as1g7Edv8aN1+I52eNLTGcTDA==
X-Received: by 2002:a92:c26b:0:b0:3df:45bc:14d1 with SMTP id e9e14a558f8ab-3e0549f47c0mr29766485ab.13.1751464161401;
        Wed, 02 Jul 2025 06:49:21 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50204861386sm2972565173.16.2025.07.02.06.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 06:49:20 -0700 (PDT)
Message-ID: <a741131f-b06c-4565-974a-f2c1a45d44c6@kernel.dk>
Date: Wed, 2 Jul 2025 07:49:20 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcache: Use a folio
To: colyli@kernel.org, axboe@kernel.org
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>
References: <20250702024848.343370-1-colyli@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250702024848.343370-1-colyli@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/1/25 8:48 PM, colyli@kernel.org wrote:
> From: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> Retrieve a folio from the page cache instead of a page.  Removes a
> hidden call to compound_head().  Then be sure to call folio_put()
> instead of put_page() to release it.  That doesn't save any calls
> to compound_head(), just moves them around.

Really needs a better subject line... I can do that while applying,
however. How about:

bcache: switch from pages to folios in read_super()

or something like that.

-- 
Jens Axboe

