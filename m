Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39AD793354
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Sep 2023 03:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbjIFBX3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Sep 2023 21:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjIFBX2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Sep 2023 21:23:28 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A26197;
        Tue,  5 Sep 2023 18:23:25 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-50079d148aeso5261940e87.3;
        Tue, 05 Sep 2023 18:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693963403; x=1694568203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DAb5a/5vJWZRPKyeLyQVVrkpU2e0KdMpe+sJbTW5hw0=;
        b=cn1skmShno3tKyxph3fPzEiZIHNMuPBSncMZYRqcCg2yYlZ7w3jVD9cXvlaIN3Z/tV
         zQJpKZmJVAfBFjvYtNyGpDIfF7xtlRpCd6yTyhNFZiHJATVWMnj7zbzl10LaLbWqOGDd
         DaQv3l5FVEazyQmq/KIEDHSbMRNrSvYU94gmQ7LH8Owu5rfTDyw+jUqZbltf8AV+6tDA
         sOuPflEV8sPu5VW4jPCy6YLqWdDcdu79VXO9BIf3dB/ZlT5BgPrXIiF5p21faRAb5rnz
         2ctLeWe5Q0j1+fG4C8aIDZ6tiK9fqmlBZg2i0RC4Vg4Z5aDSJsZJnHSIk/AyMnIMP87R
         ZjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693963403; x=1694568203;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DAb5a/5vJWZRPKyeLyQVVrkpU2e0KdMpe+sJbTW5hw0=;
        b=hyRLnAMCZGkUjy5kLuOUshcqjtvf9LodO/XGCTB1n3plVdIMIEFoukRbQXB5zxYdjW
         wQLTdnyueDE0OJiJ4BpcZeGdnzDWVh1BrZ8knU2zD6cibVG5O4t6eMSByVNPaZomQx5a
         l0cAzl2eKyb5dOXC8ULaA+IUg6f6aBeMKtahNk/m4jei45eq5BQRRmb5/s4QETfHAtPQ
         CxRdMgSvdapl5z/5hrqrSpAgj2KsfR6fmBCd+ziGPv02iQ+OiYFLhLDTo1i5p6P5qZ/d
         +wW/0ttup/VKT0CmlL2wyT5/4WlFshH8RRcZjgYzA6e1P5ifgvHopJcdYVrLBauf3nnE
         8eGQ==
X-Gm-Message-State: AOJu0Yyi6YrlM4Bs209fPFvBJbGe6lN/rZl/kz6KMms4nUEY5WxZYIOa
        yZqYkCoAa1VB8UffmsQ+qA3yV+4VTkTViNz9NtI=
X-Google-Smtp-Source: AGHT+IG+1c84SvdH98L4G+HexRK1iQEBBz8QbtxAxgBQfuA/uLAYgCUVKoxR4Uv9Gs07Wt+7pG9tmA==
X-Received: by 2002:a19:380f:0:b0:4fb:889c:c53d with SMTP id f15-20020a19380f000000b004fb889cc53dmr849032lfa.10.1693963403210;
        Tue, 05 Sep 2023 18:23:23 -0700 (PDT)
Received: from rand-ubuntu-development.dl.local (mail.confident.ru. [85.114.29.218])
        by smtp.gmail.com with ESMTPSA id r21-20020ac252b5000000b004ffa08e1a4asm2538485lfm.198.2023.09.05.18.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 18:23:22 -0700 (PDT)
From:   Rand Deeb <rand.sec96@gmail.com>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     deeb.rand@confident.ru, lvc-project@linuxtesting.org,
        voskresenski.stanislav@confident.ru,
        Rand Deeb <rand.sec96@gmail.com>
Subject: [PATCH] bcache: prevent potential division by zero error
Date:   Wed,  6 Sep 2023 04:22:49 +0300
Message-Id: <20230906012249.49203-1-rand.sec96@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In SHOW(), the variable 'n' is of type 'size_t.' While there is a
conditional check to verify that 'n' is not equal to zero before
executing the 'do_div' macro, concerns arise regarding potential
division by zero error in 64-bit environments.

The concern arises when 'n' is 64 bits in size, greater than zero, and
the lower 32 bits of it are zeros. In such cases, the conditional check
passes because 'n' is non-zero, but the 'do_div' macro casts 'n' to
'uint32_t,' effectively truncating it to its lower 32 bits.
Consequently, the 'n' value becomes zero.

To fix this potential division by zero error and ensure precise
division handling, this commit replaces the 'do_div' macro with
div64_u64(). div64_u64() is designed to work with 64-bit operands,
guaranteeing that division is performed correctly.

This change enhances the robustness of the code, ensuring that division
operations yield accurate results in all scenarios, eliminating the
possibility of division by zero, and improving compatibility across
different 64-bit environments.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
---
 drivers/md/bcache/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 554e3afc9b68..ca3e2f000cd4 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1078,7 +1078,7 @@ SHOW(__bch_cache)
 			sum += INITIAL_PRIO - cached[i];
 
 		if (n)
-			do_div(sum, n);
+			sum = div64_u64(sum, n);
 
 		for (i = 0; i < ARRAY_SIZE(q); i++)
 			q[i] = INITIAL_PRIO - cached[n * (i + 1) /
-- 
2.34.1

