Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8553CEE7B
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Apr 2019 03:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbfD3Bin (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Apr 2019 21:38:43 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45106 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfD3Bim (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Apr 2019 21:38:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id o5so5934119pls.12;
        Mon, 29 Apr 2019 18:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZynxS8wT5VQN7Zq/7F3IMTMeMTQDk53jffD4iJ3yhmA=;
        b=gVGyLx2A3iju9B9qEL8zugMCjbJJf/08jaXqerWXIVUH+jhOcnZ/u3HsPt/mf5fmX4
         vMq/HK2Cs8hLMXiKQYjYh/i7u/xy7B++Dy2phG8XziWS+WMEv8lCngHJBYWCLrGCvhnu
         +w3trQUvT+Q6IDYyQWy4/MUqDfXsDN9bzvku/PU33uKBJGZSQDiNqUJyaiYwLMdE/ljh
         cHDsFaIJCNfHcCyIQh/TnVroYYTswHeOeDbHrMZb6hfMduL3w9+2Yi6quToE7GAOMXfd
         UvFybh4IkO3QHg82gqdeSsBu9vTGR5NseIV3776SUZibWF/dGzuP443EqkhHrpa7oVgu
         7/ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZynxS8wT5VQN7Zq/7F3IMTMeMTQDk53jffD4iJ3yhmA=;
        b=A02oRU5gI62h+Ge3O4mjmicSvcW5bSBNS1cb4BAIEMfQcSms3bCmj0gLOy4JGDwwjT
         46uuYEHWRxxG55ljCbEKQ8wq1CYTFf1ToG708C08k03DLyMtMwbZ61q2iHYHHAudk4N3
         6lxB+QQUnLxA09Zlos/Gg/YQ0y2yiP4XSlAR05kH+qOHfLXBGgXFqso2qpODnpuAyb+V
         JqM/kx4/tGq3rxfaupRdwwccPKnMKgVjKxkVwyoAOPDHijscRZEh0yXFSBoa6P8s54Jl
         +XhxJ6ZP8MAgC6uTEnQhT1QAILPsr2zjvvar0DEVR7IIltrnmhVZvpMkAzDFFKCIqWhm
         upTg==
X-Gm-Message-State: APjAAAX2dpGkoW3L6mteuiMjHDTQuANszt+Kw1eqC6igxshcdkKH0BeO
        mDkFN1lsC38rw4xlz3/zNs796Y/l
X-Google-Smtp-Source: APXvYqypSXLKdOc4BifZ0GR3NGO16WadNXoen/Z2Ppfkq0lI+/5mMCeZ7XACQUf7JvIXLciz66RKhg==
X-Received: by 2002:a17:902:2862:: with SMTP id e89mr67760487plb.203.1556588322012;
        Mon, 29 Apr 2019 18:38:42 -0700 (PDT)
Received: from [0.0.0.0] (172.96.249.239.16clouds.com. [172.96.249.239])
        by smtp.gmail.com with ESMTPSA id f66sm2350064pfg.55.2019.04.29.18.38.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 18:38:40 -0700 (PDT)
Subject: Re: [PATCH] bcache: fix memleak when error occurred before journal
 replay
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org
References: <1556541059-21234-1-git-send-email-fangguoju@gmail.com>
From:   guoju fang <fangguoju@gmail.com>
Message-ID: <cae10f04-9a2c-db48-97ad-0cdd7e88a0b8@gmail.com>
Date:   Tue, 30 Apr 2019 09:38:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556541059-21234-1-git-send-email-fangguoju@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Oh, Shenghui submitted a patch to fix this bug days ago, so please 
ignore this.

On 2019/4/29 20:30, Guoju Fang wrote:
> A list of struct journal_replay is allocated when register cache device
> and will be freed when journal replay complete. It will cause memory
> leaks if some error occurred before journal replay.
>
> Signed-off-by: Guoju Fang <fangguoju@gmail.com>
> ---
>   drivers/md/bcache/super.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index a697a3a..e4289291 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1782,6 +1782,7 @@ static void run_cache_set(struct cache_set *c)
>   	struct cache *ca;
>   	struct closure cl;
>   	unsigned int i;
> +	LIST_HEAD(journal);
>   
>   	closure_init_stack(&cl);
>   
> @@ -1790,7 +1791,6 @@ static void run_cache_set(struct cache_set *c)
>   	set_gc_sectors(c);
>   
>   	if (CACHE_SYNC(&c->sb)) {
> -		LIST_HEAD(journal);
>   		struct bkey *k;
>   		struct jset *j;
>   
> @@ -1820,25 +1820,25 @@ static void run_cache_set(struct cache_set *c)
>   
>   		err = "bad btree root";
>   		if (__bch_btree_ptr_invalid(c, k))
> -			goto err;
> +			goto free_journal;
>   
>   		err = "error reading btree root";
>   		c->root = bch_btree_node_get(c, NULL, k,
>   					     j->btree_level,
>   					     true, NULL);
>   		if (IS_ERR_OR_NULL(c->root))
> -			goto err;
> +			goto free_journal;
>   
>   		list_del_init(&c->root->list);
>   		rw_unlock(true, c->root);
>   
>   		err = uuid_read(c, j, &cl);
>   		if (err)
> -			goto err;
> +			goto free_journal;
>   
>   		err = "error in recovery";
>   		if (bch_btree_check(c))
> -			goto err;
> +			goto free_journal;
>   
>   		bch_journal_mark(c, &journal);
>   		bch_initial_gc_finish(c);
> @@ -1854,7 +1854,7 @@ static void run_cache_set(struct cache_set *c)
>   		err = "error starting allocator thread";
>   		for_each_cache(ca, c, i)
>   			if (bch_cache_allocator_start(ca))
> -				goto err;
> +				goto free_journal;
>   
>   		/*
>   		 * First place it's safe to allocate: btree_check() and
> @@ -1938,6 +1938,14 @@ static void run_cache_set(struct cache_set *c)
>   
>   	set_bit(CACHE_SET_RUNNING, &c->flags);
>   	return;
> +
> +free_journal:
> +	while (!list_empty(&journal)) {
> +		struct journal_replay *jr = list_first_entry(&journal,
> +			    struct journal_replay, list);
> +		list_del(&jr->list);
> +		kfree(jr);
> +	}
>   err:
>   	closure_sync(&cl);
>   	/* XXX: test this, it's broken */
