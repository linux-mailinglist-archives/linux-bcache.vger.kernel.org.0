Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595DB741F47
	for <lists+linux-bcache@lfdr.de>; Thu, 29 Jun 2023 06:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjF2EeR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 29 Jun 2023 00:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjF2EeI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Jun 2023 00:34:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4045213D
        for <linux-bcache@vger.kernel.org>; Wed, 28 Jun 2023 21:34:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DFFAE1F74A;
        Thu, 29 Jun 2023 04:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1688013244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/t7ivZPC7L5goC7zhx29jo4sw5Yar52UdrAAQe+f1xA=;
        b=jHY9MA39tClOgGmV21JX3zUpbgsYSR3rvpA7EFYc1feZG3YKkVFeYi75k+yz6YfoYwgCSj
        4NI0mLb9z7h6DGEnxZPLQmQ3Bev83diW6zMrUPBYgWiyHEv8w8xIu0stuO0ptB5W7wn21k
        B14yGarWF9zPiwKyoZu0vSqWiFsRi8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1688013244;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/t7ivZPC7L5goC7zhx29jo4sw5Yar52UdrAAQe+f1xA=;
        b=ITgtBJEPXpnpdYrkvcCqBbzHX787JFTEYdW+c6NtY5+fCzZyvC/buE6vspSF616qhmz30x
        QzcaUXxWmvWqG0DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5201C1348C;
        Thu, 29 Jun 2023 04:34:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IQ+mCLwJnWQVdQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 29 Jun 2023 04:34:04 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: bcache: Possible deadlock between write_dirty_finish and
 bch_data_insert_keys
From:   Coly Li <colyli@suse.de>
In-Reply-To: <cc68eb14-6926-562d-951b-36f1aacb72da@ewheeler.net>
Date:   Thu, 29 Jun 2023 12:33:51 +0800
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A84B2587-6FEF-4B47-AE52-40EA06DE8AC1@suse.de>
References: <83ac53d0-9ad6-9043-a1ba-7ddaa2a92bc0@ewheeler.net>
 <DC0AB1EF-5911-4B1D-940C-D91DC22EE650@suse.de>
 <11494BB4-8FCD-4193-9310-296E4025ED44@suse.de>
 <3e38f9ce-574d-688e-8981-b9474737d6a7@ewheeler.net>
 <cc68eb14-6926-562d-951b-36f1aacb72da@ewheeler.net>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B46=E6=9C=8829=E6=97=A5 08:46=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Wed, 28 Jun 2023, Eric Wheeler wrote:
>> On Tue, 27 Jun 2023, Coly Li wrote:
>>>> 2023=E5=B9=B46=E6=9C=8827=E6=97=A5 20:54=EF=BC=8CColy Li =
<colyli@suse.de> =E5=86=99=E9=81=93=EF=BC=9A
>>>>> 2023=E5=B9=B46=E6=9C=8827=E6=97=A5 11:19=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>>>>> We have a system running a 5.15 kernel with the following errors =
in dmesg=20
>>>>> displaying repeatedly.  Ultimately the system crashed so I'll =
reset=20
>>>>> it---but I was able to get some good information out of it before =
it died=20
>>>>> so maybe we can pin it down. This happened under high CPU and disk =
load:
>>>>>=20
>>>>> [Jun26 19:24] BUG: workqueue lockup - pool cpus=3D0 node=3D0 =
flags=3D0x0 nice=3D0 stuck for 1382s!
>>>>> [  +0.001211] BUG: workqueue lockup - pool cpus=3D0 node=3D0 =
flags=3D0x0 nice=3D-20 stuck for 1381s!
>>>>> [  +0.001117] Showing busy workqueues and worker pools:
>>>>> [  +0.001081] workqueue events: flags=3D0x0
>>>>> [  +0.000007]   pwq 0: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 =
active=3D9/256 refcnt=3D10
>>>>> [  +0.000005]     pending: vmstat_shepherd, kfree_rcu_monitor, =
drm_fb_helper_damage_work [drm_kms_helper], kfree_rcu_monitor, =
mlx5_timestamp_overflow [mlx5_core], mlx5_timestamp_overflow =
[mlx5_core], kfree_rcu_monitor, mlx5e_tx_dim_work [mlx5_core], =
mlx5e_rx_dim_work [mlx5_core]
>>>>> [  +0.000301] workqueue events_highpri: flags=3D0x10
>>>>> [  +0.000002]   pwq 59: cpus=3D29 node=3D6 flags=3D0x0 nice=3D-20 =
active=3D1/256 refcnt=3D2
>>>>> [  +0.000004]     pending: mix_interrupt_randomness
>>>>> [  +0.000006]   pwq 29: cpus=3D14 node=3D7 flags=3D0x0 nice=3D-20 =
active=3D1/256 refcnt=3D2
>>>>> [  +0.000003]     pending: mix_interrupt_randomness
>>>>> [  +0.000005]   pwq 1: cpus=3D0 node=3D0 flags=3D0x0 nice=3D-20 =
active=3D1/256 refcnt=3D2
>>>>> [  +0.000002]     pending: mix_interrupt_randomness
>>>>> [  +0.000007] workqueue events_long: flags=3D0x0
>>>>> [  +0.000003]   pwq 0: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 =
active=3D1/256 refcnt=3D2
>>>>> [  +0.000002]     pending: br_fdb_cleanup
>>>>> [  +0.000014] workqueue events_power_efficient: flags=3D0x80
>>>>> [  +0.000004]   pwq 0: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 =
active=3D1/256 refcnt=3D2
>>>>> [  +0.000002]     pending: fb_flashcursor
>>>>> [  +0.000008] workqueue events_freezable_power_: flags=3D0x84
>>>>> [  +0.000003]   pwq 8: cpus=3D4 node=3D2 flags=3D0x0 nice=3D0 =
active=3D1/256 refcnt=3D2
>>>>> [  +0.000002]     pending: disk_events_workfn
>>>>> [  +0.000019] workqueue mm_percpu_wq: flags=3D0x8
>>>>> [  +0.000004]   pwq 0: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 =
active=3D1/256 refcnt=3D3
>>>>> [  +0.000002]     pending: lru_add_drain_per_cpu BAR(212)
>>>>> [  +0.000036] workqueue kblockd: flags=3D0x18
>>>>> [  +0.000005]   pwq 9: cpus=3D4 node=3D2 flags=3D0x0 nice=3D-20 =
active=3D1/256 refcnt=3D2
>>>>> [  +0.000003]     pending: blk_mq_timeout_work
>>>>> [  +0.000005]   pwq 1: cpus=3D0 node=3D0 flags=3D0x0 nice=3D-20 =
active=3D3/256 refcnt=3D4
>>>>> [  +0.000003]     pending: blk_mq_timeout_work, =
blk_mq_run_work_fn, blk_mq_run_work_fn
>>>>> [  +0.000044] workqueue bch_btree_io: flags=3D0x8
>>>>> [  +0.000001]   pwq 62: cpus=3D31 node=3D7 flags=3D0x0 nice=3D0 =
active=3D1/256 refcnt=3D2
>>>>> [  +0.000004]     in-flight: 3331:btree_node_write_work
>>>>> [  +0.000006]   pwq 38: cpus=3D19 node=3D1 flags=3D0x0 nice=3D0 =
active=3D1/256 refcnt=3D2
>>>>> [  +0.000003]     in-flight: 4829:btree_node_write_work
>>>>> [  +0.000005]   pwq 0: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 =
active=3D7/256 refcnt=3D8
>>>>> [  +0.000002]     pending: btree_node_write_work, =
btree_node_write_work, btree_node_write_work, btree_node_write_work, =
btree_node_write_work, btree_node_write_work, btree_node_write_work
>>>>> [  +0.000011] workqueue bcache: flags=3D0x8
>>>>> [  +0.000002]   pwq 6: cpus=3D3 node=3D1 flags=3D0x0 nice=3D0 =
active=3D1/256 refcnt=3D2
>>>>> [  +0.000003]     in-flight: 6295:bch_data_insert_keys
>>>>> [  +0.000073] workqueue bcache_writeback_wq: flags=3D0x8
>>>>> [  +0.000002]   pwq 62: cpus=3D31 node=3D7 flags=3D0x0 nice=3D0 =
active=3D64/256 refcnt=3D65
>>>>> [  +0.000002]     in-flight: 10178:write_dirty_finish, =
10067:write_dirty_finish, 3302:write_dirty_finish, =
10184:write_dirty_finish, 10181:write_dirty_finish, =
10066:write_dirty_finish, 10105:write_dirty_finish, =
10195:write_dirty_finish, 980:write_dirty_finish, =
10141:write_dirty_finish, 10139:write_dirty_finish, =
10098:write_dirty_finish, 10008:write_dirty_finish, =
10180:write_dirty_finish, 20178:write_dirty_finish, =
3252:write_dirty_finish, 10007:write_dirty_finish, =
10279:write_dirty_finish, 10142:write_dirty_finish, =
10223:write_dirty_finish, 10097:write_dirty_finish, =
7311:write_dirty_finish, 10234:write_dirty_finish, =
10196:write_dirty_finish, 10280:write_dirty_finish, =
10063:write_dirty_finish, 10064:write_dirty_finish, =
10188:write_dirty_finish, 10043:write_dirty_finish, =
10101:write_dirty_finish, 10185:write_dirty_finish, =
10103:write_dirty_finish, 10102:write_dirty_finish, =
10224:write_dirty_finish, 10186:write_dirty_finish, =
10114:write_dirty_finish, 10011:write_dirty_finish
>>>>> [  +0.000083] , 3253:write_dirty_finish, 10112:write_dirty_finish, =
10187:write_dirty_finish, 10009:write_dirty_finish, =
10138:write_dirty_finish, 10104:write_dirty_finish, =
10140:write_dirty_finish, 10065:write_dirty_finish, =
10193:write_dirty_finish, 10095:write_dirty_finish, =
10041:write_dirty_finish, 10010:write_dirty_finish, =
10115:write_dirty_finish, 10094:write_dirty_finish, =
10113:write_dirty_finish, 10194:write_dirty_finish, =
10177:write_dirty_finish, 10042:write_dirty_finish, =
10226:write_dirty_finish, 10179:write_dirty_finish, =
10096:write_dirty_finish, 10192:write_dirty_finish, =
10222:write_dirty_finish, 10045:write_dirty_finish, =
10116:write_dirty_finish, 10044:write_dirty_finish, =
10225:write_dirty_finish
>>>>> [  +0.000133] workqueue kcopyd: flags=3D0x8
>>>>> [  +0.000004]   pwq 2: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 =
active=3D2/256 refcnt=3D3
>>>>> [  +0.000003]     in-flight: 3424:do_work [dm_mod] do_work =
[dm_mod]
>>>>> [  +0.000520] pool 2: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 =
hung=3D14s workers=3D3 idle: 21748 21749
>>>>> [  +0.000006] pool 6: cpus=3D3 node=3D1 flags=3D0x0 nice=3D0 =
hung=3D43s workers=3D3 idle: 11428 25181
>>>>> [  +0.000006] pool 38: cpus=3D19 node=3D1 flags=3D0x0 nice=3D0 =
hung=3D34s workers=3D3 idle: 22403 25014
>>>>> [  +0.000006] pool 62: cpus=3D31 node=3D7 flags=3D0x0 nice=3D0 =
hung=3D2s workers=3D68 idle: 10281 23228 10286
>>>>>=20
>>>>> Clearly there are many write_dirty_finish() calls stuck, here are =
some=20
>>>>> traces:
>>>>>=20
>>>>> I did `cat /proc/<pid>/stack` for each bcache workqueue PID and =
these
>>>>> are the unique stacks:
>>>>>=20
>>>>> dmesg | grep in-flight | \
>>>>> perl -lne 'while(/(\d+):((write_dirty|bch|btree)\S+)/g) { print =
"$1 $2" }' | \
>>>>> sort -u | \
>>>>> while read a b; do echo =3D=3D=3D $a $b ; cat /proc/$a/stack; done
>>>>>=20
>>>>> Which prints lots of these:
>>>>>=20
>>>>> =3D=3D=3D 3253: write_dirty_finish=20
>>>>> [<0>] rwsem_down_write_slowpath+0x27b/0x4bd
>>>>> [<0>] bch_btree_node_get.part.0+0x7e/0x2d7  <<<, _probably_ called =
with write=3Dtrue
>>>>> [<0>] bch_btree_map_nodes_recurse+0xed/0x1a7   | since this is an =
insert
>>>>> [<0>] __bch_btree_map_nodes+0x17c/0x1c4
>>>>> [<0>] bch_btree_insert+0x102/0x188     <<<<< race?
>>>>> [<0>] write_dirty_finish+0x122/0x1d3   <<<<< entry
>>>>> [<0>] process_one_work+0x1f1/0x3c6
>>>>> [<0>] worker_thread+0x53/0x3e4
>>>>> [<0>] kthread+0x127/0x144
>>>>> [<0>] ret_from_fork+0x22/0x2d
>>>>>=20
>>>>> and one of these:
>>>>> =3D=3D=3D 6295 bch_data_insert_keys
>>>>> [<0>] bch_btree_insert_node+0x6b/0x287
>>>>> [<0>] btree_insert_fn+0x20/0x48       =20
>>>>> [<0>] bch_btree_map_nodes_recurse+0x111/0x1a7
>>>>> [<0>] __bch_btree_map_nodes+0x17c/0x1c4
>>>>> [<0>] bch_btree_insert+0x102/0x188     <<<<< race?
>>>>> [<0>] bch_data_insert_keys+0x30/0xba   <<<<< entry
>>>>> [<0>] process_one_work+0x1f1/0x3c6
>>>>> [<0>] worker_thread+0x53/0x3e4
>>>>> [<0>] kthread+0x127/0x144
>>>>> [<0>] ret_from_fork+0x22/0x2d
>>>>>=20
>>>>> Note that above, both threads (workqueues) are similar until they =
call
>>>>> bch_btree_map_nodes_recurse(), then they diverge where one is =
doing
>>>>> bch_btree_insert_node(), which holds b->write_lock:
>>>>>=20
>>>>> bch_btree_insert_node
>>>>> =
https://elixir.bootlin.com/linux/latest/source/drivers/md/bcache/btree.c#L=
2322
>>>>>=20
>>>>> and the other is trying bch_btree_node_get().  While I don't have =
debug
>>>>> data about the arguments, I am guessing that bch_btree_node_get is
>>>>> called with `write=3Dtrue` since the caller is bch_btree_insert:
>>>>>=20
>>>>> /* bch_btree_node_get - find a btree node in the cache and lock =
it, reading it
>>>>> * in from disk if necessary. */
>>>>> =
https://elixir.bootlin.com/linux/v6.4/source/drivers/md/bcache/btree.c#L96=
9
>>>>>=20
>>>>> The call to bch_btree_node_get() does quite a bit of =
rw_lock/rw_unlock/mutex work.
>>>>>=20
>>>>> There are also two of the traces below which are waiting on a =
down():
>>>>> =
https://elixir.bootlin.com/linux/latest/source/drivers/md/bcache/btree.c#L=
420
>>>>>=20
>>>>> These could be relevant since __bch_btree_node_write() does call=20=

>>>>> `lockdep_assert_held(&b->write_lock)` and b->write_lock is held =
above by=20
>>>>> bch_btree_insert_node:
>>>>>=20
>>>>> =3D=3D=3D 3331 btree_node_write_work
>>>>> [<0>] down+0x43/0x54
>>>>> [<0>] __bch_btree_node_write+0xa3/0x220
>>>>> [<0>] btree_node_write_work+0x43/0x4f
>>>>> [<0>] process_one_work+0x1f1/0x3c6
>>>>> [<0>] worker_thread+0x53/0x3e4
>>>>> [<0>] kthread+0x127/0x144
>>>>> [<0>] ret_from_fork+0x22/0x2d
>>>>>=20
>>>>> =3D=3D=3D 4829 btree_node_write_work
>>>>> [<0>] down+0x43/0x54
>>>>> [<0>] __bch_btree_node_write+0xa3/0x220
>>>>> [<0>] btree_node_write_work+0x43/0x4f
>>>>> [<0>] process_one_work+0x1f1/0x3c6
>>>>> [<0>] worker_thread+0x53/0x3e4
>>>>> [<0>] kthread+0x127/0x144
>>>>> [<0>] ret_from_fork+0x22/0x2d
>>>>>=20
>>>>> Thanks for your help!
>>>>=20
>>>> When does this lockup happen? Is it in initialization or bootup =
time ?
>>=20
>> After its been running for a few days and always under heavy CPU and =
disk=20
>> IO.
>>=20
>> I'll check the patches below and see if we are missing any. =20
>=20
>=20
> These were missing, so I'm cherry-picking and rebuilding:
>=20
>    bcache: fixup btree_cache_wait list damage
>    bcache: remove unnecessary flush_workqueue
>    bcache: avoid unnecessary soft lockup in kworker =
update_writeback_rate()
>    bcache: fixup bcache_dev_sectors_dirty_add() multithreaded CPU =
false sharing
>    bcache: fix NULL pointer reference in cached_dev_detach_finish
>    bcache: move calc_cached_dev_sectors to proper place on backing =
device detach
>=20
> This one fails to build, unsafe_memcpy is missing, but I don't think =
we=20
> need it:
>    bcache: Silence memcpy() run-time false positive warnings
>=20

Yes the above patch can be ignored.

Coly Li

