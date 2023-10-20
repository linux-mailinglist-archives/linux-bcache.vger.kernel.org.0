Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10257D0B8C
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Oct 2023 11:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376632AbjJTJXp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 20 Oct 2023 05:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376622AbjJTJXn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 20 Oct 2023 05:23:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637FAD51
        for <linux-bcache@vger.kernel.org>; Fri, 20 Oct 2023 02:23:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B1AB9219CD;
        Fri, 20 Oct 2023 09:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697793819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FvDYn/6gTTylR+EYfZbky6SjxPhU8dj62/egKhxtriQ=;
        b=I+G2zX/skOhnTdczt447lZJ8AViXuyzKZzEkYmssdS3zHoH2P+Jhm2rYtpYKP2/tx+QfsW
        tnHee4g21WYdE9sQrq6rEalpsZkSY7m7Zjk5xcsOWBNIcg8uJSwmFzgKkLWU/RXoj2E/b9
        EL30YX7vX0Hdwhk6ew2hk8Sds0+uGk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697793819;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FvDYn/6gTTylR+EYfZbky6SjxPhU8dj62/egKhxtriQ=;
        b=NOKkkhBgmGdZrQIZoBLHX4i3MUXd+dz5xXaKvpzoP3PlUs6iP8m3Y4bW+XQX+URl1Cd/ZF
        g9xZzduBYiyugMDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 94ABA13584;
        Fri, 20 Oct 2023 09:23:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6FgxFxpHMmUrOgAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 20 Oct 2023 09:23:38 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: [PATCH] bcache: fixup multi-threaded bch_sectors_dirty_init()
 wake-up race
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20231020075051.261222-1-mingzhe.zou@easystack.cn>
Date:   Fri, 20 Oct 2023 17:23:25 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <44D56265-0F0C-4FAF-A9A0-7BA97D41C84F@suse.de>
References: <20231020075051.261222-1-mingzhe.zou@easystack.cn>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3731.700.6)
Authentication-Results: smtp-out1.suse.de;
        none
X-Spam-Level: 
X-Spam-Score: -3.60
X-Spamd-Result: default: False [-3.60 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         BAYES_HAM(-0.00)[21.59%];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[4];
         MV_CASE(0.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         FREEMAIL_ENVRCPT(0.00)[qq.com];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         TO_DN_SOME(0.00)[];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[];
         FREEMAIL_CC(0.00)[lists.ewheeler.net,vger.kernel.org,qq.com]
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B410=E6=9C=8820=E6=97=A5 15:50=EF=BC=8CMingzhe Zou =
<mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> We get a kernel crash about "unable to handle kernel paging request":
>=20
> ```dmesg
> [368033.032005] BUG: unable to handle kernel paging request at =
ffffffffad9ae4b5
> [368033.032007] PGD fc3a0d067 P4D fc3a0d067 PUD fc3a0e063 PMD =
8000000fc38000e1
> [368033.032012] Oops: 0003 [#1] SMP PTI
> [368033.032015] CPU: 23 PID: 55090 Comm: bch_dirtcnt[0] Kdump: loaded =
Tainted: G           OE    --------- -  - 4.18.0-147.5.1.es8_24.x86_64 =
#1
> [368033.032017] Hardware name: Tsinghua Tongfang THTF Chaoqiang =
Server/072T6D, BIOS 2.4.3 01/17/2017
> [368033.032027] RIP: 0010:native_queued_spin_lock_slowpath+0x183/0x1d0
> [368033.032029] Code: 8b 02 48 85 c0 74 f6 48 89 c1 eb d0 c1 e9 12 83 =
e0
> 03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 c0 3d 02 00 48 03 04 cd 60 68 =
93
> ad <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 02
> [368033.032031] RSP: 0018:ffffbb48852abe00 EFLAGS: 00010082
> [368033.032032] RAX: ffffffffad9ae4b5 RBX: 0000000000000246 RCX: =
0000000000003bf3
> [368033.032033] RDX: ffff97b0ff8e3dc0 RSI: 0000000000600000 RDI: =
ffffbb4884743c68
> [368033.032034] RBP: 0000000000000001 R08: 0000000000000000 R09: =
000007ffffffffff
> [368033.032035] R10: ffffbb486bb01000 R11: 0000000000000001 R12: =
ffffffffc068da70
> [368033.032036] R13: 0000000000000003 R14: 0000000000000000 R15: =
0000000000000000
> [368033.032038] FS:  0000000000000000(0000) GS:ffff97b0ff8c0000(0000) =
knlGS:0000000000000000
> [368033.032039] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [368033.032040] CR2: ffffffffad9ae4b5 CR3: 0000000fc3a0a002 CR4: =
00000000003626e0
> [368033.032042] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
> [368033.032043] bcache: bch_cached_dev_attach() Caching rbd479 as =
bcache462 on set 8cff3c36-4a76-4242-afaa-7630206bc70b
> [368033.032045] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: =
0000000000000400
> [368033.032046] Call Trace:
> [368033.032054]  _raw_spin_lock_irqsave+0x32/0x40
> [368033.032061]  __wake_up_common_lock+0x63/0xc0
> [368033.032073]  ? bch_ptr_invalid+0x10/0x10 [bcache]
> [368033.033502]  bch_dirty_init_thread+0x14c/0x160 [bcache]
> [368033.033511]  ? read_dirty_submit+0x60/0x60 [bcache]
> [368033.033516]  kthread+0x112/0x130
> [368033.033520]  ? kthread_flush_work_fn+0x10/0x10
> [368033.034505]  ret_from_fork+0x35/0x40
> ```
>=20
> The crash occurred when call wake_up(&state->wait), and then we want
> to look at the value in the state. However, bch_sectors_dirty_init()
> is not found in the stack of any task. Since state is allocated on
> the stack, we guess that bch_sectors_dirty_init() has exited, causing
> bch_dirty_init_thread() to be unable to handle kernel paging request.
>=20
> In order to verify this idea, we added some printing information =
during
> wake_up(&state->wait). We find that "wake up" is printed twice, =
however
> we only expect the last thread to wake up once.
>=20
> ```dmesg
> [  994.641004] alcache: bch_dirty_init_thread() wake up
> [  994.641018] alcache: bch_dirty_init_thread() wake up
> [  994.641523] alcache: bch_sectors_dirty_init() init exit
> ```
>=20
> There is a race. If bch_sectors_dirty_init() exits after the first =
wake
> up, the second wake up will trigger this bug("unable to handle kernel
> paging request").
>=20
> Proceed as follows:
>=20
> bch_sectors_dirty_init
>    kthread_run =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> =
bch_dirty_init_thread(bch_dirtcnt[0])
>            ...                         ...
>    atomic_inc(&state.started)          ...
>            ...                         ...
>    atomic_read(&state.enough)          ...
>            ...                 atomic_set(&state->enough, 1)
>    kthread_run =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> bch_dirty_init_thread(bch_dirtcnt[1])
>            ...                 atomic_dec_and_test(&state->started)    =
        ...
>    atomic_inc(&state.started)          ...                             =
        ...
>            ...                 wake_up(&state->wait)                   =
        ...
>    atomic_read(&state.enough)                                          =
atomic_dec_and_test(&state->started)
>            ...                                                         =
        ...
>    wait_event(state.wait, atomic_read(&state.started) =3D=3D 0)        =
            ...
>    return                                                              =
        ...
>                                                                        =
wake_up(&state->wait)
>=20
> We believe it is very common to wake up twice if there is no dirty, =
but
> crash is an extremely low probability event. It's hard for us to =
reproduce
> this issue. We attached and detached continuously for a week, with a =
total
> of more than one million attaches and only one crash.
>=20
> Putting atomic_inc(&state.started) before kthread_run() can avoid =
waking
> up twice.
>=20
> Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be =
multithreaded")
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> Cc: stable@vger.kernel.org

Thanks for catching this. Added to my for-next.

Coly Li


> ---
> drivers/md/bcache/writeback.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/writeback.c =
b/drivers/md/bcache/writeback.c
> index 24c049067f61..a6ddd0bb9220 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -1014,17 +1014,18 @@ void bch_sectors_dirty_init(struct =
bcache_device *d)
> if (atomic_read(&state.enough))
> break;
>=20
> + atomic_inc(&state.started);
> state.infos[i].state =3D &state;
> state.infos[i].thread =3D
> kthread_run(bch_dirty_init_thread, &state.infos[i],
>    "bch_dirtcnt[%d]", i);
> if (IS_ERR(state.infos[i].thread)) {
> pr_err("fails to run thread bch_dirty_init[%d]\n", i);
> + atomic_dec(&state.started);
> for (--i; i >=3D 0; i--)
> kthread_stop(state.infos[i].thread);
> goto out;
> }
> - atomic_inc(&state.started);
> }
>=20
> out:
> --=20
> 2.17.1.windows.2
>=20

