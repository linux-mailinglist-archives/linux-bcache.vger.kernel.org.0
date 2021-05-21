Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB7F38CC79
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 19:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbhEURpe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 13:45:34 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:45938 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbhEURpc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 13:45:32 -0400
Received: by mail-pf1-f178.google.com with SMTP id d16so15425095pfn.12;
        Fri, 21 May 2021 10:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lcP+zO2F1IGQjzr8jBvO9rG6CcCMMr/Whp/T20TGCRM=;
        b=Bc3IOJsb6hW7LCU1Q2P3RSUaJfScE8RASrZEW3tsmIq9R0cdf4wYkDnBojCmniGGGc
         lZMBmwXGZBiG8YDNK5KbQyZgfpBK0tfC7y5/vNsJq32v4vxnjeM5Bq3a7O30K4mUOu2l
         cnG9ea6S5lLHKifIcSUB4+XJ5GKMAMsDmoZ6XUwpKnYYPM++/HknpJJGBwW0hmp7U7cn
         30jjpC7cYOjWpaP1eAq14iq52fgearQM5pa7F870t8PoSHaoMx8ttREPnY/ELRwGDUtf
         oKenOBp+WP0DNTlb1U3sYa9w25HJ9+3GK0GAW1U0kpAgdWp098kvKzZDuHTyQzBjKlqR
         ETRQ==
X-Gm-Message-State: AOAM531GnK4APq1a32wKtVDfR57xmcFfvFio/TY12QFi8NTWSA8BKosd
        c88tppVkZxKSPoiCm6Arlns=
X-Google-Smtp-Source: ABdhPJx2cr14kVfs56RCS6Lg1N9a0F2CxWXa6sTYNwZ2wWHW3RuCIJw00Zxq6x/ufjwVbJsYm0Ya2A==
X-Received: by 2002:a05:6a00:15d4:b029:2de:a538:c857 with SMTP id o20-20020a056a0015d4b02902dea538c857mr11480779pfu.51.1621619049288;
        Fri, 21 May 2021 10:44:09 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id o3sm4974976pgh.22.2021.05.21.10.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:44:08 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 766BF423A3; Fri, 21 May 2021 17:44:07 +0000 (UTC)
Date:   Fri, 21 May 2021 17:44:07 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
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
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 05/26] block: add blk_alloc_disk and
 blk_cleanup_disk APIs
Message-ID: <20210521174407.GA25291@42.do-not-panic.com>
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521055116.1053587-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 21, 2021 at 07:50:55AM +0200, Christoph Hellwig wrote:
> Add two new APIs to allocate and free a gendisk including the
> request_queue for use with BIO based drivers.  This is to avoid
> boilerplate code in drivers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/genhd.c         | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/genhd.h | 22 ++++++++++++++++++++++
>  2 files changed, 57 insertions(+)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index e4974af3d729..6d4ce962866d 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1302,6 +1302,25 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
>  }
>  EXPORT_SYMBOL(__alloc_disk_node);
>  
> +struct gendisk *__blk_alloc_disk(int node)
> +{
> +	struct request_queue *q;
> +	struct gendisk *disk;
> +
> +	q = blk_alloc_queue(node);
> +	if (!q)
> +		return NULL;
> +
> +	disk = __alloc_disk_node(0, node);
> +	if (!disk) {
> +		blk_cleanup_queue(q);
> +		return NULL;
> +	}
> +	disk->queue = q;
> +	return disk;
> +}
> +EXPORT_SYMBOL(__blk_alloc_disk);

Its not obvious to me why using this new API requires you then to
set minors explicitly to 1, and yet here underneath we see the minors
argument passed is 0.

Nor is it clear from the documentation.

  Luis
