Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9E2117C7D
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Dec 2019 01:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfLJAgd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 19:36:33 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34818 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfLJAgd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 19:36:33 -0500
Received: by mail-wm1-f68.google.com with SMTP id c20so1258056wmb.0
        for <linux-bcache@vger.kernel.org>; Mon, 09 Dec 2019 16:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o6uZCF5x/xwS4v/SjpYmK7GNi693NvVfOeAtt9Xaviw=;
        b=YHvwiAJ8/kvMd9eYNiyjBfFReYakW9AFAjIZC4mWYSoIYlLnV3wVJ44BN5YhFN0pj3
         x8RCdQqLHroL6/ckU1LyHopz2psttPzAoiAMCWArMyMlHpzZY5wStTlFYop0V6fRT8PZ
         N+A9g0WtuaGTSb951nnDzo5T7TnSAIifF3zrDOLfXd3k149ROIalkY4NnU2AMjMDViKl
         VMSX7hsETbO+T43FxTPEA7L0Ain3Q400H+S+xCWws6ghXqH2dz9TiGh0ziXAGSVVJ055
         +oUJHJpt75ZaDd5X4zfMIpZOaaqoFiGYWM8izQPMCrxx+B14dyhZcDVG+v6q2n93bqEJ
         pkTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o6uZCF5x/xwS4v/SjpYmK7GNi693NvVfOeAtt9Xaviw=;
        b=VYWl9dqExBP4UHmIH0gR4VaENA+Z/o6glzCJc3xWhWEvhAOPaVxKoebW2yHaiRi3lo
         9+uZtQPDRsUwoIG5OVdN97gLthNIEcRSb6RiOI1zq32eKsoJCbfDRcKkCFMFP1U6v1Wj
         ZE2d2sf6YJOBsnvcu3UD0u66C2FAeo5J3CGO4j7VXRQ3w2tPov/G1ekG2yKqOD86JgNC
         77mGPXm1D1Hx5EtemSuGDKlDZTkUXl3dg67/MMPSL4UvuF9rnZ+ffzfxft40xZqEhoI7
         9IWqjAuFp5eA0dPeZp/vvtGZMlAkT+rBHqnBOZQNPGmqdNvJ69zDKRkzZceBzSIM4b44
         KyOA==
X-Gm-Message-State: APjAAAW7OQfwL6UJ9i9r43sKViaxGBvDgSZfYj2jfukTDk0m0ZvF/L2w
        QeMDveUVAP5vISc1XuAaCftgOfrFWKtIFOLgq/8WAa6AMMc=
X-Google-Smtp-Source: APXvYqyZ9TLMGiV/cxTTJtDPqSVKFxZ/8UMDoBlwgYt1f2Q9RC2+LUD31QSZ9lO9fSKPNEaSjFpded4lpNgfGLx4IBg=
X-Received: by 2002:a1c:4944:: with SMTP id w65mr1710649wma.39.1575938191804;
 Mon, 09 Dec 2019 16:36:31 -0800 (PST)
MIME-Version: 1.0
References: <CAEEhgEtXKoQymHyS278GvE=95jNiW71sb1bz_-2AfOkDPp0dMw@mail.gmail.com>
 <alpine.LRH.2.11.1912100029180.11561@mx.ewheeler.net>
In-Reply-To: <alpine.LRH.2.11.1912100029180.11561@mx.ewheeler.net>
From:   Nathan Dehnel <ncdehnel@gmail.com>
Date:   Mon, 9 Dec 2019 18:36:19 -0600
Message-ID: <CAEEhgEsy8+aZuEfw5vX_ytKhCq2WxnC=N6AS0msKx_JgJb+=-g@mail.gmail.com>
Subject: Re: Trying to attach a cache drive gives "invalid argument"
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

[ 9651.101227] bcache: bch_cached_dev_attach() Couldn't attach sda1:
block size less than set's block size

On Mon, Dec 9, 2019 at 6:30 PM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
>
> On Mon, 9 Dec 2019, Nathan Dehnel wrote:
>
> > root@gentooserver / # echo 45511b33-6bb8-42d5-a255-3de1749f8dda >
> > /sys/block/bcache0/bcache/attach
> > -bash: echo: write error: Invalid argument
>
> What does `dmesg` say?
>
>
> --
> Eric Wheeler
>
>
>
> >
> > How should I fix this?
> >
