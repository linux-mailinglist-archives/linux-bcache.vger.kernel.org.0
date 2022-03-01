Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C564C7F30
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 01:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiCAAbQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Feb 2022 19:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCAAbQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Feb 2022 19:31:16 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E8E764C;
        Mon, 28 Feb 2022 16:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646094636; x=1677630636;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iQYOoTv3Io78EdoGSCPEiJBASaZqMAGkeBkPnB8tiBw=;
  b=bJGXHJgllAyPfas0F8VKyN2QA+dO5VUNWMgpG44IXfA8o11cFwoS11Nk
   oZluO1LnS39E9dzU8EgiHyzVaY+4gm9srTJw5MFm7eH3Td6NlgLKOJskg
   k0eQpFEllCu2mRKlaqvf6qkggM6AgcGC4t7E80OT08ubydXws7GbQfrHV
   ZfYtWZ3DEqRTFafulHtAL8GMctGlrGz5gUVYOLNWwnT3LrCu1Z1ZErjJf
   /eVnPqMDH/y5Pp+Lj7YKNMwRRgxC6YxheeHUI5aHayFKfJx96f8PRiaBI
   59NbbgXYDSzPqHRbGZk/FnS8hOCTiTnKQf+6XRgjnK7d7Bsx45w53YIqh
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="232991456"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="232991456"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 16:30:36 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="803674992"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 16:30:35 -0800
Date:   Mon, 28 Feb 2022 16:30:35 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Justin Sanders <justin@coraid.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Denis Efremov <efremov@linux.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        nvdimm@lists.linux.dev
Subject: Re: [PATCH 01/10] iss-simdisk: use bvec_kmap_local in
 simdisk_submit_bio
Message-ID: <Yh1pKyX8z6R1l7mf@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-2-hch@lst.de>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Feb 22, 2022 at 04:51:47PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  arch/xtensa/platforms/iss/simdisk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
> index 8eb6ad1a3a1de..0f0e0724397f4 100644
> --- a/arch/xtensa/platforms/iss/simdisk.c
> +++ b/arch/xtensa/platforms/iss/simdisk.c
> @@ -108,13 +108,13 @@ static void simdisk_submit_bio(struct bio *bio)
>  	sector_t sector = bio->bi_iter.bi_sector;
>  
>  	bio_for_each_segment(bvec, bio, iter) {
> -		char *buffer = kmap_atomic(bvec.bv_page) + bvec.bv_offset;
> +		char *buffer = bvec_kmap_local(&bvec);
>  		unsigned len = bvec.bv_len >> SECTOR_SHIFT;
>  
>  		simdisk_transfer(dev, sector, len, buffer,
>  				bio_data_dir(bio) == WRITE);
>  		sector += len;
> -		kunmap_atomic(buffer);
> +		kunmap_local(buffer);
>  	}
>  
>  	bio_endio(bio);
> -- 
> 2.30.2
> 
> 
