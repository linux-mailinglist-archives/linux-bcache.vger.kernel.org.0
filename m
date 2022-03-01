Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671054C801F
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 02:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiCABKv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Feb 2022 20:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiCABKu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Feb 2022 20:10:50 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F4CFE8;
        Mon, 28 Feb 2022 17:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646097011; x=1677633011;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HwnaWy+oJRDlGNb4s/iv7PtVKCKNjC5iJpB2XE6LsI0=;
  b=hgU1mKGUxxb8pZD4Jop79ZuBrSz8PQ/M1joJPTBWfrWis6wYtD+BEjXU
   HE5kquJqsq3EscgEKTbz4d7613l6VKuJ1brq/tHzW8VIL5zly3700tuzK
   H2lBAfjWpsbJDMZ/mrOvi++XXA10kkvqzwUka0cR39xzwq0tKM/48lmI9
   Ud2xYrb/vRYLPRV+ujIBEXzVP0LNN+hB9eyYMDv7ZLjc6mpXqoUuKLMxz
   B+k2AyKqQ1qWH+E8yS9uh2G3E3f0FOd+qhrv6SOpYuOkgUr4YvQ8jyFbb
   vhakwKbnf8WAUNX2NPlGQdG39i/pCcsQOd00GHrHHrG2z9o/Ppaz8s+KN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="233646216"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="233646216"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 17:10:10 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="685538225"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 17:10:10 -0800
Date:   Mon, 28 Feb 2022 17:10:09 -0800
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
Subject: Re: [PATCH 03/10] zram: use memcpy_to_bvec in zram_bvec_read
Message-ID: <Yh1ycd3S/FKAtnuD@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-4-hch@lst.de>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Feb 22, 2022 at 04:51:49PM +0100, Christoph Hellwig wrote:
> Use the proper helper instead of open coding the copy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine but I don't see a reason to keep the other operation atomic.  Could
the src map also use kmap_local_page()?

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/block/zram/zram_drv.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index a3a5e1e713268..14becdf2815df 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1331,12 +1331,10 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  		goto out;
>  
>  	if (is_partial_io(bvec)) {
> -		void *dst = kmap_atomic(bvec->bv_page);
>  		void *src = kmap_atomic(page);
>  
> -		memcpy(dst + bvec->bv_offset, src + offset, bvec->bv_len);
> +		memcpy_to_bvec(bvec, src + offset);
>  		kunmap_atomic(src);
> -		kunmap_atomic(dst);
>  	}
>  out:
>  	if (is_partial_io(bvec))
> -- 
> 2.30.2
> 
> 
