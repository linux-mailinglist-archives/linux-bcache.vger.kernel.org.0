Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05C42D2985
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Dec 2020 12:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgLHLEt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 8 Dec 2020 06:04:49 -0500
Received: from verein.lst.de ([213.95.11.211]:45802 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbgLHLEs (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Dec 2020 06:04:48 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 503686736F; Tue,  8 Dec 2020 12:04:04 +0100 (CET)
Date:   Tue, 8 Dec 2020 12:04:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Qian Cai <qcai@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: store a pointer to the block_device in struct bio (again)
Message-ID: <20201208110403.GA22179@lst.de>
References: <20201201165424.2030647-1-hch@lst.de> <920899710c9e8dcce16e561c6d832e4e9c03cd73.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <920899710c9e8dcce16e561c6d832e4e9c03cd73.camel@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Qian,

can you send me details of your device mapper setup, e.g. which targets
are used, are they used on top of whole device or partitions.  Do you
use partitions on top of the dm devices?  Are any other stacking devices
involved?

On Mon, Dec 07, 2020 at 01:56:26PM -0500, Qian Cai wrote:
> On Tue, 2020-12-01 at 17:54 +0100, Christoph Hellwig wrote:
> > Hi Jens,
> > 
> > this series switches back from storing the gendisk + partno to storing
> > a block_device pointer in struct bio.  The reason is two fold:  for one
> > the new struct block_device actually is always available, removing the
> > need to avoid originally.  Second the merge struct block_device is much
> > more useful than the old one, as storing it avoids the need for looking
> > up what used to be hd_struct during partition remapping and I/O
> > accounting.
> > 
> > Note that this series depends on the posted but not merged
> > "block tracepoint cleanups" series.
> 
> Reverting this patchset on the top of today's linux-next fixed data corruptions
> everywhere, i.e.,
> 
> $ git revert --no-edit a54895fa057c..4498a8536c81
> (with a trivial conflict resolution with the commit "block: move
> blk_rq_bio_prep() to linux/blk-mq.h")
> 
> .config (if ever matters and also happened on POWER9 NV):
> https://cailca.coding.net/public/linux/mm/git/files/master/x86.config
> 
> == XFS failed to mount ==
> [   55.116279][ T1507] XFS (dm-0): Mounting V5 Filesystem
> [   55.144671][ T1507] XFS (dm-0): Corruption warning: Metadata has LSN (3:70242) ahead of current LSN (3:66504). Please unmount and run xfs_repair (>= v4.3) to resolve.
> [   55.159965][ T1507] XFS (dm-0): log mount/recovery failed: error -22
> [   55.288632][ T1507] XFS (dm-0): log mount failed
> 
> In this case, it is not possible to mount the XFS rootfs anymore, and it can be
> repaired with "-L". However, we could lost vital files. Then, I have to re-
> install the system.
> 
> systemd[1]: System cannot boot: Missing /etc/machine-id and /etc is mounted read-only.
> systemd[1]: Booting up is supported only when:
> systemd[1]: 1) /etc/machine-id exists and is populated.
> systemd[1]: 2) /etc/machine-id exists and is empty.
> systemd[1]: 3) /etc/machine-id is missing and /etc is writable.
> lvm2-activation-generator: lvmconfig failed
> systemd[1]: Failed to populate /etc with preset unit settings, ignoring: No such file or directory
> 
> == systemd core dump ==
> [   46.124485][ T1028] Process 1028(systemd-coredum) has RLIMIT_CORE set to 1
> [   46.131434][ T1028] Aborting core
> [   46.143366][ T1027] systemd-cgroups (1027) used greatest stack depth: 23512 bytes left
> [   46.384430][    T1] printk: systemd: 20 output lines suppressed due to ratelimiting
> [   46.447620][    T1] traps: systemd[1] trap invalid opcode ip:7f44c485fee6 sp:7ffee96e6960 error:0 in libm-2.28.so[7f44c481a000+181000]
> [   46.492643][ T1029] traps: systemd-coredum[1029] trap invalid opcode ip:7f2f60471ee6 sp:7ffd58f76e00 error:0 in libm-2.28.so[7f2f6042c000+181000]
> [   46.505968][ T1029] Process 1029(systemd-coredum) has RLIMIT_CORE set to 1
> [   46.512900][ T1029] Aborting core
> [   46.520024][    T1] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000084
> [   46.528437][    T1] CPU: 32 PID: 1 Comm: systemd Not tainted 5.10.0-rc6-next-20201207 #1
> [   46.536581][    T1] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019
> [   46.545860][    T1] Call Trace:
> [   46.549038][    T1]  dump_stack+0x99/0xcb
> [   46.553082][    T1]  panic+0x20c/0x48b
> [   46.556860][    T1]  ? print_oops_end_marker.cold.10+0x10/0x10
> [   46.562739][    T1]  ? do_signal_stop+0x690/0x690
> [   46.567478][    T1]  ? do_exit+0x226/0x2410
> [   46.571690][    T1]  do_exit.cold.38+0x1de/0x1e5
> [   46.576346][    T1]  ? rcu_read_lock_sched_held+0xa1/0xd0
> [   46.581782][    T1]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [   46.586955][    T1]  ? mm_update_next_owner+0x750/0x750
> [   46.592215][    T1]  ? get_signal+0x80f/0x1f90
> [   46.596688][    T1]  do_group_exit+0xf0/0x2e0
> [   46.601076][    T1]  get_signal+0x35a/0x1f90
> [   46.605380][    T1]  ? finish_task_switch+0x1bb/0xa80
> [   46.610468][    T1]  arch_do_signal_or_restart+0x1d8/0x690
> [   46.615993][    T1]  ? __setup_rt_frame.isra.15+0x1830/0x1830
> [   46.621781][    T1]  ? __sched_text_start+0x8/0x8
> [   46.626521][    T1]  ? asm_exc_invalid_op+0xa/0x20
> [   46.631347][    T1]  exit_to_user_mode_prepare+0xde/0x170
> [   46.636782][    T1]  irqentry_exit_to_user_mode+0x5/0x30
> [   46.642129][    T1]  asm_exc_invalid_op+0x12/0x20
> [   46.646868][    T1] RIP: 0033:0x7f44c485fee6
> [   46.651171][    T1] Code: 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 0a 00 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a <61> 62 63 64 65 66 67 68 6a 69 6b 6c 6d 6e 6f 70 71 72 73 74 75 76
> [   46.670757][    T1] RSP: 002b:00007ffee96e6960 EFLAGS: 00010202
> [   46.676719][    T1] RAX: 00007f44c481c780 RBX: 00007f44c4825e78 RCX: 0000000000000000
> [   46.684600][    T1] RDX: 00007ffee96e6a90 RSI: 0000000000000000 RDI: 00007f44c481c780
> [   46.692480][    T1] RBP: 00007ffee96e6a90 R08: 00007f44c85d88a8 R09: 00007f44c85d88a8
> [   46.700360][    T1] R10: 00007f44ca38e4f0 R11: 00007f44c481a000 R12: 00007f44c481c780
> [   46.708241][    T1] R13: 00007f44c4826088 R14: 00007f44c4b9b128 R15: 00007f44ca38e4f0
> [   46.716523][    T1] Kernel Offset: 0x11000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [   46.728244][    T1] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000084 ]---
> 
> == git coredump == 
> # coredumpctl dump
>            PID: 1906 (git)
>            UID: 0 (root)
>            GID: 0 (root)
>         Signal: 11 (SEGV)
>      Timestamp: Mon 2020-12-07 10:10:36 EST (34s ago)
>        Boot ID: 5dd9e21b02e4487f96d2ffeed3140f22
>     Machine ID: 00f60cae470d4f54a377e935638619c5
>        Storage: /var/lib/systemd/coredump/core.git.0.5dd9e21b02e4487f96d2ffeed3140f22.1906.1607353836000000.lz4
>        Message: Process 1906 (git) of user 0 dumped core.
>                 
>                 Stack trace of thread 1906:
>                 #0  0x00007fff845af9dc _dl_relocate_object (/usr/lib64/ld-2.28.so)
>                 #1  0x00007fff845a6664 dl_main (/usr/lib64/ld-2.28.so)
>                 #2  0x00007fff845c0448 _dl_sysdep_start (/usr/lib64/ld-2.28.so)
>                 #3  0x00007fff845a1cbc _dl_start_final (/usr/lib64/ld-2.28.so)
>                 #4  0x00007fff845a2dbc _dl_start (/usr/lib64/ld-2.28.so)
>                 #5  0x00007fff845a1458 _start (/usr/lib64/ld-2.28.so)
> 
> > 
> > A git tree is also available:
> > 
> >     git://git.infradead.org/users/hch/block.git bi_bdev
> > 
> > Gitweb:
> > 
> >     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bi_bdev
> > 
> > Diffstat:
> >  arch/m68k/emu/nfblock.c             |    2 
> >  arch/xtensa/platforms/iss/simdisk.c |    2 
> >  block/bio-integrity.c               |   18 +-
> >  block/bio.c                         |   31 +---
> >  block/blk-cgroup.c                  |    7 
> >  block/blk-core.c                    |   99 ++++++-------
> >  block/blk-crypto-fallback.c         |    2 
> >  block/blk-crypto.c                  |    2 
> >  block/blk-merge.c                   |   17 +-
> >  block/blk-mq.c                      |    2 
> >  block/blk-settings.c                |    2 
> >  block/blk-throttle.c                |    2 
> >  block/blk.h                         |    9 -
> >  block/bounce.c                      |    2 
> >  block/genhd.c                       |  261 +++-------------------------------
> > --
> >  block/partitions/core.c             |   31 ----
> >  drivers/block/brd.c                 |    8 -
> >  drivers/block/drbd/drbd_int.h       |    4 
> >  drivers/block/drbd/drbd_req.c       |    2 
> >  drivers/block/null_blk_main.c       |    2 
> >  drivers/block/pktcdvd.c             |    4 
> >  drivers/block/ps3vram.c             |    2 
> >  drivers/block/rsxx/dev.c            |    2 
> >  drivers/block/umem.c                |    2 
> >  drivers/block/zram/zram_drv.c       |    2 
> >  drivers/lightnvm/pblk-init.c        |    2 
> >  drivers/md/bcache/debug.c           |    2 
> >  drivers/md/bcache/request.c         |   39 +++--
> >  drivers/md/dm-bio-record.h          |    9 -
> >  drivers/md/dm-raid1.c               |   10 -
> >  drivers/md/dm.c                     |   14 -
> >  drivers/md/md-linear.c              |    2 
> >  drivers/md/md.c                     |   10 -
> >  drivers/md/md.h                     |    6 
> >  drivers/md/raid1.c                  |    6 
> >  drivers/md/raid10.c                 |   12 -
> >  drivers/md/raid5.c                  |    2 
> >  drivers/nvdimm/blk.c                |    4 
> >  drivers/nvdimm/btt.c                |    4 
> >  drivers/nvdimm/pmem.c               |    4 
> >  drivers/nvme/host/core.c            |    6 
> >  drivers/nvme/host/lightnvm.c        |    3 
> >  drivers/nvme/host/multipath.c       |    6 
> >  drivers/nvme/host/rdma.c            |    2 
> >  drivers/s390/block/dasd.c           |   26 ---
> >  drivers/s390/block/dcssblk.c        |    6 
> >  drivers/s390/block/xpram.c          |    2 
> >  fs/btrfs/check-integrity.c          |   10 -
> >  fs/btrfs/raid56.c                   |    7 
> >  fs/btrfs/scrub.c                    |    2 
> >  fs/direct-io.c                      |    2 
> >  fs/f2fs/data.c                      |   12 -
> >  include/linux/bio.h                 |   18 +-
> >  include/linux/blk_types.h           |    3 
> >  include/linux/blkdev.h              |   20 --
> >  include/linux/genhd.h               |   21 --
> >  kernel/trace/blktrace.c             |   16 +-
> >  mm/page_io.c                        |    2 
> >  58 files changed, 251 insertions(+), 556 deletions(-)
---end quoted text---
