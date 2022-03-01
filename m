Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD834C7F42
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 01:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiCAAc2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Feb 2022 19:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiCAAc0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Feb 2022 19:32:26 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DDA69492;
        Mon, 28 Feb 2022 16:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646094706; x=1677630706;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QySiqZr3Aw1s/l/FX4PY4TC5JAQpi05yLKC4BU8F00g=;
  b=WPghUDCTR7EguSCdJpjjFNXosmjahogH+nfeEJ/Tgvj2JEioUxlhnRii
   5k77SB3eX+laXEl3Y3zugZO3sKgI3qKl3B7xGbzjhR0D30E/LIo/MUsL6
   7tus83K1F7ICOgFAVASyQeOS8Zd9IJtVGLqgpZ9gekh+IMSjfR6ma5N0n
   v4uI6qJMNhvNAu2DnK3hAHp93uiMjVOjo0uKQqHEo59OcJAIx8oC0y3Ng
   KOY/iNY1DT3e/6m9kafwUq92vMSCHs3OtyAXgoOyn1iRmJifH5ss3u+OD
   jZn9hqAhBdEpfTbj1VdOxWOufVrAVLvc8yiuKCRDOOGSgDxV/VkVYXDVO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="253213470"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="253213470"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 16:31:46 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="639181195"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 16:31:46 -0800
Date:   Mon, 28 Feb 2022 16:31:46 -0800
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
Subject: Re: [PATCH 02/10] aoe: use bvec_kmap_local in bvcpy
Message-ID: <Yh1pclDpq6iImDAu@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-3-hch@lst.de>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Feb 22, 2022 at 04:51:48PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/aoe/aoecmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index cc11f89a0928f..093996961d452 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -1018,7 +1018,7 @@ bvcpy(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter, long cnt)
>  	iter.bi_size = cnt;
>  
>  	__bio_for_each_segment(bv, bio, iter, iter) {
> -		char *p = kmap_atomic(bv.bv_page) + bv.bv_offset;
> +		char *p = bvec_kmap_local(&bv);
>  		skb_copy_bits(skb, soff, p, bv.bv_len);
>  		kunmap_atomic(p);

kunmap_local()

Ira

>  		soff += bv.bv_len;
> -- 
> 2.30.2
> 
> 
