Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF5797CD8
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Sep 2023 21:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbjIGThP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Sep 2023 15:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjIGThO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Sep 2023 15:37:14 -0400
X-Greylist: delayed 4184 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Sep 2023 12:37:09 PDT
Received: from james.steelbluetech.co.uk (james.steelbluetech.co.uk [92.63.139.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C3CCE9
        for <linux-bcache@vger.kernel.org>; Thu,  7 Sep 2023 12:37:09 -0700 (PDT)
Received: from ukinbox.ecrypt.net (hq2.ehuk.net [10.0.10.2])
        by james.steelbluetech.co.uk (Postfix) with ESMTP id EFE3FBFC13;
        Thu,  7 Sep 2023 12:14:09 +0100 (BST)
DKIM-Filter: OpenDKIM Filter v2.10.3 james.steelbluetech.co.uk EFE3FBFC13
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ehuk.net; s=default;
        t=1694085250; bh=oZIFIdW+Kfgm/8u2tNa1AIMrPG05YRV9KvLZpK7QCXo=;
        h=In-Reply-To:References:Date:Subject:From:To:Cc:Reply-To:From;
        b=d2Z+QcM5Zjtv7C9oncJl5pPNTFZ5FVkvAtxnMNSCZS92VydVcJW82eG2RTonmPWRt
         uP/qjpe6MdjJDKisFXN0vBt2NuKzbQbZJkhX4Q+w8J/1eJYfVKPOZ/Xo3WjucMArhu
         yVnmekX5w2umlGZJyuuw2Xzx/z/0MaL+RcesfhjT9q8hExdTYIv5SctgM+caee85r9
         1Lse4arz6FJhSvyHCWv2/DAE8zJ5I1L1vMnZcyFs9uRVU4LSZ9s3YgVDmgH4vboAjN
         OLCRIRStOBwVX/RRqFRYVDN4hocgOWflpg//YghKUhDsMkoGBtXgM7nz2igInDeIvq
         fM7yzUIfMZUDQ==
Message-ID: <de1e6ddd2e8534eeead33273ff3d4026.squirrel@ukinbox.ecrypt.net>
In-Reply-To: <81A90714-59BC-47F6-BFD5-26A8B90A7326@suse.de>
References: <dzhok3pe53usq5qc4emosxesmimwvhxoi663hxqpigvzejmppm@2fj6swqu2j7a>
    <AAwAcABgJMxjBt4aQEsLQqpi.3.1692881396125.Hmail.mingzhe.zou@easystack.cn>
    <81A90714-59BC-47F6-BFD5-26A8B90A7326@suse.de>
Date:   Thu, 7 Sep 2023 12:14:10 +0100
Subject: Re: [PATCH] bcache: fixup init dirty data errors
From:   "Eddie Chapman" <eddie@ehuk.net>
To:     "Coly Li" <colyli@suse.de>,
        "Mingzhe Zou" <mingzhe.zou@easystack.cn>
Cc:     "Eric Wheeler" <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Reply-To: eddie@ehuk.net
User-Agent: SquirrelMail/1.5.2 [SVN]
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Coly Li wrote:
>
>> 2023年8月24日 20:49，邹明哲 <mingzhe.zou@easystack.cn> 写道：
>>
>> From: Coly Li <colyli@suse.de>
>> Date: 2023-08-23 01:49:32
>> To:  Mingzhe Zou <mingzhe.zou@easystack.cn>
>> Cc:
>> bcache@lists.ewheeler.net,linux-bcache@vger.kernel.org,zoumingzhe@qq.co
>> m Subject: Re: [PATCH] bcache: fixup init dirty data errors>Hi Mingzhe,
>>
>>> On Tue, Aug 22, 2023 at 06:19:58PM +0800, Mingzhe Zou wrote:
>>>
>>>> We found that after long run, the dirty_data of the bcache device
>>>> will have errors. This error cannot be eliminated unless
>>>> re-register.
>>>
>>> Could you explain what the error was?
>>>
>> Hi, Coly
>>
>> We discovered dirty_data was inaccurate a long time ago.
>> When writeback thread flushes all dirty data, dirty_data via sysfs shows
>> that there are still several K to tens of M of dirty data.
>>
>> At that time, I thought it might be a calculation error at runtime, but
>> after reviewing the relevant code, no error was found.
>>
>> Last month, our online environment found that a certain device had more
>> than 200G of dirty_data. This brings us back to the question.
>>
>>>> We also found that reattach after detach, this error can
>>>> accumulate.
>>>
>>> Could you elaborate how the error can accumulate?
>>>
>> I found that when dirty_data, error, detach and then re-attach can not
>> eliminate the error, the error will continue.
>>
>> In bch_cached_dev_attach(), after bch_sectors_dirty_init(), attach may
>> still fail, but dirty_data is not cleared when it fails ```
>> bch_sectors_dirty_init(&dc->disk);
>>
>> ret = bch_cached_dev_run(dc); if (ret && (ret != -EBUSY)) {
>> up_write(&dc->writeback_lock); /*
>> * bch_register_lock is held, bcache_device_stop() is not
>> * able to be directly called. The kthread and kworker
>> * created previously in bch_cached_dev_writeback_start()
>> * have to be stopped manually here.
>> */
>> kthread_stop(dc->writeback_thread); dc->writeback_thread = NULL;
>> cancel_writeback_rate_update_dwork(dc); pr_err("Couldn't run cached
>> device %s", dc->backing_dev_name); return ret; }
>> ```
>>>
>>>> In bch_sectors_dirty_init(), all inode <= d->id keys will be
>>>> recounted again. This is wrong, we only need to count the keys of
>>>> the current device.
>>>>
>>>> Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be
>>>> multithreaded") Signed-off-by: Mingzhe Zou
>>>> <mingzhe.zou@easystack.cn>
>>>> ---
>>>> drivers/md/bcache/writeback.c | 7 ++++++- 1 file changed, 6
>>>> insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/md/bcache/writeback.c
>>>> b/drivers/md/bcache/writeback.c index 24c049067f61..71d0dabcbf9d
>>>> 100644
>>>> --- a/drivers/md/bcache/writeback.c
>>>> +++ b/drivers/md/bcache/writeback.c
>>>> @@ -983,6 +983,8 @@ void bch_sectors_dirty_init(struct bcache_device
>>>> *d)
>>>> struct cache_set *c = d->c; struct bch_dirty_init_state state;
>>>>
>>>> + atomic_long_set(&d->dirty_sectors, 0);
>>>> +
>>>
>>> The above change is not upstreamed yet, if you are fixing upstream
>>> code please avoid to use d->dirty_sectors here.
>>
>> Yes, dirty_sectors is a set of resize patches submitted to the
>> community before, these patches have not been merged into upstream, I
>> will remove this line in v2.
>>
>> In fact, the change about dirty_sectors is only a prerequisite for
>> resize, and it can be promoted first. It will greatly reduce the memory
>> requirements of high-capacity devices.
>>
>>>> /* Just count root keys if no leaf node */
>>>> rw_lock(0, c->root, c->root->level); if (c->root->level == 0) { @@
>>>> -991,8 +993,11 @@ void bch_sectors_dirty_init(struct bcache_device
>>>> *d)
>>>> op.count = 0;
>>>>
>>>> for_each_key_filter(&c->root->keys, -     k, &iter, bch_ptr_invalid)
>>>>  +     k, &iter, bch_ptr_invalid) {
>>>> + if (KEY_INODE(k) != op.inode)
>>>> + continue;
>>>> sectors_dirty_init_fn(&op.op, c->root, k); + }
>>>>
>>> Nice catch! IMHO if I take the above change, setting d->dirty_sectors
>>> by 0 might be unncessary in ideal condition, am I right?
>>
>> In bch_cached_dev_attach () may still fail and exit, I think it is
>> necessary to clear 0.
>
> Copied. Thanks for the information, I will take the v2 patch.
>
> Coly Li
>

Hi Coly, Mingzhe,

Can I ask, how far back would this fix be needed, in terms of stable
versions?

Thanks,
Eddie

