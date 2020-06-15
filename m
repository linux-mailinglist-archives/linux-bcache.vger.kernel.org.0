Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6622E1F8D8D
	for <lists+linux-bcache@lfdr.de>; Mon, 15 Jun 2020 08:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgFOGMu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 15 Jun 2020 02:12:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:49922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgFOGMu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 15 Jun 2020 02:12:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7AA0AAE65;
        Mon, 15 Jun 2020 06:12:52 +0000 (UTC)
Subject: Re: [PATCH 3/4] bcache: use delayed kworker fo asynchronous devices
 registration
To:     colyli@suse.de, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200614165333.124999-1-colyli@suse.de>
 <20200614165333.124999-4-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9bd21fc5-2666-e239-3da1-dc51c3ca2e49@suse.de>
Date:   Mon, 15 Jun 2020 08:12:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200614165333.124999-4-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/14/20 6:53 PM, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> This patch changes the asynchronous registration kworker to a delayed
> kworker. There is probability queue_work() queues the async registration
> kworker to the same CPU (even though very little), then the process
> which writing sysfs interface to reigster bcache device may won't return
> immeidately. queue_delayed_work() in this patch will delay 10 jiffies
> before insert the kworker to run queue, which makes sure the registering
> process may always returns to user space in time.
> 
> Fixes: 9e23ccf8f0a22 ("bcache: asynchronous devices registration")
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/md/bcache/super.c | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
