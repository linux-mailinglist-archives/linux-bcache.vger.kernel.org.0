Return-Path: <linux-bcache+bounces-111-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C31F0806735
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Dec 2023 07:14:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77DD9282BD5
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Dec 2023 06:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2452110A16;
	Wed,  6 Dec 2023 06:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZSLgTwnr"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9D311F;
	Tue,  5 Dec 2023 22:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4/ZwiAtDqcKncE9Sxs1fDYOC2BzoaQU34ADFgY4TSSs=; b=ZSLgTwnreLOPqcun4IeSE9ItZu
	PnTWx9UHdSzDOMw03zhM4iJWbD050LQsUFBy4f4oO/I2CEfLxgu6VKI/48QpINdzGnuBN/4jhcnWn
	T6OU37rwGxHJqPa/Z53FU9Yr3Z/lHh82wcz4yXLaNizP/+ST3MBO3FUnRt49dArLwuH65rXSylY7S
	NM9uVZ0jYQFEdnnGM7iibI2Uo0n82j5ujsUAs74TacZS+egwtqhpWfEnDXYYMvxse9S8X7lLVbUAE
	/Uc2UOgBsAQP0Wf1EQ01B4RrecJ+UvN+DuxFci/PVUUXzcCfKe+xsAO/GPTkS0EmtvxKJn5csRJAc
	38PBAwUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rAlAW-009B0t-1J;
	Wed, 06 Dec 2023 06:14:00 +0000
Date: Tue, 5 Dec 2023 22:14:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, roger.pau@citrix.com, colyli@suse.de,
	kent.overstreet@gmail.com, joern@lazybastard.org,
	miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
	sth@linux.ibm.com, hoeppner@linux.ibm.com, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, clm@fb.com, josef@toxicpanda.com,
	dsterba@suse.com, nico@fluxnic.net, xiang@kernel.org,
	chao@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
	agruenba@redhat.com, jack@suse.com, konishi.ryusuke@gmail.com,
	willy@infradead.org, akpm@linux-foundation.org, hare@suse.de,
	p.raghav@samsung.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org,
	yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH -next RFC 01/14] block: add some bdev apis
Message-ID: <ZXARKD0OmjLrvHmU@infradead.org>
References: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
 <20231205123728.1866699-2-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205123728.1866699-2-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +void invalidate_bdev_range(struct block_device *bdev, pgoff_t start,
> +			   pgoff_t end)
> +{
> +	invalidate_mapping_pages(bdev->bd_inode->i_mapping, start, end);
> +}
> +EXPORT_SYMBOL_GPL(invalidate_bdev_range);

All these could probably use kerneldoc comments.

For this one I really don't like it existing at all, but we'll have to
discuss that in the btrfs patch.

> +loff_t bdev_size(struct block_device *bdev)
> +{
> +	loff_t size;
> +
> +	spin_lock(&bdev->bd_size_lock);
> +	size = i_size_read(bdev->bd_inode);
> +	spin_unlock(&bdev->bd_size_lock);
> +
> +	return size;
> +}
> +EXPORT_SYMBOL_GPL(bdev_size);

No need for this one.  The callers can simply use bdev_nr_bytes.

> +struct folio *bdev_read_folio(struct block_device *bdev, pgoff_t index)
> +{
> +	return read_mapping_folio(bdev->bd_inode->i_mapping, index, NULL);
> +}
> +EXPORT_SYMBOL_GPL(bdev_read_folio);
> +
> +struct folio *bdev_read_folio_gfp(struct block_device *bdev, pgoff_t index,
> +				  gfp_t gfp)
> +{
> +	return mapping_read_folio_gfp(bdev->bd_inode->i_mapping, index, gfp);
> +}
> +EXPORT_SYMBOL_GPL(bdev_read_folio_gfp);

I think we can just drop bdev_read_folio_gfp. Half of the callers simply
pass GPK_KERNEL, and the other half passes GFP_NOFS and could just use
memalloc_nofs_save().

> +void bdev_balance_dirty_pages_ratelimited(struct block_device *bdev)
> +{
> +	return balance_dirty_pages_ratelimited(bdev->bd_inode->i_mapping);
> +}
> +EXPORT_SYMBOL_GPL(bdev_balance_dirty_pages_ratelimited);

Hmm, this is just used for block2mtd, and feels a little too low-level
to me, as block2mtd really should be using the normal fileread/write
APIs.  I guess we'll have to live with it for now if we want to expedite
killing off bd_inode.

> +void bdev_correlate_mapping(struct block_device *bdev,
> +			    struct address_space *mapping)
> +{
> +	mapping->host = bdev->bd_inode;
> +}
> +EXPORT_SYMBOL_GPL(bdev_correlate_mapping);

Maybe associated insted of correlate?  Either way this basically
fully exposes the bdev inode again :(

> +gfp_t bdev_gfp_constraint(struct block_device *bdev, gfp_t gfp)
> +{
> +	return mapping_gfp_constraint(bdev->bd_inode->i_mapping, gfp);
> +}
> +EXPORT_SYMBOL_GPL(bdev_gfp_constraint);

The right fix here is to:

 - use memalloc_nofs_save in extet instead of using
   mapping_gfp_constraint to clear it from the mapping flags
 - remove __ext4_sb_bread_gfp and just have buffer.c helper that does
   the right thing (either by changing the calling conventions of an
   existing one, or adding a new one).

> +/*
> + * The del_gendisk() function uninitializes the disk-specific data
> + * structures, including the bdi structure, without telling anyone
> + * else.  Once this happens, any attempt to call mark_buffer_dirty()
> + * (for example, by ext4_commit_super), will cause a kernel OOPS.
> + * This is a kludge to prevent these oops until we can put in a proper
> + * hook in del_gendisk() to inform the VFS and file system layers.
> + */
> +int bdev_ejected(struct block_device *bdev)
> +{
> +	struct backing_dev_info *bdi = inode_to_bdi(bdev->bd_inode);
> +
> +	return bdi->dev == NULL;
> +}
> +EXPORT_SYMBOL_GPL(bdev_ejected);

And this code in ext4 should just go away entirely.  The bdi should
always be valid for a live bdev for years.

> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1119,6 +1119,7 @@ void bio_add_folio_nofail(struct bio *bio, struct folio *folio, size_t len,
>  	WARN_ON_ONCE(off > UINT_MAX);
>  	__bio_add_page(bio, &folio->page, len, off);
>  }
> +EXPORT_SYMBOL_GPL(bio_add_folio_nofail);

How is this realted?  The export is fine, but really should be a
separate, well-documented commit.

>  
> +static inline u8 block_bits(struct block_device *bdev)
> +{
> +	return bdev->bd_inode->i_blkbits;
> +}

Not sure we should need this.  i_blkbits comes from the blocksize
the fs set, so it should have other ways to get at it.

