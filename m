Return-Path: <linux-bcache+bounces-821-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A16F99E84D4
	for <lists+linux-bcache@lfdr.de>; Sun,  8 Dec 2024 12:53:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9736C1645B9
	for <lists+linux-bcache@lfdr.de>; Sun,  8 Dec 2024 11:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F09213D896;
	Sun,  8 Dec 2024 11:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RvoxBPNW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303225A4D5;
	Sun,  8 Dec 2024 11:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733658836; cv=none; b=VZdFX8yqtCv7/pcTFiwwmNsu7xASaA8shei8D1Ot2lAIGj9gQ0OeNg2ZDR7h8jDEe1esxsvBYCVKPaBK5f37qS+ZDBxHg2i7X6ajFnkwpqAlddEfGUMPT6bpxWMH2g6ugTUchdWxo/GcMZ3i47+afUbS2Uu4s0jXatALujUp+7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733658836; c=relaxed/simple;
	bh=AJUtDUzuRwPUW4C8M0J6pmCLzz1FoHAKrMc7OmbOU0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NyDhZlzMJhK/CalPNYwVrxu+MIRGRFuRdXDhOyoaZVhB+TndIwLjksFIR9uAFeibV2lYIzhxroi1T+fmkc+pIJTMWxA1RwnwbTdtLC3jPNNtAa129O0AGYd89B+jhksM4LaKfMqp0dOVoI3mARYpFqmto/tUYf6iJcqe7GJ4t/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RvoxBPNW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802C2C4CED2;
	Sun,  8 Dec 2024 11:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733658835;
	bh=AJUtDUzuRwPUW4C8M0J6pmCLzz1FoHAKrMc7OmbOU0k=;
	h=From:To:Cc:Subject:Date:From;
	b=RvoxBPNW2RUPb9i9FMHzbh8L6VM8h8PO2Nu6aVo0Dt5CY0M7GQcuPV8smUFvmQry3
	 XERtk6pO++JIB3Ql5oJLQI+ips7vMjShuApqQd/wUM1DZSOnyJ+n+na511duP4Kxvg
	 4IFW2RdoPvIVULNuvEpyktCxi+iwJ2Cy9vIhIh5zoYQYR7fEU+HdAEJo6vSCBOSr83
	 YULLGNJ0GSKRk6JxT83QPKpcfTOcAw15XpARi3MlPGthdUHph+6GaUkKipFWnXxHw7
	 nYaaFrIylcR92320d8minVSRzKYnLdwAAab1mvUaGgzx84Io7me7jn4nw8qvNmda0L
	 ycewSf9Kr7Lsg==
From: colyli@kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Coly Li <colyli@kernel.org>
Subject: [PATCH] MAINTAINERS: update Coly Li's email address
Date: Sun,  8 Dec 2024 19:53:50 +0800
Message-ID: <20241208115350.85103-1-colyli@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@kernel.org>

This patch updates Coly Li's email addres to colyli@kernel.org.

Signed-off-by: Coly Li <colyli@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 17daa9ee9384..5e88f56b9819 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3893,7 +3893,7 @@ W:	http://www.baycom.org/~tom/ham/ham.html
 F:	drivers/net/hamradio/baycom*
 
 BCACHE (BLOCK LAYER CACHE)
-M:	Coly Li <colyli@suse.de>
+M:	Coly Li <colyli@kernel.org>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
 L:	linux-bcache@vger.kernel.org
 S:	Maintained
-- 
2.47.1


