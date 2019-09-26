Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16599BEF4A
	for <lists+linux-bcache@lfdr.de>; Thu, 26 Sep 2019 12:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfIZKID (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 26 Sep 2019 06:08:03 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38596 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfIZKID (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 Sep 2019 06:08:03 -0400
Received: by mail-oi1-f194.google.com with SMTP id m16so1583923oic.5
        for <linux-bcache@vger.kernel.org>; Thu, 26 Sep 2019 03:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4jIcsg0TWQMt0RSbG61t0lzV3k+gIZpPjLaaUgu4gdI=;
        b=Fm5XcIHbvVbuilhWyx49EwOTGpMqVVEebWf2szgy0psGBZ+3mTibVgJANCFNln34vi
         5eyIPFKJa3ySFRng4sMwFYNbI+PWPc7rUCYLxtDOy+cuwLq2rKNYqjRYcA5FLduEQDPZ
         LP4YY3qL8C64zmdxANfty+JXNXZcvMpQ8n+ijlAHYGRInPC0/reUr7IleipzYTmCFlCs
         PxjvZRtx6vFybOduZqVOw8zWSY2+UldF9D3VQBtC5QsKqDhf0JoislfAEgE5GrDZ65jS
         DdKQPTeBput2wDJ0915HUhV0p/atGc81pgC9p5Ha0JtJWx2y+jKSTAjOX0MrR00I0uVf
         Jugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4jIcsg0TWQMt0RSbG61t0lzV3k+gIZpPjLaaUgu4gdI=;
        b=lI0caBpLr4zOuO8rl5I30GW0LRGcx1qmSjDx4gpND5xX74hiOic4ApNGuwDrzx8TDd
         lJatwU/8cvYIUzRvFQ+IHbG0adPrYQzj3KpNUdlqOamDAJf1luMZUEfV4A4fdQpKvhJW
         gA9EsCFwcX6NQ3XIDK7BdEhAcqYVPLL7ghH+cRvMiVlnkuhnagMNK0PuYpIxZOFMTYrH
         23Cs9HUeYikt0i2G/RE1Ed4bHJQ01zG8DRDpkTxx1EaRjqqqDwhfEEg2gDGgeYYG3lVk
         bFhSoSi3SjOKq7JHItSIBH78N6dUr9srCgLn4p6h/iHDv7HOtm6yS2UF1diKYgSATxCo
         TdfQ==
X-Gm-Message-State: APjAAAVUbp/MaifG+UuN3xND+3dq2b5wxKrDL3ChE7ayVlH/FyuQPTp4
        msvhGlyLcY7cYbrF9S+KHzeSwPE8Wj44TvMklc4=
X-Google-Smtp-Source: APXvYqyOMLmU+nI9iUa9dEgZJ6bksjjDkah0H7dmYcSVt34Ntf/Pzjtq8gtC/9LeT5l+3znDWjsQzxRCpbft/lCT8P8=
X-Received: by 2002:aca:540a:: with SMTP id i10mr1873299oib.108.1569492481925;
 Thu, 26 Sep 2019 03:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAG32U2fdDmaSzgCsuc4JVB4L0w_QujcbiK8YWMNVv+Sj4TdbvQ@mail.gmail.com>
In-Reply-To: <CAG32U2fdDmaSzgCsuc4JVB4L0w_QujcbiK8YWMNVv+Sj4TdbvQ@mail.gmail.com>
From:   Henk Slager <eye1tm@gmail.com>
Date:   Thu, 26 Sep 2019 12:07:50 +0200
Message-ID: <CAPmG0jayUzX1Sx8z=WT1MThKyou5qvT7L1J5wNSoAOHb4S-hMg@mail.gmail.com>
Subject: Re: Issue with kernel 5.x
To:     Marcelo RE <marcelo.re@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Sep 25, 2019 at 6:52 PM Marcelo RE <marcelo.re@gmail.com> wrote:
>
> Hi.
>
>  have problems running bcache with the kernel 5.x in KUbuntu. It work
> fine with kernel 4.x but fail to start with 5.x. Currently using 5.2.3
> (linux-image-unsigned-5.2.3-050203-generic).
> When power on the laptop, sometimes it start to busybox and sometime
> it boot fine.
> If boot to busybox, I just enter reboot until it starts correctly.
> I tested:
> linux-image-4.15.0-29-generic
> linux-image-4.15.0-34-generic
> linux-image-5.0.0-20-generic
> linux-image-5.0.0-21-generic
> linux-image-5.0.0-23-generic
> linux-image-5.0.0-25-generic
> linux-image-5.0.0-27-generic
> linux-image-5.0.0-29-generic
> linux-image-unsigned-5.2.3-050203-generic
>
What settings do you use (e.g. writeback 10%) ?
