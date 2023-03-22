Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CC96C447D
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Mar 2023 08:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjCVH5x (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 22 Mar 2023 03:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjCVH5w (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Mar 2023 03:57:52 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363C45CECB
        for <linux-bcache@vger.kernel.org>; Wed, 22 Mar 2023 00:57:52 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h14so9833382pgj.7
        for <linux-bcache@vger.kernel.org>; Wed, 22 Mar 2023 00:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679471871;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ky8YbySl5Wxy5LoCG7bBOuGcuWRwfOySqm6PBgkaSEc=;
        b=U9jv84jfvmFsnZquIXQpv3RgYug2U/pU6+jQvyKptqODPdH4ofSFlH4Htn1GkiuAm4
         6xAsCPhnhw5EYeBOxGHU1EBkBRlNH6U+GqiWs0syUjyCOvWhNeCUV6ASrrbJV0hK8Qe/
         MrkDSQ6Drbz/MC0nvjfPg5Q058v6K1sZrqI8n63r+YbAE+cUttN2RyA5gS8lNUcGlkqr
         QLnkkAiYJzUt2ih0x4wl6PdBCT1pfBc+zhOzBppoFXs+UldjS3Y4QOKajuc5PCcDm60x
         7eAXiHOIuTAPIJ4IWD6qR3J7RhT9MWrdIfkULyZ9jfbChc2fZu2bQ1RSEjijDk7L06YY
         juJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679471871;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ky8YbySl5Wxy5LoCG7bBOuGcuWRwfOySqm6PBgkaSEc=;
        b=YuRKgdDVGD2l72GUnClNf1X3CT5RLFRNG1nPfSmreejM0xOdT+k8zsO6EGVwPMUotW
         UuFSNd/H28tGhDlpEY/p0H8ubARfDHqDpPRe3gyMybm+11RCUGc1aMOofc7rOqz9+p02
         3LaDeUiVEFvrczO3X/Nj1IwauEoINyplXnIw5DawdN8fBypBw5Z4aMu4D5pSZ7o5k12p
         110dGvn1NTbVqqpKWIX2hBfr1wYzg1QMJgH1S3S+COFAt4KmYP6qtIaDdX6MjbKPsriQ
         xNIvorbZXNuR412zboHt3U5Bw/p3TzWffgsXZDkAAl3AhEZSuUFl/Tiz8vh+rx1LgsUJ
         u6Iw==
X-Gm-Message-State: AO0yUKUHZil5OfLgeE8zwi6Nxt+nxOabNPMEGmnSvZ9FeEZRfR60bGk2
        QMAFkBM76Y0V7Qvq6Dt1MILJ0prTSUuBJKWI6sdErTaIndg=
X-Google-Smtp-Source: AK7set8CeyFZ1lGeTLxK+eYJf3G+QO/r6SKKWMCSmg3Pa4StR84G3hobxJuApSaLtQMIPEob52Gk0jcBvm/HHekJB0o=
X-Received: by 2002:a65:6191:0:b0:502:e1c4:d37b with SMTP id
 c17-20020a656191000000b00502e1c4d37bmr495599pgv.12.1679471871318; Wed, 22 Mar
 2023 00:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAO6aweOvLUP0L+DXwJEpbFJ_mF0E44pWcLzXoXvAi4MGPBkFBg@mail.gmail.com>
In-Reply-To: <CAO6aweOvLUP0L+DXwJEpbFJ_mF0E44pWcLzXoXvAi4MGPBkFBg@mail.gmail.com>
From:   gius db <giusdbg@gmail.com>
Date:   Wed, 22 Mar 2023 08:57:40 +0100
Message-ID: <CAO6aweO4tbREeen10rQP46SyJNZTx+WN2J5sdTiihJhjRn4eZA@mail.gmail.com>
Subject: Re: Throttling performance due to backing device latency
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi.

I'm (negatively) surprised by the non-reaction from the developers
(and everyone).

The point and the proposed solution is not esoteric, it doesn't
concern strange or complicated things, but something trivial and
evident (when using writeback, cache performance is lost unnecessarily
and without warning).

Okay, I'll be wrong, and anyway bcache for me, it's useful, it works
well, I can fix it.
