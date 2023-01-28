Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805A867F320
	for <lists+linux-bcache@lfdr.de>; Sat, 28 Jan 2023 01:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbjA1A0k (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Jan 2023 19:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjA1A0i (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Jan 2023 19:26:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADF3212BE;
        Fri, 27 Jan 2023 16:26:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A39A461DFD;
        Sat, 28 Jan 2023 00:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 095F6C433D2;
        Sat, 28 Jan 2023 00:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674865241;
        bh=xB1udaC+IlgxwFzrwEHvTb1Wxlzx+OgwDzgQozLjKO4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=kmZD80cCYk9faxanv7ua95jcnj8Df6YvrFfOMYHZIS+nYkHXb1V2eNaPzhm9HlG/x
         Tny+NY8khgkV4JRfKpFIaGqnIRQGcjrui2JzWadZBrhy6rYSy3jt+N5d0+3hsPwU6X
         T7h71PvqbNZ1YyVyE8NTq0gUBavnBWfe+dbS5yQEomW+RzdzrfayLxYxTbNVAatcOT
         gk8i5SRKEW/sfJLv3y1lkD5U+8JBLEowgL8X1jyWp73GvSvK3Vil+bTVJ8vvzDUs6r
         LGkz99M8obcOZVyxA9M2pz6FQ/l5FScE0ZRH8CJ43j28KwUYzwrSZN6Ua0pFHRwaZn
         TnAV2Epn/9l0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBDEEE451B6;
        Sat, 28 Jan 2023 00:20:40 +0000 (UTC)
Subject: Re: [GIT PULL] kernel hardening fixes for v6.2-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <202301271058.9A715143C@keescook>
References: <202301271058.9A715143C@keescook>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <202301271058.9A715143C@keescook>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/hardening-v6.2-rc6
X-PR-Tracked-Commit-Id: be0d8f48ad97f5b775b0af3310343f676dbf318a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 28cca23da7240df597240a492a7a7d4ce990026b
Message-Id: <167486524096.6770.12626188597583791081.pr-tracker-bot@kernel.org>
Date:   Sat, 28 Jan 2023 00:20:40 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
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
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The pull request you sent on Fri, 27 Jan 2023 10:59:38 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/hardening-v6.2-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/28cca23da7240df597240a492a7a7d4ce990026b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
