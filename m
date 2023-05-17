Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F53C706A77
	for <lists+linux-bcache@lfdr.de>; Wed, 17 May 2023 16:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjEQODe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 17 May 2023 10:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjEQODc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 May 2023 10:03:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E021121
        for <linux-bcache@vger.kernel.org>; Wed, 17 May 2023 07:03:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 339AD1F88D;
        Wed, 17 May 2023 14:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1684332209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sUKa3WS+pARI6hfMg0idH9lDl1nqPMtq4OKVSMXREU0=;
        b=1GYVsAD8dlUY3SClJBko5Ibd+sWY6LrrR0rc3fURQHpAsWeMoqzTSHRgH6hGkO6BnlKuUk
        da/VBybL+yxo/o6hZAW5Dq6uei5u5ZSz+fvXYtE6dcAsfcAGwgpZombcfr4bWtzTQA7QpI
        w9eF+HVuffMhs8dwIwxDTLqEbpz6w0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1684332209;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sUKa3WS+pARI6hfMg0idH9lDl1nqPMtq4OKVSMXREU0=;
        b=HjMss7Ye1JIHuoOKQFqFxcLVt1IMAs8GkCUjOxrlmTS22STe1i3dKnAUR1FQoXqdhUjhP7
        EN8YfcCvmFiFk/Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0D8AC13478;
        Wed, 17 May 2023 14:03:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BU3hAbHeZGQFWgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 17 May 2023 14:03:29 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v7 2/3] bcache: allocate stripe memory when
 partial_stripes_expensive is true
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230517052927.20478-1-rafael.lopez@canonical.com>
Date:   Wed, 17 May 2023 16:03:18 +0200
Cc:     mingzhe <mingzhe.zou@easystack.cn>,
        andrea.tomassetti-opensource@devo.com, bcache@lists.ewheeler.net,
        linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <58AF801B-9F98-4CF1-9DB3-7A631E381EAE@suse.de>
References: <20230307134852.8288-2-mingzhe.zou@easystack.cn>
 <20230517052927.20478-1-rafael.lopez@canonical.com>
To:     Rafael Lopez <raflopez1@gmail.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B45=E6=9C=8817=E6=97=A5 07:29=EF=BC=8CRafael Lopez =
<raflopez1@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Mingzhe, thanks for these patches. They resolve a specific bug we =
have open for a large NVME devices with non-zero optimal io size failing =
to register: =
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2016040.
> I have tested patches applied to mainline and some ubuntu kernels =
successfully, but only with regards to resolving the bug mentioned (have =
not tested online resizing).
>=20
> Are you planning further work or can this be merged soon?


Overall this specific patch is fine, now I am in travel and will be back =
next week. Then I will find a time to finish the code review for the =
rested patch in my testing queue.

It should be soon.

Thanks for the information.

Coly Li=
