Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0F95899F4
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Aug 2022 11:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiHDJeo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 Aug 2022 05:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiHDJen (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 Aug 2022 05:34:43 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4587B3DF39
        for <linux-bcache@vger.kernel.org>; Thu,  4 Aug 2022 02:34:42 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id j8so10586168ejx.9
        for <linux-bcache@vger.kernel.org>; Thu, 04 Aug 2022 02:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=SrICNljyj+6EXk05+As4iI9xNsWvqnooXHxi71ozYp8=;
        b=YW8LuDZtomDZOqmE+44RmUZEwic4lHO0nCWukhHaK1F/3ObsGls+OUjWoGEfPUNFt4
         b5W9aFjc5xSuU7kU5arw2KbBF0TTSoXcbAAttFN7B/EyORkqMlRFdLtwidM49lk/WP3f
         0sZh3e8AMRQTi5W2Yr+1o9v/76PWag13rZKf0wUlLScE3MuQfzUUZn9pizJ22HiQ7v50
         DRLDN9hqOiPyhf4gR2FdvtHih3ZojrifKl64+paJSsSG4HoOJ0f2HmSyKLRsqh9A2UGo
         BtkDsYC3DoaOF8rlIQQPB96hQIzJCdkEBcV88BdV+nQPtbyDG8kwFD2AY7iynQC2myHy
         gwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=SrICNljyj+6EXk05+As4iI9xNsWvqnooXHxi71ozYp8=;
        b=nO1aqiM2cjXReNj4jUIdHPDB3cOoZlZKpXKCF45tndvvnMLvBc4VBDBpsTlsi2Uk2r
         9b453U92jHAbvYBtFmxArhV8lOBOUU3KR2DTTuT2K/UQG/EHTAwO0+Nx1d0/78/BLmBw
         03odAtJtwX6NUDbA6KhBY/JWCAmeekrbTgk81z7dAkjbqsUDK/ls5Qd/ZebeL2WefKkO
         rKPvpKPJZcYhspKxepxOy+yq+Jkmn6qTRlu72XwGo+5RRKfnW8jQkmP/5nwSaxjB50Ll
         lTjpZ8T8TL9ghHVdLL/XnebLgpwpr/WNzUhwS13HLsUyQtPNi9538mz3LigQ5pviTL6+
         ejfQ==
X-Gm-Message-State: ACgBeo3vs1lQbefdPNVAKL5xvHxQ4V+veta1P6WmlBeaXNlwku560K7c
        0sVSvwYA1BcydF6GIObbaxzP1zGLwtkpautoW6g=
X-Google-Smtp-Source: AA6agR4Znwk9W9zT21sIGGDfdCof3AZa7sxzhHopD4Lax3SdE/zPr/MvV3DYsA5GbuCPEksU+y9yVRsEPD/GoKZ5Kqk=
X-Received: by 2002:a17:906:cc14:b0:730:d5e9:a12e with SMTP id
 ml20-20020a170906cc1400b00730d5e9a12emr613229ejb.515.1659605680641; Thu, 04
 Aug 2022 02:34:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6402:1e8c:b0:43e:7fe2:9090 with HTTP; Thu, 4 Aug 2022
 02:34:39 -0700 (PDT)
Reply-To: ndlovuraymonds@yandex.com
From:   Raymond Ndlovu <hamfranck877@gmail.com>
Date:   Thu, 4 Aug 2022 10:34:39 +0100
Message-ID: <CANe2if0+F75QZubZ-0KtRqk9whk6cZF8cRp4AoNXOO6t-qxbsA@mail.gmail.com>
Subject: JOINT INVESTMENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.2 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:630 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7282]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hamfranck877[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [hamfranck877[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Good day,
I am in search of a trustworthy Individual or company to partner with
on a business with good Return On Investment(ROI).
If interested,I look forward to reading your mail.

Regards.

Raymond Ndlovu
Investment Executive and Stockbroker
+447743328087
