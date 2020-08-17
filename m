Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB44245C53
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 08:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgHQGQ6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 02:16:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:44808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHQGQ6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 02:16:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 977D4AD5F;
        Mon, 17 Aug 2020 06:17:21 +0000 (UTC)
Subject: Re: [PATCH 05/14] bcache: only use block_bytes() on struct cache
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-6-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f4663921-d8bc-da07-4f0a-8715014ae17f@suse.de>
Date:   Mon, 17 Aug 2020 08:16:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815041043.45116-6-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/15/20 6:10 AM, Coly Li wrote:
> Because struct cache_set and struct cache both have struct cache_sb,
> therefore macro block_bytes() can be used on both of them. When removing
> the embedded struct cache_sb from struct cache_set, this macro won't be
> used on struct cache_set anymore.
> 
> This patch unifies all block_bytes() usage only on struct cache, this is
> one of the preparation to remove the embedded struct cache_sb from
> struct cache_set.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/bcache.h  |  2 +-
>   drivers/md/bcache/btree.c   | 24 ++++++++++++------------
>   drivers/md/bcache/debug.c   |  8 ++++----
>   drivers/md/bcache/journal.c |  8 ++++----
>   drivers/md/bcache/request.c |  2 +-
>   drivers/md/bcache/super.c   |  2 +-
>   drivers/md/bcache/sysfs.c   |  2 +-
>   7 files changed, 24 insertions(+), 24 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
