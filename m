Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F009BE5FE
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Sep 2019 22:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbfIYUBs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 25 Sep 2019 16:01:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbfIYUBs (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 Sep 2019 16:01:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C344C10DCC8C;
        Wed, 25 Sep 2019 20:01:47 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D54DD6012C;
        Wed, 25 Sep 2019 20:01:39 +0000 (UTC)
Date:   Wed, 25 Sep 2019 16:01:39 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Eric Wheeler <dm-devel@lists.ewheeler.net>, ejt@redhat.com
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org, lvm-devel@redhat.com
Subject: Re: kernel BUG at drivers/md/persistent-data/dm-space-map-disk.c:178
 with scsi_mod.use_blk_mq=y
Message-ID: <20190925200138.GA20584@redhat.com>
References: <alpine.LRH.2.11.1909251814220.15810@mx.ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1909251814220.15810@mx.ewheeler.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Wed, 25 Sep 2019 20:01:47 +0000 (UTC)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Sep 25 2019 at  2:40pm -0400,
Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:

> Hello,
> 
> We are using the 4.19.75 stable tree with dm-thin and multi-queue scsi.  
> We have been using the 4.19 branch for months without issue; we just 
> switched to MQ and we seem to have hit this BUG_ON.  Whether or not MQ is 
> related to the issue, I don't know, maybe coincidence:
> 
> 	static int sm_disk_new_block(struct dm_space_map *sm, dm_block_t *b)
> 	{
> 	    int r;
> 	    enum allocation_event ev;
> 	    struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
> 
> 	    /* FIXME: we should loop round a couple of times */
> 	    r = sm_ll_find_free_block(&smd->old_ll, smd->begin, smd->old_ll.nr_blocks, b);
> 	    if (r)
> 		return r;
> 
> 	    smd->begin = *b + 1;
> 	    r = sm_ll_inc(&smd->ll, *b, &ev);
> 	    if (!r) {
> 		BUG_ON(ev != SM_ALLOC); <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
> 		smd->nr_allocated_this_transaction++;
> 	    }
> 
> 	    return r;
> 	}
> 
> This is a brand-new thin pool created about 12 hours ago:
> 
>   lvcreate -c 64k -L 12t --type thin-pool --thinpool data-pool --poolmetadatasize 16G data /dev/bcache0
> 
> We are using bcache, but I don't see any bcache code in the backtraces.  
> The metadata is also on the bcache volume.

So bcache is be used for both data and metadata.
 
> We were transferring data to the new thin volumes and it ran for about 12 
> hours and then gave the trace below.  So far it has only happened once 
> and I don't have a way to reproduce it.
> 
> Any idea what this BUG_ON would indicate and how we might contrive a fix?
>
> [199391.677689] ------------[ cut here ]------------
> [199391.678437] kernel BUG at drivers/md/persistent-data/dm-space-map-disk.c:178!
> [199391.679183] invalid opcode: 0000 [#1] SMP NOPTI
> [199391.679941] CPU: 4 PID: 31359 Comm: kworker/u16:4 Not tainted 4.19.75 #1
> [199391.680683] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.2 02/20/2015
> [199391.681446] Workqueue: dm-thin do_worker [dm_thin_pool]
> [199391.682187] RIP: 0010:sm_disk_new_block+0xa0/0xb0 [dm_persistent_data]
> [199391.682929] Code: 22 00 00 49 8b 34 24 e8 4e f9 ff ff 85 c0 75 11 83 7c 24 04 01 75 13 48 83 83 28 22 00 00 01 eb af 89 c5 eb ab e8 e0 95 9b e0 <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
> [199391.684432] RSP: 0018:ffffc9000a147c88 EFLAGS: 00010297
> [199391.685186] RAX: 0000000000000000 RBX: ffff8887ceed8000 RCX: 0000000000000000
> [199391.685936] RDX: ffff8887d093ac80 RSI: 0000000000000246 RDI: ffff8887faab0a00
> [199391.686659] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8887faab0a98
> [199391.687379] R10: ffffffff810f8077 R11: 0000000000000000 R12: ffffc9000a147d58
> [199391.688120] R13: ffffc9000a147d58 R14: 00000000ffffffc3 R15: 000000000014bbc0
> [199391.688843] FS:  0000000000000000(0000) GS:ffff88880fb00000(0000) knlGS:0000000000000000
> [199391.689571] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [199391.690253] CR2: 00007f5ae49a1000 CR3: 000000000200a003 CR4: 00000000001626e0
> [199391.690984] Call Trace:
> [199391.691714]  dm_pool_alloc_data_block+0x3f/0x60 [dm_thin_pool]
> [199391.692411]  alloc_data_block.isra.52+0x6d/0x1e0 [dm_thin_pool]
> [199391.693142]  process_cell+0x2a3/0x550 [dm_thin_pool]
> [199391.693852]  ? sort+0x17b/0x270
> [199391.694527]  ? u32_swap+0x10/0x10
> [199391.695192]  do_worker+0x268/0x9a0 [dm_thin_pool]
> [199391.695890]  process_one_work+0x171/0x370
> [199391.696640]  worker_thread+0x49/0x3f0
> [199391.697332]  kthread+0xf8/0x130
> [199391.697988]  ? max_active_store+0x80/0x80
> [199391.698659]  ? kthread_bind+0x10/0x10
> [199391.699281]  ret_from_fork+0x1f/0x40

The stack shows the call to sm_disk_new_block() is due to
dm_pool_alloc_data_block().

sm_disk_new_block()'s BUG_ON(ev != SM_ALLOC) indicates that somehow it is
getting called without the passed 'ev' being set to SM_ALLOC.  Only
drivers/md/persistent-dat/dm-space-map-common.c:sm_ll_mutate() sets
SM_ALLOC. sm_disk_new_block() is indirectly calling sm_ll_mutate()

sm_ll_mutate() will only return 0 if ll->save_ie() does, the ll_disk *ll
should be ll_disk, and so disk_ll_save_ie()'s call to dm_btree_insert()
returns 0 -- which simply means success.  And on success
sm_disk_new_block() assumes ev was set to SM_ALLOC (by sm_ll_mutate).

sm_ll_mutate() decided to _not_ set SM_ALLOC because either:
1) ref_count wasn't set
or
2) old was identified

So all said: somehow a new data block was found to already be in use.
_WHY_ that is the case isn't clear from this stack...

But it does speak to the possibility of data block allocation racing
with other operations to the same block.  Which implies missing locking.

But that's all I've got so far... I'll review past dm-thinp changes with
all this in mind and see what turns up.  But Joe Thornber (ejt) likely
needs to have a look at this too.

But could it be that bcache is the source of the data device race (same
block used concurrently)?  And DM thinp is acting as the canary in the
coal mine?

Thanks,
Mike
