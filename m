Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494E83B18B2
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 13:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhFWLSc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 07:18:32 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:60600 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhFWLSc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 07:18:32 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 251901FD68;
        Wed, 23 Jun 2021 11:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624446974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KV1EpNdhx/wUSqoUCCroMUV3rsSV7q8YaeMu9XhFW1w=;
        b=NZQtUKZmTmrFVEGwfUXSMY9FqUsRi1Jw3xX+9BPq7IJbzySyg0LB+IzRSZ3sXK5JcRvoDl
        kyQehl/IoaXmmx4ocGOYwK3wTBK4xOFOJdyCe9djg4eBMTEDNZH94XYGPW/VZ90G4PN+Oc
        wIImZT1xG5JLuJr9G0yh0KPuOZcdw/M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624446974;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KV1EpNdhx/wUSqoUCCroMUV3rsSV7q8YaeMu9XhFW1w=;
        b=sB5qu1IwbpJhmVRmCUOgbBcUdGkf947ZNqvNFQSWqv3Wl7DLck0vjqV/2wmk3bU+DCOrop
        x5CeeHwJfLYx46Bg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 8E4D711A97;
        Wed, 23 Jun 2021 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624446974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KV1EpNdhx/wUSqoUCCroMUV3rsSV7q8YaeMu9XhFW1w=;
        b=NZQtUKZmTmrFVEGwfUXSMY9FqUsRi1Jw3xX+9BPq7IJbzySyg0LB+IzRSZ3sXK5JcRvoDl
        kyQehl/IoaXmmx4ocGOYwK3wTBK4xOFOJdyCe9djg4eBMTEDNZH94XYGPW/VZ90G4PN+Oc
        wIImZT1xG5JLuJr9G0yh0KPuOZcdw/M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624446974;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KV1EpNdhx/wUSqoUCCroMUV3rsSV7q8YaeMu9XhFW1w=;
        b=sB5qu1IwbpJhmVRmCUOgbBcUdGkf947ZNqvNFQSWqv3Wl7DLck0vjqV/2wmk3bU+DCOrop
        x5CeeHwJfLYx46Bg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id UhdYFvsX02DccwAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 11:16:11 +0000
Subject: Re: Ask help for code review (was Re: [PATCH 03/14] bcache: add
 initial data structures for nvm pages)
From:   Coly Li <colyli@suse.de>
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
Message-ID: <5702503a-56da-b981-90c6-ebd181716901@suse.de>
Date:   Wed, 23 Jun 2021 19:16:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <466c1678-8cdc-7240-1422-b435a599cad3@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/23/21 6:05 PM, Coly Li wrote:
> On 6/23/21 3:21 PM, Christoph Hellwig wrote:
> Does the already mapped DAX base address change in runtime during memory
> hot plugable ?
> If not, it won't be a problem here for this specific use case.
>> It could change between one use and another.
> Hmm, I don't understand the implicit meaning of the above line.
> Could you please offer a detail example ?
>

Hi Christoph,

I feel I come to understand "It could change between
one use and another." Yes, this is a problem for full
pointer design. I will switch to base + offset format.

Thank you for joining the discussion and provide your
comments, to help me have improved understand for better
design :-）

Coly Li
