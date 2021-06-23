Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397213B13DF
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 08:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFWGXs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 02:23:48 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36792 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWGXs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 02:23:48 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B3ECF1FD45;
        Wed, 23 Jun 2021 06:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624429290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnUvHMWdrLh+xHxnvDtWu1tcx1ayW0aQlPF6eMJ5FiI=;
        b=g8BLf5l0YOaaxv95/Tx/kgCiQ3wf/nZBq4A3GgPKLdjsx3s8sXbmPeYSXpGI/zkLsvZ0yK
        I3QXq7ptqpzcdw8WIbZmvcEKFdskiLI4jYNbP9b/iVr29ntHsu6YKorN444x6Kig76MGoP
        vqv7lcKW6Vf0XeRLs/Arp58IKhkPZmk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624429290;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnUvHMWdrLh+xHxnvDtWu1tcx1ayW0aQlPF6eMJ5FiI=;
        b=06xgPcQsZFIbgrVLi81dRVBSIpcnub2UHQp1ypsORIC4RPWlRpzMCbCXIfhay99WpvzMHZ
        nlmmCcdYIOj+3bAQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 6CCD211A97;
        Wed, 23 Jun 2021 06:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624429290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnUvHMWdrLh+xHxnvDtWu1tcx1ayW0aQlPF6eMJ5FiI=;
        b=g8BLf5l0YOaaxv95/Tx/kgCiQ3wf/nZBq4A3GgPKLdjsx3s8sXbmPeYSXpGI/zkLsvZ0yK
        I3QXq7ptqpzcdw8WIbZmvcEKFdskiLI4jYNbP9b/iVr29ntHsu6YKorN444x6Kig76MGoP
        vqv7lcKW6Vf0XeRLs/Arp58IKhkPZmk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624429290;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnUvHMWdrLh+xHxnvDtWu1tcx1ayW0aQlPF6eMJ5FiI=;
        b=06xgPcQsZFIbgrVLi81dRVBSIpcnub2UHQp1ypsORIC4RPWlRpzMCbCXIfhay99WpvzMHZ
        nlmmCcdYIOj+3bAQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id RFCMEOnS0mCaYwAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 06:21:29 +0000
Subject: Re: [PATCH 13/14] bcache: read jset from NVDIMM pages for journal
 replay
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-bcache@vger.kernel.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-14-colyli@suse.de>
 <78751d8c-df7f-f5c6-e017-a63eadde8a1c@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <1ca26e76-e8c6-84f4-6176-bc07a08ec120@suse.de>
Date:   Wed, 23 Jun 2021 14:21:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <78751d8c-df7f-f5c6-e017-a63eadde8a1c@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/22/21 7:04 PM, Hannes Reinecke wrote:
> On 6/15/21 7:49 AM, Coly Li wrote:
>> This patch implements two methods to read jset from media for journal
>> replay,
>> - __jnl_rd_bkt() for block device
>>   This is the legacy method to read jset via block device interface.
>> - __jnl_rd_nvm_bkt() for NVDIMM
>>   This is the method to read jset from NVDIMM memory interface, a.k.a
>>   memcopy() from NVDIMM pages to DRAM pages.
>>
>> If BCH_FEATURE_INCOMPAT_NVDIMM_META is set in incompat feature set,
>> during running cache set, journal_read_bucket() will read the journal
>> content from NVDIMM by __jnl_rd_nvm_bkt(). The linear addresses of
>> NVDIMM pages to read jset are stored in sb.d[SB_JOURNAL_BUCKETS], which
>> were initialized and maintained in previous runs of the cache set.
>>
>> A thing should be noticed is, when bch_journal_read() is called, the
>> linear address of NVDIMM pages is not loaded and initialized yet, it
>> is necessary to call __bch_journal_nvdimm_init() before reading the jset
>> from NVDIMM pages.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Jianpeng Ma <jianpeng.ma@intel.com>
>> Cc: Qiaowei Ren <qiaowei.ren@intel.com>
>> ---
>>  drivers/md/bcache/journal.c | 93 +++++++++++++++++++++++++++----------
>>  1 file changed, 69 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
>> index 03ecedf813b0..23e5ccf125df 100644
>> --- a/drivers/md/bcache/journal.c
>> +++ b/drivers/md/bcache/journal.c
>> @@ -34,60 +34,96 @@ static void journal_read_endio(struct bio *bio)
>>  	closure_put(cl);
>>  }
>>  
>> +static struct jset *__jnl_rd_bkt(struct cache *ca, unsigned int bkt_idx,
>> +				    unsigned int len, unsigned int offset,
>> +				    struct closure *cl)
>> +{
>> +	sector_t bucket = bucket_to_sector(ca->set, ca->sb.d[bkt_idx]);
>> +	struct bio *bio = &ca->journal.bio;
>> +	struct jset *data = ca->set->journal.w[0].data;
>> +
>> +	bio_reset(bio);
>> +	bio->bi_iter.bi_sector	= bucket + offset;
>> +	bio_set_dev(bio, ca->bdev);
>> +	bio->bi_iter.bi_size	= len << 9;
>> +	bio->bi_end_io	= journal_read_endio;
>> +	bio->bi_private = cl;
>> +	bio_set_op_attrs(bio, REQ_OP_READ, 0);
>> +	bch_bio_map(bio, data);
>> +
>> +	closure_bio_submit(ca->set, bio, cl);
>> +	closure_sync(cl);
>> +
>> +	/* Indeed journal.w[0].data */
>> +	return data;
>> +}
>> +
>> +#if defined(CONFIG_BCACHE_NVM_PAGES)
>> +
>> +static struct jset *__jnl_rd_nvm_bkt(struct cache *ca, unsigned int bkt_idx,
>> +				     unsigned int len, unsigned int offset)
>> +{
>> +	void *jset_addr = (void *)ca->sb.d[bkt_idx] + (offset << 9);
>> +	struct jset *data = ca->set->journal.w[0].data;
>> +
>> +	memcpy(data, jset_addr, len << 9);
>> +
>> +	/* Indeed journal.w[0].data */
>> +	return data;
>> +}
>> +
>> +#else /* CONFIG_BCACHE_NVM_PAGES */
>> +
>> +static struct jset *__jnl_rd_nvm_bkt(struct cache *ca, unsigned int bkt_idx,
>> +				     unsigned int len, unsigned int offset)
>> +{
>> +	return NULL;
>> +}
>> +
>> +#endif /* CONFIG_BCACHE_NVM_PAGES */
>> +
>>  static int journal_read_bucket(struct cache *ca, struct list_head *list,
>> -			       unsigned int bucket_index)
>> +			       unsigned int bucket_idx)
> This renaming is pointless.

Copied, will revert this in next post.

Thanks for your review.

Coly Li


