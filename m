Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394B623D41F
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Aug 2020 01:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgHEXQL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Aug 2020 19:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgHEXQJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Aug 2020 19:16:09 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF2EC061756
        for <linux-bcache@vger.kernel.org>; Wed,  5 Aug 2020 16:16:09 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s15so14110050pgc.8
        for <linux-bcache@vger.kernel.org>; Wed, 05 Aug 2020 16:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mX2RQWIeukytd4cMjhvK2ERywuLZIUHHxAhzXb8p2CI=;
        b=RedmrbDYX8xHeYwBAyAMe59kGo6ejds4t+fKQDTHMHVZoIiRoXnp4eetVKZsqZHvwp
         bqEa8dXP/bjqtUXZco7PnDuarFsJZZ+0SOLSAkZe6au6PqS/zfZhse/wsReGuyYCDPoZ
         d/Uh/xAzUKc6Q05Las/S09motL9sXLvpByuOUy+OUqik3Konpp/RoaoMOO5PbFlA06GR
         2gpNpMxRLB6FIWqnW8q5bysp7XVnQrsC9pPMu0IVvfJIfQn79jx6r94rbbHt4SWz+SGE
         Ps2M5P4EPLv6QpD0+ajMO5TjQEgHAl4iANb5kH+o9uXBTGe1IWue0N+6UoZ/nVp6B8CJ
         fXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mX2RQWIeukytd4cMjhvK2ERywuLZIUHHxAhzXb8p2CI=;
        b=TFYNZjSl2NAloqNwbjid+p5cS83C8TBcyAZzPI86HlfGPsRSJYMYZynzwMex2OL2oJ
         iPtJzJ8yMublCgEXy9L11YM5VIa99V8a4N8LJuqo/uRT4W3Spp8pun1AFz4r6xv+84nX
         l+pxge4+D0fL2n6cvGFySXGSyvqyBRnhnozkNTyODvnLlaAi+InR6nfFLwONuh0lz+4f
         E0VzlNluiBR++2Sv7EjAzvAQ9HI2+F3Lp+aiuR1KlaLrPSMsFciMv2IAjK8O1hsQsmmR
         /kVTO1OF2JP3V4UOUuvnXsigTBK2RrHFoj6jqHs3nSB5io6IEA/YlYpp1daUDzIxEjem
         uj3g==
X-Gm-Message-State: AOAM530xDPcr/6kPn/nZx3eVEylJnFTZsgICPLKTtqCcUZU3ca9wKWyE
        Yvlqad05Pnejb7qE71gTKCd9nw==
X-Google-Smtp-Source: ABdhPJxdhapAiWis8V0esUSVfVlcLDvYs+fpc50sa9uce/UQJLnj8/1rVj6gBsGtyKYnT4OhMkVUCw==
X-Received: by 2002:aa7:9241:: with SMTP id 1mr5877013pfp.188.1596669368189;
        Wed, 05 Aug 2020 16:16:08 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e4sm5160490pfd.204.2020.08.05.16.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 16:16:07 -0700 (PDT)
Subject: Re: [PATCH v4] block: check queue's limits.discard_granularity in
 __blkdev_issue_discard()
To:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Evan Green <evgreen@chromium.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiao Ni <xni@redhat.com>
References: <20200805172503.45121-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fd22ada6-0ed9-aeed-94a7-561cd923dbbd@kernel.dk>
Date:   Wed, 5 Aug 2020 17:16:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805172503.45121-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/5/20 11:25 AM, Coly Li wrote:
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

Applied, thanks.

-- 
Jens Axboe

