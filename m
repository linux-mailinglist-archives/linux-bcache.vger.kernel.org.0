Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286A038E17F
	for <lists+linux-bcache@lfdr.de>; Mon, 24 May 2021 09:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhEXHZq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 May 2021 03:25:46 -0400
Received: from verein.lst.de ([213.95.11.211]:53432 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232128AbhEXHZq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 May 2021 03:25:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BD6A867373; Mon, 24 May 2021 09:24:13 +0200 (CEST)
Date:   Mon, 24 May 2021 09:24:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
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
Message-ID: <20210524072413.GC23890@lst.de>
References: <20210521055116.1053587-1-hch@lst.de> <20210521055116.1053587-6-hch@lst.de> <20210521174407.GA25291@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521174407.GA25291@42.do-not-panic.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 21, 2021 at 05:44:07PM +0000, Luis Chamberlain wrote:
> Its not obvious to me why using this new API requires you then to
> set minors explicitly to 1, and yet here underneath we see the minors
> argument passed is 0.
> 
> Nor is it clear from the documentation.

Basically for all new drivers no one should set minors at all, and the
dynamic dev_t mechanism does all the work.  For converted old drivers
minors is set manually instead of being passed an an argument that
should be 0 for all new drivers.
