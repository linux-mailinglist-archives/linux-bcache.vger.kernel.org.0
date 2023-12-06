Return-Path: <linux-bcache+bounces-118-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42740807721
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Dec 2023 18:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7B4EB20ECD
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Dec 2023 17:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 117836DD0F;
	Wed,  6 Dec 2023 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jhEd/dyd"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA2FD44;
	Wed,  6 Dec 2023 09:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Snap78XnwhxghrXH/x5DQQflOIE581aXjQMNJjr942g=; b=jhEd/dydrVcA4CqjenXKvBzOhR
	81C86OaTSZvOMqak9GSj26Gk4YbmuiZYqP7Inoay495Qv5aZdhoCk8XtjbZygZ3zFO1MW8qKrFi2H
	jyJUerjxpHvoYivz2Tw0Fom0GZl5ibZD6cI47f6RLNKkoLSSNt8ndPXabCTs9v50CaHUmh6n8EwdV
	h3a11wO9KMQTDIeK5z9Ompws1FrJbStRk/+i8NoSwEjnMVM2d8/eYZK+A65e+FB9FyAW6cFULMbV3
	D4ZCe0VCUv3C54OOIhpqqs0icRWLiCRtInXdBESqtPRpMCqUFSNmSUQ2owjCoBA1ulhjzpRpsIDuc
	qR59KN6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rAw9b-00AzA5-00;
	Wed, 06 Dec 2023 17:57:47 +0000
Date: Wed, 6 Dec 2023 09:57:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>,
	Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk,
	roger.pau@citrix.com, colyli@suse.de, kent.overstreet@gmail.com,
	joern@lazybastard.org, miquel.raynal@bootlin.com, richard@nod.at,
	vigneshr@ti.com, sth@linux.ibm.com, hoeppner@linux.ibm.com,
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com, clm@fb.com,
	josef@toxicpanda.com, dsterba@suse.com, nico@fluxnic.net,
	xiang@kernel.org, chao@kernel.org, adilger.kernel@dilger.ca,
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
Message-ID: <ZXC2Gg7NPWu9MULx@infradead.org>
References: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
 <20231205123728.1866699-2-yukuai1@huaweicloud.com>
 <ZXARKD0OmjLrvHmU@infradead.org>
 <20231206175038.GJ509422@mit.edu>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206175038.GJ509422@mit.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 06, 2023 at 12:50:38PM -0500, Theodore Ts'o wrote:
> This was added because pulling a mounted a USB thumb drive (or a HDD
> drops off the SATA bus) while the file system is mounted and actively
> in use, would result in a kernel OOPS.  If that's no longer true,
> that's great, but it would be good to test to make sure this is the
> case....

And, surprise, surprise - that didn't just affect ext4.  So I ended
up fixing this properly in the block layer.

> If we really want to remove it, I'd suggest doing this as a separate
> commit, so that after we see syzbot reports, or users complaining
> about kernel crashes, we can revert the removal if necessary.

Yes, this should of course be separate, well documented commit.


