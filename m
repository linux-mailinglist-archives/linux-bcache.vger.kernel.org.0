Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A6C73CA9A
	for <lists+linux-bcache@lfdr.de>; Sat, 24 Jun 2023 13:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbjFXLSC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 24 Jun 2023 07:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbjFXLR6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 24 Jun 2023 07:17:58 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A72F2101
        for <linux-bcache@vger.kernel.org>; Sat, 24 Jun 2023 04:17:29 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b5585e84b4so2535825ad.0
        for <linux-bcache@vger.kernel.org>; Sat, 24 Jun 2023 04:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687605449; x=1690197449;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T15O6xQIwkBwwHtvfiEExn4sWPaOJ+WY8Ww0WTBtsp8=;
        b=CYbPeV4zw+1THiloHL2+ypjCEv/Id/OqdEvK4Gbzyx+byuca+5y6cAMB03scGpNQnd
         SSB/7Anoxb0IyXh7PuVlGbhgdQdF/LJkm6iAy37RUchzkDnhJHkx6mrv3F5vKgoyQyPy
         OIasGq/04a4yIeBx66N81aJ+oDLEzr/c57Z4snA4iQkl0+r7Z1fxQw1D3B6O1TLBBXtU
         +6bRquokuMgWUCPSNTKWaKx0RTO9dV5TrEkx6qXy9qwlyog+mmdaA1jG00RymxjmBaI/
         eUJ0hTbMfoOPJPyWkTS38C3ZPCIA3M/x6cjkzBrGwhlDHNcmA3/i0KhFITfJt8SeOUy8
         iVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687605449; x=1690197449;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T15O6xQIwkBwwHtvfiEExn4sWPaOJ+WY8Ww0WTBtsp8=;
        b=L+Q0+b3/zpUbq7ZbohFY5VpN9fiI+C/H/GmhQjqWC4mRXMqqXfn2MqjzjngB5nrnLU
         6sSqUkWDOiMKnSEHUQRLVZq/cITotfYfcON4jfj2JjDnbhRZs3v8ytL3kQOKs7nKEriB
         BZkVEdxwGf4sHT8/baf2jx2mL9//Ppn8H2z5qds81pGn+JxgcQTluf1cYKcFUv/1w0vT
         pi+dwAXCmbEWnrzVQFQAiIDVHZiZUg0eotb6sjo3ago0RVGT0STezzn/lAjiroopRkix
         wVk6XLBFiKV+1cT5O6ma7hb7aJJpNiDkKmRMlV9ZZ/auOLweNLx42XtAkbvTqVbwWrbo
         jDIw==
X-Gm-Message-State: AC+VfDyVksQVPI7ghzdjZFj7K5Io1QsBd6vg/HNA9fcRcbwvnK4ocMJd
        Ku9rDqcXXaJUNd4Hm4R+VpmFIg==
X-Google-Smtp-Source: ACHHUZ6FdOiaHAk7I6ISkFgljzCcZyK3aCzvXyKEVanrKS23oGi4259EOvC6Ypj8Kzv6/iuF/wHf7Q==
X-Received: by 2002:a17:902:ecc6:b0:1ae:1364:6086 with SMTP id a6-20020a170902ecc600b001ae13646086mr29288550plh.2.1687605448727;
        Sat, 24 Jun 2023 04:17:28 -0700 (PDT)
Received: from [10.4.162.153] ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id c13-20020a170902d48d00b001ab0a30c895sm1034090plg.202.2023.06.24.04.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jun 2023 04:17:28 -0700 (PDT)
Message-ID: <8107f6d1-2f86-46f1-2b31-263928499ab6@bytedance.com>
Date:   Sat, 24 Jun 2023 19:17:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 15/29] NFSD: dynamically allocate the nfsd-client shrinker
Content-Language: en-US
To:     Chuck Lever <cel@kernel.org>
Cc:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-mm@kvack.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-16-zhengqi.arch@bytedance.com>
 <ZJYTbnmRKF7j3CHW@manet.1015granger.net>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <ZJYTbnmRKF7j3CHW@manet.1015granger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Chuck,

On 2023/6/24 05:49, Chuck Lever wrote:
> On Thu, Jun 22, 2023 at 04:53:21PM +0800, Qi Zheng wrote:
>> In preparation for implementing lockless slab shrink,
>> we need to dynamically allocate the nfsd-client shrinker,
>> so that it can be freed asynchronously using kfree_rcu().
>> Then it doesn't need to wait for RCU read-side critical
>> section when releasing the struct nfsd_net.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> For 15/29 and 16/29 of this series:
> 
> Acked-by: Chuck Lever <chuck.lever@oracle.com>

Thanks for your review! :)

And I will implement the APIs suggested by Dave in 02/29 in
the v2, so there will be some changes here, but it should
not be much. So I will keep your Acked-bys in the v2.

Thanks,
Qi

> 
> 
>> ---
>>   fs/nfsd/netns.h     |  2 +-
>>   fs/nfsd/nfs4state.c | 20 ++++++++++++--------
>>   2 files changed, 13 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
>> index ec49b200b797..f669444d5336 100644
>> --- a/fs/nfsd/netns.h
>> +++ b/fs/nfsd/netns.h
>> @@ -195,7 +195,7 @@ struct nfsd_net {
>>   	int			nfs4_max_clients;
>>   
>>   	atomic_t		nfsd_courtesy_clients;
>> -	struct shrinker		nfsd_client_shrinker;
>> +	struct shrinker		*nfsd_client_shrinker;
>>   	struct work_struct	nfsd_shrinker_work;
>>   };
>>   
>> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
>> index 6e61fa3acaf1..a06184270548 100644
>> --- a/fs/nfsd/nfs4state.c
>> +++ b/fs/nfsd/nfs4state.c
>> @@ -4388,8 +4388,7 @@ static unsigned long
>>   nfsd4_state_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
>>   {
>>   	int count;
>> -	struct nfsd_net *nn = container_of(shrink,
>> -			struct nfsd_net, nfsd_client_shrinker);
>> +	struct nfsd_net *nn = shrink->private_data;
>>   
>>   	count = atomic_read(&nn->nfsd_courtesy_clients);
>>   	if (!count)
>> @@ -8094,14 +8093,19 @@ static int nfs4_state_create_net(struct net *net)
>>   	INIT_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
>>   	get_net(net);
>>   
>> -	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
>> -	nn->nfsd_client_shrinker.count_objects = nfsd4_state_shrinker_count;
>> -	nn->nfsd_client_shrinker.seeks = DEFAULT_SEEKS;
>> -
>> -	if (register_shrinker(&nn->nfsd_client_shrinker, "nfsd-client"))
>> +	nn->nfsd_client_shrinker = shrinker_alloc_and_init(nfsd4_state_shrinker_count,
>> +							   nfsd4_state_shrinker_scan,
>> +							   0, DEFAULT_SEEKS, 0,
>> +							   nn);
>> +	if (!nn->nfsd_client_shrinker)
>>   		goto err_shrinker;
>> +
>> +	if (register_shrinker(nn->nfsd_client_shrinker, "nfsd-client"))
>> +		goto err_register;
>>   	return 0;
>>   
>> +err_register:
>> +	shrinker_free(nn->nfsd_client_shrinker);
>>   err_shrinker:
>>   	put_net(net);
>>   	kfree(nn->sessionid_hashtbl);
>> @@ -8197,7 +8201,7 @@ nfs4_state_shutdown_net(struct net *net)
>>   	struct list_head *pos, *next, reaplist;
>>   	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
>>   
>> -	unregister_shrinker(&nn->nfsd_client_shrinker);
>> +	unregister_and_free_shrinker(nn->nfsd_client_shrinker);
>>   	cancel_work(&nn->nfsd_shrinker_work);
>>   	cancel_delayed_work_sync(&nn->laundromat_work);
>>   	locks_end_grace(&nn->nfsd4_manager);
>> -- 
>> 2.30.2
>>
