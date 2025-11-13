Return-Path: <linux-bcache+bounces-1256-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A26C58CC2
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 17:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EEC042343E
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 16:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 771C5357A33;
	Thu, 13 Nov 2025 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QKi16B8U"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7AA3559EE
	for <linux-bcache@vger.kernel.org>; Thu, 13 Nov 2025 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763051223; cv=none; b=oONh2yRge/dps0HhjLezWzlPQMaXhaYUfHoWcKMdAYSoKZiSAKdBiMIAe2OliUlkxTmgY+TrdHS9OTiugHdd3GQIcSkzNTGbGarh6B8qnAiMKuh7+flkww0+vxkvQSEIXIHQ6UVksoBLGv7fYYd1xqxyhNo7k5EyNS1wWCJr3/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763051223; c=relaxed/simple;
	bh=8cGpt1mnnD4Nd84oB3FjjbO1ZroPYw3Bi1pxnVfLhrk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Cupa2Q+Q9eLLwh9jahQfrbRUGvPl0OqepuWcsH8cYuRUorG9dHqV6AU7vUJr3yl74EAKEARxGNsfi3jPch3Fm55EIZRfsItRKD34NSP5DYTux0sLM89R05u0pmABKy9x+RBMkynT9D6objzk9fWFFzIrtssIh208uC49mk6cFyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QKi16B8U; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-433100c59dcso4859585ab.0
        for <linux-bcache@vger.kernel.org>; Thu, 13 Nov 2025 08:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763051220; x=1763656020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+WV0XxB+XpXMsT65IEjX1Mg5hj1WPsVipB9m+jCtnpo=;
        b=QKi16B8U97BczHNWv3tbcTOdHFf4ULVB0kmAG6gLit+pmQT494KOsHR/EvXhrd13kP
         aa6YHaHouA/nXFKaY2PBj6WfEhFYozBy4Y0IFbVPifpHxICbXFCP63UHXUghMfrHid/C
         aK7bEMf/sERG90SKl1s49KH2Cu0nJS/pILsJEDH3I9gT6dSSrHa/zBbgGWXNXAmbVBhU
         k/aZfoAH/KwsswZotkt3D1oORlIRsk86D5ZHmofBQ0hWE7OXppXfTaOMdfswMnY8dEhC
         lqEkRWfsfEP+ucfHIHTZseCvCplEVWL5Sth8qS+w0xAfSYHn6p3Qu7+F3uGgVzwTuJa1
         bKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763051220; x=1763656020;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+WV0XxB+XpXMsT65IEjX1Mg5hj1WPsVipB9m+jCtnpo=;
        b=Rdma4NkiwRtHD1QjLq312mdOB9HklHk8uYOHGLwDPDxQqWjYDN670zAc4NimiZro+Q
         lBWI0IPSVFxXo1Vx3l0dWCaqkjAXz1idB8HZAbm15NrhQ/7bxVAtdErli/R0X9kj2zWC
         EPBveHDbzkSbwdXYN7Tel1X+X1bO0abXH9kGjMJ91LYkKiwsy38SpmpGMBtjsWB5FbYu
         6kPiwMXSr9U4Isvc7AZHiOxkFI0lgM4REdYoTdVS6bfzmVx55zGe92RNh46xuxLosIRV
         NwZAV6SMMljvgXwPg4k2wic8rh8uKe1kv+i87VcLtcRbs3rYsB7cLpPGcWMw7MEDgMFm
         //9A==
X-Gm-Message-State: AOJu0YyKwyAm2D1Obm+f7WCsUsBtxYnvR293m59b8mortOZq83WFALm2
	N5/hwMvcLE6mo/zaJaax1i6Lh9S27tR9uFyizlLfcLnqId9V2r+FTQ4HYZsoXL5qt8bATNxF/XJ
	HyDhU
X-Gm-Gg: ASbGncuZz4d0cyBw+SRKfeo9obBw7aTqd88BKb+rjyE2Ff8svpLOXkKSeJ7/x22dhxf
	9mwbhrO6rMyQIqsjxJv0DQ58WT85MxMRwZuntQaTN8JhG/fXxVpUrPyRCNMrJCInuSXhbUOHkND
	YazAhdc9aFSA3xjE7x+ItyCkLccYudV3pz5rOyVRj8eJxy947ptL2yst1F9NbNu72hJqTSjOVVg
	oyBZZY+Wl3Hb7aLe4EaTVw2QCHrrvyDpxPrZ9CxGoakdQb6Qxl6Qe9Aj1qFoFsKCl75WpY3iLEl
	mg9iPQCLKLoq0tFWVIMxVnUMn2X3uAza33aw5IER2DhQLI2K0icONzSYBVzZcvZK/DdUSBw8jJo
	CCUtcM0yBw6NbDnezTcrvMSSxzPnI4JOpTxAZ+2L7mimSA7FwsZi6ZwkF6eyRYfTmsac=
X-Google-Smtp-Source: AGHT+IEfPEzNVUtSijTeS0YXmDIkYTXhI19QS5zHoA8Z8cIEgyRelQqFXKdqTDIpcP6BSYul/ZnQtw==
X-Received: by 2002:a05:6e02:318f:b0:433:6fe2:6b00 with SMTP id e9e14a558f8ab-4348c8648a5mr1678615ab.5.1763051219861;
        Thu, 13 Nov 2025 08:26:59 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-434833c5357sm8641725ab.2.2025.11.13.08.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 08:26:59 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: colyli@fnnas.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
In-Reply-To: <20251113053630.54218-1-colyli@fnnas.com>
References: <20251113053630.54218-1-colyli@fnnas.com>
Subject: Re: [PATCH 0/9] bcache patches for Linux 6.19
Message-Id: <176305121881.129995.1450932700968780784.b4-ty@kernel.dk>
Date: Thu, 13 Nov 2025 09:26:58 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 13 Nov 2025 13:36:21 +0800, colyli@fnnas.com wrote:
> This is the first wave bcache patches for Linux 6.19.
> 
> The major change is from me, which is to remove useless discard
> interface and code for cache device (not the backing device). And the
> last patch about gc latency is a cooperative result from Robert Pang
> (Google), Mingzhe Zou (Easystack) and me, by inspired from their
> previous works, I compose the final version and Robert prvides positive
> benchmark result.
> 
> [...]

Applied, thanks!

[1/9] bcache: get rid of discard code from journal
      commit: 0c72e9fcc156caaf123a6291321bc9bd74cd1b61
[2/9] bcache: remove discard code from alloc.c
      commit: b4056afbd4b90f5bdbdc53cca2768f9b8872a2dd
[3/9] bcache: drop discard sysfs interface
      commit: 73a004f83cf024e785b74243ba9817a329423379
[4/9] bcache: remove discard sysfs interface document
      commit: 7bf90cd740bf87dd1692cf74d49bb1dc849dcd11
[5/9] bcache: reduce gc latency by processing less nodes and sleep less time
      commit: 70bc173ce06be90b026bb00ea175567c91f006e4
[6/9] bcache: remove redundant __GFP_NOWARN
      commit: 21194c44b6bdf50a27a0e065683d94bae16f69cb
[7/9] bcache: replace use of system_wq with system_percpu_wq
      commit: fd82071814d06c7b760fe8d90b932d8a66cffc63
[8/9] bcache: WQ_PERCPU added to alloc_workqueue users
      commit: c0c808214249c32a8961999e0779b953095b0074
[9/9] bcache: Avoid -Wflex-array-member-not-at-end warning
      commit: 699122b590ebbc450737eebde3ab8f5b871cc7f0

Best regards,
-- 
Jens Axboe




