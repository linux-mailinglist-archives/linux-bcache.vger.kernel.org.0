Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F9339B7B
	for <lists+linux-bcache@lfdr.de>; Sat,  8 Jun 2019 09:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfFHHLc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 8 Jun 2019 03:11:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:43550 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfFHHLb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 8 Jun 2019 03:11:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECCD3AEA0;
        Sat,  8 Jun 2019 07:11:29 +0000 (UTC)
Subject: Re: Critical bug on bcache kernel module in Fedora 30
To:     Rolf Fokkens <rolf@rolffokkens.nl>, Nix <nix@esperi.org.uk>
Cc:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com,
        Pierre JUHEN <pierre.juhen@orange.fr>
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
 <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
 <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
 <cbd597ad-ed21-34ef-1fec-03fa943fd704@orange.fr>
 <cefbcdf6-6ab6-6ab0-8afa-bcd4d85401a5@suse.de>
 <9fc7c451-0507-b5c3-efc8-ab1baf7a1d44@suse.de> <878suzfk4a.fsf@esperi.org.uk>
 <3340607a-bb62-0bc6-420f-8338283d31d7@rolffokkens.nl>
 <5d3209f4-25f1-723c-13e1-a639071964a6@rolffokkens.nl>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <429373e0-6c17-0d56-6f7d-0c191ccaa9ae@suse.de>
Date:   Sat, 8 Jun 2019 15:11:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <5d3209f4-25f1-723c-13e1-a639071964a6@rolffokkens.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/8 5:52 上午, Rolf Fokkens wrote:
> Some potential progress: https://bugzilla.kernel.org/show_bug.cgi?id=203573
> 
> On 5/30/19 2:50 PM, Rolf Fokkens wrote:
>> Not being sure if people here follow the issue at Fedora I'd like to
>> pass a suggestion:
>> https://bugzilla.redhat.com/show_bug.cgi?id=1708315#c27
>>
>> On 5/22/19 1:44 AM, Nix wrote:
>>> On 21 May 2019, Coly Li uttered the following:
>>>> Also I try to analyze the assemble code of bcache, just find out the
>>>> generated assembly code between gcc9 and gcc7 is quite different. For
>>>> gcc9 there is a XXXX.cold part. So far I can not tell where the problem
>>>> is from yet.
>>> This is hot/cold partitioning. You can turn it off with
>>> -fno-reorder-blocks-and-partition and see if that helps things (and if
>>> it doesn't, it should at least make stuff easier to compare).

Hi folks,

From the above bugzilla.kernel.org links, it seems people are all on the
same/correct track :-)

I don't analyze the assembly code, because I can stably reproduce the
problem: two adjacent keys don't merge. And I find the problem is from
macro PRECEDING_KEY(), which misleading bch_btree_insert_key() when it
calls bch_btree_iter_init(). Misleading means returned 'm' always
indicates the inserting key is the first key in the btree node because
prev in the while-loop is NULL.

For the second adjacent key, obviously prev point should not be NULL, so
the suspicious point is PRECEDING_KEY(), its code is,
437 #define PRECEDING_KEY(_k)                                       \
438 ({                                                              \
439         struct bkey *_ret = NULL;                               \
440                                                                 \
441         if (KEY_INODE(_k) || KEY_OFFSET(_k)) {                  \
442                 _ret = &KEY(KEY_INODE(_k), KEY_OFFSET(_k), 0);  \
443                                                                 \
444                 if (!_ret->low)                                 \
445                         _ret->high--;                           \
446                 _ret->low--;                                    \
447         }                                                       \
448                                                                 \
449         _ret;                                                   \
450 })

The problem is at line 442, KEY() announced a on-stack temporary
variable in struct bkey {high = KEY_INODE(_k), low = KEY_OFFSET(_k), ptr
= NULL}. But its life range is in line 442-447. When address of this
on-stack variable returns from PRECEDING_KEY() and sent into
bch_btree_iter_init(), this stack space of this on-stack variable is
overwritten by stackframe of bch_btree_iter_init().

To confirm the above suspicion, I modify bch_btree_insert_key() to not
use PRECEDING_KEY(), and store the preceding key in a local variable of
bch_btree_insert_key() like this,

@@ -884,27 +894,78 @@ unsigned int bch_btree_insert_key(struct
btree_keys *b, struct bkey *k,
        struct bset *i = bset_tree_last(b)->data;
        struct bkey *m, *prev = NULL;
        struct btree_iter iter;
+       struct bkey preceding_key = ZERO_KEY;
+       struct bkey *preceding_key_p = NULL;

        BUG_ON(b->ops->is_extents && !KEY_SIZE(k));

-       m = bch_btree_iter_init(b, &iter, b->ops->is_extents
-                               ? PRECEDING_KEY(&START_KEY(k))
-                               : PRECEDING_KEY(k));
+
+       if (b->ops->is_extents) {
+               struct bkey tmp_k;
+               tmp_k = START_KEY(k);
+               if (KEY_INODE(&tmp_k) || KEY_OFFSET(&tmp_k)) {
+                       preceding_key = KEY(KEY_INODE(&tmp_k),
KEY_OFFSET(&tmp_k), 0);
+
+                       if (!preceding_key.low)
+                               preceding_key.high--;
+                       preceding_key.low--;
+               }
+               preceding_key_p = &preceding_key;
+       } else {
+               if (KEY_INODE(k) || KEY_OFFSET(k)) {
+                       preceding_key = KEY(KEY_INODE(k), KEY_OFFSET(k), 0);
+                       if (!preceding_key.low)
+                               preceding_key.high--;
+                       preceding_key.low--;
+               }
+               preceding_key_p = &preceding_key;
+       }
+
+       m = bch_btree_iter_init(b, &iter, preceding_key_p);

Now I can see the preceding key is reported and adjacent keys can be
merged. So far my simple fio testing works fine, but I need to go
through all locations where KEY() and PROCEDING_KEY() are used and find
a proper way to fix.

As I guessed this is a bcache bug and triggered by gcc9. I have no clear
idea why it works fine before (maybe depends on some compiling option
?), but definitely this code should be fixed.

Thanks.

-- 

Coly Li
