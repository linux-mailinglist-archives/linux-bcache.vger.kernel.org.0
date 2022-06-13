Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C064554825D
	for <lists+linux-bcache@lfdr.de>; Mon, 13 Jun 2022 10:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbiFMIfN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 Jun 2022 04:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiFMIfN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Jun 2022 04:35:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248D71409A
        for <linux-bcache@vger.kernel.org>; Mon, 13 Jun 2022 01:35:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D160C21CCC;
        Mon, 13 Jun 2022 08:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655109309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBleazX2sbRMtYgqxFuw5D7B3NmfGAxoo2MJvuKu2rw=;
        b=WdQbkkf7xfoUFVMKcS8y21PGUHrbOu7PsNMq5t+nRL030x8mJ7WxW6S6RX1k9gh4vAPDNC
        lyaJ1qxR1jorGoBfIc86j+ieND2QC89hQp4H8Fly/Wf2bt/Xk93iVOqklz1XhMXaP9htjW
        sy73e/VEWmlVxe4e8wkhfCyeFT78wW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655109309;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBleazX2sbRMtYgqxFuw5D7B3NmfGAxoo2MJvuKu2rw=;
        b=sh8m5gO19m7yDJkxkSEiyP5WlIT35DaM0iiHkoceCy2z3Kef5Viw+3H0+WfDf1MbH52b6+
        4WG2+pTrQ5BzhrBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CA35513443;
        Mon, 13 Jun 2022 08:35:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Dse0Jbz2pmLTKwAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 13 Jun 2022 08:35:08 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] bcache: try to reuse the slot of invalid_uuid
From:   Coly Li <colyli@suse.de>
In-Reply-To: <a4d9781b-7175-c90e-bbbc-5a46a6d14567@easystack.cn>
Date:   Mon, 13 Jun 2022 16:35:06 +0800
Cc:     linux-bcache@vger.kernel.org, dongsheng.yang@easystack.cn,
        zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3644BD0F-F1DC-4B04-9E07-36CB3F1D656E@suse.de>
References: <20220606084522.12680-1-mingzhe.zou@easystack.cn>
 <780B6E6E-F4A8-4801-AED3-8DF81054D491@suse.de>
 <f19c392f-6ad8-9e0c-a8f7-de2339f76cb6@easystack.cn>
 <31FA99EB-4E02-4241-9264-248A03FABA4E@suse.de>
 <a4d9781b-7175-c90e-bbbc-5a46a6d14567@easystack.cn>
To:     Zou Mingzhe <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=8813=E6=97=A5 16:20=EF=BC=8CZou Mingzhe =
<mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
> =E5=9C=A8 2022/6/6 18:34, Coly Li =E5=86=99=E9=81=93:
>>=20
>>> 2022=E5=B9=B46=E6=9C=886=E6=97=A5 17:29=EF=BC=8CZou Mingzhe =
<mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>>=20
>>>=20
>>> =E5=9C=A8 2022/6/6 16:57, Coly Li =E5=86=99=E9=81=93:
>>>>> 2022=E5=B9=B46=E6=9C=886=E6=97=A5 16:45=EF=BC=8Cmingzhe.zou@easystac=
k.cn
>>>>>  =E5=86=99=E9=81=93=EF=BC=9A
>>>>>=20
>>>>> From: mingzhe
>>>>> <mingzhe.zou@easystack.cn>
>>>>>=20
>>>>>=20
>>>>>=20
>>>>>=20
>>>> [snipped]
>>>>=20
>>>>=20
>>>>> We want to use those invalid_uuid slots carefully. Because, the =
bkey of the inode
>>>>> may still exist in the btree. So, we need to check the btree =
before reuse it.
>>>>>=20
>>>>> Signed-off-by: mingzhe
>>>>> <mingzhe.zou@easystack.cn>
>>>>>=20
>>>>> ---
>>>>> drivers/md/bcache/btree.c | 35 +++++++++++++++++++++++++++++++++++
>>>>> drivers/md/bcache/btree.h |  1 +
>>>>> drivers/md/bcache/super.c | 15 ++++++++++++++-
>>>>> 3 files changed, 50 insertions(+), 1 deletion(-)
>>>>>=20
>>>>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>>>>> index e136d6edc1ed..a5d54af73111 100644
>>>>> --- a/drivers/md/bcache/btree.c
>>>>> +++ b/drivers/md/bcache/btree.c
>>>>> @@ -2755,6 +2755,41 @@ struct keybuf_key =
*bch_keybuf_next_rescan(struct cache_set *c,
>>>>> 	return ret;
>>>>> }
>>>>>=20
>>>>> +static bool check_pred(struct keybuf *buf, struct bkey *k)
>>>>> +{
>>>>> +	return true;
>>>>> +}
>>>>> +
>>>>> +bool bch_btree_can_inode_reuse(struct cache_set *c, size_t inode)
>>>>> +{
>>>>> +	bool ret =3D true;
>>>>> +	struct keybuf_key *k;
>>>>> +	struct bkey end_key =3D KEY(inode, MAX_KEY_OFFSET, 0);
>>>>> +	struct keybuf *keys =3D kzalloc(sizeof(struct keybuf), =
GFP_KERNEL);
>>>>> +
>>>>> +	if (!keys) {
>>>>> +		ret =3D false;
>>>>> +		goto out;
>>>>> +	}
>>>>> +
>>>>> +	bch_keybuf_init(keys);
>>>>> +	keys->last_scanned =3D KEY(inode, 0, 0);
>>>>> +
>>>>> +	while (ret) {
>>>>> +		k =3D bch_keybuf_next_rescan(c, keys, &end_key, =
check_pred);
>>>>> +		if (!k)
>>>>>=20
>>>> This is a single thread iteration, for a large filled cache device =
it can be very slow. I observed 40+ minutes during my testing.
>>>>=20
>>>>=20
>>>> Coly Li
>>>>=20
>>>>=20
> Hi, Coly
>=20
> I use a 200G cache  device to test this patch. For faster testing, the =
bucket_size is set to 16k.
>=20
> ```
>=20
> [root@node-3 ~]# lsblk -s /dev/bcache4
> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> bcache4     251:512  0  500G  0 disk
> =E2=94=9C=E2=94=80rbd4      253:64   0  500G  0 disk
> =E2=94=94=E2=94=80nvme1n1p6 259:12   0  200G  0 part
>   =E2=94=94=E2=94=80nvme1n1 259:6    0  1.8T  0 disk
>=20
> [root@node-3 ~]# bcache-super-show  /dev/nvme1n1p6
> sb.magic        ok
> sb.first_sector        8 [match]
> sb.csum            53512B9BA99771C5 [match]
> sb.version        3 [cache device]
>=20
> dev.label        (empty)
> dev.uuid        007cf801-98bf-4d00-87e5-6e9127c83622
> dev.sectors_per_block    8
> dev.sectors_per_bucket    32
> dev.cache.first_sector    32
> dev.cache.cache_sectors    419430368
> dev.cache.total_sectors    419430400
> dev.cache.ordered    yes
> dev.cache.discard    no
> dev.cache.pos        0
> dev.cache.replacement    1 [fifo]
>=20
> cset.uuid        024c6ef2-ec7d-4f31-aadc-171e9be748e2
> ```
>=20
> The test steps are as follows=EF=BC=9A
>=20
> 1. attach the backing device to the cache device
>=20
> 2. set sysfs (cache_mode set to writeback, etc)
>=20
> 3. fio randwrite 10G data
>=20
> 4.the backing device from the cache device
>=20
> The for loop executes above steps
>=20
>=20
> I added  some dmesg print information in code:
>=20
> ```
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index fba0e538e46e..fd15b1dc8346 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -2783,6 +2783,7 @@ static bool check_pred(struct keybuf *buf, =
struct bkey *k)
>=20
>  bool bch_btree_can_inode_reuse(struct cache_set *c, size_t inode)
>  {
> +       size_t rescan =3D 0;
>         bool ret =3D true;
>         struct keybuf_key *k;
>         struct bkey end_key =3D KEY(inode, MAX_KEY_OFFSET, 0);
> @@ -2793,10 +2794,12 @@ bool bch_btree_can_inode_reuse(struct =
cache_set *c, size_t inode)
>                 goto out;
>         }
>=20
> +       pr_info("try to reuse inode %zu", inode);
>         bch_keybuf_init(keys);
>         keys->last_scanned =3D KEY(inode, 0, 0);
>=20
>         while (ret) {
> +               rescan++;
>                 k =3D bch_keybuf_next_rescan(c, keys, &end_key, =
check_pred);
>                 if (!k)
>                         break;
> @@ -2806,6 +2809,7 @@ bool bch_btree_can_inode_reuse(struct cache_set =
*c, size_t inode)
>                 bch_keybuf_del(keys, k);
>         }
>=20
> +       pr_info("inode %zu rescan %zu", inode, rescan);
>         kfree(keys);
>  out:
>         return ret;
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 8335aedaffa9..7427fdacf61b 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -472,10 +472,13 @@ static struct uuid_entry *uuid_find_reuse(struct =
cache_set *c)
>  {
>         struct uuid_entry *u;
>=20
> +       pr_info("reuse invalid_uuid");
>         for (u =3D c->uuids; u < c->uuids + c->nr_uuids; u++)
>                 if (!memcmp(u->uuid, invalid_uuid, 16) &&
> -                   bch_btree_can_inode_reuse(c, u - c->uuids))
> +                   bch_btree_can_inode_reuse(c, u - c->uuids)) {
> +                       pr_info("reuse inode %zu", u - c->uuids);
>                         return u;
> +               }
>=20
>         return NULL;
>  }
> ```
>=20
>=20
> These are dmesg output:
>=20
> ```
>=20
> [148602.383377] bcache: uuid_find_reuse() reuse invalid_uuid
> [148602.383883] bcache: bch_btree_can_inode_reuse() try to reuse inode =
0
> [148602.384402] bcache: bch_btree_can_inode_reuse() inode 0 rescan 1
> [148602.384897] bcache: bch_btree_can_inode_reuse() try to reuse inode =
1
> [148602.385399] bcache: bch_btree_can_inode_reuse() inode 1 rescan 1
> [148602.385893] bcache: bch_btree_can_inode_reuse() try to reuse inode =
2
> [148602.386406] bcache: bch_btree_can_inode_reuse() inode 2 rescan 1
> [148602.386901] bcache: bch_btree_can_inode_reuse() try to reuse inode =
3
> [148602.387408] bcache: bch_btree_can_inode_reuse() inode 3 rescan 1
> [148602.387903] bcache: bch_btree_can_inode_reuse() try to reuse inode =
4
> [148602.388405] bcache: bch_btree_can_inode_reuse() inode 4 rescan 1
> [148602.388898] bcache: bch_btree_can_inode_reuse() try to reuse inode =
5
> [148602.389400] bcache: bch_btree_can_inode_reuse() inode 5 rescan 1
> [148602.389891] bcache: bch_btree_can_inode_reuse() try to reuse inode =
6
> [148602.390391] bcache: bch_btree_can_inode_reuse() inode 6 rescan 1
> [148602.390967] bcache: bch_btree_can_inode_reuse() try to reuse inode =
7
> [148602.391464] bcache: bch_btree_can_inode_reuse() inode 7 rescan 1
> [148602.391953] bcache: bch_btree_can_inode_reuse() try to reuse inode =
8
> [148602.392455] bcache: bch_btree_can_inode_reuse() inode 8 rescan 1
> [148602.392949] bcache: bch_btree_can_inode_reuse() try to reuse inode =
9
> [148602.403515] bcache: bch_btree_can_inode_reuse() inode 9 rescan 1
> [148602.404004] bcache: bch_btree_can_inode_reuse() try to reuse inode =
10
> [148602.404504] bcache: bch_btree_can_inode_reuse() inode 10 rescan 1
> [148602.405082] bcache: bch_btree_can_inode_reuse() try to reuse inode =
11
> [148602.405581] bcache: bch_btree_can_inode_reuse() inode 11 rescan 1
> [148602.406077] bcache: bch_btree_can_inode_reuse() try to reuse inode =
12
> [148602.406580] bcache: bch_btree_can_inode_reuse() inode 12 rescan 1
> [148602.407074] bcache: bch_btree_can_inode_reuse() try to reuse inode =
13
> [148602.407573] bcache: bch_btree_can_inode_reuse() inode 13 rescan 1
> [148602.408064] bcache: bch_btree_can_inode_reuse() try to reuse inode =
14
> [148602.408563] bcache: bch_btree_can_inode_reuse() inode 14 rescan 1
> [148602.409052] bcache: bch_btree_can_inode_reuse() try to reuse inode =
15
> [148602.409549] bcache: bch_btree_can_inode_reuse() inode 15 rescan 1
> [148602.410039] bcache: bch_btree_can_inode_reuse() try to reuse inode =
16
> [148602.410537] bcache: bch_btree_can_inode_reuse() inode 16 rescan 1
> [148602.411027] bcache: bch_btree_can_inode_reuse() try to reuse inode =
17
> [148602.411527] bcache: bch_btree_can_inode_reuse() inode 17 rescan 1
> [148602.412018] bcache: bch_btree_can_inode_reuse() try to reuse inode =
18
> [148602.412519] bcache: bch_btree_can_inode_reuse() inode 18 rescan 1
> [148602.413009] bcache: bch_btree_can_inode_reuse() try to reuse inode =
19
> [148602.413516] bcache: bch_btree_can_inode_reuse() inode 19 rescan 1
> [148602.414008] bcache: bch_btree_can_inode_reuse() try to reuse inode =
20
> [148602.414552] bcache: bch_btree_can_inode_reuse() inode 20 rescan 1
> [148602.415041] bcache: bch_btree_can_inode_reuse() try to reuse inode =
21
> [148602.415594] bcache: bch_btree_can_inode_reuse() inode 21 rescan 1
> [148602.416082] bcache: bch_btree_can_inode_reuse() try to reuse inode =
22
> [148602.416730] bcache: bch_btree_can_inode_reuse() inode 22 rescan 1
> [148602.417219] bcache: bch_btree_can_inode_reuse() try to reuse inode =
23
> [148602.417928] bcache: bch_btree_can_inode_reuse() inode 23 rescan 1
> [148602.418422] bcache: bch_btree_can_inode_reuse() try to reuse inode =
24
> [148602.419142] bcache: bch_btree_can_inode_reuse() inode 24 rescan 1
> [148602.419654] bcache: bch_btree_can_inode_reuse() try to reuse inode =
25
> [148602.420364] bcache: bch_btree_can_inode_reuse() inode 25 rescan 1
> [148602.420851] bcache: bch_btree_can_inode_reuse() try to reuse inode =
26
> [148602.421578] bcache: bch_btree_can_inode_reuse() inode 26 rescan 1
> [148602.422072] bcache: bch_btree_can_inode_reuse() try to reuse inode =
27
> [148602.422778] bcache: bch_btree_can_inode_reuse() inode 27 rescan 1
> [148602.423267] bcache: bch_btree_can_inode_reuse() try to reuse inode =
28
> [148602.423972] bcache: bch_btree_can_inode_reuse() inode 28 rescan 1
> [148602.424466] bcache: bch_btree_can_inode_reuse() try to reuse inode =
29
> [148602.425174] bcache: bch_btree_can_inode_reuse() inode 29 rescan 1
> [148602.425668] bcache: bch_btree_can_inode_reuse() try to reuse inode =
30
> [148602.426371] bcache: bch_btree_can_inode_reuse() inode 30 rescan 1
> [148602.426859] bcache: bch_btree_can_inode_reuse() try to reuse inode =
31
> [148602.427570] bcache: bch_btree_can_inode_reuse() inode 31 rescan 1
> [148602.428060] bcache: bch_btree_can_inode_reuse() try to reuse inode =
32
> [148602.428764] bcache: bch_btree_can_inode_reuse() inode 32 rescan 1
> [148602.429251] bcache: bch_btree_can_inode_reuse() try to reuse inode =
33
> [148602.429942] bcache: bch_btree_can_inode_reuse() inode 33 rescan 1
> [148602.430437] bcache: bch_btree_can_inode_reuse() try to reuse inode =
34
> [148602.431127] bcache: bch_btree_can_inode_reuse() inode 34 rescan 1
> [148602.431622] bcache: bch_btree_can_inode_reuse() try to reuse inode =
35
> [148602.432323] bcache: bch_btree_can_inode_reuse() inode 35 rescan 1
> [148602.432820] bcache: bch_btree_can_inode_reuse() try to reuse inode =
36
> [148602.433516] bcache: bch_btree_can_inode_reuse() inode 36 rescan 1
> [148602.434004] bcache: bch_btree_can_inode_reuse() try to reuse inode =
37
> [148602.434681] bcache: bch_btree_can_inode_reuse() inode 37 rescan 1
> [148602.435169] bcache: bch_btree_can_inode_reuse() try to reuse inode =
38
> [148602.435673] bcache: bch_btree_can_inode_reuse() inode 38 rescan 1
> [148602.436159] bcache: uuid_find_reuse() reuse inode 38
>=20
> ```
>=20
> According to my tests, even if the cache device is very large, the =
reuse time cost should be acceptable, should not be 40+ minutes.

Yes from your testing, of course it is not 40+ minutes.

What I said was 90G+ btree nodes, it should be around 1.5-2T cached data =
with 512byte block size. It has been a long time when the registration =
process was not multi-threaded. Roughly the btree nodes checking spent =
around 15-20 minutes, and the dirty sectors counting for backing device =
spent 20-25 minutes.

To generate such large meta data, it took around a whole day by fio with =
10 jobs and 512 bytes block size, on a 4T NVMe SSD as cache. Such =
configuration is quite easy to see nowadays in enterprise environment.

Indeed event reduce the registration time to 1/10 is still not ideal, it =
may still exceed the udev 120 seconds timeout and causes problem during =
boot time. This is why I added the asynchronized registration Kconfg =
item to avoid blocking udev task too much time.

Coly Li




