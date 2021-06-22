Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8072B3B01DC
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Jun 2021 12:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhFVK41 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Jun 2021 06:56:27 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45620 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFVK41 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Jun 2021 06:56:27 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8EE5A1FD45;
        Tue, 22 Jun 2021 10:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i1Ni/Gzg9uvlmrsWko5N6LHxC1c+x+FU+0x79XPnh40=;
        b=xkjdSOPa1/mO8RpEyDYT5rWIAl73UEo1ZMj80AhMiiQRQp62xKeG7QEDjphQk+2EsWaGk/
        KBBjvPIGeRsAj8as8841gCoGSbty6ujXR6d1cocEnB3RDUUqiGd0qwjPJ/0BjVly/a70k4
        /Mz1hdAP7ymwClO7voo0/4+x0fygIS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359250;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i1Ni/Gzg9uvlmrsWko5N6LHxC1c+x+FU+0x79XPnh40=;
        b=Cukq1yruwf2qKCWT6/tIULGAzIIaKn18OZgYLwKPG/dykR2YeLeHiaghaj3H5JuB/s0z1m
        fUKEO8vDLBKaLwDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 81225118DD;
        Tue, 22 Jun 2021 10:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i1Ni/Gzg9uvlmrsWko5N6LHxC1c+x+FU+0x79XPnh40=;
        b=xkjdSOPa1/mO8RpEyDYT5rWIAl73UEo1ZMj80AhMiiQRQp62xKeG7QEDjphQk+2EsWaGk/
        KBBjvPIGeRsAj8as8841gCoGSbty6ujXR6d1cocEnB3RDUUqiGd0qwjPJ/0BjVly/a70k4
        /Mz1hdAP7ymwClO7voo0/4+x0fygIS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359250;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i1Ni/Gzg9uvlmrsWko5N6LHxC1c+x+FU+0x79XPnh40=;
        b=Cukq1yruwf2qKCWT6/tIULGAzIIaKn18OZgYLwKPG/dykR2YeLeHiaghaj3H5JuB/s0z1m
        fUKEO8vDLBKaLwDw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 7F9sH1LB0WDmWgAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 22 Jun 2021 10:54:10 +0000
Subject: Re: [PATCH 08/14] bcache: get allocated pages from specific owner
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-9-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <42724b1b-8b6d-8118-84c6-ec76f3f78e19@suse.de>
Date:   Tue, 22 Jun 2021 12:54:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210615054921.101421-9-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/15/21 7:49 AM, Coly Li wrote:
> From: Jianpeng Ma <jianpeng.ma@intel.com>
> 
> This patch implements bch_get_allocated_pages() of the buddy to be used to

buddy allocator

> get allocated pages from specific owner.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/nvm-pages.c | 6 ++++++
>  drivers/md/bcache/nvm-pages.h | 5 +++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> index 74d08950c67c..42b0504d9564 100644
> --- a/drivers/md/bcache/nvm-pages.c
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -397,6 +397,12 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
>  }
>  EXPORT_SYMBOL_GPL(bch_nvm_alloc_pages);
>  
> +struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
> +{
> +	return find_owner_head(owner_uuid, false);
> +}
> +EXPORT_SYMBOL_GPL(bch_get_allocated_pages);
> +
>  #define BCH_PGOFF_TO_KVADDR(pgoff) ((void *)((unsigned long)pgoff << PAGE_SHIFT))
>  
>  static int init_owner_info(struct bch_nvm_namespace *ns)
> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
> index 0ca699166855..c763bf2e2721 100644
> --- a/drivers/md/bcache/nvm-pages.h
> +++ b/drivers/md/bcache/nvm-pages.h
> @@ -64,6 +64,7 @@ int bch_nvm_init(void);
>  void bch_nvm_exit(void);
>  void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
>  void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
> +struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid);
>  
>  #else
>  
> @@ -81,6 +82,10 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
>  	return NULL;
>  }
>  static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
> +static inline struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
> +{
> +	return NULL;
> +}
>  
>  #endif /* CONFIG_BCACHE_NVM_PAGES */
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
