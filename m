Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C5523D323
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Aug 2020 22:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgHEUgF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Aug 2020 16:36:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbgHEUgD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Aug 2020 16:36:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 075FmSsH177468;
        Wed, 5 Aug 2020 15:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=j6PDDC/Mn/spTqWrjmibfzc15MJWahsDJABkuGlXOL8=;
 b=pKfbdaR1rm6EexkfUXMute1LqT50Jj8as1sABST78bRKCEEgG3nIT0PcMsMSeSWpB2DE
 vgRfTz2tZ+wUJfFHRK2FLgt1OkjkHQ5yl5ccyEm/t/+y+ZtAZxaLNUN06K6uT1yoi0UR
 KKIjiYEsN3rSOxgy9Vv4Bhjt9cXL/jLoQlGlg8EjPM/Cir0iTN8zivyH+Z5IzY5cOKmf
 lZN+cHfyXETqdEOgEL/8leGIVp3cd7RW722uy1OsLV/XVABEHG0ZUsKK/guUoPWM1qsw
 zHKv7arRrdoOKBxTe25AXv8RkfCTvr9aiS0RWCUUSjCPrGrstJX1prYRmw3vrDxL3/uc bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32n11naua7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 15:48:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 075FljmT139364;
        Wed, 5 Aug 2020 15:48:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32qyaa143y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 15:48:49 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 075Fmj4g003269;
        Wed, 5 Aug 2020 15:48:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Aug 2020 08:48:45 -0700
Date:   Wed, 5 Aug 2020 08:48:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Evan Green <evgreen@chromium.org>,
        Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH v3] block: check queue's limits.discard_granularity in
 __blkdev_issue_discard()
Message-ID: <20200805154843.GB191798@magnolia>
References: <20200805063150.41037-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805063150.41037-1-colyli@suse.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=1
 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=1 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050128
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Aug 05, 2020 at 02:31:50PM +0800, Coly Li wrote:
> If create a loop device with a backing NVMe SSD, current loop device
> driver doesn't correctly set its  queue's limits.discard_granularity and
> leaves it as 0. If a discard request at LBA 0 on this loop device, in
> __blkdev_issue_discard() the calculated req_sects will be 0, and a zero
> length discard request will trigger a BUG() panic in generic block layer
> code at block/blk-mq.c:563.
> 
> [  955.565006][   C39] ------------[ cut here ]------------
> [  955.559660][   C39] invalid opcode: 0000 [#1] SMP NOPTI
> [  955.622171][   C39] CPU: 39 PID: 248 Comm: ksoftirqd/39 Tainted: G            E     5.8.0-default+ #40
> [  955.622171][   C39] Hardware name: Lenovo ThinkSystem SR650 -[7X05CTO1WW]-/-[7X05CTO1WW]-, BIOS -[IVE160M-2.70]- 07/17/2020
> [  955.622175][   C39] RIP: 0010:blk_mq_end_request+0x107/0x110
> [  955.622177][   C39] Code: 48 8b 03 e9 59 ff ff ff 48 89 df 5b 5d 41 5c e9 9f ed ff ff 48 8b 35 98 3c f4 00 48 83 c7 10 48 83 c6 19 e8 cb 56 c9 ff eb cb <0f> 0b 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 56 41 54
> [  955.622179][   C39] RSP: 0018:ffffb1288701fe28 EFLAGS: 00010202
> [  955.749277][   C39] RAX: 0000000000000001 RBX: ffff956fffba5080 RCX: 0000000000004003
> [  955.749278][   C39] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000000
> [  955.749279][   C39] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> [  955.749279][   C39] R10: ffffb1288701fd28 R11: 0000000000000001 R12: ffffffffa8e05160
> [  955.749280][   C39] R13: 0000000000000004 R14: 0000000000000004 R15: ffffffffa7ad3a1e
> [  955.749281][   C39] FS:  0000000000000000(0000) GS:ffff95bfbda00000(0000) knlGS:0000000000000000
> [  955.749282][   C39] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  955.749282][   C39] CR2: 00007f6f0ef766a8 CR3: 0000005a37012002 CR4: 00000000007606e0
> [  955.749283][   C39] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  955.749284][   C39] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  955.749284][   C39] PKRU: 55555554
> [  955.749285][   C39] Call Trace:
> [  955.749290][   C39]  blk_done_softirq+0x99/0xc0
> [  957.550669][   C39]  __do_softirq+0xd3/0x45f
> [  957.550677][   C39]  ? smpboot_thread_fn+0x2f/0x1e0
> [  957.550679][   C39]  ? smpboot_thread_fn+0x74/0x1e0
> [  957.550680][   C39]  ? smpboot_thread_fn+0x14e/0x1e0
> [  957.550684][   C39]  run_ksoftirqd+0x30/0x60
> [  957.550687][   C39]  smpboot_thread_fn+0x149/0x1e0
> [  957.886225][   C39]  ? sort_range+0x20/0x20
> [  957.886226][   C39]  kthread+0x137/0x160
> [  957.886228][   C39]  ? kthread_park+0x90/0x90
> [  957.886231][   C39]  ret_from_fork+0x22/0x30
> [  959.117120][   C39] ---[ end trace 3dacdac97e2ed164 ]---
> 
> This is the procedure to reproduce the panic,
>   # modprobe scsi_debug delay=0 dev_size_mb=2048 max_queue=1
>   # losetup -f /dev/nvme0n1 --direct-io=on
>   # blkdiscard /dev/loop0 -o 0 -l 0x200
> 
> This patch fixes the issue by checking q->limits.discard_granularity in
> __blkdev_issue_discard() before composing the discard bio. If the value
> is 0, then prints a warning oops information and returns -EOPNOTSUPP to
> the caller to indicate that this buggy device driver doesn't support
> discard request.
> 
> Fixes: 9b15d109a6b2 ("block: improve discard bio alignment in __blkdev_issue_discard()")
> Fixes: c52abf563049 ("loop: Better discard support for block devices")
> Reported-and-suggested-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Enzo Matsumiya <ematsumiya@suse.com>
> Cc: Evan Green <evgreen@chromium.org>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Xiao Ni <xni@redhat.com>
> ---
> Changelog:
> v3: print device name assocated with the buggy driver.
> v2: fix typo of the wrong return error code.
> v1: first version.
> 
>  block/blk-lib.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 019e09bb9c0e..d3bbb3d9fac3 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -47,6 +47,15 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  		op = REQ_OP_DISCARD;
>  	}
>  
> +	/* In case the discard granularity isn't set by buggy device driver */
> +	if (WARN_ON_ONCE(!q->limits.discard_granularity)) {
> +		char dev_name[BDEVNAME_SIZE];
> +
> +		bdevname(bdev, dev_name);
> +		pr_err("%s: Error: discard_granularity is 0.\n", dev_name);

Hm, you might want to ratelimit this, before some buggy device +
careless program flood dmesg.

Also, why is it necessary to WARN_ON_ONCE /and/ pr_err the same
condition?

--D

> +		return -EOPNOTSUPP;
> +	}
> +
>  	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
>  	if ((sector | nr_sects) & bs_mask)
>  		return -EINVAL;
> -- 
> 2.26.2
> 
