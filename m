Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F7C4C81D9
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 05:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbiCAEAm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Feb 2022 23:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiCAEAl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Feb 2022 23:00:41 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5217145064;
        Mon, 28 Feb 2022 20:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646107202; x=1677643202;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LcxwOayz+lKTZD4HcNKclIM15x9RJubsj20BQE2u+gg=;
  b=lhj6atpoCk66NrwZVGj2KbsPqAw/ovXE/E1l8htjrsGuAWH3LEhOxXPG
   4NV2YoZ2TUJBjXfKSusxAFo3MZcYYzLiAD4O2l0NUg0RCYarDxzAdTjfX
   c/vMKCqmn3Y6Bp8ldVasaV3MEwAUP/jSJRnPsixfTs7pqJGTJEaiKHd15
   CR5mqN2hW5cBv1RCA0BETI3OmlZLaENWwSBc4YLUo/8ulp5pqDyksFvHm
   pOxyJy7B4PAXeZhis/EALvz1AbvWyJ+je/PTVrVs+SmZNu1vomjuxywI2
   4U9ZySjiDKrVj39VuSQ6EK8E+vf6OWor2OYE4ugLIFQRr2S9oNJ3TfVk+
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="250631716"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="250631716"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:00:02 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="639226239"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:00:01 -0800
Date:   Mon, 28 Feb 2022 20:00:01 -0800
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
Message-ID: <Yh2aQROdfk1iUuQV@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-8-hch@lst.de>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Feb 22, 2022 at 04:51:53PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/bcache/request.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 6869e010475a3..4e55ca8ca67ff 100644
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
> +		kunmap(d);

kunmap_local()

Ira

>  	}
>  
>  	k->ptr[KEY_PTRS(k)] = csum & (~0ULL >> 1);
> -- 
> 2.30.2
> 
> 
