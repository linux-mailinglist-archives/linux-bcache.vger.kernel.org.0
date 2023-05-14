Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5A4701CFC
	for <lists+linux-bcache@lfdr.de>; Sun, 14 May 2023 13:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjENLLi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 14 May 2023 07:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjENLLh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 May 2023 07:11:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26ADE4B;
        Sun, 14 May 2023 04:11:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CB3BE1F74D;
        Sun, 14 May 2023 11:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1684062693; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dM0REp/aFlq5rTBVepN8+Kk3O3vNuraV4e8TpGqBFL4=;
        b=gBPNLMuc3BF6yBxDPS8Wzgy8h+ANWDw6OeqEzaS+qRxIuohBemUxdcFO/+x2hIaMASlsuR
        wKkahhrtXaqpE7PQ492kC8NMZ3k7mG9zL+R1iO9KdcK1hZCHknZrjrE3jQjhThIatI1eY6
        7GUNras4PZK9b7ETA3emStacyYqOUPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1684062693;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dM0REp/aFlq5rTBVepN8+Kk3O3vNuraV4e8TpGqBFL4=;
        b=Fg1ST3WguJ4yGLEEswDgOIepQGzhgcsXipk+7Tnj7Zi/iQt1FxkTm3+M9/gGKZfWmUCtQZ
        VneuZNCaMIU1qxDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DF8E1138F5;
        Sun, 14 May 2023 11:11:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OFSlNeTBYGStdAAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 14 May 2023 11:11:32 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [RFC PATCH] block: add meaningful macro for flush op flags
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230512080757.387523-1-kch@nvidia.com>
Date:   Sun, 14 May 2023 13:11:22 +0200
Cc:     linux-block@vger.kernel.org,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, axboe@kernel.dk,
        kent.overstreet@gmail.com, agk@redhat.com, snitzer@kernel.org,
        dm-devel@redhat.com, song@kernel.org, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <08DD3B6F-0A2D-4725-847F-BACF40D07310@suse.de>
References: <20230512080757.387523-1-kch@nvidia.com>
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



> 2023=E5=B9=B45=E6=9C=8812=E6=97=A5 10:07=EF=BC=8CChaitanya Kulkarni =
<kch@nvidia.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Flush requests are implemented as REQ_OP_WRITE + REQ_OP_PREFLUSH
> combination and not REQ_OP_FLUSH + REQ_PREFLUSH combination.
>=20
> This unclear nature has lead to the confusion and bugs in the code for
> block drivers causing more work for testing, reviews and fixes :-
>=20
> 1. https://lore.kernel.org/all/ZFHgefWofVt24tRl@infradead.org/
> 2. https://marc.info/?l=3Dlinux-block&m=3D168386364026498&w=3D2
>=20
> Add a macro (name can me more meaningful) with a meaningful comment
> clearing the confusion and replace the REQ_OP_WRITE | REQ_PREFLUSH =
with
> the new macro name that also saves code repetation.
>=20
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>

> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -455,6 +455,13 @@ enum req_flag_bits {
> #define REQ_NOMERGE_FLAGS \
> (REQ_NOMERGE | REQ_PREFLUSH | REQ_FUA)
>=20
> +/*
> + * Flush requests are implemented as REQ_OP_WRITE + REQ_OP_PREFLUSH =
combination
> + * and not REQ_OP_FLUSH + REQ_PREFLUSH combination.
> + */
> +
> +#define REQ_FLUSH_OPF (REQ_OP_WRITE | REQ_PREFLUSH)
> +
> enum stat_group {
> STAT_READ,
> STAT_WRITE,
> --=20

Personally I like current explicit way, it is simpler than an extra =
macro. This is just my own points, FYI.

Thanks.

Coly Li

