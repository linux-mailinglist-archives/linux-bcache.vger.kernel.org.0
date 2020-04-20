Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0A61B01FB
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Apr 2020 08:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgDTGzw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 20 Apr 2020 02:55:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45398 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbgDTGzv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 20 Apr 2020 02:55:51 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BCF396C3F37183F6F41D;
        Mon, 20 Apr 2020 14:55:49 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.235) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Apr 2020
 14:55:39 +0800
Subject: Re: bcache: unlock new_nodes[i]->write_lock in btree_gc_coalesce
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
To:     <colyli@suse.de>, <kmo@daterainc.com>,
        <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "wubo (T)" <wubo40@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>,
        Yanxiaodan <yanxiaodan@huawei.com>,
        linfeilong <linfeilong@huawei.com>
References: <f4a66326-5ac5-7089-a570-0e02ad3093fa@huawei.com>
Message-ID: <c913f4bb-cbae-d8e5-e8cb-a3a527392b00@huawei.com>
Date:   Mon, 20 Apr 2020 14:55:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f4a66326-5ac5-7089-a570-0e02ad3093fa@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.215.235]
X-CFilter-Loop: Reflected
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

friendly ping...

On 2020/4/15 19:42, Zhiqiang Liu wrote:
> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> 
> coccicheck reports:
>   drivers/md//bcache/btree.c:1538:1-7: preceding lock on line 1417
> 
> After obtaining new_nodes[i]->write_lock, we may go to out_nocoalesce
> tag without releasing lock. Here, we add a new tag
> 'out_unlock_nocoalesce' before out_nocoalesce tag to release
> new_nodes[i]->write_lock.
> 
> Fixes: 2a285686c1 ("bcache: btree locking rework")
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  drivers/md/bcache/btree.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index fa872df4e770..cad8b0b97e33 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1447,7 +1447,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
>  			if (__set_blocks(n1, n1->keys + n2->keys,
>  					 block_bytes(b->c)) >
>  			    btree_blocks(new_nodes[i]))
> -				goto out_nocoalesce;
> +				goto out_unlock_nocoalesce;
> 
>  			keys = n2->keys;
>  			/* Take the key of the node we're getting rid of */
> @@ -1476,7 +1476,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
> 
>  		if (__bch_keylist_realloc(&keylist,
>  					  bkey_u64s(&new_nodes[i]->key)))
> -			goto out_nocoalesce;
> +			goto out_unlock_nocoalesce;
> 
>  		bch_btree_node_write(new_nodes[i], &cl);
>  		bch_keylist_add(&keylist, &new_nodes[i]->key);
> @@ -1522,6 +1522,10 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
>  	/* Invalidated our iterator */
>  	return -EINTR;
> 
> +out_unlock_nocoalesce:
> +	for (i = 0; i < nodes; i++)
> +		mutex_unlock(&new_nodes[i]->write_lock);
> +
>  out_nocoalesce:
>  	closure_sync(&cl);
> 

