Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5A91D1D78
	for <lists+linux-bcache@lfdr.de>; Wed, 13 May 2020 20:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390159AbgEMS3b (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 May 2020 14:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733310AbgEMS3b (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 May 2020 14:29:31 -0400
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64F53207D0;
        Wed, 13 May 2020 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589394571;
        bh=QRSsQMrQ74camPjAugEMwP/lQqJBw3KN+yss8wjRYVo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zuYgTbgg+vneAleokfO2ukKNs/dqZRWw5cokGloCn06DRltmLMyAH0XWH7ZXE6kme
         ad+FAFkx841tWRfGJCwJuCCrF9NfvNSBS/VNkG+/4QSbaYBUc8DgdG1PYWFgMFsatw
         bhT63We9c1wVG6MA7eSBOs4coDppYUwq6NJFs550=
Received: by mail-lf1-f54.google.com with SMTP id h26so362013lfg.6;
        Wed, 13 May 2020 11:29:30 -0700 (PDT)
X-Gm-Message-State: AOAM533WL1j2HlmGsB4c17HR6omCcifybnCitPOHU0xJYEjH7Mp8fW3f
        kyuY5C45juVn5EkVOlLpTUZPlFb0QIZYtQTyLA4=
X-Google-Smtp-Source: ABdhPJzEel6P56V5AzdhnqpR97v3ZXYr3I1lEd0oqpxPoU0DCjvc+wX2TsHUs+/MUKk1AS+L8zGBfF+JTi024W0oARc=
X-Received: by 2002:ac2:558e:: with SMTP id v14mr539886lfg.138.1589394568604;
 Wed, 13 May 2020 11:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200508161517.252308-1-hch@lst.de> <20200508161517.252308-13-hch@lst.de>
In-Reply-To: <20200508161517.252308-13-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Wed, 13 May 2020 11:29:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6_Y53_XLFeVxhTDpTi_PKNLqqnrXLn+M2fJW268eE6_w@mail.gmail.com>
Message-ID: <CAPhsuW6_Y53_XLFeVxhTDpTi_PKNLqqnrXLn+M2fJW268eE6_w@mail.gmail.com>
Subject: Re: [PATCH 12/15] md: stop using ->queuedata
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k@lists.linux-m68k.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-nvdimm@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 8, 2020 at 9:17 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for the cleanup. IIUC, you want this go through md tree?

Otherwise,

Acked-by: Song Liu <song@kernel.org>

> ---
>  drivers/md/md.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 271e8a5873549..c079ecf77c564 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -466,7 +466,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
>  {
>         const int rw = bio_data_dir(bio);
>         const int sgrp = op_stat_group(bio_op(bio));
> -       struct mddev *mddev = q->queuedata;
> +       struct mddev *mddev = bio->bi_disk->private_data;
>         unsigned int sectors;
>
>         if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
> @@ -5626,7 +5626,6 @@ static int md_alloc(dev_t dev, char *name)
>         mddev->queue = blk_alloc_queue(md_make_request, NUMA_NO_NODE);
>         if (!mddev->queue)
>                 goto abort;
> -       mddev->queue->queuedata = mddev;
>
>         blk_set_stacking_limits(&mddev->queue->limits);
>
> --
> 2.26.2
>
