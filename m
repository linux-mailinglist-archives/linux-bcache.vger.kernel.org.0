Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124D43A2AF
	for <lists+linux-bcache@lfdr.de>; Sun,  9 Jun 2019 03:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfFIBAB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 8 Jun 2019 21:00:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:49398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726190AbfFIBAB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 8 Jun 2019 21:00:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 02E0DAC84;
        Sun,  9 Jun 2019 00:59:59 +0000 (UTC)
Subject: Re: [RFC PATCH] bcache: fix stack corruption by PRECEDING_KEY()
To:     Rolf Fokkens <rolf@rolffokkens.nl>, linux-bcache@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>, Pierre JUHEN <pierre.juhen@orange.fr>,
        linux-block@vger.kernel.org
References: <20190608102204.60126-1-colyli@suse.de>
 <8855017f-729e-9719-236d-e98710702564@rolffokkens.nl>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <777da4cb-2d11-9bcc-b56f-e59265b8c76d@suse.de>
Date:   Sun, 9 Jun 2019 08:59:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <8855017f-729e-9719-236d-e98710702564@rolffokkens.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/9 2:50 上午, Rolf Fokkens wrote:
> On 6/8/19 12:22 PM, Coly Li wrote:
>> +static inline void preceding_key(struct bkey *k, struct bkey
>> *preceding_key_p)
>> +{
>> +    if (KEY_INODE(k) || KEY_OFFSET(k)) {
>> +        *preceding_key_p = KEY(KEY_INODE(k), KEY_OFFSET(k), 0);
>> +        if (!preceding_key_p->low)
>> +            preceding_key_p->high--;
>> +        preceding_key_p->low--;
>> +    } else {
>> +        preceding_key_p = NULL;
> 
> If I'm correct, the line above has no net effect, it just changes a
> local variable (parameter) with no effect elsewhere. So the else part
> may be left out, or do you mean this?
> 
> *preceding_key_p = ZERO_KEY;
> 

Hi Rolf and Pierre,

Setting preceding_key_p to NULL is for the following
bch_btree_iter_init(). See the call chains

bch_btree_insert_key()->bch_btree_iter_init()->
__bch_btree_iter_init()->bch_bset_search()

preceding_key_p is parameter 'search' in bch_bset_search().
If it is NULL, t->data->start returns directly; if it is not NULL,
__bch_bset_search() is called.

Indeed *preceding_key_p = ZERO_KEY is unnecessary, just makes me
comfortable. The problem is PRECEDING_KEY() allocates an on-stack
variable, and this one is overlapped with stackframe of
bch_btree_iter_init(), and overwritten. Because this anonymous on-stack
variable is allocated inside PRECEDING_KEY(), not (and should not be)
protected by compiler.

So I add the new local variable preceding_key (and make preceding_key_p
points to it) explicitly on stack frame of bch_btree_insert_key(), which
will never be overlapped with stackframe of bch_btree_iter_init().

Thanks.
-- 

Coly Li
