Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917065BC246
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 06:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiISEid (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Sep 2022 00:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiISEic (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2022 00:38:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B63C13F27
        for <linux-bcache@vger.kernel.org>; Sun, 18 Sep 2022 21:38:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C6F7C1FAC8;
        Mon, 19 Sep 2022 04:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663562309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZyiII4bwVK/CINkd4Bhjj6Lx6/7Z3bTEGv+29qS4qjY=;
        b=ZoWpE8zBkllsetKE0qvBsq2x4MpeUhkrOOthr2Nm6qR3x1X7Ri7MYzosB6y2l4gAUbAFBC
        qAd05pIFcVnW4O6R4zqQjqbrGWc2SnZ2jryM+DPR4ip/5+nxf3Keh6xb+6AFolUqs21/FN
        UUgc/DNh8ECF9ZgVipOVslj4B+7eih4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663562309;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZyiII4bwVK/CINkd4Bhjj6Lx6/7Z3bTEGv+29qS4qjY=;
        b=oLh5gnNUbERbVfcZhto3C9DWS6cgSdv9UUYjw04d9PUxtPL8blldvfox4cJXObbRUYLfNJ
        35kgKB6/lOn6ooCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EFEE513A96;
        Mon, 19 Sep 2022 04:38:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id alDWLkTyJ2OMagAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 19 Sep 2022 04:38:28 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v2] bcache: fix set_at_max_writeback_rate() for multiple
 attached devices
From:   Coly Li <colyli@suse.de>
In-Reply-To: <6d8a2888-b20a-c71c-733f-97c6a91f1244@easystack.cn>
Date:   Mon, 19 Sep 2022 12:38:26 +0800
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <EABD6CA2-9BC2-4243-B3DE-3B0FA6F43583@suse.de>
References: <20220918121647.103458-1-colyli@suse.de>
 <6d8a2888-b20a-c71c-733f-97c6a91f1244@easystack.cn>
To:     mingzhe <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=8819=E6=97=A5 11:29=EF=BC=8Cmingzhe =
<mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
> =E5=9C=A8 2022/9/18 20:16, Coly Li =E5=86=99=E9=81=93:
>> Inside set_at_max_writeback_rate() the calculation in following if()
>> check is wrong,
>> 	if (atomic_inc_return(&c->idle_counter) <
>> 	    atomic_read(&c->attached_dev_nr) * 6)
>> Because each attached backing device has its own writeback thread
>> running and increasing c->idle_counter, the counter increates much
>> faster than expected. The correct calculation should be,
>> 	(counter / dev_nr) < dev_nr * 6
>> which equals to,
>> 	counter < dev_nr * dev_nr * 6
>> This patch fixes the above mistake with correct calculation, and =
helper
>> routine idle_counter_exceeded() is added to make code be more clear.
>> Reported-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>> Changelog:
>> v2: Add the missing "!atomic_read(&c->at_max_writeback_rate)" part
>>     back.
>> v1: Original verison.
>>  drivers/md/bcache/writeback.c | 73 =
+++++++++++++++++++++++++----------
>>  1 file changed, 52 insertions(+), 21 deletions(-)
>> diff --git a/drivers/md/bcache/writeback.c =
b/drivers/md/bcache/writeback.c
>> index 647661005176..c186bf55fe61 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -157,6 +157,53 @@ static void __update_writeback_rate(struct =
cached_dev *dc)
>>  	dc->writeback_rate_target =3D target;
>>  }
>>  +static bool idle_counter_exceeded(struct cache_set *c)
>> +{
>> +	int counter, dev_nr;
>> +
>> +	/*
>> +	 * If c->idle_counter is overflow (idel for really long time),
>> +	 * reset as 0 and not set maximum rate this time for code
>> +	 * simplicity.
>> +	 */
>> +	counter =3D atomic_inc_return(&c->idle_counter);
>> +	if (counter <=3D 0) {
>> +		atomic_set(&c->idle_counter, 0);
>> +		return false;
>> +	}
>> +
>> +	dev_nr =3D atomic_read(&c->attached_dev_nr);
>> +	if (dev_nr =3D=3D 0)
>> +		return false;
>> +
>> +	/*
>> +	 * c->idle_counter is increased by writeback thread of all
>> +	 * attached backing devices, in order to represent a rough
>> +	 * time period, counter should be divided by dev_nr.
>> +	 * Otherwise the idle time cannot be larger with more backing
>> +	 * device attached.
>> +	 * The following calculation equals to checking
>> +	 *	(counter / dev_nr) < (dev_nr * 6)
>> +	 */
>> +	if (counter < (dev_nr * dev_nr * 6))
>> +		return false;
> Hi, Coly
>=20
> Look good to me. However, do we need to specify a maximum value for =
idle_counter. If cache_set has 100 backing devices, there are dev_nr*6 =
rounds of update_writeback_rate() on each backing device, which takes =
dc->writeback_rate_update_seconds(default is 5 seconds)*600 seconds.

Yes, this is exactly what I intend to do. The maximum writeback rate is =
only set when the whole cahce set is really really idle.


>=20
> In fact, any io request from the backing device will clear the =
idle_counter of cache_set, and at_max_writeback_rate will exit soon. =
Therefore, if cache_set waits for 5 minutes or 10 minutes without any io =
request to start at_max_writeback_rate, it will not have any effect on =
the possible front-end io.
>=20
> In addition, cache_set only waits 6 rounds of update_writeback_rate() =
should not have much performance impact.

The maximum writeback rate is a better than nothing effort, normally the =
P.I controller decides the writeback rate, and the maximum writeback =
rate trick should not step in.


BTW, if the patch looks fine to you, could you please to response a =
Reviewed-by or Acked-by for it?

Thanks.

Coly Li


>=20
> mingzhe
>> +
>> +	return true;
>> +}
>> +
>> +/*
>> + * Idle_counter is increased everytime when update_writeback_rate() =
is
>> + * called. If all backing devices attached to the same cache set =
have
>> + * identical dc->writeback_rate_update_seconds values, it is about 6
>> + * rounds of update_writeback_rate() on each backing device before
>> + * c->at_max_writeback_rate is set to 1, and then max wrteback rate =
set
>> + * to each dc->writeback_rate.rate.
>> + * In order to avoid extra locking cost for counting exact dirty =
cached
>> + * devices number, c->attached_dev_nr is used to calculate the idle
>> + * throushold. It might be bigger if not all cached device are in =
write-
>> + * back mode, but it still works well with limited extra rounds of
>> + * update_writeback_rate().
>> + */
>>  static bool set_at_max_writeback_rate(struct cache_set *c,
>>  				       struct cached_dev *dc)
>>  {
>> @@ -167,21 +214,8 @@ static bool set_at_max_writeback_rate(struct =
cache_set *c,
>>  	/* Don't set max writeback rate if gc is running */
>>  	if (!c->gc_mark_valid)
>>  		return false;
>> -	/*
>> -	 * Idle_counter is increased everytime when =
update_writeback_rate() is
>> -	 * called. If all backing devices attached to the same cache set =
have
>> -	 * identical dc->writeback_rate_update_seconds values, it is =
about 6
>> -	 * rounds of update_writeback_rate() on each backing device =
before
>> -	 * c->at_max_writeback_rate is set to 1, and then max wrteback =
rate set
>> -	 * to each dc->writeback_rate.rate.
>> -	 * In order to avoid extra locking cost for counting exact dirty =
cached
>> -	 * devices number, c->attached_dev_nr is used to calculate the =
idle
>> -	 * throushold. It might be bigger if not all cached device are =
in write-
>> -	 * back mode, but it still works well with limited extra rounds =
of
>> -	 * update_writeback_rate().
>> -	 */
>> -	if (atomic_inc_return(&c->idle_counter) <
>> -	    atomic_read(&c->attached_dev_nr) * 6)
>> +
>> +	if (!idle_counter_exceeded(c))
>>  		return false;
>>    	if (atomic_read(&c->at_max_writeback_rate) !=3D 1)
>> @@ -195,13 +229,10 @@ static bool set_at_max_writeback_rate(struct =
cache_set *c,
>>  	dc->writeback_rate_change =3D 0;
>>    	/*
>> -	 * Check c->idle_counter and c->at_max_writeback_rate agagain in =
case
>> -	 * new I/O arrives during before set_at_max_writeback_rate() =
returns.
>> -	 * Then the writeback rate is set to 1, and its new value should =
be
>> -	 * decided via __update_writeback_rate().
>> +	 * In case new I/O arrives during before
>> +	 * set_at_max_writeback_rate() returns.
>>  	 */
>> -	if ((atomic_read(&c->idle_counter) <
>> -	     atomic_read(&c->attached_dev_nr) * 6) ||
>> +	if (!idle_counter_exceeded(c) ||
>>  	    !atomic_read(&c->at_max_writeback_rate))
>>  		return false;
>> =20

