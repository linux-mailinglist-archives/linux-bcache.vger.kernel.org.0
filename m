Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F5853EB73
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jun 2022 19:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbiFFKeo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jun 2022 06:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbiFFKen (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jun 2022 06:34:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C642D2EA00
        for <linux-bcache@vger.kernel.org>; Mon,  6 Jun 2022 03:34:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6EB03219F3;
        Mon,  6 Jun 2022 10:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654511676; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JfObIgWnyTl46pgpXQ0lHNqqZE4sWGtq3+9aV/6WZFA=;
        b=Lunv0ovASv2XyRCU2R2+htCQlcLje/RBaelKoU6Kmz6mzu2Fi/N+1tvDmSrvHM0gum0cEh
        pzQOPcE1XD8JHbGiAB8UeFeAxI06vICkZqtNA9J2QTWMR8VbPliW++wc2RE0ZBGV3EmxPp
        czZwU9Lx0yilp4ffxwFsT2KWBL5phfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654511676;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JfObIgWnyTl46pgpXQ0lHNqqZE4sWGtq3+9aV/6WZFA=;
        b=KnkdFEh3XhQKarzyAQUficfj7TfwdCSOLkF3uh20Ik5TAYX5UsQt728pqleAnwEpVfZwEk
        FqYePAp7slGLW+Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 88431139F5;
        Mon,  6 Jun 2022 10:34:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MxP0FTvYnWKoGAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 06 Jun 2022 10:34:35 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] bcache: try to reuse the slot of invalid_uuid
From:   Coly Li <colyli@suse.de>
In-Reply-To: <f19c392f-6ad8-9e0c-a8f7-de2339f76cb6@easystack.cn>
Date:   Mon, 6 Jun 2022 18:34:33 +0800
Cc:     linux-bcache@vger.kernel.org, dongsheng.yang@easystack.cn,
        zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <31FA99EB-4E02-4241-9264-248A03FABA4E@suse.de>
References: <20220606084522.12680-1-mingzhe.zou@easystack.cn>
 <780B6E6E-F4A8-4801-AED3-8DF81054D491@suse.de>
 <f19c392f-6ad8-9e0c-a8f7-de2339f76cb6@easystack.cn>
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



> 2022=E5=B9=B46=E6=9C=886=E6=97=A5 17:29=EF=BC=8CZou Mingzhe =
<mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
> =E5=9C=A8 2022/6/6 16:57, Coly Li =E5=86=99=E9=81=93:
>>=20
>>> 2022=E5=B9=B46=E6=9C=886=E6=97=A5 16:45=EF=BC=8Cmingzhe.zou@easystack.=
cn
>>>  =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> From: mingzhe=20
>>> <mingzhe.zou@easystack.cn>
>>>=20
>>>=20
>>>=20
>>>=20
>> [snipped]
>>=20
>>=20
>>> We want to use those invalid_uuid slots carefully. Because, the bkey =
of the inode
>>> may still exist in the btree. So, we need to check the btree before =
reuse it.
>>>=20
>>> Signed-off-by: mingzhe=20
>>> <mingzhe.zou@easystack.cn>
>>>=20
>>> ---
>>> drivers/md/bcache/btree.c | 35 +++++++++++++++++++++++++++++++++++
>>> drivers/md/bcache/btree.h |  1 +
>>> drivers/md/bcache/super.c | 15 ++++++++++++++-
>>> 3 files changed, 50 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>>> index e136d6edc1ed..a5d54af73111 100644
>>> --- a/drivers/md/bcache/btree.c
>>> +++ b/drivers/md/bcache/btree.c
>>> @@ -2755,6 +2755,41 @@ struct keybuf_key =
*bch_keybuf_next_rescan(struct cache_set *c,
>>> 	return ret;
>>> }
>>>=20
>>> +static bool check_pred(struct keybuf *buf, struct bkey *k)
>>> +{
>>> +	return true;
>>> +}
>>> +
>>> +bool bch_btree_can_inode_reuse(struct cache_set *c, size_t inode)
>>> +{
>>> +	bool ret =3D true;
>>> +	struct keybuf_key *k;
>>> +	struct bkey end_key =3D KEY(inode, MAX_KEY_OFFSET, 0);
>>> +	struct keybuf *keys =3D kzalloc(sizeof(struct keybuf), =
GFP_KERNEL);
>>> +
>>> +	if (!keys) {
>>> +		ret =3D false;
>>> +		goto out;
>>> +	}
>>> +
>>> +	bch_keybuf_init(keys);
>>> +	keys->last_scanned =3D KEY(inode, 0, 0);
>>> +
>>> +	while (ret) {
>>> +		k =3D bch_keybuf_next_rescan(c, keys, &end_key, =
check_pred);
>>> +		if (!k)
>>>=20
>>=20
>> This is a single thread iteration, for a large filled cache device it =
can be very slow. I observed 40+ minutes during my testing.
>>=20
>>=20
>> Coly Li
>>=20
>>=20
> Hi, Coly
>=20
> We first use the zero_uuid slot, and reuse only if there is no =
zero_uuid slot. This is just an imperfect solution to make bcache =
available, so we haven't tested its performance. We think we will =
eventually need to actively clean up these bkeys in a new thread and =
reset the invalid_uuid to zero_uuid.

Current method is the simplest, trust me, there is no much fun to play =
with register lock, writeback lock, and the btree node locks, live is =
not easy already...

Coly Li


