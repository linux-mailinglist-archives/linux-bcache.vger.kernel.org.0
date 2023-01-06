Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50CD65FB29
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jan 2023 07:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjAFGCj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Jan 2023 01:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjAFGCi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Jan 2023 01:02:38 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B26F6C7DD
        for <linux-bcache@vger.kernel.org>; Thu,  5 Jan 2023 22:02:36 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so4286801pjj.2
        for <linux-bcache@vger.kernel.org>; Thu, 05 Jan 2023 22:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+anX43Mu+MJERuRlu4YWa+yMoYVv49RcDXznbQT8og=;
        b=TQWkY0oklPgt/5r5cwlVo9/0J0Iztw/r7ZwqqWCfiaJ3MzTS223U360dspIUhp/6Ov
         W2ryG5VksV19en1B01GCNx5Blp8tkuWN9+Hcv2CBH1NjfIurxS3d/qRO6lVnW4xNySFi
         uEYY1OecqFbDKQA3D7PxeZ4NX0XKm5qooreVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y+anX43Mu+MJERuRlu4YWa+yMoYVv49RcDXznbQT8og=;
        b=3i42DevoeBIbwMkAI1qiO18UCFwMgPfv6QwfCiFS6kAd0RclZt6f/TqE9nBhZwfBeP
         BZ0W10oZCFl8IQRXlvAUyYbHsQIy9x5hkRvAJ+ImcGfg2mpUQxAB05WZipX5c48u6kmm
         TaJ7VKmNcYH28er/EzXst/UnvsiILT4nHjnx6LKGq2qFiuSfGlz7xVZTSsDPgbkL7/Yo
         icZ6zFLYZC9aVa5U+44UBTfbHxX4ynQA0B1N6Oup5H86usDmZswXBBilTsfWjlGERZy/
         RdT4ClM+jQy112se6mrPj6p9fDtidZ0rDU5QYkbNLObP3n0VZWHKo5mh0+oCyxSinwKP
         ts0A==
X-Gm-Message-State: AFqh2kqegi3LQPBMJZPnFbDm+66c1TDvL/HvKHFP9OZKhTVn6VoGo3Vo
        pmgRuQf6yj8ue+S490ryNPpwUg==
X-Google-Smtp-Source: AMrXdXuPxHZEHMiDTLNVSwPBxfOyDu7WzK+fS6EAV8dn+kJPPDy/gc9tidjrLkicbgJmXHKj2Yx3pA==
X-Received: by 2002:a05:6a20:8b89:b0:a7:a591:4fca with SMTP id m9-20020a056a208b8900b000a7a5914fcamr57145215pzh.61.1672984956350;
        Thu, 05 Jan 2023 22:02:36 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q15-20020aa7842f000000b00580e3917af7sm263876pfn.117.2023.01.05.22.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 22:02:35 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Coly Li <colyli@suse.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Thorsten Leemhuis <linux@leemhuis.info>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] bcache: Silence memcpy() run-time false positive warnings
Date:   Thu,  5 Jan 2023 22:02:33 -0800
Message-Id: <20230106060229.never.047-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2294; h=from:subject:message-id; bh=hTGH6NubMvHnfos0JgY0W0bCNHZlDQ5kCsJbr0ADcY0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjt7l5Xn8LxEcT24jMoUZlJV8VEac0DCWD7svpNFHI yMy3+VaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY7e5eQAKCRCJcvTf3G3AJjHiD/ 4giyGiIV4i/gX19THV5iQPRflDiE5uFQ4U5i4aNgMO4xSRe0h7fdAAd9H2hbcvQ5QMcC5Fp9x5XiYW 1d76Qh1qODHd6Xqh0TZf0nWjemG0WVgp6e1J9ELcMzOt5b6Vx6clehvCmD+ZWT94mFIiN3Lj9E1prN /H+LxGCQWt8gDOY+jJmoecUftIBPFP5EBY9nLqv8IVzNyNZUKAE+0C1psgsWC/UWyNbM2VWCxZIGr8 lbHRbNCUm/l4YNxmkrL5jRFtcnn+9LOMrJB3DGl3OdhjATJDNHMXR0i35XwwXFc8V82AC9xl/MKyGQ 8AX3wkEcq7IkJxiGfgF68iIglGoO5Q8x9HX1RScGBi9CP/abFFjI22dSqt7meoxDw+HZc+UuGvYLg9 QvxJwODOjWzl6l+Hposek0iHpSFubiB39TU2sTa+Z5UAQry2mQNBrUOh9ngYrjEXLJKo2JH4q+rCbB fzcW3YfR13fg3J+Fq7voE4mxuYzLQiG31IFiaO6W0xwL1L+ypmVouBwJ16zBiW1uH27KO909OFs9Z/ ThkVd/H8u5E1d1k6T/OP4TNRxHV1/1ljFiu6t+BpU1UtGliAIgkarWRvGdiApxpjbZmpfBUP+FWVJn bJDIE9UCb4EpRBlZAmbBuUvw6MlaZP5NWpRDumhgpLSbZhz8y8rb35MTiHog==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

struct bkey has internal padding in a union, but it isn't always named
the same (e.g. key ## _pad, key_p, etc). This makes it extremely hard
for the compiler to reason about the available size of copies done
against such keys. Use unsafe_memcpy() for now, to silence the many
run-time false positive warnings:

  memcpy: detected field-spanning write (size 264) of single field "&i->j" at drivers/md/bcache/journal.c:152 (size 240)
  memcpy: detected field-spanning write (size 24) of single field "&b->key" at drivers/md/bcache/btree.c:939 (size 16)
  emcpy: detected field-spanning write (size 24) of single field "&temp.key" at drivers/md/bcache/extents.c:428 (size 16)

Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
Link: https://lore.kernel.org/all/19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.info/
Cc: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/bcache/bcache_ondisk.h | 3 ++-
 drivers/md/bcache/journal.c       | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
index d086a0ce4bc2..6620a7f8fffc 100644
--- a/drivers/md/bcache/bcache_ondisk.h
+++ b/drivers/md/bcache/bcache_ondisk.h
@@ -106,7 +106,8 @@ static inline unsigned long bkey_bytes(const struct bkey *k)
 	return bkey_u64s(k) * sizeof(__u64);
 }
 
-#define bkey_copy(_dest, _src)	memcpy(_dest, _src, bkey_bytes(_src))
+#define bkey_copy(_dest, _src)	unsafe_memcpy(_dest, _src, bkey_bytes(_src), \
+					/* bkey is always padded */)
 
 static inline void bkey_copy_key(struct bkey *dest, const struct bkey *src)
 {
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index e5da469a4235..c182c21de2e8 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -149,7 +149,8 @@ reread:		left = ca->sb.bucket_size - offset;
 				    bytes, GFP_KERNEL);
 			if (!i)
 				return -ENOMEM;
-			memcpy(&i->j, j, bytes);
+			unsafe_memcpy(&i->j, j, bytes,
+				/* "bytes" was calculated by set_bytes() above */);
 			/* Add to the location after 'where' points to */
 			list_add(&i->list, where);
 			ret = 1;
-- 
2.34.1

