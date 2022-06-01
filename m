Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60AF53AF51
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Jun 2022 00:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiFAVKW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jun 2022 17:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiFAVKI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jun 2022 17:10:08 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD32381AB
        for <linux-bcache@vger.kernel.org>; Wed,  1 Jun 2022 14:10:03 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id l84so4232143oif.10
        for <linux-bcache@vger.kernel.org>; Wed, 01 Jun 2022 14:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=Gk4nfCem3ECRa7Gml0J0mN/3RZoOAdfGaQAqyHPKtiI=;
        b=RGd9c1aErSn0Z6Ze8KLoF3EWbTH/9kTlwI+HC+SAx7dzvBrwHHsKOlh0JbRb09xcBP
         iM2OCHeO/Jrl9Xle2mDSw6T0q2WeDDZSG5qe5a4Dg+cUelC504vEzjOQufYXWP9aJXgI
         V/LFJCahzAFFpJlr1tiv2Vp4M01X+B3LdrfN7rOxB8bGQcOq43FjV1KDwVfyhOisNkOG
         FD6f0xHzXypVyOoc2S2G61yyKZweooFWr6HTnKbFSpcoQrcxWgeekfUkx9WrMRo9A/lx
         1hTIaXz5Rg+fQ0IRlejP5CxzHN8QjtW4TV9t29PD5AzmW/wzytk4/unH4gfxTM3MusEo
         OocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=Gk4nfCem3ECRa7Gml0J0mN/3RZoOAdfGaQAqyHPKtiI=;
        b=tqrjSUrOWafY+GdBCjy3sYDRzVJedcepcdvPDZA8P9VpRfL/A9CM3uA/6A8yZeP9UG
         qHRnOKvfGxBj10FfAfyUkzIsZm6M1yJwqlIIbgtK283yTuLlxdVsgpB/yM5l34iEO5sc
         /uidl6qcn4At1qYcqNpqSt9w/ljxPc/VQXcLaAsXCSn7aCdo9qQkHo6ZFkcLC9SfQjEt
         450QItHro9RVIyA9XkdD5MkF/4QcpD0q4qoGiJdp5ShGZl2GM3IXy2+1DYgmCaZ/i+bZ
         LuVNpIVoDvkicbYb7uB4T5WcCNqJUVAgbGyhQOrx17Ed0KnnQrUWd+C4cIzLWy1zI0Rn
         vx8w==
X-Gm-Message-State: AOAM533pz/I3A3NkvJ75+w4dY1jDcEBn95puL05+BoQBJOdvBVZJNCsL
        Qv60Pum/rxPnqOj3IO45KzFieh7ZTb5USHfqq2l09/HLM5I=
X-Google-Smtp-Source: ABdhPJw3lgUh0oxmgmjzAwlNNZ94ksw/9I0mOwLnUtgereG7iWZKY4s1I5RZI0o0mPKS7RYxDWrvjq+R1cXj2tliMpE=
X-Received: by 2002:a05:6870:4619:b0:f1:e78d:fd54 with SMTP id
 z25-20020a056870461900b000f1e78dfd54mr18171419oao.195.1654111014269; Wed, 01
 Jun 2022 12:16:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:3601:b0:a3:2139:251d with HTTP; Wed, 1 Jun 2022
 12:16:53 -0700 (PDT)
Reply-To: johnwinery@online.ee
In-Reply-To: <CAFqHCSRskayxkisB-+u26DtbT6KFL5dAQ+X5s5W-kcBz_DGgTw@mail.gmail.com>
References: <CAFqHCSRskayxkisB-+u26DtbT6KFL5dAQ+X5s5W-kcBz_DGgTw@mail.gmail.com>
From:   johnwinery <alicejohnson8974@gmail.com>
Date:   Wed, 1 Jun 2022 12:16:53 -0700
Message-ID: <CAFqHCSSwNksOc4c+jJ+6tiF2b2hWGn9JARB6iPpgQJTeHU_7AA@mail.gmail.com>
Subject: Re: good day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Greeting ,I had written an earlier mail to you but without response
