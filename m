Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808A945AE5D
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Nov 2021 22:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240504AbhKWVZO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Nov 2021 16:25:14 -0500
Received: from l2mail1.panix.com ([166.84.1.75]:55993 "EHLO l2mail1.panix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240490AbhKWVZO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Nov 2021 16:25:14 -0500
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2021 16:25:13 EST
Received: from mailbackend.panix.com (mailbackend.panix.com [166.84.1.89])
        by l2mail1.panix.com (Postfix) with ESMTPS id 4HzGrb0216zDbB;
        Tue, 23 Nov 2021 16:05:50 -0500 (EST)
Received: from [192.168.126.80] (ip98-184-250-31.oc.oc.cox.net [98.184.250.31])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4HzGrX6f0lzJnG;
        Tue, 23 Nov 2021 16:05:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1637701549; bh=B3kPy1NzB8y0FmTYTR8f42WWhi1Y6VwmFqX8nuXr4Tw=;
        h=Date:From:Reply-To:To:cc:Subject;
        b=SmVKmngIic9SkWw9o6YikHHdvVzdGEwZMB9NB5irhfhsDt2DfNOer3IPoKWF43NP6
         kJs0/32TYY4dn1NBhF4doo1WfhS64jix22xp0m+hy6YQtAmCK6moM3M1NCwsDOjAxN
         VyitFe9LnG6nvpboJr7GyRENkiqePFfk0egsa5vU=
Date:   Tue, 23 Nov 2021 13:05:47 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org
cc:     "Kenneth R. Crudup" <kenny@panix.com>
Subject: Write I/O queue hangup at random on recent Linus' kernels
Message-ID: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


(Please forgive the SPAMmy nature of the To: list; I'm not exactly sure whose
subsystem this issue belongs to, so please trim as appropriate).

I've got a Kioxia NVMe SSD on my Dell XPS-7390 2-in-1 running an i7-1065G7 CPU
with 32GB RAM.  If you need more info (and I suspect so), please let me know.

I'm sorry I don't have a better description of the problem, but I run Linus'
master branch (and sometimes I weed out problems like this). I'm current as of
his commit 1360572566 (the 5.16-rc2 tag).

For about two weeks now every now and then my block/NVMe/...? subsystem comes to
a total halt on writes, and I get a system that can no longer issue writes
(reads/pageins still seem to work) until I reboot. SysRq-S/U/B still leaves a
dirty ext4 filesystem requring recovery on reboot.

It happens at random- twice today as a matter of fact- and there doesn't seem to
be any particular action that causes it:

----
Nov 23 12:39:57 xps-7390 kernel: [13641.000227][   T55] INFO: task jbd2/nvme0n1p3-:375 blocked for more than 122 seconds.
Nov 23 12:39:57 xps-7390 kernel: [13641.000241][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 12:39:57 xps-7390 kernel: [13641.000245][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 12:39:57 xps-7390 kernel: [13641.000247][   T55] task:jbd2/nvme0n1p3- state:D stack:    0 pid:  375 ppid:     2 flags:0x00004000
Nov 23 12:39:57 xps-7390 kernel: [13641.000254][   T55] Call Trace:
Nov 23 12:39:57 xps-7390 kernel: [13641.000257][   T55]  <TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000259][   T55]  __schedule+0x4ac/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.000268][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000272][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000275][   T55]  schedule+0x6f/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000278][   T55]  io_schedule+0x3b/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.000282][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.000285][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.000287][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000290][   T55]  wbt_wait+0xbf/0x180
Nov 23 12:39:57 xps-7390 kernel: [13641.000293][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 12:39:57 xps-7390 kernel: [13641.000299][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 12:39:57 xps-7390 kernel: [13641.000303][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 12:39:57 xps-7390 kernel: [13641.000306][   T55]  ext4_io_submit+0x43/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.000312][   T55]  ext4_writepage+0x178/0x700
Nov 23 12:39:57 xps-7390 kernel: [13641.000317][   T55]  ? folio_mkclean+0x5c/0x110
Nov 23 12:39:57 xps-7390 kernel: [13641.000323][   T55]  __writepage+0xe/0x60
Nov 23 12:39:57 xps-7390 kernel: [13641.000329][   T55]  write_cache_pages+0x21a/0x3b0
Nov 23 12:39:57 xps-7390 kernel: [13641.000334][   T55]  ? generic_writepages+0x80/0x80
Nov 23 12:39:57 xps-7390 kernel: [13641.000339][   T55]  generic_writepages+0x4a/0x80
Nov 23 12:39:57 xps-7390 kernel: [13641.000344][   T55]  jbd2_journal_submit_inode_data_buffers+0x5b/0x80
Nov 23 12:39:57 xps-7390 kernel: [13641.000349][   T55]  ext4_journal_submit_inode_data_buffers+0x2b/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000355][   T55]  jbd2_journal_commit_transaction+0x4dc/0x1680
Nov 23 12:39:57 xps-7390 kernel: [13641.000360][   T55]  ? __schedule+0x4b4/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.000363][   T55]  kjournald2+0xa8/0x250
Nov 23 12:39:57 xps-7390 kernel: [13641.000368][   T55]  ? init_wait_entry+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000374][   T55]  kthread+0x17a/0x190
Nov 23 12:39:57 xps-7390 kernel: [13641.000380][   T55]  ? jbd2_seq_info_show+0x270/0x270
Nov 23 12:39:57 xps-7390 kernel: [13641.000385][   T55]  ? kthread_unuse_mm+0x90/0x90
Nov 23 12:39:57 xps-7390 kernel: [13641.000390][   T55]  ret_from_fork+0x1f/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000394][   T55]  </TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000404][   T55] INFO: task NetworkManager:1435 blocked for more than 122 seconds.
Nov 23 12:39:57 xps-7390 kernel: [13641.000408][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 12:39:57 xps-7390 kernel: [13641.000411][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 12:39:57 xps-7390 kernel: [13641.000412][   T55] task:NetworkManager  state:D stack:    0 pid: 1435 ppid:     1 flags:0x00004000
Nov 23 12:39:57 xps-7390 kernel: [13641.000417][   T55] Call Trace:
Nov 23 12:39:57 xps-7390 kernel: [13641.000417][   T55]  <TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000419][   T55]  __schedule+0x4ac/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.000422][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000426][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000428][   T55]  schedule+0x6f/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000431][   T55]  io_schedule+0x3b/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.000435][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.000437][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.000439][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000442][   T55]  wbt_wait+0xbf/0x180
Nov 23 12:39:57 xps-7390 kernel: [13641.000444][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 12:39:57 xps-7390 kernel: [13641.000450][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 12:39:57 xps-7390 kernel: [13641.000453][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 12:39:57 xps-7390 kernel: [13641.000457][   T55]  ext4_io_submit+0x43/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.000461][   T55]  ext4_writepages+0xa28/0xf80
Nov 23 12:39:57 xps-7390 kernel: [13641.000467][   T55]  ? ext4_buffered_write_iter+0x10e/0x160
Nov 23 12:39:57 xps-7390 kernel: [13641.000471][   T55]  do_writepages+0xd8/0x200
Nov 23 12:39:57 xps-7390 kernel: [13641.000477][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 12:39:57 xps-7390 kernel: [13641.000483][   T55]  file_write_and_wait_range+0x12c/0x150
Nov 23 12:39:57 xps-7390 kernel: [13641.000487][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.000492][   T55]  ext4_sync_file+0x5b/0x250
Nov 23 12:39:57 xps-7390 kernel: [13641.000496][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.000500][   T55]  __x64_sys_fsync+0x68/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000503][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 12:39:57 xps-7390 kernel: [13641.000509][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 12:39:57 xps-7390 kernel: [13641.000516][   T55] RIP: 0033:0x7f397c57a0bb
Nov 23 12:39:57 xps-7390 kernel: [13641.000518][   T55] RSP: 002b:00007ffd776a00f0 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
Nov 23 12:39:57 xps-7390 kernel: [13641.000522][   T55] RAX: ffffffffffffffda RBX: 00007f397b001930 RCX: 00007f397c57a0bb
Nov 23 12:39:57 xps-7390 kernel: [13641.000525][   T55] RDX: 0000000000000002 RSI: 000055d897d01000 RDI: 000000000000001d
Nov 23 12:39:57 xps-7390 kernel: [13641.000527][   T55] RBP: 000000000000001d R08: 0000000000000000 R09: 00007ffd776a0200
Nov 23 12:39:57 xps-7390 kernel: [13641.000528][   T55] R10: 0000000000009d75 R11: 0000000000000293 R12: 00007ffd776a0200
Nov 23 12:39:57 xps-7390 kernel: [13641.000530][   T55] R13: 000055d897be13c0 R14: 000055d897d0ad75 R15: 0000000000000000
Nov 23 12:39:57 xps-7390 kernel: [13641.000533][   T55]  </TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000596][   T55] INFO: task METRICS_SINK_RU:2806 blocked for more than 122 seconds.
Nov 23 12:39:57 xps-7390 kernel: [13641.000601][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 12:39:57 xps-7390 kernel: [13641.000603][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 12:39:57 xps-7390 kernel: [13641.000605][   T55] task:METRICS_SINK_RU state:D stack:    0 pid: 2806 ppid:     1 flags:0x00004000
Nov 23 12:39:57 xps-7390 kernel: [13641.000609][   T55] Call Trace:
Nov 23 12:39:57 xps-7390 kernel: [13641.000610][   T55]  <TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000612][   T55]  __schedule+0x4ac/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.000616][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000619][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000622][   T55]  schedule+0x6f/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000624][   T55]  io_schedule+0x3b/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.000628][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.000630][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.000633][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000635][   T55]  wbt_wait+0xbf/0x180
Nov 23 12:39:57 xps-7390 kernel: [13641.000638][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 12:39:57 xps-7390 kernel: [13641.000645][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 12:39:57 xps-7390 kernel: [13641.000648][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 12:39:57 xps-7390 kernel: [13641.000655][   T55]  ext4_io_submit+0x43/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.000659][   T55]  ext4_writepages+0xa28/0xf80
Nov 23 12:39:57 xps-7390 kernel: [13641.000665][   T55]  ? generic_perform_write+0x17a/0x210
Nov 23 12:39:57 xps-7390 kernel: [13641.000671][   T55]  do_writepages+0xd8/0x200
Nov 23 12:39:57 xps-7390 kernel: [13641.000676][   T55]  ? ext4_file_write_iter+0x2c6/0x870
Nov 23 12:39:57 xps-7390 kernel: [13641.000681][   T55]  filemap_flush+0x6c/0x90
Nov 23 12:39:57 xps-7390 kernel: [13641.000685][   T55]  ext4_release_file+0x20/0xc0
Nov 23 12:39:57 xps-7390 kernel: [13641.000691][   T55]  __fput+0xec/0x210
Nov 23 12:39:57 xps-7390 kernel: [13641.000697][   T55]  task_work_run+0x69/0xb0
Nov 23 12:39:57 xps-7390 kernel: [13641.000703][   T55]  exit_to_user_mode_prepare+0xd6/0x120
Nov 23 12:39:57 xps-7390 kernel: [13641.000710][   T55]  syscall_exit_to_user_mode+0x24/0x100
Nov 23 12:39:57 xps-7390 kernel: [13641.000714][   T55]  do_syscall_64+0x4e/0xb0
Nov 23 12:39:57 xps-7390 kernel: [13641.000720][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 12:39:57 xps-7390 kernel: [13641.000726][   T55] RIP: 0033:0x7febd5adebdb
Nov 23 12:39:57 xps-7390 kernel: [13641.000728][   T55] RSP: 002b:00007feb64bf5de0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
Nov 23 12:39:57 xps-7390 kernel: [13641.000731][   T55] RAX: 0000000000000000 RBX: 000000000000002c RCX: 00007febd5adebdb
Nov 23 12:39:57 xps-7390 kernel: [13641.000734][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 000000000000002c
Nov 23 12:39:57 xps-7390 kernel: [13641.000735][   T55] RBP: 00007feb64bf66d0 R08: 0000000000000000 R09: 0000000000008000
Nov 23 12:39:57 xps-7390 kernel: [13641.000737][   T55] R10: 0000000000000000 R11: 0000000000000293 R12: 00007feb64bf7070
Nov 23 12:39:57 xps-7390 kernel: [13641.000739][   T55] R13: 0000000000000000 R14: 00007feb64bf5ea0 R15: 00007feb64bf6200
Nov 23 12:39:57 xps-7390 kernel: [13641.000741][   T55]  </TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000762][   T55] INFO: task ThreadPoolForeg:20339 blocked for more than 122 seconds.
Nov 23 12:39:57 xps-7390 kernel: [13641.000766][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 12:39:57 xps-7390 kernel: [13641.000769][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 12:39:57 xps-7390 kernel: [13641.000770][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20339 ppid:  2427 flags:0x00004000
Nov 23 12:39:57 xps-7390 kernel: [13641.000774][   T55] Call Trace:
Nov 23 12:39:57 xps-7390 kernel: [13641.000776][   T55]  <TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000778][   T55]  __schedule+0x4ac/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.000782][   T55]  schedule+0x6f/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000785][   T55]  jbd2_log_wait_commit+0xe2/0x120
Nov 23 12:39:57 xps-7390 kernel: [13641.000791][   T55]  ? init_wait_entry+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000797][   T55]  ext4_fc_commit+0xe7/0xd00
Nov 23 12:39:57 xps-7390 kernel: [13641.000800][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 12:39:57 xps-7390 kernel: [13641.000806][   T55]  ? file_write_and_wait_range+0xb9/0x150
Nov 23 12:39:57 xps-7390 kernel: [13641.000811][   T55]  ext4_sync_file+0xc9/0x250
Nov 23 12:39:57 xps-7390 kernel: [13641.000815][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.000819][   T55]  __x64_sys_fdatasync+0x43/0x70
Nov 23 12:39:57 xps-7390 kernel: [13641.000823][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 12:39:57 xps-7390 kernel: [13641.000827][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 12:39:57 xps-7390 kernel: [13641.000833][   T55] RIP: 0033:0x7fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.000835][   T55] RSP: 002b:00007fa507107980 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
Nov 23 12:39:57 xps-7390 kernel: [13641.000837][   T55] RAX: ffffffffffffffda RBX: 000034960a063f80 RCX: 00007fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.000840][   T55] RDX: 0000000000000002 RSI: 0000000000000002 RDI: 0000000000000176
Nov 23 12:39:57 xps-7390 kernel: [13641.000842][   T55] RBP: 00007fa5071079d0 R08: 0000000000000000 R09: 0000564a51add248
Nov 23 12:39:57 xps-7390 kernel: [13641.000844][   T55] R10: 0000000000002400 R11: 0000000000000293 R12: 0000349609b25000
Nov 23 12:39:57 xps-7390 kernel: [13641.000848][   T55] R13: 0000000000000000 R14: 0000000000002400 R15: 0000000000001000
Nov 23 12:39:57 xps-7390 kernel: [13641.000851][   T55]  </TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000853][   T55] INFO: task ThreadPoolForeg:20715 blocked for more than 122 seconds.
Nov 23 12:39:57 xps-7390 kernel: [13641.000858][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 12:39:57 xps-7390 kernel: [13641.000861][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 12:39:57 xps-7390 kernel: [13641.000871][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20715 ppid:  2427 flags:0x00004000
Nov 23 12:39:57 xps-7390 kernel: [13641.000874][   T55] Call Trace:
Nov 23 12:39:57 xps-7390 kernel: [13641.000875][   T55]  <TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000876][   T55]  __schedule+0x4ac/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.000879][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000882][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000885][   T55]  schedule+0x6f/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.000888][   T55]  io_schedule+0x3b/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.000891][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.000893][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.000895][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.000898][   T55]  wbt_wait+0xbf/0x180
Nov 23 12:39:57 xps-7390 kernel: [13641.000900][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 12:39:57 xps-7390 kernel: [13641.000906][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 12:39:57 xps-7390 kernel: [13641.000909][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 12:39:57 xps-7390 kernel: [13641.000912][   T55]  ext4_io_submit+0x43/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.000916][   T55]  ext4_writepages+0xa28/0xf80
Nov 23 12:39:57 xps-7390 kernel: [13641.000923][   T55]  do_writepages+0xd8/0x200
Nov 23 12:39:57 xps-7390 kernel: [13641.000929][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 12:39:57 xps-7390 kernel: [13641.000935][   T55]  file_write_and_wait_range+0x12c/0x150
Nov 23 12:39:57 xps-7390 kernel: [13641.000938][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.000942][   T55]  ext4_sync_file+0x5b/0x250
Nov 23 12:39:57 xps-7390 kernel: [13641.000946][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.000949][   T55]  __x64_sys_fdatasync+0x43/0x70
Nov 23 12:39:57 xps-7390 kernel: [13641.000952][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 12:39:57 xps-7390 kernel: [13641.000957][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 12:39:57 xps-7390 kernel: [13641.000963][   T55] RIP: 0033:0x7fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.000965][   T55] RSP: 002b:00007fa50144dd00 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
Nov 23 12:39:57 xps-7390 kernel: [13641.000968][   T55] RAX: ffffffffffffffda RBX: 00007fa50144dd60 RCX: 00007fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.000971][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000000001ea
Nov 23 12:39:57 xps-7390 kernel: [13641.000973][   T55] RBP: 00007fa50144dde0 R08: 0000000000000000 R09: 00007ffc2fa540b8
Nov 23 12:39:57 xps-7390 kernel: [13641.000975][   T55] R10: 0000000001568a98 R11: 0000000000000293 R12: aaaaaaaaaaaaaaaa
Nov 23 12:39:57 xps-7390 kernel: [13641.000978][   T55] R13: 000034960c9d6549 R14: 00007fa50144dee0 R15: 0000564a52608ea0
Nov 23 12:39:57 xps-7390 kernel: [13641.000981][   T55]  </TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000982][   T55] INFO: task ThreadPoolForeg:20716 blocked for more than 122 seconds.
Nov 23 12:39:57 xps-7390 kernel: [13641.000985][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 12:39:57 xps-7390 kernel: [13641.000987][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 12:39:57 xps-7390 kernel: [13641.000989][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20716 ppid:  2427 flags:0x00004000
Nov 23 12:39:57 xps-7390 kernel: [13641.000992][   T55] Call Trace:
Nov 23 12:39:57 xps-7390 kernel: [13641.000993][   T55]  <TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.000994][   T55]  __schedule+0x4ac/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.000997][   T55]  ? kmem_cache_alloc+0x153/0x240
Nov 23 12:39:57 xps-7390 kernel: [13641.001003][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001005][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.001008][   T55]  schedule+0x6f/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.001011][   T55]  io_schedule+0x3b/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.001013][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.001015][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.001017][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001020][   T55]  wbt_wait+0xbf/0x180
Nov 23 12:39:57 xps-7390 kernel: [13641.001022][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 12:39:57 xps-7390 kernel: [13641.001028][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 12:39:57 xps-7390 kernel: [13641.001031][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 12:39:57 xps-7390 kernel: [13641.001033][   T55]  ext4_io_submit+0x43/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.001037][   T55]  ext4_writepages+0x3bc/0xf80
Nov 23 12:39:57 xps-7390 kernel: [13641.001043][   T55]  ? ext4_buffered_write_iter+0x10e/0x160
Nov 23 12:39:57 xps-7390 kernel: [13641.001047][   T55]  do_writepages+0xd8/0x200
Nov 23 12:39:57 xps-7390 kernel: [13641.001053][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 12:39:57 xps-7390 kernel: [13641.001059][   T55]  file_write_and_wait_range+0x12c/0x150
Nov 23 12:39:57 xps-7390 kernel: [13641.001062][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.001066][   T55]  ext4_sync_file+0x5b/0x250
Nov 23 12:39:57 xps-7390 kernel: [13641.001069][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.001073][   T55]  __x64_sys_fdatasync+0x43/0x70
Nov 23 12:39:57 xps-7390 kernel: [13641.001075][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 12:39:57 xps-7390 kernel: [13641.001080][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 12:39:57 xps-7390 kernel: [13641.001085][   T55] RIP: 0033:0x7fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.001087][   T55] RSP: 002b:00007fa507908e50 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
Nov 23 12:39:57 xps-7390 kernel: [13641.001089][   T55] RAX: ffffffffffffffda RBX: 00007fa507908eb0 RCX: 00007fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.001090][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000000000b8
Nov 23 12:39:57 xps-7390 kernel: [13641.001092][   T55] RBP: 00007fa507908f30 R08: 0000000000000000 R09: 00007ffc2fa540b8
Nov 23 12:39:57 xps-7390 kernel: [13641.001093][   T55] R10: 00000000015651fc R11: 0000000000000293 R12: aaaaaaaaaaaaaaaa
Nov 23 12:39:57 xps-7390 kernel: [13641.001095][   T55] R13: 00003496090fa400 R14: 00003496090fa400 R15: 0000564a52608ea0
Nov 23 12:39:57 xps-7390 kernel: [13641.001097][   T55]  </TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.001098][   T55] INFO: task ThreadPoolForeg:20816 blocked for more than 122 seconds.
Nov 23 12:39:57 xps-7390 kernel: [13641.001101][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 12:39:57 xps-7390 kernel: [13641.001103][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 12:39:57 xps-7390 kernel: [13641.001104][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20816 ppid:  2427 flags:0x00004000
Nov 23 12:39:57 xps-7390 kernel: [13641.001107][   T55] Call Trace:
Nov 23 12:39:57 xps-7390 kernel: [13641.001108][   T55]  <TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.001109][   T55]  __schedule+0x4ac/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.001112][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001115][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.001117][   T55]  schedule+0x6f/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.001120][   T55]  io_schedule+0x3b/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.001123][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.001125][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.001127][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001129][   T55]  wbt_wait+0xbf/0x180
Nov 23 12:39:57 xps-7390 kernel: [13641.001132][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 12:39:57 xps-7390 kernel: [13641.001137][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 12:39:57 xps-7390 kernel: [13641.001140][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 12:39:57 xps-7390 kernel: [13641.001143][   T55]  ext4_io_submit+0x43/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.001146][   T55]  ext4_writepages+0xa28/0xf80
Nov 23 12:39:57 xps-7390 kernel: [13641.001153][   T55]  ? hrtimer_cancel+0x15/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001156][   T55]  ? futex_wait+0x20c/0x250
Nov 23 12:39:57 xps-7390 kernel: [13641.001161][   T55]  do_writepages+0xd8/0x200
Nov 23 12:39:57 xps-7390 kernel: [13641.001166][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 12:39:57 xps-7390 kernel: [13641.001172][   T55]  file_write_and_wait_range+0x12c/0x150
Nov 23 12:39:57 xps-7390 kernel: [13641.001175][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.001190][   T55]  ext4_sync_file+0x5b/0x250
Nov 23 12:39:57 xps-7390 kernel: [13641.001194][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.001198][   T55]  __x64_sys_fdatasync+0x43/0x70
Nov 23 12:39:57 xps-7390 kernel: [13641.001201][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 12:39:57 xps-7390 kernel: [13641.001206][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 12:39:57 xps-7390 kernel: [13641.001212][   T55] RIP: 0033:0x7fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.001214][   T55] RSP: 002b:00007fa4fda57980 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
Nov 23 12:39:57 xps-7390 kernel: [13641.001216][   T55] RAX: ffffffffffffffda RBX: 0000349608f73200 RCX: 00007fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.001218][   T55] RDX: 0000000000000002 RSI: 0000000000000002 RDI: 0000000000000178
Nov 23 12:39:57 xps-7390 kernel: [13641.001220][   T55] RBP: 00007fa4fda579d0 R08: 0000000000000000 R09: 0000564a51add248
Nov 23 12:39:57 xps-7390 kernel: [13641.001221][   T55] R10: 0000000000002400 R11: 0000000000000293 R12: 0000349609b23e00
Nov 23 12:39:57 xps-7390 kernel: [13641.001223][   T55] R13: 0000000000000000 R14: 0000000000002400 R15: 0000000000001000
Nov 23 12:39:57 xps-7390 kernel: [13641.001225][   T55]  </TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.001226][   T55] INFO: task ThreadPoolForeg:20869 blocked for more than 122 seconds.
Nov 23 12:39:57 xps-7390 kernel: [13641.001229][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 12:39:57 xps-7390 kernel: [13641.001232][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 12:39:57 xps-7390 kernel: [13641.001234][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20869 ppid:  2427 flags:0x00004000
Nov 23 12:39:57 xps-7390 kernel: [13641.001237][   T55] Call Trace:
Nov 23 12:39:57 xps-7390 kernel: [13641.001238][   T55]  <TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.001239][   T55]  __schedule+0x4ac/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.001242][   T55]  ? kmem_cache_alloc+0x153/0x240
Nov 23 12:39:57 xps-7390 kernel: [13641.001246][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001249][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.001251][   T55]  schedule+0x6f/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.001254][   T55]  io_schedule+0x3b/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.001257][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.001260][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.001262][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001264][   T55]  wbt_wait+0xbf/0x180
Nov 23 12:39:57 xps-7390 kernel: [13641.001267][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 12:39:57 xps-7390 kernel: [13641.001272][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 12:39:57 xps-7390 kernel: [13641.001275][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 12:39:57 xps-7390 kernel: [13641.001278][   T55]  ext4_io_submit+0x43/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.001282][   T55]  ext4_writepages+0x3bc/0xf80
Nov 23 12:39:57 xps-7390 kernel: [13641.001288][   T55]  ? ext4_buffered_write_iter+0x10e/0x160
Nov 23 12:39:57 xps-7390 kernel: [13641.001292][   T55]  do_writepages+0xd8/0x200
Nov 23 12:39:57 xps-7390 kernel: [13641.001298][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 12:39:57 xps-7390 kernel: [13641.001303][   T55]  file_write_and_wait_range+0x12c/0x150
Nov 23 12:39:57 xps-7390 kernel: [13641.001308][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.001311][   T55]  ext4_sync_file+0x5b/0x250
Nov 23 12:39:57 xps-7390 kernel: [13641.001315][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.001318][   T55]  __x64_sys_fdatasync+0x43/0x70
Nov 23 12:39:57 xps-7390 kernel: [13641.001321][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 12:39:57 xps-7390 kernel: [13641.001326][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 12:39:57 xps-7390 kernel: [13641.001330][   T55] RIP: 0033:0x7fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.001332][   T55] RSP: 002b:00007fa504f02720 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
Nov 23 12:39:57 xps-7390 kernel: [13641.001335][   T55] RAX: ffffffffffffffda RBX: 00007fa504f02780 RCX: 00007fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.001336][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000000001cc
Nov 23 12:39:57 xps-7390 kernel: [13641.001338][   T55] RBP: 00007fa504f02800 R08: 0000000000000000 R09: 00007ffc2fa540b8
Nov 23 12:39:57 xps-7390 kernel: [13641.001340][   T55] R10: 00000000015743a0 R11: 0000000000000293 R12: aaaaaaaaaaaaaaaa
Nov 23 12:39:57 xps-7390 kernel: [13641.001342][   T55] R13: 0000349609565e80 R14: 0000349609565ea0 R15: 0000564a52608ea0
Nov 23 12:39:57 xps-7390 kernel: [13641.001344][   T55]  </TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.001345][   T55] INFO: task ThreadPoolForeg:20878 blocked for more than 122 seconds.
Nov 23 12:39:57 xps-7390 kernel: [13641.001348][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 12:39:57 xps-7390 kernel: [13641.001350][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 12:39:57 xps-7390 kernel: [13641.001352][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20878 ppid:  2427 flags:0x00004000
Nov 23 12:39:57 xps-7390 kernel: [13641.001354][   T55] Call Trace:
Nov 23 12:39:57 xps-7390 kernel: [13641.001355][   T55]  <TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.001356][   T55]  __schedule+0x4ac/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.001359][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001361][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.001363][   T55]  schedule+0x6f/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.001366][   T55]  io_schedule+0x3b/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.001369][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.001371][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.001373][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001375][   T55]  wbt_wait+0xbf/0x180
Nov 23 12:39:57 xps-7390 kernel: [13641.001377][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 12:39:57 xps-7390 kernel: [13641.001384][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 12:39:57 xps-7390 kernel: [13641.001388][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 12:39:57 xps-7390 kernel: [13641.001392][   T55]  ext4_bio_write_page+0x2de/0x430
Nov 23 12:39:57 xps-7390 kernel: [13641.001398][   T55]  ext4_writepages+0x90e/0xf80
Nov 23 12:39:57 xps-7390 kernel: [13641.001406][   T55]  do_writepages+0xd8/0x200
Nov 23 12:39:57 xps-7390 kernel: [13641.001412][   T55]  filemap_flush+0x6c/0x90
Nov 23 12:39:57 xps-7390 kernel: [13641.001417][   T55]  ext4_rename2+0x670/0x1590
Nov 23 12:39:57 xps-7390 kernel: [13641.001423][   T55]  ? inode_permission+0x29/0x170
Nov 23 12:39:57 xps-7390 kernel: [13641.001429][   T55]  vfs_rename+0x4ff/0x670
Nov 23 12:39:57 xps-7390 kernel: [13641.001434][   T55]  do_renameat2+0x487/0x6f0
Nov 23 12:39:57 xps-7390 kernel: [13641.001440][   T55]  __x64_sys_rename+0x3b/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.001445][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 12:39:57 xps-7390 kernel: [13641.001451][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 12:39:57 xps-7390 kernel: [13641.001458][   T55] RIP: 0033:0x7fa51fdecfcb
Nov 23 12:39:57 xps-7390 kernel: [13641.001461][   T55] RSP: 002b:00007fa504701c88 EFLAGS: 00000282 ORIG_RAX: 0000000000000052
Nov 23 12:39:57 xps-7390 kernel: [13641.001464][   T55] RAX: ffffffffffffffda RBX: 00007fa504701db0 RCX: 00007fa51fdecfcb
Nov 23 12:39:57 xps-7390 kernel: [13641.001465][   T55] RDX: 0000000000004000 RSI: 000034961bfe4400 RDI: 0000349605ae5e60
Nov 23 12:39:57 xps-7390 kernel: [13641.001468][   T55] RBP: 00007fa504701e30 R08: 000034961a69a003 R09: 00007ffc2fa540b8
Nov 23 12:39:57 xps-7390 kernel: [13641.001470][   T55] R10: 000000000157d910 R11: 0000000000000282 R12: 0000349606911e08
Nov 23 12:39:57 xps-7390 kernel: [13641.001472][   T55] R13: 000034961670db40 R14: 00007fa504701e70 R15: 00007fa504701c90
Nov 23 12:39:57 xps-7390 kernel: [13641.001475][   T55]  </TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.001477][   T55] INFO: task ThreadPoolForeg:20885 blocked for more than 122 seconds.
Nov 23 12:39:57 xps-7390 kernel: [13641.001480][   T55]       Tainted: G S   U     O      5.16.0-rc2-XPS-Kenny+ #1
Nov 23 12:39:57 xps-7390 kernel: [13641.001484][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 12:39:57 xps-7390 kernel: [13641.001486][   T55] task:ThreadPoolForeg state:D stack:    0 pid:20885 ppid:  2427 flags:0x00004000
Nov 23 12:39:57 xps-7390 kernel: [13641.001490][   T55] Call Trace:
Nov 23 12:39:57 xps-7390 kernel: [13641.001492][   T55]  <TASK>
Nov 23 12:39:57 xps-7390 kernel: [13641.001493][   T55]  __schedule+0x4ac/0x6d0
Nov 23 12:39:57 xps-7390 kernel: [13641.001497][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001501][   T55]  ? wbt_inflight_cb+0xa0/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.001505][   T55]  schedule+0x6f/0xa0
Nov 23 12:39:57 xps-7390 kernel: [13641.001510][   T55]  io_schedule+0x3b/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.001514][   T55]  rq_qos_wait+0xe5/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.001517][   T55]  ? rq_qos_wait+0x130/0x130
Nov 23 12:39:57 xps-7390 kernel: [13641.001520][   T55]  ? wbt_exit+0x30/0x30
Nov 23 12:39:57 xps-7390 kernel: [13641.001524][   T55]  wbt_wait+0xbf/0x180
Nov 23 12:39:57 xps-7390 kernel: [13641.001529][   T55]  __rq_qos_throttle+0x2c/0x40
Nov 23 12:39:57 xps-7390 kernel: [13641.001536][   T55]  blk_mq_submit_bio+0x1b8/0x620
Nov 23 12:39:57 xps-7390 kernel: [13641.001541][   T55]  submit_bio_noacct+0x24c/0x2a0
Nov 23 12:39:57 xps-7390 kernel: [13641.001545][   T55]  ext4_io_submit+0x43/0x50
Nov 23 12:39:57 xps-7390 kernel: [13641.001550][   T55]  ext4_writepages+0xa28/0xf80
Nov 23 12:39:57 xps-7390 kernel: [13641.001560][   T55]  do_writepages+0xd8/0x200
Nov 23 12:39:57 xps-7390 kernel: [13641.001566][   T55]  ? apparmor_file_permission+0xc5/0x120
Nov 23 12:39:57 xps-7390 kernel: [13641.001574][   T55]  file_write_and_wait_range+0x12c/0x150
Nov 23 12:39:57 xps-7390 kernel: [13641.001580][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.001585][   T55]  ext4_sync_file+0x5b/0x250
Nov 23 12:39:57 xps-7390 kernel: [13641.001590][   T55]  ? ext4_getfsmap_compare+0x20/0x20
Nov 23 12:39:57 xps-7390 kernel: [13641.001595][   T55]  __x64_sys_fdatasync+0x43/0x70
Nov 23 12:39:57 xps-7390 kernel: [13641.001600][   T55]  do_syscall_64+0x3e/0xb0
Nov 23 12:39:57 xps-7390 kernel: [13641.001607][   T55]  entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 23 12:39:57 xps-7390 kernel: [13641.001614][   T55] RIP: 0033:0x7fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.001617][   T55] RSP: 002b:00007fa4fd256d00 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
Nov 23 12:39:57 xps-7390 kernel: [13641.001622][   T55] RAX: ffffffffffffffda RBX: 00007fa4fd256d60 RCX: 00007fa51fe9c1fb
Nov 23 12:39:57 xps-7390 kernel: [13641.001624][   T55] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 000000000000018c
Nov 23 12:39:57 xps-7390 kernel: [13641.001627][   T55] RBP: 00007fa4fd256de0 R08: 0000000000000000 R09: 00007ffc2fa540b8
Nov 23 12:39:57 xps-7390 kernel: [13641.001630][   T55] R10: 000000000157e876 R11: 0000000000000293 R12: aaaaaaaaaaaaaaaa
Nov 23 12:39:57 xps-7390 kernel: [13641.001633][   T55] R13: 0000349618ad87b6 R14: 00007fa4fd256ee0 R15: 0000564a52608ea0
Nov 23 12:39:57 xps-7390 kernel: [13641.001637][   T55]  </TASK>
----

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
