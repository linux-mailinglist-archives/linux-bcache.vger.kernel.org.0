Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502DD114FB7
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 12:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfLFLXr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 06:23:47 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33545 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfLFLXr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 06:23:47 -0500
Received: by mail-qk1-f194.google.com with SMTP id c124so6220900qkg.0;
        Fri, 06 Dec 2019 03:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lCXoIWakRU3V5oXHzk/54lcFuPvdsHqcKCN0u+YlFk8=;
        b=DUzVap8v4VirQVTep3A6dGYG+uytH67cmP4XN8Lne0knjj/yCEiW72bk2E3dXh5dic
         Bs+Yq6xfOiNDdmmxipv39ecbcWapH/HGi9qxBZ84jeo3hBH1bFWvBnEICJeeOWN4MzoU
         uVeUF8NZhXv2sBm+78UIrC53wY+mzPByWqmLYYp0hMfMz4kc09VVIH5Lu2K8C1zx/PwN
         2qxBeqMsoeSLmM+HooR9qmaGTEcgmHJuSqB4z1bi4FY6FaMugCDvyq9/7pUSHXmmdpQv
         U/Lisw/iHSVU+KX1csgzKA2I9r/xOaKEjC9H8ET8kGkmFi+pGy4Q3xLBHWiScb7M9AnZ
         OULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCXoIWakRU3V5oXHzk/54lcFuPvdsHqcKCN0u+YlFk8=;
        b=ahnGE1Rz7wDBvbZyi+QGUQlRQX2DeN1AkkP/vnURUwJnagD71leaJDv8G6gzLG41s3
         1UVkA8ynDoiFse7MZlPCLKI/D9+mPHhVCTRkCd8F8VIjhmPczVggB8skOB+DYPUk1Fh4
         Z8eEMR8KHDRlBjjxndh6WRP0r/HYGX5leJ//JIcKxF/WjZFmM2wOvfWYp/FWy20gIptZ
         VVAkUttG7iXyclO1J/z00LNM4g/pnF0zWdXPJT1mSyq8spi0Qv4YWFaSmi+N9Gg2pGMN
         BLlnmXRILtMwql6PzuXgayx8alMABagFwHJI2KJcnWoutXMCQ6xkcnvk4afup0mU6tlw
         VbUQ==
X-Gm-Message-State: APjAAAX+F6y3FJc8Dnjif2pIJnEf7LCS9sdyw+4twXi14D5jtd+TlQcB
        rvSy7194JTy6lYER4q4gwCXqspOWkzcCWDrVNm0=
X-Google-Smtp-Source: APXvYqwRiDdbmUlgkoJoWPMMG4F45AgSVaufe6gb3a6Zoiuoo1pW2O/Ry/R+iEpUq1NigQhTl50C69QiBbnq8WUZOnc=
X-Received: by 2002:ae9:ee11:: with SMTP id i17mr10179649qkg.333.1575631426316;
 Fri, 06 Dec 2019 03:23:46 -0800 (PST)
MIME-Version: 1.0
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com> <20191206092336.GA7650@infradead.org>
In-Reply-To: <20191206092336.GA7650@infradead.org>
From:   Liang C <liangchen.linux@gmail.com>
Date:   Fri, 6 Dec 2019 19:23:35 +0800
Message-ID: <CAKhg4t+LTwny9_xs4YWuSzz9oeqWK81=JRr8V92JTc0HSQ7ANQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Thanks for the advise.
Yeah, calculating the offset based on the buffer size is possible. I
just wanted to avoid making a dependency on some buffer head
internal logic here, like the way it dividesthe page into equal sized
buffers, and at the same time keep the patch less intrusive.

On Fri, Dec 6, 2019 at 5:23 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Dec 06, 2019 at 04:55:43PM +0800, Liang Chen wrote:
> > __write_super assumes super block data starts at offset 0 of the page
> > read in with __bread from read_super, which is not true when page size
> > is not 4k. We encountered the issue on system with 64K page size - commonly
> >  seen on aarch64 architecture.
> >
> > Instead of making any assumption on the offset of the data within the page,
> > this patch calls __bread again to locate the data. That should not introduce
> > an extra io since the page has been held when it's read in from read_super,
> > and __write_super is not on performance critical code path.
>
> No need to use buffer heads here, you can just use offset_in_page
> to calculate the offset.  Similarly I think the read side shouldn't
> use buffer heads either (it is the only use of buffer heads in bcache!),
> a siple read_cache_page should be all that is needed.
