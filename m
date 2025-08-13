Return-Path: <linux-bcache+bounces-1187-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0C5B23EFB
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Aug 2025 05:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3B0C3BF414
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Aug 2025 03:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02080270575;
	Wed, 13 Aug 2025 03:24:32 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9E71EDA1A;
	Wed, 13 Aug 2025 03:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755055471; cv=none; b=KYn6iV2XqMvb+GI96wIXlINbbBTUkWe1AvE6HclUgY0zY9EEm2HP2p/+BL3qoHp+WdHlIZLnVX5CA+ZGmiZr3v6QC7w4gFESO5EtIFWoHSMuM54jqfeAkmFUKV3i8Ankx8tOXBfnfaXbcLtktjO9cCsQOB2MtDf0+5svmGqI+sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755055471; c=relaxed/simple;
	bh=gZaVqfqDrED5aTdYHEvjlx6entJ0DUV0pOS4vvWnwWk=;
	h=From:To:Cc:Subject:Date:Message-Id; b=PbuyaXxAGj96EUAqXPZcwQeb/sa2+VhaN3uwUn1EazQ/e2WHD9+vHsqK7x5/KEEMEeSQLThaY3oIc8Puaoy8rC7Box+cHRAy+DdvxEN427C5guWre4Gg5DtxoxsQaLoZFg9VaH09Ohd00HkLKGOnkKrh7rxo7YSL8sMSiDqR+IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
X-QQ-mid: esmtpgz13t1755055439tb0c5b234
X-QQ-Originating-IP: MNZnml3VbxOINt/sjaR0nge6SW3o8kkwAiOKjursSEQ=
Received: from localhost.localdomain ( [175.9.39.161])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 13 Aug 2025 11:23:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 193211725706897531
EX-QQ-RecipientCnt: 4
From: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
To: colyli@kernel.org
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Subject: [PATCH] bcache: fixed the issue of low rate at the tail end of dirty data writeback
Date: Wed, 13 Aug 2025 11:23:43 +0800
Message-Id: <20250813032343.18472-1-zhoujifeng@kylinos.com.cn>
X-Mailer: git-send-email 2.18.1
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:kylinos.com.cn:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MjQ00mYXMHtuVtdtDY6WsHasMNyuVniRfb9Vi+ZsFPy24tksGoQeP/+P
	/2JKn/bsRfbFT1cSmtfGmZdDvKLHL+QoYICo0dYSrigWSNVgcSgUrwuEu1nJf4HJ9pnft6Z
	+PfULNlmSU7ICmRoGwpQyiE0L+jzHtqIirWy/h3rLdjFOsqWkAhPDMcc/ErhzWobVaoVuN9
	AGcy5+MIfeqzuzQHtA+E0CVWXKsy70CoHJx//12O1qKJK07UySOljy9sEJQmbdWoGGvtGJv
	cDR1yHj1/fFPein6Przd9mwiOQ+ufmsIlbCYkXYvkC6XCt6ZuomJGgajNoipX4x+0aLlwsi
	F556f/uR8j261XCmUV0f974MCfkqxfs/GXq3lW3YPfNxGPp2R0/uTHizMQZQRfkbEMQIGm0
	Xv9bdczKjOdAM/sPu9m00mDIX89Sab+P77SW/EnQ2O5bBcb8D5xuj5VOs2GEttvRojCe3kh
	WOfCngz+27kzTy3XUsT6zBHlJOeY6BaGYiXTMlv8OliFbS6uk/A1nutpoO13nyAypVXDvg9
	VfEqr+Ikvw7/jkhkbSO05BZEHMCyOvfNaJCbX5kxJEilDpa2ynXSYxYgtyqG2JP75+BGyEy
	xwzOAejOrIu8kLFAEjfjILmBItb1UYXLQ0zt5xyaBACyQVmbrcH8mHmBtyYX1U6PdC0nwcC
	PWgz/naX3LOB8twbpUZF3cySHB8cw2fId+TDSGn82YD1OUtSa1DD0cp1CKrdG4HiMSqTbHh
	hCqtkttr+GrzJdlKpR9ac6RuazMnNwbJbVFM66NWf83YocmLvGr173EPnY9laQxemFN3yPg
	HT3+8i7ZOY3BBxyp1nBTlgC22XHJMBe2Sm7HyvYGiNGi7l7gf0J0w1CFJx26NcLhLukYxC0
	oJVZ4NbrIqbTIOcGZq9fRxxW9XrTTpDf1esTFpHtU82Ukp1N9o+WhvFaJp99sfcrGRHJ6BJ
	W4uyhSacgvUXUFegjRodRmRP7NSmrZBzYc4KXMTe0QpwcFMQqfnx00ypUli/vGT46amRYpy
	ns9vV2L03KB7PLo8VOc2jTdRDIqs0=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>

When c->gc_stats.in_use > BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW, since the
dirty_buckets will not decrease before the GC is triggered, while the
number of dirty sectors waiting for write-back will continuously decrease
, the fps = dirty / dirty_buckets * fp_term gradually approaches 0.
Eventually, when dirty < dirty_buckets, the writeback rate drops to the
lowest level. The larger the cache space is, the higher the dirty value
will be when the write-back speed of dirty data drops to 4k/s. This is
inconsistent with our expectations.

This solution is to set the dirty data write-back speed limit to the
maximum value when c->gc_stats.in_use is high and dirty < dirty_buckets,
so that only a small amount of dirty data can be quickly written back.

Signed-off-by: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
---
 drivers/md/bcache/writeback.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 453efbbdc8ee..9fc00fe11201 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -121,6 +121,13 @@ static void __update_writeback_rate(struct cached_dev *dc)
 		}
 		fps = div_s64(dirty, dirty_buckets) * fp_term;
 		if (fragment > 3 && fps > proportional_scaled) {
+			/*
+			 * When there is only a small amount of dirty data, complete the
+			 * write-back operation as quickly as possible.
+			 */
+			if (fps == 0)
+				fps = INT_MAX;
+
 			/* Only overrite the p when fragment > 3 */
 			proportional_scaled = fps;
 		}
-- 
2.18.1


