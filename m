Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E629345F93
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Mar 2021 14:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhCWNYm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Mar 2021 09:24:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:38870 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhCWNYL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Mar 2021 09:24:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 67C58ACBF;
        Tue, 23 Mar 2021 13:24:10 +0000 (UTC)
Subject: Re: [bch-nvm-pages v7 0/6] nvm page allocator for bcache
To:     Qiaowei Ren <qiaowei.ren@intel.com>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org
References: <20210317151029.40735-1-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <f26156bb-6911-eb62-a2f7-68fa970c61e2@suse.de>
Date:   Tue, 23 Mar 2021 21:24:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317151029.40735-1-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/17/21 11:10 PM, Qiaowei Ren wrote:
> This series implements nvm pages allocator for bcache. This idea is from
> one discussion about nvdimm use case in kernel together with Coly. Coly
> sent the following email about this idea to give some introduction on what
> we will do before:
> 
> https://lore.kernel.org/linux-bcache/bc7e71ec-97eb-b226-d4fc-d8b64c1ef41a@suse.de/
> 
> Here this series focus on the first step in above email, that is to say,
> this patch set implements a generic framework in bcache to allocate/release
> NV-memory pages, and provide allocated pages for each requestor after reboot.
> In order to do this, one simple buddy system is implemented to manage NV-memory
> pages.
> 
> This set includes one testing module which can be used for simple test cases.
> Next need to stroe bcache log or internal btree nodes into nvdimm based on
> these buddy apis to do more testing.
> 
> 
> Coly Li (1):
>   bcache: add initial data structures for nvm pages
> 
> Jianpeng Ma (5):
>   bcache: initialize the nvm pages allocator
>   bcache: initialization of the buddy
>   bcache: bch_nvm_alloc_pages() of the buddy
>   bcache: bch_nvm_free_pages() of the buddy
>   bcache: get allocated pages from specific owner
> 
>  drivers/md/bcache/Kconfig       |   6 +
>  drivers/md/bcache/Makefile      |   2 +-
>  drivers/md/bcache/nvm-pages.c   | 737 ++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h   |  91 ++++
>  drivers/md/bcache/super.c       |   3 +
>  include/uapi/linux/bcache-nvm.h | 196 +++++++++
>  6 files changed, 1034 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/md/bcache/nvm-pages.c
>  create mode 100644 drivers/md/bcache/nvm-pages.h
>  create mode 100644 include/uapi/linux/bcache-nvm.h
> 

Hi Qiaowei and Jianpeng,

Thanks for the improved version. Now I start to work on the integration
and testing, and the on-nvdimm data structure will change a little by
the feed back from Jens.

I will update later for the result or issue during my testing.

Coly Li
