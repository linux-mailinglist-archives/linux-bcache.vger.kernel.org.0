Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C05C73F29B
	for <lists+linux-bcache@lfdr.de>; Tue, 27 Jun 2023 05:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjF0D0Y (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 26 Jun 2023 23:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjF0DYn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Jun 2023 23:24:43 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8358E1708
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jun 2023 20:19:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 26BB249
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jun 2023 20:19:58 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id TGGhUkLyTe2E for <linux-bcache@vger.kernel.org>;
        Mon, 26 Jun 2023 20:19:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 7FACC47
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jun 2023 20:19:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 7FACC47
Date:   Mon, 26 Jun 2023 20:19:51 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     linux-bcache@vger.kernel.org
Subject: bcache: Possible deadlock between write_dirty_finish and
 bch_data_insert_keys
Message-ID: <83ac53d0-9ad6-9043-a1ba-7ddaa2a92bc0@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello all,

We have a system running a 5.15 kernel with the following errors in dmesg 
displaying repeatedly.  Ultimately the system crashed so I'll reset 
it---but I was able to get some good information out of it before it died 
so maybe we can pin it down. This happened under high CPU and disk load:

[Jun26 19:24] BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0 nice=0 stuck for 1382s!
[  +0.001211] BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0 nice=-20 stuck for 1381s!
[  +0.001117] Showing busy workqueues and worker pools:
[  +0.001081] workqueue events: flags=0x0
[  +0.000007]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=9/256 refcnt=10
[  +0.000005]     pending: vmstat_shepherd, kfree_rcu_monitor, drm_fb_helper_damage_work [drm_kms_helper], kfree_rcu_monitor, mlx5_timestamp_overflow [mlx5_core], mlx5_timestamp_overflow [mlx5_core], kfree_rcu_monitor, mlx5e_tx_dim_work [mlx5_core], mlx5e_rx_dim_work [mlx5_core]
[  +0.000301] workqueue events_highpri: flags=0x10
[  +0.000002]   pwq 59: cpus=29 node=6 flags=0x0 nice=-20 active=1/256 refcnt=2
[  +0.000004]     pending: mix_interrupt_randomness
[  +0.000006]   pwq 29: cpus=14 node=7 flags=0x0 nice=-20 active=1/256 refcnt=2
[  +0.000003]     pending: mix_interrupt_randomness
[  +0.000005]   pwq 1: cpus=0 node=0 flags=0x0 nice=-20 active=1/256 refcnt=2
[  +0.000002]     pending: mix_interrupt_randomness
[  +0.000007] workqueue events_long: flags=0x0
[  +0.000003]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
[  +0.000002]     pending: br_fdb_cleanup
[  +0.000014] workqueue events_power_efficient: flags=0x80
[  +0.000004]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
[  +0.000002]     pending: fb_flashcursor
[  +0.000008] workqueue events_freezable_power_: flags=0x84
[  +0.000003]   pwq 8: cpus=4 node=2 flags=0x0 nice=0 active=1/256 refcnt=2
[  +0.000002]     pending: disk_events_workfn
[  +0.000019] workqueue mm_percpu_wq: flags=0x8
[  +0.000004]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=3
[  +0.000002]     pending: lru_add_drain_per_cpu BAR(212)
[  +0.000036] workqueue kblockd: flags=0x18
[  +0.000005]   pwq 9: cpus=4 node=2 flags=0x0 nice=-20 active=1/256 refcnt=2
[  +0.000003]     pending: blk_mq_timeout_work
[  +0.000005]   pwq 1: cpus=0 node=0 flags=0x0 nice=-20 active=3/256 refcnt=4
[  +0.000003]     pending: blk_mq_timeout_work, blk_mq_run_work_fn, blk_mq_run_work_fn
[  +0.000044] workqueue bch_btree_io: flags=0x8
[  +0.000001]   pwq 62: cpus=31 node=7 flags=0x0 nice=0 active=1/256 refcnt=2
[  +0.000004]     in-flight: 3331:btree_node_write_work
[  +0.000006]   pwq 38: cpus=19 node=1 flags=0x0 nice=0 active=1/256 refcnt=2
[  +0.000003]     in-flight: 4829:btree_node_write_work
[  +0.000005]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=7/256 refcnt=8
[  +0.000002]     pending: btree_node_write_work, btree_node_write_work, btree_node_write_work, btree_node_write_work, btree_node_write_work, btree_node_write_work, btree_node_write_work
[  +0.000011] workqueue bcache: flags=0x8
[  +0.000002]   pwq 6: cpus=3 node=1 flags=0x0 nice=0 active=1/256 refcnt=2
[  +0.000003]     in-flight: 6295:bch_data_insert_keys
[  +0.000073] workqueue bcache_writeback_wq: flags=0x8
[  +0.000002]   pwq 62: cpus=31 node=7 flags=0x0 nice=0 active=64/256 refcnt=65
[  +0.000002]     in-flight: 10178:write_dirty_finish, 10067:write_dirty_finish, 3302:write_dirty_finish, 10184:write_dirty_finish, 10181:write_dirty_finish, 10066:write_dirty_finish, 10105:write_dirty_finish, 10195:write_dirty_finish, 980:write_dirty_finish, 10141:write_dirty_finish, 10139:write_dirty_finish, 10098:write_dirty_finish, 10008:write_dirty_finish, 10180:write_dirty_finish, 20178:write_dirty_finish, 3252:write_dirty_finish, 10007:write_dirty_finish, 10279:write_dirty_finish, 10142:write_dirty_finish, 10223:write_dirty_finish, 10097:write_dirty_finish, 7311:write_dirty_finish, 10234:write_dirty_finish, 10196:write_dirty_finish, 10280:write_dirty_finish, 10063:write_dirty_finish, 10064:write_dirty_finish, 10188:write_dirty_finish, 10043:write_dirty_finish, 10101:write_dirty_finish, 10185:write_dirty_finish, 10103:write_dirty_finish, 10102:write_dirty_finish, 10224:write_dirty_finish, 10186:write_dirty_finish, 10114:write_dirty_finish, 10011:write_dirty_finish
[  +0.000083] , 3253:write_dirty_finish, 10112:write_dirty_finish, 10187:write_dirty_finish, 10009:write_dirty_finish, 10138:write_dirty_finish, 10104:write_dirty_finish, 10140:write_dirty_finish, 10065:write_dirty_finish, 10193:write_dirty_finish, 10095:write_dirty_finish, 10041:write_dirty_finish, 10010:write_dirty_finish, 10115:write_dirty_finish, 10094:write_dirty_finish, 10113:write_dirty_finish, 10194:write_dirty_finish, 10177:write_dirty_finish, 10042:write_dirty_finish, 10226:write_dirty_finish, 10179:write_dirty_finish, 10096:write_dirty_finish, 10192:write_dirty_finish, 10222:write_dirty_finish, 10045:write_dirty_finish, 10116:write_dirty_finish, 10044:write_dirty_finish, 10225:write_dirty_finish
[  +0.000133] workqueue kcopyd: flags=0x8
[  +0.000004]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=2/256 refcnt=3
[  +0.000003]     in-flight: 3424:do_work [dm_mod] do_work [dm_mod]
[  +0.000520] pool 2: cpus=1 node=0 flags=0x0 nice=0 hung=14s workers=3 idle: 21748 21749
[  +0.000006] pool 6: cpus=3 node=1 flags=0x0 nice=0 hung=43s workers=3 idle: 11428 25181
[  +0.000006] pool 38: cpus=19 node=1 flags=0x0 nice=0 hung=34s workers=3 idle: 22403 25014
[  +0.000006] pool 62: cpus=31 node=7 flags=0x0 nice=0 hung=2s workers=68 idle: 10281 23228 10286

Clearly there are many write_dirty_finish() calls stuck, here are some 
traces:

I did `cat /proc/<pid>/stack` for each bcache workqueue PID and these
are the unique stacks:

	dmesg | grep in-flight | \
		perl -lne 'while(/(\d+):((write_dirty|bch|btree)\S+)/g) { print "$1 $2" }' | \
		sort -u | \
		while read a b; do echo === $a $b ; cat /proc/$a/stack; done

Which prints lots of these:

	=== 3253: write_dirty_finish 
	[<0>] rwsem_down_write_slowpath+0x27b/0x4bd
	[<0>] bch_btree_node_get.part.0+0x7e/0x2d7  <<<, _probably_ called with write=true
	[<0>] bch_btree_map_nodes_recurse+0xed/0x1a7   | since this is an insert
	[<0>] __bch_btree_map_nodes+0x17c/0x1c4
	[<0>] bch_btree_insert+0x102/0x188     <<<<< race?
	[<0>] write_dirty_finish+0x122/0x1d3   <<<<< entry
	[<0>] process_one_work+0x1f1/0x3c6
	[<0>] worker_thread+0x53/0x3e4
	[<0>] kthread+0x127/0x144
	[<0>] ret_from_fork+0x22/0x2d

and one of these:
	=== 6295 bch_data_insert_keys
	[<0>] bch_btree_insert_node+0x6b/0x287
	[<0>] btree_insert_fn+0x20/0x48        
	[<0>] bch_btree_map_nodes_recurse+0x111/0x1a7
	[<0>] __bch_btree_map_nodes+0x17c/0x1c4
	[<0>] bch_btree_insert+0x102/0x188     <<<<< race?
	[<0>] bch_data_insert_keys+0x30/0xba   <<<<< entry
	[<0>] process_one_work+0x1f1/0x3c6
	[<0>] worker_thread+0x53/0x3e4
	[<0>] kthread+0x127/0x144
	[<0>] ret_from_fork+0x22/0x2d

Note that above, both threads (workqueues) are similar until they call
bch_btree_map_nodes_recurse(), then they diverge where one is doing
bch_btree_insert_node(), which holds b->write_lock:

	bch_btree_insert_node
	  https://elixir.bootlin.com/linux/latest/source/drivers/md/bcache/btree.c#L2322

and the other is trying bch_btree_node_get().  While I don't have debug
data about the arguments, I am guessing that bch_btree_node_get is
called with `write=true` since the caller is bch_btree_insert:

	/* bch_btree_node_get - find a btree node in the cache and lock it, reading it
	 * in from disk if necessary. */
	https://elixir.bootlin.com/linux/v6.4/source/drivers/md/bcache/btree.c#L969

The call to bch_btree_node_get() does quite a bit of rw_lock/rw_unlock/mutex work.

There are also two of the traces below which are waiting on a down():
	https://elixir.bootlin.com/linux/latest/source/drivers/md/bcache/btree.c#L420

These could be relevant since __bch_btree_node_write() does call 
`lockdep_assert_held(&b->write_lock)` and b->write_lock is held above by 
bch_btree_insert_node:

	=== 3331 btree_node_write_work
	[<0>] down+0x43/0x54
	[<0>] __bch_btree_node_write+0xa3/0x220
	[<0>] btree_node_write_work+0x43/0x4f
	[<0>] process_one_work+0x1f1/0x3c6
	[<0>] worker_thread+0x53/0x3e4
	[<0>] kthread+0x127/0x144
	[<0>] ret_from_fork+0x22/0x2d

	=== 4829 btree_node_write_work
	[<0>] down+0x43/0x54
	[<0>] __bch_btree_node_write+0xa3/0x220
	[<0>] btree_node_write_work+0x43/0x4f
	[<0>] process_one_work+0x1f1/0x3c6
	[<0>] worker_thread+0x53/0x3e4
	[<0>] kthread+0x127/0x144
	[<0>] ret_from_fork+0x22/0x2d

Thanks for your help!

--
Eric Wheeler
