Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF4F36482D
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Apr 2021 18:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhDSQ1V (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Apr 2021 12:27:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:47156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhDSQ1U (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Apr 2021 12:27:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C4DD3AF11;
        Mon, 19 Apr 2021 16:26:49 +0000 (UTC)
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <20210419202309.0575ad77@canb.auug.org.au>
 <66d41349-60ba-f27f-5c56-3520a40dd83f@infradead.org>
From:   Coly Li <colyli@suse.de>
Subject: Re: linux-next: Tree for Apr 19 (bcache)
Message-ID: <f4ca485d-614b-6924-63bc-0948d087bdc3@suse.de>
Date:   Tue, 20 Apr 2021 00:26:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <66d41349-60ba-f27f-5c56-3520a40dd83f@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/19/21 11:40 PM, Randy Dunlap wrote:
> On 4/19/21 3:23 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20210416:
>>
> 
> on x86_64:
> 
> when
> # CONFIG_BLK_DEV is not set
> 
> 
> WARNING: unmet direct dependencies detected for LIBNVDIMM
>   Depends on [n]: PHYS_ADDR_T_64BIT [=y] && HAS_IOMEM [=y] && BLK_DEV [=n]
>   Selected by [y]:
>   - BCACHE_NVM_PAGES [=y] && MD [=y] && BCACHE [=y] && PHYS_ADDR_T_64BIT [=y]
> 
> 
> Full randconfig file is attached.
> 

I need hint from kbuild expert.

My original idea to use "select LIBNVDIMM" is to avoid the
BCACHE_NVM_PAGES option to disappear if LIBNVDIMM is not enabled.
Otherwise if nvdimm driver is not configure, users won't know there is a
BCACHE_NVM_PAGES option unless they read bcache Kconfig file.

But I see nvdimm's Kconfig, it uses "depends on BLK_DEV", I understand
it is acceptable that LIBNVDIMM option to disappear from "make
menuconfig" if BLK_DEV is not enabled.

For such condition, which one is the proper way to set the dependence ?
- Change "select LIBNVDIMM" and "select DAX" to "depends on LIBNVDIMM"
and "depends on DAX" in bcache Kconfig
- Or change "depends on BLK_DEV" to "select BLK_DEV" in nvdimm Kconfig.


I want to ask for a proper way to handle such dependence, and I will
follow the guide for now and in future.

Thanks in advance for the advice.

Coly Li
