Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A1A3B13BD
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 08:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFWGMI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 02:12:08 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43080 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWGMH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 02:12:07 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2EB942195A;
        Wed, 23 Jun 2021 06:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624428590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9mP6V0oY2WyQvvX8MU3rQidOjEB8I6+aYTVfOe4iRlw=;
        b=Z9a/FzLIheDcG2ZBXqGuxerIodtBM23zwpFL3dNyDegc0rQ/J8dUPmZvaSIGQcpr7SfIuT
        lx4/gGTvU0cFW137tBApesJLUQl3KONOh6BFYrej6fw+vDEnMsF20o4daeMJuaXkRPog8/
        zQRfvJPfQKd+aKAsMxhiLrjToi4LTH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624428590;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9mP6V0oY2WyQvvX8MU3rQidOjEB8I6+aYTVfOe4iRlw=;
        b=nzGkIX4cZatOrBUErxFn7lFVKkD+wYq56WASSrLUU37b6u1vcAmyB40Y0wKXNpDhaLwxlH
        hOtN05fYCequV+BQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id A9AAD11A97;
        Wed, 23 Jun 2021 06:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624428590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9mP6V0oY2WyQvvX8MU3rQidOjEB8I6+aYTVfOe4iRlw=;
        b=Z9a/FzLIheDcG2ZBXqGuxerIodtBM23zwpFL3dNyDegc0rQ/J8dUPmZvaSIGQcpr7SfIuT
        lx4/gGTvU0cFW137tBApesJLUQl3KONOh6BFYrej6fw+vDEnMsF20o4daeMJuaXkRPog8/
        zQRfvJPfQKd+aKAsMxhiLrjToi4LTH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624428590;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9mP6V0oY2WyQvvX8MU3rQidOjEB8I6+aYTVfOe4iRlw=;
        b=nzGkIX4cZatOrBUErxFn7lFVKkD+wYq56WASSrLUU37b6u1vcAmyB40Y0wKXNpDhaLwxlH
        hOtN05fYCequV+BQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id zlwPHizQ0mCqXgAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 06:09:48 +0000
Subject: Re: [PATCH 10/14] bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into
 incompat feature set
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-bcache@vger.kernel.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-11-colyli@suse.de>
 <f49f2939-5cd6-6741-f53e-b1c0473bc686@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <84d6de75-aba1-d0e4-65b5-69c259df1fdf@suse.de>
Date:   Wed, 23 Jun 2021 14:09:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f49f2939-5cd6-6741-f53e-b1c0473bc686@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/22/21 6:59 PM, Hannes Reinecke wrote:
> On 6/15/21 7:49 AM, Coly Li wrote:
>> This patch adds BCH_FEATURE_INCOMPAT_NVDIMM_META (value 0x0004) into the
>> incompat feature set. When this bit is set by bcache-tools, it indicates
>> bcache meta data should be stored on specific NVDIMM meta device.
>>
>> The bcache meta data mainly includes journal and btree nodes, when this
>> bit is set in incompat feature set, bcache will ask the nvm-pages
>> allocator for NVDIMM space to store the meta data.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Jianpeng Ma <jianpeng.ma@intel.com>
>> Cc: Qiaowei Ren <qiaowei.ren@intel.com>
>> ---
>>  drivers/md/bcache/features.h | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
>> index d1c8fd3977fc..45d2508d5532 100644
>> --- a/drivers/md/bcache/features.h
>> +++ b/drivers/md/bcache/features.h
>> @@ -17,11 +17,19 @@
>>  #define BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET		0x0001
>>  /* real bucket size is (1 << bucket_size) */
>>  #define BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE	0x0002
>> +/* store bcache meta data on nvdimm */
>> +#define BCH_FEATURE_INCOMPAT_NVDIMM_META		0x0004
>>  
>>  #define BCH_FEATURE_COMPAT_SUPP		0
>>  #define BCH_FEATURE_RO_COMPAT_SUPP	0
>> +#if defined(CONFIG_BCACHE_NVM_PAGES)
>> +#define BCH_FEATURE_INCOMPAT_SUPP	(BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET| \
>> +					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE| \
>> +					 BCH_FEATURE_INCOMPAT_NVDIMM_META)
>> +#else
>>  #define BCH_FEATURE_INCOMPAT_SUPP	(BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET| \
>>  					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE)
>> +#endif
>>  
>>  #define BCH_HAS_COMPAT_FEATURE(sb, mask) \
>>  		((sb)->feature_compat & (mask))
>> @@ -89,6 +97,7 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
>>  
>>  BCH_FEATURE_INCOMPAT_FUNCS(obso_large_bucket, OBSO_LARGE_BUCKET);
>>  BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LOG_LARGE_BUCKET_SIZE);
>> +BCH_FEATURE_INCOMPAT_FUNCS(nvdimm_meta, NVDIMM_META);
>>  
>>  static inline bool bch_has_unknown_compat_features(struct cache_sb *sb)
>>  {
>>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks for your review.

Coly Li
