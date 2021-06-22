Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF4D3B0222
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Jun 2021 12:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFVLB7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Jun 2021 07:01:59 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47326 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhFVLB6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Jun 2021 07:01:58 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DA1BA2196D;
        Tue, 22 Jun 2021 10:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PffBQGqiSbrArOVxeRaiCq2+fO3Ji1PAj4wruiJ+XNw=;
        b=jrSr2XoBEOmuE0piC1z8E7LZESR795xq/DZ6jrHy/N199LUOT85JPvQpH3kjKBtRplRfFc
        p1z+HPovfDJc8KiV0Wrwj69RQGJWa7dwzp3GJc+SGCjkIbYs5XFRJas6V7raoKZcReKlAS
        +bNFmpYcBVFohNzAx4CfuD9SuHN2UBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359581;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PffBQGqiSbrArOVxeRaiCq2+fO3Ji1PAj4wruiJ+XNw=;
        b=Am0+izuYQiJ7iJDdPA66NOdH+6t+upyY0pc8hQYaYnirikvAo1OxodBHMX3WtnJ96cCsdN
        cXEb/WpyVjRd2rCQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id C948D118DD;
        Tue, 22 Jun 2021 10:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PffBQGqiSbrArOVxeRaiCq2+fO3Ji1PAj4wruiJ+XNw=;
        b=jrSr2XoBEOmuE0piC1z8E7LZESR795xq/DZ6jrHy/N199LUOT85JPvQpH3kjKBtRplRfFc
        p1z+HPovfDJc8KiV0Wrwj69RQGJWa7dwzp3GJc+SGCjkIbYs5XFRJas6V7raoKZcReKlAS
        +bNFmpYcBVFohNzAx4CfuD9SuHN2UBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359581;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PffBQGqiSbrArOVxeRaiCq2+fO3Ji1PAj4wruiJ+XNw=;
        b=Am0+izuYQiJ7iJDdPA66NOdH+6t+upyY0pc8hQYaYnirikvAo1OxodBHMX3WtnJ96cCsdN
        cXEb/WpyVjRd2rCQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id TWOdMJ3C0WAUXgAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 22 Jun 2021 10:59:41 +0000
Subject: Re: [PATCH 10/14] bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into
 incompat feature set
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-11-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f49f2939-5cd6-6741-f53e-b1c0473bc686@suse.de>
Date:   Tue, 22 Jun 2021 12:59:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210615054921.101421-11-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/15/21 7:49 AM, Coly Li wrote:
> This patch adds BCH_FEATURE_INCOMPAT_NVDIMM_META (value 0x0004) into the
> incompat feature set. When this bit is set by bcache-tools, it indicates
> bcache meta data should be stored on specific NVDIMM meta device.
> 
> The bcache meta data mainly includes journal and btree nodes, when this
> bit is set in incompat feature set, bcache will ask the nvm-pages
> allocator for NVDIMM space to store the meta data.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Jianpeng Ma <jianpeng.ma@intel.com>
> Cc: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  drivers/md/bcache/features.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
> index d1c8fd3977fc..45d2508d5532 100644
> --- a/drivers/md/bcache/features.h
> +++ b/drivers/md/bcache/features.h
> @@ -17,11 +17,19 @@
>  #define BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET		0x0001
>  /* real bucket size is (1 << bucket_size) */
>  #define BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE	0x0002
> +/* store bcache meta data on nvdimm */
> +#define BCH_FEATURE_INCOMPAT_NVDIMM_META		0x0004
>  
>  #define BCH_FEATURE_COMPAT_SUPP		0
>  #define BCH_FEATURE_RO_COMPAT_SUPP	0
> +#if defined(CONFIG_BCACHE_NVM_PAGES)
> +#define BCH_FEATURE_INCOMPAT_SUPP	(BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET| \
> +					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE| \
> +					 BCH_FEATURE_INCOMPAT_NVDIMM_META)
> +#else
>  #define BCH_FEATURE_INCOMPAT_SUPP	(BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET| \
>  					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE)
> +#endif
>  
>  #define BCH_HAS_COMPAT_FEATURE(sb, mask) \
>  		((sb)->feature_compat & (mask))
> @@ -89,6 +97,7 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
>  
>  BCH_FEATURE_INCOMPAT_FUNCS(obso_large_bucket, OBSO_LARGE_BUCKET);
>  BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LOG_LARGE_BUCKET_SIZE);
> +BCH_FEATURE_INCOMPAT_FUNCS(nvdimm_meta, NVDIMM_META);
>  
>  static inline bool bch_has_unknown_compat_features(struct cache_sb *sb)
>  {
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
