Return-Path: <linux-bcache+bounces-938-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B4EA99515
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Apr 2025 18:29:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B0299A0D59
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Apr 2025 16:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEBC72857DC;
	Wed, 23 Apr 2025 16:07:43 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637C42857C5;
	Wed, 23 Apr 2025 16:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745424463; cv=none; b=cHsuRYZ0A5Za74fmdLpaBQjfrBaojJg0XI9l4yXHZJZoOISlw2QWFLpVVck4j8mrf1onTrmSSv1zQcgMI4eRcYfJSqFXBMkeLMrc5Gty7FS9Nxtn5de//I5Gqw+jRakBtjFVwqv+T7AR3rTRFTgKC5hYJaPcA3zfZzvGAZMYEmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745424463; c=relaxed/simple;
	bh=UCuGDx6I9M/13NqKuR5IYfWmkzxfzhqoFwLaSCBg7uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wqnh/8/EUtTZUGbJTKOCk/G4tSdFc4BNGGKvD1Sq/eXTdZnLuG5ijCGWFGQeIvJJP/fp1KEqE0P7jgyO1jooP1teQosJPCO8Kd9eNwAwYfD62BkVuTlfosWFKiUBX+xjbjjNX1DmWBulwnE40VOFs0H2kXhzu6GsOneq2H2s0cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2017568C7B; Wed, 23 Apr 2025 18:07:34 +0200 (CEST)
Date: Wed, 23 Apr 2025 18:07:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: add more bio helper
Message-ID: <20250423160733.GA656@lst.de>
References: <20250422142628.1553523-1-hch@lst.de> <jetduw7zshrmp4gl7zfpwqjweycwesxiod7xvtnxqwqekgtvdf@idwnvfzvhgik> <20250423093621.GA2578@lst.de> <sl4oibdxpjygqfpy6llq237zuckz7ym4fmzcfvxn2raofr37a5@hvevbcgm5trn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sl4oibdxpjygqfpy6llq237zuckz7ym4fmzcfvxn2raofr37a5@hvevbcgm5trn>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 23, 2025 at 06:37:41AM -0400, Kent Overstreet wrote:
> > It also don't support bio chaining or error handling and requires a
> > single bio that is guaranteed to fit the required number of vectors.
> 
> Why would bio chaining ever be required? The caller allocates both the
> buf and the bio, I've never seen an instance where you'd want that; just
> allocate a bio with the correct number of vecs, which your
> bio_vmalloc_max_vecs() helps with.

If you go beyond 1MB I/O for vmalloc you need it because a single
bio can't hold enough page size chunks.  That is unless you want
to use your own allocation for it and call bio_init which has various
other downsides.

> The "abstract over vmalloc and normal physically contigious allocations"
> bit that bch2_bio_map() does is the important part.
> 
> It's not uncommon to prefer physically contiguous allocations but have a
> vmalloc fallback; bcachefs does, and  xfs does with a clever "try the
> big allocation if it's cheap, fall back to vmalloc to avoid waiting on
> compaction" that I might steal.
> 
> is_vmalloc_addr() is also cheap, it's just a pointer comparison (and it
> really should be changed to a static inline).

The problem with transparent vmalloc handling is that it's not possible.
The magic handling for virtually indexed caches can be hidden on the
submission side, but the completion side also needs to call
invalidate_kernel_vmap_range for reads.  Requiring the caller to know
they deal vmalloc is a way to at least keep that on the radar.

The other benefit is that by forcing different calls it is much
easier to pick the optimal number of bvecs (1) for the non-vmalloc
path, although that is of course also possible without it.

Not for a purely synchronous helper we could handle both, but so far
I've not seen anything but the xfs log recovery code that needs it,
and we'd probably get into needing to pass a bio_set to avoid
deadlock when used deeper in the stack, etc.  I can look into that
if we have more than a single user, but for now it doesn't seem
worth it.

Having a common helper for vmalloc and the kernel direct mapping
is actually how I started, but then I ran into all the issues with
it and with the extremely simple helpers for the direct mapping
which are used a lot, and the more complicated version for vmalloc
which just has a few users instead.

