Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A2D35E389
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Apr 2021 18:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhDMQMw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 13 Apr 2021 12:12:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:60990 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhDMQMw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Apr 2021 12:12:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BDC0FB1C5;
        Tue, 13 Apr 2021 16:12:31 +0000 (UTC)
Subject: Re: [bch-nvm-pages v8 0/6] nvm page allocator for bcache
To:     Qiaowei Ren <qiaowei.ren@intel.com>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org
References: <20210413140549.224482-1-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <8692a0d3-8d37-16d7-343e-0234747102ce@suse.de>
Date:   Wed, 14 Apr 2021 00:12:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210413140549.224482-1-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Qiaowei and Jianpeng,

The v8 series looks fine, now they are under pressure testing. Once they
survive tomorrow, I will submit them with the 2nd wave patches.

Thanks for the effort.

Coly Li

On 4/13/21 10:05 PM, Qiaowei Ren wrote:
> From: Jianpeng Ma <jianpeng.ma@intel.com>
> 
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
>  drivers/md/bcache/Kconfig       |   9 +
>  drivers/md/bcache/Makefile      |   2 +-
>  drivers/md/bcache/nvm-pages.c   | 747 ++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h   |  93 ++++
>  drivers/md/bcache/super.c       |   3 +
>  include/uapi/linux/bcache-nvm.h | 208 +++++++++
>  6 files changed, 1061 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/md/bcache/nvm-pages.c
>  create mode 100644 drivers/md/bcache/nvm-pages.h
>  create mode 100644 include/uapi/linux/bcache-nvm.h
> 

