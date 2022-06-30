Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93E6561F87
	for <lists+linux-bcache@lfdr.de>; Thu, 30 Jun 2022 17:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbiF3Pni (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 30 Jun 2022 11:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiF3Pni (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 30 Jun 2022 11:43:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D312A711
        for <linux-bcache@vger.kernel.org>; Thu, 30 Jun 2022 08:43:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id go6so19195482pjb.0
        for <linux-bcache@vger.kernel.org>; Thu, 30 Jun 2022 08:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=edeevZ54MxyNr2ONaDsC9jI+UtdZjrCL/LCuSFC70Ao=;
        b=FhikdCglADdIKgARstJimj3GHIVs4n/3vfv7KvI3xq5/Al6ZDEmECl8IcL+CJOE9Ld
         GN/b0+bq/n999dE/dbrrkWUfJVgKzny5d/yEYXFgqol3NNOjV4E/wIbq2gprCLhz2McX
         GbfzWhnniM83eiwMfcxEsRodx9drS3l3RTfuxHJaXea9DO4MnVSMFzgvDfty7Qx4QmxA
         8hwBOR0k3GJEvr84E1L7l07c60LIUDjVRzqIsiL2aO+AaJqE4yqzNOBs7iEYbZPYwFns
         opCi6z2s1pmqSp82BHXTAM23Qvv3lSRI9mCqC8S/BcBge5Tf2KlRtrzD18M/XEs8TYMC
         kz9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=edeevZ54MxyNr2ONaDsC9jI+UtdZjrCL/LCuSFC70Ao=;
        b=JpsfLG2weGy368qZ5FLsBSF0DP9LL6m5y2GMwyKCwPqYcGTNGg+78SO+zP2yh/IfEJ
         BdOhsoHgCqMq/MH1s6hIymr4oA5SoS2gpdpG3xKErvFGSRUJhivhv66Q4XH2dknblY1K
         b8EMr2ieR5YgLvV7+2jxn29Q/lKCl+kdiEKnaHWqpP/nGHN+NYjHm92+g1xk08Is6o8K
         3Oldugki04MisMWhJPbrQJSeZmbckXjy7UwgQ4RMoqX9Bs2NuT3NmO82+bUCneBZDbz7
         fqggMNubiu64ll9oljJt71v5ZU+KkAZLmKYrXN+KtQN+77Te6dDBITUXbz0sjMZGtUqx
         byWQ==
X-Gm-Message-State: AJIora/sounOOvIt3uE16bc7KGjNHnRAA2MLVZV58HLOlWQVHkmIO+MQ
        trurDY1GOtwG+OZroU5NqaiKUvzvwkDj7iKtwg==
X-Google-Smtp-Source: AGRyM1sAHD6NIRn2KK/Mh0Gtvq7mzYJbZc7fnOSrhwfLFOrAtmePKPAa1nsAMYErskvGAAp7CDw2X2r9SbD79Odog2w=
X-Received: by 2002:a17:902:b118:b0:16b:7b17:41df with SMTP id
 q24-20020a170902b11800b0016b7b1741dfmr15820257plr.171.1656603817148; Thu, 30
 Jun 2022 08:43:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:903:185:b0:16a:29ab:582f with HTTP; Thu, 30 Jun 2022
 08:43:36 -0700 (PDT)
Reply-To: mohammedsaeeda619@gmail.com
From:   Mohammed Saeed <mitash.m.patel2012@gmail.com>
Date:   Thu, 30 Jun 2022 08:43:36 -0700
Message-ID: <CANRWfSPJTZW_YZCR4QjryCyKh6VnBCwOO28cUimbUcCmmtTDQw@mail.gmail.com>
Subject: Proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Salam alaikum,

I am the investment officer of UAE based investment company who are
ready to fund projects outside UAE, in the form of debt finance. We
grant loan to both Corporate and private entities at a low interest
rate of 2% ROI per annum. The terms are very flexible and
interesting.Kindly revert back if you have projects that needs funding
for further discussion and negotiation.

Thanks

investment officer
