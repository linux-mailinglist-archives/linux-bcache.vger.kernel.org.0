Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E284F3072EA
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jan 2021 10:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhA1Jjn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 04:39:43 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:19530 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbhA1Jg7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 04:36:59 -0500
X-Greylist: delayed 1545 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2021 04:36:56 EST
Received: from [192.168.122.37] (unknown [218.94.118.90])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 76012417F3;
        Thu, 28 Jan 2021 17:10:18 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [PATCH] bcache: dont reset bio opf in bch_data_insert_start
To:     Christoph Hellwig <hch@infradead.org>
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, mchristi@redhat.com
References: <20210125042942.1087170-1-dongsheng.yang@easystack.cn>
 <20210127173726.GA1738577@infradead.org>
Message-ID: <e360e24b-7c6e-f7b3-ee59-e4f9d7dd3576@easystack.cn>
Date:   Thu, 28 Jan 2021 17:10:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210127173726.GA1738577@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTEhMSUpNTkpOTRlLVkpNSkpDSU5LSkNDSk1VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hNSlVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MDY6Hzo*Sz00Pg8DGhgZAiEj
        CC9PCxpVSlVKTUpKQ0lOS0pCS0pNVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSExKQzcG
X-HM-Tid: 0a774841f7202086kuqy76012417f3
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Christop:

在 2021/1/28 星期四 上午 1:37, Christoph Hellwig 写道:
> But the old code is also completely broken.  We can't just OR in
> the op, as that implicitly assumes the old op was 0 (REQ_OP_READ).


Yes, indeed, there is an assume that the op is just possible to be 0 
(REQ_OP_READ) or 1 (REQ_OP_WRITE).

REQ_OP_WRITE is from cached_dev_submit_bio() which would be submitted by 
upper user.

REQ_OP_READ is from bcache itself, such as cached_dev_read_done() (when 
we found cache miss, we will read

data from backing and then we want to insert it into cache device. then 
there is a read bio with data reach here, we

need to set the bio_op to REQ_OP_WRITE, and send this bio to cache device).

> Please fix this to explicitly set the exact op and flags that you want
> instead of this fragile magic.blk_rq_map_kern

This commit only want to fix the logic bug introduced in ad0d9e76a412 
("bcache: use bio op accessors"),

that's more likely a partial revert.


I agree that we can make it more clearly and explicitly.

But I found there is no accessor to set op only, besides, the 
bio_set_op_attrs() was marked as obsolete.

There are some others doing similar things as below:

blk_rq_map_kern():

bio->bi_opf &= ~REQ_OP_MASK;

bio->bi_opf |= req_op(rq);


So what about below:

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index c7cadaafa947..bacc7366002f 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -244,7 +244,14 @@ static void bch_data_insert_start(struct closure *cl)
                 trace_bcache_cache_insert(k);
                 bch_keylist_push(&op->insert_keys);

-               bio_set_op_attrs(n, REQ_OP_WRITE, 0);
+               /*
+                * n here would be REQ_OP_READ, if
+                * we are inserting data read from
+                * backing device in cache miss or
+                * inserting data in movinggc.
+                */
+               n->bi_opf &= ~REQ_OP_MASK;
+               n->bi_opf |= REQ_OP_WRITE;
                 bch_submit_bbio(n, op->c, k, 0);
         } while (n != bio);


Thanx

Yang

