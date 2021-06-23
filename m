Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064EA3B1949
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 13:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFWLwR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 07:52:17 -0400
Received: from verein.lst.de ([213.95.11.211]:50452 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230392AbhFWLwP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 07:52:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D4DCB68AFE; Wed, 23 Jun 2021 13:49:54 +0200 (CEST)
Date:   Wed, 23 Jun 2021 13:49:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Huang, Ying" <ying.huang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jan Kara <jack@suse.com>, Hannes Reinecke <hare@suse.com>,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>, axboe@kernel.dk
Subject: Re: Ask help for code review (was Re: [PATCH 03/14] bcache: add
 initial data structures for nvm pages)
Message-ID: <20210623114954.GA20363@lst.de>
References: <20210615054921.101421-1-colyli@suse.de> <20210615054921.101421-4-colyli@suse.de> <24ad3795-813c-b50b-e983-56dccef1b0db@suse.de> <875yy6l2a1.fsf@yhuang6-desk2.ccr.corp.intel.com> <b1597c54-16ea-c943-8af7-25c8eab342e9@suse.de> <87czsdhy0u.fsf@yhuang6-desk2.ccr.corp.intel.com> <20210623070405.GA537@lst.de> <f150a8a6-26ee-8fdd-2964-be1254835bc1@suse.de> <20210623072140.GA837@lst.de> <466c1678-8cdc-7240-1422-b435a599cad3@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466c1678-8cdc-7240-1422-b435a599cad3@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jun 23, 2021 at 06:05:51PM +0800, Coly Li wrote:
> The cache device (typically SSD) of bcache is designed to dedicate to a
> single local machine. Any
> storage migration between machines with different endians should firstly
> flush the dirty data to
> backing hard drive.

Now my G5 died and I need to recover the data using my x86 laptop,
what am I going to do?

> >> If not, it won't be a problem here for this specific use case.
> > It could change between one use and another.
> 
> Hmm, I don't understand the implicit meaning of the above line.
> Could you please offer a detail example ?

There is no guarantee you nvdimm or CXL memory device will show up
at the same address.
