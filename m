Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE33238BF36
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 08:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhEUGY3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 02:24:29 -0400
Received: from verein.lst.de ([213.95.11.211]:46545 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhEUGY3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 02:24:29 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C508C6736F; Fri, 21 May 2021 08:23:01 +0200 (CEST)
Date:   Fri, 21 May 2021 08:23:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-m68k@lists.linux-m68k.org,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
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
        Matias Bjorling <mb@lightnvm.io>,
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
        linux-mmc@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 12/26] bcache: convert to
 blk_alloc_disk/blk_cleanup_disk
Message-ID: <20210521062301.GA10244@lst.de>
References: <20210521055116.1053587-1-hch@lst.de> <20210521055116.1053587-13-hch@lst.de> <d4f1c005-2ce0-51b5-c861-431f0ffb3dcf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4f1c005-2ce0-51b5-c861-431f0ffb3dcf@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 21, 2021 at 02:15:32PM +0800, Coly Li wrote:
> The  above 2 lines are added on purpose to prevent an refcount
> underflow. It is from commit 86da9f736740 ("bcache: fix refcount
> underflow in bcache_device_free()").
> 
> Maybe add a parameter to blk_cleanup_disk() or checking (disk->flags &
> GENHD_FL_UP) inside blk_cleanup_disk() ?

Please take a look at patch 4 in the series.
