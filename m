Return-Path: <linux-bcache+bounces-59-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 310147F9ADD
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Nov 2023 08:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6238B1C2091F
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Nov 2023 07:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C741078E;
	Mon, 27 Nov 2023 07:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kgGJDb1V"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CFE134
	for <linux-bcache@vger.kernel.org>; Sun, 26 Nov 2023 23:24:18 -0800 (PST)
Date: Mon, 27 Nov 2023 02:24:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701069856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sJC7JnCdDMwVJE2Gwk1C0vFk6Py1BaDljTucatOpxXs=;
	b=kgGJDb1VLCucuD5e2hQjWQ+XC++egZdZLhAJ5iSZ9utvVrf0CyMvQhrYx/JyB6n/L7fH3e
	GiEbFbqY39IEtBXghxm0L08GSy6BnG8399HEFLMWDdDhP3apLoaek5QzUTk74RqX4T/nLt
	6aKmIt20r4fDMRbnYCLJEPsYwvQ8600=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org,
	ming.lei@redhat.com, axboe@kernel.dk, roger.pau@citrix.com,
	colyli@suse.de, kent.overstreet@gmail.com, joern@lazybastard.org,
	miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
	sth@linux.ibm.com, hoeppner@linux.ibm.com, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, clm@fb.com, josef@toxicpanda.com,
	dsterba@suse.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	nico@fluxnic.net, xiang@kernel.org, chao@kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, agruenba@redhat.com, jack@suse.com,
	konishi.ryusuke@gmail.com, dchinner@redhat.com,
	linux@weissschuh.net, min15.li@samsung.com, yukuai3@huawei.com,
	willy@infradead.org, akpm@linux-foundation.org, hare@suse.de,
	p.raghav@samsung.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nilfs@vger.kernel.org, yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH block/for-next v2 07/16] bcachefs: use new helper to get
 inode from block_device
Message-ID: <20231127072409.y22jkynrchm4tkd2@moria.home.lan>
References: <20231127062116.2355129-1-yukuai1@huaweicloud.com>
 <20231127062116.2355129-8-yukuai1@huaweicloud.com>
 <d3b87b87-2ca7-43ca-9fb4-ee3696561eb5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3b87b87-2ca7-43ca-9fb4-ee3696561eb5@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 27, 2023 at 04:09:47PM +0900, Damien Le Moal wrote:
> On 11/27/23 15:21, Yu Kuai wrote:
> > From: Yu Kuai <yukuai3@huawei.com>
> > 
> > Which is more efficiency, and also prepare to remove the field
> > 'bd_inode' from block_device.
> > 
> > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > ---
> >  fs/bcachefs/util.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
> > index 2984b57b2958..fe7ccb3a3517 100644
> > --- a/fs/bcachefs/util.h
> > +++ b/fs/bcachefs/util.h
> > @@ -518,7 +518,7 @@ int bch2_bio_alloc_pages(struct bio *, size_t, gfp_t);
> >  
> >  static inline sector_t bdev_sectors(struct block_device *bdev)
> >  {
> > -	return bdev->bd_inode->i_size >> 9;
> > +	return bdev_inode(bdev)->i_size >> 9;
> 
> shouldn't this use i_size_read() ?
> 
> I missed the history with this but why not use bdev_nr_sectors() and delete this
> helper ?

Actually, this helper seems to be dead code.

