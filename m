Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE69645F29
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Dec 2022 17:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiLGQnu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Dec 2022 11:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiLGQnt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Dec 2022 11:43:49 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15D25D6A3
        for <linux-bcache@vger.kernel.org>; Wed,  7 Dec 2022 08:43:47 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id s16so8079264iln.4
        for <linux-bcache@vger.kernel.org>; Wed, 07 Dec 2022 08:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJ8Ay+PB284aY3NVmhw3n5NaBjbrOxQtEAJy+RGXMRM=;
        b=Ny7BzO6Z3MS2ZJ0cRncx8Fzd5LXVeD1NHgtDeyn6MJ6xVu5o3y5OWYJZCvUtEgjKRk
         UNUPyxK+q6Ys/IktM1+7HYWPvLZRwL1iJmxg5fEtG7dBfn8iQ0DETRblKzR4UnQC+HtJ
         k1VqyES/CL5JZBKrXcVioYud0xilCvP+oC8W5LQkl0ZmVqdFxLYxqIzDNxweoqMHg6FN
         ljqwW+AfkWgOjuNLzw4HiWU6wW5KlGdJjq4azTIVo0fK02r4j5WyJaFN/7wYQhkwyBjs
         lLuD782mA4hJl4Gw17g9BhZiCbWyGJKUIkg0swDfu8lfl7B88IJiGrKlSmUDGnmKJ+sH
         5kug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJ8Ay+PB284aY3NVmhw3n5NaBjbrOxQtEAJy+RGXMRM=;
        b=ZYCh89Ha294X4EUS0Lj7FE4EtNI5BQ4gheeCk+RtBrFthBzs0ArWp/UwB4AX6kXKes
         iv7qOHo9PK6w2Q2mrUzKKZDUz351hQLzH+zCndXa3bG6FsDYrUTWMZ/Qsu1RO6lCs59o
         a0sEbLvTGv8nxUQpW3M+VHQsdvnqXlqCnE+DJh1As6JqGLVHecpmdyXQ6W7CHpkTQmgR
         UJo8BdoeW7PCeoKmXdJJOPJA8MbkpR+8JNYVMUwj132aL7gOc4XQZit5n//qaH98Vodc
         rkYwjBJedLficAihBYEkeprVYsqW6JGyOSylk5Qb8zIkMOKAYTpKwm691+RP6wcjYLwD
         HAxw==
X-Gm-Message-State: ANoB5plFfPQNPXJfkBgL/Ewg4zKNTLwA57pOGYOdoYd7aD/r3q7h/IWc
        WuMeUL9ceR4XWzTwb5Uw7JjKpw==
X-Google-Smtp-Source: AA0mqf7tWpWZtUh0xPnGJO9AZcQHA021bUAhGGmdDCkM2tthnOVB7XOHehMq1xO+VcDumIv8Vf9cvw==
X-Received: by 2002:a92:cc84:0:b0:302:489c:669 with SMTP id x4-20020a92cc84000000b00302489c0669mr34208447ilo.135.1670431427024;
        Wed, 07 Dec 2022 08:43:47 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e12-20020a0566380ccc00b003728cd8bc7csm7802731jak.38.2022.12.07.08.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 08:43:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     snitzer@kernel.org, Christoph Hellwig <hch@lst.de>
Cc:     colyli@suse.de, song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com
In-Reply-To: <20221206144057.720846-1-hch@lst.de>
References: <20221206144057.720846-1-hch@lst.de>
Subject: Re: [PATCH] block: remove bio_set_op_attrs
Message-Id: <167043142630.172966.3660102879335248846.b4-ty@kernel.dk>
Date:   Wed, 07 Dec 2022 09:43:46 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-50ba3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Tue, 06 Dec 2022 15:40:57 +0100, Christoph Hellwig wrote:
> This macro is obsolete, so replace the last few uses with open coded
> bi_opf assignments.
> 
> 

Applied, thanks!

[1/1] block: remove bio_set_op_attrs
      commit: c34b7ac65087554627f4840f4ecd6f2107a68fd1

Best regards,
-- 
Jens Axboe


