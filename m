Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA31453726B
	for <lists+linux-bcache@lfdr.de>; Sun, 29 May 2022 22:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiE2UIo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 29 May 2022 16:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiE2UIo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 29 May 2022 16:08:44 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0213190A
        for <linux-bcache@vger.kernel.org>; Sun, 29 May 2022 13:08:42 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id g18so2695074ljd.0
        for <linux-bcache@vger.kernel.org>; Sun, 29 May 2022 13:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=kc2C3cb7sRgAcZ3aq50IRPQ3t+PRREAP8MnCczc2TBbVbZivQNVBKC8FJeyE9OjUox
         5Ep4JgmrkCvlwBGgCII3gSwwzlrdnYLqNjRNxEXTHtHoLXjubG8e7GMYgIqmqwRvBFZT
         KmsWcNHs6WhUtJdzKfjlyRXCRZ3DXjvxllUaVAhkDy7SahxIYKIDU+y4tqkTOnU4GIHe
         MWSoNChKGVQB8K20XuAUs8YsCCVKSDmRvdI1TBL3g+vnYy2HngD8+02r1PSaLdGb7bBF
         X12rbh0A1YxhLtkZCD1QQ6QZ85SAn2frTq/2L5xs/RhllL3Y0mrZd7R1ez7A/VbYef2C
         /1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=4CQlPK82jiLabPswMULV7FH/6A2TeOAI4thQ+2XzUZadZko9PkQvrY23erzplMvf9Q
         FZZ08BbLm16S9NsaSAI7mVQnCWpYmAxy4Sek5B7mAMEcpsTZtIPqRFp96tEILOeEVU9W
         A/VtkU0yI+tZEU3oqYkAplerO+Or0D8uc0HIJjZeCrIBieNJ5kfx0EwEf0kxLlXA4hkF
         9bn49yVcs3CZw9yORBdNTS1YxktFfyCu2X73j1+ZturMAatrULSbGt96eXO6W4bv2EK4
         8A2HPRfENujaheNBRMmzZ53GHaS9H6UIDmGveNSSViPZFYWPNtTjN4NUiz3jG3zrW/km
         82DA==
X-Gm-Message-State: AOAM530t/BUE0YbpFqOdon4HLG7sRZC7Vl6ZyB5/mQoJClRQ6Xg6Fklv
        AmKduuVyH9TYCDG79YO5oCyf28r/UBlFVJmlFfY=
X-Google-Smtp-Source: ABdhPJwyvs+mdLH/K2uYY0RMTBZ+657Pi9XAfiBdSckzFUZur9qwMEcG25ig5EOOgs4hO9SgurewitrYFcIgWIp4k1o=
X-Received: by 2002:a2e:800a:0:b0:255:50fa:8a38 with SMTP id
 j10-20020a2e800a000000b0025550fa8a38mr178460ljg.340.1653854920984; Sun, 29
 May 2022 13:08:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:b742:0:0:0:0:0 with HTTP; Sun, 29 May 2022 13:08:40
 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <tracydr873@gmail.com>
Date:   Sun, 29 May 2022 13:08:40 -0700
Message-ID: <CAARq6Vbr96gQg6Q8qqoyQ5oxXU_RpnNLc34TeStZNviggpf40Q@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [tracydr873[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [tracydr873[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
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
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
