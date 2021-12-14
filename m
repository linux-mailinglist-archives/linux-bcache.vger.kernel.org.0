Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BA047486E
	for <lists+linux-bcache@lfdr.de>; Tue, 14 Dec 2021 17:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhLNQoA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 Dec 2021 11:44:00 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:59760
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229942AbhLNQn7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Dec 2021 11:43:59 -0500
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id BAD433F1AA
        for <linux-bcache@vger.kernel.org>; Tue, 14 Dec 2021 16:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639500238;
        bh=403PGBQb+h3Z+TiwgV04Gowpm/5b+KHSenbrumU92zw=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=LYHxTm92VGNfkhU9eMOdF0vQNSR7EAx++pzhGhro62S36Qewz1l7iex4xhRPEHlDo
         SHB9H2h3VcSxPDAF390+sP7jdvZaN5U1/v37ePIPdmIZTxRTlWPJ2hjzJAVuDQWqVy
         MV5r7qUwPZ8heVvNCQ3st61eKo8LnisdvhVPYlRlYoRCdAwxIK1UL9/sfaBCj5k93/
         BzqxU+WK55b/69cfXI957AM80C2Zef8oAoKlRzBHPFK9L27dck8xtzCpXGJdnJUTzU
         sb4r2MpmcexwWw8jajzQKOwvdh6QVjkIVrOc9+fU8Yq4uGrMpPxetUreNytJIflbLK
         yAK4TFUPahx9A==
Received: by mail-pj1-f71.google.com with SMTP id gf12-20020a17090ac7cc00b001a968c11642so12020929pjb.4
        for <linux-bcache@vger.kernel.org>; Tue, 14 Dec 2021 08:43:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=403PGBQb+h3Z+TiwgV04Gowpm/5b+KHSenbrumU92zw=;
        b=1YWlU0Tp3ntHnmrkx3HdgpASOQazNv9Lmk1jxVCULaHNVJFBTp+ZvoL3AKJvLWOLBY
         wHwDvdratcjVU/LiDiTfhEkMXG16FpyjjV4CVgDIHuBNtNLpv98CWGqt2/3gnF4m3RJ9
         8Sb9pXSSFB1k4rEcm+8/gXkt91ZkTXMMoQixVAmZAyUN8UDvNxzeIUUV1nl+yZF3lD7Y
         N8mHdJGC5pi2WWMpRPe2TLp5xaMwE8onO7TlJAVCIR22JJIWVs8vf460kpplDvBkCjNK
         d4/dovUzB4LveyUUf1iyi3Fvb2PfMS2CYtMhNkn9AdIgvuglONvMBcGaoEYUww7u8tQb
         ssOA==
X-Gm-Message-State: AOAM531ALaUNkIhk8GtkgQjstUIDK4skH0EqLb9ZxIDi+wccsil1OXY5
        N2HSC/csp+1CVtklaWxsMVRmzpv3+1+JMBO58rhMxA4eO0i9L911/DhjkEfg1mU0ktXSe1PgtZY
        Cu978byeZj780f53ij6NGKQZz5S5wkvC2QcQfax9gG5UFr8zDhZ0L/1OQaw==
X-Received: by 2002:a17:902:d488:b0:148:a2f7:9d64 with SMTP id c8-20020a170902d48800b00148a2f79d64mr127202plg.131.1639500237310;
        Tue, 14 Dec 2021 08:43:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfF8GRC+ldGwFR9S+imfLVSyQMoeRXpCQBZLbhNwIOqrGXlNU7LGLqLowIAdSuK8ZJd9i91nPi/gOcPGb+hJU=
X-Received: by 2002:a17:902:d488:b0:148:a2f7:9d64 with SMTP id
 c8-20020a170902d48800b00148a2f79d64mr127179plg.131.1639500236998; Tue, 14 Dec
 2021 08:43:56 -0800 (PST)
MIME-Version: 1.0
References: <YY/+YDSjdZPma3oT@moria.home.lan> <20211213220455.1633987-1-mfo@canonical.com>
 <77a855ff-fb0d-5c7b-d2fd-24d58beb6a07@suse.de>
In-Reply-To: <77a855ff-fb0d-5c7b-d2fd-24d58beb6a07@suse.de>
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
Date:   Tue, 14 Dec 2021 13:43:45 -0300
Message-ID: <CAO9xwp0+11UC085SYt-qiy=n5fzfwKKeshx5shzgM3OXjmXpCA@mail.gmail.com>
Subject: Re: bcache-register hang after reboot
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, nkshirsagar@gmail.com,
        kent.overstreet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 14, 2021 at 1:06 PM Coly Li <colyli@suse.de> wrote:
>
> On 12/14/21 6:04 AM, Mauricio Faria de Oliveira wrote:
> > What do you think of this patch?
[snip]
> The following patch might work but not a proper fix. I am in travel
> recently, and hope soon I may have time to refine a patch for such
> non-space issue for journal.
> I have a patch but it need to be rebased with the latest bcache code.

Hey Coly.

Ok, thanks for the prompt reply and letting us know!

cheers,
