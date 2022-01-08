Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EFD4881D1
	for <lists+linux-bcache@lfdr.de>; Sat,  8 Jan 2022 07:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiAHGQd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 8 Jan 2022 01:16:33 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60026 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiAHGQc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 8 Jan 2022 01:16:32 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AE7941F387;
        Sat,  8 Jan 2022 06:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641622591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/OZKLto7DbcujA8Y+d3eunCD+6T9fenHeja9jnpFz/A=;
        b=G6Rzoc/RstRVMNdnVlEaRDbf8JenAT848X59828k7olR5biEIoi3YUdWBMcyJaWhQ8llZB
        /P7lGsJ1SDfPm+Y/cBl5VXX5H7UewvmvEAZaWIx2bLY1rjf+XjH2s3xdCO0NzPHtoQW47l
        Vzt4MuR1nUdhhkwbwkcdGqhgrowfzp0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641622591;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/OZKLto7DbcujA8Y+d3eunCD+6T9fenHeja9jnpFz/A=;
        b=dQ5mMt+9guYg0GqjGMsWFsKpRsHgh5IKzUlxUmAbNtnvn+cdca0jMMxkDOa0mQB+7OUkrF
        6FvWJX3p5CSelzAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB4CD13D55;
        Sat,  8 Jan 2022 06:16:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pY46Jz4s2WEIMQAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 08 Jan 2022 06:16:30 +0000
Message-ID: <7cbca83d-bcac-464e-d2e4-c54b2d53eead@suse.de>
Date:   Sat, 8 Jan 2022 14:16:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] bcache: use default_groups in kobj_type
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220106100004.3277439-1-gregkh@linuxfoundation.org>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220106100004.3277439-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/6/22 6:00 PM, Greg Kroah-Hartman wrote:
> There are currently 2 ways to create a set of sysfs files for a
> kobj_type, through the default_attrs field, and the default_groups
> field.  Move the bcache sysfs code to use default_groups field which has
> been the preferred way since aa30f47cf666 ("kobject: Add support for
> default attribute groups to kobj_type") so that we can soon get rid of
> the obsolete default_attrs field.
>
> Cc: Coly Li <colyli@suse.de>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: linux-bcache@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

It looks good to me.

Acked-by: Coly Li <colyli@suse.de>

I assume you may take this patch directly in your maintenance path, but 
if you want me to take this, just let me know. Thanks.

Coly Li

> ---
>   drivers/md/bcache/stats.c |  3 ++-
>   drivers/md/bcache/sysfs.c | 15 ++++++++++-----
>   drivers/md/bcache/sysfs.h |  2 +-
>   3 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
> index 4c7ee5fedb9d..68b02216033d 100644
> --- a/drivers/md/bcache/stats.c
> +++ b/drivers/md/bcache/stats.c
> @@ -78,7 +78,7 @@ static void bch_stats_release(struct kobject *k)
>   {
>   }
>   
> -static struct attribute *bch_stats_files[] = {
> +static struct attribute *bch_stats_attrs[] = {
>   	&sysfs_cache_hits,
>   	&sysfs_cache_misses,
>   	&sysfs_cache_bypass_hits,
> @@ -88,6 +88,7 @@ static struct attribute *bch_stats_files[] = {
>   	&sysfs_bypassed,
>   	NULL
>   };
> +ATTRIBUTE_GROUPS(bch_stats);
>   static KTYPE(bch_stats);
>   
>   int bch_cache_accounting_add_kobjs(struct cache_accounting *acc,
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 1f0dce30fa75..d1029d71ff3b 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -500,7 +500,7 @@ STORE(bch_cached_dev)
>   	return size;
>   }
>   
> -static struct attribute *bch_cached_dev_files[] = {
> +static struct attribute *bch_cached_dev_attrs[] = {
>   	&sysfs_attach,
>   	&sysfs_detach,
>   	&sysfs_stop,
> @@ -543,6 +543,7 @@ static struct attribute *bch_cached_dev_files[] = {
>   	&sysfs_backing_dev_uuid,
>   	NULL
>   };
> +ATTRIBUTE_GROUPS(bch_cached_dev);
>   KTYPE(bch_cached_dev);
>   
>   SHOW(bch_flash_dev)
> @@ -600,7 +601,7 @@ STORE(__bch_flash_dev)
>   }
>   STORE_LOCKED(bch_flash_dev)
>   
> -static struct attribute *bch_flash_dev_files[] = {
> +static struct attribute *bch_flash_dev_attrs[] = {
>   	&sysfs_unregister,
>   #if 0
>   	&sysfs_data_csum,
> @@ -609,6 +610,7 @@ static struct attribute *bch_flash_dev_files[] = {
>   	&sysfs_size,
>   	NULL
>   };
> +ATTRIBUTE_GROUPS(bch_flash_dev);
>   KTYPE(bch_flash_dev);
>   
>   struct bset_stats_op {
> @@ -955,7 +957,7 @@ static void bch_cache_set_internal_release(struct kobject *k)
>   {
>   }
>   
> -static struct attribute *bch_cache_set_files[] = {
> +static struct attribute *bch_cache_set_attrs[] = {
>   	&sysfs_unregister,
>   	&sysfs_stop,
>   	&sysfs_synchronous,
> @@ -980,9 +982,10 @@ static struct attribute *bch_cache_set_files[] = {
>   	&sysfs_clear_stats,
>   	NULL
>   };
> +ATTRIBUTE_GROUPS(bch_cache_set);
>   KTYPE(bch_cache_set);
>   
> -static struct attribute *bch_cache_set_internal_files[] = {
> +static struct attribute *bch_cache_set_internal_attrs[] = {
>   	&sysfs_active_journal_entries,
>   
>   	sysfs_time_stats_attribute_list(btree_gc, sec, ms)
> @@ -1022,6 +1025,7 @@ static struct attribute *bch_cache_set_internal_files[] = {
>   	&sysfs_feature_incompat,
>   	NULL
>   };
> +ATTRIBUTE_GROUPS(bch_cache_set_internal);
>   KTYPE(bch_cache_set_internal);
>   
>   static int __bch_cache_cmp(const void *l, const void *r)
> @@ -1182,7 +1186,7 @@ STORE(__bch_cache)
>   }
>   STORE_LOCKED(bch_cache)
>   
> -static struct attribute *bch_cache_files[] = {
> +static struct attribute *bch_cache_attrs[] = {
>   	&sysfs_bucket_size,
>   	&sysfs_block_size,
>   	&sysfs_nbuckets,
> @@ -1196,4 +1200,5 @@ static struct attribute *bch_cache_files[] = {
>   	&sysfs_cache_replacement_policy,
>   	NULL
>   };
> +ATTRIBUTE_GROUPS(bch_cache);
>   KTYPE(bch_cache);
> diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
> index c1752ba2e05b..a2ff6447b699 100644
> --- a/drivers/md/bcache/sysfs.h
> +++ b/drivers/md/bcache/sysfs.h
> @@ -9,7 +9,7 @@ struct kobj_type type ## _ktype = {					\
>   		.show	= type ## _show,				\
>   		.store	= type ## _store				\
>   	}),								\
> -	.default_attrs	= type ## _files				\
> +	.default_groups	= type ## _groups				\
>   }
>   
>   #define SHOW(fn)							\

