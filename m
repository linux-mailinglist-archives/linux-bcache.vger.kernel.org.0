Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45DC73AC57
	for <lists+linux-bcache@lfdr.de>; Mon, 10 Jun 2019 00:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbfFIWQJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 9 Jun 2019 18:16:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:36962 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729304AbfFIWQJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 9 Jun 2019 18:16:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7BBA1ADD2;
        Sun,  9 Jun 2019 22:16:07 +0000 (UTC)
Subject: Re: [PATCH V2] bcache: fix stack corruption by PRECEDING_KEY()
To:     Pierre JUHEN <pierre.juhen@orange.fr>
Cc:     linux-bcache@vger.kernel.org, Rolf Fokkens <rolf@rolffokkens.nl>,
        linux-block@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>
References: <20190609152400.18887-1-colyli@suse.de>
 <58eef1e0-b5d7-a3f7-8d59-4ef5117ce5fe@suse.de>
 <2968c6b5-9f14-73ff-0571-5d9710a023d0@orange.fr>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <4883fcc1-f988-d58f-6338-21dff2c562b9@suse.de>
Date:   Mon, 10 Jun 2019 06:15:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <2968c6b5-9f14-73ff-0571-5d9710a023d0@orange.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/10 1:52 上午, Pierre JUHEN wrote:
> I tested a patched  bcache module. OK for me.

hi Pierre,

Cool, thank you!

Coly Li

> 
> Le 09/06/2019 à 17:28, Coly Li a écrit :
>> On 2019/6/9 11:24 下午, Coly Li wrote:
>>> Recently people report bcache code compiled with gcc9 is broken, one of
>>> the buggy behavior I observe is that two adjacent 4KB I/Os should merge
>>> into one but they don't. Finally it turns out to be a stack corruption
>>> caused by macro PRECEDING_KEY().
>>>
>>> See how PRECEDING_KEY() is defined in bset.h,
>>> 437 #define PRECEDING_KEY(_k)                                       \
>>> 438 ({                                                              \
>>> 439         struct bkey *_ret = NULL;                               \
>>> 440                                                                 \
>>> 441         if (KEY_INODE(_k) || KEY_OFFSET(_k)) {                  \
>>> 442                 _ret = &KEY(KEY_INODE(_k), KEY_OFFSET(_k), 0);  \
>>> 443                                                                 \
>>> 444                 if (!_ret->low)                                 \
>>> 445                         _ret->high--;                           \
>>> 446                 _ret->low--;                                    \
>>> 447         }                                                       \
>>> 448                                                                 \
>>> 449         _ret;                                                   \
>>> 450 })
>>>
>>> At line 442, _ret points to address of a on-stack variable combined by
>>> KEY(), the life range of this on-stack variable is in line 442-446,
>>> once _ret is returned to bch_btree_insert_key(), the returned address
>>> points to an invalid stack address and this address is overwritten in
>>> the following called bch_btree_iter_init(). Then argument 'search' of
>>> bch_btree_iter_init() points to some address inside stackframe of
>>> bch_btree_iter_init(), exact address depends on how the compiler
>>> allocates stack space. Now the stack is corrupted.
>>>
>>> Signed-off-by: Coly Li <colyli@suse.de>
>>> Reviewed-by: Rolf Fokkens <rolf@rolffokkens.nl>
>>> Reviewed-by: Pierre JUHEN <pierre.juhen@orange.fr>
>> Hi Rolf and Pierre,
>>
>> Oops, I am a little bit too hurry, just realize you don't offer
>> Reviewed-by: yet.
>>
>> Could you like to offer a Reviewed-by: to this patch, then I may submit
>> to Jens in this run ASAP.
>>
>> Many thanks of your code review and help !
>>
>> Coly Li
>>
>>
>>> Tested-by: Shenghui Wang <shhuiw@foxmail.com>
>>> Cc: Kent Overstreet <kent.overstreet@gmail.com>
>>> Cc: Nix <nix@esperi.org.uk>
>>> ---
>>> Changlog:
>>> V2: Fix a pointer assignment problem in preceding_key(), which is
>>>      pointed by Rolf Fokkens and Pierre JUHEN.
>>> V1: Initial RFC patch for review and comment.
>>>
>>>   drivers/md/bcache/bset.c | 16 +++++++++++++---
>>>   drivers/md/bcache/bset.h | 34 ++++++++++++++++++++--------------
>>>   2 files changed, 33 insertions(+), 17 deletions(-)
>> [snipped]
