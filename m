Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449605BBD8A
	for <lists+linux-bcache@lfdr.de>; Sun, 18 Sep 2022 13:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiIRLLH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 18 Sep 2022 07:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIRLLG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 18 Sep 2022 07:11:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5365327B35;
        Sun, 18 Sep 2022 04:11:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E7E2C1FD69;
        Sun, 18 Sep 2022 11:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663499460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WeoB6ZJ3kMZVb3Q8syRSrmyuPST462pBWmv5sZ1whj8=;
        b=2QXZJhTdwlieE/bMpwOIv9NXJ3NZKBLlyECk9A27OGI1bsLerTWQ3R2k3/wJJLJp7NbHiJ
        SRjJ9/l+1xOdcKnbLzeNzT/iD/HanXxB2Bt91if3Oy6U9Ro6d0XUcicx/I1ZAEMRodHXuX
        2o74IyPXpsP8+4YobU+nnRCWWQWCLzc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663499460;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WeoB6ZJ3kMZVb3Q8syRSrmyuPST462pBWmv5sZ1whj8=;
        b=yoqxah4gjJDBTJ1QwMkQIuz+Jlwe4ro55Bz+koXglgJd8hw4jU5d7SA7uIPB7h4M/x0R0u
        R9ege05BAoXLTGAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C874F13A6B;
        Sun, 18 Sep 2022 11:10:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vRBPI8P8JmO8YQAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 18 Sep 2022 11:10:59 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH] bcache: fix repeated words in comments
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220918094549.17325-1-yuanjilin@cdjrlc.com>
Date:   Sun, 18 Sep 2022 19:10:56 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8455FB06-B6C7-4CD7-A56A-39A3301534EC@suse.de>
References: <20220918094549.17325-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=8818=E6=97=A5 17:45=EF=BC=8CJilin Yuan =
<yuanjilin@cdjrlc.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Delete the redundant word 'by'.
>=20
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Added into my for-next queue.

Thanks.

Coly Li


> ---
> drivers/md/bcache/bset.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 94d38e8a59b3..6a24a327dce2 100644
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
> +		 * creaated by mempool_init_page_pool(), which allocates
> 		 * pages by alloc_pages() indeed.
> 		 */
>=20
> --=20
> 2.36.1
>=20

