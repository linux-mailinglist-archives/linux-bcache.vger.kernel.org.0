Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46D34CAB20
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Mar 2022 18:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbiCBRIF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Mar 2022 12:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243646AbiCBRH4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Mar 2022 12:07:56 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031CCCCC67;
        Wed,  2 Mar 2022 09:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646240833; x=1677776833;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZDYri7lCowU3GJr6M0z1hSFUZr0wdNpx1kXCi+W+DLY=;
  b=Os+MBOe+zBd+r0D/K/KAGx+2Dg3b4+APvOdW5x+44PKA066Hr2E36fV4
   qKGhmyXwKkF9fVTuuCfwsIJEBO8Rhg1s9rRGqilmGjrk2CL+kmtuVu5EL
   ElqxFQGKvaCGDrGCSKjyPMyNtZmDORfkWwfw3gfhDyZMZpv8jcS+kKrDh
   Iw6Pyd/COesp2Ho8R23sZBY/TQviaYWA+3Dte6XDihkINI+3F1vQ7a9KF
   24oc+vBk+snZhFKRsQ6h9JZt0klDLnD03znsJPC1+Hq3gfgSyIujRPZOg
   VWnV5ryIc44iioFwrJQv3Ir5qZ0CIiBOBRVZjhjcYNdS7gqmNqyDbNdTU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="253183409"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="253183409"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:04:52 -0800
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="493606916"
Received: from akshatak-mobl.amr.corp.intel.com (HELO localhost) ([10.212.41.96])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:04:51 -0800
Date:   Wed, 2 Mar 2022 09:04:50 -0800
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
Subject: Re: [PATCH 06/10] nvdimm-btt: use bvec_kmap_local in btt_rw_integrity
Message-ID: <Yh+jshFsKMt+iI55@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-7-hch@lst.de>
 <Yh2aCi6gtG0naC1r@iweiny-desk3>
 <20220301122042.GB3405@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301122042.GB3405@lst.de>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Mar 01, 2022 at 01:20:42PM +0100, Christoph Hellwig wrote:
> On Mon, Feb 28, 2022 at 07:59:06PM -0800, Ira Weiny wrote:
> > On Tue, Feb 22, 2022 at 04:51:52PM +0100, Christoph Hellwig wrote:
> > > Using local kmaps slightly reduces the chances to stray writes, and
> > > the bvec interface cleans up the code a little bit.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  drivers/nvdimm/btt.c | 10 ++++------
> > >  1 file changed, 4 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > > index cbd994f7f1fe6..9613e54c7a675 100644
> > > --- a/drivers/nvdimm/btt.c
> > > +++ b/drivers/nvdimm/btt.c
> > > @@ -1163,17 +1163,15 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
> > >  		 */
> > >  
> > >  		cur_len = min(len, bv.bv_len);
> > > -		mem = kmap_atomic(bv.bv_page);
> > > +		mem = bvec_kmap_local(&bv);
> > >  		if (rw)
> > > -			ret = arena_write_bytes(arena, meta_nsoff,
> > > -					mem + bv.bv_offset, cur_len,
> > > +			ret = arena_write_bytes(arena, meta_nsoff, mem, cur_len,
> > 
> > Why drop bv.bv_offset here and below?
> 
> Because bvec_kmap_local includes bv_offset in the pointer that it
> returns.

Ah I missed that.  Thanks,
Ira
