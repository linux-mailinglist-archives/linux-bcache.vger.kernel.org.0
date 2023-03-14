Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A157C6B9641
	for <lists+linux-bcache@lfdr.de>; Tue, 14 Mar 2023 14:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjCNNbY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 Mar 2023 09:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjCNNa5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Mar 2023 09:30:57 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE07AA27A
        for <linux-bcache@vger.kernel.org>; Tue, 14 Mar 2023 06:27:52 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id d8so8897915pgm.3
        for <linux-bcache@vger.kernel.org>; Tue, 14 Mar 2023 06:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678800471;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LQagVqAUznkgNLH3Mx9aCkXs8SocQNTlDDbh8SueSIY=;
        b=fjh2x7IibYR5IVDN344fE63lTnimeglBPHRADzy02LOsQhmK3toAowIiHgPa0DHrmC
         dmEoCSmigsM62L4Enro0UwGYEnfMryUi4rhj7/px6rU7hQBvo53v/WEmrP7/18RBQz9Z
         T26N8uw3T6U68+cfGo16lXy3iZJ/HW7/Yxlu6A5TfEeuHlIOHGdBkhae1RD5k0VqI6Uu
         UbmBYqi0IH8ru2ta8yA6Fp8QnlTMzF61fAN0E0gns+V4+2ft9yGKSeCW8pm+HQojai0p
         0QsneX/wpFMIuzn8GxhLQaj6RQ8X/WzW4gS7Q4bCWgWZYUvCayBd+n4VSreIZ11Ucgi4
         M5wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678800471;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LQagVqAUznkgNLH3Mx9aCkXs8SocQNTlDDbh8SueSIY=;
        b=zyX9r5DAqL3BHkeDQKhf/AqqVHkzYUvJdwOvfVlkSe+v9nyroRxsFYWABM5DAO32RR
         2ONk7PfH68cnmeBfaxRO4cNiNPN6zfckkHVU78xQkSKcpUrh5Id89qPeDG0VUtibCiBX
         20GxOFUXmXXxtPJcqjNl29LMmGTEW+7Re0E5ymOq+MzlM1aqjdR8XynwwME7RA4F+Jnv
         PDC/r8YC6ROFeieWz9Jd0LT33vmO541SmDBogHge8ORu/FWjRwLkOiPNPBrbjw+nYK2R
         ZQOoE08hkfQYQjadFrfIAG8wQM45o64tWOgi7VDGsNo91sfr4TDs34ejNGiclPYNYJCT
         /n1Q==
X-Gm-Message-State: AO0yUKWBp7k8Ai2mrwuLRE3SQPMaMz5XqMy5AZDIUS05CrVk5zY3dkGu
        pOJ/MkKXSRbp74fqnH+b/xJOxGCZVPg4B0xvhR6Z3yKFh3o=
X-Google-Smtp-Source: AK7set+85O50pxlLflh2vgISYnqLpNG2GSAbv761Sz5euuySDaU95ALGIiKQ6XDg/HBvCPItyNNJ80KwkVCdPZ2ePVg=
X-Received: by 2002:a63:8c5a:0:b0:507:68f8:4369 with SMTP id
 q26-20020a638c5a000000b0050768f84369mr8318304pgn.12.1678800471088; Tue, 14
 Mar 2023 06:27:51 -0700 (PDT)
MIME-Version: 1.0
From:   gius db <giusdbg@gmail.com>
Date:   Tue, 14 Mar 2023 14:28:16 +0100
Message-ID: <CAO6aweOvLUP0L+DXwJEpbFJ_mF0E44pWcLzXoXvAi4MGPBkFBg@mail.gmail.com>
Subject: Throttling performance due to backing device latency
To:     linux-bcache@vger.kernel.org
Cc:     benard_bsc@outlook.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi.

bcache does not have a good throttling strategy for dirty cache writeback.
(I personally think the available ones are wrong.)

I was forced to start writing a bash script to adjust writeback speed, so that:
- When the discs have medium/low usage, the speed is reduced to a minimum.
- When they have very low or zero usage, the speed is greatly increased.

In this way I get the two fundamental things:
- having the maximum dirty cache used  (when needed).
- having zero dirty cache when possible (to avoid data loss, to have
more dirty cache available).
