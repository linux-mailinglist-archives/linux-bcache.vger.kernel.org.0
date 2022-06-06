Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4C453E865
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jun 2022 19:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiFFJgh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jun 2022 05:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiFFJgd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jun 2022 05:36:33 -0400
Received: from mail-m2836.qiye.163.com (mail-m2836.qiye.163.com [103.74.28.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A749B1BF166
        for <linux-bcache@vger.kernel.org>; Mon,  6 Jun 2022 02:36:32 -0700 (PDT)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id BB2BEC02A1;
        Mon,  6 Jun 2022 17:36:29 +0800 (CST)
Message-ID: <34d760d4-9d1b-7ec0-af90-3c8777fbe971@easystack.cn>
Date:   Mon, 6 Jun 2022 17:36:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] bcache: try to reuse the slot of invalid_uuid
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, dongsheng.yang@easystack.cn,
        zoumingzhe@qq.com
References: <20220606084522.12680-1-mingzhe.zou@easystack.cn>
 <780B6E6E-F4A8-4801-AED3-8DF81054D491@suse.de>
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <780B6E6E-F4A8-4801-AED3-8DF81054D491@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUNCTk1WHU9JQ0xDTxpPTk
        JJVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktITkhVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OFE6Nww6MDIVUSkJLRIzEEsB
        Vg4KCRFVSlVKTU5PTktDSkJLSElIVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTktOTTcG
X-HM-Tid: 0a81385f78c9841ekuqwbb2bec02a1
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


在 2022/6/6 16:57, Coly Li 写道:
>
>> 2022年6月6日 16:45，mingzhe.zou@easystack.cn 写道：
>>
>> From: mingzhe <mingzhe.zou@easystack.cn>
>>
>>
> [snipped]
>
>> We want to use those invalid_uuid slots carefully. Because, the bkey of the inode
>> may still exist in the btree. So, we need to check the btree before reuse it.
>>
>> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
>> ---
>> drivers/md/bcache/btree.c | 35 +++++++++++++++++++++++++++++++++++
>> drivers/md/bcache/btree.h |  1 +
>> drivers/md/bcache/super.c | 15 ++++++++++++++-
>> 3 files changed, 50 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> index e136d6edc1ed..a5d54af73111 100644
>> --- a/drivers/md/bcache/btree.c
>> +++ b/drivers/md/bcache/btree.c
>> @@ -2755,6 +2755,41 @@ struct keybuf_key *bch_keybuf_next_rescan(struct cache_set *c,
>> 	return ret;
>> }
>>
>> +static bool check_pred(struct keybuf *buf, struct bkey *k)
>> +{
>> +	return true;
>> +}
>> +
>> +bool bch_btree_can_inode_reuse(struct cache_set *c, size_t inode)
>> +{
>> +	bool ret = true;
>> +	struct keybuf_key *k;
>> +	struct bkey end_key = KEY(inode, MAX_KEY_OFFSET, 0);
>> +	struct keybuf *keys = kzalloc(sizeof(struct keybuf), GFP_KERNEL);
>> +
>> +	if (!keys) {
>> +		ret = false;
>> +		goto out;
>> +	}
>> +
>> +	bch_keybuf_init(keys);
>> +	keys->last_scanned = KEY(inode, 0, 0);
>> +
>> +	while (ret) {
>> +		k = bch_keybuf_next_rescan(c, keys, &end_key, check_pred);
>> +		if (!k)
>
> This is a single thread iteration, for a large filled cache device it can be very slow. I observed 40+ minutes during my testing.
>
>
> Coly Li
>
Hi, Coly
We first use the zero_uuid slot, and reuse only if there is no zero_uuid 
slot. This is just an imperfect solution to make bcache available, so we 
haven't tested its performance. We think we will eventually need to 
actively clean up these bkeys in a new thread and reset the invalid_uuid 
to zero_uuid.
mingzhe
>
>> +			break;
>> +
>> +		if (KEY_INODE(&k->key) == inode)
>> +			ret = false;
>> +		bch_keybuf_del(keys, k);
>> +	}
>> +
>> +	kfree(keys);
>> +out:
>> +	return ret;
>> +}
>> +
>> void bch_keybuf_init(struct keybuf *buf)
>> {
>> 	buf->last_scanned	= MAX_KEY;
>> diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
>> index 1b5fdbc0d83e..c3e6094adb62 100644
>> --- a/drivers/md/bcache/btree.h
>> +++ b/drivers/md/bcache/btree.h
>> @@ -413,4 +413,5 @@ struct keybuf_key *bch_keybuf_next_rescan(struct cache_set *c,
>> 					  struct bkey *end,
>> 					  keybuf_pred_fn *pred);
>> void bch_update_bucket_in_use(struct cache_set *c, struct gc_stat *stats);
>> +bool bch_btree_can_inode_reuse(struct cache_set *c, size_t inode);
>> #endif
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 3563d15dbaf2..31f7aa347561 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -544,11 +544,24 @@ static struct uuid_entry *uuid_find(struct cache_set *c, const char *uuid)
>> 	return NULL;
>> }
>>
>> +static struct uuid_entry *uuid_find_reuse(struct cache_set *c)
>> +{
>> +	struct uuid_entry *u;
>> +
>> +	for (u = c->uuids; u < c->uuids + c->nr_uuids; u++)
>> +		if (!memcmp(u->uuid, invalid_uuid, 16) &&
>> +		    bch_btree_can_inode_reuse(c, u - c->uuids))
>> +			return u;
>> +
>> +	return NULL;
>> +}
>> +
>> static struct uuid_entry *uuid_find_empty(struct cache_set *c)
>> {
>> 	static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
>> +	struct uuid_entry *u = uuid_find(c, zero_uuid);
>>
>> -	return uuid_find(c, zero_uuid);
>> +	return u ? u : uuid_find_reuse(c);
>> }
>>
>> /*
>> -- 
>> 2.17.1
>>
>
