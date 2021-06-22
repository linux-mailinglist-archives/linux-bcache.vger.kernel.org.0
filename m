Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371A13B024A
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Jun 2021 13:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFVLGv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Jun 2021 07:06:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47744 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhFVLGt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Jun 2021 07:06:49 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C37AB21988;
        Tue, 22 Jun 2021 11:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0yBjG7qiVZakd3KjOO2BgsADHy/hKn5zmYUJOtYeOU=;
        b=1Owiw4Lp3dHKPOJXijnoHA1RMHIQX8Z2cNwWqsqAvkL2EsfOmrJUzvn5Yxf1+aFhqG/453
        JBqu2SBVzfvXcw6yJqlBKtrpzb4pknw+vJcnsfHpEqCfTOQx32NzPTCBPTBzXBeOGxZQVu
        FjW/SsemdNy3vTrg3lsM4JfxNhRXNks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359872;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0yBjG7qiVZakd3KjOO2BgsADHy/hKn5zmYUJOtYeOU=;
        b=QcciyL6Exgjyg8gGsoqt/hkGP1J7YlMsytC7/ev2cOiMgSc+ry0n0GpcYSn7OlCFq4U6+C
        /xkU4xnjzh/EWSCw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id B1F45118DD;
        Tue, 22 Jun 2021 11:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0yBjG7qiVZakd3KjOO2BgsADHy/hKn5zmYUJOtYeOU=;
        b=1Owiw4Lp3dHKPOJXijnoHA1RMHIQX8Z2cNwWqsqAvkL2EsfOmrJUzvn5Yxf1+aFhqG/453
        JBqu2SBVzfvXcw6yJqlBKtrpzb4pknw+vJcnsfHpEqCfTOQx32NzPTCBPTBzXBeOGxZQVu
        FjW/SsemdNy3vTrg3lsM4JfxNhRXNks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359872;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0yBjG7qiVZakd3KjOO2BgsADHy/hKn5zmYUJOtYeOU=;
        b=QcciyL6Exgjyg8gGsoqt/hkGP1J7YlMsytC7/ev2cOiMgSc+ry0n0GpcYSn7OlCFq4U6+C
        /xkU4xnjzh/EWSCw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 8MhJK8DD0WDhYQAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 22 Jun 2021 11:04:32 +0000
Subject: Re: [PATCH 14/14] bcache: add sysfs interface register_nvdimm_meta to
 register NVDIMM meta device
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-15-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d85d87f1-5a3d-9e20-7275-1aab7b8a6711@suse.de>
Date:   Tue, 22 Jun 2021 13:04:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210615054921.101421-15-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/15/21 7:49 AM, Coly Li wrote:
> This patch adds a sysfs interface register_nvdimm_meta to register
> NVDIMM meta device. The sysfs interface file only shows up when
> CONFIG_BCACHE_NVM_PAGES=y. Then a NVDIMM name space formatted by
> bcache-tools can be registered into bcache by e.g.,
>   echo /dev/pmem0 > /sys/fs/bcache/register_nvdimm_meta
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Jianpeng Ma <jianpeng.ma@intel.com>
> Cc: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  drivers/md/bcache/super.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 4d6666d03aa7..9d506d053548 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2439,10 +2439,18 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
>  					 struct kobj_attribute *attr,
>  					 const char *buffer, size_t size);
> +#if defined(CONFIG_BCACHE_NVM_PAGES)
> +static ssize_t register_nvdimm_meta(struct kobject *k,
> +				    struct kobj_attribute *attr,
> +				    const char *buffer, size_t size);
> +#endif
>  
>  kobj_attribute_write(register,		register_bcache);
>  kobj_attribute_write(register_quiet,	register_bcache);
>  kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);
> +#if defined(CONFIG_BCACHE_NVM_PAGES)
> +kobj_attribute_write(register_nvdimm_meta, register_nvdimm_meta);
> +#endif
>  
>  static bool bch_is_open_backing(dev_t dev)
>  {
> @@ -2556,6 +2564,24 @@ static void register_device_async(struct async_reg_args *args)
>  	queue_delayed_work(system_wq, &args->reg_work, 10);
>  }
>  
> +#if defined(CONFIG_BCACHE_NVM_PAGES)
> +static ssize_t register_nvdimm_meta(struct kobject *k, struct kobj_attribute *attr,
> +				    const char *buffer, size_t size)
> +{
> +	ssize_t ret = size;
> +
> +	struct bch_nvm_namespace *ns = bch_register_namespace(buffer);
> +
> +	if (IS_ERR(ns)) {
> +		pr_err("register nvdimm namespace %s for meta device failed.\n",
> +			buffer);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +#endif
> +
>  static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  			       const char *buffer, size_t size)
>  {
> @@ -2898,6 +2924,9 @@ static int __init bcache_init(void)
>  	static const struct attribute *files[] = {
>  		&ksysfs_register.attr,
>  		&ksysfs_register_quiet.attr,
> +#if defined(CONFIG_BCACHE_NVM_PAGES)
> +		&ksysfs_register_nvdimm_meta.attr,
> +#endif
>  		&ksysfs_pendings_cleanup.attr,
>  		NULL
>  	};
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
