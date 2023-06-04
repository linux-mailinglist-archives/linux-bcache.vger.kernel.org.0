Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D945721AEB
	for <lists+linux-bcache@lfdr.de>; Mon,  5 Jun 2023 00:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjFDWxv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 4 Jun 2023 18:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjFDWxu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 4 Jun 2023 18:53:50 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E74ACD
        for <linux-bcache@vger.kernel.org>; Sun,  4 Jun 2023 15:53:49 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-94f9cd65b1aso88203866b.0
        for <linux-bcache@vger.kernel.org>; Sun, 04 Jun 2023 15:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685919227; x=1688511227;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kPjzVkyTIEwz75tgjsD5N/QfaXh4Uk0nJyIRBYcXkQA=;
        b=FtBd2LDk+XwV2MebBNhoRhjxJdLc7+lAjI0+0g9PxaP0McQ6IrEAeAY2QVTrtakKU/
         tQ2ifN+7Wy3U/rGvQJ4uYjYcnxcHLRIBIxT32KF5m+mraACr9rK6LxjOBsexZZ1Vpvu8
         PTCgZA3cupoIoyKqfmGBJt3s/dQVJlJtfXgKWjoMgGoqBRSgCtoSFEkqMgKyy/g40PId
         oufKFyxN/2xnmUgsbyjSLTG6+yag3mgihB3V2c6jVCxMD5uWsjQtNwIKvARq4++Wrj8f
         8HVZE1rvBvCw+sOlmvCYOOlODU7sbv/jX+dyDySsJAvqWeFDn5X4N8YvSogv/hySd0nD
         ZQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685919227; x=1688511227;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kPjzVkyTIEwz75tgjsD5N/QfaXh4Uk0nJyIRBYcXkQA=;
        b=goiXwfMLKdd4aBC+NS7sC3bmGqgHd/y8vV7slrYlYy+HLlMLPVQ88zBQaAhstEUGSC
         yaJnhOV8LUTSqmLoOt2EEEwBfYK1Ps8PFn0x68lrHZPGYKv73gtkcg5XPTq1744JOyMU
         n5f3lzwH5+EI4vsVqDPQd7AMFLYfiuehvpeuknoBZmgzpSMS0ieJho6rVLo4kli36Hr0
         dYvJQfeepz+g2jnAI3AF/AQoNG4eF8BX8QNyKpPWJhjIcj1Axifdll4o1bAWXxk6/V6G
         dlJvCPVR7BZ3O+Ir7YW1JaQlpBSnPa7VgpO5lEKdESFL+G2E7CLBxg/4K2zz0qJ7Gulu
         8HEQ==
X-Gm-Message-State: AC+VfDwxhGuxlAkybjrliwDgNVdk3SCN/rV3IkSRMPMUnJHT7rIv+JdH
        pJmabG4iMNphmrLafXLr91H7hzYJdREY0HplWVytd0lhsY0=
X-Google-Smtp-Source: ACHHUZ4DddjYjchK/1TeUD8t5OD5FVH3tonon/3oRsVt1j9cY1F44EzZJZqwFHleG6Yw/3jg6sdiMrtqNX7GRTyp9DQ=
X-Received: by 2002:a17:906:2cf:b0:976:7c67:4bf8 with SMTP id
 15-20020a17090602cf00b009767c674bf8mr5054551ejk.5.1685919227231; Sun, 04 Jun
 2023 15:53:47 -0700 (PDT)
MIME-Version: 1.0
From:   Alcatraz NG <ovearj@gmail.com>
Date:   Mon, 5 Jun 2023 06:53:36 +0800
Message-ID: <CAFvjXT7N8aVKP-nUHJQ407jE7Bf5Kn1wNkTSiPZ2EdAMHd01YQ@mail.gmail.com>
Subject: Bcache accelerated LVM LV device doesn't come up after reboot
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

I am using bcache to accelerate my LVM LVs (lvmcache is not ideal
approach for some reason). But every time I reboot, all bcache devices
just disappear, and doesn't come up until `partprobe` being executed
manually.

Is there any method to let bcache bring those devices up automatically
when the system is up? The `partprobe` workaround isn't ideal as most
applications will fail due to the non-existent device. I have tried to
adjust some module load configurations, but it did not work.

Many thanks
