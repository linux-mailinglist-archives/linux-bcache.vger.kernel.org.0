Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4D05843AF
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jul 2022 17:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiG1P4O (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jul 2022 11:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiG1Pzz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jul 2022 11:55:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2E052DC0;
        Thu, 28 Jul 2022 08:55:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E3C061FA2C;
        Thu, 28 Jul 2022 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659023752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/GlzqPS99WoZkWdHGQ39h0relM7Tl5PCJXiMbv3EdzQ=;
        b=srh5O8FGHyWFm4PTPLPKFNzTyw5gAj7qcOj47Y7ez6k/PutjUcoGsD5UrzCy8s/rEFHKFk
        3WXu71LDMXJ9NDiH1cAKR277+bSDA7ywqL29Rixj8nI76ySG6DBzJlZUBImRQAAEi08elN
        mPHfFtRnXg5GHMFJxQHoEBgG8v8T1nE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659023752;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/GlzqPS99WoZkWdHGQ39h0relM7Tl5PCJXiMbv3EdzQ=;
        b=0iKRrsyUYvGatz//vcW+c19uQqD+cB1fbXy5xThErFVBAq8tB1M220C0TDS+CboqLi19hU
        ZBfsT0rOsrsZElBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DE0F413427;
        Thu, 28 Jul 2022 15:55:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hqNvJ4ex4mK+BgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 28 Jul 2022 15:55:51 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 0/1] bcache patche for Linux v5.20
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220719042724.8498-1-colyli@suse.de>
Date:   Thu, 28 Jul 2022 23:55:48 +0800
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <54A9F5B1-305E-4861-AB76-3BFB2651ED24@suse.de>
References: <20220719042724.8498-1-colyli@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=8819=E6=97=A5 12:27=EF=BC=8CColy Li =
<colyli@suse.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Jens,
>=20
> There is 1 patch from bcache submission, which removes 'EXPERIMENTAL'
> from the bcache Kconfig item, now 'Asynchronous device registration'
> option is not experimental anymore.
>=20
> Please take it for v5.20. Thank you in advance to taking care of this.
>=20
> Coly Li
> ---
>=20
> Coly Li (1):
>  bcache: remove EXPERIMENTAL for Kconfig option 'Asynchronous device
>    registration'
>=20
> drivers/md/bcache/Kconfig | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Hi Jens,

Just kindly remind for this single patch for 5.20. Thanks.

Coly Li

