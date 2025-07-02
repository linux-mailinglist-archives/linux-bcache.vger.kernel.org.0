Return-Path: <linux-bcache+bounces-1152-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C61B2AF662B
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Jul 2025 01:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FFF84A75F4
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Jul 2025 23:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FEF3246BB9;
	Wed,  2 Jul 2025 23:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aP1+7Cv6"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EDB2459FF
	for <linux-bcache@vger.kernel.org>; Wed,  2 Jul 2025 23:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751498444; cv=none; b=OkKeaJMyMutKqyG46oRbEBPaqTFYeYsVu+xSxJBUL2qAFy5pz4FmlUEr8OjC6Cnm10axswtGo1X9eOzGWHVRVia0NPdvDY365AabvaOZV0RUsScV2hanYHQa8bMBCPfOiXLcwgLmrYlnzf22aGDfRdta3HyxCPn2ZkuDBznnvMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751498444; c=relaxed/simple;
	bh=q3ofX0T5a7aC+Sxdb7tFd/olIE4sjwbtwq6Y+ktwBIo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Fj5uQ0oC58JJKPtdVVB8+iBwwlYa5sWuCLWoc4WAcpfx5Xb91jAuUaYUo7jkb1dCOfglIp07iDBf4Eg17iweQWXnyv2eE2BkZJ3i4P6O8yU2DV2g+384fMyC7TGQrsIH0QA9gtpxV9Gl0wnFwxUR2VRobSgMrWKPEZGIIjDiRCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aP1+7Cv6; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86cf3dd8c97so444902939f.2
        for <linux-bcache@vger.kernel.org>; Wed, 02 Jul 2025 16:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751498442; x=1752103242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lhaVNTqKFBo7V81f6Yv1iIxQt+Ef23n06JZqgPmk2Dc=;
        b=aP1+7Cv6tUDK44r5eumil1x3bKPOaNI3s9spHmMqIG0SiaWEAggSXcSyBd2NYPIyFX
         +oCnsLTxxiPquirA9QqY0zHR/FA9EwxCb9Aqop8Ccw5hOCp2zqBMdavRwnvmUEzDFutg
         OUOE+OFFah/+sLwUaMJ3ig4KmUoWZQE60Z0rSCIjlOcP6iEPFRvEnLoLWHu7LbC9Fqd4
         Gi/13kImiDCNGQRnoJmOi9s6bZif6fK8i4XMAlsuMwsm4q38BN/UAkhSfePBXIdAZx1i
         0NcfkSoRiWTxSIy96bKr4qb+Mj0xzP9Yz9BIysV9zSfPKYmsbQ4TkQSwPYP77d6pnm5Y
         lkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751498442; x=1752103242;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lhaVNTqKFBo7V81f6Yv1iIxQt+Ef23n06JZqgPmk2Dc=;
        b=fti+ykuWsxsBXIFqk4Cxq9nugDN4FPUPnmzfCOSKy2I21kjVk5C9g0ZTeH0fu4Hf2A
         Iz2zMUydcADDLE5M6XSkWlqBubquh4yzBu8X/TQJwKZiH05rTr3jmSB6fSm1JStbnRR7
         Z4uR3nofobvIH7KTSG38ftQCqzKxWbGa7GbnK4wxZghZ6dw6k8hIaug9po91NOTDm/fN
         ey33UdPRlmC8KWU7am1Ep6843mtQayjYcjrVxnmYsfB/1Sf55kYqGoWPUxngX50UUWI+
         kDlZagYIk6NuvAuBWjecWfWOK6be6wj+OpQCDfZ8cQttpNSSqOR5PIIF75CVENIJ0/f+
         P82g==
X-Forwarded-Encrypted: i=1; AJvYcCWX/8VQazCjDF/WUNsgYYz2Hc1Z2/OdlX0gZgojES5cFshgrK7CECVf6cTe2e4TvrkodyToH9d57NI53oM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcjNFheJ3xWnIQyllVyXQvdGfWzVsKLQgsBg35y6T17TAYU8d5
	Vo8B/GZzaZexRs6Hl1hN/yOmf6aWM/pxrutwF56Y/qdMxHckd3FF+H5QTJkXFzlGhpj5s2Mm8MK
	lfUGd
X-Gm-Gg: ASbGncsScbO7gAP8rgVM3ByrqU2gKGgtQ7GjSoFcOQI8GqymIK+ufucrOEww7RlsQcA
	KW1qxcu//VJ7+TigU5+FPDkQd4SlKnIzspD8sXMVdbNTbJfCRewlXPDJrG9Zl+1Fmczsb15Zs1h
	iCU7lNkm38QAmokKpT5ObiO7zoGfzVZ5n0fZuTKJJLuxSjtPd8rgGbvknooothpRANIL2Umz92+
	AtU4deS3KEkxpawpBoai1qAigf4FZeXek5K0kMVRCnev3XxQeoX83PcqRZV+VOcPDi7fZJZ/2KS
	NsZsl2/pnABR3KKUD7nohyKVbah4mpXdTvf6jeuVTslHOFIj2sH0aw==
X-Google-Smtp-Source: AGHT+IEby1ioQvw12GtPt/ocg6xPvPzaqg55+xdZ8hB8KnbDdnv7Wv2+8Tq0O9OKzEA3E3Emy/GHyQ==
X-Received: by 2002:a05:6602:750d:b0:85b:3c49:8811 with SMTP id ca18e2360f4ac-876c6a098f1mr818720039f.4.1751498441970;
        Wed, 02 Jul 2025 16:20:41 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-502048d2af9sm3209457173.56.2025.07.02.16.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 16:20:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: axboe@kernel.org, colyli@kernel.org
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
 Matthew Wilcox <willy@infradead.org>
In-Reply-To: <20250702024848.343370-1-colyli@kernel.org>
References: <20250702024848.343370-1-colyli@kernel.org>
Subject: Re: [PATCH] bcache: Use a folio
Message-Id: <175149844110.467787.16486778272474982430.b4-ty@kernel.dk>
Date: Wed, 02 Jul 2025 17:20:41 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Wed, 02 Jul 2025 10:48:48 +0800, colyli@kernel.org wrote:
> Retrieve a folio from the page cache instead of a page.  Removes a
> hidden call to compound_head().  Then be sure to call folio_put()
> instead of put_page() to release it.  That doesn't save any calls
> to compound_head(), just moves them around.
> 
> 

Applied, thanks!

[1/1] bcache: Use a folio
      commit: 88b4b873551f0901dd0314d37ca2a420ec6c2686

Best regards,
-- 
Jens Axboe




