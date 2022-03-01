Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E204D4C81F2
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 05:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiCAEKo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Feb 2022 23:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiCAEKl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Feb 2022 23:10:41 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAD8583AF;
        Mon, 28 Feb 2022 20:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646107801; x=1677643801;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R1uMAEtzeBJ62IRlIzYoDZhF0ZqNu5JCt6nzrNsVez8=;
  b=W0tOGKB7lql+qrr9xX5QY1aM5SxF7JpmCVfT7x1InFeXcXzTxWtAyGK6
   LNNYpeD1xP3pm4PFPZpPU9E9LJci8Why5/lHyTfoC7yyeTuHz2pEP0luS
   mOMK9tBuE9yVK6B2JMVJVWH8zi1QTpmVkguOOZIWw8zE9tFotpEfShqyC
   nbpSRQSGft1aMGdwoZ3sL+1zZWxJnTeIBtZmw0Fk/ZYL64o7jICJbwJCA
   vvgzHpItDWePQOecSAO/jv4rKVxkeOxI1dgLI7sXwjWb4Tz94f+yu7QM5
   XdwnHIRVUdB7UvzI1S4mCdkyqkA61IYZamrjgFr+Vn8w/jTN/cq5SyWq8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="233020484"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="233020484"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:09:59 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="804056797"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:09:59 -0800
Date:   Mon, 28 Feb 2022 20:09:58 -0800
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
Subject: Re: [PATCH 09/10] drbd: use bvec_kmap_local in recv_dless_read
Message-ID: <Yh2clo6ATYC/e8Jm@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-10-hch@lst.de>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Feb 22, 2022 at 04:51:55PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/block/drbd/drbd_receiver.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
> index 04e3ec12d8b49..fa00cf2ea9529 100644
> --- a/drivers/block/drbd/drbd_receiver.c
> +++ b/drivers/block/drbd/drbd_receiver.c
> @@ -2017,10 +2017,10 @@ static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_req
>  	D_ASSERT(peer_device->device, sector == bio->bi_iter.bi_sector);
>  
>  	bio_for_each_segment(bvec, bio, iter) {
> -		void *mapped = kmap(bvec.bv_page) + bvec.bv_offset;
> +		void *mapped = bvec_kmap_local(&bvec);
>  		expect = min_t(int, data_size, bvec.bv_len);
>  		err = drbd_recv_all_warn(peer_device->connection, mapped, expect);
> -		kunmap(bvec.bv_page);
> +		kunmap_local(mapped);
>  		if (err)
>  			return err;
>  		data_size -= expect;
> -- 
> 2.30.2
> 
> 
