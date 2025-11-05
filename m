Return-Path: <linux-bcache+bounces-1232-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E768C362A7
	for <lists+linux-bcache@lfdr.de>; Wed, 05 Nov 2025 15:52:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 56F8E4EC11C
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Nov 2025 14:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5FF246BA4;
	Wed,  5 Nov 2025 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gy70U958"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780E3239562
	for <linux-bcache@vger.kernel.org>; Wed,  5 Nov 2025 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762354257; cv=none; b=bBpJPFq7mge+EJ5R3DVLT87wskkh6fCRyqPhlQcUY1x6x8cA+IZoCDfq5AhwIVbaVP293B6WfLpgDHne9o6Pu32XgePNmKAL3jkjqoY70VBR78VOrnkxej8AOKSTlFuBP27bPfVIrFDmukVQ5EcI42gn2nEPtF8NqIzOXlrS4WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762354257; c=relaxed/simple;
	bh=+GvlQk06G9W39519d3jc60EuiE8rQv//MMTxBFhe96g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CYVYP2p2a463rgSuZyotI7X4rXXit3gs2LoU3aB37dcpe0ZJlULET7FLZ//vABnwdtLTThwovKuD7uG/O3qHD0VjACcRD+rprC6VVBGdO7G+WMclU6ZnF6IvnEnQqjnWbF/SAJXb9bsaxDMIpewlhREvbqKN/jXVVGM0dPSLV7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gy70U958; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3ee130237a8so4365114f8f.0
        for <linux-bcache@vger.kernel.org>; Wed, 05 Nov 2025 06:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762354254; x=1762959054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OxFsnMA9mRTRiSe0nOFLXrbbhFFoy8CeiOo3gwfHLbQ=;
        b=gy70U9582vQB5xTbnbvQeu/ev+CARvyBRSyHPVc7Cpkggg/FZVq7VOaVwHJWdQVzJs
         3qG4dhn1zjyNvWLQXGQmoVRbfkkKJ9h9Xam0ulgV3eSCXRrsYi9XLpFJBuDviTLZL+p4
         m9sQSVGfevIdYJV3ZPUOxaA1qlECXMJ+2Q+vtm9ScxlF/xS5Dz6oXecUbEQQf7uqBQMQ
         5PsUqknaGcTzKA71vx9dtWXY1q+VZmOX9y91zzF4o3LeTysArtF5h29vMg8paigi3zfp
         btlJ9g8FS/pL1sgrsNVgvVXRNxJlX1uOIhHsaOP3sNJKz1zTn+oT6gLO84WJiowfMvzF
         PNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762354254; x=1762959054;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OxFsnMA9mRTRiSe0nOFLXrbbhFFoy8CeiOo3gwfHLbQ=;
        b=FGqwbl61cRBaLZVgPvnCt+jpb6kmYItcJice5faX+c7PMqc9HQuGA3w18NEL3hK8wi
         tQ6RQ+oRIcagYNiwWr82egJ9tpDBd60iWe6LNQb3kGdd1orAVGDze4Dx8h02ZISj1jiv
         p0/o8rOAjo1TID4T42QtXJDfBElREWsVhFGsOPN+bdOc67Q2ASzZ9d4vVZJqpJlPAo0q
         yzc0RAkL/1S1AfZuMXtiH9aDG2AFHKjn84c0EOX7eKv+FJ7VehLN7its1w2IQLtssMyD
         8qO7LVdL5J9KSGjxJhNqWfVWKvsIxDxkUWmkQ70fEX2jFpwAlwRcmvw2SBKx4qh9oeQ6
         JlKQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5rs+V1bM4Sscns4DKIDFFgEUuPTuY8zbKKsiBn/zixESkMv3Anxi+7mNgtbu1kJLGQZq1KM08Qup9gSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsgMwrYt1+nJmY5f8QW7t6zLi3Hr4AzD/PpcFwyq5NU3Mue8ao
	qlMsHEO2DwFOH9iPnqYthDKYPReLvQYec7hOTeR5VgBbkUDF9MeCve0g4D//RO/RUo4=
X-Gm-Gg: ASbGncsP6U79Ffnc7AioMhYIaXflxyzzYnlgwUzVtnRX/JzjrZSUIhVDwQqH2mbVc7Y
	PrlCX911CeMrwypn/juaS6f2F3s4rYx9/HbB4z/beZDKEPDeF+IfJdAtzTA0KcS+mQEpe1zeUrf
	IH6onXVV+4AgkcoTk1STQ74+VqexmMaIAa2RGGwebj5KxjY2x0BIAWItPpGvxTCkVWOEM3LA5iC
	D8swA+tMq90HJRl72T0ySeUvm3E9zGd+JQm4Og5JRyhK43XiQRarW9R+t48KdRe1O8opHjY9Sxa
	f5vhj6LOFO9IDu5zdjymzubWiJwCuQDt17Vc6TbD4sIEBO1urrWcm/l/nfZy5gcgnCC6ZXlhG0Y
	0yRaozgfU5QEzgLlDh4QeHAvpIoLtAkTmhJYVsgiJ4TVdvAL7O3J1WGTh72RXZXK77HNbtSqSSu
	fj/BSMkbafK17fRSr84GA7alA=
X-Google-Smtp-Source: AGHT+IHo6EfCx3qMEtwlwpO7+vL3gANNLC57V9Vp+QrpOWGUp+tf1ZuveBJQR8sQocotcTRWWlh73g==
X-Received: by 2002:a05:6000:60f:b0:428:bb7:174f with SMTP id ffacd0b85a97d-429e32ed31emr3767404f8f.26.1762354253783;
        Wed, 05 Nov 2025 06:50:53 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1f5ccasm10662873f8f.25.2025.11.05.06.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 06:50:53 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Coly Li <colyli@fnnas.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/2] replace system_wq with system_percpu_wq, add WQ_PERCPU to alloc_workqueue
Date: Wed,  5 Nov 2025 15:50:41 +0100
Message-ID: <20251105145043.231927-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

=== Current situation: problems ===

Let's consider a nohz_full system with isolated CPUs: wq_unbound_cpumask is
set to the housekeeping CPUs, for !WQ_UNBOUND the local CPU is selected.

This leads to different scenarios if a work item is scheduled on an
isolated CPU where "delay" value is 0 or greater then 0:
        schedule_delayed_work(, 0);

This will be handled by __queue_work() that will queue the work item on the
current local (isolated) CPU, while:

        schedule_delayed_work(, 1);

Will move the timer on an housekeeping CPU, and schedule the work there.

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistency cannot be addressed without refactoring the API.

=== Recent changes to the WQ API ===

The following, address the recent changes in the Workqueue API:

- commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
- commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The old workqueues will be removed in a future release cycle.

=== Introduced Changes by this series ===

1) [P 1]  Replace uses of system_wq and system_unbound_wq

    system_wq is a per-CPU workqueue, but his name is not clear.

    Because of that, system_wq has been replaced with system_percpu_wq,
    keeping the same old behavior.

2) [P 2] WQ_PERCPU added to alloc_workqueue()

    This change adds a new WQ_PERCPU flag to explicitly request
    alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.


Thanks!


Marco Crivellari (2):
  bcache: replace use of system_wq with system_percpu_wq
  bcache: WQ_PERCPU added to alloc_workqueue users

 drivers/md/bcache/btree.c     |  3 ++-
 drivers/md/bcache/super.c     | 30 ++++++++++++++++--------------
 drivers/md/bcache/writeback.c |  2 +-
 3 files changed, 19 insertions(+), 16 deletions(-)

-- 
2.51.1


