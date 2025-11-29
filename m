Return-Path: <linux-bcache+bounces-1294-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20AB1C93A88
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 10:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA7803AA5DC
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 09:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECDB2836B1;
	Sat, 29 Nov 2025 09:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OpCq5xV0"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420BA27FD71
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406921; cv=none; b=BaI06RM3FKVnfu68uQSJCrXE72UaXKeihErXkovW/X7r/1BZ9dUd+F82wn9eeCe1sBfxry5zfnuDorK9CGor8EafSoZLNdD1+cHOYIWG8kbOL1g+l6CsiN60QRPYTPFWPk/W6cZGpUqHYbZNRMBZBWQVa9o2mtHjuNdntblprH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406921; c=relaxed/simple;
	bh=rZqecGhzp3NmtFjaYLSNOTM+/xsMiNIYX8VY+Bn+fL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DxAwLghx6zIxkDAgHudNKSWJBjci1gCfDOiX7AX8XDp3ohh2GRfI3SM4aT38tRgIvvE8LHLoZ00BBkqs2R2n85jPNaK6n2EmqpWUkiAy3ZuYjBW5rithcB1MQa98TQOXNpf/JkKng4/1IbTpdj81VlWFToVIF2WyKiTpxZaQ+H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OpCq5xV0; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso3025735b3a.1
        for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406919; x=1765011719; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7vHs8yXaPj8mv/GRmviioQ8omsZI2Wqns1LW2Ikl6c=;
        b=OpCq5xV0GpYV4qxg49HqK8ixRDljLimfEEj14WmRfrjYfpR5HNvOpbtgtvfDbb1JQU
         PjIXGyqpJaoYAup3h5BOmV16imgDbeOqmuCZpGNFoAPAjMLKYOAb7GLZAhDTZsLb/7RK
         rK6+7uJKk85G5FJ9a+Fio6BBbWsk/B1Yw6he1A1AXzUU9HN6DZ9RHxFXolWtrnrwHXvk
         MAvKA/2qBAQDCTxl7D3Jjxh6hHRfidgQhmz9cHt+WeBpXaiGOr/2uWMavfMFFEobSNDi
         lZGpixsfz04G5WowFHqgCbQakJ8vW+p69P0G5tqi981sNpbX5x7y2+iKEAheyIRjnlh/
         7pSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406919; x=1765011719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7vHs8yXaPj8mv/GRmviioQ8omsZI2Wqns1LW2Ikl6c=;
        b=BwLFhJSdl6/Qzr4BrjWaq08vmRp8wJ0nj5w6iTSqEsjWgBhva4sbPVlg4nsC+HM/7Y
         qPifWIteDygPvXUsIKF97o3vi03aLovwDufrqSDmfLEHFCVWeDisTBEWTHopiBgWB1KU
         xJDywhqPGnGZfMu+Tljdh28TBV/yNdW0FkHfqDhG6AjKFxCTzAe6gLlVe6vB5LLZlcYN
         sD1HEFuhR76T7loZDM+rgZGrGXSnnHbisfPgd84N3G4utkBol9B1DyulQ7gMYLwTmWE3
         SC5stl67joAh9ruXkcOk7ZFrFh7bvfFbRpHl4cf4YMPQa0cMX5nhOYaqjOzYl+IsykiT
         ve0w==
X-Forwarded-Encrypted: i=1; AJvYcCUo8EnmxjKI/OYnF3kpj7guupx5K/iueoPqzfvVno7XQ+5sMx8CY6KU3tt22+lcy4zQZqT4puUtDvEpEIg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTLnzU0B8NJPI2VthvEClwSKQcO8szxL/8hLO9JCFKE1Xuj8tB
	HtSetJwGO1TG6wv3ZwSniWqaZp+R/O2ZzuGmoVkGcQtNKtIUuUIXdiUO
X-Gm-Gg: ASbGnctfBv9uNpyKaXWix3rsny2zWdnacSa1nBoJ0Vz4+RGjaAF2vHh9SfpNg8Sk4Nb
	c1MzJYbNmiwj5yaMNidlJcuNxWlpNeUmuQWFdqySmzIdBzCYxgYJf+uyVtlhDLCRFuTM3X+mRG3
	AmQsavBoj+tINgcEo6SgZzIgWUHaoXoveCNxhft3YqD1UjRDSY+14l42aTi+nEwjN8XAUhf9dxw
	oEcS8DP/FC9lejH9+ILNMx4X2oQ35b9XZzwXTTQSYybgRaP0TyHkwrlRPm3QealYx2Z+9VhllXu
	hdZ82+fKXD+bXfmuEL4olU0WovBar/acwCG4nxKyH2I+r2ZCn1zYhM8V6NEBlsOp+5GLKfvHkMa
	GlujzeuNBOmiKMndpx+gCqCEG6/a/qEnwUlgW7cftIdN84niy4UuNK7or+LXXsJhWhQHL3GGZrB
	SRqsY+ItljG6wxfFS+ogADpDRSs1Nyc4y3p32I
X-Google-Smtp-Source: AGHT+IFdL+OyABUQodQSrM5NvvO0TZqbCFx6Z3c8afGQwuwppQB6YRBsN5vK+YoTkxr7MD5m+Dfwkw==
X-Received: by 2002:a05:7022:41:b0:11b:b1ce:277a with SMTP id a92af1059eb24-11c9d8482b1mr17983636c88.28.1764406918534;
        Sat, 29 Nov 2025 01:01:58 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:58 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 5/9] xfs: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:18 +0800
Message-Id: <20251129090122.2457896-6-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
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
 fs/xfs/xfs_bio_io.c | 3 +--
 fs/xfs/xfs_buf.c    | 3 +--
 fs/xfs/xfs_log.c    | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 2a736d10eaf..4a6577b0789 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -38,8 +38,7 @@ xfs_rw_bdev(
 					bio_max_vecs(count - done),
 					prev->bi_opf, GFP_KERNEL);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
-			bio_chain(prev, bio);
-			submit_bio(prev);
+			bio_chain_and_submit(prev, bio);
 		}
 		done += added;
 	} while (done < count);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 773d959965d..c26bd28edb4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1357,8 +1357,7 @@ xfs_buf_submit_bio(
 		split = bio_split(bio, bp->b_maps[map].bm_len, GFP_NOFS,
 				&fs_bio_set);
 		split->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
-		bio_chain(split, bio);
-		submit_bio(split);
+		bio_chain_and_submit(split, bio);
 	}
 	bio->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
 	submit_bio(bio);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 603e85c1ab4..f4c9ad1d148 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1687,8 +1687,7 @@ xlog_write_iclog(
 
 		split = bio_split(&iclog->ic_bio, log->l_logBBsize - bno,
 				  GFP_NOIO, &fs_bio_set);
-		bio_chain(split, &iclog->ic_bio);
-		submit_bio(split);
+		bio_chain_and_submit(split, &iclog->ic_bio);
 
 		/* restart at logical offset zero for the remainder */
 		iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart;
-- 
2.34.1


