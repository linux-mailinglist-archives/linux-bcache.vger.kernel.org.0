Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35AC16CC153
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Mar 2023 15:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbjC1Npg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Mar 2023 09:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbjC1NpS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Mar 2023 09:45:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D9AD332
        for <linux-bcache@vger.kernel.org>; Tue, 28 Mar 2023 06:44:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 65C3221A28;
        Tue, 28 Mar 2023 13:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680011081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PP7O4Vn44vSK8EB0uEDIrBFLpi/SLZqtcs7HF1NcHos=;
        b=woFMbnHD17UU1wgNVw1OGNE4DBTfcqnULtE6eSnVJVlojzs1GykEitlvdIuXuh4yl1hOeP
        kWKrVNF1IbQdoPCrIjdhIsH0S+VslphJ6cWGwMb9765RxwDTF4iChXou+VTVoULQsoyFl3
        fkZ49bU/oXn4KZnG2XN+vOODq12L3kk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680011081;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PP7O4Vn44vSK8EB0uEDIrBFLpi/SLZqtcs7HF1NcHos=;
        b=Xkqfhz630Dm5U3i/I7YBPuv5oD/yzhWrqEJfeEGU4MSZ/c0R2PvUga1N4+U1jjEwNFO+6h
        f8XtxcR1T2QzCjCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2E51A1390B;
        Tue, 28 Mar 2023 13:44:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id x1VcOEfvImS2XgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 28 Mar 2023 13:44:39 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: [PATCH v2] bcache: fixup btree_cache_wait list damage
From:   Coly Li <colyli@suse.de>
X-Priority: 3
In-Reply-To: <AM2ALADkIzWluMu9cpBZ5qpK.3.1679990093116.Hmail.mingzhe.zou@easystack.cn>
Date:   Tue, 28 Mar 2023 21:44:27 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CEB9E2D2-B031-4DE0-BBBC-9441B90A9DFA@suse.de>
References: <71a7266f-8c55-33a0-3ef9-e48ba4ea76fa@ewheeler.net>
 <AM2ALADkIzWluMu9cpBZ5qpK.3.1679990093116.Hmail.mingzhe.zou@easystack.cn>
To:     =?utf-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B43=E6=9C=8828=E6=97=A5 15:54=EF=BC=8C=E9=82=B9=E6=98=8E=E5=93=
=B2 <mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: Eric Wheeler <bcache@lists.ewheeler.net>
> Date: 2023-03-28 05:28:05
> To:  Mingzhe Zou <mingzhe.zou@easystack.cn>
> Cc:  colyli@suse.de,linux-bcache@vger.kernel.org,zoumingzhe@qq.com
> Subject: Re: [PATCH v2] bcache: fixup btree_cache_wait list damage>On =
Mon, 27 Mar 2023, Mingzhe Zou wrote:
>>=20
>>> We get a kernel crash about "list_add corruption. next->prev should =
be
>>> prev (ffff9c801bc01210), but was ffff9c77b688237c. =
(next=3Dffffae586d8afe68)."
>>>=20
>>> crash> struct list_head 0xffff9c801bc01210
>>> struct list_head {
>>>  next =3D 0xffffae586d8afe68,
>>>  prev =3D 0xffffae586d8afe68
>>> }
>>> crash> struct list_head 0xffff9c77b688237c
>>> struct list_head {
>>>  next =3D 0x0,
>>>  prev =3D 0x0
>>> }
>>> crash> struct list_head 0xffffae586d8afe68
>>> struct list_head struct: invalid kernel virtual address: =
ffffae586d8afe68  type: "gdb_readmem_callback"
>>> Cannot access memory at address 0xffffae586d8afe68
>>>=20
>>> [230469.019492] Call Trace:
>>> [230469.032041]  prepare_to_wait+0x8a/0xb0
>>> [230469.044363]  ? bch_btree_keys_free+0x6c/0xc0 [bcache]
>>> [230469.056533]  mca_cannibalize_lock+0x72/0x90 [bcache]
>>> [230469.068788]  mca_alloc+0x2ae/0x450 [bcache]
>>> [230469.080790]  bch_btree_node_get+0x136/0x2d0 [bcache]
>>> [230469.092681]  bch_btree_check_thread+0x1e1/0x260 [bcache]
>>> [230469.104382]  ? finish_wait+0x80/0x80
>>> [230469.115884]  ? bch_btree_check_recurse+0x1a0/0x1a0 [bcache]
>>> [230469.127259]  kthread+0x112/0x130
>>> [230469.138448]  ? kthread_flush_work_fn+0x10/0x10
>>> [230469.149477]  ret_from_fork+0x35/0x40
>>>=20
>>> bch_btree_check_thread() and bch_dirty_init_thread() maybe call
>>> mca_cannibalize() to cannibalize other cached btree nodes. Only
>>> one thread can do it at a time, so the op of other threads will
>>> be added to the btree_cache_wait list.
>>>=20
>>> We must call finish_wait() to remove op from btree_cache_wait
>>> before free it's memory address. Otherwise, the list will be
>>> damaged. Also should call bch_cannibalize_unlock() to release
>>> the btree_cache_alloc_lock and wake_up other waiters.
>>>=20
>>> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>=20
>> Is there a reason not to cc stable?
>>=20
>> If its ok to cc stable then please add:
>> Cc: stable@vger.kernel.org=20
>>=20
>=20
> This is an old patch that was not processed last year,  and cannot be =
applied to the latest branch now.
>=20
> I have updated it to latest branch, cc stable seems unnecessary.

Hi Mingzhe,

Thank you for updating the patch against latest kernel. Let me firstly =
test and evaluation the change, then I will add these stuffs if =
necessary.

Coly Li=
