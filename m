Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9238B53E9DC
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jun 2022 19:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiFFI6J (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jun 2022 04:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiFFI6F (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jun 2022 04:58:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA6C9A99C
        for <linux-bcache@vger.kernel.org>; Mon,  6 Jun 2022 01:58:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9F65321A53;
        Mon,  6 Jun 2022 08:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654505879; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ockgaakXccN0pEpHpOWG4Nixp45uTt5BlgGW/BgGlYk=;
        b=ahmv9PB1sp1TdJkpo7G7Ub2q9nOb3N20gaFhCFA2NUCV48fJzV8k4/RlOwaON9DolElpZ9
        SHlls2ZBChEI3SD0U72QRuAVi3RdgrX3h76lLQbGtPZyWXjIPojSOtXghQQztyHXuMkEvV
        aJ83aXlGjh4alXAHgEgyB+YRhAhUAH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654505879;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ockgaakXccN0pEpHpOWG4Nixp45uTt5BlgGW/BgGlYk=;
        b=eRLAf06P1klzHS5edXKNL6k1DkLgh2n8nwX9vLCxTG70JgwXvWseYC5WvSjF8OVKB5mzIy
        U+7sHVlnfSzf7DDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69F9413A5F;
        Mon,  6 Jun 2022 08:57:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CMpiCpbBnWJAdAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 06 Jun 2022 08:57:58 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] bcache: try to reuse the slot of invalid_uuid
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220606084522.12680-1-mingzhe.zou@easystack.cn>
Date:   Mon, 6 Jun 2022 16:57:55 +0800
Cc:     linux-bcache@vger.kernel.org, dongsheng.yang@easystack.cn,
        zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <780B6E6E-F4A8-4801-AED3-8DF81054D491@suse.de>
References: <20220606084522.12680-1-mingzhe.zou@easystack.cn>
To:     mingzhe.zou@easystack.cn
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



> 2022=E5=B9=B46=E6=9C=886=E6=97=A5 16:45=EF=BC=8Cmingzhe.zou@easystack.cn=
 =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: mingzhe <mingzhe.zou@easystack.cn>
>=20
>=20

[snipped]

> We want to use those invalid_uuid slots carefully. Because, the bkey =
of the inode
> may still exist in the btree. So, we need to check the btree before =
reuse it.
>=20
> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
> ---
> drivers/md/bcache/btree.c | 35 +++++++++++++++++++++++++++++++++++
> drivers/md/bcache/btree.h |  1 +
> drivers/md/bcache/super.c | 15 ++++++++++++++-
> 3 files changed, 50 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index e136d6edc1ed..a5d54af73111 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -2755,6 +2755,41 @@ struct keybuf_key =
*bch_keybuf_next_rescan(struct cache_set *c,
> 	return ret;
> }
>=20
> +static bool check_pred(struct keybuf *buf, struct bkey *k)
> +{
> +	return true;
> +}
> +
> +bool bch_btree_can_inode_reuse(struct cache_set *c, size_t inode)
> +{
> +	bool ret =3D true;
> +	struct keybuf_key *k;
> +	struct bkey end_key =3D KEY(inode, MAX_KEY_OFFSET, 0);
> +	struct keybuf *keys =3D kzalloc(sizeof(struct keybuf), =
GFP_KERNEL);
> +
> +	if (!keys) {
> +		ret =3D false;
> +		goto out;
> +	}
> +
> +	bch_keybuf_init(keys);
> +	keys->last_scanned =3D KEY(inode, 0, 0);
> +
> +	while (ret) {
> +		k =3D bch_keybuf_next_rescan(c, keys, &end_key, =
check_pred);
> +		if (!k)


This is a single thread iteration, for a large filled cache device it =
can be very slow. I observed 40+ minutes during my testing.


Coly Li



> +			break;
> +
> +		if (KEY_INODE(&k->key) =3D=3D inode)
> +			ret =3D false;
> +		bch_keybuf_del(keys, k);
> +	}
> +
> +	kfree(keys);
> +out:
> +	return ret;
> +}
> +
> void bch_keybuf_init(struct keybuf *buf)
> {
> 	buf->last_scanned	=3D MAX_KEY;
> diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
> index 1b5fdbc0d83e..c3e6094adb62 100644
> --- a/drivers/md/bcache/btree.h
> +++ b/drivers/md/bcache/btree.h
> @@ -413,4 +413,5 @@ struct keybuf_key *bch_keybuf_next_rescan(struct =
cache_set *c,
> 					  struct bkey *end,
> 					  keybuf_pred_fn *pred);
> void bch_update_bucket_in_use(struct cache_set *c, struct gc_stat =
*stats);
> +bool bch_btree_can_inode_reuse(struct cache_set *c, size_t inode);
> #endif
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 3563d15dbaf2..31f7aa347561 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -544,11 +544,24 @@ static struct uuid_entry *uuid_find(struct =
cache_set *c, const char *uuid)
> 	return NULL;
> }
>=20
> +static struct uuid_entry *uuid_find_reuse(struct cache_set *c)
> +{
> +	struct uuid_entry *u;
> +
> +	for (u =3D c->uuids; u < c->uuids + c->nr_uuids; u++)
> +		if (!memcmp(u->uuid, invalid_uuid, 16) &&
> +		    bch_btree_can_inode_reuse(c, u - c->uuids))
> +			return u;
> +
> +	return NULL;
> +}
> +
> static struct uuid_entry *uuid_find_empty(struct cache_set *c)
> {
> 	static const char zero_uuid[16] =3D =
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
> +	struct uuid_entry *u =3D uuid_find(c, zero_uuid);
>=20
> -	return uuid_find(c, zero_uuid);
> +	return u ? u : uuid_find_reuse(c);
> }
>=20
> /*
> --=20
> 2.17.1
>=20

