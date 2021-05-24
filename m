Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB8438E18A
	for <lists+linux-bcache@lfdr.de>; Mon, 24 May 2021 09:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhEXH01 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 May 2021 03:26:27 -0400
Received: from verein.lst.de ([213.95.11.211]:53457 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232249AbhEXH01 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 May 2021 03:26:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 08B3867373; Mon, 24 May 2021 09:24:57 +0200 (CEST)
Date:   Mon, 24 May 2021 09:24:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
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
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 06/26] brd: convert to blk_alloc_disk/blk_cleanup_disk
Message-ID: <20210524072456.GD23890@lst.de>
References: <20210521055116.1053587-1-hch@lst.de> <20210521055116.1053587-7-hch@lst.de> <83fc5cdc-53ed-0bd3-fbe8-93d0afd20771@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83fc5cdc-53ed-0bd3-fbe8-93d0afd20771@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sun, May 23, 2021 at 09:58:48AM +0200, Hannes Reinecke wrote:
>> +	/*
>> +	 * This is so fdisk will align partitions on 4k, because of
>> +	 * direct_access API needing 4k alignment, returning a PFN
>> +	 * (This is only a problem on very small devices <= 4M,
>> +	 *  otherwise fdisk will align on 1M. Regardless this call
>> +	 *  is harmless)
>> +	 */
>> +	blk_queue_physical_block_size(disk->queue, PAGE_SIZE);
>>   
>
> Maybe converting the comment to refer to 'PAGE_SIZE' instead of 4k while 
> you're at it ...

I really do not want to touch these kinds of unrelated things here.
