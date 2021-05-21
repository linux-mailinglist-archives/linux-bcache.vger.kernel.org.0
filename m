Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5148838C210
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 10:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbhEUIjd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 04:39:33 -0400
Received: from mail-vk1-f173.google.com ([209.85.221.173]:38726 "EHLO
        mail-vk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbhEUIjc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 04:39:32 -0400
Received: by mail-vk1-f173.google.com with SMTP id o24so1981967vkf.5;
        Fri, 21 May 2021 01:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RVHzs0poOF+hVS1v1BAW6iRpurNI2FLCHK2qQooBQc8=;
        b=ckdvfHYBrLrpwASgs+RmUT5WDLn+xzDOnpk0GW32CBzsHEL+OR51W8SqH+PuTXYuOU
         NA1Z9A2i0p0k9EKdpyq7l894jTdd7a5h3VW4Bf5FYQjGeFqtWMOjhFw0UxrWd58TiBGI
         U4nodKBAMR8Cua58UW3umsqA4NCSHNff4pSXVglPeyX1ZJMvY7xTj/i8G19vkZnrZdlb
         Sb9Y0FObHzUeIPTjxTfLL3gB4CNHQ9KMt6ZnbhZ4Wdb0wsDEMPa/rmAcj64g6lE0RYbW
         aEXSv+oOA+rYqmSa3CAWSubWP7qEjqu+HSFsl5MPkffi/9/X1YJ+x0o96wrOFwnoiqu/
         oRZg==
X-Gm-Message-State: AOAM531gau/vGmYh6dvJUF66yiiIWInbif2MhbK8Szohb7L4z7jyKZ0I
        zgVJkNij3BVPmmrWIiXxa7Ll1KJw1qy0EFFKI0Y=
X-Google-Smtp-Source: ABdhPJzGTg0SxZhAyS6W3ANe8pj0R0i+6+zDbI/+BVCcJpHhTvw5AwmdUSLpxqeMfSWaogZWi2MJbcqhNDfvoXw93hU=
X-Received: by 2002:a1f:2504:: with SMTP id l4mr9071521vkl.5.1621586288105;
 Fri, 21 May 2021 01:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210521055116.1053587-1-hch@lst.de> <20210521055116.1053587-20-hch@lst.de>
In-Reply-To: <20210521055116.1053587-20-hch@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 21 May 2021 10:37:56 +0200
Message-ID: <CAMuHMdUReZCGwii_rJuOOag+jmn4E3yfH+=P3a=5bJDf8CJvrQ@mail.gmail.com>
Subject: Re: [PATCH 19/26] nfblock: convert to blk_alloc_disk/blk_cleanup_disk
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
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
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
        linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 21, 2021 at 7:52 AM Christoph Hellwig <hch@lst.de> wrote:
> Convert the nfblock driver to use the blk_alloc_disk and blk_cleanup_disk
> helpers to simplify gendisk and request_queue allocation.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
