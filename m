Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC358507675
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Apr 2022 19:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbiDSRbV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Apr 2022 13:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbiDSRbV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Apr 2022 13:31:21 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D60C37
        for <linux-bcache@vger.kernel.org>; Tue, 19 Apr 2022 10:28:38 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id g21so18343536iom.13
        for <linux-bcache@vger.kernel.org>; Tue, 19 Apr 2022 10:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=K5ibByWrOCHCBv0qUI+fEMoOYO/eUhGaHXlxiLBVdYA=;
        b=JjW1DwYeXtUI5DPl8PPEJu6OZNrdTaowXJUkipAmH5BHbZZsK2Cw9ecZqmMCPv+rXS
         tF3twI+mF1CpPTFBngjYTDj3BamWovinnM4eE7bB6PwJ0wJA8y77xTfY85kLnkCwekEJ
         tl1rmU+mFXglWeLGApscB7dBe4nh80o+tMwz5Kw+vSYJ+uCMH/nvx542ZQ719R3C45Tn
         yW3pxNfsd9RjpdtyHNnfKUze47kqW9r8wqmYyPPJ4TuxCmo8IdZOtqqvsAAU3cddj8lp
         9aZwByiO4JeAQM0Qo0fhRRVMv8pE5Sup/YP5n+lDFX6lGx4Vo3bbuP4ucHyHkBdJUFTT
         YH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=K5ibByWrOCHCBv0qUI+fEMoOYO/eUhGaHXlxiLBVdYA=;
        b=1MOBleo6oMsQDGuh3xeQuYelvLFB8vDMp5PgzpTz3p6DYaVnC9dm+Zp90HXC8imDFl
         Pbz4DP9aruvFQK9MAOOeVM/bQ1rjuxjx+h2NyzKuE26o5x8MpJMocR4A0AlTVz9BJ+/v
         PuaXKeQdZv7Y0bHLY+IC9o7XzAKuQ0Z7kZyIv3xVezWXzyTDaaZKK5IUPxn4eTNxstOa
         KTz7BPPtxzwBHPAcZwd3a38bTomAI9IhEn6xU8HUu2UDiCs3w1iE5SBEp7Jimi0xwLoU
         Hwmr3F6VCbtvwJ6m/Sj02fF4vUX4qxLFsXmEeQYmLIeg/f6C4iZK6M0r9nnxtrLINp7w
         BuEQ==
X-Gm-Message-State: AOAM533VpSSGQktFN/ksn8NDxAJpa3gw3TxnqP21h6xXn1vPNNIh127V
        zZA6Wh3hGIO0AoOWMQlO8/u6yQ==
X-Google-Smtp-Source: ABdhPJxtRNT5EtYAifxVnI7p9MYsdR+ycAsLjJUaGuEWTHfdw0Nl2OvJLb4yJhPdn3DAeyHvkZ87tQ==
X-Received: by 2002:a05:6638:d8c:b0:32a:8207:5562 with SMTP id l12-20020a0566380d8c00b0032a82075562mr1184638jaj.178.1650389317451;
        Tue, 19 Apr 2022 10:28:37 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e203-20020a6bb5d4000000b0064dafa0416fsm10026398iof.2.2022.04.19.10.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 10:28:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     colyli@suse.de
Cc:     snitzer@redhat.com, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        kch@nvidia.com
In-Reply-To: <20220419160425.4148-1-colyli@suse.de>
References: <20220419160425.4148-1-colyli@suse.de>
Subject: Re: [PATCH 0/2] bcache fixes for Linux v5.18-rc3
Message-Id: <165038931635.226604.10514697822185905339.b4-ty@kernel.dk>
Date:   Tue, 19 Apr 2022 11:28:36 -0600
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

On Wed, 20 Apr 2022 00:04:23 +0800, Coly Li wrote:
> There are two regressions introduced in the generic block layer changes
> from Linux v5.18-rc1. Both of them may panic the kernel, please take
> them for -rc4.
> 
> Thanks in advance.
> 
> Coly Li
> 
> [...]

Applied, thanks!

[1/2] bcache: put bch_bio_map() back to correct location in journal_write_unlocked()
      commit: ff2695e52c9936febf65aa36a1769881da71bec5
[2/2] bcache: fix wrong bdev parameter when calling bio_alloc_clone() in do_bio_hook()
      commit: 9dca4168a37c9cfe182f077f0d2289292e9e3656

Best regards,
-- 
Jens Axboe


