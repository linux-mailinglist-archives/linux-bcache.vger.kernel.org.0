Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D33618F016
	for <lists+linux-bcache@lfdr.de>; Mon, 23 Mar 2020 08:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgCWHFa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 23 Mar 2020 03:05:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:53950 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCWHFa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 Mar 2020 03:05:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9E832B15F;
        Mon, 23 Mar 2020 07:05:28 +0000 (UTC)
Subject: Re: [PATCH 1/7] bcache: move macro btree() and btree_root() into
 btree.h
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200322060305.70637-1-colyli@suse.de>
 <20200322060305.70637-2-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <32b1c348-e9fd-1c0d-d0fc-7a6711410106@suse.de>
Date:   Mon, 23 Mar 2020 08:05:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200322060305.70637-2-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/22/20 7:02 AM, Coly Li wrote:
> In order to accelerate bcache registration speed, the macro btree()
> and btree_root() will be referenced out of btree.c. This patch moves
> them from btree.c into btree.h with other relative function declaration
> in btree.h, for the following changes.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/btree.c | 60 +----------------------------------
>   drivers/md/bcache/btree.h | 66 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 67 insertions(+), 59 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
