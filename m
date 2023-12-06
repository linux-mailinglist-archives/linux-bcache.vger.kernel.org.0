Return-Path: <linux-bcache+bounces-115-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E830A80682B
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Dec 2023 08:22:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25D501C21151
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Dec 2023 07:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F403016433;
	Wed,  6 Dec 2023 07:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hhRbaenX"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AF69E;
	Tue,  5 Dec 2023 23:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qmCAsGLsB31X5J4lJ2nHtJS8+MwGW1F5WEYO0jIziI0=; b=hhRbaenXZsjRyFtp5oCl7ZLapp
	PGbBHBMazopo9x7zLycOLomgyozjMFDmXz0mBlHcwPG5BI6SfQiEYs2RFIxTkHszoMBIB5fp7RvF5
	vaqpcOeQKcUjsuqauqy5BsIY31xjg/0sVfUccDbi5kKXOZc7fS1d0vbSOWjK1ECcJERDPQIM6Icyq
	pZ82Y80XxVZAy+fiqCF56whvlLXWz/53NURq30p1NEOux+n0cJVqd1itpsG6+3wl1H+zQ95RNHzGZ
	8Wbn2E17f06JWnxiq2s6y4vOb2NT9ha36DJvWW/HkrWz3MeH9YEasxDh/aL/9GmJ56G3rYqKjOoGL
	m/NxJEIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rAmDz-009HyE-2v;
	Wed, 06 Dec 2023 07:21:39 +0000
Date: Tue, 5 Dec 2023 23:21:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
	roger.pau@citrix.com, colyli@suse.de, kent.overstreet@gmail.com,
	joern@lazybastard.org, miquel.raynal@bootlin.com, richard@nod.at,
	vigneshr@ti.com, sth@linux.ibm.com, hoeppner@linux.ibm.com,
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com, clm@fb.com,
	josef@toxicpanda.com, dsterba@suse.com, nico@fluxnic.net,
	xiang@kernel.org, chao@kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, agruenba@redhat.com, jack@suse.com,
	konishi.ryusuke@gmail.com, willy@infradead.org,
	akpm@linux-foundation.org, hare@suse.de, p.raghav@samsung.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nilfs@vger.kernel.org, yi.zhang@huawei.com,
	yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next RFC 02/14] xen/blkback: use bdev api in
 xen_update_blkif_status()
Message-ID: <ZXAhA0WUXoF5YEq4@infradead.org>
References: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
 <20231205123728.1866699-3-yukuai1@huaweicloud.com>
 <ZXAMwBD8pd48qwX/@infradead.org>
 <783b5515-db42-c77f-62ab-050f7cc8ef5e@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <783b5515-db42-c77f-62ab-050f7cc8ef5e@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 06, 2023 at 02:56:05PM +0800, Yu Kuai wrote:
> > > -	invalidate_inode_pages2(
> > > -			blkif->vbd.bdev_handle->bdev->bd_inode->i_mapping);
> > > +	invalidate_bdev(blkif->vbd.bdev_handle->bdev);
> > 
> > blkbak is a bdev exported.   I don't think it should ever call
> > invalidate_inode_pages2, through a wrapper or not.
> 
> I'm not sure about this. I'm not familiar with xen/blkback, but I saw
> that xen-blkback will open a bdev from xen_vbd_create(), hence this
> looks like a dm/md for me, hence it sounds reasonable to sync +
> invalidate the opened bdev while initialization. Please kindly correct
> me if I'm wrong.

I guess we have enough precedence for this, so the switchover here
isn't wrong.  But all this invalidating of the bdev cache seems to
be asking for trouble.


