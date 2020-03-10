Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430951809DF
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Mar 2020 22:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgCJVGR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 10 Mar 2020 17:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCJVGR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Mar 2020 17:06:17 -0400
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36E4A227BF;
        Tue, 10 Mar 2020 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583874376;
        bh=vhxZrp2Lx5DeATCenHy71j1LATXknii/r2+vE+Yb5m0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VSxML8CZIv6TujbXRjRw9Ndm8hswQ0Iy4czB2jk6b7uVrcoP7w2FT3QpRGHO/Gfw8
         1PAC8sWmIxLgfBwLT0IoBg95GgOQJewHjIgNWqAF9o7XsmOF2nFAtuL0aHnkZz6PQW
         ByM8dtKGpYIidv0mnusE83YjNVcG4UXW3V9qqpcY=
Received: by mail-lf1-f54.google.com with SMTP id i10so12136173lfg.11;
        Tue, 10 Mar 2020 14:06:16 -0700 (PDT)
X-Gm-Message-State: ANhLgQ04zCsRs7UK9XWxVx7wooYAdDNSM9b0I0WQv78AILIpGR7hrwLU
        Mm1oEeT5RNcvNoUsZ/IhpxOsvFDGqis7tSd4obw=
X-Google-Smtp-Source: ADFU+vudBQrw1oSvW+1z/bikz1NjhAJyNp9q/S1l7eZSBzV8bqzYmhmQtaOP3eZbtp4E2HGJaK7++RE5+JjVfD/y/h8=
X-Received: by 2002:ac2:554d:: with SMTP id l13mr39638lfk.82.1583874374294;
 Tue, 10 Mar 2020 14:06:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200223165724.23816-1-mcroce@redhat.com>
In-Reply-To: <20200223165724.23816-1-mcroce@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 10 Mar 2020 14:06:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6DOkyvscJhxXPE+KLsw=WH6CQ=8_5uThzf7_pmD3E8JA@mail.gmail.com>
Message-ID: <CAPhsuW6DOkyvscJhxXPE+KLsw=WH6CQ=8_5uThzf7_pmD3E8JA@mail.gmail.com>
Subject: Re: [PATCH] block: refactor duplicated macros
To:     Matteo Croce <mcroce@redhat.com>
Cc:     linux-block@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-nvdimm@lists.01.org, linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-mmc@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Anna Schumaker <anna.schumaker@netapp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sun, Feb 23, 2020 at 8:58 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are defined
> several times in different flavours across the whole tree.
> Define them just once in a common header.
>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  block/blk-lib.c                  |  2 +-
>  drivers/block/brd.c              |  3 ---
>  drivers/block/null_blk_main.c    |  4 ----
>  drivers/block/zram/zram_drv.c    |  8 ++++----
>  drivers/block/zram/zram_drv.h    |  2 --
>  drivers/dax/super.c              |  2 +-
>  drivers/md/bcache/util.h         |  2 --
>  drivers/md/dm-bufio.c            |  6 +++---
>  drivers/md/dm-integrity.c        | 10 +++++-----
>  drivers/md/md.c                  |  4 ++--
>  drivers/md/raid1.c               |  2 +-
>  drivers/mmc/core/host.c          |  3 ++-
>  drivers/scsi/xen-scsifront.c     |  4 ++--
>  fs/iomap/buffered-io.c           |  2 +-
>  fs/nfs/blocklayout/blocklayout.h |  2 --
>  include/linux/blkdev.h           |  4 ++++
>  include/linux/device-mapper.h    |  1 -
>  17 files changed, 26 insertions(+), 35 deletions(-)

For md:

Acked-by: Song Liu <song@kernel.org>
