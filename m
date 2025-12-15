Return-Path: <linux-bcache+bounces-1352-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id ED45CCBC274
	for <lists+linux-bcache@lfdr.de>; Mon, 15 Dec 2025 01:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E830F300769E
	for <lists+linux-bcache@lfdr.de>; Mon, 15 Dec 2025 00:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E4D2FDC3D;
	Mon, 15 Dec 2025 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZYqolXH"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF3B2FD679;
	Mon, 15 Dec 2025 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759321; cv=none; b=LUNpEA/YC+D80CHwJOHtDrcbIcO/acm/2d75URAZIJxaL/NMFct9Lrh08iAu0/oRBw/7xYM/R9NAZKULVo8SYuG49nlY+fH/obmmbozSVMh88PdNdwb8qsHV77IUrN/a+9hBK2g48nfnrxjfGRL8uqoNWiu7snvdr1GopYu0gQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759321; c=relaxed/simple;
	bh=3Qj265UrbssCIwX1v5j+Fo9Ll7BNWo0kYrEq6sI6/NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVA9P3jcsfCnruMrgwXeqzi4/SdnDuBM3wi/zKQ6WNyV6rsC+h0AGHEWF47b8vrkorJIzgGH2KvXPkIZTwSRKB7youbG8jN6QBmQc+vRWaK8AEO4J3x85BOAs9cYO1jMQQPYCt1N1VLhrlHKjoy51z4bh4vwtQYBPRTmmiXpz9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZYqolXH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A55C19421;
	Mon, 15 Dec 2025 00:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765759320;
	bh=3Qj265UrbssCIwX1v5j+Fo9Ll7BNWo0kYrEq6sI6/NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZYqolXHce2YC5DIE+5XzOcKxM34pb/xAicTuZvvhveZDWFRD9iHIDnqaB8rosg5e
	 LzFpiM2oj4ye5E+tBoDV+QEnRvXx66yd1mGOsmV4LQVa208AKhRSigWuadRXunu+9H
	 VZwYt/ALv3X9HZcXeyCr1/El0LfJpIYxrRB1CzMGGd0fX39W2Z2aI58ttrkBeHGkcG
	 Uo2UkaaCVKb65NuObTZqaBsqfWGInIVPrRUYhL+9z8LL6Vrc4scWNvSDgDO/afQTAL
	 8WQZ3zrc+afBje2cCmbOr7S4gHIgDX+WP+gDjjnOltrVgcgI45ffK/q/ouqGFLFJBG
	 pmF8FfWSPmw1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shida Zhang <zhangshida@kylinos.cn>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	colyli@fnnas.com,
	kent.overstreet@linux.dev,
	linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] bcache: fix improper use of bi_end_io
Date: Sun, 14 Dec 2025 19:41:23 -0500
Message-ID: <20251215004145.2760442-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215004145.2760442-1-sashal@kernel.org>
References: <20251215004145.2760442-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.1
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

[ Upstream commit 53280e398471f0bddbb17b798a63d41264651325 ]

Don't call bio->bi_end_io() directly. Use the bio_endio() helper
function instead, which handles completion more safely and uniformly.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of bcache commit: "fix improper use of bi_end_io"

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly indicates this is a **bug fix** addressing
improper use of the block I/O completion API. Key signals:
- Subject explicitly says "fix improper use"
- Body explains the correct API (`bio_endio()`) should be used instead
  of direct `bi_end_io()` calls
- Suggested and Reviewed by Christoph Hellwig - one of the most
  respected Linux kernel developers, particularly in block layer code

### 2. CODE CHANGE ANALYSIS

The commit makes three changes in `drivers/md/bcache/request.c`:

**Change 1** (detached_dev_end_io, line 1107):
```c
- bio->bi_end_io(bio);
+       bio_endio(bio);
```
After restoring the original `bi_end_io`, uses proper API for
completion.

**Change 2** (detached_dev_do_request error path, line 1122):
```c
- bio->bi_end_io(bio);
+       bio_endio(bio);
```
Error path when `kzalloc` fails - uses proper API.

**Change 3** (detached_dev_do_request discard handling, line 1139):
```c
- bio->bi_end_io(bio);
+       detached_dev_end_io(bio);
```
**This is the most critical fix.** At this point, `bio->bi_end_io` has
already been reassigned to `detached_dev_end_io`. The old code was
calling the *saved* original handler directly, completely bypassing the
accounting and cleanup in `detached_dev_end_io()`. This could cause:
- Missing I/O accounting (`bio_end_io_acct_remapped` never called)
- Memory leak (ddip structure never freed)
- Incorrect error handling for backing device

### 3. WHY THIS IS A BUG

`bio_endio()` does more than just calling `bi_end_io()`:
- Handles bio chaining/splitting properly
- Manages completion accounting
- Ensures proper memory barriers
- Provides unified completion path expected by block layer

Bypassing this function can cause:
- Incorrect I/O statistics
- Race conditions in bio completion
- Potential memory issues
- Missing cleanup (especially Change 3)

### 4. CLASSIFICATION

- **Bug fix**: Yes - corrects improper API usage
- **Feature addition**: No
- **Security**: Not explicitly, but improper completion could lead to
  memory issues

### 5. SCOPE AND RISK ASSESSMENT

| Factor | Assessment |
|--------|------------|
| Lines changed | 3 lines |
| Files touched | 1 file |
| Complexity | Very low - simple API call substitution |
| Subsystem | bcache (mature, stable subsystem) |
| Risk | Very low - using proper API is strictly safer |

### 6. USER IMPACT

- **Affected users**: bcache users (SSD caching in front of HDDs)
- **Severity**: Medium - Change 3 especially could cause I/O accounting
  issues and memory leaks for discards on devices without discard
  support
- **Visibility**: Subtle issues that may manifest as accounting bugs or
  resource leaks

### 7. STABILITY INDICATORS

- **Reviewed-by: Christoph Hellwig** - block layer maintainer provides
  high confidence
- **Suggested-by: Christoph Hellwig** - issue identified by expert
  during code review
- `bio_endio()` is a fundamental, long-standing block layer API - no
  dependency concerns

### 8. DEPENDENCY CHECK

- `bio_endio()` has existed for many years in all stable kernels
- bcache has been in mainline since ~3.10
- No dependencies on other commits
- Should apply cleanly to any stable tree with bcache

### CONCLUSION

This commit meets all stable kernel criteria:

1. **Obviously correct**: Uses the documented, proper block layer API
2. **Fixes real bugs**: Third change especially fixes missing
   cleanup/accounting
3. **Small and contained**: Only 3 one-line changes
4. **Reviewed by expert**: Christoph Hellwig's review carries
   significant weight
5. **No new features**: Pure correctness fix
6. **Low risk**: Switching to proper API cannot introduce new bugs

The fix is surgical, addresses genuine API misuse that causes real
issues (particularly the discard path), has top-tier review, and carries
essentially no regression risk.

**YES**

 drivers/md/bcache/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde14..82fdea7dea7aa 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1104,7 +1104,7 @@ static void detached_dev_end_io(struct bio *bio)
 	}
 
 	kfree(ddip);
-	bio->bi_end_io(bio);
+	bio_endio(bio);
 }
 
 static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
@@ -1121,7 +1121,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	if (!ddip) {
 		bio->bi_status = BLK_STS_RESOURCE;
-		bio->bi_end_io(bio);
+		bio_endio(bio);
 		return;
 	}
 
@@ -1136,7 +1136,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 
 	if ((bio_op(bio) == REQ_OP_DISCARD) &&
 	    !bdev_max_discard_sectors(dc->bdev))
-		bio->bi_end_io(bio);
+		detached_dev_end_io(bio);
 	else
 		submit_bio_noacct(bio);
 }
-- 
2.51.0


