Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B6E3B16F8
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 11:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhFWJhH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 05:37:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:53420 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbhFWJhH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 05:37:07 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 184201FD36;
        Wed, 23 Jun 2021 09:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624440889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aDB1VzxYNeOQVS/1gju0LRGDKZBzWjfV0Mikq78NpCA=;
        b=omz3WDuHza3+QZFKptDCZV0iPM6+dJtEudid3y9bHyMvbgxxNApQNAY2T7GoHeg1ELt/ln
        GU3zaxUpSFy6iSlUh82axxocActf4iRJR6tuzG7PKezsKAsGde7DSwOVNQOWELFlxouTLT
        h68CYXaMMMBfjrS1R3v/EyX3oFgHNkc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624440889;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aDB1VzxYNeOQVS/1gju0LRGDKZBzWjfV0Mikq78NpCA=;
        b=din9qPqR5/pSJSRuurJr2e3Io2lKw75DWhZEwDLV0uDkmdtVBtrultcjuiUArH+jVhZ428
        42Cstx1XuZC1l0Dw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id A0CD311A97;
        Wed, 23 Jun 2021 09:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624440889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aDB1VzxYNeOQVS/1gju0LRGDKZBzWjfV0Mikq78NpCA=;
        b=omz3WDuHza3+QZFKptDCZV0iPM6+dJtEudid3y9bHyMvbgxxNApQNAY2T7GoHeg1ELt/ln
        GU3zaxUpSFy6iSlUh82axxocActf4iRJR6tuzG7PKezsKAsGde7DSwOVNQOWELFlxouTLT
        h68CYXaMMMBfjrS1R3v/EyX3oFgHNkc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624440889;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aDB1VzxYNeOQVS/1gju0LRGDKZBzWjfV0Mikq78NpCA=;
        b=din9qPqR5/pSJSRuurJr2e3Io2lKw75DWhZEwDLV0uDkmdtVBtrultcjuiUArH+jVhZ428
        42Cstx1XuZC1l0Dw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id tTAQHTcA02AlQgAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 09:34:47 +0000
Subject: Re: [PATCH 04/14] bcache: initialize the nvm pages allocator
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-bcache@vger.kernel.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-5-colyli@suse.de>
 <39c118e3-ddc9-f417-a929-fc21e761a4ac@suse.de>
 <fc5b8586-0181-da7b-ba1f-73f7b00b8d16@suse.de>
 <48cab671-d4d6-d5f2-29bf-b2f19e04e533@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <5d418422-641d-0d76-3eb3-570e3706b88c@suse.de>
Date:   Wed, 23 Jun 2021 17:34:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <48cab671-d4d6-d5f2-29bf-b2f19e04e533@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/23/21 5:16 PM, Hannes Reinecke wrote:
> On 6/23/21 7:26 AM, Coly Li wrote:
>> On 6/22/21 6:39 PM, Hannes Reinecke wrote:
>>> On 6/15/21 7:49 AM, Coly Li wrote:
>>>> From: Jianpeng Ma <jianpeng.ma@intel.com>
>>>>
>>>> This patch define the prototype data structures in memory and
>>>> initializes the nvm pages allocator.
>>>>
>>>> The nvm address space which is managed by this allocator can
>>>> consist of
>>>> many nvm namespaces, and some namespaces can compose into one nvm set,
>>>> like cache set. For this initial implementation, only one set can be
>>>> supported.
>>>>
>>>> The users of this nvm pages allocator need to call
>>>> register_namespace()
>>>> to register the nvdimm device (like /dev/pmemX) into this allocator as
>>>> the instance of struct nvm_namespace.
>>>>
>>>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>>>> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
>>>> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
>>>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>>>> Signed-off-by: Coly Li <colyli@suse.de>
>>>> ---
>>>>   drivers/md/bcache/Kconfig     |  10 ++
>>>>   drivers/md/bcache/Makefile    |   1 +
>>>>   drivers/md/bcache/nvm-pages.c | 295
>>>> ++++++++++++++++++++++++++++++++++
>>>>   drivers/md/bcache/nvm-pages.h |  74 +++++++++
>>>>   drivers/md/bcache/super.c     |   3 +
>>>>   5 files changed, 383 insertions(+)
>>>>   create mode 100644 drivers/md/bcache/nvm-pages.c
>>>>   create mode 100644 drivers/md/bcache/nvm-pages.h
>>>>
>>>> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
>>>> index d1ca4d059c20..a69f6c0e0507 100644
>>>> --- a/drivers/md/bcache/Kconfig
>>>> +++ b/drivers/md/bcache/Kconfig
>>>> @@ -35,3 +35,13 @@ config BCACHE_ASYNC_REGISTRATION
>>>>       device path into this file will returns immediately and the real
>>>>       registration work is handled in kernel work queue in
>>>> asynchronous
>>>>       way.
>>>> +
>>>> +config BCACHE_NVM_PAGES
>>>> +    bool "NVDIMM support for bcache (EXPERIMENTAL)"
>>>> +    depends on BCACHE
>>>> +    depends on 64BIT
>>>> +    depends on LIBNVDIMM
>>>> +    depends on DAX
>>>> +    help
>>>> +      Allocate/release NV-memory pages for bcache and provide
>>>> allocated pages
>>>> +      for each requestor after system reboot.
>>>> diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
>>>> index 5b87e59676b8..2397bb7c7ffd 100644
>>>> --- a/drivers/md/bcache/Makefile
>>>> +++ b/drivers/md/bcache/Makefile
>>>> @@ -5,3 +5,4 @@ obj-$(CONFIG_BCACHE)    += bcache.o
>>>>   bcache-y        := alloc.o bset.o btree.o closure.o debug.o
>>>> extents.o\
>>>>       io.o journal.o movinggc.o request.o stats.o super.o sysfs.o
>>>> trace.o\
>>>>       util.o writeback.o features.o
>>>> +bcache-$(CONFIG_BCACHE_NVM_PAGES) += nvm-pages.o
>>>> diff --git a/drivers/md/bcache/nvm-pages.c
>>>> b/drivers/md/bcache/nvm-pages.c
>>>> new file mode 100644
>>>> index 000000000000..18fdadbc502f
>>>> --- /dev/null
>>>> +++ b/drivers/md/bcache/nvm-pages.c
>>>> @@ -0,0 +1,295 @@
>>>> +// SPDX-License-Identifier: GPL-2.0-only
>>>> +/*
>>>> + * Nvdimm page-buddy allocator
>>>> + *
>>>> + * Copyright (c) 2021, Intel Corporation.
>>>> + * Copyright (c) 2021, Qiaowei Ren <qiaowei.ren@intel.com>.
>>>> + * Copyright (c) 2021, Jianpeng Ma <jianpeng.ma@intel.com>.
>>>> + */
>>>> +
>>>> +#if defined(CONFIG_BCACHE_NVM_PAGES)
>>>> +
>>> No need for this 'if' statement as it'll be excluded by the Makefile
>>> anyway if the config option isn't set.
>>
>> Such if is necessary because stub routines are defined when
>> CONFIG_BCACHE_NVM_PAGES is not defined, e.g.
>>
>> 426 +#else
>> 427 +
>> 428 +static inline struct bch_nvm_namespace
>> *bch_register_namespace(const char *dev_path)
>> 429 +{
>> 430 +       return NULL;
>> 431 +}
>> 432 +static inline int bch_nvm_init(void)
>> 433 +{
>> 434 +       return 0;
>> 435 +}
>> 436 +static inline void bch_nvm_exit(void) { }
>> 437 +
>> 438 +#endif /* CONFIG_BCACHE_NVM_PAGES */
>>
> But then these stubs should be defined in the header file, not here.
>
> [ .. ]

Copied, it will be improved in next post. Thanks for your review and
comment.

Coly Li

