Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588B732E2EC
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Mar 2021 08:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhCEH2s (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 5 Mar 2021 02:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCEH2s (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Mar 2021 02:28:48 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5023CC061574;
        Thu,  4 Mar 2021 23:28:48 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id h4so777519pgf.13;
        Thu, 04 Mar 2021 23:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=6Ly9AygsZVxhm/pjR/0AIez7N6QggPomRJyse1qO8wc=;
        b=jBMEHXP45zx0bNYSnJC4mXRwjqZylFAzGUeEn/HeidZQG/sYWhKEOaNZr37/kcdEY4
         E5ZdEczfFPJY2H/PNHDad00g/KibsuK2XLbwE/qiBE7uPWlRgDTNRdWug5Xloi5QubVv
         RmanxvEUbHjD7huU5T2lzpPxjmgsL97QmxbPFUUIGgnWuIqp06UF8r2Snx1nOmfff5w7
         AhfuWF9ghBYFNZVw8NqkHVbCmuymrD3UrihPcxFnkFtOErO8WRD5jIM0Ij7sB2oy1mqU
         G4brt4emQMG0YzylIJb0eqeLDXs3uz97LH7Ou5ppeZXXZQTGapXAmWUCjpqfo78oUR1n
         oVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6Ly9AygsZVxhm/pjR/0AIez7N6QggPomRJyse1qO8wc=;
        b=VbFMloES4SCohQbZCany1nQJ4tiMVi9cOEJI0LuRqBRmdgBlV06Nmh5QvPSZH581pO
         QV2kdo/3Emo4krc0pJtmNstLTwPag9LDTo+DQPlZ8GiiSE+kgH/SgGTTatJMdfKj36UO
         +7LwvlAAU2qGm2kixOYIJZonp/fjk8MLnJVIxZlS8Ce86/jFwohGnQ6WnzNxdaToLwpj
         XnEvbzrgL+yuQXJS/fSvZceO/oktIJvLBGDo58JHPaWWmis2+F+0Tjz6uSVpdtII+55h
         OAzLlzucHSkBWWqymXidQ3mMW2VCETm23JxyEw5UQlsQv8C7jgaChWpjY+Uiin1bRrxs
         PeVw==
X-Gm-Message-State: AOAM5311UeHfdhf0FjC4CShMXfeWb3l7jmElP3bHrIheho4W0tuK2Wob
        Dqgfu1xpatZ/YvAjJwSNtAM=
X-Google-Smtp-Source: ABdhPJw3JPLNS+8Q1VJgrFY8GCjLw9oML5jxwRYwXzwgiGlgtNnox3q/6+dVknDH48alExBd1t1Ogw==
X-Received: by 2002:a63:2321:: with SMTP id j33mr7279208pgj.120.1614929327872;
        Thu, 04 Mar 2021 23:28:47 -0800 (PST)
Received: from [10.69.0.138] ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id y1sm11604958pjr.3.2021.03.04.23.28.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 23:28:47 -0800 (PST)
Subject: Re: [PATCH] md: bcache: fix error return code of
 cached_dev_cache_miss()
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20210305024609.4880-1-baijiaju1990@gmail.com>
 <ee960cbc-352a-cae6-3d57-41dd16249bff@suse.de>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <3324a8b6-51a8-2a06-9d3d-9896ace8ef66@gmail.com>
Date:   Fri, 5 Mar 2021 15:28:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <ee960cbc-352a-cae6-3d57-41dd16249bff@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

Thanks a lot for your detailed explanation :)


Best wishes,
Jia-Ju Bai

On 2021/3/5 12:05, Coly Li wrote:
> On 3/5/21 10:46 AM, Jia-Ju Bai wrote:
>> When bch_bio_alloc_pages() fails, no error return code of
>> cached_dev_cache_miss() is assigned.
>> To fix this bug, ret is assigned with -ENOMEN as error return code.
>>
>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>   drivers/md/bcache/request.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>> index 29c231758293..9ecaf26c8d60 100644
>> --- a/drivers/md/bcache/request.c
>> +++ b/drivers/md/bcache/request.c
>> @@ -930,8 +930,10 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
>>   	cache_bio->bi_private	= &s->cl;
>>   
>>   	bch_bio_map(cache_bio, NULL);
>> -	if (bch_bio_alloc_pages(cache_bio, __GFP_NOWARN|GFP_NOIO))
>> +	if (bch_bio_alloc_pages(cache_bio, __GFP_NOWARN|GFP_NOIO)) {
>> +		ret = -ENOMEM;
>>   		goto out_put;
>> +	}
>>   
>>   	if (reada)
>>   		bch_mark_cache_readahead(s->iop.c, s->d);
>>
> Thanks for looking at bcache :-)
>
> Without the above change, -EINTR will be returned. -EINTR is special in
> bache's btree iteration code. See bcache_btree_root() from bcache.h,
>
> 347 #define bcache_btree_root(fn, c, op, ...)	\
> 348 ({						\
> 349	int _r = -EINTR;			\
> 350	do {					\
> 351		struct btree *_b = (c)->root; 	\
> 352		bool _w = insert_lock(op, _b);	\
> 353		rw_lock(_w, _b, _b->level);	\
> 354		if (_b == (c)->root &&		\
> 355			_w == insert_lock(op, _b)) { \
> 356			_r = bch_btree_ ## fn(_b, op, ##__VA_ARGS__); \
> 357		}				\
> 358	rw_unlock(_w, _b);			\
> 359	bch_cannibalize_unlock(c);		\
> 360	if (_r == -EINTR)			\
> 361						\
> 362	} while (_r == -EINTR);			\
> 363						\
> 364	finish_wait(&(c)->btree_cache_wait, &(op)->wait); \
> 365	_r;					\
> 366 })
>
> cached_dev_cache_miss() is called by the following code path,
>
> cache_lookup() ==> bch_btree_map_keys() ==> bcache_btree_root() ==>
> bch_btree_map_keys_recurse() ==> cache_lookup_fn()
>
> Therefore the return value of cached_dev_cache_miss() will be returned
> from where s->d->cache_miss() is called from cache_lookup_fn(). And in
> macro bcache_btree_root() this return value will be checked. If the
> return value is -EINTR, then the whole iteration will be re-do again.
>
> Returning -ENOMEM works but if the memory allocation failed, there is no
> chance to re-do the cache lookup again from bcache_btree_root(). When
> system memory is in heavy usage, we want the lookup to try more times
> (because GFP_NOIO is set), which is much better then returning -EIO
> immediately to caller.
>
> Therefore NOT setting ret to -ENOMEM in the patching location should be
> an on-purpose coding, IMHO.
>
> Thanks.
>
> Coly Li
>

