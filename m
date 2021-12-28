Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBEB480688
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Dec 2021 06:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhL1F3L (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Dec 2021 00:29:11 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:56250 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhL1F3L (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Dec 2021 00:29:11 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2B1B1210FD;
        Tue, 28 Dec 2021 05:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640669350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6S2yrWbvy/nRqKTrNOOhDjrGztb6Txz3eUA7btuxJaQ=;
        b=sGzbtzD3vBDjTI5Kmigf0igEVOb1I+nLIlh3q6BnKu4B6LMCyuzhdSSOWrNJxoTdqOXnwl
        5PQVy4o6IGpmq5Gx7y0A/nfTZ274/PRhP6ht42Dq8dm04hHYJWh2QFs/rwIERpkzFq+zyS
        km+es72QCYpn6UinOu00xJ3e0ax91zY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640669350;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6S2yrWbvy/nRqKTrNOOhDjrGztb6Txz3eUA7btuxJaQ=;
        b=vdo4TNlcKugIY/BilEU5J9qOvzYt9ACqjnk6lWcug7RyUvf5D30ExMztUqmTTEjOoLawxy
        Bf8NY/i3MqOK3SBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3948E13A6D;
        Tue, 28 Dec 2021 05:29:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cdNjA6SgymHUFwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 28 Dec 2021 05:29:08 +0000
Message-ID: <92e33b43-db93-f941-3100-e833d949e8a9@suse.de>
Date:   Tue, 28 Dec 2021 13:29:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v13 00/12] bcache for 5.17: enable NVDIMM for bcache
 journal
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Ying Huang <ying.huang@intel.com>
References: <20211212170552.2812-1-colyli@suse.de>
 <5b08ac62-78c8-4b5a-eb8e-16739e8daa05@kernel.dk>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <5b08ac62-78c8-4b5a-eb8e-16739e8daa05@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/13/21 4:20 AM, Jens Axboe wrote:
> On 12/12/21 10:05 AM, Coly Li wrote:
>> Hi Jens,
>>
>> This is the v12 effort the enabling NVDIMM for bcache journal, the code
>> is under testing for months and quite stable now. Please consider to
>> take them for Linux v5.17 merge window.
> As I've mentioned before, this really needs some thorough review from
> people not associated with the project. I spent a bit of time on the
> first section of the patches, and it doesn't look ready to me.

Copied. Considering the following part of the whole work is on the way, 
I will not submit the journaling part again.

The following plan is to finish the whole work and ask more people to 
review the whole patch set. And on the same time, we will look for some 
real workload for further testing and result estimate.

It would take several merge windows before next submission to you. Thank 
you for the time to looking into them and providing constructive 
suggestions.

Coly Li


