Return-Path: <linux-bcache+bounces-286-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B90873AD6
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Mar 2024 16:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31E6F1C241E9
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Mar 2024 15:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1F5135A40;
	Wed,  6 Mar 2024 15:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FpwIAzl7"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD2E13E7C3
	for <linux-bcache@vger.kernel.org>; Wed,  6 Mar 2024 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709739342; cv=none; b=rr8z+wdtEsMrzgqQJz59/8bzUQaoD5F0DGaeeO8kKvi93jgB7hT5PRizYpjDUaavuO5dNLoAfMfV0xnANOIZbioq0lET3YTV0GLmImPgyruCrbNAoDSJgZbmahpW6CzXS5ci7VT64lt/iu+ZOEyzbUe4vbveWb6OGwzrJU7SW3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709739342; c=relaxed/simple;
	bh=kBmyubjd7UqX7KtOVqXQPAZbNnvgLHXmvVx4xERaGw0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dHtzgHcRHObw9vBizhmaGm5lIao27KWEV9sIJHz5zeG0Fptz3g5rg7XW32SHXuJXUCIOX6fAfRMV2j4RqIA8jjuQMujnsvpz3yrlDCzJOkPZwFzXnJrkVCr2Kld9yP5VMANCoIOJflt8VH4o9EPxRE+sz9SOrK5r5wwdRrUTJcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FpwIAzl7; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7c495be1924so67154839f.1
        for <linux-bcache@vger.kernel.org>; Wed, 06 Mar 2024 07:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709739339; x=1710344139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5EJVyKfo/qJKp/5TYAxUmzDSOM9Yh6oX5oGW77hIJQ0=;
        b=FpwIAzl73aPw+9keWnzvLKc8W+L/8alNQLOHPbgMMF/ZO6X0TAfuWmq3UD8BkxrjCX
         sDddZ0i5bEUVefqfzKdb6Uz2b5kgE3fE6xgGYY7jezmCS7mglPAcehheWFdl8u/CkoII
         9uPcEhNc2U3+2TWFbHOO0RU/HVOlba8LsfTvnYQnXipsGU3/emRmj2LjWWRZTpAeMIGy
         NXR/afx1qh9TSjqLvywUwr295Rxyeu7YBm7UkPhfN55HmlpdJef0GLbUkfZx6aShaEAk
         H6aRYCeSqQSc60oiGBPiJqFgGPFg49ZUwa118YAu4n/Z104oOsJMz8iUzeinmbk11bwc
         7Wcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709739339; x=1710344139;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5EJVyKfo/qJKp/5TYAxUmzDSOM9Yh6oX5oGW77hIJQ0=;
        b=M5mAPHuza5MnorvwkaQRowkQtRu6tqZrRMvm2HtPWE+0VAXP2jalLr7hG5U2sjjvyP
         vdnOSLuqbPgXliq152yvaencgrBd8M/xt6PT3t8o18F37NR/kAF5EP5RcO9MMeF9qDKi
         HzpW5ZOjwK9YeT3tf4v9oN47m7xGXZEJaH21QWuU5dTtwEWW97jTQwSyb1LiZlxaf14q
         YTPwCfja8GylS8x8g6gMNju8wy1nfNXafXQFIa+ShJ9IT64qPLelnEbMjSSSvqa2a2SL
         Wi32e/ddeYIMcXodQtp8oD7zqPC8FubLGmJiEaZCw2cKrmXZh5EFBDksq/lEYHsKb4qO
         QTVw==
X-Gm-Message-State: AOJu0YxOgkvPdxst6/IVj20BfHMKDu5P3fdiFvgimyeevV1y2+CAb48A
	IfKl6SyE1iE6ne2QAmmupVPI7qB0ucW98A21yqtwlST1EhgKfIBnUUCb3sVK9R/YAZM7zAhvaTE
	x
X-Google-Smtp-Source: AGHT+IExezYwLCdk1ah3myJ1ZnMAxxK9psbgLX+yx/PyyFKASpLqrBrwGzpYSdEwh0JY5dYcBA98SA==
X-Received: by 2002:a05:6e02:1c46:b0:365:fe09:6431 with SMTP id d6-20020a056e021c4600b00365fe096431mr3733556ilg.3.1709739339446;
        Wed, 06 Mar 2024 07:35:39 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t2-20020a92cc42000000b003660612cf73sm324467ilq.49.2024.03.06.07.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 07:35:38 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@linux.dev>, 
 Christoph Hellwig <hch@lst.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
In-Reply-To: <20240226104826.283067-2-hch@lst.de>
References: <20240226104826.283067-1-hch@lst.de>
 <20240226104826.283067-2-hch@lst.de>
Subject: Re: [PATCH] bcache: move calculation of stripe_size and io_opt
 into bcache_device_init
Message-Id: <170973933779.23995.9027032366565112081.b4-ty@kernel.dk>
Date: Wed, 06 Mar 2024 08:35:37 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Mon, 26 Feb 2024 11:48:26 +0100, Christoph Hellwig wrote:
> bcache currently calculates the stripe size for the non-cached_dev
> case directly in bcache_device_init, but for the cached_dev case it does
> it in the caller.  Consolidate it in one places, which also enables
> setting the io_opt queue_limit before allocating the gendisk so that it
> can be passed in instead of changing the limit just after the allocation.
> 
> 
> [...]

Applied, thanks!

[1/1] bcache: move calculation of stripe_size and io_opt into bcache_device_init
      commit: 34a2cf3fbef17deee2d4d28c41e3cb8ac1929fda

Best regards,
-- 
Jens Axboe




