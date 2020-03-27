Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8437F19562D
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 12:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgC0LVf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 07:21:35 -0400
Received: from verein.lst.de ([213.95.11.211]:50874 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgC0LVf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 07:21:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 00E7668C65; Fri, 27 Mar 2020 12:21:31 +0100 (CET)
Date:   Fri, 27 Mar 2020 12:21:31 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 4/5] block: simplify queue allocation
Message-ID: <20200327112131.GA1096@lst.de>
References: <20200327083012.1618778-1-hch@lst.de> <20200327083012.1618778-5-hch@lst.de> <SN4PR0401MB3598BF20E4DCF8F1B129625E9BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB3598BF20E4DCF8F1B129625E9BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Mar 27, 2020 at 10:11:08AM +0000, Johannes Thumshirn wrote:
> On 27/03/2020 09:34, Christoph Hellwig wrote:
> > -struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
> > -{
> > -	return blk_alloc_queue_node(gfp_mask, NUMA_NO_NODE);
> > -}
> > -EXPORT_SYMBOL(blk_alloc_queue);
> 
> Why are you removing the non _node() variant? The memory allocation 
> function for instance have this indirection as well and I don't think it 
> simplifies a lot passing NUMA_NO_NODE in each block driver.

Because the two variants are rather pointless.  And this might get
more people to actually pass a useful node ID instead of copy and
pasting some old example code.
