Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A6C45B000
	for <lists+linux-bcache@lfdr.de>; Wed, 24 Nov 2021 00:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbhKWX1E (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Nov 2021 18:27:04 -0500
Received: from mailbackend.panix.com ([166.84.1.89]:53535 "EHLO
        mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235626AbhKWX1D (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Nov 2021 18:27:03 -0500
Received: from [192.168.126.80] (ip98-184-250-31.oc.oc.cox.net [98.184.250.31])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4HzKvs1DP3z2j2C;
        Tue, 23 Nov 2021 18:23:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1637709833; bh=bwDebFqLHZNrAB1goALoefa3P0Dtn8z3qf5VSWcM/6o=;
        h=Date:From:Reply-To:To:cc:Subject:In-Reply-To:References;
        b=cns/GleUdRu0+9f/X8mBxJBCFPx2YJj78MSPmXfjcaYnoV/aTbszwKCcQITOKzQ/N
         LNvm8dfK1dPSVnLdY3Ghi0nlT5L6zfu8qy4VgkYTT3Ta2a0dWI5o6TvPRh49hHYIc3
         /hETUqccKulyqKSFjosd+6BD7m3ZXAJ96x+sjD2w=
Date:   Tue, 23 Nov 2021 15:23:52 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org
cc:     "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
In-Reply-To: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com>
Message-ID: <f2a31f22-816f-ff58-af8c-f4c8137fc2a2@panix.com>
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


It's happened again, this makes three times today (and none the day before, and
only twice over the last week, so bisecting is probably unlikely to give a result
in any reasonable time-frame). I'm going to pop back to a released kernel, but
can try any patches or tests, if there's any ideas.

	-Kenny

----
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522129][   T55] INFO: task kworker/u16:1:68 blocked for more than 122 seconds.
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522144][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522149][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522152][   T55] task:kworker/u16:1   state:D stack:    0 pid:   68 ppid:     2 flags:0x00004000
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522188][   T55] Workqueue: writeback wb_workfn (flush-259:0)
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522200][   T55] Call Trace:
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522202][   T55]  <TASK>
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522205][   T55]  __schedule+0x4ac/0x6d0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522213][   T55]  ? blk_flush_plug+0xcb/0x100
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522218][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522223][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522227][   T55]  schedule+0x6f/0xa0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522231][   T55]  io_schedule+0x3b/0x50
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522236][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522240][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522243][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522247][   T55]  wbt_wait+0xbf/0x180
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522251][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522258][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522267][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522271][   T55]  ext4_bio_write_page+0x2de/0x430
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522277][   T55]  mpage_process_page_bufs+0x197/0x1e0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522285][   T55]  mpage_prepare_extent_to_map+0x1fb/0x2e0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522293][   T55]  ext4_writepages+0x3a3/0xf80
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522300][   T55]  ? write_cache_pages+0x2e9/0x3b0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522307][   T55]  ? generic_writepages+0x54/0x80
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522313][   T55]  do_writepages+0xd8/0x200
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522320][   T55]  __writeback_single_inode+0x2c/0x120
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522327][   T55]  writeback_sb_inodes+0x3fa/0xb20
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522334][   T55]  ? move_expired_inodes+0xd0/0x1e0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522340][   T55]  __writeback_inodes_wb+0x8b/0x1c0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522346][   T55]  wb_writeback+0x15b/0x240
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522353][   T55]  wb_workfn+0x25b/0x400
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522359][   T55]  ? __switch_to+0x14f/0x440
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522366][   T55]  ? finish_task_switch+0xc0/0x280
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522371][   T55]  process_one_work+0x1ea/0x350
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522376][   T55]  worker_thread+0x26d/0x4b0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522381][   T55]  kthread+0x17a/0x190
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522387][   T55]  ? process_one_work+0x350/0x350
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522391][   T55]  ? kthread_unuse_mm+0x90/0x90
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522397][   T55]  ret_from_fork+0x1f/0x30
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522403][   T55]  </TASK>
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522481][   T55] INFO: task chrome:3106 blocked for more than 122 seconds.
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522486][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522490][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522492][   T55] task:chrome          state:D stack:    0 pid: 3106 ppid:  2584 flags:0x00004000
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522499][   T55] Call Trace:
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522500][   T55]  <TASK>
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522502][   T55]  __schedule+0x4ac/0x6d0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522507][   T55]  schedule+0x6f/0xa0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522510][   T55]  io_schedule+0x3b/0x50
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522514][   T55]  folio_wait_bit_common+0x1f5/0x2f0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522521][   T55]  ? try_to_release_page+0x70/0x70
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522526][   T55]  ? ext4_da_release_space+0xe0/0xe0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522532][   T55]  block_page_mkwrite+0x4e/0x1a0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522536][   T55]  ext4_page_mkwrite+0x366/0x800
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522542][   T55]  ? touch_atime+0xdf/0x170
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522548][   T55]  do_wp_page+0x16a/0x640
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522552][   T55]  handle_mm_fault+0xc0a/0x15c0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522555][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522563][   T55]  do_user_addr_fault+0x1f2/0x4d0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522570][   T55]  ? asm_exc_page_fault+0x8/0x30
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522577][   T55]  exc_page_fault+0x5a/0xa0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522581][   T55]  asm_exc_page_fault+0x1e/0x30
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522587][   T55] RIP: 0033:0x555f9539c0be
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522591][   T55] RSP: 002b:00007ffdf4c19890 EFLAGS: 00010206
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522595][   T55] RAX: 00007f222a3c1e60 RBX: 0000000000000000 RCX: 0000000000000001
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522599][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00003a10029a0340
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522601][   T55] RBP: 00007ffdf4c198c0 R08: 0000000000000010 R09: 0000555f9de53488
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522604][   T55] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522606][   T55] R13: 0000555f949ba8b1 R14: 0000000000000001 R15: 00003a10029a0340
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522610][   T55]  </TASK>
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522612][   T55] INFO: task Chrome_IOThread:3135 blocked for more than 122 seconds.
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522616][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522619][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522622][   T55] task:Chrome_IOThread state:D stack:    0 pid: 3135 ppid:  2584 flags:0x00004000
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522626][   T55] Call Trace:
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522627][   T55]  <TASK>
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522629][   T55]  __schedule+0x4ac/0x6d0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522633][   T55]  schedule+0x6f/0xa0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522637][   T55]  io_schedule+0x3b/0x50
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522640][   T55]  folio_wait_bit_common+0x1f5/0x2f0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522646][   T55]  ? try_to_release_page+0x70/0x70
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522650][   T55]  ? ext4_da_release_space+0xe0/0xe0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522656][   T55]  block_page_mkwrite+0x4e/0x1a0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522659][   T55]  ext4_page_mkwrite+0x366/0x800
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522665][   T55]  do_wp_page+0x16a/0x640
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522668][   T55]  handle_mm_fault+0xc0a/0x15c0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522672][   T55]  ? __sys_sendto+0x13e/0x180
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522677][   T55]  do_user_addr_fault+0x1f2/0x4d0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522683][   T55]  ? asm_exc_page_fault+0x8/0x30
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522689][   T55]  exc_page_fault+0x5a/0xa0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522692][   T55]  asm_exc_page_fault+0x1e/0x30
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522697][   T55] RIP: 0033:0x555f9539c0be
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522700][   T55] RSP: 002b:00007f22262c5af0 EFLAGS: 00010206
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522703][   T55] RAX: 00007f222a3c1e60 RBX: 0000000000000000 RCX: 0000000000000001
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522705][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00003a10029a0340
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522707][   T55] RBP: 00007f22262c5b20 R08: 0000000000000010 R09: 0000555f9de53488
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522709][   T55] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522711][   T55] R13: 0000555f949ba8b1 R14: 0000000000000001 R15: 00003a10029a0340
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522714][   T55]  </TASK>
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522735][   T55] INFO: task ThreadPoolForeg:9752 blocked for more than 122 seconds.
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522738][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522742][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522744][   T55] task:ThreadPoolForeg state:D stack:    0 pid: 9752 ppid:  3146 flags:0x00004000
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522748][   T55] Call Trace:
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522749][   T55]  <TASK>
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522750][   T55]  __schedule+0x4ac/0x6d0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522755][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522758][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522762][   T55]  schedule+0x6f/0xa0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522765][   T55]  io_schedule+0x3b/0x50
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522769][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522772][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522775][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522779][   T55]  wbt_wait+0xbf/0x180
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522782][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522789][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522793][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522797][   T55]  ext4_io_submit+0x43/0x50
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522802][   T55]  ext4_writepages+0xa28/0xf80
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522810][   T55]  do_writepages+0xd8/0x200
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522816][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522822][   T55]  file_write_and_wait_range+0x12c/0x150
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522828][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522833][   T55]  ext4_sync_file+0x5b/0x250
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522838][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522842][   T55]  __x64_sys_fdatasync+0x43/0x70
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522846][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522853][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522860][   T55] RIP: 0033:0x7fa9c33bf1fb
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522862][   T55] RSP: 002b:00007fa9be7b7920 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522866][   T55] RAX: ffffffffffffffda RBX: 000015ac00ae2300 RCX: 00007fa9c33bf1fb
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522869][   T55] RDX: 0000000000000002 RSI: 0000000000000002 RDI: 0000000000000028
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522871][   T55] RBP: 00007fa9be7b7970 R08: 0000000000000000 R09: 0000556917d94248
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522873][   T55] R10: 0000000000008400 R11: 0000000000000293 R12: 000015ac01342300
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522876][   T55] R13: 0000000000000000 R14: 0000000000008400 R15: 0000000000001000
Nov 23 15:15:18 xps-7390 kernel: [ 3687.522879][   T55]  </TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401678][   T55] INFO: task kworker/u16:1:68 blocked for more than 245 seconds.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401692][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401697][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401700][   T55] task:kworker/u16:1   state:D stack:    0 pid:   68 ppid:     2 flags:0x00004000
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401709][   T55] Workqueue: writeback wb_workfn (flush-259:0)
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401720][   T55] Call Trace:
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401722][   T55]  <TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401725][   T55]  __schedule+0x4ac/0x6d0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401734][   T55]  ? blk_flush_plug+0xcb/0x100
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401740][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401744][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401748][   T55]  schedule+0x6f/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401752][   T55]  io_schedule+0x3b/0x50
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401757][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401760][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401763][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401765][   T55]  wbt_wait+0xbf/0x180
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401768][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401774][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401777][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401781][   T55]  ext4_bio_write_page+0x2de/0x430
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401786][   T55]  mpage_process_page_bufs+0x197/0x1e0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401792][   T55]  mpage_prepare_extent_to_map+0x1fb/0x2e0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401797][   T55]  ext4_writepages+0x3a3/0xf80
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401803][   T55]  ? write_cache_pages+0x2e9/0x3b0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401808][   T55]  ? generic_writepages+0x54/0x80
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401813][   T55]  do_writepages+0xd8/0x200
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401818][   T55]  __writeback_single_inode+0x2c/0x120
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401824][   T55]  writeback_sb_inodes+0x3fa/0xb20
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401829][   T55]  ? move_expired_inodes+0xd0/0x1e0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401834][   T55]  __writeback_inodes_wb+0x8b/0x1c0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401839][   T55]  wb_writeback+0x15b/0x240
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401845][   T55]  wb_workfn+0x25b/0x400
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401849][   T55]  ? __switch_to+0x14f/0x440
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401854][   T55]  ? finish_task_switch+0xc0/0x280
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401858][   T55]  process_one_work+0x1ea/0x350
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401862][   T55]  worker_thread+0x26d/0x4b0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401866][   T55]  kthread+0x17a/0x190
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401871][   T55]  ? process_one_work+0x350/0x350
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401874][   T55]  ? kthread_unuse_mm+0x90/0x90
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401879][   T55]  ret_from_fork+0x1f/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401883][   T55]  </TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401894][   T55] INFO: task jbd2/nvme0n1p3-:375 blocked for more than 122 seconds.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401898][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401901][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401903][   T55] task:jbd2/nvme0n1p3- state:D stack:    0 pid:  375 ppid:     2 flags:0x00004000
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401906][   T55] Call Trace:
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401907][   T55]  <TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401908][   T55]  __schedule+0x4ac/0x6d0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401912][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401914][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401917][   T55]  schedule+0x6f/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401920][   T55]  io_schedule+0x3b/0x50
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401923][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401925][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401927][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401929][   T55]  wbt_wait+0xbf/0x180
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401931][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401936][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401939][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401942][   T55]  ext4_io_submit+0x43/0x50
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401946][   T55]  ext4_writepage+0x178/0x700
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401951][   T55]  ? folio_mkclean+0x5c/0x110
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401956][   T55]  __writepage+0xe/0x60
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401961][   T55]  write_cache_pages+0x21a/0x3b0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401966][   T55]  ? generic_writepages+0x80/0x80
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401972][   T55]  ? __slab_free+0x64/0x270
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401978][   T55]  ? enqueue_task_fair+0xb5/0x4f0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401984][   T55]  generic_writepages+0x4a/0x80
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401990][   T55]  jbd2_journal_submit_inode_data_buffers+0x5b/0x80
Nov 23 15:17:20 xps-7390 kernel: [ 3810.401996][   T55]  ext4_journal_submit_inode_data_buffers+0x2b/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402001][   T55]  jbd2_journal_commit_transaction+0x4dc/0x1680
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402006][   T55]  ? __schedule+0x4b4/0x6d0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402009][   T55]  kjournald2+0xa8/0x250
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402014][   T55]  ? init_wait_entry+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402018][   T55]  kthread+0x17a/0x190
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402023][   T55]  ? jbd2_seq_info_show+0x270/0x270
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402028][   T55]  ? kthread_unuse_mm+0x90/0x90
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402032][   T55]  ret_from_fork+0x1f/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402035][   T55]  </TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402037][   T55] INFO: task systemd-journal:426 blocked for more than 122 seconds.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402040][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402042][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402044][   T55] task:systemd-journal state:D stack:    0 pid:  426 ppid:     1 flags:0x00004000
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402046][   T55] Call Trace:
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402047][   T55]  <TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402048][   T55]  __schedule+0x4ac/0x6d0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402051][   T55]  ? free_unref_page_list+0x1d2/0x240
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402054][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402057][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402059][   T55]  schedule+0x6f/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402062][   T55]  io_schedule+0x3b/0x50
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402064][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402066][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402068][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402070][   T55]  wbt_wait+0xbf/0x180
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402073][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402077][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402081][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402084][   T55]  ext4_io_submit+0x43/0x50
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402087][   T55]  ext4_writepages+0x3bc/0xf80
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402092][   T55]  ? lock_page_memcg+0x1b/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402098][   T55]  ? fault_dirty_shared_page+0xa9/0xd0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402100][   T55]  do_writepages+0xd8/0x200
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402105][   T55]  ? __seccomp_filter+0x115/0x700
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402109][   T55]  file_write_and_wait_range+0x12c/0x150
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402113][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402117][   T55]  ext4_sync_file+0x5b/0x250
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402121][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402124][   T55]  __x64_sys_fsync+0x68/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402127][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402132][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402139][   T55] RIP: 0033:0x7f197044f13b
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402142][   T55] RSP: 002b:00007ffc5df794e0 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402146][   T55] RAX: ffffffffffffffda RBX: 000055a776f6c4d0 RCX: 00007f197044f13b
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402148][   T55] RDX: 0000000000000002 RSI: 000055a776f89d90 RDI: 0000000000000030
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402150][   T55] RBP: 0000000000000001 R08: 0000000000000000 R09: 00007ffc5df79628
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402152][   T55] R10: 00007f1970797ab0 R11: 0000000000000293 R12: 000055a776f6c4d0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402154][   T55] R13: 00007ffc5df79620 R14: 0000000000000000 R15: 00007ffc5df79620
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402156][   T55]  </TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402158][   T55] INFO: task journal-offline:9968 blocked for more than 122 seconds.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402161][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402163][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402164][   T55] task:journal-offline state:D stack:    0 pid: 9968 ppid:     1 flags:0x00004000
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402167][   T55] Call Trace:
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402168][   T55]  <TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402169][   T55]  __schedule+0x4ac/0x6d0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402172][   T55]  schedule+0x6f/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402175][   T55]  jbd2_log_wait_commit+0xe2/0x120
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402180][   T55]  ? init_wait_entry+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402184][   T55]  ext4_fc_commit+0xe7/0xd00
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402187][   T55]  ? __seccomp_filter+0x115/0x700
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402190][   T55]  ? file_write_and_wait_range+0xb9/0x150
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402194][   T55]  ext4_sync_file+0xc9/0x250
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402198][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402201][   T55]  __x64_sys_fsync+0x68/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402203][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402207][   T55]  ? syscall_exit_to_user_mode+0x24/0x100
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402210][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402215][   T55] RIP: 0033:0x7f197044f13b
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402217][   T55] RSP: 002b:00007f196d778bd0 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402219][   T55] RAX: ffffffffffffffda RBX: 000055a776f68cb0 RCX: 00007f197044f13b
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402221][   T55] RDX: 0000000000000002 RSI: 00007f1970793e6e RDI: 0000000000000014
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402222][   T55] RBP: 00007f1970796950 R08: 0000000000000000 R09: 00007f196d779640
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402223][   T55] R10: 000000000000000e R11: 0000000000000293 R12: 0000000000000002
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402225][   T55] R13: 00007ffc5df79f0f R14: 0000000000000000 R15: 00007f196d779640
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402227][   T55]  </TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402234][   T55] INFO: task cupsd:1566 blocked for more than 122 seconds.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402237][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402240][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402242][   T55] task:cupsd           state:D stack:    0 pid: 1566 ppid:     1 flags:0x00004000
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402246][   T55] Call Trace:
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402247][   T55]  <TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402249][   T55]  __schedule+0x4ac/0x6d0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402253][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402257][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402261][   T55]  schedule+0x6f/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402263][   T55]  io_schedule+0x3b/0x50
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402266][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402268][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402270][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402272][   T55]  wbt_wait+0xbf/0x180
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402275][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402280][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402282][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402285][   T55]  ext4_io_submit+0x43/0x50
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402288][   T55]  ext4_writepages+0xa28/0xf80
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402294][   T55]  ? ext4_buffered_write_iter+0x10e/0x160
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402298][   T55]  do_writepages+0xd8/0x200
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402302][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402308][   T55]  file_write_and_wait_range+0x12c/0x150
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402311][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402315][   T55]  ext4_sync_file+0x5b/0x250
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402318][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402321][   T55]  __x64_sys_fsync+0x68/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402323][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402328][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402332][   T55] RIP: 0033:0x7fe0d9e0e097
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402334][   T55] RSP: 002b:00007ffd2ac29578 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402336][   T55] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe0d9e0e097
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402337][   T55] RDX: 00000000000001f8 RSI: 000055bb1fa72358 RDI: 000000000000000f
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402339][   T55] RBP: 000055bb1fa72350 R08: 0000000000000000 R09: 00007ffd2ac29c20
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402340][   T55] R10: 0000000000000001 R11: 0000000000000246 R12: 00007ffd2ac29e10
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402342][   T55] R13: 000055bb1dcc45d8 R14: 000055bb1dcadd54 R15: 0000000000000000
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402344][   T55]  </TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402345][   T55] INFO: task NetworkManager:1568 blocked for more than 122 seconds.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402347][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402349][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402351][   T55] task:NetworkManager  state:D stack:    0 pid: 1568 ppid:     1 flags:0x00004000
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402354][   T55] Call Trace:
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402354][   T55]  <TASK>
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402355][   T55]  __schedule+0x4ac/0x6d0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402358][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402360][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402363][   T55]  schedule+0x6f/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402365][   T55]  io_schedule+0x3b/0x50
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402368][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402370][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402373][   T55]  ? wbt_exit+0x30/0x30
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402376][   T55]  wbt_wait+0xbf/0x180
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402379][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402385][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402418][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402422][   T55]  ext4_io_submit+0x43/0x50
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402426][   T55]  ext4_writepages+0xa28/0xf80
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402432][   T55]  ? ext4_buffered_write_iter+0x10e/0x160
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402436][   T55]  do_writepages+0xd8/0x200
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402440][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402446][   T55]  file_write_and_wait_range+0x12c/0x150
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402449][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402452][   T55]  ext4_sync_file+0x5b/0x250
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402456][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402459][   T55]  __x64_sys_fsync+0x68/0xa0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402462][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402466][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402471][   T55] RIP: 0033:0x7fabbbf9c0bb
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402472][   T55] RSP: 002b:00007ffd5eb648b0 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402474][   T55] RAX: ffffffffffffffda RBX: 00007fabbaa23930 RCX: 00007fabbbf9c0bb
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402476][   T55] RDX: 0000000000000002 RSI: 00005581014f2400 RDI: 000000000000001d
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402477][   T55] RBP: 000000000000001d R08: 0000000000000000 R09: 00007ffd5eb649c0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402479][   T55] R10: 0000000000009d75 R11: 0000000000000293 R12: 00007ffd5eb649c0
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402480][   T55] R13: 0000558101451b70 R14: 00005581014fc175 R15: 0000000000000000
Nov 23 15:17:20 xps-7390 kernel: [ 3810.402482][   T55]  </TASK>
----

On Tue, 23 Nov 2021, Kenneth R. Crudup wrote:

>
> (Please forgive the SPAMmy nature of the To: list; I'm not exactly sure whose
> subsystem this issue belongs to, so please trim as appropriate).
>
> I've got a Kioxia NVMe SSD on my Dell XPS-7390 2-in-1 running an i7-1065G7 CPU
> with 32GB RAM.  If you need more info (and I suspect so), please let me know.
>
> I'm sorry I don't have a better description of the problem, but I run Linus'
> master branch (and sometimes I weed out problems like this). I'm current as of
> his commit 1360572566 (the 5.16-rc2 tag).
>
> For about two weeks now every now and then my block/NVMe/...? subsystem comes to
> a total halt on writes, and I get a system that can no longer issue writes
> (reads/pageins still seem to work) until I reboot. SysRq-S/U/B still leaves a
> dirty ext4 filesystem requring recovery on reboot.
>
> It happens at random- twice today as a matter of fact- and there doesn't seem to
> be any particular action that causes it:
>
> ----
> Nov 23 12:39:57 xps-7390 kernel: [13641.000227][   T55] INFO: task jbd2/nvme0n1p3-:375 blocked for more than 122 seconds.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000241][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
> Nov 23 12:39:57 xps-7390 kernel: [13641.000245][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000247][   T55] task:jbd2/nvme0n1p3- state:D stack:    0 pid:  375 ppid:     2 flags:0x00004000
> Nov 23 12:39:57 xps-7390 kernel: [13641.000254][   T55] Call Trace:
> Nov 23 12:39:57 xps-7390 kernel: [13641.000257][   T55]  <TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000259][   T55]  __schedule+0x4ac/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000268][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000272][   T55]  ? wbt_inflight_cb+0xa0/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000275][   T55]  schedule+0x6f/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000278][   T55]  io_schedule+0x3b/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.000282][   T55]  rq_qos_wait+0xe5/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.000285][   T55]  ? rq_qos_wait+0x130/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.000287][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000290][   T55]  wbt_wait+0xbf/0x180
> Nov 23 12:39:57 xps-7390 kernel: [13641.000293][   T55]  __rq_qos_throttle+0x2c/0x40
> Nov 23 12:39:57 xps-7390 kernel: [13641.000299][   T55]  blk_mq_submit_bio+0x1b8/0x620
> Nov 23 12:39:57 xps-7390 kernel: [13641.000303][   T55]  submit_bio_noacct+0x24c/0x2a0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000306][   T55]  ext4_io_submit+0x43/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.000312][   T55]  ext4_writepage+0x178/0x700
> Nov 23 12:39:57 xps-7390 kernel: [13641.000317][   T55]  ? folio_mkclean+0x5c/0x110
> Nov 23 12:39:57 xps-7390 kernel: [13641.000323][   T55]  __writepage+0xe/0x60
> Nov 23 12:39:57 xps-7390 kernel: [13641.000329][   T55]  write_cache_pages+0x21a/0x3b0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000334][   T55]  ? generic_writepages+0x80/0x80
> Nov 23 12:39:57 xps-7390 kernel: [13641.000339][   T55]  generic_writepages+0x4a/0x80
> Nov 23 12:39:57 xps-7390 kernel: [13641.000344][   T55]  jbd2_journal_submit_inode_data_buffers+0x5b/0x80
> Nov 23 12:39:57 xps-7390 kernel: [13641.000349][   T55]  ext4_journal_submit_inode_data_buffers+0x2b/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000355][   T55]  jbd2_journal_commit_transaction+0x4dc/0x1680
> Nov 23 12:39:57 xps-7390 kernel: [13641.000360][   T55]  ? __schedule+0x4b4/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000363][   T55]  kjournald2+0xa8/0x250
> Nov 23 12:39:57 xps-7390 kernel: [13641.000368][   T55]  ? init_wait_entry+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000374][   T55]  kthread+0x17a/0x190
> Nov 23 12:39:57 xps-7390 kernel: [13641.000380][   T55]  ? jbd2_seq_info_show+0x270/0x270
> Nov 23 12:39:57 xps-7390 kernel: [13641.000385][   T55]  ? kthread_unuse_mm+0x90/0x90
> Nov 23 12:39:57 xps-7390 kernel: [13641.000390][   T55]  ret_from_fork+0x1f/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000394][   T55]  </TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000404][   T55] INFO: task NetworkManager:1435 blocked for more than 122 seconds.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000408][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
> Nov 23 12:39:57 xps-7390 kernel: [13641.000411][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000412][   T55] task:NetworkManager  state:D stack:    0 pid: 1435 ppid:     1 flags:0x00004000
> Nov 23 12:39:57 xps-7390 kernel: [13641.000417][   T55] Call Trace:
> Nov 23 12:39:57 xps-7390 kernel: [13641.000417][   T55]  <TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000419][   T55]  __schedule+0x4ac/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000422][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000426][   T55]  ? wbt_inflight_cb+0xa0/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000428][   T55]  schedule+0x6f/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000431][   T55]  io_schedule+0x3b/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.000435][   T55]  rq_qos_wait+0xe5/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.000437][   T55]  ? rq_qos_wait+0x130/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.000439][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000442][   T55]  wbt_wait+0xbf/0x180
> Nov 23 12:39:57 xps-7390 kernel: [13641.000444][   T55]  __rq_qos_throttle+0x2c/0x40
> Nov 23 12:39:57 xps-7390 kernel: [13641.000450][   T55]  blk_mq_submit_bio+0x1b8/0x620
> Nov 23 12:39:57 xps-7390 kernel: [13641.000453][   T55]  submit_bio_noacct+0x24c/0x2a0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000457][   T55]  ext4_io_submit+0x43/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.000461][   T55]  ext4_writepages+0xa28/0xf80
> Nov 23 12:39:57 xps-7390 kernel: [13641.000467][   T55]  ? ext4_buffered_write_iter+0x10e/0x160
> Nov 23 12:39:57 xps-7390 kernel: [13641.000471][   T55]  do_writepages+0xd8/0x200
> Nov 23 12:39:57 xps-7390 kernel: [13641.000477][   T55]  ? apparmor_file_permission+0xc5/0x120
> Nov 23 12:39:57 xps-7390 kernel: [13641.000483][   T55]  file_write_and_wait_range+0x12c/0x150
> Nov 23 12:39:57 xps-7390 kernel: [13641.000487][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.000492][   T55]  ext4_sync_file+0x5b/0x250
> Nov 23 12:39:57 xps-7390 kernel: [13641.000496][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.000500][   T55]  __x64_sys_fsync+0x68/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000503][   T55]  do_syscall_64+0x3e/0xb0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000509][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Nov 23 12:39:57 xps-7390 kernel: [13641.000516][   T55] RIP: 0033:0x7f397c57a0bb
> Nov 23 12:39:57 xps-7390 kernel: [13641.000518][   T55] RSP: 002b:00007ffd776a00f0 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
> Nov 23 12:39:57 xps-7390 kernel: [13641.000522][   T55] RAX: ffffffffffffffda RBX: 00007f397b001930 RCX: 00007f397c57a0bb
> Nov 23 12:39:57 xps-7390 kernel: [13641.000525][   T55] RDX: 0000000000000002 RSI: 000055d897d01000 RDI: 000000000000001d
> Nov 23 12:39:57 xps-7390 kernel: [13641.000527][   T55] RBP: 000000000000001d R08: 0000000000000000 R09: 00007ffd776a0200
> Nov 23 12:39:57 xps-7390 kernel: [13641.000528][   T55] R10: 0000000000009d75 R11: 0000000000000293 R12: 00007ffd776a0200
> Nov 23 12:39:57 xps-7390 kernel: [13641.000530][   T55] R13: 000055d897be13c0 R14: 000055d897d0ad75 R15: 0000000000000000
> Nov 23 12:39:57 xps-7390 kernel: [13641.000533][   T55]  </TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000596][   T55] INFO: task METRICS_SINK_RU:2806 blocked for more than 122 seconds.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000601][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
> Nov 23 12:39:57 xps-7390 kernel: [13641.000603][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000605][   T55] task:METRICS_SINK_RU state:D stack:    0 pid: 2806 ppid:     1 flags:0x00004000
> Nov 23 12:39:57 xps-7390 kernel: [13641.000609][   T55] Call Trace:
> Nov 23 12:39:57 xps-7390 kernel: [13641.000610][   T55]  <TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000612][   T55]  __schedule+0x4ac/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000616][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000619][   T55]  ? wbt_inflight_cb+0xa0/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000622][   T55]  schedule+0x6f/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000624][   T55]  io_schedule+0x3b/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.000628][   T55]  rq_qos_wait+0xe5/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.000630][   T55]  ? rq_qos_wait+0x130/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.000633][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000635][   T55]  wbt_wait+0xbf/0x180
> Nov 23 12:39:57 xps-7390 kernel: [13641.000638][   T55]  __rq_qos_throttle+0x2c/0x40
> Nov 23 12:39:57 xps-7390 kernel: [13641.000645][   T55]  blk_mq_submit_bio+0x1b8/0x620
> Nov 23 12:39:57 xps-7390 kernel: [13641.000648][   T55]  submit_bio_noacct+0x24c/0x2a0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000655][   T55]  ext4_io_submit+0x43/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.000659][   T55]  ext4_writepages+0xa28/0xf80
> Nov 23 12:39:57 xps-7390 kernel: [13641.000665][   T55]  ? generic_perform_write+0x17a/0x210
> Nov 23 12:39:57 xps-7390 kernel: [13641.000671][   T55]  do_writepages+0xd8/0x200
> Nov 23 12:39:57 xps-7390 kernel: [13641.000676][   T55]  ? ext4_file_write_iter+0x2c6/0x870
> Nov 23 12:39:57 xps-7390 kernel: [13641.000681][   T55]  filemap_flush+0x6c/0x90
> Nov 23 12:39:57 xps-7390 kernel: [13641.000685][   T55]  ext4_release_file+0x20/0xc0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000691][   T55]  __fput+0xec/0x210
> Nov 23 12:39:57 xps-7390 kernel: [13641.000697][   T55]  task_work_run+0x69/0xb0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000703][   T55]  exit_to_user_mode_prepare+0xd6/0x120
> Nov 23 12:39:57 xps-7390 kernel: [13641.000710][   T55]  syscall_exit_to_user_mode+0x24/0x100
> Nov 23 12:39:57 xps-7390 kernel: [13641.000714][   T55]  do_syscall_64+0x4e/0xb0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000720][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Nov 23 12:39:57 xps-7390 kernel: [13641.000726][   T55] RIP: 0033:0x7febd5adebdb
> Nov 23 12:39:57 xps-7390 kernel: [13641.000728][   T55] RSP: 002b:00007feb64bf5de0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> Nov 23 12:39:57 xps-7390 kernel: [13641.000731][   T55] RAX: 0000000000000000 RBX: 000000000000002c RCX: 00007febd5adebdb
> Nov 23 12:39:57 xps-7390 kernel: [13641.000734][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 000000000000002c
> Nov 23 12:39:57 xps-7390 kernel: [13641.000735][   T55] RBP: 00007feb64bf66d0 R08: 0000000000000000 R09: 0000000000008000
> Nov 23 12:39:57 xps-7390 kernel: [13641.000737][   T55] R10: 0000000000000000 R11: 0000000000000293 R12: 00007feb64bf7070
> Nov 23 12:39:57 xps-7390 kernel: [13641.000739][   T55] R13: 0000000000000000 R14: 00007feb64bf5ea0 R15: 00007feb64bf6200
> Nov 23 12:39:57 xps-7390 kernel: [13641.000741][   T55]  </TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000762][   T55] INFO: task ThreadPoolForeg:20339 blocked for more than 122 seconds.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000766][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
> Nov 23 12:39:57 xps-7390 kernel: [13641.000769][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000770][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20339 ppid:  2427 flags:0x00004000
> Nov 23 12:39:57 xps-7390 kernel: [13641.000774][   T55] Call Trace:
> Nov 23 12:39:57 xps-7390 kernel: [13641.000776][   T55]  <TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000778][   T55]  __schedule+0x4ac/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000782][   T55]  schedule+0x6f/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000785][   T55]  jbd2_log_wait_commit+0xe2/0x120
> Nov 23 12:39:57 xps-7390 kernel: [13641.000791][   T55]  ? init_wait_entry+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000797][   T55]  ext4_fc_commit+0xe7/0xd00
> Nov 23 12:39:57 xps-7390 kernel: [13641.000800][   T55]  ? apparmor_file_permission+0xc5/0x120
> Nov 23 12:39:57 xps-7390 kernel: [13641.000806][   T55]  ? file_write_and_wait_range+0xb9/0x150
> Nov 23 12:39:57 xps-7390 kernel: [13641.000811][   T55]  ext4_sync_file+0xc9/0x250
> Nov 23 12:39:57 xps-7390 kernel: [13641.000815][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.000819][   T55]  __x64_sys_fdatasync+0x43/0x70
> Nov 23 12:39:57 xps-7390 kernel: [13641.000823][   T55]  do_syscall_64+0x3e/0xb0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000827][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Nov 23 12:39:57 xps-7390 kernel: [13641.000833][   T55] RIP: 0033:0x7fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.000835][   T55] RSP: 002b:00007fa507107980 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> Nov 23 12:39:57 xps-7390 kernel: [13641.000837][   T55] RAX: ffffffffffffffda RBX: 000034960a063f80 RCX: 00007fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.000840][   T55] RDX: 0000000000000002 RSI: 0000000000000002 RDI: 0000000000000176
> Nov 23 12:39:57 xps-7390 kernel: [13641.000842][   T55] RBP: 00007fa5071079d0 R08: 0000000000000000 R09: 0000564a51add248
> Nov 23 12:39:57 xps-7390 kernel: [13641.000844][   T55] R10: 0000000000002400 R11: 0000000000000293 R12: 0000349609b25000
> Nov 23 12:39:57 xps-7390 kernel: [13641.000848][   T55] R13: 0000000000000000 R14: 0000000000002400 R15: 0000000000001000
> Nov 23 12:39:57 xps-7390 kernel: [13641.000851][   T55]  </TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000853][   T55] INFO: task ThreadPoolForeg:20715 blocked for more than 122 seconds.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000858][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
> Nov 23 12:39:57 xps-7390 kernel: [13641.000861][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000871][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20715 ppid:  2427 flags:0x00004000
> Nov 23 12:39:57 xps-7390 kernel: [13641.000874][   T55] Call Trace:
> Nov 23 12:39:57 xps-7390 kernel: [13641.000875][   T55]  <TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000876][   T55]  __schedule+0x4ac/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000879][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000882][   T55]  ? wbt_inflight_cb+0xa0/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000885][   T55]  schedule+0x6f/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000888][   T55]  io_schedule+0x3b/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.000891][   T55]  rq_qos_wait+0xe5/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.000893][   T55]  ? rq_qos_wait+0x130/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.000895][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.000898][   T55]  wbt_wait+0xbf/0x180
> Nov 23 12:39:57 xps-7390 kernel: [13641.000900][   T55]  __rq_qos_throttle+0x2c/0x40
> Nov 23 12:39:57 xps-7390 kernel: [13641.000906][   T55]  blk_mq_submit_bio+0x1b8/0x620
> Nov 23 12:39:57 xps-7390 kernel: [13641.000909][   T55]  submit_bio_noacct+0x24c/0x2a0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000912][   T55]  ext4_io_submit+0x43/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.000916][   T55]  ext4_writepages+0xa28/0xf80
> Nov 23 12:39:57 xps-7390 kernel: [13641.000923][   T55]  do_writepages+0xd8/0x200
> Nov 23 12:39:57 xps-7390 kernel: [13641.000929][   T55]  ? apparmor_file_permission+0xc5/0x120
> Nov 23 12:39:57 xps-7390 kernel: [13641.000935][   T55]  file_write_and_wait_range+0x12c/0x150
> Nov 23 12:39:57 xps-7390 kernel: [13641.000938][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.000942][   T55]  ext4_sync_file+0x5b/0x250
> Nov 23 12:39:57 xps-7390 kernel: [13641.000946][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.000949][   T55]  __x64_sys_fdatasync+0x43/0x70
> Nov 23 12:39:57 xps-7390 kernel: [13641.000952][   T55]  do_syscall_64+0x3e/0xb0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000957][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Nov 23 12:39:57 xps-7390 kernel: [13641.000963][   T55] RIP: 0033:0x7fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.000965][   T55] RSP: 002b:00007fa50144dd00 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> Nov 23 12:39:57 xps-7390 kernel: [13641.000968][   T55] RAX: ffffffffffffffda RBX: 00007fa50144dd60 RCX: 00007fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.000971][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000000001ea
> Nov 23 12:39:57 xps-7390 kernel: [13641.000973][   T55] RBP: 00007fa50144dde0 R08: 0000000000000000 R09: 00007ffc2fa540b8
> Nov 23 12:39:57 xps-7390 kernel: [13641.000975][   T55] R10: 0000000001568a98 R11: 0000000000000293 R12: aaaaaaaaaaaaaaaa
> Nov 23 12:39:57 xps-7390 kernel: [13641.000978][   T55] R13: 000034960c9d6549 R14: 00007fa50144dee0 R15: 0000564a52608ea0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000981][   T55]  </TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000982][   T55] INFO: task ThreadPoolForeg:20716 blocked for more than 122 seconds.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000985][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
> Nov 23 12:39:57 xps-7390 kernel: [13641.000987][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 23 12:39:57 xps-7390 kernel: [13641.000989][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20716 ppid:  2427 flags:0x00004000
> Nov 23 12:39:57 xps-7390 kernel: [13641.000992][   T55] Call Trace:
> Nov 23 12:39:57 xps-7390 kernel: [13641.000993][   T55]  <TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.000994][   T55]  __schedule+0x4ac/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.000997][   T55]  ? kmem_cache_alloc+0x153/0x240
> Nov 23 12:39:57 xps-7390 kernel: [13641.001003][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001005][   T55]  ? wbt_inflight_cb+0xa0/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001008][   T55]  schedule+0x6f/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001011][   T55]  io_schedule+0x3b/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.001013][   T55]  rq_qos_wait+0xe5/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.001015][   T55]  ? rq_qos_wait+0x130/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.001017][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001020][   T55]  wbt_wait+0xbf/0x180
> Nov 23 12:39:57 xps-7390 kernel: [13641.001022][   T55]  __rq_qos_throttle+0x2c/0x40
> Nov 23 12:39:57 xps-7390 kernel: [13641.001028][   T55]  blk_mq_submit_bio+0x1b8/0x620
> Nov 23 12:39:57 xps-7390 kernel: [13641.001031][   T55]  submit_bio_noacct+0x24c/0x2a0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001033][   T55]  ext4_io_submit+0x43/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.001037][   T55]  ext4_writepages+0x3bc/0xf80
> Nov 23 12:39:57 xps-7390 kernel: [13641.001043][   T55]  ? ext4_buffered_write_iter+0x10e/0x160
> Nov 23 12:39:57 xps-7390 kernel: [13641.001047][   T55]  do_writepages+0xd8/0x200
> Nov 23 12:39:57 xps-7390 kernel: [13641.001053][   T55]  ? apparmor_file_permission+0xc5/0x120
> Nov 23 12:39:57 xps-7390 kernel: [13641.001059][   T55]  file_write_and_wait_range+0x12c/0x150
> Nov 23 12:39:57 xps-7390 kernel: [13641.001062][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.001066][   T55]  ext4_sync_file+0x5b/0x250
> Nov 23 12:39:57 xps-7390 kernel: [13641.001069][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.001073][   T55]  __x64_sys_fdatasync+0x43/0x70
> Nov 23 12:39:57 xps-7390 kernel: [13641.001075][   T55]  do_syscall_64+0x3e/0xb0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001080][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Nov 23 12:39:57 xps-7390 kernel: [13641.001085][   T55] RIP: 0033:0x7fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.001087][   T55] RSP: 002b:00007fa507908e50 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> Nov 23 12:39:57 xps-7390 kernel: [13641.001089][   T55] RAX: ffffffffffffffda RBX: 00007fa507908eb0 RCX: 00007fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.001090][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000000000b8
> Nov 23 12:39:57 xps-7390 kernel: [13641.001092][   T55] RBP: 00007fa507908f30 R08: 0000000000000000 R09: 00007ffc2fa540b8
> Nov 23 12:39:57 xps-7390 kernel: [13641.001093][   T55] R10: 00000000015651fc R11: 0000000000000293 R12: aaaaaaaaaaaaaaaa
> Nov 23 12:39:57 xps-7390 kernel: [13641.001095][   T55] R13: 00003496090fa400 R14: 00003496090fa400 R15: 0000564a52608ea0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001097][   T55]  </TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.001098][   T55] INFO: task ThreadPoolForeg:20816 blocked for more than 122 seconds.
> Nov 23 12:39:57 xps-7390 kernel: [13641.001101][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
> Nov 23 12:39:57 xps-7390 kernel: [13641.001103][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 23 12:39:57 xps-7390 kernel: [13641.001104][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20816 ppid:  2427 flags:0x00004000
> Nov 23 12:39:57 xps-7390 kernel: [13641.001107][   T55] Call Trace:
> Nov 23 12:39:57 xps-7390 kernel: [13641.001108][   T55]  <TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.001109][   T55]  __schedule+0x4ac/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001112][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001115][   T55]  ? wbt_inflight_cb+0xa0/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001117][   T55]  schedule+0x6f/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001120][   T55]  io_schedule+0x3b/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.001123][   T55]  rq_qos_wait+0xe5/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.001125][   T55]  ? rq_qos_wait+0x130/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.001127][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001129][   T55]  wbt_wait+0xbf/0x180
> Nov 23 12:39:57 xps-7390 kernel: [13641.001132][   T55]  __rq_qos_throttle+0x2c/0x40
> Nov 23 12:39:57 xps-7390 kernel: [13641.001137][   T55]  blk_mq_submit_bio+0x1b8/0x620
> Nov 23 12:39:57 xps-7390 kernel: [13641.001140][   T55]  submit_bio_noacct+0x24c/0x2a0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001143][   T55]  ext4_io_submit+0x43/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.001146][   T55]  ext4_writepages+0xa28/0xf80
> Nov 23 12:39:57 xps-7390 kernel: [13641.001153][   T55]  ? hrtimer_cancel+0x15/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001156][   T55]  ? futex_wait+0x20c/0x250
> Nov 23 12:39:57 xps-7390 kernel: [13641.001161][   T55]  do_writepages+0xd8/0x200
> Nov 23 12:39:57 xps-7390 kernel: [13641.001166][   T55]  ? apparmor_file_permission+0xc5/0x120
> Nov 23 12:39:57 xps-7390 kernel: [13641.001172][   T55]  file_write_and_wait_range+0x12c/0x150
> Nov 23 12:39:57 xps-7390 kernel: [13641.001175][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.001190][   T55]  ext4_sync_file+0x5b/0x250
> Nov 23 12:39:57 xps-7390 kernel: [13641.001194][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.001198][   T55]  __x64_sys_fdatasync+0x43/0x70
> Nov 23 12:39:57 xps-7390 kernel: [13641.001201][   T55]  do_syscall_64+0x3e/0xb0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001206][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Nov 23 12:39:57 xps-7390 kernel: [13641.001212][   T55] RIP: 0033:0x7fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.001214][   T55] RSP: 002b:00007fa4fda57980 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> Nov 23 12:39:57 xps-7390 kernel: [13641.001216][   T55] RAX: ffffffffffffffda RBX: 0000349608f73200 RCX: 00007fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.001218][   T55] RDX: 0000000000000002 RSI: 0000000000000002 RDI: 0000000000000178
> Nov 23 12:39:57 xps-7390 kernel: [13641.001220][   T55] RBP: 00007fa4fda579d0 R08: 0000000000000000 R09: 0000564a51add248
> Nov 23 12:39:57 xps-7390 kernel: [13641.001221][   T55] R10: 0000000000002400 R11: 0000000000000293 R12: 0000349609b23e00
> Nov 23 12:39:57 xps-7390 kernel: [13641.001223][   T55] R13: 0000000000000000 R14: 0000000000002400 R15: 0000000000001000
> Nov 23 12:39:57 xps-7390 kernel: [13641.001225][   T55]  </TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.001226][   T55] INFO: task ThreadPoolForeg:20869 blocked for more than 122 seconds.
> Nov 23 12:39:57 xps-7390 kernel: [13641.001229][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
> Nov 23 12:39:57 xps-7390 kernel: [13641.001232][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 23 12:39:57 xps-7390 kernel: [13641.001234][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20869 ppid:  2427 flags:0x00004000
> Nov 23 12:39:57 xps-7390 kernel: [13641.001237][   T55] Call Trace:
> Nov 23 12:39:57 xps-7390 kernel: [13641.001238][   T55]  <TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.001239][   T55]  __schedule+0x4ac/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001242][   T55]  ? kmem_cache_alloc+0x153/0x240
> Nov 23 12:39:57 xps-7390 kernel: [13641.001246][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001249][   T55]  ? wbt_inflight_cb+0xa0/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001251][   T55]  schedule+0x6f/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001254][   T55]  io_schedule+0x3b/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.001257][   T55]  rq_qos_wait+0xe5/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.001260][   T55]  ? rq_qos_wait+0x130/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.001262][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001264][   T55]  wbt_wait+0xbf/0x180
> Nov 23 12:39:57 xps-7390 kernel: [13641.001267][   T55]  __rq_qos_throttle+0x2c/0x40
> Nov 23 12:39:57 xps-7390 kernel: [13641.001272][   T55]  blk_mq_submit_bio+0x1b8/0x620
> Nov 23 12:39:57 xps-7390 kernel: [13641.001275][   T55]  submit_bio_noacct+0x24c/0x2a0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001278][   T55]  ext4_io_submit+0x43/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.001282][   T55]  ext4_writepages+0x3bc/0xf80
> Nov 23 12:39:57 xps-7390 kernel: [13641.001288][   T55]  ? ext4_buffered_write_iter+0x10e/0x160
> Nov 23 12:39:57 xps-7390 kernel: [13641.001292][   T55]  do_writepages+0xd8/0x200
> Nov 23 12:39:57 xps-7390 kernel: [13641.001298][   T55]  ? apparmor_file_permission+0xc5/0x120
> Nov 23 12:39:57 xps-7390 kernel: [13641.001303][   T55]  file_write_and_wait_range+0x12c/0x150
> Nov 23 12:39:57 xps-7390 kernel: [13641.001308][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.001311][   T55]  ext4_sync_file+0x5b/0x250
> Nov 23 12:39:57 xps-7390 kernel: [13641.001315][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.001318][   T55]  __x64_sys_fdatasync+0x43/0x70
> Nov 23 12:39:57 xps-7390 kernel: [13641.001321][   T55]  do_syscall_64+0x3e/0xb0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001326][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Nov 23 12:39:57 xps-7390 kernel: [13641.001330][   T55] RIP: 0033:0x7fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.001332][   T55] RSP: 002b:00007fa504f02720 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> Nov 23 12:39:57 xps-7390 kernel: [13641.001335][   T55] RAX: ffffffffffffffda RBX: 00007fa504f02780 RCX: 00007fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.001336][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000000001cc
> Nov 23 12:39:57 xps-7390 kernel: [13641.001338][   T55] RBP: 00007fa504f02800 R08: 0000000000000000 R09: 00007ffc2fa540b8
> Nov 23 12:39:57 xps-7390 kernel: [13641.001340][   T55] R10: 00000000015743a0 R11: 0000000000000293 R12: aaaaaaaaaaaaaaaa
> Nov 23 12:39:57 xps-7390 kernel: [13641.001342][   T55] R13: 0000349609565e80 R14: 0000349609565ea0 R15: 0000564a52608ea0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001344][   T55]  </TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.001345][   T55] INFO: task ThreadPoolForeg:20878 blocked for more than 122 seconds.
> Nov 23 12:39:57 xps-7390 kernel: [13641.001348][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
> Nov 23 12:39:57 xps-7390 kernel: [13641.001350][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 23 12:39:57 xps-7390 kernel: [13641.001352][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20878 ppid:  2427 flags:0x00004000
> Nov 23 12:39:57 xps-7390 kernel: [13641.001354][   T55] Call Trace:
> Nov 23 12:39:57 xps-7390 kernel: [13641.001355][   T55]  <TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.001356][   T55]  __schedule+0x4ac/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001359][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001361][   T55]  ? wbt_inflight_cb+0xa0/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001363][   T55]  schedule+0x6f/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001366][   T55]  io_schedule+0x3b/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.001369][   T55]  rq_qos_wait+0xe5/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.001371][   T55]  ? rq_qos_wait+0x130/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.001373][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001375][   T55]  wbt_wait+0xbf/0x180
> Nov 23 12:39:57 xps-7390 kernel: [13641.001377][   T55]  __rq_qos_throttle+0x2c/0x40
> Nov 23 12:39:57 xps-7390 kernel: [13641.001384][   T55]  blk_mq_submit_bio+0x1b8/0x620
> Nov 23 12:39:57 xps-7390 kernel: [13641.001388][   T55]  submit_bio_noacct+0x24c/0x2a0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001392][   T55]  ext4_bio_write_page+0x2de/0x430
> Nov 23 12:39:57 xps-7390 kernel: [13641.001398][   T55]  ext4_writepages+0x90e/0xf80
> Nov 23 12:39:57 xps-7390 kernel: [13641.001406][   T55]  do_writepages+0xd8/0x200
> Nov 23 12:39:57 xps-7390 kernel: [13641.001412][   T55]  filemap_flush+0x6c/0x90
> Nov 23 12:39:57 xps-7390 kernel: [13641.001417][   T55]  ext4_rename2+0x670/0x1590
> Nov 23 12:39:57 xps-7390 kernel: [13641.001423][   T55]  ? inode_permission+0x29/0x170
> Nov 23 12:39:57 xps-7390 kernel: [13641.001429][   T55]  vfs_rename+0x4ff/0x670
> Nov 23 12:39:57 xps-7390 kernel: [13641.001434][   T55]  do_renameat2+0x487/0x6f0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001440][   T55]  __x64_sys_rename+0x3b/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.001445][   T55]  do_syscall_64+0x3e/0xb0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001451][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Nov 23 12:39:57 xps-7390 kernel: [13641.001458][   T55] RIP: 0033:0x7fa51fdecfcb
> Nov 23 12:39:57 xps-7390 kernel: [13641.001461][   T55] RSP: 002b:00007fa504701c88 EFLAGS: 00000282 ORIG_RAX: 0000000000000052
> Nov 23 12:39:57 xps-7390 kernel: [13641.001464][   T55] RAX: ffffffffffffffda RBX: 00007fa504701db0 RCX: 00007fa51fdecfcb
> Nov 23 12:39:57 xps-7390 kernel: [13641.001465][   T55] RDX: 0000000000004000 RSI: 000034961bfe4400 RDI: 0000349605ae5e60
> Nov 23 12:39:57 xps-7390 kernel: [13641.001468][   T55] RBP: 00007fa504701e30 R08: 000034961a69a003 R09: 00007ffc2fa540b8
> Nov 23 12:39:57 xps-7390 kernel: [13641.001470][   T55] R10: 000000000157d910 R11: 0000000000000282 R12: 0000349606911e08
> Nov 23 12:39:57 xps-7390 kernel: [13641.001472][   T55] R13: 000034961670db40 R14: 00007fa504701e70 R15: 00007fa504701c90
> Nov 23 12:39:57 xps-7390 kernel: [13641.001475][   T55]  </TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.001477][   T55] INFO: task ThreadPoolForeg:20885 blocked for more than 122 seconds.
> Nov 23 12:39:57 xps-7390 kernel: [13641.001480][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
> Nov 23 12:39:57 xps-7390 kernel: [13641.001484][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 23 12:39:57 xps-7390 kernel: [13641.001486][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20885 ppid:  2427 flags:0x00004000
> Nov 23 12:39:57 xps-7390 kernel: [13641.001490][   T55] Call Trace:
> Nov 23 12:39:57 xps-7390 kernel: [13641.001492][   T55]  <TASK>
> Nov 23 12:39:57 xps-7390 kernel: [13641.001493][   T55]  __schedule+0x4ac/0x6d0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001497][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001501][   T55]  ? wbt_inflight_cb+0xa0/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001505][   T55]  schedule+0x6f/0xa0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001510][   T55]  io_schedule+0x3b/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.001514][   T55]  rq_qos_wait+0xe5/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.001517][   T55]  ? rq_qos_wait+0x130/0x130
> Nov 23 12:39:57 xps-7390 kernel: [13641.001520][   T55]  ? wbt_exit+0x30/0x30
> Nov 23 12:39:57 xps-7390 kernel: [13641.001524][   T55]  wbt_wait+0xbf/0x180
> Nov 23 12:39:57 xps-7390 kernel: [13641.001529][   T55]  __rq_qos_throttle+0x2c/0x40
> Nov 23 12:39:57 xps-7390 kernel: [13641.001536][   T55]  blk_mq_submit_bio+0x1b8/0x620
> Nov 23 12:39:57 xps-7390 kernel: [13641.001541][   T55]  submit_bio_noacct+0x24c/0x2a0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001545][   T55]  ext4_io_submit+0x43/0x50
> Nov 23 12:39:57 xps-7390 kernel: [13641.001550][   T55]  ext4_writepages+0xa28/0xf80
> Nov 23 12:39:57 xps-7390 kernel: [13641.001560][   T55]  do_writepages+0xd8/0x200
> Nov 23 12:39:57 xps-7390 kernel: [13641.001566][   T55]  ? apparmor_file_permission+0xc5/0x120
> Nov 23 12:39:57 xps-7390 kernel: [13641.001574][   T55]  file_write_and_wait_range+0x12c/0x150
> Nov 23 12:39:57 xps-7390 kernel: [13641.001580][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.001585][   T55]  ext4_sync_file+0x5b/0x250
> Nov 23 12:39:57 xps-7390 kernel: [13641.001590][   T55]  ? ext4_getfsmap_compare+0x20/0x20
> Nov 23 12:39:57 xps-7390 kernel: [13641.001595][   T55]  __x64_sys_fdatasync+0x43/0x70
> Nov 23 12:39:57 xps-7390 kernel: [13641.001600][   T55]  do_syscall_64+0x3e/0xb0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001607][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Nov 23 12:39:57 xps-7390 kernel: [13641.001614][   T55] RIP: 0033:0x7fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.001617][   T55] RSP: 002b:00007fa4fd256d00 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> Nov 23 12:39:57 xps-7390 kernel: [13641.001622][   T55] RAX: ffffffffffffffda RBX: 00007fa4fd256d60 RCX: 00007fa51fe9c1fb
> Nov 23 12:39:57 xps-7390 kernel: [13641.001624][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 000000000000018c
> Nov 23 12:39:57 xps-7390 kernel: [13641.001627][   T55] RBP: 00007fa4fd256de0 R08: 0000000000000000 R09: 00007ffc2fa540b8
> Nov 23 12:39:57 xps-7390 kernel: [13641.001630][   T55] R10: 000000000157e876 R11: 0000000000000293 R12: aaaaaaaaaaaaaaaa
> Nov 23 12:39:57 xps-7390 kernel: [13641.001633][   T55] R13: 0000349618ad87b6 R14: 00007fa4fd256ee0 R15: 0000564a52608ea0
> Nov 23 12:39:57 xps-7390 kernel: [13641.001637][   T55]  </TASK>
> ----
>
> 	-Kenny
>
>

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
