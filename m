Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4760A536CF4
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 14:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbiE1Msx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 08:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiE1Msw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 08:48:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D6A140B2
        for <linux-bcache@vger.kernel.org>; Sat, 28 May 2022 05:48:50 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id x2-20020a17090a1f8200b001e07a64c461so9342154pja.4
        for <linux-bcache@vger.kernel.org>; Sat, 28 May 2022 05:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=MnagosiILgWcElXIwikX5UphVikopylBoWqMoiiMl5s=;
        b=cDdWhmYZ12EuRnQEYuNTiOsn2Z4q9Hizo0Y/sTGqlofQlsFknWPNL++0xlSgFUUPCp
         TZsw9XBGIsYuruj+rvzhYxxFSyshhkm/MLQM3csnm9eraulRIPjUIkomdZxn5RMXB8TA
         7E8SzIBqGj6NyVxVqUZN5z7/dqwudKdo+TFG0mnNbyV1AcGCnXgRQDN4X4YOEj04fpQP
         4Hlg1aAON7r8Y17SffO9i+M1mNZc1f1Nla+TaG65lCNMYMr5tz1BScQWVS0KEa1D0o6D
         8SBaG88NhZ/T5bExc0UKJip6b3dyobBJjIWAg6gyuevVYZJ0+TvtA9OSnleWxn0JpsMO
         J9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=MnagosiILgWcElXIwikX5UphVikopylBoWqMoiiMl5s=;
        b=XFDQs9dxp64yIx3gqyNwmTTSEpwoezdHi7YuOiFQNEetaFbDJUopOdAvnfiXwhjYvH
         X5eUmzRzuPD6puXB9oW0u5N4ecy+2tAQmYHWAUsqok203ThsDWA11fg7t5ITAuUgOvUk
         vJLKt0j0Hod21yEAAmxXgd/dWGNHnAOYdkV9Wbv9lxQh0ldBs1zbc5ThDIr0wtmH2J8L
         Ht4Kcm88eIyNnLjazNMgnPiAMusXVrRON7y8oW8ZjEhwfMSzVW8zIBo7X+Zbg6is6h8F
         XBEILYlwUA9/te5YKsTL7GqUC1rJ5aGt9VK7yi40fM/gQVIxEW4w1PmtD30+R3y/6JwN
         n+VA==
X-Gm-Message-State: AOAM531VIqsEXuvwsLFarqQFXAwcBWZHzj75aNNB6ijAxR5shql1ydPL
        bllXwivHf0lT1aiDWQZ82A+N7t83eG3sqQ==
X-Google-Smtp-Source: ABdhPJzCGtiYY0UDNOsKgV5dFa6cy4cXR83xuIF5LkbPl3FXIivXuTdIqIwgjkn8aLYYLLdR/Ak0SA==
X-Received: by 2002:a17:903:1d1:b0:162:3dfd:adaa with SMTP id e17-20020a17090301d100b001623dfdadaamr23286342plh.22.1653742130080;
        Sat, 28 May 2022 05:48:50 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z6-20020a170903018600b0015e8d4eb25bsm5623040plg.165.2022.05.28.05.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 05:48:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
In-Reply-To: <20220528124550.32834-1-colyli@suse.de>
References: <20220528124550.32834-1-colyli@suse.de>
Subject: Re: [PATCH v2 0/1] bcache fix for Linux v5.19 (3rd wave)
Message-Id: <165374212924.762356.8804693148122760367.b4-ty@kernel.dk>
Date:   Sat, 28 May 2022 06:48:49 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, 28 May 2022 20:45:49 +0800, Coly Li wrote:
> This is the last bcache patch from me for Linux v5.19, which tries to
> avoid bogus soft lockup warning from the bcache writeback rate update
> kworker.
> 
> Comparing to previous version, the only change in this version is to
> change BCH_WBRATE_UPDATE_RETRY_MAX to BCH_WBRATE_UPDATE_RETRY_MAX. This
> is only about naming change, no other thing touched.
> 
> [...]

Applied, thanks!

[1/1] bcache: avoid unnecessary soft lockup in kworker update_writeback_rate()
      commit: a1a2d8f0162b27e85e7ce0ae6a35c96a490e0559

Best regards,
-- 
Jens Axboe


