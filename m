Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F243961D9E4
	for <lists+linux-bcache@lfdr.de>; Sat,  5 Nov 2022 13:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiKEMfi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 5 Nov 2022 08:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKEMfi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 5 Nov 2022 08:35:38 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577D915730
        for <linux-bcache@vger.kernel.org>; Sat,  5 Nov 2022 05:35:37 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a67so11114865edf.12
        for <linux-bcache@vger.kernel.org>; Sat, 05 Nov 2022 05:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c8XA1N0uaxkLO/wKHErNWHaSuu64k5Pjb5u9dmcZrOc=;
        b=cBRQ6Y8RpefIRHVQrLMSbFXJhzjFVhKUVpWiqphfFD7ZpdDCO4bkiuF3D/wQA8szCV
         N9/bn9IHCh7XDMLbhEEGrfqiLIOEs4dJxsB83TL3DNqg7MfoEPuluMIpDp6ZBO90y4DD
         fWKUOs/7GSTK6BhMWPmhNXEAq6hohjAMxPiWpy1hZI9WsxxcpRo2Yb+NBHr+rq8EXy5G
         MP37jw6howTDBU0pbP6pioWqE/qZyyX+SMTGB3BuhtQMIjk4NfTxtGc7ZD/jM6B1zSTJ
         SG+flxql5YVXo/GQ+GhmgMs26VLfUnwwzfizS49eehXvsuQO1umllX/v9vFFdjUUHgmE
         ubNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c8XA1N0uaxkLO/wKHErNWHaSuu64k5Pjb5u9dmcZrOc=;
        b=xW+wnnbphbp/IB7ccJR1+XwDL3WTxXY82+IAQvpHgCyMXwKSoxcLRJnyTywRK5Y2du
         a9+phqu/iru3WxPrcKNdFt86pkTlM7EzW3o+JUxiQ3UEQciWxh0gQzEPAQfqjfYmQo0q
         WgqcZ7jaEZ9mjQl++PCoO9ZmakmJYPPQsOqFXt8yWf21ierLAuMptNyrcezONApn6mwY
         1Pgeek9R8bnQj8a/WWGKsD/J8TAqtr1BjKCSeXS3iQIdfoJMV1qXuq9eb4EVALXcLftI
         SC0eDtOmKciZbrds77DxAcGh4swWA9sYegv+WakiaYQyBvZGcLTYj0Tp5hSOXo6uTegn
         UGxQ==
X-Gm-Message-State: ACrzQf1sE9gZ4zlwAO+yEUDgjk/ICLf5o82WJTcskl0CigfY25MaT2Q8
        qJbcT3ilN7wcJKZpBFrJ4K1Xf1pITGNlDabbU8I=
X-Google-Smtp-Source: AMsMyM7ov6riUwC0zZeruMWfTOWyLCbUC37ops/VJH6Iz0RYno+LBVMMQ4SF3SwUDowxxmVLzV5y8vk580CQgz/obwk=
X-Received: by 2002:a05:6402:2947:b0:451:32a:2222 with SMTP id
 ed7-20020a056402294700b00451032a2222mr39283693edb.376.1667651735582; Sat, 05
 Nov 2022 05:35:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:3c41:b0:78d:b654:8aec with HTTP; Sat, 5 Nov 2022
 05:35:34 -0700 (PDT)
Reply-To: stefanopessia755@hotmail.com
From:   Stefano Pessina <annastaciamutuku87@gmail.com>
Date:   Sat, 5 Nov 2022 15:35:34 +0300
Message-ID: <CA+Rj53bd_Xp1QaoObL4LCwiUdRsk7BNXS8hYLLL5HqpCEx86qg@mail.gmail.com>
Subject: Geldspende
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

--=20
Die Summe von 500.000,00 =E2=82=AC wurde Ihnen von STEFANO PESSINA gespende=
t.
Bitte kontaktieren Sie uns f=C3=BCr weitere Informationen =C3=BCber
stefanopessia755@hotmail.com
