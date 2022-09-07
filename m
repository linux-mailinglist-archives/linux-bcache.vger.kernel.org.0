Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298A95B0B49
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Sep 2022 19:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiIGRQE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Sep 2022 13:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiIGRQD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Sep 2022 13:16:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96967BC82F
        for <linux-bcache@vger.kernel.org>; Wed,  7 Sep 2022 10:15:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2359233F79;
        Wed,  7 Sep 2022 17:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662570958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/gpCjnHHMyPm2Q9RayhETH3k91oxiLXLcCn8QMwAtls=;
        b=08avm11FAwNTz8fniFYFfLPuKbC7Al421JDuFno8Ky4cN6l1mrK+wmIO/k3zPi80U0A1Y2
        tfJON1o9xRdqPBirWAEp6U9X2BnLg5wQskyb05Hc2USv7MH9Uqpn0G0EVBxeRK8Z8oEenn
        561EINI3ShxnIkFo5/E57drQeCuxirU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662570958;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/gpCjnHHMyPm2Q9RayhETH3k91oxiLXLcCn8QMwAtls=;
        b=03OlJmj8oHmkbTwMtKdKweMgCnoDNQv8ngg+3P03nSRPCJ0K3ynVfVMLLefzRlQ9LSzyap
        A8fHVNOySGflCXBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4F31313A66;
        Wed,  7 Sep 2022 17:15:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7u8MB83RGGNNBQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 07 Sep 2022 17:15:57 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH] bcache: limit create flash device size
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220907112913.16488-1-mingzhe.zou@easystack.cn>
Date:   Thu, 8 Sep 2022 01:15:52 +0800
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <AA4299A9-337A-4710-89DA-5C1E3520DA91@suse.de>
References: <20220907112913.16488-1-mingzhe.zou@easystack.cn>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=887=E6=97=A5 19:29=EF=BC=8Cmingzhe.zou@easystack.cn=
 =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: mingzhe <mingzhe.zou@easystack.cn>
>=20
> Currently, size is specified and not checked when creating a flash =
device.
> This will cause a problem, IO maybe hang when creating a flash device =
with
> the actual size of the device.
>=20
> ```
> 	if (attr =3D=3D &sysfs_flash_vol_create) {
> 		int r;
> 		uint64_t v;
>=20
> 		strtoi_h_or_return(buf, v);
>=20
> 		r =3D bch_flash_dev_create(c, v);
> 		if (r)
> 			return r;
> 	}
> ```
>=20
> Because the flash device needs some space for superblock, journal and =
btree.
> If the size of data reaches the available size, the new IO cannot =
allocate
> space and will hang. At this time, the gc thread will be started =
frequently.
>=20
> Even more unreasonable, we can create flash devices larger than actual =
size.
>=20
> ```
> [root@zou ~]# echo 2G > /sys/block/vdb/bcache/set/flash_vol_create
> [root@zou ~]# lsblk /dev/vdb
> NAME       MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
> vdb        252:16   0   1G  0 disk
> =E2=94=94=E2=94=80bcache0  251:0    0   2G  0 disk
> ```
>=20
> This patch will limit the size of flash device, reserving at least 5% =
of
> available size for the btree.
>=20
> ```
> [root@zou ~]# echo 2G > /sys/block/vdb/bcache/set/flash_vol_create
> [root@zou ~]# lsblk /dev/vdb
> NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdb        252:16   0    1G  0 disk
> =E2=94=94=E2=94=80bcache0  251:0    0  950M  0 disk
> ```
>=20
> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
> ---
> drivers/md/bcache/super.c | 13 ++++++++++++-
> 1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..f41e09e0e8ee 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1579,6 +1579,17 @@ static int flash_devs_run(struct cache_set *c)
> 	return ret;
> }
>=20


Hi Mingzhe,

> +static inline sector_t flash_dev_max_sectors(struct cache_set *c)
> +{
> +	size_t avail_nbuckets;
> +	struct cache *ca =3D c->cache;
> +	size_t first_bucket =3D ca->sb.first_bucket;
> +	size_t njournal_buckets =3D ca->sb.njournal_buckets;
> +
> +	avail_nbuckets =3D c->nbuckets - first_bucket - =
njournal_buckets;
> +	return bucket_to_sector(c, avail_nbuckets / 100 * 95);
> +}

Overall I like this idea. This is really something I didn=E2=80=99t =
realize to fix, nice catch!

BTW, I feel 95% is still quite high rate, how about using 90%? And you =
may define the rate as a macro in bcache.h.

Thanks for this patch.

Coly Li

> +
> int bch_flash_dev_create(struct cache_set *c, uint64_t size)
> {
> 	struct uuid_entry *u;
> @@ -1600,7 +1611,7 @@ int bch_flash_dev_create(struct cache_set *c, =
uint64_t size)
> 	u->first_reg =3D u->last_reg =3D =
cpu_to_le32((u32)ktime_get_real_seconds());
>=20
> 	SET_UUID_FLASH_ONLY(u, 1);
> -	u->sectors =3D size >> 9;
> +	u->sectors =3D min(flash_dev_max_sectors(c), size >> 9);
>=20
> 	bch_uuid_write(c);
>=20
> --=20
> 2.17.1
>=20

