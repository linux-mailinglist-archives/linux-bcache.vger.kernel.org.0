Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBAC390C5A
	for <lists+linux-bcache@lfdr.de>; Wed, 26 May 2021 00:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhEYWnr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 May 2021 18:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhEYWnq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 May 2021 18:43:46 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043FAC061574
        for <linux-bcache@vger.kernel.org>; Tue, 25 May 2021 15:42:14 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id x13so16896510vsh.1
        for <linux-bcache@vger.kernel.org>; Tue, 25 May 2021 15:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q2ntYm6uDO3tojaF9gfgprihNvjCO5hVlU6EmFGOmTo=;
        b=K9wqVdOPxXHut6A0EevQX/nqmrPWosCHVPu4555rYr8tuCz8O0lI/p4Rb77PfQ8Yfq
         fRmWkgPHBfsqXzE6lREE/b8PxdKg0U8EuVSS9rL2xjxve3ATaYRjERwWLkhwXRfzDPTA
         KMH0Jn7mx/0V+2ZMCJ2ntLBKrEex0sj58ibU9GJdf25N1KPIZf6ysG7S8bBIp5GxRiyl
         oW1gRaEs+jb593kt9via8xPWNweotp+DwCl/Vc0y0ZfLnCUPzk4X9FC3QvSvLxInEfdN
         EReMXPyNQilw4NAPZf5vV5feE5jyQ8EEPE5nGtQ/Fqd8VnVaNh6v5d36RKW9J9jTG3bc
         rUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q2ntYm6uDO3tojaF9gfgprihNvjCO5hVlU6EmFGOmTo=;
        b=JxR98ubmjE88gK6VqyfMXIM/E8fiQM/Z1BE4Kfh30UuQ00w74xCDcvNQJMxcLkXvFK
         U6ppYidnh3t+Pl9k7DRb0XiH2tJTA7NGs8cb0IgJr2wdpn9L0vxoCi0RX0pwoWFsVuQb
         vKXfAqw/1qGzuv5pIW1B1O0Y4+s7Q+9GnVAcqkuv87XiTGZ2CFyZRp/LQ3uWpe7cx8MS
         ct1s3MGMB+9ye8s+JlyXujie757oEKiPARV/AsiM/kzQliBaj+iVfugB5GKrOOEMCea2
         2DHUXq33W3Yya7YC3Z5xQY6cAIBp9YN8yNd58gPGpxojaCT4yir38YutZkFVMdILrHOv
         WE7A==
X-Gm-Message-State: AOAM530fjB6trhC8m5PJsfKTbHGOu+MMF76fxJnsS2DIqG0pxC5weXzD
        FV9bQIRQJLtjjHtzY/LjGP5akZYpkZ8x/gIsSShzLA==
X-Google-Smtp-Source: ABdhPJwx/fwYmfo8P5+A7EuWXJoD8LuumWi86gXq03cq2Wld1BR6mX3B8HbBTdDiayCS1IrjwzR0gvQYH9nbZXbeRCI=
X-Received: by 2002:a05:6102:7c1:: with SMTP id y1mr29600317vsg.34.1621982533995;
 Tue, 25 May 2021 15:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210521055116.1053587-1-hch@lst.de>
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 26 May 2021 00:41:37 +0200
Message-ID: <CAPDyKFpqdSYeA+Zg=9Ewi46CmSWNpXQbju6HQo7aviCcRzyAAg@mail.gmail.com>
Subject: Re: simplify gendisk and request_queue allocation for bio based drivers
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jim Paris <jim@jtan.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mmc <linux-mmc@vger.kernel.org>, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 21 May 2021 at 07:51, Christoph Hellwig <hch@lst.de> wrote:
>
> Hi all,
>
> this series is the first part of cleaning up lifetimes and allocation of
> the gendisk and request_queue structure.  It adds a new interface to
> allocate the disk and queue together for bio based drivers, and a helper
> for cleanup/free them when a driver is unloaded or a device is removed.

May I ask what else you have in the pipe for the next steps?

The reason why I ask is that I am looking into some issues related to
lifecycle problems of gendisk/mmc, typically triggered at SD/MMC card
removal.

>
> Together this removes the need to treat the gendisk and request_queue
> as separate entities for bio based drivers.
>
> Diffstat:
>  arch/m68k/emu/nfblock.c             |   20 +---
>  arch/xtensa/platforms/iss/simdisk.c |   29 +------
>  block/blk-core.c                    |    1
>  block/blk.h                         |    6 -
>  block/genhd.c                       |  149 +++++++++++++++++++-----------------
>  block/partitions/core.c             |   19 ++--
>  drivers/block/brd.c                 |   94 +++++++---------------
>  drivers/block/drbd/drbd_main.c      |   23 +----
>  drivers/block/n64cart.c             |    8 -
>  drivers/block/null_blk/main.c       |   38 ++++-----
>  drivers/block/pktcdvd.c             |   11 --
>  drivers/block/ps3vram.c             |   31 +------
>  drivers/block/rsxx/dev.c            |   39 +++------
>  drivers/block/rsxx/rsxx_priv.h      |    1
>  drivers/block/zram/zram_drv.c       |   19 ----
>  drivers/lightnvm/core.c             |   24 +----
>  drivers/md/bcache/super.c           |   15 ---
>  drivers/md/dm.c                     |   16 +--
>  drivers/md/md.c                     |   25 ++----
>  drivers/memstick/core/ms_block.c    |    1
>  drivers/nvdimm/blk.c                |   27 +-----
>  drivers/nvdimm/btt.c                |   25 +-----
>  drivers/nvdimm/btt.h                |    2
>  drivers/nvdimm/pmem.c               |   17 +---
>  drivers/nvme/host/core.c            |    1
>  drivers/nvme/host/multipath.c       |   46 +++--------
>  drivers/s390/block/dcssblk.c        |   26 +-----
>  drivers/s390/block/xpram.c          |   26 ++----
>  include/linux/blkdev.h              |    1
>  include/linux/genhd.h               |   23 +++++
>  30 files changed, 297 insertions(+), 466 deletions(-)

This looks like a nice cleanup to me.  Feel free to add, for the series:

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe
