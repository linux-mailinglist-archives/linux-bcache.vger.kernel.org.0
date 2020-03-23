Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A2918F020
	for <lists+linux-bcache@lfdr.de>; Mon, 23 Mar 2020 08:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgCWHJ2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 23 Mar 2020 03:09:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:55918 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCWHJ2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 Mar 2020 03:09:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0FBA2AD45;
        Mon, 23 Mar 2020 07:09:26 +0000 (UTC)
Subject: Re: [PATCH 7/7] bcache: optimize barrier usage for atomic operations
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>
References: <20200322060305.70637-1-colyli@suse.de>
 <20200322060305.70637-8-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8536b839-252d-8b88-d2fc-d41cfc0a9af3@suse.de>
Date:   Mon, 23 Mar 2020 08:09:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200322060305.70637-8-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/22/20 7:03 AM, Coly Li wrote:
> The idea of this patch is from Davidlohr Bueso, he posts a patch
> for bcache to optimize barrier usage for read-modify-write atomic
> bitops. Indeed such optimization can also apply on other locations
> where smp_mb() is used before or after an atomic operation.
> 
> This patch replaces smp_mb() with smp_mb__before_atomic() or
> smp_mb__after_atomic() in btree.c and writeback.c,  where it is used
> to synchronize memory cache just earlier on other cores. Although
> the locations are not on hot code path, it is always not bad to mkae
> things a little better.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> ---
>   drivers/md/bcache/btree.c     | 6 +++---
>   drivers/md/bcache/writeback.c | 6 +++---
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
