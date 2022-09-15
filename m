Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D875B9D9C
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Sep 2022 16:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiIOOoL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 15 Sep 2022 10:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiIOOoL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Sep 2022 10:44:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB74FD
        for <linux-bcache@vger.kernel.org>; Thu, 15 Sep 2022 07:44:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 96AF921A0E;
        Thu, 15 Sep 2022 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663253048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gds39AXoyp8Zs0gF68/qkamdJ4+1csCFJhgIn3ioP4w=;
        b=q/CyKuJJd+SK7Od27U4gYayKqR7JqXMl5x7DUQQ0+Jw3vH2paDkgibJ4oHQPZ9kssHwUFi
        szAACCig0OFf/OqM3rhs6O5uTxZdWgZidGi+ROl+h+IMs7eXsGTLnosIU3uq7L2ZDhxE8J
        vPFdPC9ziKmrey9ZPo/7rQ4Ri3ziWN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663253048;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gds39AXoyp8Zs0gF68/qkamdJ4+1csCFJhgIn3ioP4w=;
        b=XCcQPepKy81ZNqZrbEo5fr5lc/rKtpivB/ZH14qUSk2hVE38NrBq+BXSMcVaWFEqQ59PnI
        cldMeytUl/aLjPDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B3CB133B6;
        Thu, 15 Sep 2022 14:44:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ql8JFjc6I2OjfwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 15 Sep 2022 14:44:07 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH] bcache: set cool backing device to maximum writeback rate
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220915120544.9086-1-mingzhe.zou@easystack.cn>
Date:   Thu, 15 Sep 2022 22:44:02 +0800
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <993D46BB-D0BF-499C-B8B3-89405DD1DB66@suse.de>
References: <20220915120544.9086-1-mingzhe.zou@easystack.cn>
To:     mingzhe.zou@easystack.cn
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=8815=E6=97=A5 20:05=EF=BC=8Cmingzhe.zou@easystack.c=
n =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: mingzhe <mingzhe.zou@easystack.cn>
>=20
> If the data in the cache is dirty, gc thread cannot reclaim the space.
> We need to writeback dirty data to backing, and then gc can reclaim
> this area. So bcache will writeback dirty data more aggressively.
>=20

The writeback operation should try to avoid negative influence to front =
end I/O performance. Especially the I/O latency.


> Currently, there is no io request within 30 seconds of the cache_set,
> all backing devices in it will be set to the maximum writeback rate.

The idle time depends how many backing devices there are. If there is 1 =
backing device, the idle time before maximum writeback rate setting is =
30 seconds, if there are 2 backing device, the idle time will be 60 =
seconds. If there are 6 backing device attached with a cache set, the =
maximum writeback rate will be set after 180 seconds without any =
incoming I/O request. That is to say, the maximum writeback rate setting =
is not a aggressive writeback policy, it is just try to writeback more =
dirty data without interfering regular I/O request when the cache set is =
really idle.



>=20
> However, for multiple backings in the same cache_set, there maybe both
> cold and hot devices. Since the cold device has no read or write =
requests,
> dirty data should writeback as soon as possible.
>=20

NACK. The writeback thread will take mutex lock(s) of btree nodes, =
increasing writeback rate may introduce negative contribution to front =
end I/O performance. And your change will make the P.I controller for =
writeback rate not work properly.


> This patch reduces the control granularity of =
set_at_max_writeback_rate()
> from cache_set to cached_dev. Because even cache_set still has io =
requests,
> writeback cold data can make more space for hot data.

I won=E2=80=99t take this patch, because it will obviously interfere =
front I/O performance. Maybe it really works fine in your condition, but =
other people with other workload will not happy.

Thanks.

Coly Li


>=20
> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
> ---
> drivers/md/bcache/bcache.h    |  5 +++--
> drivers/md/bcache/request.c   | 10 +++++-----
> drivers/md/bcache/writeback.c | 16 +++++++---------
> 3 files changed, 15 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index f4436229cd83..768bb217e156 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -330,6 +330,9 @@ struct cached_dev {
> 	 */
> 	atomic_t		has_dirty;
>=20
> +	atomic_t		idle_counter;
> +	atomic_t		at_max_writeback_rate;
> +
> #define BCH_CACHE_READA_ALL		0
> #define BCH_CACHE_READA_META_ONLY	1
> 	unsigned int		cache_readahead_policy;
> @@ -520,8 +523,6 @@ struct cache_set {
> 	struct cache_accounting accounting;
>=20
> 	unsigned long		flags;
> -	atomic_t		idle_counter;
> -	atomic_t		at_max_writeback_rate;
>=20
> 	struct cache		*cache;
>=20
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index f2c5a7e06fa9..f53b5831f500 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1141,7 +1141,7 @@ static void quit_max_writeback_rate(struct =
cache_set *c,
> 	 * To avoid such situation, if mutext_trylock() failed, only =
writeback
> 	 * rate of current cached device is set to 1, and =
__update_write_back()
> 	 * will decide writeback rate of other cached devices (remember =
now
> -	 * c->idle_counter is 0 already).
> +	 * dc->idle_counter is 0 already).
> 	 */
> 	if (mutex_trylock(&bch_register_lock)) {
> 		for (i =3D 0; i < c->devices_max_used; i++) {
> @@ -1184,16 +1184,16 @@ void cached_dev_submit_bio(struct bio *bio)
> 	}
>=20
> 	if (likely(d->c)) {
> -		if (atomic_read(&d->c->idle_counter))
> -			atomic_set(&d->c->idle_counter, 0);
> +		if (atomic_read(&dc->idle_counter))
> +			atomic_set(&dc->idle_counter, 0);
> 		/*
> 		 * If at_max_writeback_rate of cache set is true and new =
I/O
> 		 * comes, quit max writeback rate of all cached devices
> 		 * attached to this cache set, and set =
at_max_writeback_rate
> 		 * to false.
> 		 */
> -		if (unlikely(atomic_read(&d->c->at_max_writeback_rate) =
=3D=3D 1)) {
> -			atomic_set(&d->c->at_max_writeback_rate, 0);
> +		if (unlikely(atomic_read(&dc->at_max_writeback_rate) =3D=3D=
 1)) {
> +			atomic_set(&dc->at_max_writeback_rate, 0);
> 			quit_max_writeback_rate(d->c, dc);
> 		}
> 	}
> diff --git a/drivers/md/bcache/writeback.c =
b/drivers/md/bcache/writeback.c
> index 3f0ff3aab6f2..40e10fd3552e 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -172,7 +172,7 @@ static bool set_at_max_writeback_rate(struct =
cache_set *c,
> 	 * called. If all backing devices attached to the same cache set =
have
> 	 * identical dc->writeback_rate_update_seconds values, it is =
about 6
> 	 * rounds of update_writeback_rate() on each backing device =
before
> -	 * c->at_max_writeback_rate is set to 1, and then max wrteback =
rate set
> +	 * dc->at_max_writeback_rate is set to 1, and then max wrteback =
rate set
> 	 * to each dc->writeback_rate.rate.
> 	 * In order to avoid extra locking cost for counting exact dirty =
cached
> 	 * devices number, c->attached_dev_nr is used to calculate the =
idle
> @@ -180,12 +180,11 @@ static bool set_at_max_writeback_rate(struct =
cache_set *c,
> 	 * back mode, but it still works well with limited extra rounds =
of
> 	 * update_writeback_rate().
> 	 */
> -	if (atomic_inc_return(&c->idle_counter) <
> -	    atomic_read(&c->attached_dev_nr) * 6)
> +	if (atomic_inc_return(&dc->idle_counter) < 6)
> 		return false;
>=20
> -	if (atomic_read(&c->at_max_writeback_rate) !=3D 1)
> -		atomic_set(&c->at_max_writeback_rate, 1);
> +	if (atomic_read(&dc->at_max_writeback_rate) !=3D 1)
> +		atomic_set(&dc->at_max_writeback_rate, 1);
>=20
> 	atomic_long_set(&dc->writeback_rate.rate, INT_MAX);
>=20
> @@ -195,14 +194,13 @@ static bool set_at_max_writeback_rate(struct =
cache_set *c,
> 	dc->writeback_rate_change =3D 0;
>=20
> 	/*
> -	 * Check c->idle_counter and c->at_max_writeback_rate agagain in =
case
> +	 * Check dc->idle_counter and dc->at_max_writeback_rate agagain =
in case
> 	 * new I/O arrives during before set_at_max_writeback_rate() =
returns.
> 	 * Then the writeback rate is set to 1, and its new value should =
be
> 	 * decided via __update_writeback_rate().
> 	 */
> -	if ((atomic_read(&c->idle_counter) <
> -	     atomic_read(&c->attached_dev_nr) * 6) ||
> -	    !atomic_read(&c->at_max_writeback_rate))
> +	if ((atomic_read(&dc->idle_counter) < 6) ||
> +	    !atomic_read(&dc->at_max_writeback_rate))
> 		return false;
>=20
> 	return true;
> --=20
> 2.17.1
>=20

