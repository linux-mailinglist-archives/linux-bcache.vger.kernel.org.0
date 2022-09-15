Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1975B9EAF
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Sep 2022 17:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiIOPX6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 15 Sep 2022 11:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiIOPXh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Sep 2022 11:23:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062942BDA
        for <linux-bcache@vger.kernel.org>; Thu, 15 Sep 2022 08:23:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3D41A1F8E7;
        Thu, 15 Sep 2022 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663255413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sj+SSGHM7RKKzHKIVN8cGO24CqUQZhQOUcYDCNToXLo=;
        b=zlcgUqoXTnO/EugMGjRlyGKFiWSs7VozOKGsvIInSCqv8IacCGwtVhgqXFTSBX/kdGlCAs
        PTJTuxwTEHocxv6ikQQz080//tSTZTdz5xEqKWf50SBj5Oipdc9xkIZ0QpvvTuKxOfwbXJ
        ZGL7VfcrNXDdSvYVqiTuzAAefq8rCQQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663255413;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sj+SSGHM7RKKzHKIVN8cGO24CqUQZhQOUcYDCNToXLo=;
        b=Mns8sYZmrbDx5w7Erb/wCVtXBkJXyuRETtMxe0SpG/XhK12/oN31OtJYsd5DqHaVulQVA0
        uPcXpyADxMmUpLBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 50CEC13A49;
        Thu, 15 Sep 2022 15:23:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dgl8B3RDI2MQEgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 15 Sep 2022 15:23:32 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH] bcache: limit multiple flash devices size
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220914060657.22102-1-mingzhe.zou@easystack.cn>
Date:   Thu, 15 Sep 2022 23:23:29 +0800
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <DC88819F-BB84-4766-A8FB-8637B6686D5F@suse.de>
References: <20220914060657.22102-1-mingzhe.zou@easystack.cn>
To:     mingzhe.zou@easystack.cn
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=8814=E6=97=A5 14:06=EF=BC=8Cmingzhe.zou@easystack.c=
n =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: mingzhe <mingzhe.zou@easystack.cn>
>=20
> Bcache allows multiple flash devices to be created on the same cache.
> We can create multiple flash devices, and the total size larger than
> cache device's actual size.
> ```
> [root@zou ~]# lsblk /dev/vdd
> NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdd        252:48   0  100G  0 disk
> [root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
> [root@zou ~]# lsblk /dev/vdd
> NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdd        252:48   0  100G  0 disk
> =E2=94=94=E2=94=80bcache1  251:128  0   50G  0 disk
> [root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
> [root@zou ~]# lsblk /dev/vdd
> NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdd        252:48   0  100G  0 disk
> =E2=94=9C=E2=94=80bcache2  251:256  0   50G  0 disk
> =E2=94=94=E2=94=80bcache1  251:128  0   50G  0 disk
> [root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
> [root@zou ~]# lsblk /dev/vdd
> NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdd        252:48   0  100G  0 disk
> =E2=94=9C=E2=94=80bcache3  251:256  0   50G  0 disk
> =E2=94=9C=E2=94=80bcache2  251:256  0   50G  0 disk
> =E2=94=94=E2=94=80bcache1  251:128  0   50G  0 disk
> ```
>=20
> This patch will limit the total size of multi-flash device, until no
> free space to create a new flash device with an error.
> ```
> [root@zou ~]# lsblk /dev/vdd
> NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdd        252:48   0  100G  0 disk
> [root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
> [root@zou ~]# lsblk /dev/vdd
> NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdd        252:48   0  100G  0 disk
> =E2=94=94=E2=94=80bcache1  251:128  0   50G  0 disk
> [root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
> [root@zou ~]# lsblk /dev/vdd
> NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdd        252:48   0  100G  0 disk
> =E2=94=9C=E2=94=80bcache2  251:256  0 39.9G  0 disk
> =E2=94=94=E2=94=80bcache1  251:128  0   50G  0 disk
> [root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
> -bash: echo: write error: Invalid argument
> [root@zou ~]# lsblk /dev/vdd
> NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdd        252:48   0  100G  0 disk
> =E2=94=9C=E2=94=80bcache2  251:256  0 39.9G  0 disk
> =E2=94=94=E2=94=80bcache1  251:128  0   50G  0 disk
> ```
>=20
> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
> ---
> drivers/md/bcache/super.c | 13 ++++++++++++-
> 1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 214a384dc1d7..e019cfd793eb 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1581,13 +1581,20 @@ static int flash_devs_run(struct cache_set *c)
>=20
> static inline sector_t flash_dev_max_sectors(struct cache_set *c)
> {
> +	sector_t sectors;
> +	struct uuid_entry *u;
> 	size_t avail_nbuckets;
> 	struct cache *ca =3D c->cache;
> 	size_t first_bucket =3D ca->sb.first_bucket;
> 	size_t njournal_buckets =3D ca->sb.njournal_buckets;
>=20
> 	avail_nbuckets =3D c->nbuckets - first_bucket - =
njournal_buckets;
> -	return bucket_to_sector(c, avail_nbuckets / 100 * =
FLASH_DEV_AVAILABLE_RATIO);
> +	sectors =3D bucket_to_sector(c, avail_nbuckets / 100 * =
FLASH_DEV_AVAILABLE_RATIO);
> +
> +	for (u =3D c->uuids; u < c->uuids + c->nr_uuids && sectors > 0; =
u++)
> +		if (UUID_FLASH_ONLY(u))
> +			sectors -=3D min(u->sectors, sectors);
> +	return sectors;

The value returned from flash_dev_max_sectors() is the buckets number =
which not allocated to flash devices. But it might not always be the =
allocable free buckets for new flash device. Because some of the buckets =
might be allocated to btree nodes, or cached dirty data. Although these =
space might be shrunk eventually, we should always avoid to use up all =
the free buckets.

Therefore, the exact free bucket amount should be calculated =E2=80=94-- =
no cheap method to do it.

There is a variable cache_set->avail_nbuckets for current available =
buckets, but it is updated after gc accomplished and not a =
updated-in-time value. So this value is always <=3D real available =
buckets. That is to say, if the creating flash device size < =
(cache_set->avail_nbuckets - reserved_buckets), the creation failed but =
there might be enough free buckets for the creating flash device. This =
is very probably to happen because  cache_set->avail_nbuckets is not =
refreshed frequently.


> }
>=20
> int bch_flash_dev_create(struct cache_set *c, uint64_t size)
> @@ -1612,6 +1619,10 @@ int bch_flash_dev_create(struct cache_set *c, =
uint64_t size)
>=20
> 	SET_UUID_FLASH_ONLY(u, 1);
> 	u->sectors =3D min(flash_dev_max_sectors(c), size >> 9);
> +	if (!u->sectors) {
> +		pr_err("Can't create volume, no free space");
> +		return -EINVAL;
> +	}


The idea is cool. But current code doesn=E2=80=99t solve the target =
problem, and I don=E2=80=99t have better solution in my brain yet...


Thanks.

Coly Li

>=20
> 	bch_uuid_write(c);
>=20
> --=20
> 2.17.1
>=20

