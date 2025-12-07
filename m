Return-Path: <linux-bcache+bounces-1342-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A2DA3CAB422
	for <lists+linux-bcache@lfdr.de>; Sun, 07 Dec 2025 13:21:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FA8E30552DE
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Dec 2025 12:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C796B2D9EF3;
	Sun,  7 Dec 2025 12:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2rqsv8R"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8B02609EE
	for <linux-bcache@vger.kernel.org>; Sun,  7 Dec 2025 12:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765110110; cv=none; b=QyPTJAEv1IGB5/GULXpYD5sVFN+rNtYvX8ADWY3KOwjFnYqspTRaWu8kTlK6WPo4RRlEVRrNcfUNklGWljhxJ8/rtTJG11oM69KQWlrkKvxDnBT1TB8hFQivJgjwccBBBInYJzgxhkZp4UX9ehB8r0sg/KHfrv/jjPZ4hGv2+TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765110110; c=relaxed/simple;
	bh=EdAQp9CHsrjyYHWEK1NLd3cyuoRw/bMWYJkcM+8jzxY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ijEsTgHI58NjT9g2suN8xTHZJOHJdvnnoi5/KiBFXnfRuW1Ver6TE9n5wnraqLyUgBn26VEBMudTHA9E7Zjq0/7ZLrW+ca5sYKINH2lBkVNRYFYKjREMp6tdQCdqia/nYv/eZHuVPfGIQIY2QCRDRoqwhuwko2ZStt/AEaQu+OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f2rqsv8R; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29845b06dd2so49191335ad.2
        for <linux-bcache@vger.kernel.org>; Sun, 07 Dec 2025 04:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765110108; x=1765714908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=joTQfPhywjCMY+5oDHnst7DgiG3VJz2oKR4JgFEEjaA=;
        b=f2rqsv8ROnq2vdZG7gkLyt3kFx7zSQj3BRwTcF9g5/I7Jca+yQLWLKe+sUDDTHi3+I
         HHxf6WuXLyKokXnb9Sov6+UYuUiDERXcu1mhAZZm+PZLc3YinOuWkadz8dt9WJDR2idn
         Wnp+YPxXAXck4RXmfqMpn9yiH2aXsbB4aVppJ4KCYwsnk6YEtiFlju11xr/hlE5+kwx8
         7vl6LS5qwoUs+YhlvnelDzkfPr+mtHIkU8PRSIhoEZDhB2WQRudmXeRqV4lxeZzTgVlR
         lxw3gINpigDFrBLIPtGMdFn/q05ZXHOMCRJvEzvQL2hyyfvjeYzY00Fh1SyDSThmrtg0
         o42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765110108; x=1765714908;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joTQfPhywjCMY+5oDHnst7DgiG3VJz2oKR4JgFEEjaA=;
        b=II8kyc3LoBrJc1U77FS0efeExpynZ62gDb4g9+88grQFmYuao3hX/673BJHjG0HXW1
         Ty6+9CUE9L8DXcVDEtBQddoDHkx/OK1OA5L4mfyTU8pCHGBs+qI+10GSdYQsYCJGVJvu
         JBsOKf8zppi/W9kmCV8U953R3DkrUFV5Ga2bpeQyFeSp4PO+1Bh7ttZZemNwPI5244Kr
         rinJ7UaZ1UedDA2E4VOM93r1qCHtOZh4ijYk7CTc4OUlEoHJ0jDMwuu5u0Y+99EQU73C
         HgK0dx9qrLJj4qFA8432/oTdD8zZgI8CmYhSMkG/ror3uxTRvfk/TIu11Yb8Sa7aPHsc
         z/Tg==
X-Forwarded-Encrypted: i=1; AJvYcCUGwcTBrHkcBQ+0jKV1ZlGDV3rh+7rSj2Sk0GcpsXmfBuIN0BnmMMfOk/ur8vqRsE8FT4ktExocXqOas9g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxek/Z/tQic33KyZk6NWzy9JTKRjETqYbxmAdMFmVjhCDHNdHpi
	m/fPuMar1NFgJeNmp/iDtOO9RhaPVHf5OS0BxgHWd+copX4mU1irngM3qbfnnia7xno=
X-Gm-Gg: ASbGncse0GKNumsVh7uEbmU1Iii5lQNtV0cZUAD+JeqlM+4nFabMj/EhvjzK/s0ZOeF
	bPAMi+2Wwk3ma9MIfXEYW972Vb/N3Plw6dPZNTnGdhSnfU26OH1dzFB5yHuaGgsnm4BrYPoydQ7
	pofuXK6zqc1D69+LAlQSAWvgoczLglxdS9xAmxcHXz5W8m1W9gb9VqSnTeyj83NKl0xpcZs7ch6
	Te3hreGgVq2HWj2ucPKj1ZfkfDgQpttiwNlcamvKt8DX95WuaXw4M336Bm6FDKqqKwYtWel/5Re
	3CaTSCgfiP5c3gOGAgYyft/6G/Rofrf1qcvSRNcig0+aXX81118EXJN+lN8/Cb9f/ktlcvj54XA
	2o1HVl90qgHu+XtaONyma6jvOEW4kWGqdWoa0czdp7doo049eQHIog/YELWj53Sd+gAM6aCZZcK
	IknGvZXib6MqJZsAUw4UvRo1cJWA==
X-Google-Smtp-Source: AGHT+IG8BbDKk36cm/PHPVqWDlq17iC4do7MY7rKoUCFS0nZ2SwpdfJ+A5u1l78OZShYQYwtPCeo3Q==
X-Received: by 2002:a05:7022:699d:b0:11b:9386:a3c4 with SMTP id a92af1059eb24-11e032d8b2fmr3479895c88.47.1765110108364;
        Sun, 07 Dec 2025 04:21:48 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2f3csm38598822c88.5.2025.12.07.04.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 04:21:48 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com,
	colyli@fnnas.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v6 0/3] Fix bio chain related issues
Date: Sun,  7 Dec 2025 20:21:23 +0800
Message-Id: <20251207122126.3518192-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

This series addresses incorrect usage of bio_chain_endio().

Note: Patch 2 depends on changes introduced in patch 1. Therefore, patch
1 is still included in this series even though Coly suggested sending it
directly to the bcache mailing list:
https://lore.kernel.org/all/20251201082611.2703889-1-zhangshida@kylinos.cn/

V6:
- Patch 2: Fixed the comment format.

V5:
- Patch 2: Replaced BUG_ON(1) with BUG().
- Patch 3: Rephrased the commit message.
https://lore.kernel.org/all/20251204024748.3052502-1-zhangshida@kylinos.cn/

v4:
- Removed unnecessary cleanups from the series.
https://lore.kernel.org/all/20251201090442.2707362-1-zhangshida@kylinos.cn/

v3:
- Remove the dead code in bio_chain_endio and drop patch 1 in v2 
- Refined the __bio_chain_endio changes with minor modifications (was
  patch 02 in v2).
- Dropped cleanup patches 06 and 12 from v2 due to an incorrect 'prev'
  and 'new' order.
https://lore.kernel.org/all/20251129090122.2457896-1-zhangshida@kylinos.cn/

v2:
- Added fix for bcache.
- Added BUG_ON() in bio_chain_endio().
- Enhanced commit messages for each patch
https://lore.kernel.org/all/20251128083219.2332407-1-zhangshida@kylinos.cn/

v1:
https://lore.kernel.org/all/20251121081748.1443507-1-zhangshida@kylinos.cn/


Shida Zhang (3):
  bcache: fix improper use of bi_end_io
  block: prohibit calls to bio_chain_endio
  block: prevent race condition on bi_status in __bio_chain_endio

 block/bio.c                 | 11 ++++++++---
 drivers/md/bcache/request.c |  6 +++---
 2 files changed, 11 insertions(+), 6 deletions(-)

-- 
2.34.1


