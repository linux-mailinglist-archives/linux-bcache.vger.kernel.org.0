Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93363B17C2
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 12:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhFWKIQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 06:08:16 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34520 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhFWKIN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 06:08:13 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4488721962;
        Wed, 23 Jun 2021 10:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624442755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i9ZMWxxo7T7ej1+mWoiY5NWenqmHykSoSC/W90+Og2E=;
        b=JYrM73w8wwo2h95MLzn6GQYHSpay/DpBNhNxLLbeJduEVqr7HnxtOEk2IDN3j+2P4GJF+A
        Oc/JQ+S2TtjOs/L11IJbqbRV0gGEWg36bbcbKsQJ+7dYEyAGBPe+a3iKS1viEBIi7/dMRK
        hHL9OrC+zf8Hp2ApX4IyPejRzkIWNww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624442755;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i9ZMWxxo7T7ej1+mWoiY5NWenqmHykSoSC/W90+Og2E=;
        b=KLnvkjGIqrHjuZH3SRnh2qDfqjyDKtDovxVs7jRy1xgzPmlhcaR9sZGKLi6cwsmf5vW/Q5
        byc2aW+MoU7y4rAQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 6EA8A11A97;
        Wed, 23 Jun 2021 10:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624442755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i9ZMWxxo7T7ej1+mWoiY5NWenqmHykSoSC/W90+Og2E=;
        b=JYrM73w8wwo2h95MLzn6GQYHSpay/DpBNhNxLLbeJduEVqr7HnxtOEk2IDN3j+2P4GJF+A
        Oc/JQ+S2TtjOs/L11IJbqbRV0gGEWg36bbcbKsQJ+7dYEyAGBPe+a3iKS1viEBIi7/dMRK
        hHL9OrC+zf8Hp2ApX4IyPejRzkIWNww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624442755;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i9ZMWxxo7T7ej1+mWoiY5NWenqmHykSoSC/W90+Og2E=;
        b=KLnvkjGIqrHjuZH3SRnh2qDfqjyDKtDovxVs7jRy1xgzPmlhcaR9sZGKLi6cwsmf5vW/Q5
        byc2aW+MoU7y4rAQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id yUJiEYEH02CiUQAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 10:05:53 +0000
Subject: Re: Ask help for code review (was Re: [PATCH 03/14] bcache: add
 initial data structures for nvm pages)
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Huang, Ying" <ying.huang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jan Kara <jack@suse.com>, Hannes Reinecke <hare@suse.com>,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>, axboe@kernel.dk
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-4-colyli@suse.de>
 <24ad3795-813c-b50b-e983-56dccef1b0db@suse.de>
 <875yy6l2a1.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <b1597c54-16ea-c943-8af7-25c8eab342e9@suse.de>
 <87czsdhy0u.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <20210623070405.GA537@lst.de> <f150a8a6-26ee-8fdd-2964-be1254835bc1@suse.de>
 <20210623072140.GA837@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <466c1678-8cdc-7240-1422-b435a599cad3@suse.de>
Date:   Wed, 23 Jun 2021 18:05:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210623072140.GA837@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/23/21 3:21 PM, Christoph Hellwig wrote:
> On Wed, Jun 23, 2021 at 03:19:11PM +0800, Coly Li wrote:
>> Bcache does not support endian clean indeed,
> Then we need to fix that eventually rather than making it worse.  Which
> means any _new_ data structure should start that way.

The cache device (typically SSD) of bcache is designed to dedicate to a
single local machine. Any
storage migration between machines with different endians should firstly
flush the dirty data to
backing hard drive. For bcache meta-data on cache device (typically
SSD), it is designed to NOT
move dirty cache between machines with different endians, and in
practice there is no such use
case indeed and not supported by any Linux Distribution.

Not supporting different endian is as design, why we should fix it for
no real use case ?

BTW, the discussion is only for cache device because the bcache meta
data stored on it. For
backing hard drive, its endian is transparent to bcache and decided by
upper layer code like
file system or user space application, it is fully endian clean.


>> and libnvdimm only works with
>> 64bit physical address width.
> Maybe it does right now.  But ther is nothing fundamental in that, so
> please don't design stupid on-disk formats to encode that are going to
> come back to bite us sooner or later.  Be that by adding 32-bit support
> for any Linux DAX device, or by new 96 or 128bit CPUs.

This is unfair restriction :-)
The nvdimm support for bcache heavily depends on libnvdimm, that is, for
all conditions that libnvdimm
supports we should follow up. But requiring us to support the condition
that even libnvdimm does not
support yet, it is too early at this stage.

And, if libnvdimm (not DAX) supports 32-bit or new 96 or 128bit CPUs,
considering the data sturectures
are arrays and single lists,  it won't be too complicated to follow up.

>> The only restriction here by using pointer is
>> the CPU register word should be 64bits, because we use the NVDIMM as memory.
>>
>> Is it one of the way how NVDIMM (especially Intel AEP) designed to use ?
>> As a non-volatiled memory.
> Not for on-disk data structures.

This is not on-disk data structure. We use the NVDIMM as memory, and
access the internal data
structures as current existing code does onto DRAM.

Please encourage us to have a series try with this might-be-different idea.

>> Does the already mapped DAX base address change in runtime during memory
>> hot plugable ?
>> If not, it won't be a problem here for this specific use case.
> It could change between one use and another.

Hmm, I don't understand the implicit meaning of the above line.
Could you please offer a detail example ?


Thank you for looking at this and provide value comment. All the above
response is not argument or
stubbornness, I do want to have a clear understand by the discussion
with you, that we won't regret
in future for current design.

Coly Li
