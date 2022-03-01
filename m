Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06504C81E5
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 05:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiCAEHV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Feb 2022 23:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiCAEHU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Feb 2022 23:07:20 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D0C4F9EA;
        Mon, 28 Feb 2022 20:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646107599; x=1677643599;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wwDVriVDm7UgNSs8eXv3lJSf+SyllYz/XxGrm4fiOYw=;
  b=WhGHD2VY9oH1llNS+CjxXTAutJTV4tkac8+nap+yy05hhexRH05oxB4n
   JfN/Q9MmGIrAItVS6pTc36bvuTr2K+KkcF6C2PChYPm9plb0c6XqTQYFN
   GjuVkxuBkAeKLXx4Bb4BIT+C98Hr1emLfTB6jvz8yt2MRXgyr0EuQb5NP
   jLJd3IZ/1h7Im6gaSw+0QwqXvbipVYKA5fB1BZ6sEwVxtGQMoDrWbVg5J
   Dl3Sdu+nF0SMPXwnjYM8jGw2uVjLQ1EAgBXyaR2YI6G3SWi7PYw2Y/ZYw
   KEYhClrqIhMLBVc0nK/cBtP1pPHsfNVsDns3FBTOauhCGxOKL/c7FGhZo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="240462475"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="240462475"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:06:38 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="639228248"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:06:37 -0800
Date:   Mon, 28 Feb 2022 20:06:37 -0800
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
Subject: Re: [PATCH 08/10] drbd: use bvec_kmap_local in drbd_csum_bio
Message-ID: <Yh2bzX6YzzltNLZg@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-9-hch@lst.de>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Feb 22, 2022 at 04:51:54PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/block/drbd/drbd_worker.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
> index a5e04b38006b6..1b48c8172a077 100644
> --- a/drivers/block/drbd/drbd_worker.c
> +++ b/drivers/block/drbd/drbd_worker.c
> @@ -326,9 +326,9 @@ void drbd_csum_bio(struct crypto_shash *tfm, struct bio *bio, void *digest)
>  	bio_for_each_segment(bvec, bio, iter) {
>  		u8 *src;
>  
> -		src = kmap_atomic(bvec.bv_page);
> -		crypto_shash_update(desc, src + bvec.bv_offset, bvec.bv_len);
> -		kunmap_atomic(src);
> +		src = bvec_kmap_local(&bvec);
> +		crypto_shash_update(desc, src, bvec.bv_len);
> +		kunmap_local(src);
>  
>  		/* REQ_OP_WRITE_SAME has only one segment,
>  		 * checksum the payload only once. */
> -- 
> 2.30.2
> 
> 
