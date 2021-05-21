Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AFF38CC1E
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 19:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbhEURaJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 13:30:09 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:38852 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbhEURaH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 13:30:07 -0400
Received: by mail-pj1-f42.google.com with SMTP id cu11-20020a17090afa8bb029015d5d5d2175so7702067pjb.3;
        Fri, 21 May 2021 10:28:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B30rffgHFLYBI6xwi77IEdIESyslCgwa8HluqL6arQs=;
        b=L0NrTYnlcCkEPwLVO7XpXe2fuNvYe+6wZqU0WH1niAmzXvB7SYjTxX/78nEHoC54Ss
         OshlcXwbThouovLYulV8jCjvj+VSA96bRHnYbenBeKY2zWtMrCO4INvokcCsvStW/MoL
         D57e+gX1gSzbuv9yzQf5FcAYuHWYrH4qksVQiWcPLAC9Al7sTmxx3Rqcyb4RyKyOkV4H
         C6CPzsSA6MsMfFKBBhBa5bGxdaZcPJIRoMqJ+3MwiaaXxDkIBWf3qyWZL9kqudLm/4FB
         yNKQ7ILFytfzAIAHP/8FR2F7pKfQwoZvdbHC0aKVHxPsCMJMyMOCgrzFFxIRDoRHil60
         CNgA==
X-Gm-Message-State: AOAM532rVI+PkKMdZoECdVco+ipJpmEFeIxlvvbFVl7EyfnaEHO/QJH4
        CWimZGtU0EzVLhsasq7D3aU=
X-Google-Smtp-Source: ABdhPJyrNWjuuiPeUt5pQpc8nPl0WeqbdGuJLCj1G2mOrwbN4glaACuKyX0vSa0sudDl68ZR50luTQ==
X-Received: by 2002:a17:902:e8c8:b029:ee:f249:e416 with SMTP id v8-20020a170902e8c8b02900eef249e416mr13149158plg.3.1621618124047;
        Fri, 21 May 2021 10:28:44 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id p19sm2008772pgi.59.2021.05.21.10.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:28:42 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 77877423A3; Fri, 21 May 2021 17:28:41 +0000 (UTC)
Date:   Fri, 21 May 2021 17:28:41 +0000
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
Subject: Re: [dm-devel] [PATCH 04/26] block: add a flag to make put_disk on
 partially initalized disks safer
Message-ID: <20210521172841.GA25211@42.do-not-panic.com>
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521055116.1053587-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 21, 2021 at 07:50:54AM +0200, Christoph Hellwig wrote:
> Add a flag to indicate that __device_add_disk did grab a queue reference
> so that disk_release only drops it if we actually had it.  This sort
> out one of the major pitfals with partially initialized gendisk that
> a lot of drivers did get wrong or still do.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
