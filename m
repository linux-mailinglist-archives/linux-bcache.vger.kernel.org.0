Return-Path: <linux-bcache+bounces-818-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D6BB9E1E0D
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Dec 2024 14:46:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6E24B29C4F
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Dec 2024 13:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0E71F8933;
	Tue,  3 Dec 2024 13:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LjxLmdEk"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40641F76AE
	for <linux-bcache@vger.kernel.org>; Tue,  3 Dec 2024 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233336; cv=none; b=BrEqTwqYiyOebK9+8xxiMINeRLgS/oCM86VwbazygC+4R+Zkee4V2S25CLOKR/SbnSN0ljkhjUGRfkEwUuc+Wl/FXP+q7B4ZqD/J8j/HXRoJARX/T9+SuEUyy3gU4QvVaXG6+lQUbe/6JfatljX4M1RXgXVVpAjDAn+gG2ZtG+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233336; c=relaxed/simple;
	bh=BPqo/+vJ9OA99wMkdAF6vWPVOkXo/UQOziFQPIlW/1E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=P9NsK3qzrJ/I6iqvSdjcmc0NXHRWouELVBq3vCfgWEzYGnBi7pIWl63QvfIxXDlFxfVdanWDSlXr/Y2ooE+vAJg7OUG6n90ZtoH22es0CD6td2jtPrEtbbzT3rpQR7V03rLuZLOZ1tDMNe/m3UO71yF9Hf/tZqtNjqz/O3wm4ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LjxLmdEk; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5f1e7639391so1930805eaf.0
        for <linux-bcache@vger.kernel.org>; Tue, 03 Dec 2024 05:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733233333; x=1733838133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPziSiz6FIPz1llFZL4/mtv70ocOZmo18hfdyDsh/VQ=;
        b=LjxLmdEkeOzRdv2LOy8MDnd9IqaiNPf9AwmUCLMdGor82amWTMEVsYs886T7eymnrB
         zy8yYZDY14DZBsGdWmoreADl7hEbgNxly+iMObL2qjPO96HYxRFEMFESudSPrIrCorcR
         pN+ddZMBHAZGjOilYlZu3wGLqsmLvLhmRK6B6WTWkWx+Gwg3aJwrbmEcJtGqStUMLWo4
         5rFsmQDKA5/pJyD9px7Z8bfH1jM8OQvEJy2YnJ5LT9/9tPEaVmlge6SEKDrJKq/Kp095
         LUHrm3vRacst7YQRSd4WbhxJxCrvuRECNqC0Mq45G8cYccbtqc/wCGNoMVpKdDrOAZVm
         Qs0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733233333; x=1733838133;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPziSiz6FIPz1llFZL4/mtv70ocOZmo18hfdyDsh/VQ=;
        b=IdHG8XBnLzPIL1K3BkvkP0vLs/YDTDL/ocitngFOLTZK91xUG3aa/oGG2/85giLTtd
         ZDjlIx8fSm+PUaCMQjbP3IouU4xIii+BqaDmMuFRQQSdM9iyogsceKCIrqnQxPpJ4AYc
         yy10fJvwdOa3yb/5eWgmAbYDKWjX8YOmzbQiDalDqKD3SwviyjEEYR2EqI9T0lpJcbrn
         XIGWAkX0HsrvHmfIh6BkXm18BEP9yldCkITAacbnxns+8ncIm+PLqrW3a6sRkzC1bkMM
         4f+taO01Geo6CvSlaPKuclbpbSTqmBfvBctqf6SdI5OlQfNyfJywQDlrHAVwtGNl8RO+
         otog==
X-Forwarded-Encrypted: i=1; AJvYcCXYMKtxL+/hT9yg6gXE6G5cs9tm/PYfLjFjLPO2wvIDCHCtokPOcq8iPPOajX3GKa45ESbOzEow95p2L/U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoL7cxAbDycmVIJxEJekdtC4LhB35pyBer5ZibTotVgt+NzHdj
	5R0gJicgFlhIn9/f82rJSx1ZaYR9QHE95bcTncMwjypJVKPPL9d3CSmwR0dE5KA=
X-Gm-Gg: ASbGncspE9HMxJNx1uYCGjgdAIWI8U9i68ocqPnVmm4OuOzB3X049GTKp4b1TknZsMg
	UGCZxu5v8+30I570jFX1Qj5x8np1lYRatfs+vaiJTwm5z1NTjRbT5133oVYFxug7OnZCb7XHAXq
	dklD1PRYcgwCFnnckQTiBQnUyUku3HIk3z5/1bLIvX5imkDGm6HS2v+65wVDttmaRNp6spstSLG
	yS3rDMCNfRAL/wgg2jdH7LHg4JzpEdFCb5qP8rHJXL/8A==
X-Google-Smtp-Source: AGHT+IF3JxViCcZr46UetkoBs9MyylLeqwOA8mylprKsogFh27HKGMF5642pWucfOY8iKk1uqQ4f1w==
X-Received: by 2002:a05:6820:50c:b0:5ee:d89f:1d2c with SMTP id 006d021491bc7-5f25ad40e71mr1942008eaf.1.1733233333038;
        Tue, 03 Dec 2024 05:42:13 -0800 (PST)
Received: from [127.0.0.1] ([130.250.255.163])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f21a4cd86bsm2782124eaf.29.2024.12.03.05.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 05:42:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: John Garry <john.g.garry@oracle.com>
Cc: haris.iqbal@ionos.com, jinpu.wang@ionos.com, colyli@suse.de, 
 kent.overstreet@linux.dev, agk@redhat.com, snitzer@kernel.org, 
 mpatocka@redhat.com, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, 
 dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, hch@lst.de
In-Reply-To: <20241202111957.2311683-1-john.g.garry@oracle.com>
References: <20241202111957.2311683-1-john.g.garry@oracle.com>
Subject: Re: [PATCH 0/2] block: Delete bio_set_prio() and bio_prio()
Message-Id: <173323333147.59116.15700360793401292347.b4-ty@kernel.dk>
Date: Tue, 03 Dec 2024 06:42:11 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 02 Dec 2024 11:19:55 +0000, John Garry wrote:
> Macros bio_set_prio() and bio_prio() do nothing special in terms of
> setting and getting the bio io prio member, so just delete them.
> 
> Prior to commit 43b62ce3ff0a, they would actually encode and decode the
> prio in the now-deleted bi_rw member.
> 
> John Garry (2):
>   block: Delete bio_prio()
>   block: Delete bio_set_prio()
> 
> [...]

Applied, thanks!

[1/2] block: Delete bio_prio()
      commit: 099d214fc7abc3fec0f38d10bec31ac7acce8d13
[2/2] block: Delete bio_set_prio()
      commit: 77cfdf838d8467d3ca44058caff7c1727080efb2

Best regards,
-- 
Jens Axboe




