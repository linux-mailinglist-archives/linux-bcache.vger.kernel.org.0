Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E999304429
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 18:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbhAZGBe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Jan 2021 01:01:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:45500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbhAZEe5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Jan 2021 23:34:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3948AAD78;
        Tue, 26 Jan 2021 04:34:15 +0000 (UTC)
Subject: Re: [PATCH] bcache: dont reset bio opf in bch_data_insert_start
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
References: <20210125042942.1087170-1-dongsheng.yang@easystack.cn>
 <7569abf3-3e54-986e-8307-751fa5e00828@suse.de>
 <17578d50-4113-8f25-827e-840fafb09d6f@easystack.cn>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchristi@redhat.com
From:   Coly Li <colyli@suse.de>
Message-ID: <92c66f2d-22af-abd7-6fcb-ad896185c0c6@suse.de>
Date:   Tue, 26 Jan 2021 12:34:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <17578d50-4113-8f25-827e-840fafb09d6f@easystack.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/26/21 12:32 PM, Dongsheng Yang wrote:
> 
> 在 2021/1/25 星期一 下午 12:53, Coly Li 写道:
>> On 1/25/21 12:29 PM, Dongsheng Yang wrote:
>>> commit ad0d9e76(bcache: use bio op accessors) makes the bi_opf
>>> modified by bio_set_op_attrs(). But there is a logical
>>> problem in this commit:
>>>
>>>                  trace_bcache_cache_insert(k);
>>>                  bch_keylist_push(&op->insert_keys);
>>>
>>> -               n->bi_rw |= REQ_WRITE;
>>> +               bio_set_op_attrs(n, REQ_OP_WRITE, 0);
>>>                  bch_submit_bbio(n, op->c, k, 0);
>>>          } while (n != bio);
>>>
>>> The old code add REQ_WRITE into bio n and keep other flags; the
>>> new code set REQ_OP_WRITE to bi_opf, but reset all other flags.
>>>
>>> This problem is discoverd in our performance testing:
>>> (1) start a fio with 1M x 128depth for read in /dev/nvme0n1p1
>>> (2) start a fio with 1M x 128depth for write in /dev/escache0 (cache
>>> device is /dev/nvme0n1p2)
>>>
>>> We found the BW of reading is 2000+M/s, but the BW of writing is
>>> 0-100M/s. After some debugging, we found the problem is io submit in
>>> writting is very slow.
>>>
>>> bch_data_insert_start() insert a bio to /dev/nvme0n1p1, but as
>>> cached_dev submit stack bio will be added into current->bio_list, and
>>> return.Then __submit_bio_noacct() will submit the new bio in bio_list
>>> into /dev/nvme0n1p1. This operation would be slow in
>>> blk_mq_submit_bio() -> rq_qos_throttle(q, bio);
>>>
>>> The rq_qos_throttle() will call wbt_should_throttle(),
>>> static inline bool wbt_should_throttle(struct rq_wb *rwb, struct bio
>>> *bio)
>>> {
>>>          switch (bio_op(bio)) {
>>>          case REQ_OP_WRITE:
>>>                  /*
>>>                   * Don't throttle WRITE_ODIRECT
>>>                   */
>>>                  if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) ==
>>>                      (REQ_SYNC | REQ_IDLE))
>>>                          return false;
>>> ... ...
>>> }
>>>
>>> As the bio_set_op_attrs() reset the (REQ_SYNC | REQ_IDLE), so this write
>>> bio will be considered as non-direct write.
>>>
>>> After this fix, bio to nvme will flaged as (REQ_SYNC | REQ_IDLE),
>>> then fio for writing will get about 1000M/s bandwidth.
>>>
>>> Fixes: ad0d9e76a4124708dddd00c04fc4b56fc86c02d6
>> It should be,
>> Fixes: ad0d9e76a412 ("bcache: use bio op accessors")
>>
>>> Signed-off-by: Dongsheng Yang<dongsheng.yang@easystack.cn>
>> Please CC the fixed patch author  Mike Christie<mchristi@redhat.com>.
> 
> 
> Hi Coly,
> 
>     Should I send a V2 for commit message update?
> 
> Or you can help to fix it when you take it from maillist?
> 

Yes, please fix it in v2 version. And let's wait for response from Mike,
maybe he has better suggestion to fix.

Thanks.

Coly Li

