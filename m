Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0501705F5C
	for <lists+linux-bcache@lfdr.de>; Wed, 17 May 2023 07:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjEQF3o (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 17 May 2023 01:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbjEQF3n (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 May 2023 01:29:43 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B73240CC
        for <linux-bcache@vger.kernel.org>; Tue, 16 May 2023 22:29:42 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6439b410679so218391b3a.0
        for <linux-bcache@vger.kernel.org>; Tue, 16 May 2023 22:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684301382; x=1686893382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aEByPUbWzEge4Iky1e5iUg2L1hJZ/fHa9xQCoH3WVIg=;
        b=Y357R0X3sX4A14QNgJYWLnQBq43XKMYFAIoxmhvf6Vz/WyojR1F60pCzCkXBvHwnb+
         6Eha3TkslnfcaMGchrLPGC6f5rd6RouAsOB/wn6uJBGloQ97D3oPCRXD0UqW4JxxSEH0
         yKKiiBzt52jDFbkD+l1a6cYXFY/Yi13zZ3NroNHMcrsklv/g8WoADHcbP9E0QClNomxj
         YuxibqQ9ZBoHrQcP8+0MV7NDcf+GIY5mFw7pJXyqOdW9O5uHw9pJyag2X3hdp3GcbPlg
         G9S3os3ND4Svl+2SY6UQ+a5rQRFQxK6rujViyYe/tdzv1v8QkRs9lVIwWa0tt/Jyp71i
         U3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684301382; x=1686893382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aEByPUbWzEge4Iky1e5iUg2L1hJZ/fHa9xQCoH3WVIg=;
        b=CkZYjAGOcz1c2aOZk79v0f0MkD+RHv8hK0nqOnAWmUBGqlDh13MHJ9VHnYqBg6vBcv
         xFH1GCMvTmTiqXDfWkXCgf7/2pDdox4qanPPWeXvfqIoX+X6BTjXk5blKQQVgCc8RVdQ
         5rkLfJX2SjVqb+z1wSFtfSjcaOhWztfWCcTWplen9fV713yTgKv+MJOICAfwRDpyFWZQ
         yEN9Iix7h1fyuFnwx0z7m5HxIJiZlFjtCB2SJN963c41gSeLJICqUfnYJ9Ofkb34Ttbi
         mB+BG9m9XeKNu36Z0+DXehXPlRLO8Y8t+NxlHxPiztNDju8+giCwK3E75a0a++y4RFMP
         HXag==
X-Gm-Message-State: AC+VfDzN+9YQc2/X4VR6R3jwErlUFZuvqJMwoM041u+5E3mI+oNzEMKd
        Lku5jrG5ZzwceqaTdZTk2lU=
X-Google-Smtp-Source: ACHHUZ4HOjr6WQ9MZfkq7oKvnUosOaMmcS0mAiiHHPTCzd2/oW3wQNEmyX6zuxUwrud+09TRf6d0QQ==
X-Received: by 2002:a05:6a00:c82:b0:64a:a1ba:50fd with SMTP id a2-20020a056a000c8200b0064aa1ba50fdmr23242094pfv.22.1684301381795;
        Tue, 16 May 2023 22:29:41 -0700 (PDT)
Received: from maverick.. (59-102-46-11.tpgi.com.au. [59.102.46.11])
        by smtp.gmail.com with ESMTPSA id v12-20020a62a50c000000b006437c0edf9csm10064691pfm.16.2023.05.16.22.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 22:29:41 -0700 (PDT)
From:   Rafael Lopez <raflopez1@gmail.com>
X-Google-Original-From: Rafael Lopez <rafael.lopez@canonical.com>
To:     mingzhe.zou@easystack.cn
Cc:     andrea.tomassetti-opensource@devo.com, bcache@lists.ewheeler.net,
        colyli@suse.de, linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: Re: [PATCH v7 2/3] bcache: allocate stripe memory when partial_stripes_expensive is true
Date:   Wed, 17 May 2023 15:29:27 +1000
Message-Id: <20230517052927.20478-1-rafael.lopez@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307134852.8288-2-mingzhe.zou@easystack.cn>
References: <20230307134852.8288-2-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Mingzhe, thanks for these patches. They resolve a specific bug we have open for a large NVME devices with non-zero optimal io size failing to register: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2016040.
I have tested patches applied to mainline and some ubuntu kernels successfully, but only with regards to resolving the bug mentioned (have not tested online resizing).

Are you planning further work or can this be merged soon?

Rafael
