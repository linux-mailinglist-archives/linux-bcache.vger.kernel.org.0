Return-Path: <linux-bcache+bounces-502-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B35EE8D1BD7
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 14:57:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 317EEB22A16
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 12:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA8916DECB;
	Tue, 28 May 2024 12:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CoAPvequ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586D016DEAD
	for <linux-bcache@vger.kernel.org>; Tue, 28 May 2024 12:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901050; cv=none; b=amv1eFigJ/hSW07OebARYx2924rh+tY8Hf22TTmj7W8EEuPEgg+/j3rz3gRSQTTdnf1qfX9l1vxb8MZRLcOxcx41B8COqipvbGybyWeZQptYdhE0AgVBo3so7pG5RdEtq89JAI1vacWHHp898QEZzvHHpqh3DB9Dbfek3nNqgQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901050; c=relaxed/simple;
	bh=yLXEm1c42e6C5TSq6c3jBGbb3fPTE8uHjV+RDOiqHso=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aoXQtk3VH5TG6x64hCz82h6HpgLrfxigk06BhxVKV3ntWP4n6a+SYP5rpdfnFfzAbkpGhomvLCeTMvJLrUGCjeqFqtJGKxttbm24aJ79S5cwDHF7/QuW0JYPemW/iFOmx0+cj3ZzwQk8VGOFbNrOLmJYkejwUjWPx65/y3EuoqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CoAPvequ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1f2e3249d5eso388715ad.3
        for <linux-bcache@vger.kernel.org>; Tue, 28 May 2024 05:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716901048; x=1717505848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jeEpsyiS3b8raPxgZdh+Wek4BUXAmeaBtOvZqJZBf0E=;
        b=CoAPvequTJOVgrC79J3OQ4aD63NSG2z6NeAlLpwgkysMOc0UTNDL5ail3JODRqIGo6
         +g+MJtk3uSqghjDD8MGlAsLYrvZ9QKcWYJSTeCUmJrO62EAjOH0lzFvEgTO/Zv1AXofr
         eAwAWBRovt10Fnil3bChDnYvSduhNLokYJUPRd0GAyBb62vhyJJjLGTMcnXzmFaoVJBB
         txYsWCTCeri7LZ1pXyafkP4Qp/BLXktJDeGz06hyXSde/FDkmTZDoPKNEpho/YjIZgzx
         SiE0ojX7v5Qx4s0sGgmlWcNreX/n01tpY1sAbgZARBgS6tkd8eupfwAkIOab6/7lBfAz
         GVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901048; x=1717505848;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jeEpsyiS3b8raPxgZdh+Wek4BUXAmeaBtOvZqJZBf0E=;
        b=BbxFIy/ZE9OGuWE6pgQWU4iqNNVBP11CDD0hMT5mOoogZHiN3x2AZG3gdD+a576xWu
         A5J96SPFOyCMYIn5LH+ZhuveqK22P2Kue3epxKgZRXMlcPwF+8TzAhvkC7VBYdy1ixmM
         qzwrbHdlRYqBcci1By083Xc5FfwCC+PYH13iy3pE3LPhZI/fCJqMkQmowOXcr/Fi83Q0
         MGRampb+0rRUZdVgzXoF5eX9ontBrDN2IlgmEHvRBbf92gPIOSBP9XQx8DKGMqOkWpd+
         lTox3djIZ5E7GL1UsOR4a+WgLSlGLYGwOpO1NmASG4Z4X+025gU38Krhk+7SlHqP+SwA
         eNtw==
X-Forwarded-Encrypted: i=1; AJvYcCUkgSD3xElbiJ4SIzk811CHF8zjUeD4rksAq+VRpH+4cHCfIflTDlCU9iIj1AOeEo/rVfqNsXXOVC4w04+fZN8jsiN92Wtam2q5zY4X
X-Gm-Message-State: AOJu0Yw9BqPmIgKvQpK4mDHyAPZjlXwqT9U3RS1s/fbeRwctyNgRkfAl
	vVpE9sTfGRLufmr5o5YFVMofaXU0ZV0SIgW8Z5Ds9jVidl8bD7rXl6WEkE9rinQLx8myZ6x6Bn3
	6
X-Google-Smtp-Source: AGHT+IEDT5wjyQdIWxBFy7iDmEP048k5ary7ucllsQ2C76rJTpb2NNS/f9uwl2ddLYm3BPA1HtYt5Q==
X-Received: by 2002:a17:902:f688:b0:1f3:358:cc30 with SMTP id d9443c01a7336-1f4486d1fbamr136086695ad.2.1716901048527;
        Tue, 28 May 2024 05:57:28 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c967ac0sm79255505ad.180.2024.05.28.05.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 05:57:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Coly Li <colyli@suse.de>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
In-Reply-To: <20240528120914.28705-1-colyli@suse.de>
References: <20240528120914.28705-1-colyli@suse.de>
Subject: Re: [PATCH 0/3] bcache-6.10 20240528
Message-Id: <171690104653.274292.6349743072736147377.b4-ty@kernel.dk>
Date: Tue, 28 May 2024 06:57:26 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Tue, 28 May 2024 20:09:11 +0800, Coly Li wrote:
> This series is just for the patch from Dongsheng Yang, due to more
> testing needed, it comes after the first wave.
> 
> Dongsheng's patch helps to improve the latency of cache space
> allocation. This patch has been shipped in product more than one year
> by his team. Robert Pang from Google introduces this patch has been
> tested inside Google with quite extended hardware configurations. Eric
> Wheeler also deploys this patch in his production for 1+ months.
> 
> [...]

Applied, thanks!

[1/3] bcache: allow allocator to invalidate bucket in gc
      commit: a14a68b76954e73031ca6399abace17dcb77c17a
[2/3] bcache: call force_wake_up_gc() if necessary in check_should_bypass()
      commit: 05356938a4be356adde4eab4425c6822f3c7d706
[3/3] bcache: code cleanup in __bch_bucket_alloc_set()
      commit: 74d4ce92e08d5669d66fd890403724faa4286c21

Best regards,
-- 
Jens Axboe




