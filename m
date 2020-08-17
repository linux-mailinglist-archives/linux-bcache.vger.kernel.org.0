Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736B1245C6C
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 08:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgHQGZa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 02:25:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:46608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgHQGZ2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 02:25:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E3591AD5F;
        Mon, 17 Aug 2020 06:25:51 +0000 (UTC)
Subject: Re: [PATCH 12/14] bcache: check and set sync status on cache's
 in-memory super block
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-13-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <13de59de-f9c7-10a0-d358-04334522db1e@suse.de>
Date:   Mon, 17 Aug 2020 08:25:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815041043.45116-13-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/15/20 6:10 AM, Coly Li wrote:
> Currently the cache's sync status is checked and set on cache set's in-
> memory partial super block. After removing the embedded struct cache_sb
> from cache set and reference cache's in-memory super block from struct
> cache_set, the sync status can set and check directly on cache's super
> block.
> 
> This patch checks and sets the cache sync status directly on cache's
> in-memory super block. This is a preparation for later removing embedded
> struct cache_sb from struct cache_set.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/alloc.c   | 2 +-
>   drivers/md/bcache/journal.c | 2 +-
>   drivers/md/bcache/super.c   | 7 ++-----
>   drivers/md/bcache/sysfs.c   | 6 +++---
>   4 files changed, 7 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
