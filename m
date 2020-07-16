Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF14221C86
	for <lists+linux-bcache@lfdr.de>; Thu, 16 Jul 2020 08:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgGPGUI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jul 2020 02:20:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:48232 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgGPGUH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jul 2020 02:20:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D6623B71F;
        Thu, 16 Jul 2020 06:20:08 +0000 (UTC)
Subject: Re: [PATCH v3 14/16] bcache: add sysfs file to display feature sets
 information of cache set
To:     Hannes Reinecke <hare@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715143015.14957-1-colyli@suse.de>
 <20200715143015.14957-15-colyli@suse.de>
 <dd08f8dd-4818-7cb2-6151-f7315cc03755@suse.de>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <912b4b34-3352-3496-eca2-0f6487e9b643@suse.de>
Date:   Thu, 16 Jul 2020 14:20:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dd08f8dd-4818-7cb2-6151-f7315cc03755@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/7/16 14:17, Hannes Reinecke wrote:
> On 7/15/20 4:30 PM, colyli@suse.de wrote:
>> From: Coly Li <colyli@suse.de>
>>
>> A new sysfs file /sys/fs/bcache/<cache set UUID>/internal/feature_sets
>> is added by this patch, to display feature sets information of the cache
>> set.
>>
>> Now only an incompat feature 'large_bucket' added in bcache, the sysfs
>> file content is:
>>     feature_incompat: [large_bucket]
>> string large_bucket means the running bcache drive supports incompat
>> feature 'large_bucket', the wrapping [] means the 'large_bucket' feature
>> is currently enabled on this cache set.
>>
>> This patch is ready to display compat and ro_compat features, in future
>> once bcache code implements such feature sets, the according feature
>> strings will be displayed in this sysfs file too.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>   drivers/md/bcache/Makefile   |  2 +-
>>   drivers/md/bcache/features.c | 48 ++++++++++++++++++++++++++++++++++++
>>   drivers/md/bcache/features.h |  3 +++
>>   drivers/md/bcache/sysfs.c    |  6 +++++
>>   4 files changed, 58 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
>> index fd714628da6a..5b87e59676b8 100644
>> --- a/drivers/md/bcache/Makefile
>> +++ b/drivers/md/bcache/Makefile
>> @@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)    += bcache.o
>>     bcache-y        := alloc.o bset.o btree.o closure.o debug.o
>> extents.o\
>>       io.o journal.o movinggc.o request.o stats.o super.o sysfs.o
>> trace.o\
>> -    util.o writeback.o
>> +    util.o writeback.o features.o
>> diff --git a/drivers/md/bcache/features.c b/drivers/md/bcache/features.c
>> index ba53944bb390..5c601635e11c 100644
>> --- a/drivers/md/bcache/features.c
>> +++ b/drivers/md/bcache/features.c
>> @@ -8,6 +8,7 @@
>>    */
>>   #include <linux/bcache.h>
>>   #include "bcache.h"
>> +#include "features.h"
>>     struct feature {
>>       int        compat;
>> @@ -20,3 +21,50 @@ static struct feature feature_list[] = {
>>           "large_bucket"},
>>       {0, 0, 0 },
>>   };
>> +
>> +#define compose_feature_string(type, head)                \
>> +({                                    \
>> +    struct feature *f;                        \
>> +    bool first = true;                        \
>> +                                    \
>> +    for (f = &feature_list[0]; f->compat != 0; f++) {        \
>> +        if (f->compat != BCH_FEATURE_ ## type)            \
>> +            continue;                    \
>> +        if (BCH_HAS_ ## type ## _FEATURE(&c->sb, f->mask)) {    \
>> +            if (first) {                    \
>> +                out += snprintf(out, buf + size - out,    \
>> +                        "%s%s", head, ": [");    \
>> +            } else {                    \
>> +                out += snprintf(out, buf + size - out,    \
>> +                        " [");            \
>> +            }                        \
>> +        } else {                        \
>> +            if (first)                    \
>> +                out += snprintf(out, buf + size - out,    \
>> +                        "%s%s", head, ": ");    \
>> +            else                        \
>> +                out += snprintf(out, buf + size - out,    \
>> +                        " ");            \
>> +        }                            \
>> +                                    \
>> +        out += snprintf(out, buf + size - out, "%s", f->string);\
>> +                                    \
>> +        if (BCH_HAS_ ## type ## _FEATURE(&c->sb, f->mask))    \
>> +            out += snprintf(out, buf + size - out, "]");    \
>> +                                    \
>> +        first = false;                        \
>> +    }                                \
>> +    if (!first)                            \
>> +        out += snprintf(out, buf + size - out, "\n");        \
>> +})
>> +
>> +int bch_print_cache_set_feature_set(struct cache_set *c, char *buf,
>> int size)
>> +{
>> +    char *out = buf;
>> +
>> +    compose_feature_string(COMPAT, "feature_compat");
>> +    compose_feature_string(RO_COMPAT, "feature_ro_compat");
>> +    compose_feature_string(INCOMPAT, "feature_incompat");
>> +
>> +    return out - buf;
>> +}
>> diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
>> index dca052cf5203..350a4f413136 100644
>> --- a/drivers/md/bcache/features.h
>> +++ b/drivers/md/bcache/features.h
>> @@ -78,4 +78,7 @@ static inline void bch_clear_feature_##name(struct
>> cache_sb *sb) \
>>   }
>>     BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LARGE_BUCKET);
>> +
>> +int bch_print_cache_set_feature_set(struct cache_set *c, char *buf,
>> int size);
>> +
>>   #endif
>> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
>> index 0dadec5a78f6..e3633f06d43b 100644
>> --- a/drivers/md/bcache/sysfs.c
>> +++ b/drivers/md/bcache/sysfs.c
>> @@ -11,6 +11,7 @@
>>   #include "btree.h"
>>   #include "request.h"
>>   #include "writeback.h"
>> +#include "features.h"
>>     #include <linux/blkdev.h>
>>   #include <linux/sort.h>
>> @@ -88,6 +89,7 @@ read_attribute(btree_used_percent);
>>   read_attribute(average_key_size);
>>   read_attribute(dirty_data);
>>   read_attribute(bset_tree_stats);
>> +read_attribute(feature_sets);
>>     read_attribute(state);
>>   read_attribute(cache_read_races);
>> @@ -779,6 +781,9 @@ SHOW(__bch_cache_set)
>>       if (attr == &sysfs_bset_tree_stats)
>>           return bch_bset_print_stats(c, buf);
>>   +    if (attr == &sysfs_feature_sets)
>> +        return bch_print_cache_set_feature_set(c, buf, PAGE_SIZE);
>> +
>>       return 0;
>>   }
>>   SHOW_LOCKED(bch_cache_set)
>> @@ -987,6 +992,7 @@ static struct attribute
>> *bch_cache_set_internal_files[] = {
>>       &sysfs_io_disable,
>>       &sysfs_cutoff_writeback,
>>       &sysfs_cutoff_writeback_sync,
>> +    &sysfs_feature_sets,
>>       NULL
>>   };
>>   KTYPE(bch_cache_set_internal);
>>
> Tsk.
> 
> sysfs attributes should be one value only, not some string declaring
> several things at once.
> Why not adding two attributes (features_compat and features_incompat),
> listing each feature?
> That would even easier to implement.

Copied, will fix it in next version. Thanks.

Coly Li


