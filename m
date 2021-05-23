Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8210E38DA33
	for <lists+linux-bcache@lfdr.de>; Sun, 23 May 2021 10:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhEWIWh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 23 May 2021 04:22:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:50984 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhEWIWg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 23 May 2021 04:22:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621758069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnrJQhy+MYhzXLtIe6jAiCOIQfeS3nQ27RRrzMM7c4w=;
        b=oiQsaLP2aD8LiVuUxIt/eALuF2yltrcClEFcmMQDBYnGl/zW6akill6n+VOZeCO0vsqmVR
        tFmM2Hvjyk9E0xM6c06JxQ2VB4oxaLWJUc3LAzfeXgnsky9rD4djo1o+QLKWbjqM0cOyHn
        ZVmwDCT2IFzqxHY6cgoDJRbGvkLjJUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621758069;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnrJQhy+MYhzXLtIe6jAiCOIQfeS3nQ27RRrzMM7c4w=;
        b=6IbKh5gBam4ts1rG2btRELfs7eM0Jl1uklNvIMyXUd4F3+4YBMyInbMp6ogttdCwWnX/aI
        sasQptSJEFfzcoCA==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 257BEABB1;
        Sun, 23 May 2021 08:21:09 +0000 (UTC)
Subject: Re: [PATCH 19/26] nfblock: convert to blk_alloc_disk/blk_cleanup_disk
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jim Paris <jim@jtan.com>,
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
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-20-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b62c7915-9989-0755-866b-0d871c113261@suse.de>
Date:   Sun, 23 May 2021 10:21:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-20-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/21/21 7:51 AM, Christoph Hellwig wrote:
> Convert the nfblock driver to use the blk_alloc_disk and blk_cleanup_disk
> helpers to simplify gendisk and request_queue allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   arch/m68k/emu/nfblock.c | 20 +++++---------------
>   1 file changed, 5 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
