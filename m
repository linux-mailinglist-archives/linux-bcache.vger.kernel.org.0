Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52684C8B6C
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 13:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiCAMV1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Mar 2022 07:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiCAMV0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Mar 2022 07:21:26 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EA757170;
        Tue,  1 Mar 2022 04:20:46 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DB11D68BEB; Tue,  1 Mar 2022 13:20:42 +0100 (CET)
Date:   Tue, 1 Mar 2022 13:20:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Chris Zankel <chris@zankel.net>,
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
Subject: Re: [PATCH 06/10] nvdimm-btt: use bvec_kmap_local in
 btt_rw_integrity
Message-ID: <20220301122042.GB3405@lst.de>
References: <20220222155156.597597-1-hch@lst.de> <20220222155156.597597-7-hch@lst.de> <Yh2aCi6gtG0naC1r@iweiny-desk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh2aCi6gtG0naC1r@iweiny-desk3>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Feb 28, 2022 at 07:59:06PM -0800, Ira Weiny wrote:
> On Tue, Feb 22, 2022 at 04:51:52PM +0100, Christoph Hellwig wrote:
> > Using local kmaps slightly reduces the chances to stray writes, and
> > the bvec interface cleans up the code a little bit.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/nvdimm/btt.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > index cbd994f7f1fe6..9613e54c7a675 100644
> > --- a/drivers/nvdimm/btt.c
> > +++ b/drivers/nvdimm/btt.c
> > @@ -1163,17 +1163,15 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
> >  		 */
> >  
> >  		cur_len = min(len, bv.bv_len);
> > -		mem = kmap_atomic(bv.bv_page);
> > +		mem = bvec_kmap_local(&bv);
> >  		if (rw)
> > -			ret = arena_write_bytes(arena, meta_nsoff,
> > -					mem + bv.bv_offset, cur_len,
> > +			ret = arena_write_bytes(arena, meta_nsoff, mem, cur_len,
> 
> Why drop bv.bv_offset here and below?

Because bvec_kmap_local includes bv_offset in the pointer that it
returns.
