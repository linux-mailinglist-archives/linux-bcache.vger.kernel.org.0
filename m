Return-Path: <linux-bcache+bounces-1354-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D3804CE9A49
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Dec 2025 13:23:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 36460302174B
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Dec 2025 12:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9CA2EC55D;
	Tue, 30 Dec 2025 12:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="FWUJp+d6"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10762EC0B3
	for <linux-bcache@vger.kernel.org>; Tue, 30 Dec 2025 12:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767097368; cv=none; b=t25x0OgF9WHW6MmaddvQm2p8VbQkq+qBNFrjBsj+t6KsHpApPVQDVMdme1hSSrbkQZFV6KmTfnCr5OQdjSTzKlPOFHECjdPAVhHMUs3bvqlubPYgndltbT1eH+bjCwuGW9UgmZNsGwINaIXc2x/Kkfb5uDUBVwZKan4snu7ef1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767097368; c=relaxed/simple;
	bh=5E+pHP/WDcB58e2s6Uhfw0rLyMIdeVHIPlf0Bh1bJrs=;
	h=Content-Type:References:Subject:Message-Id:Date:In-Reply-To:Cc:
	 From:Content-Disposition:To:Mime-Version; b=QD0vSfxro+DzDLycycF9dRbAKVD8CDOufbQS/aRkXsMgx14r6B4eR8sZMu+UAlGgojYbISI/iIszvjUBAcgvd7wMtqx1roTqWOj9Us0LNch9QdJUFMfa1O+Ahppj85I1pERsL1Qkq81p6U+2WU09OjYu1VoaOx3XKMx7uimxD3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=FWUJp+d6; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1767097353;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=l8JjzPk1CnpEF34Dequn38DJ3sRtjdyg64fScM1MvlE=;
 b=FWUJp+d6iUaxCx7b735AotP9ZDZtIcaMQ/XR4jhDMJqLfwVqT3xgqpsx11lokQVj7neohN
 /gUYlWuGXo4L9EnqalB0M8rUTpu2kV4y+tie3/Kqn1cfhsCUrM24Xui9U1BuOnRTnTkWT7
 Th2xiE6XryV2cw5L95HsQQtp/UXiD5BIDJ95uQ1vy59p0wIYTp4GZaEI3fFLMWqi60fBzi
 mRX0n4MiKYt/p9RJtUK5PBTq5ji6HBhY0PWO4zQgpnq29g10eUD4bEU+F/qC6rUvnM7+iy
 ow2iVv7Yoa2ZSomKGn3CpXWJcrjJRekJIs3eAth5DJWob1ZocbCpdLF3sTiHYA==
Content-Type: text/plain; charset=UTF-8
References: <20251230113357.1299759-1-wale.zhang.ftd@gmail.com>
Subject: Re: [RFC PATCH] bcache: make bcache_is_reboot atomic.
Message-Id: <aVPDeUkQ1f_PqEDs@studio.local>
Date: Tue, 30 Dec 2025 20:22:29 +0800
Received: from studio.local ([120.245.64.50]) by smtp.feishu.cn with ESMTPS; Tue, 30 Dec 2025 20:22:30 +0800
In-Reply-To: <20251230113357.1299759-1-wale.zhang.ftd@gmail.com>
Cc: <kent.overstreet@linux.dev>, <linux-bcache@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
From: "Coly Li" <colyli@fnnas.com>
X-Lms-Return-Path: <lba+26953c407+c681a1+vger.kernel.org+colyli@fnnas.com>
X-Original-From: Coly Li <colyli@fnnas.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
To: "Wale Zhang" <wale.zhang.ftd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

On Tue, Dec 30, 2025 at 07:33:57PM +0800, Wale Zhang wrote:
> bcache: make bcache_is_reboot atomic.
> 
> The smp_mb is mainly used to ensure the dependency relationship between
> variables, but there is only one variable bcache_is_reboot. Therefore,
> using smp_mb is not very appropriate.
> 
> When bcache_reboot and register_bcache occur concurrently, register_bcache
> cannot immediately detect that bcache_is_reboot has been set to true.
> 
>     cpu0                            cpu1
> bcache_reboot
>   bcache_is_reboot = true;
>   smp_mb();                      register_bcache
>                                    smp_mb();
>                                    if (bcache_is_reboot)
>                                    // bcache_is_reboot may still be false.
> 

From the above comments, I don't see what problem this patch tries to solve.
And read or write bcache_is_reboot is atomic indeed, I don't see the difference
this patch makes.

Thanks.

Coly Li

> Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
> ---
>  drivers/md/bcache/super.c | 19 ++++++-------------
>  drivers/md/bcache/sysfs.c | 14 +++++++-------
>  2 files changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index c17d4517af22..0b2098aa7234 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -41,7 +41,7 @@ static const char invalid_uuid[] = {
>  
>  static struct kobject *bcache_kobj;
>  struct mutex bch_register_lock;
> -bool bcache_is_reboot;
> +atomic_t bcache_is_reboot = ATOMIC_INIT(0);
>  LIST_HEAD(bch_cache_sets);
>  static LIST_HEAD(uncached_devices);
>  
> @@ -2561,10 +2561,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	if (!try_module_get(THIS_MODULE))
>  		goto out;
>  
> -	/* For latest state of bcache_is_reboot */
> -	smp_mb();
>  	err = "bcache is in reboot";
> -	if (bcache_is_reboot)
> +	if (atomic_read(&bcache_is_reboot))
>  		goto out_module_put;
>  
>  	ret = -ENOMEM;
> @@ -2735,7 +2733,7 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
>  
>  static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
>  {
> -	if (bcache_is_reboot)
> +	if (atomic_read(&bcache_is_reboot))
>  		return NOTIFY_DONE;
>  
>  	if (code == SYS_DOWN ||
> @@ -2750,16 +2748,11 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
>  
>  		mutex_lock(&bch_register_lock);
>  
> -		if (bcache_is_reboot)
> +		if (atomic_read(&bcache_is_reboot))
>  			goto out;
>  
>  		/* New registration is rejected since now */
> -		bcache_is_reboot = true;
> -		/*
> -		 * Make registering caller (if there is) on other CPU
> -		 * core know bcache_is_reboot set to true earlier
> -		 */
> -		smp_mb();
> +		atomic_set(&bcache_is_reboot, 1);
>  
>  		if (list_empty(&bch_cache_sets) &&
>  		    list_empty(&uncached_devices))
> @@ -2935,7 +2928,7 @@ static int __init bcache_init(void)
>  
>  	bch_debug_init();
>  
> -	bcache_is_reboot = false;
> +	atomic_set(&bcache_is_reboot, 0);
>  
>  	return 0;
>  err:
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 72f38e5b6f5c..5384653c5bbb 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -17,7 +17,7 @@
>  #include <linux/sort.h>
>  #include <linux/sched/clock.h>
>  
> -extern bool bcache_is_reboot;
> +extern atomic_t bcache_is_reboot;
>  
>  /* Default is 0 ("writethrough") */
>  static const char * const bch_cache_modes[] = {
> @@ -296,7 +296,7 @@ STORE(__cached_dev)
>  	struct kobj_uevent_env *env;
>  
>  	/* no user space access if system is rebooting */
> -	if (bcache_is_reboot)
> +	if (atomic_read(&bcache_is_reboot))
>  		return -EBUSY;
>  
>  #define d_strtoul(var)		sysfs_strtoul(var, dc->var)
> @@ -459,7 +459,7 @@ STORE(bch_cached_dev)
>  					     disk.kobj);
>  
>  	/* no user space access if system is rebooting */
> -	if (bcache_is_reboot)
> +	if (atomic_read(&bcache_is_reboot))
>  		return -EBUSY;
>  
>  	mutex_lock(&bch_register_lock);
> @@ -571,7 +571,7 @@ STORE(__bch_flash_dev)
>  	struct uuid_entry *u = &d->c->uuids[d->id];
>  
>  	/* no user space access if system is rebooting */
> -	if (bcache_is_reboot)
> +	if (atomic_read(&bcache_is_reboot))
>  		return -EBUSY;
>  
>  	sysfs_strtoul(data_csum,	d->data_csum);
> @@ -814,7 +814,7 @@ STORE(__bch_cache_set)
>  	ssize_t v;
>  
>  	/* no user space access if system is rebooting */
> -	if (bcache_is_reboot)
> +	if (atomic_read(&bcache_is_reboot))
>  		return -EBUSY;
>  
>  	if (attr == &sysfs_unregister)
> @@ -941,7 +941,7 @@ STORE(bch_cache_set_internal)
>  	struct cache_set *c = container_of(kobj, struct cache_set, internal);
>  
>  	/* no user space access if system is rebooting */
> -	if (bcache_is_reboot)
> +	if (atomic_read(&bcache_is_reboot))
>  		return -EBUSY;
>  
>  	return bch_cache_set_store(&c->kobj, attr, buf, size);
> @@ -1137,7 +1137,7 @@ STORE(__bch_cache)
>  	ssize_t v;
>  
>  	/* no user space access if system is rebooting */
> -	if (bcache_is_reboot)
> +	if (atomic_read(&bcache_is_reboot))
>  		return -EBUSY;
>  
>  	if (attr == &sysfs_cache_replacement_policy) {
> -- 
> 2.43.0

