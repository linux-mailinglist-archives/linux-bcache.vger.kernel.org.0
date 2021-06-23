Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7373B1456
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 09:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFWHG0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 03:06:26 -0400
Received: from verein.lst.de ([213.95.11.211]:49587 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhFWHGZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 03:06:25 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4625367373; Wed, 23 Jun 2021 09:04:05 +0200 (CEST)
Date:   Wed, 23 Jun 2021 09:04:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Huang, Ying" <ying.huang@intel.com>
Cc:     Coly Li <colyli@suse.de>, Dan Williams <dan.j.williams@intel.com>,
        Jan Kara <jack@suse.com>, Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>, axboe@kernel.dk
Subject: Re: Ask help for code review (was Re: [PATCH 03/14] bcache: add
 initial data structures for nvm pages)
Message-ID: <20210623070405.GA537@lst.de>
References: <20210615054921.101421-1-colyli@suse.de> <20210615054921.101421-4-colyli@suse.de> <24ad3795-813c-b50b-e983-56dccef1b0db@suse.de> <875yy6l2a1.fsf@yhuang6-desk2.ccr.corp.intel.com> <b1597c54-16ea-c943-8af7-25c8eab342e9@suse.de> <87czsdhy0u.fsf@yhuang6-desk2.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czsdhy0u.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Storing a pointer on-media is completely broken.  It is not endian
clean, not 32-bit vs 64-bit clean and will lead to problems when addresses
change.  And they will change - maybe not often with DDR-attached
memory, but very certainly with CXL-attached memory that is completely
hot pluggable.
