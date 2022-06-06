Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2885153E004
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jun 2022 05:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348060AbiFFDXG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jun 2022 23:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245564AbiFFDXF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jun 2022 23:23:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365C81C102
        for <linux-bcache@vger.kernel.org>; Sun,  5 Jun 2022 20:23:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B41671F8F2;
        Mon,  6 Jun 2022 03:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654485782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jOs3dO9PXYYn1nXV2P9AIxruwws/MWyjFPlJkFgrv78=;
        b=iPw/d7vu8D0XIQCL36/fLb5JFB+tyOrV/HWic86J8EKTq9wLiEozmceNYWkpX6LUM4DAwo
        OSBZYmiX+AW4+nShQoo6Z3YreWB4lVwJI96it/EjQYgsfA3U5/TgHC1M3LX9AS/GUpLBrr
        HRRzdG1pdu/ovnH7BQPfNeBTAJy7fS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654485782;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jOs3dO9PXYYn1nXV2P9AIxruwws/MWyjFPlJkFgrv78=;
        b=3GW8K547fKHBOFD+zfE6Uup4TzExm/ofqOE6bgy3yIctLXf0ejz2PomdZZd7u/NGPWHp1c
        Ch/vWS7inGF2t9Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6EAFD13A8F;
        Mon,  6 Jun 2022 03:23:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NELJCxRznWI5EgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 06 Jun 2022 03:23:00 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] bcache: remove unnecessary flush_workqueue
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAMhKsX=boc+pgUbm6HTA0rs1YpLO4Twif+SC=3w++tAys2im+g@mail.gmail.com>
Date:   Mon, 6 Jun 2022 11:22:55 +0800
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2D500941-73E5-4C63-B5CF-2324E8745AED@suse.de>
References: <20220327072038.12385-1-lilei@szsandstone.com>
 <40862b68-e81d-089b-d713-b0e6e2bd7e04@suse.de>
 <CAMhKsXnLdAjSN00WpCrq4P-3Z6PEf+vp_QfiHcwCLuVH9s5z_Q@mail.gmail.com>
 <428a70b3-f671-e6fb-93d1-0a975da35ad8@suse.de>
 <CAMhKsX=boc+pgUbm6HTA0rs1YpLO4Twif+SC=3w++tAys2im+g@mail.gmail.com>
To:     Lei Li <noctis.akm@gmail.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B45=E6=9C=8829=E6=97=A5 02:11=EF=BC=8CLei Li =
<noctis.akm@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Sorry for replying so late, because of my testing environment. After
> several fio random writing and reboot tests,
> this patch worked well. Here is the test result.
>=20
> 1. I successfully reproduced deadlock warning by reverting commit
> 7e865eba00a3 ("bcache: fix potential
> deadlock in cached_def_free()").
> [  105.448074] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  105.449634] WARNING: possible circular locking dependency detected
> [  105.451185] 5.4.191-MANJARO #1 Not tainted
> [  105.452221] ------------------------------------------------------
> [  105.453742] kworker/9:15/1272 is trying to acquire lock:
> [  105.455042] ffff9e9ef1c44348
> ((wq_completion)bcache_writeback_wq){+.+.}, at:
> flush_workqueue+0x8a/0x550
> [  105.457482]
> [  105.457482] but task is already holding lock:
> [  105.458926] ffffbaba01203e68
> ((work_completion)(&cl->work)#2){+.+.}, at:
> process_one_work+0x1c3/0x5a0
> [  105.461568]
> [  105.461568] which lock already depends on the new lock.
> [  105.461568]
> [  105.463810]
> [  105.463810] the existing dependency chain (in reverse order) is:
> [  105.465570]
> [  105.465570] -> #1 ((work_completion)(&cl->work)#2){+.+.}:
> [  105.467230]        process_one_work+0x21a/0x5a0
> [  105.468449]        worker_thread+0x52/0x3c0
> [  105.469653]        kthread+0x132/0x150
> [  105.470695]        ret_from_fork+0x3a/0x50
> [  105.471649]
> [  105.471649] -> #0 ((wq_completion)bcache_writeback_wq){+.+.}:
> [  105.473453]        __lock_acquire+0x105b/0x1c50
> [  105.474678]        lock_acquire+0xc4/0x1b0
> [  105.476007]        flush_workqueue+0xad/0x550
> [  105.477160]        drain_workqueue+0xb6/0x170
> [  105.478237]        destroy_workqueue+0x36/0x290
> [  105.479328]        cached_dev_free+0x45/0x1e0 [bcache]
> [  105.480595]        process_one_work+0x243/0x5a0
> [  105.481714]        worker_thread+0x52/0x3c0
> [  105.482687]        kthread+0x132/0x150
> [  105.483667]        ret_from_fork+0x3a/0x50
> [  105.484707]
> [  105.484707] other info that might help us debug this:
> [  105.484707]
> [  105.486856]  Possible unsafe locking scenario:
> [  105.486856]
> [  105.488314]        CPU0                    CPU1
> [  105.489336]        ----                    ----
> [  105.490438]   lock((work_completion)(&cl->work)#2);
> [  105.491587]
> lock((wq_completion)bcache_writeback_wq);
> [  105.493554]
> lock((work_completion)(&cl->work)#2);
> [  105.495360]   lock((wq_completion)bcache_writeback_wq);
> [  105.496878]
> [  105.496878]  *** DEADLOCK ***
> [  105.496878]
> [  105.498303] 2 locks held by kworker/9:15/1272:
> [  105.499373]  #0: ffff9e9f16c21148 ((wq_completion)events){+.+.},
> at: process_one_work+0x1c3/0x5a0
> [  105.501514]  #1: ffffbaba01203e68
> ((work_completion)(&cl->work)#2){+.+.}, at:
> process_one_work+0x1c3/0x5a0
> [  105.504221]
> [  105.504221] stack backtrace:
> [  105.505271] CPU: 9 PID: 1272 Comm: kworker/9:15 Not tainted
> 5.4.191-MANJARO #1
> [  105.507069] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
> [  105.509485] Workqueue: events cached_dev_free [bcache]
> [  105.510805] Call Trace:
> [  105.511471]  dump_stack+0x8b/0xbd
> [  105.512327]  check_noncircular+0x198/0x1b0
> [  105.513462]  __lock_acquire+0x105b/0x1c50
> [  105.514675]  lock_acquire+0xc4/0x1b0
> [  105.515557]  ? flush_workqueue+0x8a/0x550
> [  105.516535]  flush_workqueue+0xad/0x550
> [  105.517587]  ? flush_workqueue+0x8a/0x550
> [  105.518530]  ? drain_workqueue+0xb6/0x170
> [  105.519518]  drain_workqueue+0xb6/0x170
> [  105.520572]  destroy_workqueue+0x36/0x290
> [  105.521658]  cached_dev_free+0x45/0x1e0 [bcache]
> [  105.522879]  process_one_work+0x243/0x5a0
> [  105.523854]  worker_thread+0x52/0x3c0
> [  105.524734]  ? process_one_work+0x5a0/0x5a0
> [  105.525768]  kthread+0x132/0x150
> [  105.526594]  ? __kthread_bind_mask+0x60/0x60
> [  105.527706]  ret_from_fork+0x3a/0x50
> [  105.571043] bcache: bcache_device_free() bcache0 stopped
> [  105.730801] bcache: cache_set_free() Cache set
> 74f01341-0881-4c77-a49b-39fafcabb99e unregistered
> [  105.730819] bcache: bcache_reboot() All devices stopped
> [  105.930055] reboot: Restarting system
> [  105.930996] reboot: machine restart
> [  105.932182] ACPI MEMORY or I/O RESET_REG.
>=20
> 2. After applied 7e865eba00a3 and this patch, no warning showed again.
> [   58.296057] bcache: bcache_reboot() Stopping all devices:
> [   58.337730] bcache: bcache_device_free() bcache0 stopped
> [   58.484177] bcache: cache_set_free() Cache set
> 74f01341-0881-4c77-a49b-39fafcabb99e unregistered
> [   58.484202] bcache: bcache_reboot() All devices stopped
> [   58.731929] reboot: Restarting system
> [   58.732845] reboot: machine restart
> [   58.734044] ACPI MEMORY or I/O RESET_REG.

Hi Lei,

Nice, then it is proved your patch removes redundant code without =
regression.

I will take this patch for 5.20, thank you for the extra effort.

Coly Li


