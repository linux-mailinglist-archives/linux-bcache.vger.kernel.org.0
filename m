Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB536ECA0D
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Apr 2023 12:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjDXKUL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 06:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjDXKUK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 06:20:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB535B7;
        Mon, 24 Apr 2023 03:20:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 79A7F1FD7D;
        Mon, 24 Apr 2023 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1682331608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8HvVdeDiIgiuBeUDj17fn5dqrFt5dqGREda0ixO83bE=;
        b=Yy0WJzsZgknyxIkT8ZupXHV2gU8R7J656Huu1VcKZASk4jNNz3aAg7P+5vyYwq3T3kUxNu
        26W06XckOTCE9/mTcWWlPCeF9z1YOo9dB4dyn4LPJQin7G3/7fQs4qLl9rBLah3RoWxAOL
        2SEKUgl8G4pbePizxsUWt4yKYtCjcII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1682331608;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8HvVdeDiIgiuBeUDj17fn5dqrFt5dqGREda0ixO83bE=;
        b=XrWNSOJ06s3ar4CN/oq0TfkqoQSJ0De+M0u+cLclK1VYnGBkIMzBDKwjmZ4MumXxxx9O9u
        JIurkNzeN2kqgZAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 40B081390E;
        Mon, 24 Apr 2023 10:20:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DckIBNVXRmQ7KwAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 24 Apr 2023 10:20:05 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 5/5] bcache: don't clear the flag that is not  =?ISO-8859-1?Q?=20set=1B?=
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230424073023.38935-6-kch@nvidia.com>
Date:   Mon, 24 Apr 2023 18:19:52 +0800
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        axboe@kernel.dk, josef@toxicpanda.com, minchan@kernel.org,
        senozhatsky@chromium.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        dlemoal@kernel.org, johannes.thumshirn@wdc.com, bvanassche@acm.org,
        vincent.fu@samsung.com, akinobu.mita@gmail.com,
        shinichiro.kawasaki@wdc.com, nbd@other.debian.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F1D47747-F82A-4395-9B11-8A717BB2D96A@suse.de>
References: <20230424073023.38935-1-kch@nvidia.com>
 <20230424073023.38935-6-kch@nvidia.com>
To:     Chaitanya Kulkarni <kch@nvidia.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Apr 24, 2023 at 12:30:23AM -0700, Chaitanya Kulkarni wrote:
> QUEUE_FLAG_ADD_RANDOM is not set in bcache_device_init() before we =
clear
> it. There is no point in clearing the flag that is not set.
> Remove blk_queue_flag_clear() for QUEUE_FLAG_ADD_RANDOM.
>=20
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
> drivers/md/bcache/super.c | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..7e9d19fd21dd 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -971,7 +971,6 @@ static int bcache_device_init(struct bcache_device =
*d, unsigned int block_size,
> 	}
>=20
> 	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
> -	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
>=20
> 	blk_queue_write_cache(q, true, true);
>=20
> --=20
> 2.40.0
>=20

--=20
Coly Li
