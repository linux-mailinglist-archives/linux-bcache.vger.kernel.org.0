Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6DE3B1998
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 14:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhFWMMA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 08:12:00 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39010 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhFWML7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 08:11:59 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BBC201FD36;
        Wed, 23 Jun 2021 12:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624450181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Shj2SE8niP5WvMXjun7ikIAkYYmoq/GAPEpKa0VAbKw=;
        b=V6zOpxwZ3ibpNomE4ANU88oKCgVPTKMgpkOrt/3kF2XYMasevOWE4rl/jqrfrqOem+tNlM
        pIOD97FZ04RURUyFojM60Ljqmt2xhcSNDYYy5ItAHtZwI9VsWOXIsMuWNibiCR/yxW6E4o
        1F4vSu5sUbVf8bBQK9KYlMqzqbarT18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624450181;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Shj2SE8niP5WvMXjun7ikIAkYYmoq/GAPEpKa0VAbKw=;
        b=IFkPNpq/JVrj//USk0ZjtbAYNn/8J5Hfx9xjSwCeWfFtbI9AZf34t+cKRqFZLiqfsJDQcZ
        iV8e1SKZ8bJ9aYAw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 9633911A97;
        Wed, 23 Jun 2021 12:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624450181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Shj2SE8niP5WvMXjun7ikIAkYYmoq/GAPEpKa0VAbKw=;
        b=V6zOpxwZ3ibpNomE4ANU88oKCgVPTKMgpkOrt/3kF2XYMasevOWE4rl/jqrfrqOem+tNlM
        pIOD97FZ04RURUyFojM60Ljqmt2xhcSNDYYy5ItAHtZwI9VsWOXIsMuWNibiCR/yxW6E4o
        1F4vSu5sUbVf8bBQK9KYlMqzqbarT18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624450181;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Shj2SE8niP5WvMXjun7ikIAkYYmoq/GAPEpKa0VAbKw=;
        b=IFkPNpq/JVrj//USk0ZjtbAYNn/8J5Hfx9xjSwCeWfFtbI9AZf34t+cKRqFZLiqfsJDQcZ
        iV8e1SKZ8bJ9aYAw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id IgYZGYMk02AEEwAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 12:09:39 +0000
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
 <20210623072140.GA837@lst.de> <466c1678-8cdc-7240-1422-b435a599cad3@suse.de>
 <20210623114954.GA20363@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <3d84ecc3-4ebf-3ef4-e4e3-df39e661f854@suse.de>
Date:   Wed, 23 Jun 2021 20:09:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210623114954.GA20363@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/23/21 7:49 PM, Christoph Hellwig wrote:
> On Wed, Jun 23, 2021 at 06:05:51PM +0800, Coly Li wrote:
>> The cache device (typically SSD) of bcache is designed to dedicate to a
>> single local machine. Any
>> storage migration between machines with different endians should firstly
>> flush the dirty data to
>> backing hard drive.
> Now my G5 died and I need to recover the data using my x86 laptop,
> what am I going to do?
>
>>>> If not, it won't be a problem here for this specific use case.
>>> It could change between one use and another.
>> Hmm, I don't understand the implicit meaning of the above line.
>> Could you please offer a detail example ?
> There is no guarantee you nvdimm or CXL memory device will show up
> at the same address.

Copied, I fully understand. Now I am working on the full pointer to
[base + offset] convert.

Thanks for your patient explanation :-)

Coly Li
