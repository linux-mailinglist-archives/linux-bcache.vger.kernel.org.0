Return-Path: <linux-bcache+bounces-1097-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B2345AC4776
	for <lists+linux-bcache@lfdr.de>; Tue, 27 May 2025 07:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E9E17A7D38
	for <lists+linux-bcache@lfdr.de>; Tue, 27 May 2025 05:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F026E1DE4F3;
	Tue, 27 May 2025 05:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pO9ftAfp"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72091DE4D2;
	Tue, 27 May 2025 05:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748322970; cv=none; b=ux3EVn4GouqbdyeniAoJWzXspLsMqH9JFuPyHpDh0hGBxkORWJSfEm/BAfucqmaNYZHsUq7FMiQ6nlMfLHB3AS7dNT35g+tG6eqkZQAQrNqw5tbbXJJN+FslPkF6iTpplKgZV+WOuEkWwOPi2ka3IbAw8nDZ66R2Xzh1oImy/PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748322970; c=relaxed/simple;
	bh=tpdu7/umO6EnRjRHaXmQcb0z3wUOXm3YIGVF2N7O/tE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G0O+VwoXDOkLstTLHu2l78nBqglocXywU7QJFX2cwb+ynYQWoLm8pZtHzh0HiiMr8BlWtCb77OHeO8p+xvDRWHfHCCrXMRwdCXJEy6gRu6b7lndWPp1QRTUyXei+d1Gw4IqQo5mrj4JXxxkO2SWce3P+4EOqeaJqaU8eBO+Ft1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pO9ftAfp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7524C4CEED;
	Tue, 27 May 2025 05:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748322970;
	bh=tpdu7/umO6EnRjRHaXmQcb0z3wUOXm3YIGVF2N7O/tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pO9ftAfpA1TlHTl18iXalZQKXZBwPAKSj9QDgeVd8+nYA7vvj1aDr2xr4R8Gv4ZCR
	 HpL+GLbp2892XTu2YSYFn4tYSVF4TqrPQKjqA90m61c4K6KsQSrbB9JnCBCchy6Dfj
	 6gnUChMK64G/piSJoh+NuDZrXiD7zo4FaVlo82wD/KpK/otNcB4hikmyx9LHM+t8tm
	 BRbDOpGYaIeDq3hPglHnJg3flCloK1JSMhMFQkTWs+YkfQ9kJM4jgADNWx2H2u6N1P
	 OooWT6SeBrU1gSJPfeDUDnQtXVtxqceTYqWij8az8iJ7zR2yJJ/YwZYoQgD6kZMbKe
	 PqRPpfA8CnNkg==
From: colyli@kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Robert Pang <robertpang@google.com>,
	Coly Li <colyli@kernel.org>
Subject: [PATCH 2/3] bcache: remove unused constants
Date: Tue, 27 May 2025 13:16:00 +0800
Message-Id: <20250527051601.74407-3-colyli@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527051601.74407-1-colyli@kernel.org>
References: <20250527051601.74407-1-colyli@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Robert Pang <robertpang@google.com>

Remove constants MAX_NEED_GC and MAX_SAVE_PRIO in btree.c that have been unused
since initial commit.

Signed-off-by: Robert Pang <robertpang@google.com>
Signed-off-by: Coly Li <colyli@kernel.org>
---
 drivers/md/bcache/btree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ed40d8600656..f991be2bc44e 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -88,8 +88,6 @@
  * Test module load/unload
  */
 
-#define MAX_NEED_GC		64
-#define MAX_SAVE_PRIO		72
 #define MAX_GC_TIMES		100
 #define MIN_GC_NODES		100
 #define GC_SLEEP_MS		100
-- 
2.39.5


