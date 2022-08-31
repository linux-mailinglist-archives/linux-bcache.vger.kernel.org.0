Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2D45A80F6
	for <lists+linux-bcache@lfdr.de>; Wed, 31 Aug 2022 17:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiHaPMP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 31 Aug 2022 11:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiHaPMO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Aug 2022 11:12:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD98D3ECF;
        Wed, 31 Aug 2022 08:12:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7C08C2211C;
        Wed, 31 Aug 2022 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661958732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AhKMQsk03osPCRJxhlweox2ETeW0NDfgWBNTgv9z8Ns=;
        b=0VmAqpqi4QaPLV0aduWu0xTsv4FFSSLElO6UAsg9RlHo2lIVv69jUmvIt7gHtFAcFaUihe
        WQk/YIlxr2yQJ/Sjf8en3XP4I4ujB+mAGTGyg9/7TMH64aGoS0rR5EWpnVCYyi+KXY8V0T
        V/QnZ0e8N8xCPTxqEXHtcC0PBdFg7pw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661958732;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AhKMQsk03osPCRJxhlweox2ETeW0NDfgWBNTgv9z8Ns=;
        b=lP3Pn2xScytKYQl+I9x2+Bvg2iU1AnFwwiEZyrNhkrMNegQQ3G6BxCyZFFrtPJl4XaWFZp
        6tPFvF0f7jPWoQBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 72E1613A7C;
        Wed, 31 Aug 2022 15:12:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jAgtC0p6D2OjZgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 31 Aug 2022 15:12:10 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH] bcache:: fix repeated words in comments
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220830153026.16948-1-yuanjilin@cdjrlc.com>
Date:   Wed, 31 Aug 2022 23:12:06 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A39949D5-FEED-4A59-8BE5-9D90BE63521D@suse.de>
References: <20220830153026.16948-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
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



> 2022=E5=B9=B48=E6=9C=8830=E6=97=A5 23:30=EF=BC=8CJilin Yuan =
<yuanjilin@cdjrlc.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Delete the redundant word 'we'.
>=20
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Added to my for-next queue. Thanks.

Coly Li


> ---
> drivers/md/bcache/bcache.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 2acda9cea0f9..aebb7ef10e63 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -107,7 +107,7 @@
>  *
>  * BTREE NODES:
>  *
> - * Our unit of allocation is a bucket, and we we can't arbitrarily =
allocate and
> + * Our unit of allocation is a bucket, and we can't arbitrarily =
allocate and
>  * free smaller than a bucket - so, that's how big our btree nodes =
are.
>  *
>  * (If buckets are really big we'll only use part of the bucket for a =
btree node
> --=20
> 2.36.1
>=20

