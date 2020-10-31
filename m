Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA042A1ABC
	for <lists+linux-bcache@lfdr.de>; Sat, 31 Oct 2020 22:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgJaVdI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 31 Oct 2020 17:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728553AbgJaVdI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 31 Oct 2020 17:33:08 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D22C0617A6;
        Sat, 31 Oct 2020 14:33:07 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id r8so6720114qtp.13;
        Sat, 31 Oct 2020 14:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xHvOHUVvu4ckbchx1rcuGr08kZCMPwt4rJyailG9bbE=;
        b=PXt1Lod62vg8gGET6LJhJCXNcAPFlFMqhaLW/oHUss2OGkbyS0YCJBKTjLTU9jBnJP
         Xdkns0Q7fETaxj+olj5iMsdqrAkBUMBMh7IVyQosyXpFAMhodyWnYtGV9BHCihrGZN/B
         dfd+D0Fc+FllJtZcwZTALVV7HrOQnFS8ownbwN+B+bRbMW7Bt1jOhcZGMn9EITUZ5ztH
         JAgGTVa9Y+2y9DFCnki15TVU6X86FLg/UgI+M9QnWnKMVgQD6vZCAcpYeYKRixVxNZxT
         oF2TZ3X/wjk3l44NHMlIGXDU4FtiZJ8X6kqba7Q+o+XP9/kvuSRSQuuohjNPfTLH6yRY
         Dlmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xHvOHUVvu4ckbchx1rcuGr08kZCMPwt4rJyailG9bbE=;
        b=Z4zKubUKPH3vR64hajDHk6bAOJ1dMUejEFFJzDQBYzBJROL0iBZU6cIDYNfTERZVXQ
         lp+/WCfLPfiO9bXA8uCUEZ1kwkSap3r71h6t4ye679qsa+8SByoNtEOwWRKQ6YxeCQzU
         N0GApT8eUQVFGU1QeEVhdAwJmAnC4YH5sSJvR3xPODdLu5iFYvzSGOlsBFRCRtypvbIO
         fTrFoeNL7pXlD8UjXsnITc9mkfEa5PH152sJaF67pPjPIWE69136s1WzvgVYYJ1NtzO8
         wdV6pTasJUKTjaZPsZ/fjsOPgUoT0NqKrSzrymYBgC/NwV0yGJEhnu1w3yr/MZVToOxH
         XKJQ==
X-Gm-Message-State: AOAM533VA5QmgBFMgmnunuDyci06JlNyYf8P11bEppKBu/hySopE3Hyz
        L7GfyXDovE0FEzrL6uYuC0nSTJIRrJnxkas910JsyCY7VcU=
X-Google-Smtp-Source: ABdhPJyH4x3XJbLMJ7sY9fe6Z2kSL4S37owrGlWRCqTmjoD87RzDjMLEM/6vqyHGxMoGH58ahNEztGNUEB1zdGP7kcs=
X-Received: by 2002:aed:384a:: with SMTP id j68mr8263047qte.170.1604179987263;
 Sat, 31 Oct 2020 14:33:07 -0700 (PDT)
MIME-Version: 1.0
References: <20201031085810.450489-1-hch@lst.de> <20201031085810.450489-2-hch@lst.de>
In-Reply-To: <20201031085810.450489-2-hch@lst.de>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Sat, 31 Oct 2020 22:32:56 +0100
Message-ID: <CAFLxGvzXaM8gKF5ffG6dgNaCuTV_g7uozoMiPPHtkmte2CY_bQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] mtd_blkdevs: don't override BLKFLSBUF
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-s390@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
        linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org,
        Stefan Haberland <sth@linux.ibm.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Oct 31, 2020 at 10:08 AM Christoph Hellwig <hch@lst.de> wrote:
>
> BLKFLSBUF does not actually send a flush command to the device, but
> teard down buffer cache structures.  Remove the mtd_blkdevs
> implementation and just use the default semantics instead.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Richard Weinberger <richard@nod.at>

-- 
Thanks,
//richard
