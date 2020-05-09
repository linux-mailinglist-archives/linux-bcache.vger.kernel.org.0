Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985711CC062
	for <lists+linux-bcache@lfdr.de>; Sat,  9 May 2020 12:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgEIKiQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 9 May 2020 06:38:16 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33997 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbgEIKiQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 May 2020 06:38:16 -0400
Received: by mail-oi1-f193.google.com with SMTP id c12so9819670oic.1;
        Sat, 09 May 2020 03:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nBe+65cgrmufPqKgCO/WJS9rGOrSoS9DaeQpyO6VPQY=;
        b=HUXFfZqyQiXplVrHeI/ZPD7fgTu/OyQS1uWandQ6GfholZUozpDA92RXqRtP3552+4
         QU3UraKKkKBepmI4MM8VVIPVwoKSVc58fm+nR18vHiQTUD114S+ZJ7Z1yqclKOvDyfDw
         /LAg8vYGyAmWIpSXcfPoxA14/QbxzjQIGrNCcLfV+j4vNoubQ5Lw6Kej6XiDjnDtr/Sm
         mSjL8ioibecpSpdditmliAoTdksLU0kI/e8QDnJL6gNrAGiDVY9bhRs8tKRKoMOM/4yM
         fBklMHZ/F0j1KhJwDEC/SGcPxpWd4DK81p+RBhisjz5CIqhRrrNXgUi0x5GI2ktEKXzZ
         IZ3w==
X-Gm-Message-State: AGi0Pua8mblCFI4UeA4h/Ojs+ZTIWSRPGsnxdFCxXlARacpXuuCfjEAj
        oYctl3NkzFVkGH2Q6GDOKkrfZ7dULzyemEM0/O0=
X-Google-Smtp-Source: APiQypJViR7zf1BxfE4fSiEMumUvdAfdspNngdk/6s5fr4R3Q+whgmTLapvbuOPEuAwW4U0ZD7JgMnKsLrBjVv9lPKw=
X-Received: by 2002:aca:d50f:: with SMTP id m15mr13605566oig.54.1589020691722;
 Sat, 09 May 2020 03:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200508161517.252308-1-hch@lst.de> <20200508161517.252308-2-hch@lst.de>
In-Reply-To: <20200508161517.252308-2-hch@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 9 May 2020 12:38:00 +0200
Message-ID: <CAMuHMdUBRsZQ1BOD9jW99NTm_8NZDootGrqzz3nPeeJ+mUAoTw@mail.gmail.com>
Subject: Re: [PATCH 01/15] nfblock: use gendisk private_data
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        linux-block@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Christoph,

On Fri, May 8, 2020 at 6:16 PM Christoph Hellwig <hch@lst.de> wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for your patch!

> --- a/arch/m68k/emu/nfblock.c
> +++ b/arch/m68k/emu/nfblock.c
> @@ -61,7 +61,7 @@ struct nfhd_device {
>
>  static blk_qc_t nfhd_make_request(struct request_queue *queue, struct bio *bio)
>  {
> -       struct nfhd_device *dev = queue->queuedata;
> +       struct nfhd_device *dev = bio->bi_disk->private_data;
>         struct bio_vec bvec;
>         struct bvec_iter iter;
>         int dir, len, shift;
> @@ -122,7 +122,6 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
>         if (dev->queue == NULL)
>                 goto free_dev;
>
> -       dev->queue->queuedata = dev;
>         blk_queue_logical_block_size(dev->queue, bsize);
>
>         dev->disk = alloc_disk(16);
> @@ -136,6 +135,7 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
>         sprintf(dev->disk->disk_name, "nfhd%u", dev_id);
>         set_capacity(dev->disk, (sector_t)blocks * (bsize / 512));
>         dev->disk->queue = dev->queue;
> +       dev->disk->private_data = dev;

This is already set above, just before the quoted sprintf() call.

>
>         add_disk(dev->disk);

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
