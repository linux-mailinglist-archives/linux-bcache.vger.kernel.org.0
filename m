Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE41B689257
	for <lists+linux-bcache@lfdr.de>; Fri,  3 Feb 2023 09:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBCIbX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 3 Feb 2023 03:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjBCIbW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 3 Feb 2023 03:31:22 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4773348597
        for <linux-bcache@vger.kernel.org>; Fri,  3 Feb 2023 00:31:21 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id v3so3150556pgh.4
        for <linux-bcache@vger.kernel.org>; Fri, 03 Feb 2023 00:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zu2y/4MWJnFonrJxDyZ6rAlSIWBncWmXyCnHWDIviA8=;
        b=WTtn/RNLG5A2REqjOO3Zjeybff8ScqTwxFE9byTs1urSsVCXozMHM/XiPW5rNsc4UU
         ut4aMi71deb11CiPSbbDpWHQHTueyn394CWNntMvz2/VGnZ8/wq8/iWUTJbTjGxdel/M
         3W5fXFQttEbEk3ehNBXmQPvd3DXJ7aURgWV8cohA8psiYzk1qElmeNiHBfT07UXg9zLq
         Cm1RfP5qxoKpEHAz6DDk3SKKnyybDMEphrfSx1T6qZtr5KF/g/2gp+I1rzo6/Y80LJu2
         z/prs2oVT5d46YheKqahPkuHtxka+T8vQhmYqqLEodOPbNZUOdayKzuRMNBCUI9sSbOk
         T2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zu2y/4MWJnFonrJxDyZ6rAlSIWBncWmXyCnHWDIviA8=;
        b=41vFR+WfIQgUUv6fiOX1Oxgv5BfFZb6OYrKzIsVvz7KJZ4hRe8MVOB56GqZJ3CLGoO
         StA67iSA6JRNh7mJjAqtHMqoliacKRJXKmnh2uNWez1aRkFW4wFHTNxI4zN3fVVang5v
         GWHn3aVBmRsTSu2rU7r6rzgdBf4+P8I/cWM+Il8RCZk+jujdsduv1WwSzy875t4f6cA2
         8oMpOT1vYmIf6zjwecgqjlvisSbBcPR/LOOjZsefhCtCUkq9XpugW74NEOYU4HvKiYM8
         nRb4jbrx7FRnYDvHsk9Qm7gL0WFp2xtBB0WJiY9kXvMozPBitXyH3kYN0+xtuYb392an
         EQkg==
X-Gm-Message-State: AO0yUKWDI+RbRKtnAELppT6Hfd2BnG0ezIPy/OavzktSuAgl6EnTPnxm
        qXf7xymncPr5wqI3+o97+3KoL52YrNZUsty1gE8=
X-Google-Smtp-Source: AK7set+7AFx3F2LUR15lCVVepw4RU5GcvbUMXJ7Cea5noVJlwqwI2PnWXr2UnW/2jHD36dT5kCDeyB+1fZ8ojSGmcxI=
X-Received: by 2002:a63:cc0f:0:b0:4cf:122f:2102 with SMTP id
 x15-20020a63cc0f000000b004cf122f2102mr1516079pgf.98.1675413079979; Fri, 03
 Feb 2023 00:31:19 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:3dcb:b0:3f8:bec7:db13 with HTTP; Fri, 3 Feb 2023
 00:31:19 -0800 (PST)
Reply-To: kolowskimrk9@gmail.com
From:   "M. Kozlowski" <lphbtprzcenter@gmail.com>
Date:   Fri, 3 Feb 2023 09:31:19 +0100
Message-ID: <CABMFT_m1E=HrCXcZTiPR=hGxptXn870DR4AU96KezsBzeF0FAg@mail.gmail.com>
Subject: Waiting for your reply
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:533 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 HK_RANDOM_ENVFROM Envelope sender username looks random
        *  1.0 HK_RANDOM_FROM From username looks random
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [kolowskimrk9[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lphbtprzcenter[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

-- 
Good Day,

I am Marek Kozlowski, an International Relationships Manager with an
International Bank in Europe. I handle portfolios of high net-worth
individuals (Foreign Investors) and have over 200 of these high
net-worth investors attached to my portfolio whose Capital Investment
Funds are being managed and administered by me. I have an important
information/proposal for you but for security reasons, I have decided
not to include more information in this letter, but as soon as you
respond, I will be able to provide you with more confidential
information.
Best Regards,
Marek Kozlowski
International Relationships Manager
