Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA424C81C8
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 04:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiCADzG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Feb 2022 22:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiCADzF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Feb 2022 22:55:05 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5A03BA6E;
        Mon, 28 Feb 2022 19:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646106866; x=1677642866;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VS6fmfe+veXdqFV0QkiV3wt3rSbkw9JdxwIlqxaie1k=;
  b=nGDCaHN/iV9ISvQe8aRKYlP1WuvPCZ0/qvhcz46cbLUstC2vUG1bKwQd
   +zLVTgxbORpe9HGpw4bwv9omxZWJ3y49j2LJ/kt1/3Tx+2q2TA4hYfnhC
   jh/qmDoJdnYqBv8naJW4QGMihUyz8PNPVFeETQhTH5dmFREoHMiWJBgUG
   jsd2cxHpqqn5okeZNyEju8Z/MBz4yZMCIh4cV2ESzFpJBleiVddBEtmkN
   a8H2Df668pU868KOzuuvb5EBoHRqvG0ELdpfw1f1Xe7D27KUUMVobowrF
   /OxwaGzmSohypGtHISkBVM+vWaAbffW+WrA5kfnBRPE4poVtvsjiPyrFA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="251880831"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="251880831"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 19:54:25 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="641118781"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 19:54:24 -0800
Date:   Mon, 28 Feb 2022 19:54:23 -0800
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
Subject: Re: [PATCH 05/10] nvdimm-blk: use bvec_kmap_local in
 nd_blk_rw_integrity
Message-ID: <Yh2Y76PZxSHF1stE@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-6-hch@lst.de>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Feb 22, 2022 at 04:51:51PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/nvdimm/blk.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
> index c1db43524d755..0a38738335941 100644
> --- a/drivers/nvdimm/blk.c
> +++ b/drivers/nvdimm/blk.c
> @@ -88,10 +88,9 @@ static int nd_blk_rw_integrity(struct nd_namespace_blk *nsblk,
>  		 */
>  
>  		cur_len = min(len, bv.bv_len);
> -		iobuf = kmap_atomic(bv.bv_page);
> -		err = ndbr->do_io(ndbr, dev_offset, iobuf + bv.bv_offset,
> -				cur_len, rw);
> -		kunmap_atomic(iobuf);
> +		iobuf = bvec_kmap_local(&bv);
> +		err = ndbr->do_io(ndbr, dev_offset, iobuf, cur_len, rw);
> +		kunmap_local(iobuf);
>  		if (err)
>  			return err;
>  
> -- 
> 2.30.2
> 
> 
