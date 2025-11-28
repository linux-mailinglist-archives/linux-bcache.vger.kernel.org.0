Return-Path: <linux-bcache+bounces-1273-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6728AC91334
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:35:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0AEE04E6A2B
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EFAE2FD1BF;
	Fri, 28 Nov 2025 08:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUi/xMAG"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9477D2FCC1A
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318801; cv=none; b=YReRDPaaOA+FUmOc39AhWgMTseyDd9+iOatIeFCTnKnRMdMAgfr0GNNHzYHLHdiAGRguskvj+7Stsvf80LaSjY+riT8FR00McT2niROyVFZVJaJ5sqStapCrbGM/EB74ITmvqV2LzmTH38R9x2RSfPmTLlAR74cLJGyFSy+jmvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318801; c=relaxed/simple;
	bh=Hfn+I4xKib6YHUNH+g6fjmCyECLvbavw8yPYoNL/5CA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dijvbtkWhee/iLK7CZ2nLB+tT+qSoh1/i6vAOfqvRTZFV+LEsBBjxccurF9tV9qWKrlGM6dAC9F07wec1mc++FKg2CVp+J2QevV/vzLUtORUfGr5ImexN83e//nq681A9iqd1ex+D8BjujspUCdd48PJpwHF5S8tpsnsghq3O0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OUi/xMAG; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7aad4823079so1395919b3a.0
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318799; x=1764923599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=OUi/xMAG412JYQWqySKUfzoBptHS4/Qe8BOfLx1Cl7Ol+ZrysScGuSCbCSD832sagK
         E2WVayGv/dFEuvs3uezePHhpenkhUJLWlEWRdXBi0+7UKy4yLs1/7RbnYaoYGFlgMvpC
         ifZxtMlbt5rIFtBO7OFqKBQ1L4bCpYAdoX2eDKAz4KVeJqP0rWJAhziBh5ZQJZMY/DNy
         H0HbeiwnWIhXZ9LZnKl1d6uWdhJoY2QxPPZd2n1+PQMGtQPJj/gMdhpIVwsNWsx0Lykp
         PnNT804fJRSb5AQKhnUVPvisdKk7jejR5ztxyrbImwCfmqeTl42L6fq7+FW91/eRitbr
         LDnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318799; x=1764923599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=o10E3eNk7T1RoNDbf14fvPA8oB47eJw4BflqJ1cIoXv07pANFw28X6YgNQt29Aby0W
         qoUjQQgQDgDY/Oc58YMTDan97wwNat0BZruZ81gVtpDw7X7YROMrZz0jEe+TG1QUat3m
         FWEFQaEbl8R50JpY6g9jgao7PkDMENLr8Uro5BiENmcIVI9l6qWer+/pWJxYBX+0BeHR
         E2/2z/esmH6+McauRwSviqrTXsIhJV2zpUC6AzQqxtdwPmKiz6hTUPsApLMJrwQzKSkd
         ipJpkTPct4FgX+i4YnZgXKVNXEfJeS2KPwBjZ7EWzeFhpcVbQ4tcVBvH/4PCSQIHUYsi
         tKCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnNJbEFbild1xFPWlvM9S80mWv3WozJuktwaykg9GLiafvsYNyaCFQ5gv1fQ0ol4XQZz5K5m6bPrsez6s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1IzS/XeDW0PUlWPvYa6XzEGIniLOOVS8H1eCLlgR1MM6t/jKq
	DC6RfHQX8/szebfvtVLXodUgzpCqNwUfiDjR82ls0GZiZDeazsYCdQ89
X-Gm-Gg: ASbGncs5T3fVhpHn3HV29johQmHGR1DLBkNY0JKU4Hzi5QIZVfN+Qic88PdNKw2RVQ/
	sKXWV+uvFk55LGs7FSDSmIdqgyd+EuCLUNxtpzVQA6LgDt1Re+6jxZxBWHXBlfyynAeMxPzljVN
	RX4A2dUkc6qLKmmN+3V6q68Gk0ukVTry3450FOvxjGcP6QR0j6t9LZKvQjRvP4IUo3E6wEjGnyQ
	GzVJxLzc+HDOPZA6DlsZTxJSCQrz4/V77+JpFpxWuREegpVjsKpgAs0MYur9zA4qLTzZEtN04kT
	BP0ldUtNFh8L/To0IhwLlqeNPle8yKXZNnTa01OscLoT+yj4ed95GMHlw11BFXkHm4wlRAMyyc5
	h7LGPFLOQ1/bvahDZ+leZ3zhbw9+BrQwWtiNGXam69EeZcTwXfQUQ2Mvu+YTDDjkf2nNOxJ3AA1
	gtstLZsUTxa2DVDdE8BFG3XG3niQ==
X-Google-Smtp-Source: AGHT+IHKXq8x9elSCjEHks4N7hQUevj8WxDVP5HKi9llAEtlIQFfHNb05BLq+B1Nz6uA8fi9DHZiww==
X-Received: by 2002:a05:7022:671f:b0:119:e56b:91f2 with SMTP id a92af1059eb24-11c9d870411mr17436186c88.35.1764318798796;
        Fri, 28 Nov 2025 00:33:18 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:18 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 08/12] block: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:15 +0800
Message-Id: <20251128083219.2332407-9-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/squashfs/block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index a05e3793f93..5818e473255 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -126,8 +126,7 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 			if (bio) {
 				bio_trim(bio, start_idx * PAGE_SECTORS,
 					 (end_idx - start_idx) * PAGE_SECTORS);
-				bio_chain(bio, new);
-				submit_bio(bio);
+				bio_chain_and_submit(bio, new);
 			}
 
 			bio = new;
-- 
2.34.1


