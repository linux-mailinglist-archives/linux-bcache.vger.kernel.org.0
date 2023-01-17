Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826D066E318
	for <lists+linux-bcache@lfdr.de>; Tue, 17 Jan 2023 17:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjAQQIn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 17 Jan 2023 11:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjAQQId (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 17 Jan 2023 11:08:33 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6893F86A1
        for <linux-bcache@vger.kernel.org>; Tue, 17 Jan 2023 08:08:30 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CC9D2388DB;
        Tue, 17 Jan 2023 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673971708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0OenXvEpQRZ/Uggat3U1ANbaDWigrZqQLXqO0V+3UZo=;
        b=F2I0Rinrbk++TGmqhh0WuZVHZY1K8QyvNGLDQAXkOYeCsE5uYgJA8LLGoiYZUplHGIV4Am
        y8C0MNtbtdfTHk/A1uQx8rB56zMO2FRMoDxuiwn/tgX7Su/k0Pd26H/zH8hnFrntc+m/OE
        eDniMRzqfJ9imrPKhJ9azBNTDtV1y7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673971708;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0OenXvEpQRZ/Uggat3U1ANbaDWigrZqQLXqO0V+3UZo=;
        b=mxJMp3tHhKgx/yROfab+3Mt7nzmGy53qOztxNZtVw1oX6bgs25+P76QTiDmp09p+Mghy+M
        qk5pmmtYBmwXFkBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F413013357;
        Tue, 17 Jan 2023 16:08:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lcWIL/vHxmNiYwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 17 Jan 2023 16:08:27 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: Error messages with kernel 6.1.[56]
From:   Coly Li <colyli@suse.de>
In-Reply-To: <c63dc204-13c1-6e3a-3c93-5c5f3dd9271f@orange.fr>
Date:   Wed, 18 Jan 2023 00:08:15 +0800
Cc:     linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <293126F4-B40E-49C9-91B1-4A2D1BEBF10E@suse.de>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
 <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
 <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
 <c63dc204-13c1-6e3a-3c93-5c5f3dd9271f@orange.fr>
To:     Pierre Juhen <pierre.juhen@orange.fr>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B41=E6=9C=8817=E6=97=A5 21:08=EF=BC=8CPierre Juhen =
<pierre.juhen@orange.fr> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi bcache-list,
>=20
> I wish you all the best for 2023.
>=20
> I use fedora (36 for the moment).
>=20
> Since the migration to 6.1 kernel, I get the following messages at =
boot time :
>=20

This is reported, and fixed by Kees Cook with following original =
patches,

https://lore.kernel.org/lkml/20230106045327.never.413-kees@kernel.org/
https://lore.kernel.org/lkml/20230106053153.never.999-kees@kernel.org/
https://lore.kernel.org/lkml/20230106060229.never.047-kees@kernel.org/
https://lore.kernel.org/lkml/20230106061659.never.817-kees@kernel.org/

The patches are not upstream yet, maybe soon.

Just for your information.

Coly Li


>   janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
>   field-spanning write (size 264) of single field "&i->j" at
>   drivers/md/bcache/journal.c:152 (size 240)
>   janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 650 at
>   drivers/md/bcache/journal.c:152 journal_read_bucket+0x3d0/0x480 =
[bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: Modules linked in:
>   bcachefjes(-) raid0 crct10dif_pclmul crc32_pclmul crc32c_intel
>   polyval_clmulni polyval_generic nvme ghash_clmulni_intel
>   sha512_ssse3 nvme_core sp5100_>
>   janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 650 Comm:
>   bcache-register Not tainted 6.1.6-100.fc36.x86_64 #1
>   janv. 17 07:20:50 pierre.juhen kernel: RIP:
>   0010:journal_read_bucket+0x3d0/0x480 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ? bch_btree_exit+0x20/0x20
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  bch_journal_read+0x69/0x2f0
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     register_bcache+0x12c9/0x1bf0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
>   field-spanning write (size 24) of single field "&b->key" at
>   drivers/md/bcache/btree.c:939 (size 16)
>   janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 650 at
>   drivers/md/bcache/btree.c:939 mca_alloc+0x421/0x4c0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: raid1
>   fjes(-) bcacheraid0 crct10dif_pclmul crc32_pclmul crc32c_intel
>   polyval_clmulni polyval_generic nvme ghash_clmulni_intel
>   sha512_ssse3 nvme_core s>
>   janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 650 Comm:
>   bcache-register Tainted: G        W          6.1.6-100.fc36.x86_64 =
#1
>   janv. 17 07:20:50 pierre.juhen kernel: RIP:
>   0010:mca_alloc+0x421/0x4c0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_btree_node_get.part.0+0x109/0x2b0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     register_bcache+0x16ed/0x1bf0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
>   field-spanning write (size 24) of single field "&c->uuid_bucket" at
>   drivers/md/bcache/super.c:465 (size 16)
>   janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 650 at
>   drivers/md/bcache/super.c:465 register_bcache+0x1b39/0x1bf0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: raid1
>   fjes(-) bcacheraid0 crct10dif_pclmul crc32_pclmul crc32c_intel
>   polyval_clmulni polyval_generic nvme ghash_clmulni_intel
>   sha512_ssse3 nvme_core s>
>   janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 650 Comm:
>   bcache-register Tainted: G        W          6.1.6-100.fc36.x86_64 =
#1
>   janv. 17 07:20:50 pierre.juhen kernel: RIP:
>   0010:register_bcache+0x1b39/0x1bf0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
>   field-spanning write (size 24) of single field "&temp.key" at
>   drivers/md/bcache/extents.c:428 (size 16)
>   janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 9 PID: 650 at
>   drivers/md/bcache/extents.c:428 bch_extent_insert_fixup+0x54e/0x560
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: fjes(-)
>   hid_logitech_hidpp(+) raid1 bcacheraid0 crct10dif_pclmul
>   crc32_pclmul crc32c_intel polyval_clmulni polyval_generic nvme
>   ghash_clmulni_intel sh>
>   janv. 17 07:20:50 pierre.juhen kernel: CPU: 9 PID: 650 Comm:
>   bcache-register Tainted: G        W          6.1.6-100.fc36.x86_64 =
#1
>   janv. 17 07:20:50 pierre.juhen kernel: RIP:
>   0010:bch_extent_insert_fixup+0x54e/0x560 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_btree_insert_key+0xc5/0x260 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  btree_insert_key+0x4c/0xd0
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_btree_insert_keys+0x3e/0x290 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   __bch_btree_ptr_invalid+0x5b/0xc0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_btree_insert_node+0x143/0x3a0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   bch_btree_insert_check_key+0x150/0x150 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  btree_insert_fn+0x20/0x40
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_btree_map_nodes_recurse+0xf0/0x170 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     __bch_btree_map_nodes+0x1dd/0x1f0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   bch_btree_insert_check_key+0x150/0x150 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  bch_btree_insert+0xcd/0x110
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_journal_replay+0xe6/0x1f0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     register_bcache+0x1918/0x1bf0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
>   field-spanning write (size 24) of single field "&k.key" at
>   drivers/md/bcache/btree.c:371 (size 16)
>   janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 9 PID: 650 at
>   drivers/md/bcache/btree.c:371 __bch_btree_node_write+0x59d/0x5d0
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: fjes(-)
>   hid_logitech_hidpp(+) raid1 bcacheraid0 crct10dif_pclmul
>   crc32_pclmul crc32c_intel polyval_clmulni polyval_generic nvme
>   ghash_clmulni_intel sh>
>   janv. 17 07:20:50 pierre.juhen kernel: CPU: 9 PID: 650 Comm:
>   bcache-register Tainted: G        W          6.1.6-100.fc36.x86_64 =
#1
>   janv. 17 07:20:50 pierre.juhen kernel: RIP:
>   0010:__bch_btree_node_write+0x59d/0x5d0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   bch_btree_insert_keys+0x48/0x290 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_btree_insert_node+0x32b/0x3a0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   bch_btree_insert_check_key+0x150/0x150 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  btree_insert_fn+0x20/0x40
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_btree_map_nodes_recurse+0xf0/0x170 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     __bch_btree_map_nodes+0x1dd/0x1f0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   bch_btree_insert_check_key+0x150/0x150 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  bch_btree_insert+0xcd/0x110
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_journal_replay+0xe6/0x1f0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     register_bcache+0x1918/0x1bf0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: bcache: bch_journal_replay()
>   journal replay done, 3591 keys in 304 entries, seq 6243591
>   janv. 17 07:20:50 pierre.juhen kernel: bcache: register_cache()
>   registered cache device nvme0n1p3
>   janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
>   field-spanning write (size 24) of single field
>   "&w->data->btree_root" at drivers/md/bcache/journal.c:778 (size 16)
>   janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 700 at
>   drivers/md/bcache/journal.c:778 journal_write_unlocked+0x4f6/0x560
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: fjes(-)
>   hid_logitech_hidpp(+) raid1 bcacheraid0 crct10dif_pclmul
>   crc32_pclmul crc32c_intel polyval_clmulni polyval_generic nvme
>   ghash_clmulni_intel sh>
>   janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 700 Comm:
>   bcache_allocato Tainted: G        W          6.1.6-100.fc36.x86_64 =
#1
>   janv. 17 07:20:50 pierre.juhen kernel: RIP:
>   0010:journal_write_unlocked+0x4f6/0x560 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  bch_journal+0x302/0x370 =
[bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  bch_journal_meta+0x38/0x50
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  bch_prio_write+0x3af/0x4c0
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_allocator_thread+0x199/0xcd0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   bch_invalidate_one_bucket+0x80/0x80 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
>   field-spanning write (size 24) of single field
>   "&w->data->uuid_bucket" at drivers/md/bcache/journal.c:779 (size 16)
>   janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 700 at
>   drivers/md/bcache/journal.c:779 journal_write_unlocked+0x545/0x560
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: fjes(-)
>   hid_logitech_hidpp(+) raid1 bcacheraid0 crct10dif_pclmul
>   crc32_pclmul crc32c_intel polyval_clmulni polyval_generic nvme
>   ghash_clmulni_intel sh>
>   janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 700 Comm:
>   bcache_allocato Tainted: G        W          6.1.6-100.fc36.x86_64 =
#1
>   janv. 17 07:20:50 pierre.juhen kernel: RIP:
>   0010:journal_write_unlocked+0x545/0x560 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  bch_journal+0x302/0x370 =
[bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  bch_journal_meta+0x38/0x50
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  bch_prio_write+0x3af/0x4c0
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_allocator_thread+0x199/0xcd0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   bch_invalidate_one_bucket+0x80/0x80 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: bcache: register_bdev()
>   registered backing device md126
>   janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
>   field-spanning write (size 24) of single field "&c->uuid_bucket" at
>   drivers/md/bcache/super.c:520 (size 16)
>   janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 11 PID: 703 at
>   drivers/md/bcache/super.c:520 __uuid_write+0x1ad/0x1c0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: Modules linked in:
>   hid_logitech_hidpp raid1 bcacheraid0 crct10dif_pclmul crc32_pclmul
>   crc32c_intel polyval_clmulni polyval_generic nvme
>   ghash_clmulni_intel sha512_ssse3 >
>   janv. 17 07:20:50 pierre.juhen kernel: CPU: 11 PID: 703 Comm:
>   bcache-register Tainted: G        W          6.1.6-100.fc36.x86_64 =
#1
>   janv. 17 07:20:50 pierre.juhen kernel: RIP:
>   0010:__uuid_write+0x1ad/0x1c0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ? bch_btree_exit+0x20/0x20
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_cached_dev_attach+0x442/0x560 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     register_bcache.cold+0x26c/0x3e4 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: bcache:
>   bch_cached_dev_attach() Caching md126 as bcache0 on set
>   4e3b28d9-0795-4f91-af97-f8429b325481
>   janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
>   field-spanning write (size 24) of single field "&w->key" at
>   drivers/md/bcache/btree.c:2618 (size 16)
>   janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 706 at
>   drivers/md/bcache/btree.c:2618 refill_keybuf_fn+0x220/0x230 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel: Modules linked in:
>   hid_logitech_hidpp raid1 bcacheraid0 crct10dif_pclmul crc32_pclmul
>   crc32c_intel polyval_clmulni polyval_generic nvme
>   ghash_clmulni_intel sha512_ssse3 >
>   janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 706 Comm:
>   bcache_writebac Tainted: G        W          6.1.6-100.fc36.x86_64 =
#1
>   janv. 17 07:20:50 pierre.juhen kernel: RIP:
>   0010:refill_keybuf_fn+0x220/0x230 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_btree_map_keys_recurse+0x60/0x180 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   bch_btree_gc_finish+0x390/0x390 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_btree_map_keys_recurse+0xe6/0x180 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   bch_btree_gc_finish+0x390/0x390 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   idle_counter_exceeded+0x50/0x50 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_btree_map_keys+0x1dd/0x1f0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   bch_btree_gc_finish+0x390/0x390 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   idle_counter_exceeded+0x50/0x50 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  bch_refill_keybuf+0xba/0x1e0
>   [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ?
>   idle_counter_exceeded+0x50/0x50 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:
>     bch_writeback_thread+0x31a/0x5b0 [bcache]
>   janv. 17 07:20:50 pierre.juhen kernel:  ? read_dirty+0x450/0x450
>   [bcache]
>   janv. 17 07:20:52 pierre.juhen dracut-initqueue[783]: Scanning
>   devices bcache0 md127 sdc1  for LVM volume groups
>   janv. 17 07:20:52 pierre.juhen kernel: memcpy: detected
>   field-spanning write (size 24) of single field "&ret->key" at
>   drivers/md/bcache/alloc.c:586 (size 16)
>   janv. 17 07:20:52 pierre.juhen kernel: WARNING: CPU: 5 PID: 870 at
>   drivers/md/bcache/alloc.c:586 bch_alloc_sectors+0x4ad/0x500 [bcache]
>   janv. 17 07:20:52 pierre.juhen kernel: Modules linked in:
>   nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE)
>   hid_logitech_hidpp raid1 bcacheraid0 crct10dif_pclmul crc32_pclmul
>   crc32c_intel polyva>
>   janv. 17 07:20:52 pierre.juhen kernel: RIP:
>   0010:bch_alloc_sectors+0x4ad/0x500 [bcache]
>   janv. 17 07:20:52 pierre.juhen kernel:
>     bch_data_insert_start+0x150/0x4c0 [bcache]
>   janv. 17 07:20:52 pierre.juhen kernel:
>     cached_dev_submit_bio+0xb1d/0xd70 [bcache]
>=20
> Thank you,
>=20
> Regards,
>=20
> Pierre
>=20

