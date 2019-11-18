Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2598F10091A
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Nov 2019 17:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfKRQVj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Nov 2019 11:21:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:43242 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726322AbfKRQVj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Nov 2019 11:21:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C6ADB1D6;
        Mon, 18 Nov 2019 16:21:37 +0000 (UTC)
Subject: Re: [ 186.758123] kernel BUG at drivers/md/bcache/writeback.c:324!
To:     Marc Smith <msmith626@gmail.com>
References: <CAH6h+hdWRN-wG9_JJoCSfxs55jeTLzE5ia+DK19GPtJA59EXxQ@mail.gmail.com>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <497aac95-c9c9-61e7-edc1-c38154f1e881@suse.de>
Date:   Tue, 19 Nov 2019 00:21:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAH6h+hdWRN-wG9_JJoCSfxs55jeTLzE5ia+DK19GPtJA59EXxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/11/14 3:46 上午, Marc Smith wrote:
> Hi,
> 
> I'm using bcache on Linux 4.14.154 and I'm hitting a BUG_ON() in
> writeback.c, which occurs quite a bit on my systems (using write-back
> mode). This occurs typically after the backing device is assembled,
> and the bcache udev rule registers it. Here are the kernel messages
> when this occurs:
> 
> [  186.463146] md: md126 stopped.
> [  186.475151] md/raid:md126: device sdc operational as raid disk 0
> [  186.475155] md/raid:md126: device sdn operational as raid disk 11
> [  186.475157] md/raid:md126: device sdm operational as raid disk 10
> [  186.475158] md/raid:md126: device sdl operational as raid disk 9
> [  186.475160] md/raid:md126: device sdk operational as raid disk 8
> [  186.475161] md/raid:md126: device sdj operational as raid disk 7
> [  186.475163] md/raid:md126: device sdi operational as raid disk 6
> [  186.475165] md/raid:md126: device sdh operational as raid disk 5
> [  186.475166] md/raid:md126: device sdg operational as raid disk 4
> [  186.475168] md/raid:md126: device sdf operational as raid disk 3
> [  186.475169] md/raid:md126: device sde operational as raid disk 2
> [  186.475170] md/raid:md126: device sdd operational as raid disk 1
> [  186.476349] md/raid:md126: raid level 6 active with 12 out of 12
> devices, algorithm 2
> [  186.487142] md126: detected capacity change from 0 to 12001083392000
> [  186.745889] bcache: register_bdev() registered backing device md126
> [  186.757725] bcache: bch_cached_dev_attach() Caching md126 as
> bcache0 on set 81c4d4e3-4feb-4f88-8fcb-00f367e69906
> [  186.758120] ------------[ cut here ]------------
> [  186.758123] kernel BUG at drivers/md/bcache/writeback.c:324!
> [  186.758128] invalid opcode: 0000 [#1] SMP NOPTI
> [  186.758301] Modules linked in: qla2xxx(O) bonding ntb_transport
> ntb_hw_switchtec(OE) cls_switchtec(OE) mlx5_ib mlx5_core bna ib_umad
> rdma_ucm rdma_cm iw_cm ib_uverbs ib_srp ib_cm iw_nes iw_cxgb4 cxgb4
> iw_cxgb3 ib_qib rdmavt mlx4_ib mlx4_core ib_mthca ib_core
> [  186.758741] CPU: 13 PID: 2109 Comm: bcache_writebac Tainted: G
>      OE   4.14.154-esos.prod #1
> [  186.758945] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [  186.759101] task: ffff888327af0000 task.stack: ffffc90003014000
> [  186.759262] RIP: 0010:dirty_pred+0x17/0x21
> [  186.759391] RSP: 0018:ffffc90003017ca0 EFLAGS: 00010202
> [  186.759537] RAX: 9000001000200002 RBX: ffff888329840b90 RCX: 0000000000000003
> [  186.760235] RDX: 0000000000000002 RSI: ffff888327b01f10 RDI: ffff888329840b90
> [  186.760922] RBP: ffff888327b01f10 R08: 0000000000000000 R09: 000007ffffffffff
> [  186.761603] R10: 0000000000000001 R11: 0000000000000001 R12: ffffc90003017dd8
> [  186.762289] R13: 0000000000000000 R14: ffff88842b503800 R15: ffff88842b5038c8
> [  186.762977] FS:  0000000000000000(0000) GS:ffff88842f540000(0000)
> knlGS:0000000000000000
> [  186.764185] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  186.764856] CR2: 00007f5fd478ee80 CR3: 00000003af48a000 CR4: 00000000000006e0
> [  186.765541] Call Trace:
> [  186.766160]  refill_keybuf_fn+0x64/0x19b
> [  186.766799]  ? bch_btree_gc_finish+0x2b9/0x2b9
> [  186.767441]  bch_btree_map_keys_recurse+0x6a/0x140
> [  186.768983]  bch_btree_map_keys+0x98/0xfb
> [  186.769626]  ? bch_btree_gc_finish+0x2b9/0x2b9
> [  186.770269]  ? write_dirty+0xcb/0xcb
> [  186.770904]  bch_refill_keybuf+0xa0/0x1ab
> [  186.771544]  ? wait_woken+0x6a/0x6a
> [  186.772178]  ? write_dirty+0xcb/0xcb
> [  186.772812]  bch_writeback_thread+0x2a8/0x73d
> [  186.773458]  ? __switch_to+0x31b/0x342
> [  186.774096]  ? read_dirty_submit+0x55/0x55
> [  186.774744]  kthread+0x117/0x11f
> [  186.775369]  ? kthread_create_on_node+0x36/0x36
> [  186.776019]  ret_from_fork+0x35/0x40
> [  186.776656] Code: 5b be 01 00 00 20 48 c7 45 18 20 73 a2 81 5d e9
> 2d 0a ff ff 48 8b 06 8b 8f f8 f4 ff ff 48 89 c2 81 e2 ff ff 0f 00 48
> 39 d1 74 02 <0f> 0b 48 c1 e8 24 83 e0 01 c3 55 48 89 fd f0 ff 47 28 48
> 83 c7
> [  186.778552] RIP: dirty_pred+0x17/0x21 RSP: ffffc90003017ca0
> [  186.779240] ---[ end trace f9cfb637b4062277 ]---
> 
> 
> I had experienced this same issue on 4.14.120 as well. I noticed some
> bug fixes since that patch release so I updated to .154 but the issue
> still persists. Perhaps it's worth noting this kernel is built with
> GCC 9.x -- I saw another patch for a stack corruption issue involving
> GCC 9.x (4.14.128).
> 
> The 4.14.154 kernel is vanilla from 'kernel.org' (not a distro variant).
> 
> Any hints on where to start would be greatly appreciated.

Hi Marc,

This is new in my memory. v4.14.154 already has the fix "bcache: fix
stack corruption by PRECEDING_KEY()", so I guess this issue might be new.

Is it possible to try Linux v5.3, or later kernel ? There are quite a
lot fixes from v4.14 to v5.3, if you may still observe the issue from
v5.3, I can try to look into it.

Thanks.

-- 

Coly Li
