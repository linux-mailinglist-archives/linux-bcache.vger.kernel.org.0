Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681C420E67C
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Jun 2020 00:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbgF2Vrw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Jun 2020 17:47:52 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46365 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391466AbgF2Vrq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jun 2020 17:47:46 -0400
Received: by mail-ot1-f65.google.com with SMTP id n24so14590650otr.13;
        Mon, 29 Jun 2020 14:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bg/8+MNYJDDCvPfevV5MmVW6eomjiYjuKJdPS9BuKRc=;
        b=KrtLIKkstEXzLph+hH/92CRzqSHeAWo3KOzjjTkWcrVtsSr2KKh0OzcDqgOcxe8+Qp
         b7NFKuu1zn/ZMMrPwkNhH1EkonUY88m3Bgy0luv4wlSSDt0luFg1XBcl5Ny2QHr/jFHI
         lN25QpT2n9O4tkMAVDRIXDKcT0J9wikh9hfdxRy7euptOkW+8yJSS7TxlcfdcUpyb3oP
         D8sdZa59FDQWJmhr3b702CrXoGaAO45EXdvR4Qa2UgBeDAmt/EKbhubG8XG0gVF33K4T
         0Qapyhd9knt8a7LX37eArLbgVFfSJVK3nVD9mONOy09RxERJt4EAN0eL4za2Q+Won56r
         whPg==
X-Gm-Message-State: AOAM5335T8ZfZvTnFiUis89joIQO6t/GWXerNU4YC2r7DRXcnCkctsEl
        wlRaSM29d/kdq6uE1xrxf62PHRBncRWszVucSjW9XjSBAFI=
X-Google-Smtp-Source: ABdhPJyLaroA0htJgp6XAeP34onG9mo2tlAy+lOvoV/8lvJ36fwjwGDczPcQeW26SHMu76Ngn9P5yzkiLg9cpAETRvQ=
X-Received: by 2002:a9d:2646:: with SMTP id a64mr14223999otb.107.1593467266175;
 Mon, 29 Jun 2020 14:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200629193947.2705954-1-hch@lst.de> <20200629193947.2705954-2-hch@lst.de>
In-Reply-To: <20200629193947.2705954-2-hch@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 29 Jun 2020 23:47:35 +0200
Message-ID: <CAMuHMdXXORM_yD4bqk+MQ1yEA1jmOjO9eyfnsjxY1a5E5isEcg@mail.gmail.com>
Subject: Re: [PATCH 01/20] nfblock: stop using ->queuedata
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        linux-nvme@lists.infradead.org,
        linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Jun 29, 2020 at 9:40 PM Christoph Hellwig <hch@lst.de> wrote:
> Instead of setting up the queuedata as well just use one private data
> field.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
