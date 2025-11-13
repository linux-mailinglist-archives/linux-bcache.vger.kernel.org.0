Return-Path: <linux-bcache+bounces-1245-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 032C9C55D32
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 06:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A716D4E2114
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 05:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA3D291C33;
	Thu, 13 Nov 2025 05:36:38 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F56E2A1CF;
	Thu, 13 Nov 2025 05:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763012198; cv=none; b=POKUo8OXstsGGGxatG+qCeiR5OEGfDMSBbjfYXEVie/ekV8z66Y5mHPHxM3FeQR2foa9j13XTvE0ONMFdrOzt4eVsYEIGVaVQk2BBKb7KXvcO/iewmp+arNbVi7AIhyFYuTwf3Bw8FMv6xBR2s+ZG5dRnsEPm1C71V6gmWoW+iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763012198; c=relaxed/simple;
	bh=uqYXlpbqyXRA0MLB1Tm9ycD8UbMN1jFTsR1e8l63fxg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eZZeYLhAv+hjXEyvoFdqNv5bGLJgSy3mt3UdQLmHkJERO+eWUd898xAoqqM48D9GJzNNPyCZlSLbBWNX37rbzGjQgnbiwTJXgP0huESP6b8p+/4Mi8ageQKa/fequ26YiOnbeq3zl9Dne7dJ2be3yLg+WVmj7q0gZ0QKtp3RiY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F12EC4CEF5;
	Thu, 13 Nov 2025 05:36:36 +0000 (UTC)
From: colyli@fnnas.com
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH 0/9] bcache patches for Linux 6.19 
Date: Thu, 13 Nov 2025 13:36:21 +0800
Message-ID: <20251113053630.54218-1-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fnnas.com>

Hi Jens,

This is the first wave bcache patches for Linux 6.19.

The major change is from me, which is to remove useless discard
interface and code for cache device (not the backing device). And the
last patch about gc latency is a cooperative result from Robert Pang
(Google), Mingzhe Zou (Easystack) and me, by inspired from their
previous works, I compose the final version and Robert prvides positive
benchmark result.

Marco contributes 2 patches to improve the usage of  per-cpu system work
queue. Gustavo contributes a patch to fix the not-at-end flexible-array
member warning by gcc14. And Qianfeng contributes a code cleanup patch
to remove redundant __GFP_NOWARN.

Please consider to take them for 6.19. Thank you in advance.

Coly Li
---
Coly Li (5):
  bcache: get rid of discard code from journal
  bcache: remove discard code from alloc.c
  bcache: drop discard sysfs interface
  bcache: remove discard sysfs interface document
  bcache: reduce gc latency by processing less nodes and sleep less time

Gustavo A. R. Silva (1):
  bcache: Avoid -Wflex-array-member-not-at-end warning

Marco Crivellari (2):
  bcache: replace use of system_wq with system_percpu_wq
  bcache: WQ_PERCPU added to alloc_workqueue users

Qianfeng Rong (1):
  bcache: remove redundant __GFP_NOWARN

 Documentation/ABI/testing/sysfs-block-bcache |  7 --
 Documentation/admin-guide/bcache.rst         | 13 +--
 drivers/md/bcache/alloc.c                    | 25 ++----
 drivers/md/bcache/bcache.h                   |  6 +-
 drivers/md/bcache/bset.h                     |  8 +-
 drivers/md/bcache/btree.c                    | 53 +++++------
 drivers/md/bcache/journal.c                  | 93 ++------------------
 drivers/md/bcache/journal.h                  | 13 ---
 drivers/md/bcache/super.c                    | 33 ++++---
 drivers/md/bcache/sysfs.c                    | 15 ----
 drivers/md/bcache/writeback.c                |  5 +-
 11 files changed, 71 insertions(+), 200 deletions(-)

-- 
2.47.3


