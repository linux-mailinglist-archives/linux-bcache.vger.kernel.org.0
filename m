Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EFE6A521E
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Feb 2023 04:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjB1D6W (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Feb 2023 22:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjB1D54 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Feb 2023 22:57:56 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C29C30C9
        for <linux-bcache@vger.kernel.org>; Mon, 27 Feb 2023 19:57:55 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EC7FF1FDB4;
        Tue, 28 Feb 2023 03:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677556673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jwvTvHrYTz1cWEUzwg49AywHtuR0BWYGj24opOX2eOc=;
        b=iiJFG4tIVOauQsfMqmAAOvIl0U+CS6SHk0B7N//bP0mnY7Xtk1G2r7tRGBBmu4asRFz7TE
        CvxUEh7FTcRZFwIfLbvK2sW49sDoyfQMz60htPkM/icKz3T6iwR860B8z7r4OJZpkumMoZ
        eEWsA6IKIT00IC2ntv/IGdggpIM7CNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677556673;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jwvTvHrYTz1cWEUzwg49AywHtuR0BWYGj24opOX2eOc=;
        b=gUWQqN/bbEPVV47WbxMySzn1DNcErlGepSKhp3WmwwzUy3AZtuKI2eeg0Pv13Leyt7Igl5
        MjH4f9qN5uN+WVAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 39A2A13440;
        Tue, 28 Feb 2023 03:57:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iMmnAMF7/WNCOwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 28 Feb 2023 03:57:53 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: bugfix commits since 5.15 not marked with Cc: stable
From:   Coly Li <colyli@suse.de>
In-Reply-To: <577d7e59-33ff-77bb-5a31-a18d7ca9834a@ewheeler.net>
Date:   Tue, 28 Feb 2023 11:57:40 +0800
Cc:     linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5B7D9629-C505-4668-9989-0F998BD0A8CA@suse.de>
References: <577d7e59-33ff-77bb-5a31-a18d7ca9834a@ewheeler.net>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B42=E6=9C=8828=E6=97=A5 08:56=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hello Coly,

Hi Eric,

>=20
> I was looking through the commits between 5.15 and the latest kernel=20=

> release. It looks like the following commits may benefit from being =
marked=20
> for inclusion in the stable kernel trees.
>=20
> Is there any reason that any of these should be excluded from the =
stable=20
> release kernels?
>=20
> d55f7cb2e5c0 bcache: fix error info in register_bcache()
> 7b1002f7cfe5 bcache: fixup bcache_dev_sectors_dirty_add() =
multithreaded CPU false sharing
> a1a2d8f0162b bcache: avoid unnecessary soft lockup in kworker =
update_writeback_rate()
>=20
> # These two depend on each other, so apply both or neither:
> 0259d4498ba4 bcache: move calc_cached_dev_sectors to proper place on =
backing device detach
> aa97f6cdb7e9 bcache: fix NULL pointer reference in =
cached_dev_detach_finish
>=20
> If they look good to you then I will write an email to the stable =
list.

It was just because the original patches didn=E2=80=99t do that. And yes =
I do appreciate to send them to stable maintainer.

Thank you for the help :-)

Coly Li

