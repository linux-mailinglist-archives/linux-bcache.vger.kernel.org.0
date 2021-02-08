Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319753133B4
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Feb 2021 14:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhBHNuq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Feb 2021 08:50:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:51434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230310AbhBHNun (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Feb 2021 08:50:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 686FEACF4;
        Mon,  8 Feb 2021 13:50:01 +0000 (UTC)
To:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>
Cc:     linux-bcache@vger.kernel.org
References: <20210208142621.76815-1-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v6 0/7] nvm page allocator for bcache
Message-ID: <0c4ba429-9697-be06-e5a4-4bd3a07c6275@suse.de>
Date:   Mon, 8 Feb 2021 21:49:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210208142621.76815-1-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/8/21 10:26 PM, Qiaowei Ren wrote:
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
> Qiaowei Ren (7):
>   bcache: add initial data structures for nvm pages
>   bcache: initialize the nvm pages allocator
>   bcache: initialization of the buddy
>   bcache: bch_nvm_alloc_pages() of the buddy
>   bcache: bch_nvm_free_pages() of the buddy
>   bcache: get allocated pages from specific owner
>   bcache: persist owner info when alloc/free pages.

I test the V6 patch set, it works with current bcache part change. Sorry
for not response for the previous series in time on list, but thank you
all to fix the known issues in previous version.

Although the series is still marked as RFC patches, but IMHO they are in
good shape for an EXPERIMENTAL series.

I will have them with my other bcache changes in the v5.12 for-next, and
it is so far so good in my smoking testing.

There is one thing I feel should be clarified from you, I see some
patches the author and the first signed-off-by person is not identical.
Please make the first SOB people to be the same one in the From/Author
field. And I guess maybe most of the work are done by both of you, if
this is true, the second author can use a Co-authored-by: tag after the
first Signed-off-by: person.

The v6 series is under testing now, so it is unnecessary to post one
more version for the above changes. I'd like to change them from my side
if you may provide me some hints.

Thanks for the contribution, the tiny NVDIMM pages allcoator works.

Coly Li
