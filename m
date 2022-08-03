Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE72589445
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Aug 2022 00:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiHCWHe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 3 Aug 2022 18:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiHCWHe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Aug 2022 18:07:34 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D911D31C
        for <linux-bcache@vger.kernel.org>; Wed,  3 Aug 2022 15:07:33 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-328303afa6eso33367787b3.10
        for <linux-bcache@vger.kernel.org>; Wed, 03 Aug 2022 15:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=BP7N97YjVM4PMUACuppi4PcUKAj1aoOhRa9DbafFqaA=;
        b=UxdWjKwJulLaKzOyJFxxXJ0ERw2JH43+th+KrH6QPCPPCim9ZHU+aG/UKmgcS/B+di
         HnwnMoxst6VzZvJKK/YKcdc142bxCDpAJDBzQl1076jd+ZKxGLtQZlcTZpxfAnkfbvm/
         jNchaUBa/DdnXNbRE4bw87d3aKCofo2dRq1sfS+FFMgppF+ttSzDHRu9DYxaVyDgCOnv
         CVM53hD0ISt6nxdGWElfsDlT1zu64LVW7GqUAam/awrBe6A7QOzB4d75EjxTYpVRyOR1
         lwn/vuCYW06T0uFv3V8R6wb613HcQGgd6gy6StVI6opDPj9bMNGQEG9GVI9in3juAuWc
         cfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=BP7N97YjVM4PMUACuppi4PcUKAj1aoOhRa9DbafFqaA=;
        b=F+bSpAZTDPsH7OCqoXLMgxcO2V5xh1lZrDrszf4+rwqJ9DTL1cPXeJwbEsXPaAbT0D
         bgz4vhwxUCP7lOciZKXsSztUJoWZKFr31PrqYIQ3n812A8ZGFXvin2KZGm/gz/4KTZwY
         nLaakS9Z2i+Mn/WPPyLUlnTgXqZNsQOqKBGDV5pQUMOYEydvON9RyVroT4i+W4X6P8O2
         xTHGmMxQBGnzrwN4thQyV+lRiFQ+UUlv7kzRgYyg9JNVdevxjniD6QguGfMeSzRxI/22
         Qovj326LEpXOJxzAOtcvM+5gG5S7XG1QJ4qR0vSXc0PaQxlMa5/e1Ec6g08o37Z7sn7p
         w7Qw==
X-Gm-Message-State: ACgBeo0lRMfErtJ7LDxZXmiFbVsqrKfHpT/pT2aG0a2DutG5gKFu6h3X
        0KJXQzPYrGFsmBvAryrkmwa2SWXN46kyMRMuGIU=
X-Google-Smtp-Source: AA6agR6o0togAN/7iRHWFnpX+8vIx/oPzrt4Aq8F9AqJd0d30VQLTz1GZ/4hl3q8RnoUWb9glMST4hGa1wu/A3QHG/s=
X-Received: by 2002:a0d:ee01:0:b0:324:d943:19dc with SMTP id
 x1-20020a0dee01000000b00324d94319dcmr16449626ywe.325.1659564452621; Wed, 03
 Aug 2022 15:07:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:8189:b0:18c:d810:1c2b with HTTP; Wed, 3 Aug 2022
 15:07:32 -0700 (PDT)
Reply-To: keenjr73@gmail.com
From:   "Keen J. Richardson" <angelamarina137@gmail.com>
Date:   Wed, 3 Aug 2022 22:07:32 +0000
Message-ID: <CAB4TZUmtm_WPwsh7hOocWTyQntr6_XegGYtvMooj-RO4N_BSvQ@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1131 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5496]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [angelamarina137[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [keenjr73[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [angelamarina137[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

-- 
A mail was sent to you sometime last week with the expectation of
having a return mail from you but to my surprise you never bothered to replied.
Kindly reply for further explanations.

Respectfully yours,
Keen J. Richardson.
