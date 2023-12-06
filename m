Return-Path: <linux-bcache+bounces-112-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8177E8067BF
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Dec 2023 07:51:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DD841F21572
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Dec 2023 06:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52CD012B6A;
	Wed,  6 Dec 2023 06:51:09 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D7C1B5;
	Tue,  5 Dec 2023 22:51:03 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4SlSjG1jDFz4f3jRC;
	Wed,  6 Dec 2023 14:50:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 64F101A09DB;
	Wed,  6 Dec 2023 14:51:00 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgA3iA7QGXBlJV2DCw--.10265S3;
	Wed, 06 Dec 2023 14:50:59 +0800 (CST)
Subject: Re: [PATCH -next RFC 01/14] block: add some bdev apis
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, roger.pau@citrix.com, colyli@suse.de,
 kent.overstreet@gmail.com, joern@lazybastard.org, miquel.raynal@bootlin.com,
 richard@nod.at, vigneshr@ti.com, sth@linux.ibm.com, hoeppner@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 jejb@linux.ibm.com, martin.petersen@oracle.com, clm@fb.com,
 josef@toxicpanda.com, dsterba@suse.com, nico@fluxnic.net, xiang@kernel.org,
 chao@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 agruenba@redhat.com, jack@suse.com, konishi.ryusuke@gmail.com,
 willy@infradead.org, akpm@linux-foundation.org, hare@suse.de,
 p.raghav@samsung.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
 gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
 <20231205123728.1866699-2-yukuai1@huaweicloud.com>
 <ZXARKD0OmjLrvHmU@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <aafabc6e-fd98-f927-44d7-3ef76e2acaf8@huaweicloud.com>
Date: Wed, 6 Dec 2023 14:50:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZXARKD0OmjLrvHmU@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3iA7QGXBlJV2DCw--.10265S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCw4kZFWUAFyktr1fCw45KFg_yoW7Gr47pr
	yUKFy5trWDJryI9rs2qw4UAw1Iqw1ftF4xZr93A3sxA390krn2kF48Kay5Cayxtw4vkF4q
	vF4jvrW3Zr1j9rJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9I14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Wrv_Gr1UMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_
	WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjfUojjgUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2023/12/06 14:14, Christoph Hellwig Ð´µÀ:
>> +void invalidate_bdev_range(struct block_device *bdev, pgoff_t start,
>> +			   pgoff_t end)
>> +{
>> +	invalidate_mapping_pages(bdev->bd_inode->i_mapping, start, end);
>> +}
>> +EXPORT_SYMBOL_GPL(invalidate_bdev_range);
> 
> All these could probably use kerneldoc comments.

Ok, and thanks for reviewing the patchset!
> 
> For this one I really don't like it existing at all, but we'll have to
> discuss that in the btrfs patch.
> 
>> +loff_t bdev_size(struct block_device *bdev)
>> +{
>> +	loff_t size;
>> +
>> +	spin_lock(&bdev->bd_size_lock);
>> +	size = i_size_read(bdev->bd_inode);
>> +	spin_unlock(&bdev->bd_size_lock);
>> +
>> +	return size;
>> +}
>> +EXPORT_SYMBOL_GPL(bdev_size);
> 
> No need for this one.  The callers can simply use bdev_nr_bytes.

Ok, I'll replace it with bdev_nr_bytes.
> 
>> +struct folio *bdev_read_folio(struct block_device *bdev, pgoff_t index)
>> +{
>> +	return read_mapping_folio(bdev->bd_inode->i_mapping, index, NULL);
>> +}
>> +EXPORT_SYMBOL_GPL(bdev_read_folio);
>> +
>> +struct folio *bdev_read_folio_gfp(struct block_device *bdev, pgoff_t index,
>> +				  gfp_t gfp)
>> +{
>> +	return mapping_read_folio_gfp(bdev->bd_inode->i_mapping, index, gfp);
>> +}
>> +EXPORT_SYMBOL_GPL(bdev_read_folio_gfp);
> 
> I think we can just drop bdev_read_folio_gfp. Half of the callers simply
> pass GPK_KERNEL, and the other half passes GFP_NOFS and could just use
> memalloc_nofs_save().

I'm a litter confused, so there are 3 use cases:
1) use GFP_USER, default gfp from bdev_alloc.
2) use GFP_KERNEL
3) use GFP_NOFS

I understand that you're suggesting memalloc_nofs_save() to distinguish
2 and 3, but how can I distinguish 1?
> 
>> +void bdev_balance_dirty_pages_ratelimited(struct block_device *bdev)
>> +{
>> +	return balance_dirty_pages_ratelimited(bdev->bd_inode->i_mapping);
>> +}
>> +EXPORT_SYMBOL_GPL(bdev_balance_dirty_pages_ratelimited);
> 
> Hmm, this is just used for block2mtd, and feels a little too low-level
> to me, as block2mtd really should be using the normal fileread/write
> APIs.  I guess we'll have to live with it for now if we want to expedite
> killing off bd_inode.
> 
>> +void bdev_correlate_mapping(struct block_device *bdev,
>> +			    struct address_space *mapping)
>> +{
>> +	mapping->host = bdev->bd_inode;
>> +}
>> +EXPORT_SYMBOL_GPL(bdev_correlate_mapping);
> 
> Maybe associated insted of correlate?  Either way this basically
> fully exposes the bdev inode again :(
> 
>> +gfp_t bdev_gfp_constraint(struct block_device *bdev, gfp_t gfp)
>> +{
>> +	return mapping_gfp_constraint(bdev->bd_inode->i_mapping, gfp);
>> +}
>> +EXPORT_SYMBOL_GPL(bdev_gfp_constraint);
> 
> The right fix here is to:
> 
>   - use memalloc_nofs_save in extet instead of using
>     mapping_gfp_constraint to clear it from the mapping flags
>   - remove __ext4_sb_bread_gfp and just have buffer.c helper that does
>     the right thing (either by changing the calling conventions of an
>     existing one, or adding a new one).

Thanks for the suggestions, but I'm not sure how to do this yet, I must
read more ext4 code.
> 
>> +/*
>> + * The del_gendisk() function uninitializes the disk-specific data
>> + * structures, including the bdi structure, without telling anyone
>> + * else.  Once this happens, any attempt to call mark_buffer_dirty()
>> + * (for example, by ext4_commit_super), will cause a kernel OOPS.
>> + * This is a kludge to prevent these oops until we can put in a proper
>> + * hook in del_gendisk() to inform the VFS and file system layers.
>> + */
>> +int bdev_ejected(struct block_device *bdev)
>> +{
>> +	struct backing_dev_info *bdi = inode_to_bdi(bdev->bd_inode);
>> +
>> +	return bdi->dev == NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(bdev_ejected);
> 
> And this code in ext4 should just go away entirely.  The bdi should
> always be valid for a live bdev for years.
Sounds good, I was confused about this code as well.

> 
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -1119,6 +1119,7 @@ void bio_add_folio_nofail(struct bio *bio, struct folio *folio, size_t len,
>>   	WARN_ON_ONCE(off > UINT_MAX);
>>   	__bio_add_page(bio, &folio->page, len, off);
>>   }
>> +EXPORT_SYMBOL_GPL(bio_add_folio_nofail);
> 
> How is this realted?  The export is fine, but really should be a
> separate, well-documented commit.

This is used to replace __bio_add_page() in btrfs while converting page
to folio, please let me know if I should keep this, if so, I'll split
this into a new commit.
> 
>>   
>> +static inline u8 block_bits(struct block_device *bdev)
>> +{
>> +	return bdev->bd_inode->i_blkbits;
>> +}
> 
> Not sure we should need this.  i_blkbits comes from the blocksize
> the fs set, so it should have other ways to get at it.

Yes, this is now only used for erofs, and erofs do call
sb_set_blocksize() while initializing, hence it's right there is other
way to get blkbits and this helper is not needed.

Thanks,
Kuai

> .
> 


