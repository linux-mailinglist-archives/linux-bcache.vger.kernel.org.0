Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755BF245C3E
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 08:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgHQGIx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 02:08:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:42350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgHQGIu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 02:08:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2425BAD7D;
        Mon, 17 Aug 2020 06:09:13 +0000 (UTC)
Subject: Re: [PATCH 01/14] bcache: remove 'int n' from parameter list of
 bch_bucket_alloc_set()
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-2-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <30a805bb-d3d6-3501-0f01-0448849e3560@suse.de>
Date:   Mon, 17 Aug 2020 08:08:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815041043.45116-2-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/15/20 6:10 AM, Coly Li wrote:
> The parameter 'int n' from bch_bucket_alloc_set() is not cleared
> defined. From the code comments n is the number of buckets to alloc, but
> from the code itself 'n' is the maximum cache to iterate. Indeed all the
> locations where bch_bucket_alloc_set() is called, 'n' is alwasy 1.
> 
> This patch removes the confused and unnecessary 'int n' from parameter
> list of  bch_bucket_alloc_set(), and explicitly allocates only 1 bucket
> for its caller.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/alloc.c  | 35 +++++++++++++++--------------------
>   drivers/md/bcache/bcache.h |  4 ++--
>   drivers/md/bcache/btree.c  |  2 +-
>   drivers/md/bcache/super.c  |  2 +-
>   4 files changed, 19 insertions(+), 24 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
