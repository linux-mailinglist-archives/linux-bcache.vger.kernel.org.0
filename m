Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BEC5364E7
	for <lists+linux-bcache@lfdr.de>; Fri, 27 May 2022 17:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348133AbiE0PuM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 11:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242714AbiE0PuL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 11:50:11 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2424134E11
        for <linux-bcache@vger.kernel.org>; Fri, 27 May 2022 08:50:08 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id f4so5047967iov.2
        for <linux-bcache@vger.kernel.org>; Fri, 27 May 2022 08:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=n/fJ9wjC1pXIX0DkPRAjEiWZ9G1KQvCFPCpSJkb5kZs=;
        b=HHVjUg8t4BWFFgTKNQj18T7ROAfp8yg3lU1yYo3y5F7lcH1FgXr5rV0DWfzjs63qIo
         HhkcCTMKyf+YiTJyNyCl5LnUBI5n+6bkABchoWZZe++/BmlDlprh/CgKz2cslBjFAESt
         0I46rY6nNzUpEHl8OkXwyipRNsAcokT2/n5tBpZ3XXXxfvtVR2JAmP1VGCH977ohz5k0
         71ThdrNoFx3MQx+zgIKpZzk0/ec/MEFsy0aP8ZstL2E1Wm/qSmB4d6xHOUPWjDq0qRrm
         6THasFNsoZK1l/s2ZqOk8Q7gxsRtonRUahfG4E0VZnKXHVxGIrBO6/JxN2+GmCuJkxDL
         XU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=n/fJ9wjC1pXIX0DkPRAjEiWZ9G1KQvCFPCpSJkb5kZs=;
        b=FZ23QH2lp5NFZ40Q5owfUZW0Lyv01C4riN6qmkmZhDKWxlglY/8pDPSfKniowfJF01
         41BHVJO7+7xwY198AqPyEj8hqUbbNbXiL6MVUvgjl3rk00nz03kGMez8yhY0SOkFl7rG
         4HI0BtsijhtQ1vsxWdiW+/i6hsqzs70n/th4Pm2bk7d6uU52RNOI9JtHgiXxlk1WN0cS
         dVWarmAuvYJv4aOg2bBFIq0Z+1+HqLhc0dr25cw/NT6cV1TMZJEMA8Sikns86u7siJlw
         ztlsmcst+Wn1XVUFDKrgoPd8LitAjc0Kybe+iGu13/NOYcgcKx+JqrZOfamUt3PbMCDO
         dYMQ==
X-Gm-Message-State: AOAM530IItDH0ORMbA0WxXjNZMeia6zCT/nPnKyktbVWgzgKJShnaugv
        6MXWrF9xCrLCnIYV2WSAgCbtYw==
X-Google-Smtp-Source: ABdhPJw2KdfmHyyNNE4chqN4Y7/j5DxuJsK4COnZirkfKvSFiDy3UwdbdrfGBhj/0lAasoeyVWU6ZA==
X-Received: by 2002:a05:6638:4883:b0:32e:4d19:4583 with SMTP id ct3-20020a056638488300b0032e4d194583mr21849565jab.312.1653666607800;
        Fri, 27 May 2022 08:50:07 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k22-20020a6b3c16000000b0065a989b183asm1251723iob.41.2022.05.27.08.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 08:50:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     colyli@suse.de
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
In-Reply-To: <20220527152818.27545-1-colyli@suse.de>
References: <20220527152818.27545-1-colyli@suse.de>
Subject: Re: (subset) [PATCH 0/3] bcache fixes for Linux v5.19 (2nd wave)
Message-Id: <165366660711.122737.5293591142225711731.b4-ty@kernel.dk>
Date:   Fri, 27 May 2022 09:50:07 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 27 May 2022 23:28:15 +0800, Coly Li wrote:
> Here are the 2nd wave bcache fixes for Linux v5.19, they just survives
> from my I/O pressure testing and look fine.
> 
> The patch from Jia-Ju Bai is in my testing queue for a while, it handles
> a memory allocation failure in the I/O path on a backing device when it
> is not attached to cache device.
> 
> [...]

Applied, thanks!

[1/3] bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()
      commit: 7d6b902ea0e02b2a25c480edf471cbaa4ebe6b3c
[3/3] md: bcache: check the return value of kzalloc() in detached_dev_do_request()
      commit: 40f567bbb3b0639d2ec7d1c6ad4b1b018f80cf19

Best regards,
-- 
Jens Axboe


