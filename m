Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2393F6A9BDB
	for <lists+linux-bcache@lfdr.de>; Fri,  3 Mar 2023 17:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjCCQi2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 3 Mar 2023 11:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjCCQi1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 3 Mar 2023 11:38:27 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3417166F4
        for <linux-bcache@vger.kernel.org>; Fri,  3 Mar 2023 08:38:23 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id y14so2951366ljq.4
        for <linux-bcache@vger.kernel.org>; Fri, 03 Mar 2023 08:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677861502;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8n+B7BYhQiGOp7c1Owg7QU/XYDAQwZbI9wzpBHuEFA=;
        b=Qs+TKCTIOlMKj8NYU7XrVODkYswsb5sTh4zEi6b8t46BwpOvWWtdeSQkyo2+Vw08Bu
         73B3gZrNd6S6ALgcHGYFpqd316I4JWlWKByA+p7wc9eDSYhewAiu1dn5y1Bx+3Abyb6X
         ho6g7Oflc+iTYjvyhA1c5KntoSNo4NNYLlsjd1hqRGMSEOdaefHvncgZ/gWMgO38q1KV
         fAositv6a6rIXUBTBFtcSGEjpemmTqxqwPt0VQB+R83PeX2bJBrmLOxHonxoqIm3sfZI
         Rf8bkvlpYhmLlwum+0sBzn4e/pkM88uOI9XYLWftoN5BfDIC0SjxlZrSKKOb+cEprWyq
         eHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677861502;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h8n+B7BYhQiGOp7c1Owg7QU/XYDAQwZbI9wzpBHuEFA=;
        b=kYeAkV+O/GYOPrHaQT6tjeBUGbh2LlLJi4YlyTGE6iV5dJWnwApRQBrCnNBng1tSF2
         5e4TypZu3pw8P2oY0YenoigTVjeuzxaCm2bDwkU2/PTmqs5fgEVbeVMfieF3MYxHW4io
         knlGM8tm39+Nqfu6m4xzgk7EWQq+5/v6A091khfLy+Q38iq3cyCqgobfnpM8CNP/Kpyo
         /DTicKq2H6t/U1NC31hdjfrrR2k8PV4M6+djg808NOWv7YR2NBXzedexwh9wrGxnVl5D
         U5TgXTm+zkK0LlRocZxQFOYTK33yeYFxspDStuZ63HkLrLBfewEHIisZsNMopVp65Bb+
         yS5g==
X-Gm-Message-State: AO0yUKXc3jTjYKeh7F+hnzxQx05kgDmML2HI4Yai0mzFRm5cysI5ialj
        qeuKJllqOpzQM1c36SqmkNB+/UomZXYRmT+7VYI=
X-Google-Smtp-Source: AK7set/3qlgd3vLe5YAHsRZ/bDHwVApCHOpP8aT/eipU8j7hsJE2t15Z6nmjRra5PB3Z/FqFdkAjruVgdqCGqw/l/pQ=
X-Received: by 2002:a05:651c:336:b0:293:2f6e:91bf with SMTP id
 b22-20020a05651c033600b002932f6e91bfmr758301ljp.7.1677861501854; Fri, 03 Mar
 2023 08:38:21 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab2:1c6:0:b0:19a:6077:878e with HTTP; Fri, 3 Mar 2023
 08:38:20 -0800 (PST)
Reply-To: samuelkelliner@gmail.com
From:   Samuel <samstarmaxglobal@gmail.com>
Date:   Fri, 3 Mar 2023 17:38:20 +0100
Message-ID: <CAMT6da9KANweCx6GFt=HOT=a=12ai-wwq-bmJ9edSW_feo0V3w@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:241 listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [samstarmaxglobal[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello, i am aware that the Internet has become very unsafe, but
considering the situation I have no option than to seek for foreign
partnership through this medium.I will not disclose my Identity until
I am fully convinced you are the right person for this business deal.
I have access to very vital information that can be used to move a
huge amount of money to a secured account outside United Kingdom. Full
details/modalities will be disclosed on your expression of Interest to
partner with me. I am open for negotiation importantly the funds to be
transferred have nothing to do with drugs, terrorism or Money
laundering. Thanks for your anticipated corporation.
Regards,
