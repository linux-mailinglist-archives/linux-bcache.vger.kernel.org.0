Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5AE69690B
	for <lists+linux-bcache@lfdr.de>; Tue, 14 Feb 2023 17:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBNQQU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 Feb 2023 11:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBNQQT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Feb 2023 11:16:19 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F42DEB;
        Tue, 14 Feb 2023 08:16:18 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B9E521F37F;
        Tue, 14 Feb 2023 16:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676391376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z72CGZa2ynMtipnZj0aFsVnqwMWT2V0BIvV+1xAIoOE=;
        b=igsU6vNgMWC3ZQKO2kkbpJEqvMLAdAa+yeLT9g0MGf2VaS7vO2zIT1GIBHtEBUZQu4ec0k
        vAtO+8kR6WxqVmLxyerMFqHrR8YfmRGfMFI6E3loxHAWEBe0bgkjpeUiDX3pf+9BfIpOFw
        4A3xqzhhwI3XCOEp+bu7C4S96wtOs5g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676391376;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z72CGZa2ynMtipnZj0aFsVnqwMWT2V0BIvV+1xAIoOE=;
        b=nkp9upIw1J/Q6COMWfGTxbh46bD2P/5m48CMIwIk6E0jUqJhmLFt24iMM2He8d8fwLyC1f
        zOaQ+HnTJ/rgzdDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B68F913A21;
        Tue, 14 Feb 2023 16:16:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id P4LDIM+z62NtCwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 14 Feb 2023 16:16:15 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] bcache: make kobj_type structures constant
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230214152119.epkfhkojqjvokqmv@t-8ch.de>
Date:   Wed, 15 Feb 2023 00:16:03 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9DE71214-283C-4410-B5A4-22DFDA7021F4@suse.de>
References: <20230214-kobj_type-bcache-v1-1-cf00ead7bee7@weissschuh.net>
 <125CA8D6-D3B7-42FB-83BE-DCA688F2ACAF@suse.de>
 <20230214152119.epkfhkojqjvokqmv@t-8ch.de>
To:     =?utf-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B42=E6=9C=8814=E6=97=A5 23:21=EF=BC=8CThomas Wei=C3=9Fschuh =
<linux@weissschuh.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, Feb 14, 2023 at 05:51:09PM +0800, Coly Li wrote:
>>=20
>>=20
>>> 2023=E5=B9=B42=E6=9C=8814=E6=97=A5 11:13=EF=BC=8CThomas Wei=C3=9Fschuh=
 <linux@weissschuh.net> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
>>> the driver core allows the usage of const struct kobj_type.
>>>=20
>>> Take advantage of this to constify the structure definitions to =
prevent
>>> modification at runtime.
>>>=20
>>=20
>> How the const structure definition can prevent modification at run =
time?
>=20
> It will be put into .rodata instead of .data by the compiler.
> The .rodata section is mapped as read-only via the pagetable.
>=20
> See Documentation/security/self-protection.rst
> "Function pointers and sensitive variables must not be writable".

I see. Thanks for the information.

This patch will be added into my testing queue, and submitted later.

Coly Li

