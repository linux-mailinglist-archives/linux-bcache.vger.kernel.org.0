Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9453B13B4
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 08:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFWGKi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 02:10:38 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43018 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWGKi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 02:10:38 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 514252195A;
        Wed, 23 Jun 2021 06:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624428500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJpyVZdke16d/9FOBE6NzBiyoDDJPlNtlwfP3Kla7Ys=;
        b=J5xDNd9Hhjt2M2kWVTTHKj8oPRAQH2d4eQ0zmpkiFOUNMmIbK38kLx0z+n0ZwSObb8s01n
        vtqxbQlVFdzjhk7yjRvnUydPgXoPntVUm/BVYdbGkPcE5tmoSwbombKhIkXp/Uk8AuOmo3
        s9p/PXWW8LJAPZranDh52EREXHQE/XY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624428500;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJpyVZdke16d/9FOBE6NzBiyoDDJPlNtlwfP3Kla7Ys=;
        b=ZNv+ixAcCywad4AfqjRKK7Xq7G3u1sIQCMmFGj2v0O5R1b9aIni+dMR0CBqbn0Oip96Z/t
        Wu7/OOdkSwLXHcAw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id E7FA311A97;
        Wed, 23 Jun 2021 06:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624428500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJpyVZdke16d/9FOBE6NzBiyoDDJPlNtlwfP3Kla7Ys=;
        b=J5xDNd9Hhjt2M2kWVTTHKj8oPRAQH2d4eQ0zmpkiFOUNMmIbK38kLx0z+n0ZwSObb8s01n
        vtqxbQlVFdzjhk7yjRvnUydPgXoPntVUm/BVYdbGkPcE5tmoSwbombKhIkXp/Uk8AuOmo3
        s9p/PXWW8LJAPZranDh52EREXHQE/XY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624428500;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJpyVZdke16d/9FOBE6NzBiyoDDJPlNtlwfP3Kla7Ys=;
        b=ZNv+ixAcCywad4AfqjRKK7Xq7G3u1sIQCMmFGj2v0O5R1b9aIni+dMR0CBqbn0Oip96Z/t
        Wu7/OOdkSwLXHcAw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id doE3L9LP0mA8XgAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 06:08:18 +0000
Subject: Re: [PATCH 08/14] bcache: get allocated pages from specific owner
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-bcache@vger.kernel.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-9-colyli@suse.de>
 <42724b1b-8b6d-8118-84c6-ec76f3f78e19@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <0be3f724-2419-89f6-73a7-6269d495d4e1@suse.de>
Date:   Wed, 23 Jun 2021 14:08:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <42724b1b-8b6d-8118-84c6-ec76f3f78e19@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/22/21 6:54 PM, Hannes Reinecke wrote:
> On 6/15/21 7:49 AM, Coly Li wrote:
>> From: Jianpeng Ma <jianpeng.ma@intel.com>
>>
>> This patch implements bch_get_allocated_pages() of the buddy to be used to
> buddy allocator
>

Copied. Will be updated in next post.

>> get allocated pages from specific owner.
>>
>> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
>> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  drivers/md/bcache/nvm-pages.c | 6 ++++++
>>  drivers/md/bcache/nvm-pages.h | 5 +++++
>>  2 files changed, 11 insertions(+)
>>
>> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
>> index 74d08950c67c..42b0504d9564 100644
>> --- a/drivers/md/bcache/nvm-pages.c
>> +++ b/drivers/md/bcache/nvm-pages.c
>> @@ -397,6 +397,12 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
>>  }
>>  EXPORT_SYMBOL_GPL(bch_nvm_alloc_pages);
>>  
>> +struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
>> +{
>> +	return find_owner_head(owner_uuid, false);
>> +}
>> +EXPORT_SYMBOL_GPL(bch_get_allocated_pages);
>> +
>>  #define BCH_PGOFF_TO_KVADDR(pgoff) ((void *)((unsigned long)pgoff << PAGE_SHIFT))
>>  
>>  static int init_owner_info(struct bch_nvm_namespace *ns)
>> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
>> index 0ca699166855..c763bf2e2721 100644
>> --- a/drivers/md/bcache/nvm-pages.h
>> +++ b/drivers/md/bcache/nvm-pages.h
>> @@ -64,6 +64,7 @@ int bch_nvm_init(void);
>>  void bch_nvm_exit(void);
>>  void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
>>  void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
>> +struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid);
>>  
>>  #else
>>  
>> @@ -81,6 +82,10 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
>>  	return NULL;
>>  }
>>  static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
>> +static inline struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
>> +{
>> +	return NULL;
>> +}
>>  
>>  #endif /* CONFIG_BCACHE_NVM_PAGES */
>>  
>>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks for your review.

Coly Li
