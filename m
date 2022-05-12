Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE27524E76
	for <lists+linux-bcache@lfdr.de>; Thu, 12 May 2022 15:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354523AbiELNmA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 May 2022 09:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354525AbiELNl7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 May 2022 09:41:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2476C5D656
        for <linux-bcache@vger.kernel.org>; Thu, 12 May 2022 06:41:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C70B421C75;
        Thu, 12 May 2022 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652362916; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbuER8xzdLnfoXwiSAlwGsCtLIs7A4ho5lInbfwJPd0=;
        b=rYzyF6/BEHK+DWbYpMyUeSSV8Vb24neFKh+pWwoGbTodcZgA65OBnzEsfIbB9VZwtTThH0
        2Yq5Zzlx2GQddAQZo1BImURlV3Jvz0jJyRfyDFe2im+UdYll0FxxwIp+oz7U3+B4PwKvka
        DXWKCw9ieVCnalQJQbExd7IsmgLqUN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652362916;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbuER8xzdLnfoXwiSAlwGsCtLIs7A4ho5lInbfwJPd0=;
        b=NOMMxOeUDZ7opUm5a2+jcGfY0j1KxcmfqaS7wwA+u23DL5eH9cWSY4JOK6vxptEBdLWtqo
        ue06hbofAosBsTBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3944313A84;
        Thu, 12 May 2022 13:41:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6yYhAKMOfWLKPAAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 12 May 2022 13:41:54 +0000
Message-ID: <ecce38e7-8ba0-5fbf-61a6-2dfc21c7793d@suse.de>
Date:   Thu, 12 May 2022 21:41:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v3] bcache: dynamic incremental gc
Content-Language: en-US
To:     mingzhe.zou@easystack.cn
Cc:     dongsheng.yang@easystack.cn, linux-bcache@vger.kernel.org,
        zoumingzhe@qq.com
References: <20220511073903.13568-1-mingzhe.zou@easystack.cn>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220511073903.13568-1-mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/11/22 3:39 PM, mingzhe.zou@easystack.cn wrote:
> From: ZouMingzhe <mingzhe.zou@easystack.cn>
>
> Currently, GC wants no more than 100 times, with at least
> 100 nodes each time, the maximum number of nodes each time
> is not limited.
>
> ```
> static size_t btree_gc_min_nodes(struct cache_set *c)
> {
>          ......
>          min_nodes = c->gc_stats.nodes / MAX_GC_TIMES;
>          if (min_nodes < MIN_GC_NODES)
>                  min_nodes = MIN_GC_NODES;
>
>          return min_nodes;
> }
> ```
>
> According to our test data, when nvme is used as the cache,
> it takes about 1ms for GC to handle each node (block 4k and
> bucket 512k). This means that the latency during GC is at
> least 100ms. During GC, IO performance would be reduced by
> half or more.
>
> I want to optimize the IOPS and latency under high pressure.
> This patch hold the inflight peak. When IO depth up to maximum,
> GC only process very few(10) nodes, then sleep immediately and
> handle these requests.
>
> bch_bucket_alloc() maybe wait for bch_allocator_thread() to
> wake up, and and bch_allocator_thread() needs to wait for gc
> to complete, in which case gc needs to end quickly. So, add
> bucket_alloc_inflight to cache_set in v3.
>
> ```
> long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
> {
>          ......
>          do {
>                  prepare_to_wait(&ca->set->bucket_wait, &w,
>                                  TASK_UNINTERRUPTIBLE);
>
>                  mutex_unlock(&ca->set->bucket_lock);
>                  schedule();
>                  mutex_lock(&ca->set->bucket_lock);
>          } while (!fifo_pop(&ca->free[RESERVE_NONE], r) &&
>                   !fifo_pop(&ca->free[reserve], r));
>          ......
> }
>
> static int bch_allocator_thread(void *arg)
> {
> 	......
> 	allocator_wait(ca, bch_allocator_push(ca, bucket));
> 	wake_up(&ca->set->btree_cache_wait);
> 	wake_up(&ca->set->bucket_wait);
> 	......
> }
>
> static void bch_btree_gc(struct cache_set *c)
> {
> 	......
> 	bch_btree_gc_finish(c);
> 	wake_up_allocators(c);
> 	......
> }
> ```
>
> Apply this patch, each GC maybe only process very few nodes,
> GC would last a long time if sleep 100ms each time. So, the
> sleep time should be calculated dynamically based on gc_cost.
>
> At the same time, I added some cost statistics in gc_stat,
> hoping to provide useful information for future work.


Hi Mingzhe,

 From the first glance, I feel this change may delay the small GC 
period, and finally result a large GC period, which is not expected.

But it is possible that my feeling is incorrect. Do you have detailed 
performance number about both I/O latency  and GC period, then I can 
have more understanding for this effort.

BTW, I will add this patch to my testing set and experience myself.


Thanks.


Coly Li




[snipped]


