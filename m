Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99F053440D
	for <lists+linux-bcache@lfdr.de>; Wed, 25 May 2022 21:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241682AbiEYTQQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 25 May 2022 15:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344519AbiEYTPA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 May 2022 15:15:00 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F33FC5E4E
        for <linux-bcache@vger.kernel.org>; Wed, 25 May 2022 12:13:11 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id h4so11317078vsr.13
        for <linux-bcache@vger.kernel.org>; Wed, 25 May 2022 12:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=V3ilouT9genmWgVMdUNI5P/LrIsW5jIirCBfI8vk+4c=;
        b=fhTOpq5a185u/Fvy/z60mm57+fhOJQXNm75VUupwLqqTeblJ/tIb4vW51Cc+H8f4S6
         FCtkPdy8eOGE51vGaes+rTg9D3F0vC+iHLjFW/wqBSHMxMyFdcvo/0L5VIqvy7HSEaN6
         F4+aqn6wSVfCukgoHN6pcM1LA/K8ELktYRC2Fs/aZjgwPzWD2ZDJ8cwwuWoq1iXMEMF2
         7Ncv8k61QaT/5LzJQuzEx8cWUM5pBYtqVdYL7oQz8t2o4CeTe6AO6KBrza9omJHJz+P3
         YD6PFoWrPMWXEdNffXF6WZXtAaEa6yePqcU+mV4+zwsUTvb6SOqX49n9LatUUcUDB6Yf
         Um7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=V3ilouT9genmWgVMdUNI5P/LrIsW5jIirCBfI8vk+4c=;
        b=DkzjcrI95bVmgVXEjIzJMy9PHGx7ALVh4Cn2gCwjZJ0IdLsgwEzhjScXhOAeDPfaSF
         4hqy6BTaljSlu9XbuyoDjRn7PaPjsMKOfacHVc6XEoB65rTIkglS2C8osWd2POvevIu/
         ADMjUcMM7/Jjr4aiGlfYtAupZXfqjD8AxMf+JbFLxpT+rdUwy8yr9Kn6vpcGiret4hPB
         yEbEFt26by/NgZI1Gz7jxnx5x5p7ifH87BEclMMQTmDgu4g/C9dZzRXHjs4mG5mU3ibb
         H02MGVQwmr7uVg2X2WeH6CguwDtYYAbGEItvJSjikoBWliw8z2kR0Hw05scF0XsQ286Z
         ZmNw==
X-Gm-Message-State: AOAM531NgoFABKbXOl2gdVrgBjAwBgzmgGOA3fKn3IW/iLlD3kmTz0gX
        ASnrPp3beqRmQZxci4Ii1NuItils/wIPlyfksTw=
X-Google-Smtp-Source: ABdhPJzq488bGwYxv9tcBBD77w6Et+Hunbcn7CQTEpxqWBhHD7UA935B6/FJyviyRwQGcStzZd5ZrNYVQJxWtBACJKM=
X-Received: by 2002:a67:d99b:0:b0:335:f18f:7f7d with SMTP id
 u27-20020a67d99b000000b00335f18f7f7dmr11885495vsj.78.1653505990318; Wed, 25
 May 2022 12:13:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:d484:0:b0:2bc:cae4:6d22 with HTTP; Wed, 25 May 2022
 12:13:09 -0700 (PDT)
From:   Rolf Benra <olfbenra@gmail.com>
Date:   Wed, 25 May 2022 21:13:09 +0200
Message-ID: <CA+z==VtN8Ah5nEAnNjr=-C8doB_jKQeeHZ4y31LkP-MWAHCg6g@mail.gmail.com>
Subject: Bitte kontaktaufnahme Erforderlich !!! Please Contact Required !!!
To:     contact@firstdiamondbk.com
Cc:     info@firstdiamondbk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Guten Tag,

Ich habe mich nur gefragt, ob Sie meine vorherige E-Mail bekommen

haben ?

Ich habe versucht, Sie per E-Mail zu erreichen.

Kommen Sie bitte schnell zu mir zur=C3=BCck, es ist sehr wichtig.

Danke

Rolf Benra

olfbenra@gmail.com







----------------------------------




Good Afternoon,

I was just wondering if you got my Previous E-mail
have ?

I tried to reach you by E-mail.

Please come back to me quickly, it is very Important.

Thanks

Rolf Benra

olfbenra@gmail.com
