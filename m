Return-Path: <linux-bcache+bounces-114-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04C2680681F
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Dec 2023 08:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 367121C2113E
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Dec 2023 07:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36FEB16404;
	Wed,  6 Dec 2023 07:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hj7ctWdU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ACF1B6;
	Tue,  5 Dec 2023 23:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3qSq0ZgSYyFQdhkNKKx+ay2VTuWMWagkFjN44scFJGI=; b=Hj7ctWdUPYGChKSXbjiG3ceuLC
	qJJdvlVYftwJ0JmFiiq7KgA3kS4RlnIA/MDhNrvJyEEBExXyzpZoszMTkmDa/0AcbWk3X3RegC55V
	7demvhkD/2Vm6MNZiLt23BUpT9dBqEkmj0CKPAbAJm+oIUuXhDVeLjwJaZkW3WPEmdGuSLkwjyd9+
	YyBHijcvKAnO2bAVJAUvyMRdWxJKRyTYJ1uvpasFg0q82cLUXzhXq4Wu/L7v1jx64IWttFDdMu/ca
	3J1JyfBFyObPGWrCPbNdP80bglMjq75SOxMB3QIX6GX/sagc2ovosgUjghAazuSh7ZC/geNc3PWxS
	jsvebKrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rAmCo-009HjE-0N;
	Wed, 06 Dec 2023 07:20:26 +0000
Date: Tue, 5 Dec 2023 23:20:26 -0800
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
Subject: Re: [PATCH -next RFC 01/14] block: add some bdev apis
Message-ID: <ZXAgut2MTKw50OLI@infradead.org>
References: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
 <20231205123728.1866699-2-yukuai1@huaweicloud.com>
 <ZXARKD0OmjLrvHmU@infradead.org>
 <aafabc6e-fd98-f927-44d7-3ef76e2acaf8@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aafabc6e-fd98-f927-44d7-3ef76e2acaf8@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 06, 2023 at 02:50:56PM +0800, Yu Kuai wrote:
> I'm a litter confused, so there are 3 use cases:
> 1) use GFP_USER, default gfp from bdev_alloc.
> 2) use GFP_KERNEL
> 3) use GFP_NOFS
> 
> I understand that you're suggesting memalloc_nofs_save() to distinguish
> 2 and 3, but how can I distinguish 1?

You shouldn't.  Diverging from the default flags except for clearing
the FS or IO flags is simply a bug.  Note that things like block2mtd
should probably also ensure a noio allocation if they aren't doing that
yet.

> >   - use memalloc_nofs_save in extet instead of using
> >     mapping_gfp_constraint to clear it from the mapping flags
> >   - remove __ext4_sb_bread_gfp and just have buffer.c helper that does
> >     the right thing (either by changing the calling conventions of an
> >     existing one, or adding a new one).
> 
> Thanks for the suggestions, but I'm not sure how to do this yet, I must
> read more ext4 code.

the nofs save part should be trivial.  You can just skip the rest for
now as it's not needed for this patch series.


