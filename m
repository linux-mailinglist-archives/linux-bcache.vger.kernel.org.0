Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236FC3B6661
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Jun 2021 18:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhF1QHk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Jun 2021 12:07:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39474 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbhF1QHj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Jun 2021 12:07:39 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 13A35202DC;
        Mon, 28 Jun 2021 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624896313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbRxgVxV6TYzorHgSBImWxbNn2ZvSThvDNVw1mLNnYk=;
        b=IwRbmUsp4T2bhw1GFGOkIf4Xze94zjzOqJMfLtsrKa1is8tpW3HIVKxm/SO3GXebmD5ZNn
        15nmzdGPpL0vaPGVLZMZ+t1jHZFScY5BUoZ0RWVq6VtT2r1tJZ4TUqzSlWWDNhU/8nnzuh
        ZuXcisWw4X00JS0wvfKndhNVzM0Omfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624896313;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbRxgVxV6TYzorHgSBImWxbNn2ZvSThvDNVw1mLNnYk=;
        b=rnLZis4H1mf9BW4cssTegaeOyb1L7CSl0f1Zik3dkAaAy6j9E/CFYOkW57ZECiuScYwkpm
        FVtWMkto2YtBmrCA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id C845F11906;
        Mon, 28 Jun 2021 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624896313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbRxgVxV6TYzorHgSBImWxbNn2ZvSThvDNVw1mLNnYk=;
        b=IwRbmUsp4T2bhw1GFGOkIf4Xze94zjzOqJMfLtsrKa1is8tpW3HIVKxm/SO3GXebmD5ZNn
        15nmzdGPpL0vaPGVLZMZ+t1jHZFScY5BUoZ0RWVq6VtT2r1tJZ4TUqzSlWWDNhU/8nnzuh
        ZuXcisWw4X00JS0wvfKndhNVzM0Omfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624896313;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbRxgVxV6TYzorHgSBImWxbNn2ZvSThvDNVw1mLNnYk=;
        b=rnLZis4H1mf9BW4cssTegaeOyb1L7CSl0f1Zik3dkAaAy6j9E/CFYOkW57ZECiuScYwkpm
        FVtWMkto2YtBmrCA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id lxGcIjfz2WB/QQAALh3uQQ
        (envelope-from <colyli@suse.de>); Mon, 28 Jun 2021 16:05:11 +0000
Subject: Re: [PATCH] bcache: fix cache miss's issue
To:     Qiang Bai <chiang.bai@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20210627071817.24296-1-chiang.bai@gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <b7be3c15-aae6-3952-26bc-1ee35e661327@suse.de>
Date:   Tue, 29 Jun 2021 00:05:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210627071817.24296-1-chiang.bai@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/27/21 3:18 PM, Qiang Bai wrote:
> when cache miss's IO was done, it needs to continue the left part of IO,
> not return -EINTR. -EINTR will stop the whole btree recurse.
>
> Signed-off-by: Qiang Bai <chiang.bai@gmail.com>

NACK.  The commit log should explain how the fixing issue happens in
detail, and why your method fixes it.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/request.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 29c231758293..b6ff101d2611 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -914,7 +914,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
>  	miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
>  
>  	/* btree_search_recurse()'s btree iterator is no good anymore */
> -	ret = miss == bio ? MAP_DONE : -EINTR;
> +	ret = miss == bio ? MAP_DONE : MAP_CONTINUE;
>  
>  	cache_bio = bio_alloc_bioset(GFP_NOWAIT,
>  			DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS),

