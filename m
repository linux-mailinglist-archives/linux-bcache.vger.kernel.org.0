Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A0C4CCC14
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Mar 2022 04:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbiCDDHT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Mar 2022 22:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiCDDHS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Mar 2022 22:07:18 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182CE2B242;
        Thu,  3 Mar 2022 19:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646363192; x=1677899192;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lc9qHdOlafcJNOz8evKbREjH7xRoVMfzT76IGNVrBPY=;
  b=bC0mTAmoSWJLOdpVHSWoMRSpb+0tUBSAA/3vN7QTQB/X+2eTc1f8AGnX
   CPpgO+PNRn1I+U0KJcF+rXhqdsSvkFEjPaAChjrG8aTVDCPPDN7kV+SB5
   AclEYC0gBGHaOyo3rY2yNq18rXDvb9Gev7mxFMwxLxya4NfRV9pRLLS2p
   0iH10t8pBDMbl0MQ1X0XLygoEsGf+daxJp+sDxsF+tLnN+VbJ+0iuv9hy
   Is60QymJYf76gBLiQ0h5FNgrgZrZthMbJtpdYRbijzxjNN1dTLH8xWAHO
   lEkBeqBGn4hHUiRSWZ/u2FN3zwV+HTRIESNN1d6wKnbRehgYt4shJg3zV
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="252707150"
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="252707150"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 19:06:12 -0800
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="546100598"
Received: from harikara-mobl.amr.corp.intel.com (HELO localhost) ([10.212.33.238])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 19:06:11 -0800
Date:   Thu, 3 Mar 2022 19:06:11 -0800
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
Subject: Re: [PATCH 07/10] bcache: use bvec_kmap_local in bio_csum
Message-ID: <YiGCIzAwEO+o9pEj@iweiny-desk3>
References: <20220303111905.321089-1-hch@lst.de>
 <20220303111905.321089-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303111905.321089-8-hch@lst.de>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Mar 03, 2022 at 02:19:02PM +0300, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/md/bcache/request.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 6869e010475a3..fdd0194f84dd0 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -44,10 +44,10 @@ static void bio_csum(struct bio *bio, struct bkey *k)
>  	uint64_t csum = 0;
>  
>  	bio_for_each_segment(bv, bio, iter) {
> -		void *d = kmap(bv.bv_page) + bv.bv_offset;
> +		void *d = bvec_kmap_local(&bv);
>  
>  		csum = crc64_be(csum, d, bv.bv_len);
> -		kunmap(bv.bv_page);
> +		kunmap_local(d);
>  	}
>  
>  	k->ptr[KEY_PTRS(k)] = csum & (~0ULL >> 1);
> -- 
> 2.30.2
> 
