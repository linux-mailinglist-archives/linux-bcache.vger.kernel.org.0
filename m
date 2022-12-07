Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B9B645A59
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Dec 2022 14:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiLGNFH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Dec 2022 08:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLGNFG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Dec 2022 08:05:06 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521F1554D4;
        Wed,  7 Dec 2022 05:05:05 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CFF5321CAD;
        Wed,  7 Dec 2022 13:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1670418303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C1QfEziAeDcGEDzwXJANuiEADJn/6tF2TC6ZG3Sw5AU=;
        b=0HatBERdGReczXGRd8FOK81z1FazdvS9074cVnjDl68kk7D1QeDE67ud/6efHedB5o2qc7
        yi0RzOd5CWTIGirgjlnWPZIOhSL8OmqGEWVu1l4Y4fiy8VbF4iJS3UJIcCPSMK9TI5kR+6
        YKMiJMZ2dSbAyYmnppr48nYPqLASlEQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1670418303;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C1QfEziAeDcGEDzwXJANuiEADJn/6tF2TC6ZG3Sw5AU=;
        b=Xv2Et2gOs310IJlWOnB4TJ4oi5izH0foJ5Bpov0oX9YEf5AntHW7vWA8LHzKK3go+3bBWC
        GS0YqyR/pER3ODAQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id C62E9134CD;
        Wed,  7 Dec 2022 13:05:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 5o/mIn6PkGPqYQAAGKfGzw
        (envelope-from <colyli@suse.de>); Wed, 07 Dec 2022 13:05:02 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] bcache: Convert to use sysfs_emit()/sysfs_emit_at() APIs
From:   Coly Li <colyli@suse.de>
In-Reply-To: <202212071702359325169@zte.com.cn>
Date:   Wed, 7 Dec 2022 21:04:50 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0DC3481B-747E-4874-BDD5-47016A0C4916@suse.de>
References: <202212071702359325169@zte.com.cn>
To:     ye.xingchen@zte.com.cn
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B412=E6=9C=887=E6=97=A5 17:02=EF=BC=8C<ye.xingchen@zte.com.cn=
> <ye.xingchen@zte.com.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: ye xingchen <ye.xingchen@zte.com.cn>
>=20
> Follow the advice of the Documentation/filesystems/sysfs.rst and =
show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.
>=20
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>

Added to my for-next queue for Linux v6.3 merge window.

Thanks.

Coly Li


> ---
> drivers/md/bcache/sysfs.c | 31 +++++++++++++++----------------
> 1 file changed, 15 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index c6f677059214..0e2c1880f60b 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -1111,26 +1111,25 @@ SHOW(__bch_cache)
>=20
> vfree(p);
>=20
> - ret =3D scnprintf(buf, PAGE_SIZE,
> - "Unused: %zu%%\n"
> - "Clean: %zu%%\n"
> - "Dirty: %zu%%\n"
> - "Metadata: %zu%%\n"
> - "Average: %llu\n"
> - "Sectors per Q: %zu\n"
> - "Quantiles: [",
> - unused * 100 / (size_t) ca->sb.nbuckets,
> - available * 100 / (size_t) ca->sb.nbuckets,
> - dirty * 100 / (size_t) ca->sb.nbuckets,
> - meta * 100 / (size_t) ca->sb.nbuckets, sum,
> - n * ca->sb.bucket_size / (ARRAY_SIZE(q) + 1));
> + ret =3D sysfs_emit(buf,
> + "Unused: %zu%%\n"
> + "Clean: %zu%%\n"
> + "Dirty: %zu%%\n"
> + "Metadata: %zu%%\n"
> + "Average: %llu\n"
> + "Sectors per Q: %zu\n"
> + "Quantiles: [",
> + unused * 100 / (size_t) ca->sb.nbuckets,
> + available * 100 / (size_t) ca->sb.nbuckets,
> + dirty * 100 / (size_t) ca->sb.nbuckets,
> + meta * 100 / (size_t) ca->sb.nbuckets, sum,
> + n * ca->sb.bucket_size / (ARRAY_SIZE(q) + 1));
>=20
> for (i =3D 0; i < ARRAY_SIZE(q); i++)
> - ret +=3D scnprintf(buf + ret, PAGE_SIZE - ret,
> - "%u ", q[i]);
> + ret +=3D sysfs_emit_at(buf, ret, "%u ", q[i]);
> ret--;
>=20
> - ret +=3D scnprintf(buf + ret, PAGE_SIZE - ret, "]\n");
> + ret +=3D sysfs_emit_at(buf, ret, "]\n");
>=20
> return ret;
> }
> --=20
> 2.25.1

