Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521DA38D981
	for <lists+linux-bcache@lfdr.de>; Sun, 23 May 2021 09:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhEWHrc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 23 May 2021 03:47:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:40030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231591AbhEWHrb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 23 May 2021 03:47:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621755963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qgeGl97uX/ASq/b1LiyPvGm5KNHhtUs0K8R0hHcKHNc=;
        b=loXc3McbnIlaTeOmap5xh/BtT1gA18JtYlPnnRT16wqHGfTJ19lzfYOvtfB0oOgoXJJBVk
        /ReVtyQfx/H7rkQyR4p+DdQCpRAZIyorp+zG3qS0QxK3kt3astNHDmaxUpril0ODq2rDNt
        r9Vkt/28bb7h7z+3O1fywe0kQCnoBFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621755963;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qgeGl97uX/ASq/b1LiyPvGm5KNHhtUs0K8R0hHcKHNc=;
        b=ColirDJTDltQ04gjJ+NwT5obDqeCRv1j+ud81TmJU8SNYoFAHUoSAb2/6qAn8/xG4ncH3n
        i/HOh7UwzHlRZeDg==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AF152AB5F;
        Sun, 23 May 2021 07:46:03 +0000 (UTC)
Subject: Re: [PATCH 01/26] block: refactor device number setup in
 __device_add_disk
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
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
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-2-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d55cba32-b114-513b-09d9-40c289fa95c3@suse.de>
Date:   Sun, 23 May 2021 09:46:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/21/21 7:50 AM, Christoph Hellwig wrote:
> Untangle the mess around blk_alloc_devt by moving the check for
> the used allocation scheme into the callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk.h             |  4 +-
>   block/genhd.c           | 96 ++++++++++++++++-------------------------
>   block/partitions/core.c | 15 +++++--
>   3 files changed, 49 insertions(+), 66 deletions(-)
> 
... and also fixes an issue with GENHD_FL_UP remained set in an error 
path in __device_add_disk().

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
