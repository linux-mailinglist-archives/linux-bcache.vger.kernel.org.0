Return-Path: <linux-bcache+bounces-1099-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74CDEAC500E
	for <lists+linux-bcache@lfdr.de>; Tue, 27 May 2025 15:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED2134A04AE
	for <lists+linux-bcache@lfdr.de>; Tue, 27 May 2025 13:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C9C2749CB;
	Tue, 27 May 2025 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YULFVzmm"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2BC2741BC
	for <linux-bcache@vger.kernel.org>; Tue, 27 May 2025 13:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748353114; cv=none; b=nz+Um65Ds7J8C+VibDwlzr/43DHxlc0cV/z8634s3Ibt6/3HaNoMrm+PvIzUt33+YTLraRX8MP/znRttYtfD90iy0iv6XUA+8brc1tWGGJe0AjFkWQZ+nXr8+xPd8ocxhTlY/47AyThvsJvfK3eoUe41K+4HOVShG1+Rt3vgW/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748353114; c=relaxed/simple;
	bh=IRnL26yWQubYAmM0trqw8iZN/s8xec1ny+6viPQeVy0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=K/JuMiqvC4i6X3bSB2F1zNDPfUI0vVGeATPjQAi0qKc50o4OBkmxFmITlTdmKf5Zt/LEGP/Ipti0tj8e+9AnLOlwjbS0Ove888g4W+V+rRrCMXA1GxYzp5a4V/vgG4s3VasD53b50vvIUeFCeWGoyuRRNUHzW/SbAAOfZd3BQC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YULFVzmm; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3dc978d5265so12671765ab.0
        for <linux-bcache@vger.kernel.org>; Tue, 27 May 2025 06:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748353112; x=1748957912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXdprp2M4n4x/hDHTn7TaL1n02o3UoZxEfZi2MHg6Oo=;
        b=YULFVzmmBBSBhReT8rBtY/5duSHSFBPe7OthXm6GxkUeQfZKN8xE88n2ojPco/ZA3F
         kDpwz4Mcm3/ReIUUjhCWfXgTJaDzK7l/XUInlSkfTfGTryCkh5yHzkqs67XNpSG32qnn
         6Za80s2w0Z7kLGg9ez+zeKPxQV13dLfu3/tUs3URzB7TINszzV9JxcIXq6eWdFy5AumS
         DDxUub1F+ufYe2IheONEuBhgVmW/9X5oa0FCrp/8TreFYpvai0rW7ABKJeWfKVtJ0cLK
         /hotddT516MCj1SvsmyerfA8jSrIXJ+e39Rh/2cdqkrmIunEbB0bGp/0ucNZihNptQQl
         dF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748353112; x=1748957912;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TXdprp2M4n4x/hDHTn7TaL1n02o3UoZxEfZi2MHg6Oo=;
        b=HmjqHOYdf1yLKAaR0+O3ehDyd4KvyZoW4qpzZLnEqZY6yTdLRhrjFW3FKoQLZ7wxEx
         semQsNy0rAVAyW2BtzbOT7HeTJ1e72GvVHWgbB0QKg9Y9dOVkl6oqFui3U68s6N3Bo66
         h6xKtXWh94310kJpa7+2xDw31J1/dTqPa7JjY/spRQVdPfh0qBI4XROtuv/FkLNp+ow7
         DEA9ZBL0yNR3gkmPQydGzMtdnC1+fqFzwZEKn2IIT/TOChIJLRvMovv1vYcIo/TVT1tA
         8XPCsc0nd+ssKIUVboZs68nCVg7+1MO+Az8Q7aufDhJ9cnfIT+mds64Sc6CiFR1BrN7m
         1Cyw==
X-Gm-Message-State: AOJu0Ywb9Iaoqkf5TEKwlQS72csQUXYs1OLJl1LcDfg3KOvdCPnPHWEQ
	Tpup3ofdswH/JULXr5kTlojpZ2AjLe+4V28yEyc9NjEU/5QYvapSly8i33JkxNVnmA0JL+gzP8B
	qc+Gh
X-Gm-Gg: ASbGncuG/HpCMaRieJrcDtvfb04hHAH2P8gnUKHxHBultCT/pQQRqpRy6zWUFx9QL46
	riYUEd9aumh2Nj+8zKbbZa2emuNSrymqdUEFdGQ3LRZ+Sy1ETPojCeOso0KxxN/wMSGi1ur09SB
	g96cyrMpyVrXt71pnaTdpFBGGQBZ8oxm8oBpbpoLxn5LhvmFQDpHjO+pj6s1/NrOdbXlvR+IDzc
	oNO6F6uGlpXmF7sby7FeqzgzSQBRUA74nHFUuWOCvYHYDJtG5WYYsYE+vG3qCFFxkDhU8OptFSe
	gpUi8C9d5wdAZZO/dR3ItcqYHbfRIzrl9VF1aVlsTg==
X-Google-Smtp-Source: AGHT+IGqdnA8GXR4KIorpMW2Y8clpddOdkxA/tTng2GsFFAogRkjTZs38r3zpV0pNXTj8mDhdGeBNw==
X-Received: by 2002:a05:6e02:12c6:b0:3dc:5be8:9695 with SMTP id e9e14a558f8ab-3dc9b663fccmr113230395ab.3.1748353111711;
        Tue, 27 May 2025 06:38:31 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc84ceeca7sm35685895ab.57.2025.05.27.06.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 06:38:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: colyli@kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
In-Reply-To: <20250527051601.74407-1-colyli@kernel.org>
References: <20250527051601.74407-1-colyli@kernel.org>
Subject: Re: [PATCH 0/3] bcache-6.16-20250527
Message-Id: <174835311090.454262.3692110373889951104.b4-ty@kernel.dk>
Date: Tue, 27 May 2025 07:38:30 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 27 May 2025 13:15:58 +0800, colyli@kernel.org wrote:
> Please consider to take these patches for 6.16. They are generated
> against linux-block tree for-6.16/block branch.
> 
> Linggang and Mingzhe from Easystack contribute two important fixes, the
> patches are verified in their production environment for quite long
> time. This time we have a new contributor Robert Pang from Google who
> posts a code clean patch.
> 
> [...]

Applied, thanks!

[1/3] bcache: fix NULL pointer in cache_set_flush()
      commit: 1e46ed947ec658f89f1a910d880cd05e42d3763e
[2/3] bcache: remove unused constants
      commit: 5a08e49f2359a14629f27da99aaf0f1c3a68b850
[3/3] bcache: reserve more RESERVE_BTREE buckets to prevent allocator hang
      commit: 208c1559c5b18894e3380b3807b6364bd14f7584

Best regards,
-- 
Jens Axboe




