Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A6E587A53
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Aug 2022 12:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiHBKIQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Aug 2022 06:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236477AbiHBKIP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Aug 2022 06:08:15 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C392FFFF
        for <linux-bcache@vger.kernel.org>; Tue,  2 Aug 2022 03:08:14 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id s129so5603221vsb.11
        for <linux-bcache@vger.kernel.org>; Tue, 02 Aug 2022 03:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=edeevZ54MxyNr2ONaDsC9jI+UtdZjrCL/LCuSFC70Ao=;
        b=BvdjqWEZK3gAP+txc7LcmoCs7F4p97SgEnsgayrpevljjmT4Xvk6dab129SHUznPuo
         aGR3oGrqNIJWsLYfYPJbsOF2MxQVjp8lgdYkPzpTjvqyzsrmxx6xvcrTGLKkarxd7o7p
         2PwV7HdiUdSZgU0GY7oCT11etzsB32wOZ7KQ3M9+ppotRidMK4WffkxlM6k2En9+oQXt
         yHX4yf2116EtSPlwK+dgu5NEtIZJbQOz1Xb99iQEfHjdIX6wLYTZ2a5mMSRwLaA92j+l
         4UcpQmZV0K+WzxajLtQg5MNXUhbzRp7M/tQMcmH1Z2YY3nsZnjPBOGvI7Fce4fQuS69f
         zfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=edeevZ54MxyNr2ONaDsC9jI+UtdZjrCL/LCuSFC70Ao=;
        b=h3tUTMiH396o6WFE7p9KtLGvMldWSOD7u/maok13VlOecc/IFL0vjTWUglxV+x6eGE
         S1P66DREaPa3LAz3bg85jzDL2plh3jEoR4bskXOxZnK9Yx4oX7CI0g0JYbHlTMugLznw
         mMZAV1W5BnOijpDW9rllap5divpL+rfd3mo4+9tHYZIll2vTfjEy+6bnnO03o+/9XfR3
         aZEgaSrp1c41IQ+yoQAVnXZE7S8cqC6e8Vjf9fkewFhsJEkW8iBcOyF0JGR7TDr0Fq9x
         YOFDgW2fa6XE85rtK7kyTX/azaeIQ1Z2/RwUrM8a0jxGn5UtX3AK+e5H61kV84TofwVl
         dhlg==
X-Gm-Message-State: ACgBeo3xvbugwkSrlpjx887c7p3XABhufrgd0gtAJHg57NmI1/QmBlh4
        YaDgQXH2jjST/EOfHWZrPc8Cc45Hc63cgKohLLE=
X-Google-Smtp-Source: AA6agR7glMxiYqpGUrkYu+Jla4cvWKB3zqOJm9sC80CReM1xrawZ0ksdwfSMPtqTqHFiYRr6Fj+0wmKZsIexDUEQ89I=
X-Received: by 2002:a67:be04:0:b0:37d:db55:6723 with SMTP id
 x4-20020a67be04000000b0037ddb556723mr3930020vsq.49.1659434893658; Tue, 02 Aug
 2022 03:08:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:beda:0:b0:2cd:f4a8:c08d with HTTP; Tue, 2 Aug 2022
 03:08:13 -0700 (PDT)
Reply-To: mohammedsaeedms934@gmail.com
From:   Mohammed Saeed <bienevidaherminiia@gmail.com>
Date:   Tue, 2 Aug 2022 03:08:13 -0700
Message-ID: <CAHyTKtj1uoTgnrYbEW4zdsfQ8GyHL+tCb80x0Z-UgzWZTckEGg@mail.gmail.com>
Subject: Proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
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
