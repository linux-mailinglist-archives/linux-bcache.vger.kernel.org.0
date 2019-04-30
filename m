Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F65FA85
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Apr 2019 15:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfD3NeH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Apr 2019 09:34:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:40048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbfD3NeH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Apr 2019 09:34:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D6BCFAD7B;
        Tue, 30 Apr 2019 13:34:05 +0000 (UTC)
Subject: Re: [PATCH 18/18] bcache: avoid potential memleak of list of
 journal_replay(s) in the CACHE_SYNC branch of run_cache_set
To:     Juha Aatrokoski <juha.aatrokoski@aalto.fi>
Cc:     linux-bcache@vger.kernel.org, Shenghui Wang <shhuiw@foxmail.com>
References: <20190424164843.29535-1-colyli@suse.de>
 <20190424164843.29535-19-colyli@suse.de>
 <alpine.DEB.2.21.1904301510350.7886@orbit.lan>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <02cd27e2-1c20-918f-ec86-f96840f580c3@suse.de>
Date:   Tue, 30 Apr 2019 21:33:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1904301510350.7886@orbit.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/4/30 8:15 下午, Juha Aatrokoski wrote:
> This patch is missing the following chunk from the original patch:
> 
> @@ -1790,7 +1792,6 @@ static void run_cache_set(struct cache_set *c)
>         set_gc_sectors(c);
> 
>         if (CACHE_SYNC(&c->sb)) {
> -               LIST_HEAD(journal);
>                 struct bkey *k;
>                 struct jset *j;
> 
> Unless I'm missing something, without this chunk this patch doesn't do
> anything, as the "journal" that is allocated is the inner one, while the
> "journal" that is freed is the outer one.
> 
> 

Hi Juhua,

Oops I overlooked this one. I will post the fix after my local test
finished. Many thanks!

Coly Li




> On Thu, 25 Apr 2019, Coly Li wrote:
> 
>> From: Shenghui Wang <shhuiw@foxmail.com>
>>
>> In the CACHE_SYNC branch of run_cache_set(), LIST_HEAD(journal) is used
>> to collect journal_replay(s) and filled by bch_journal_read().
>>
>> If all goes well, bch_journal_replay() will release the list of
>> jounal_replay(s) at the end of the branch.
>>
>> If something goes wrong, code flow will jump to the label "err:" and
>> leave
>> the list unreleased.
>>
>> This patch will release the list of journal_replay(s) in the case of
>> error detected.
>>
>> v1 -> v2:
>> * Move the release code to the location after label 'err:' to
>>  simply the change.
>>
>> Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>> drivers/md/bcache/super.c | 8 ++++++++
>> 1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 3f34b96ebbc3..0ffe9acee9d8 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1790,6 +1790,8 @@ static int run_cache_set(struct cache_set *c)
>>     struct cache *ca;
>>     struct closure cl;
>>     unsigned int i;
>> +    LIST_HEAD(journal);
>> +    struct journal_replay *l;
>>
>>     closure_init_stack(&cl);
>>
>> @@ -1949,6 +1951,12 @@ static int run_cache_set(struct cache_set *c)
>>     set_bit(CACHE_SET_RUNNING, &c->flags);
>>     return 0;
>> err:
>> +    while (!list_empty(&journal)) {
>> +        l = list_first_entry(&journal, struct journal_replay, list);
>> +        list_del(&l->list);
>> +        kfree(l);
>> +    }
>> +
>>     closure_sync(&cl);
>>     /* XXX: test this, it's broken */
>>     bch_cache_set_error(c, "%s", err);
>>


-- 

Coly Li
