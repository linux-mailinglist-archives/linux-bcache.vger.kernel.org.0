Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BB23B1483
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 09:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFWHYA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 03:24:00 -0400
Received: from verein.lst.de ([213.95.11.211]:49632 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWHX7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 03:23:59 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 409B567373; Wed, 23 Jun 2021 09:21:40 +0200 (CEST)
Date:   Wed, 23 Jun 2021 09:21:40 +0200
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
Message-ID: <20210623072140.GA837@lst.de>
References: <20210615054921.101421-1-colyli@suse.de> <20210615054921.101421-4-colyli@suse.de> <24ad3795-813c-b50b-e983-56dccef1b0db@suse.de> <875yy6l2a1.fsf@yhuang6-desk2.ccr.corp.intel.com> <b1597c54-16ea-c943-8af7-25c8eab342e9@suse.de> <87czsdhy0u.fsf@yhuang6-desk2.ccr.corp.intel.com> <20210623070405.GA537@lst.de> <f150a8a6-26ee-8fdd-2964-be1254835bc1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f150a8a6-26ee-8fdd-2964-be1254835bc1@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jun 23, 2021 at 03:19:11PM +0800, Coly Li wrote:
> Bcache does not support endian clean indeed,

Then we need to fix that eventually rather than making it worse.  Which
means any _new_ data structure should start that way.

> and libnvdimm only works with
> 64bit physical address width.

Maybe it does right now.  But ther is nothing fundamental in that, so
please don't design stupid on-disk formats to encode that are going to
come back to bite us sooner or later.  Be that by adding 32-bit support
for any Linux DAX device, or by new 96 or 128bit CPUs.

> The only restriction here by using pointer is
> the CPU register word should be 64bits, because we use the NVDIMM as memory.
> 
> Is it one of the way how NVDIMM (especially Intel AEP) designed to use ?
> As a non-volatiled memory.

Not for on-disk data structures.

> Does the already mapped DAX base address change in runtime during memory
> hot plugable ?
> If not, it won't be a problem here for this specific use case.

It could change between one use and another.
