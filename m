Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6917D5A80B0
	for <lists+linux-bcache@lfdr.de>; Wed, 31 Aug 2022 16:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiHaO4Z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 31 Aug 2022 10:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiHaO4V (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Aug 2022 10:56:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17DACC32D;
        Wed, 31 Aug 2022 07:55:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9D33822100;
        Wed, 31 Aug 2022 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661957745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s6AjlAeWtcKwmBZkBON6SrodR56ivUjL6OJtH2nJbWA=;
        b=JIUylpNW05JOiyVBi265AW5nHZI3DvkLsHtXw900NpgNlNlcUTiMa/ivHlSsAeATDm/KIJ
        KJQGrrtZd9LEp2OkZ9lGmRir6YcExN10I9llYBHfnhSCsIHh0jq+OcCwGdGibV3XX3Mc6w
        nFigLkrUB0iseJ3lSMRrlXRD19zHBXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661957745;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s6AjlAeWtcKwmBZkBON6SrodR56ivUjL6OJtH2nJbWA=;
        b=i0V6x6gQGmnH4AZq4BwH7anJ6DOPGAbGNjpb4PbQ7W0aKjfflDqq6tdVc31SM1e/wph8/f
        ADYRcGEViz62u9Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A42D313A7C;
        Wed, 31 Aug 2022 14:55:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id q/YgHnB2D2PCXwAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 31 Aug 2022 14:55:44 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH] bcache: bset: Fix comment typos
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220826100052.22945-24-jmaselbas@kalray.eu>
Date:   Wed, 31 Aug 2022 22:55:42 +0800
Cc:     linux-kernel@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FD6DF477-C5B5-482F-B237-0FC1B7CED915@suse.de>
References: <20220826100052.22945-24-jmaselbas@kalray.eu>
To:     Jules Maselbas <jmaselbas@kalray.eu>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8826=E6=97=A5 18:00=EF=BC=8CJules Maselbas =
<jmaselbas@kalray.eu> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Remove the redundant word `by`, correct the typo `creaated`.
>=20
> CC: Kent Overstreet <kent.overstreet@gmail.com>
> CC: linux-bcache@vger.kernel.org
> Signed-off-by: Jules Maselbas <jmaselbas@kalray.eu>

Added to my for-next queue. Thanks.

Coly Li

> ---
> drivers/md/bcache/bset.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 94d38e8a59b3..2bba4d6aaaa2 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -1264,7 +1264,7 @@ static void __btree_sort(struct btree_keys *b, =
struct btree_iter *iter,
> 		 *
> 		 * Don't worry event 'out' is allocated from mempool, it =
can
> 		 * still be swapped here. Because state->pool is a page =
mempool
> -		 * creaated by by mempool_init_page_pool(), which =
allocates
> +		 * created by mempool_init_page_pool(), which allocates
> 		 * pages by alloc_pages() indeed.
> 		 */
>=20
> --=20
> 2.17.1
>=20

