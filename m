Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F772787582
	for <lists+linux-bcache@lfdr.de>; Thu, 24 Aug 2023 18:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbjHXQhB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Aug 2023 12:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242622AbjHXQgb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Aug 2023 12:36:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2B4E6A
        for <linux-bcache@vger.kernel.org>; Thu, 24 Aug 2023 09:36:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6C0CB1F388;
        Thu, 24 Aug 2023 16:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692894987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=63AFpMhzG983n+NELXwcBusqSL0hGIujbBhbxiOu9a0=;
        b=VWOnHdcTx4RXlqyc4Y6JavCzGrh+74QxwUP9kKGTJC+hnXkqaJr6QlAzXNmFTlSKoltXe1
        pilh269sePUcj7HTh9J4/hI1nXs7w5Tjf8OeZ8VD9lVzxAuNN+ElWxkd09gnw3D37djQW4
        YoPtmNiGXjHde9IeUisa121fq5IJ8r8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692894987;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=63AFpMhzG983n+NELXwcBusqSL0hGIujbBhbxiOu9a0=;
        b=S67Fd9AfSQAV5mnz4qHbOkN2/eFPZyYyCBrHIM6nNjGCqM/rObuwUBP9tJN22MrQg++krz
        3QcDq85OYgdWBjBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4EA00132F2;
        Thu, 24 Aug 2023 16:36:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id q/ARBgqH52RQYgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 24 Aug 2023 16:36:26 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH] bcache: fixup init dirty data errors
From:   Coly Li <colyli@suse.de>
X-Priority: 3
In-Reply-To: <AAwAcABgJMxjBt4aQEsLQqpi.3.1692881396125.Hmail.mingzhe.zou@easystack.cn>
Date:   Fri, 25 Aug 2023 00:36:13 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <81A90714-59BC-47F6-BFD5-26A8B90A7326@suse.de>
References: <dzhok3pe53usq5qc4emosxesmimwvhxoi663hxqpigvzejmppm@2fj6swqu2j7a>
 <AAwAcABgJMxjBt4aQEsLQqpi.3.1692881396125.Hmail.mingzhe.zou@easystack.cn>
To:     =?utf-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B48=E6=9C=8824=E6=97=A5 20:49=EF=BC=8C=E9=82=B9=E6=98=8E=E5=93=
=B2 <mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: Coly Li <colyli@suse.de>
> Date: 2023-08-23 01:49:32
> To:  Mingzhe Zou <mingzhe.zou@easystack.cn>
> Cc:  =
bcache@lists.ewheeler.net,linux-bcache@vger.kernel.org,zoumingzhe@qq.com
> Subject: Re: [PATCH] bcache: fixup init dirty data errors>Hi Mingzhe,
>>=20
>> On Tue, Aug 22, 2023 at 06:19:58PM +0800, Mingzhe Zou wrote:
>>> We found that after long run, the dirty_data of the bcache device
>>> will have errors. This error cannot be eliminated unless =
re-register.
>>=20
>> Could you explain what the error was?
>>=20
> Hi, Coly
>=20
> We discovered dirty_data was inaccurate a long time ago.=20
> When writeback thread flushes all dirty data, dirty_data via sysfs =
shows that
> there are still several K to tens of M of dirty data.=20
>=20
> At that time, I thought it might be a calculation error at runtime, =
but after
> reviewing the relevant code, no error was found.
>=20
> Last month, our online environment found that a certain device had =
more than
> 200G of dirty_data. This brings us back to the question.
>=20
>>>=20
>>> We also found that reattach after detach, this error can accumulate.
>>>=20
>>=20
>> Could you elaborate how the error can accumulate?
>>=20
> I found that when dirty_data, error, detach and then re-attach can not
> eliminate the error, the error will continue.
>=20
> In bch_cached_dev_attach(), after bch_sectors_dirty_init(), attach may =
still fail,
> but dirty_data is not cleared when it fails
> ```
> bch_sectors_dirty_init(&dc->disk);
>=20
> ret =3D bch_cached_dev_run(dc);
> if (ret && (ret !=3D -EBUSY)) {
> up_write(&dc->writeback_lock);
> /*
>  * bch_register_lock is held, bcache_device_stop() is not
>  * able to be directly called. The kthread and kworker
>  * created previously in bch_cached_dev_writeback_start()
>  * have to be stopped manually here.
>  */
> kthread_stop(dc->writeback_thread);
> dc->writeback_thread =3D NULL;
> cancel_writeback_rate_update_dwork(dc);
> pr_err("Couldn't run cached device %s",
>        dc->backing_dev_name);
> return ret;
> }
> ```
>=20
>>=20
>>> In bch_sectors_dirty_init(), all inode <=3D d->id keys will be =
recounted
>>> again. This is wrong, we only need to count the keys of the current
>>> device.
>>>=20
>>> Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be =
multithreaded")
>>> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>> ---
>>> drivers/md/bcache/writeback.c | 7 ++++++-
>>> 1 file changed, 6 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/drivers/md/bcache/writeback.c =
b/drivers/md/bcache/writeback.c
>>> index 24c049067f61..71d0dabcbf9d 100644
>>> --- a/drivers/md/bcache/writeback.c
>>> +++ b/drivers/md/bcache/writeback.c
>>> @@ -983,6 +983,8 @@ void bch_sectors_dirty_init(struct bcache_device =
*d)
>>> struct cache_set *c =3D d->c;
>>> struct bch_dirty_init_state state;
>>>=20
>>> + atomic_long_set(&d->dirty_sectors, 0);
>>> +
>>=20
>> The above change is not upstreamed yet, if you are fixing upstream =
code please
>> avoid to use d->dirty_sectors here.
>>=20
>=20
> Yes, dirty_sectors is a set of resize patches submitted to the =
community before,
> these patches have not been merged into upstream, I will remove this =
line in v2.
>=20
> In fact, the change about dirty_sectors is only a prerequisite for =
resize, and it can
> be promoted first. It will greatly reduce the memory requirements of =
high-capacity
> devices.
>=20
>>=20
>>=20
>>> /* Just count root keys if no leaf node */
>>> rw_lock(0, c->root, c->root->level);
>>> if (c->root->level =3D=3D 0) {
>>> @@ -991,8 +993,11 @@ void bch_sectors_dirty_init(struct =
bcache_device *d)
>>> op.count =3D 0;
>>>=20
>>> for_each_key_filter(&c->root->keys,
>>> -     k, &iter, bch_ptr_invalid)
>>> +     k, &iter, bch_ptr_invalid) {
>>> + if (KEY_INODE(k) !=3D op.inode)
>>> + continue;
>>> sectors_dirty_init_fn(&op.op, c->root, k);
>>> + }
>>>=20
>>=20
>> Nice catch! IMHO if I take the above change, setting d->dirty_sectors =
by 0
>> might be unncessary in ideal condition, am I right?
>>=20
>=20
> In bch_cached_dev_attach () may still fail and exit, I think it is =
necessary to clear 0.

Copied. Thanks for the information, I will take the v2 patch.

Coly Li

