Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8B03B17EF
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 12:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhFWKRF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 06:17:05 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56730 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhFWKRE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 06:17:04 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AEC541FD36;
        Wed, 23 Jun 2021 10:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624443286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=semWVFz7wfL9gI03dnaCWk0ArgLFYd7xtpksOcVoYg8=;
        b=rkh4KCquJT1302nzifpYjRoVOd5IHOxQaZpLyn7IxVjD7Jzr3UC7VtooGmoZVcX/1/Q9D2
        CudKNqv/jGZLI9IT57sjOb9c7cvpFLpBPBAnwC/ib+i+a2Fl8pyhDt9rsrmDlsvskKvv6I
        72NPUoWWBEN5FDNNET4QMGgOoPnEBpo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624443286;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=semWVFz7wfL9gI03dnaCWk0ArgLFYd7xtpksOcVoYg8=;
        b=kS1m3R5yJOxypqDi/kFWAeJuNlLO88NwgpVERvA876Mkm4fjZtGctd15sZO5PswdfCGza3
        h+w2QrZfRaMR6KBg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 4F49711A97;
        Wed, 23 Jun 2021 10:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624443286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=semWVFz7wfL9gI03dnaCWk0ArgLFYd7xtpksOcVoYg8=;
        b=rkh4KCquJT1302nzifpYjRoVOd5IHOxQaZpLyn7IxVjD7Jzr3UC7VtooGmoZVcX/1/Q9D2
        CudKNqv/jGZLI9IT57sjOb9c7cvpFLpBPBAnwC/ib+i+a2Fl8pyhDt9rsrmDlsvskKvv6I
        72NPUoWWBEN5FDNNET4QMGgOoPnEBpo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624443286;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=semWVFz7wfL9gI03dnaCWk0ArgLFYd7xtpksOcVoYg8=;
        b=kS1m3R5yJOxypqDi/kFWAeJuNlLO88NwgpVERvA876Mkm4fjZtGctd15sZO5PswdfCGza3
        h+w2QrZfRaMR6KBg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id o1f1B5UJ02ADVgAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 10:14:45 +0000
Subject: Re: [PATCH 11/14] bcache: initialize bcache journal for NVDIMM meta
 device
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-bcache@vger.kernel.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-12-colyli@suse.de>
 <97aaab72-30ba-d030-1be0-5aef1026150e@suse.de>
 <635b8138-22c5-9467-f99f-585a248872d3@suse.de>
 <6e15a2fb-5452-6e60-5bde-1edc076ed6db@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <db134826-18e8-e80e-6397-c91fb073046e@suse.de>
Date:   Wed, 23 Jun 2021 18:14:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6e15a2fb-5452-6e60-5bde-1edc076ed6db@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/23/21 5:20 PM, Hannes Reinecke wrote:
> On 6/23/21 8:17 AM, Coly Li wrote:
>> On 6/22/21 7:01 PM, Hannes Reinecke wrote:
>>> On 6/15/21 7:49 AM, Coly Li wrote:
>>>> The nvm-pages allocator may store and index the NVDIMM pages allocated
>>>> for bcache journal. This patch adds the initialization to store bcache
>>>> journal space on NVDIMM pages if BCH_FEATURE_INCOMPAT_NVDIMM_META
>>>> bit is
>>>> set by bcache-tools.
>>>>
>>>> If BCH_FEATURE_INCOMPAT_NVDIMM_META is set, get_nvdimm_journal_space()
>>>> will return the linear address of NVDIMM pages for bcache journal,
>>>> - If there is previously allocated space, find it from nvm-pages owner
>>>>    list and return to bch_journal_init().
>>>> - If there is no previously allocated space, require a new NVDIMM
>>>> range
>>>>    from the nvm-pages allocator, and return it to bch_journal_init().
>>>>
>>>> And in bch_journal_init(), keys in sb.d[] store the corresponding
>>>> linear
>>>> address from NVDIMM into sb.d[i].ptr[0] where 'i' is the bucket
>>>> index to
>>>> iterate all journal buckets.
>>>>
>>>> Later when bcache journaling code stores the journaling jset, the
>>>> target
>>>> NVDIMM linear address stored (and updated) in sb.d[i].ptr[0] can be
>>>> used
>>>> directly in memory copy from DRAM pages into NVDIMM pages.
>>>>
>>>> Signed-off-by: Coly Li <colyli@suse.de>
>>>> Cc: Jianpeng Ma <jianpeng.ma@intel.com>
>>>> Cc: Qiaowei Ren <qiaowei.ren@intel.com>
>>>> ---
>>>>   drivers/md/bcache/journal.c | 105
>>>> ++++++++++++++++++++++++++++++++++++
>>>>   drivers/md/bcache/journal.h |   2 +-
>>>>   drivers/md/bcache/super.c   |  16 +++---
>>>>   3 files changed, 115 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
>>>> index 61bd79babf7a..32599d2ff5d2 100644
>>>> --- a/drivers/md/bcache/journal.c
>>>> +++ b/drivers/md/bcache/journal.c
>>>> @@ -9,6 +9,8 @@
>>>>   #include "btree.h"
>>>>   #include "debug.h"
>>>>   #include "extents.h"
>>>> +#include "nvm-pages.h"
>>>> +#include "features.h"
>>>>     #include <trace/events/bcache.h>
>>>>   @@ -982,3 +984,106 @@ int bch_journal_alloc(struct cache_set *c)
>>>>         return 0;
>>>>   }
>>>> +
>>>> +#if defined(CONFIG_BCACHE_NVM_PAGES)
>>>> +
>>>> +static void *find_journal_nvm_base(struct bch_nvm_pages_owner_head
>>>> *owner_list,
>>>> +                   struct cache *ca)
>>>> +{
>>>> +    unsigned long addr = 0;
>>>> +    struct bch_nvm_pgalloc_recs *recs_list = owner_list->recs[0];
>>>> +
>>>> +    while (recs_list) {
>>>> +        struct bch_pgalloc_rec *rec;
>>>> +        unsigned long jnl_pgoff;
>>>> +        int i;
>>>> +
>>>> +        jnl_pgoff = ((unsigned long)ca->sb.d[0]) >> PAGE_SHIFT;
>>>> +        rec = recs_list->recs;
>>>> +        for (i = 0; i < recs_list->used; i++) {
>>>> +            if (rec->pgoff == jnl_pgoff)
>>>> +                break;
>>>> +            rec++;
>>>> +        }
>>>> +        if (i < recs_list->used) {
>>>> +            addr = rec->pgoff << PAGE_SHIFT;
>>>> +            break;
>>>> +        }
>>>> +        recs_list = recs_list->next;
>>>> +    }
>>>> +    return (void *)addr;
>>>> +}
>>>> +
>>>> +static void *get_nvdimm_journal_space(struct cache *ca)
>>>> +{
>>>> +    struct bch_nvm_pages_owner_head *owner_list = NULL;
>>>> +    void *ret = NULL;
>>>> +    int order;
>>>> +
>>>> +    owner_list = bch_get_allocated_pages(ca->sb.set_uuid);
>>>> +    if (owner_list) {
>>>> +        ret = find_journal_nvm_base(owner_list, ca);
>>>> +        if (ret)
>>>> +            goto found;
>>>> +    }
>>>> +
>>>> +    order = ilog2(ca->sb.bucket_size *
>>>> +              ca->sb.njournal_buckets / PAGE_SECTORS);
>>>> +    ret = bch_nvm_alloc_pages(order, ca->sb.set_uuid);
>>>> +    if (ret)
>>>> +        memset(ret, 0, (1 << order) * PAGE_SIZE);
>>>> +
>>>> +found:
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static int __bch_journal_nvdimm_init(struct cache *ca)
>>>> +{
>>>> +    int i, ret = 0;
>>>> +    void *journal_nvm_base = NULL;
>>>> +
>>>> +    journal_nvm_base = get_nvdimm_journal_space(ca);
>>>> +    if (!journal_nvm_base) {
>>>> +        pr_err("Failed to get journal space from nvdimm\n");
>>>> +        ret = -1;
>>>> +        goto out;
>>>> +    }
>>>> +
>>>> +    /* Iniialized and reloaded from on-disk super block already */
>>>> +    if (ca->sb.d[0] != 0)
>>>> +        goto out;
>>>> +
>>>> +    for (i = 0; i < ca->sb.keys; i++)
>>>> +        ca->sb.d[i] =
>>>> +            (u64)(journal_nvm_base + (ca->sb.bucket_size * i));
>>>> +
>>>> +out:
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +#else /* CONFIG_BCACHE_NVM_PAGES */
>>>> +
>>>> +static int __bch_journal_nvdimm_init(struct cache *ca)
>>>> +{
>>>> +    return -1;
>>>> +}
>>>> +
>>>> +#endif /* CONFIG_BCACHE_NVM_PAGES */
>>>> +
>>>> +int bch_journal_init(struct cache_set *c)
>>>> +{
>>>> +    int i, ret = 0;
>>>> +    struct cache *ca = c->cache;
>>>> +
>>>> +    ca->sb.keys = clamp_t(int, ca->sb.nbuckets >> 7,
>>>> +                2, SB_JOURNAL_BUCKETS);
>>>> +
>>>> +    if (!bch_has_feature_nvdimm_meta(&ca->sb)) {
>>>> +        for (i = 0; i < ca->sb.keys; i++)
>>>> +            ca->sb.d[i] = ca->sb.first_bucket + i;
>>>> +    } else {
>>>> +        ret = __bch_journal_nvdimm_init(ca);
>>>> +    }
>>>> +
>>>> +    return ret;
>>>> +}
>>>> diff --git a/drivers/md/bcache/journal.h b/drivers/md/bcache/journal.h
>>>> index f2ea34d5f431..e3a7fa5a8fda 100644
>>>> --- a/drivers/md/bcache/journal.h
>>>> +++ b/drivers/md/bcache/journal.h
>>>> @@ -179,7 +179,7 @@ void bch_journal_mark(struct cache_set *c,
>>>> struct list_head *list);
>>>>   void bch_journal_meta(struct cache_set *c, struct closure *cl);
>>>>   int bch_journal_read(struct cache_set *c, struct list_head *list);
>>>>   int bch_journal_replay(struct cache_set *c, struct list_head *list);
>>>> -
>>>> +int bch_journal_init(struct cache_set *c);
>>>>   void bch_journal_free(struct cache_set *c);
>>>>   int bch_journal_alloc(struct cache_set *c);
>>>>   diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>>> index ce22aefb1352..cce0f6bf0944 100644
>>>> --- a/drivers/md/bcache/super.c
>>>> +++ b/drivers/md/bcache/super.c
>>>> @@ -147,10 +147,15 @@ static const char *read_super_common(struct
>>>> cache_sb *sb,  struct block_device *
>>>>           goto err;
>>>>         err = "Journal buckets not sequential";
>>>> +#if defined(CONFIG_BCACHE_NVM_PAGES)
>>>> +    if (!bch_has_feature_nvdimm_meta(sb)) {
>>>> +#endif
>>>>       for (i = 0; i < sb->keys; i++)
>>>>           if (sb->d[i] != sb->first_bucket + i)
>>>>               goto err;
>>>> -
>>>> +#ifdef CONFIG_BCACHE_NVM_PAGES
>>>> +    } /* bch_has_feature_nvdimm_meta */
>>>> +#endif
>>>>       err = "Too many journal buckets";
>>>>       if (sb->first_bucket + sb->keys > sb->nbuckets)
>>>>           goto err;
>>> Extremely awkward.
>>
>> After the feature settled and not marked as EXPERIMENTAL, such condition
>> code will be removed.
>>
>>
>>> Make 'bch_has_feature_nvdimm_meta()' generally available, and have it
>>> return 'false' if the config feature isn't enabled.
>>
>> bch_has_feature_nvdimm_meta() is defined as,
>>
>>
>>   41 #define BCH_FEATURE_COMPAT_FUNCS(name, flagname) \
>>   42 static inline int bch_has_feature_##name(struct cache_sb *sb) \
>>   43 { \
>>   44         if (sb->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
>>   45                 return 0; \
>>   46         return (((sb)->feature_compat & \
>>   47                 BCH##_FEATURE_COMPAT_##flagname) != 0); \
>>   48 } \
>>
>> It is not easy to check a specific Kconfig item in the above code block,
>> this is why
>> we choose the compiling condition to disable nvdimm related code here,
>> before we remove
>> the EXPERIMENTAL mark in Kconfig.
>>
> But you can have the flag defined in general (ie outside the config
> ifdefs), and only set it if the code is enabled, right?
> Then the check will work always and do what we want, or?

I understand you, I will add a flag in struct cache, and handle the
condition as your suggestion.

Thanks for your review and comments.

Coly Li
