Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371616B036D
	for <lists+linux-bcache@lfdr.de>; Wed,  8 Mar 2023 10:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjCHJxf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 8 Mar 2023 04:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCHJxS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Mar 2023 04:53:18 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E09C392A2
        for <linux-bcache@vger.kernel.org>; Wed,  8 Mar 2023 01:53:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EA90921A0C;
        Wed,  8 Mar 2023 09:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678269190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2bYMXtROWFvdarBtgZQ/wO1Ue3CaZdPRuqZrjApfoCQ=;
        b=crDS0gBt3Mw2XM42UlKP8hUcrTpp6xkwC0mvkcT9MOV7NgPlfDQcx4+XIkcqDDP1Tj7Exl
        VTnB/ZxUfJEqEV4aOVYpZUTQZ0eNxYRaf5r+fw9sWSn1Im96oabKIloK0ldJP1EXDDetEh
        GQXQPWz/Na3RMw1cLztO/p9yP4/MBI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678269190;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2bYMXtROWFvdarBtgZQ/wO1Ue3CaZdPRuqZrjApfoCQ=;
        b=QfF2sZLdCr1qGzy4oYck0slT/UOTTWjJNQ84nZbM3pNhbxX4CaerUGNNZ87/l7ZQZ+TUhr
        8n7k0JRAguUigvAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EA5351391B;
        Wed,  8 Mar 2023 09:53:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 52hFLQVbCGT2SAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 08 Mar 2023 09:53:09 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: [PATCH] bcache: set io_disable to true when stop bcache device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230308092036.11024-1-mingzhe.zou@easystack.cn>
Date:   Wed, 8 Mar 2023 17:52:57 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <BB908A89-DE89-4C38-9B43-9A82520BE03D@suse.de>
References: <20230308092036.11024-1-mingzhe.zou@easystack.cn>
To:     mingzhe <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B43=E6=9C=888=E6=97=A5 17:20=EF=BC=8Cmingzhe =
<mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Stop is an operation that cannot be aborted. If there are still
> IO requests being processed, we can never stop the device.
> So, all new IO requests should fail when we set io_disable to true.
> However, sysfs has been unlinked at this time, user cannot modify
> io_disable via sysfs.
>=20
> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>

NACK. I tried this years ago, it might introduce potential risk for meta =
data inconsistency.


Coly Li


> ---
> drivers/md/bcache/request.c | 16 ++++++++++++++++
> drivers/md/bcache/super.c   |  9 +++++++++
> 2 files changed, 25 insertions(+)
>=20
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 67a2e29e0b40..9b85aad20022 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -758,6 +758,15 @@ static void cached_dev_bio_complete(struct =
closure *cl)
> search_free(cl);
> }
>=20
> +static void cached_dev_bio_fail(struct closure *cl)
> +{
> + struct search *s =3D container_of(cl, struct search, cl);
> + struct cached_dev *dc =3D container_of(s->d, struct cached_dev, =
disk);
> +
> + s->iop.status =3D BLK_STS_IOERR;
> + cached_dev_bio_complete(cl);
> +}
> +
> /* Process reads */
>=20
> static void cached_dev_read_error_done(struct closure *cl)
> @@ -971,6 +980,9 @@ static void cached_dev_write(struct cached_dev =
*dc, struct search *s)
> struct bkey start =3D KEY(dc->disk.id, bio->bi_iter.bi_sector, 0);
> struct bkey end =3D KEY(dc->disk.id, bio_end_sector(bio), 0);
>=20
> + if (unlikely((dc->io_disable)))
> + goto fail_bio;
> +
> bch_keybuf_check_overlapping(&s->iop.c->moving_gc_keys, &start, &end);
>=20
> down_read_non_owner(&dc->writeback_lock);
> @@ -1046,6 +1058,10 @@ static void cached_dev_write(struct cached_dev =
*dc, struct search *s)
> insert_data:
> closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
> continue_at(cl, cached_dev_write_complete, NULL);
> + return;
> +
> +fail_bio:
> + continue_at(cl, cached_dev_bio_fail, NULL);
> }
>=20
> static void cached_dev_nodata(struct closure *cl)
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..a2a82942f85b 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1389,6 +1389,15 @@ static void cached_dev_flush(struct closure =
*cl)
> bch_cache_accounting_destroy(&dc->accounting);
> kobject_del(&d->kobj);
>=20
> + /*
> + * Stop is an operation that cannot be aborted. If there are still
> + * IO requests being processed, we can never stop the device.
> + * So, all new IO requests should fail when we set io_disable to =
true.
> + * However, sysfs has been unlinked at this time, user cannot modify
> + * io_disable via sysfs.
> + */
> + dc->io_disable =3D true;
> +
> continue_at(cl, cached_dev_free, system_wq);
> }
>=20
> --=20
> 2.17.1.windows.2
>=20

