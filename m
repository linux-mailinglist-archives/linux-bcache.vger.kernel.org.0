Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486753B01DF
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Jun 2021 12:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFVK5d (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Jun 2021 06:57:33 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47206 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVK5d (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Jun 2021 06:57:33 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 996AC21988;
        Tue, 22 Jun 2021 10:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdhOkHb563nioODxq403p3Sqwc3FVVAkpApSQUm4Rag=;
        b=hSZl8vRPzichV06o5RV4ybG6Ebi7jFC4E/2W/FOCrvqMObn9i33VL+k6XuCWy3OT23BZBm
        8UKMUaRHWDXq/rRZYfCDp66w7SzZ7sK2eoiwRJ3VgHlNb+66ALBtSn+fq//O4iGVVQyrn5
        Qg3uear5RHY+O9ImUGNqvNKU48ZACvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359316;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdhOkHb563nioODxq403p3Sqwc3FVVAkpApSQUm4Rag=;
        b=YRzrmAINpK1rqqMJ5BL22n+4ZasakU2Igg010RW6eot932WvTf5iqm+nAsnwIuyk8tGmyk
        uSorcpPxStId8jAQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 8AE7D118DD;
        Tue, 22 Jun 2021 10:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdhOkHb563nioODxq403p3Sqwc3FVVAkpApSQUm4Rag=;
        b=hSZl8vRPzichV06o5RV4ybG6Ebi7jFC4E/2W/FOCrvqMObn9i33VL+k6XuCWy3OT23BZBm
        8UKMUaRHWDXq/rRZYfCDp66w7SzZ7sK2eoiwRJ3VgHlNb+66ALBtSn+fq//O4iGVVQyrn5
        Qg3uear5RHY+O9ImUGNqvNKU48ZACvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359316;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdhOkHb563nioODxq403p3Sqwc3FVVAkpApSQUm4Rag=;
        b=YRzrmAINpK1rqqMJ5BL22n+4ZasakU2Igg010RW6eot932WvTf5iqm+nAsnwIuyk8tGmyk
        uSorcpPxStId8jAQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id vmOjIZTB0WB/WwAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 22 Jun 2021 10:55:16 +0000
Subject: Re: [PATCH 09/14] bcache: use bucket index to set GC_MARK_METADATA
 for journal buckets in bch_btree_gc_finish()
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-10-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c1f06286-fd5f-163e-c4a7-bf193b3c804f@suse.de>
Date:   Tue, 22 Jun 2021 12:55:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210615054921.101421-10-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/15/21 7:49 AM, Coly Li wrote:
> Currently the meta data bucket locations on cache device are reserved
> after the meta data stored on NVDIMM pages, for the meta data layout
> consistentcy temporarily. So these buckets are still marked as meta data
> by SET_GC_MARK() in bch_btree_gc_finish().
> 
> When BCH_FEATURE_INCOMPAT_NVDIMM_META is set, the sb.d[] stores linear
> address of NVDIMM pages and not bucket index anymore. Therefore we
> should avoid to find bucket index from sb.d[], and directly use bucket
> index from ca->sb.first_bucket to (ca->sb.first_bucket +
> ca->sb.njournal_bucketsi) for setting the gc mark of journal bucket.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Jianpeng Ma <jianpeng.ma@intel.com>
> Cc: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  drivers/md/bcache/btree.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 183a58c89377..e0d7135669ca 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1761,8 +1761,10 @@ static void bch_btree_gc_finish(struct cache_set *c)
>  	ca = c->cache;
>  	ca->invalidate_needs_gc = 0;
>  
> -	for (k = ca->sb.d; k < ca->sb.d + ca->sb.keys; k++)
> -		SET_GC_MARK(ca->buckets + *k, GC_MARK_METADATA);
> +	/* Range [first_bucket, first_bucket + keys) is for journal buckets */
> +	for (i = ca->sb.first_bucket;
> +	     i < ca->sb.first_bucket + ca->sb.njournal_buckets; i++)
> +		SET_GC_MARK(ca->buckets + i, GC_MARK_METADATA);
>  
>  	for (k = ca->prio_buckets;
>  	     k < ca->prio_buckets + prio_buckets(ca) * 2; k++)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
