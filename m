Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7F6245C5D
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 08:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgHQGSd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 02:18:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:45334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHQGSc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 02:18:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D9DE7AD5F;
        Mon, 17 Aug 2020 06:18:55 +0000 (UTC)
Subject: Re: [PATCH 07/14] bcache: remove useless bucket_pages()
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-8-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <5a6bb59f-7ca8-36c9-3065-59f361fc265a@suse.de>
Date:   Mon, 17 Aug 2020 08:18:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815041043.45116-8-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/15/20 6:10 AM, Coly Li wrote:
> It seems alloc_bucket_pages() is the only user of bucket_pages().
> Considering alloc_bucket_pages() is removed from bcache code, it is safe
> to remove the useless macro bucket_pages() now.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/bcache.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 29bec61cafbb..48a2585b6bbb 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -757,7 +757,6 @@ struct bbio {
>   #define btree_default_blocks(c)						\
>   	((unsigned int) ((PAGE_SECTORS * (c)->btree_pages) >> (c)->block_bits))
>   
> -#define bucket_pages(c)		((c)->sb.bucket_size / PAGE_SECTORS)
>   #define bucket_bytes(c)		((c)->sb.bucket_size << 9)
>   #define block_bytes(ca)		((ca)->sb.block_size << 9)
>   
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
