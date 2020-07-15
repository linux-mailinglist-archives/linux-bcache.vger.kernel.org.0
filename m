Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1802204B7
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 08:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGOGC6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 02:02:58 -0400
Received: from [195.135.220.15] ([195.135.220.15]:42314 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgGOGC6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 02:02:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B8A6AAC61;
        Wed, 15 Jul 2020 06:02:59 +0000 (UTC)
Subject: Re: [PATCH v2 01/17] bcache: add comments to mark member offset of
 struct cache_sb_disk
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715054612.6349-1-colyli@suse.de>
 <20200715054612.6349-2-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <668b8126-6a34-7029-dea4-2ad0ecc3915e@suse.de>
Date:   Wed, 15 Jul 2020 08:02:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715054612.6349-2-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/15/20 7:45 AM, Coly Li wrote:
> This patch adds comments to mark each member of struct cache_sb_disk,
> it is helpful to understand the bcache superblock on-disk layout.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   include/uapi/linux/bcache.h | 39 +++++++++++++++++++------------------
>   1 file changed, 20 insertions(+), 19 deletions(-)
> 
> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
> index 9a1965c6c3d0..afbd1b56a661 100644
> --- a/include/uapi/linux/bcache.h
> +++ b/include/uapi/linux/bcache.h
> @@ -158,33 +158,33 @@ static inline struct bkey *bkey_idx(const struct bkey *k, unsigned int nr_keys)
>   #define BDEV_DATA_START_DEFAULT		16	/* sectors */
>   
>   struct cache_sb_disk {
> -	__le64			csum;
> -	__le64			offset;	/* sector where this sb was written */
> -	__le64			version;
> +/*000*/	__le64			csum;
> +/*008*/	__le64			offset;	/* sector where this sb was written */
> +/*010*/	__le64			version;
>   
> -	__u8			magic[16];
> +/*018*/	__u8			magic[16];
>   
> -	__u8			uuid[16];
> +/*028*/	__u8			uuid[16];
>   	union {
> -		__u8		set_uuid[16];
> +/*038*/		__u8		set_uuid[16];
>   		__le64		set_magic;
>   	};
> -	__u8			label[SB_LABEL_SIZE];
> +/*048*/	__u8			label[SB_LABEL_SIZE];
>   
> -	__le64			flags;
> -	__le64			seq;
> -	__le64			pad[8];
> +/*068*/	__le64			flags;
> +/*070*/	__le64			seq;
> +/*078*/	__le64			pad[8];
>   
>   	union {
>   	struct {
>   		/* Cache devices */
> -		__le64		nbuckets;	/* device size */
> +/*0b8*/		__le64		nbuckets;	/* device size */
>   
> -		__le16		block_size;	/* sectors */
> -		__le16		bucket_size;	/* sectors */
> +/*0c0*/		__le16		block_size;	/* sectors */
> +/*0c2*/		__le16		bucket_size;	/* sectors */
>   
> -		__le16		nr_in_set;
> -		__le16		nr_this_dev;
> +/*0c4*/		__le16		nr_in_set;
> +/*0c6*/		__le16		nr_this_dev;
>   	};
>   	struct {
>   		/* Backing devices */
> @@ -198,14 +198,15 @@ struct cache_sb_disk {
>   	};
>   	};
>   
> -	__le32			last_mount;	/* time overflow in y2106 */
> +/*0c8*/	__le32			last_mount;	/* time overflow in y2106 */
>   
> -	__le16			first_bucket;
> +/*0cc*/	__le16			first_bucket;
>   	union {
> -		__le16		njournal_buckets;
> +/*0ce*/		__le16		njournal_buckets;
>   		__le16		keys;
>   	};
> -	__le64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
> +/*0d0*/	__le64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
> +/*8d0*/
>   };
>   
>   struct cache_sb {
> 
Common practice is to place comments at the end; please don't use the 
start of the line here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
