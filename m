Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD55687F63
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 14:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBBN6Y (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 08:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjBBN6X (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 08:58:23 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D23113D3;
        Thu,  2 Feb 2023 05:58:22 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id f16-20020a17090a9b1000b0023058bbd7b2so1286415pjp.0;
        Thu, 02 Feb 2023 05:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xdHlr3SOPAtSw15n+9lmV4cCHmuQTMsGbHcrqatRLEY=;
        b=F6EpSKtfxVZbwae8cDgLzKe/RSYSyRbd0ldpQRcINJvFsHOUj7thNburqY1MBf/U2H
         xP9udUTJhIqiBrB52lQOb3c5u5LZITOgC2u78+xzEmbr4WMEDK8Tl1Ck+04E98XhCBXG
         Rcnd/dCduCj9agRfOnvLXcEfK/x3KKpmOVAOu5RidK/EA5cRvRgfHp/cA29dmdKGLAcc
         oLGT6gVi0VcRh38JoRnVIaP2KCVOL73aglIFUBOun1BsEej1RL846YMJ0NxMAeKs7dfD
         M9lZGn2GPgCQeT1Yw/z5U24vdAPUV9oqvLgv9RRnU8EN5LZw8SK6RuUUeCwpxHprWPdC
         5MDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xdHlr3SOPAtSw15n+9lmV4cCHmuQTMsGbHcrqatRLEY=;
        b=YbXAB8DSZibPgDopN/7oOFF+2G3kLLuYh+x80zN328aai/Dd/soEX8o896Ndwg5iVB
         ggGfe/nWQg8bc2GR3Kduskk2uIq7r/VljTJcbxNiTvgbUAKDH/oPSt/cTfliMtOQ8AiW
         sRnwK0BuVE3NW2InCxwC+jwrGt5tkmBGCJPKEFMNARaLdsi8Xy9kspkMEoXnN8OYEe5d
         DzCAkzjPP3hlF/D/6cKNF3pvcq/AfD92W67Zfu5ACULAyx6Enr+udEGGKcIYETqSlNks
         x6ebEc86fJEIywTCFjqpbTMfr24R+V3LMsaTXc2E6FQ1vdVGxoYeXW7MZzHUJUoOF2ym
         6k/g==
X-Gm-Message-State: AO0yUKV/cQuSHSKm3HcBUt47VmMZnTiN2fAUFO9sNtPMgTuvAC6iXlQE
        2LvAqA7cm8OlDcHOOupzgzRitkZ/eI9i7MW3PxEQUwTMUivCTg==
X-Google-Smtp-Source: AK7set8R/0v0CdKOxw8P+8P+3o/YO1QBec3x05t3Z48EPZMUS3pJzqnT7WPuQ7+wE2ePovO42LPSQ+SDmHubxtFLmqo=
X-Received: by 2002:a17:902:a401:b0:195:eb15:6ed0 with SMTP id
 p1-20020a170902a40100b00195eb156ed0mr1549183plq.19.1675346301530; Thu, 02 Feb
 2023 05:58:21 -0800 (PST)
MIME-Version: 1.0
References: <20230202110543.27548-1-zyytlz.wz@163.com> <Y9un0/BnBoe4B4m1@kroah.com>
In-Reply-To: <Y9un0/BnBoe4B4m1@kroah.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Thu, 2 Feb 2023 21:58:09 +0800
Message-ID: <CAJedcCxKRxryXRpag3hHPvTwhNWTCyQaQrexNXF84+SsLMe7gw@mail.gmail.com>
Subject: Re: [PATCH] bcache: Fix a NULL or wild pointer dereference in btree_split
To:     Greg KH <greg@kroah.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, colyli@suse.de,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Greg KH <greg@kroah.com> =E4=BA=8E2023=E5=B9=B42=E6=9C=882=E6=97=A5=E5=91=
=A8=E5=9B=9B 20:08=E5=86=99=E9=81=93=EF=BC=9A
>
> Note, there is no need to cc: security@k.o on any of these patches that
> you send to public mailing lists, as the development and discussion of
> them should happen there instead.
>
Hi Greg,

Thanks for your kind reminding. I'll remember that in the future.

Best regards,
Zheng Wang
