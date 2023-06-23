Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1346E73C3D1
	for <lists+linux-bcache@lfdr.de>; Sat, 24 Jun 2023 00:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjFWWKl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 23 Jun 2023 18:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjFWWKk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 23 Jun 2023 18:10:40 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4885826BB
        for <linux-bcache@vger.kernel.org>; Fri, 23 Jun 2023 15:10:39 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-668842bc50dso198949b3a.1
        for <linux-bcache@vger.kernel.org>; Fri, 23 Jun 2023 15:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687558238; x=1690150238;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SzqZd/rs9XYD8T9ZWwd9xXE99AaUzhjzNilQFiXD8tA=;
        b=plZ9Ss8EYoJvi92flqa53vJztJaLFBvTr1Bxf5sJJeZUPEyAUIAw7f6lFy90fuMGud
         iXoM40ubKBOKyl/f7zWFZRHmkec9kp9z79mHeGZO7eu5nDq8FKz+eOckFnLbhlw0coYx
         9gpy4F+2jaFrFG5mWEfPUlFBYW0eC3qwVjahbcDO9p93UAgmK1Tx0lInZ1NoUhPfLbWJ
         slp+koO3uDbkgip7YZSUGCy9ENvKqLoTi2tJO1FZGhkjVCPgNxjJQrPSh+eHkRjIsAbR
         rHnF4+uzCkWXasyOufQkHUYU1ye/AGkN4jx3bvf5ZzBq276fTNThlw2ZXN3Rfelsjp3O
         BVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687558238; x=1690150238;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzqZd/rs9XYD8T9ZWwd9xXE99AaUzhjzNilQFiXD8tA=;
        b=ja/bOWbojiEoxZr5znSOuXFFKj/QMFMrNYwPd6hItT1uQVpi+WQqPzwyIztDV2pivM
         Ey+eKopN8ugrUfVgmUKSrqV5qyWQzQrGw2PAgnE3yTveF1AuUrLqrMTLYX7nz5Rxy/Dn
         YQ7RqEXUZ4IMNfNNnWRBgWhwDMepzOVGOGSDOSWNKXlN87MSDHPALgpi7Om3qeNt3B5U
         ItmX7dnKUbomB4rwaFJXijsgGoClWfRQSdKJWB0hPX4Qzd5990TPUKEz/AeM+Kd7QzjU
         mNByDm2k7n33DbPvuEetkMOyOMv8cGHRaO+Tu602EC+eDqLnCpw/qGiNuVizQB6xiqfn
         3LSA==
X-Gm-Message-State: AC+VfDyNO/ZIHenrHoYhn+OercOZahQJbpcE2zNlfYjUAtPTuvhhDdWz
        VYZdKVXI8ftg5nQ/G1TDAFfQREZ8ZmvvmCLqcZU=
X-Google-Smtp-Source: ACHHUZ6bPodQfqXgmATrMMfGoCuKvI9pKdnXbycRidjjsnXWigbKjL144KWlVAkb76PbwvN0mNjRRQ==
X-Received: by 2002:aa7:830b:0:b0:66c:2d6e:58b6 with SMTP id bk11-20020aa7830b000000b0066c2d6e58b6mr2142881pfb.2.1687558238231;
        Fri, 23 Jun 2023 15:10:38 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j2-20020a63e742000000b00476d1385265sm150061pgk.25.2023.06.23.15.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 15:10:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Coly Li <colyli@suse.de>, Jan Kara <jack@suse.cz>
Cc:     linux-bcache@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>
In-Reply-To: <20230622164149.17134-1-jack@suse.cz>
References: <20230622164149.17134-1-jack@suse.cz>
Subject: Re: [PATCH v2 0/2] bcache: Fix block device claiming
Message-Id: <168755823703.745948.18293679494417829590.b4-ty@kernel.dk>
Date:   Fri, 23 Jun 2023 16:10:37 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Thu, 22 Jun 2023 18:46:53 +0200, Jan Kara wrote:
> these two patches fix block device claiming for bcache broken by recent
> Christoph's changes to blkdev_get_*() functions and also cleans up the layering
> violation inside bcache which was the underlying cause of the breakage.
> 
> This time I've actually tested various modified error handling paths (which was
> good because one of them was indeed wrong!).
> 
> [...]

Applied, thanks!

[1/2] bcache: Alloc holder object before async registration
      commit: abcc0cbd49283fccd20420e86416b2475b00819c
[2/2] bcache: Fix bcache device claiming
      commit: 2c5555983bd27d24162534b682b10654639a5576

Best regards,
-- 
Jens Axboe



