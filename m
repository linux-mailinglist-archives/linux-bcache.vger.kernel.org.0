Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1D767EDEC
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Jan 2023 19:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjA0S7l (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Jan 2023 13:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjA0S7l (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Jan 2023 13:59:41 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C277F45F63
        for <linux-bcache@vger.kernel.org>; Fri, 27 Jan 2023 10:59:39 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id z13so5951338plg.6
        for <linux-bcache@vger.kernel.org>; Fri, 27 Jan 2023 10:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8FSfRUNSPzw6WDGkk9NuSWJ20Yk15j/9mQUC20/ywjM=;
        b=JbJ16pBT7IqjxBNPjSK5CDUwVUGhR/OnugwG+wWGEsBW1javshnmaTNBawxGtiCTdp
         hjeUc/BFKBLrv2j6Vkzr04dBesVNUv3Ybtgjww3OoV+TcgrPoKLH1c8jWFvG3t1VdV9n
         lLMGQtj07HEe4CIosgl0RZmz4koECGboCUjTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8FSfRUNSPzw6WDGkk9NuSWJ20Yk15j/9mQUC20/ywjM=;
        b=x32oKJA7LqTQp8kmmnEkSrSWXuJkGYk4S34I/y2RMoELGPuq+3+FAdwUcZjy8D2kr0
         RB32Y8B2yNhSVh9MM8g1N/iw/3VZuVz6nL1xhz94Ae38OKupOVCllmumapgjpJ2WdOnN
         J7bUulXsYh/DeXRiO6d/6dS2aawMJIeR+Py972tjWg94h3SIZp1n30e8Wg1BqyIddTnf
         tWeO+Ni/aguIRyK8SiVKJ8FswUGtNttCb55+hetuVsro5KmjKVrulGHiTb8CYG620SNJ
         sPYHPeR+Qh6U+rrykbR4sWKq0OPBdIj4sasJsIr4vn5s0g7FFOIP/HOlxl0F09nrT52v
         fHlw==
X-Gm-Message-State: AO0yUKXwHioQMCOFBLSvdeHzUTorsFacsSBwis1BDDqZ+3RLP4JIHq1R
        Nu1YCHkCfIWCbHLwiEXi3klBBlGtj8bRgqsG
X-Google-Smtp-Source: AK7set+R7u95YSQFcv8aA/dNQLjtSYZGUroZHCcbUYOQbH7Or+Zjje8xrH69dqdpqZ+AwKANkcV7Jw==
X-Received: by 2002:a17:903:234b:b0:196:595b:2587 with SMTP id c11-20020a170903234b00b00196595b2587mr2888516plh.20.1674845979328;
        Fri, 27 Jan 2023 10:59:39 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i15-20020a17090332cf00b00194799b084esm2395292plr.10.2023.01.27.10.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:59:38 -0800 (PST)
Date:   Fri, 27 Jan 2023 10:59:38 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Pereira <alexpereira@disroot.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Coly Li <colyli@suse.de>, David Gow <davidgow@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Kees Cook <keescook@chromium.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-hardening@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [GIT PULL] kernel hardening fixes for v6.2-rc6
Message-ID: <202301271058.9A715143C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Linus,

Please pull this small set of kernel hardening fixes for v6.2-rc6 that
haven't gone via other trees.

Thanks!

-Kees

The following changes since commit 42633ed852deadc14d44660ad71e2f6640239120:

  kbuild: Fix CFI hash randomization with KASAN (2023-01-13 15:22:03 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/hardening-v6.2-rc6

for you to fetch changes up to be0d8f48ad97f5b775b0af3310343f676dbf318a:

  bcache: Silence memcpy() run-time false positive warnings (2023-01-25 12:24:50 -0800)

----------------------------------------------------------------
hardening fixes for v6.2-rc6

- Split slow memcpy tests into MEMCPY_SLOW_KUNIT_TEST

- Reorganize gcc-plugin includes for GCC 13

- Silence bcache memcpy run-time false positive warnings

----------------------------------------------------------------
Kees Cook (3):
      kunit: memcpy: Split slow memcpy tests into MEMCPY_SLOW_KUNIT_TEST
      gcc-plugins: Reorganize gimple includes for GCC 13
      bcache: Silence memcpy() run-time false positive warnings

 drivers/md/bcache/bcache_ondisk.h | 3 ++-
 drivers/md/bcache/journal.c       | 3 ++-
 lib/Kconfig.debug                 | 9 +++++++++
 lib/memcpy_kunit.c                | 2 ++
 scripts/gcc-plugins/gcc-common.h  | 4 ++--
 5 files changed, 17 insertions(+), 4 deletions(-)

-- 
Kees Cook
