Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5F45C0BAA
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Sep 2019 20:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfI0Spm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Sep 2019 14:45:42 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:56438 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbfI0Spi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Sep 2019 14:45:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 09FCBA0692;
        Fri, 27 Sep 2019 18:45:37 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id YyPqUFVX106N; Fri, 27 Sep 2019 18:45:36 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id EAD11A067D;
        Fri, 27 Sep 2019 18:45:35 +0000 (UTC)
Date:   Fri, 27 Sep 2019 18:45:33 +0000 (UTC)
From:   Eric Wheeler <dm-devel@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Joe Thornber <thornber@redhat.com>
cc:     Mike Snitzer <snitzer@redhat.com>, ejt@redhat.com,
        Coly Li <colyli@suse.de>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        lvm-devel@redhat.com, joe.thornber@gmail.com
Subject: Re: kernel BUG at drivers/md/persistent-data/dm-space-map-disk.c:178
 with scsi_mod.use_blk_mq=y
In-Reply-To: <20190927083239.xy6jwbkbektwqu3h@reti>
Message-ID: <alpine.LRH.2.11.1909271819450.20939@mx.ewheeler.net>
References: <alpine.LRH.2.11.1909251814220.15810@mx.ewheeler.net> <20190925200138.GA20584@redhat.com> <alpine.LRH.2.11.1909261819300.15810@mx.ewheeler.net> <20190927083239.xy6jwbkbektwqu3h@reti>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 27 Sep 2019, Joe Thornber wrote:

> Hi Eric,
> 
> On Thu, Sep 26, 2019 at 06:27:09PM +0000, Eric Wheeler wrote:
> > I pvmoved the tmeta to an SSD logical volume (dm-linear) on a non-bcache 
> > volume and we got the same trace this morning, so while the tdata still 
> > passes through bcache, all meta operations are direct to an SSD. This is 
> > still using multi-queue scsi, but dm_mod.use_blk_mq=N.
> > 
> > Since bcache is no longer involved with metadata operations, and since 
> > this appears to be a metadata issue, are there any other reasons to 
> > suspect bcache?
> 
> Did you recreate the pool, or are you just using the existing pool but with
> a different IO path?  If it's the latter then there could still be something
> wrong with the metadata, introduced while bcache was in the stack.

We did not create the pool after the initial problem, though the pool was 
new just before the problem occurred. 
 
> Would it be possible to send me a copy of the metadata device please so
> I can double check the space maps (I presume you've run thin_check on it)?

~]# /usr/local/bin/thin_check /dev/mapper/data-data--pool_tmeta 
examining superblock
TRANSACTION_ID=2347
METADATA_FREE_BLOCKS=4145151
examining devices tree
examining mapping tree
checking space map counts

~]# echo $?
0

~]# /usr/local/bin/thin_check -V
0.8.5

> [Assuming you're using the existing pool] Another useful experiment would be to 
> thump_dump and then thin_restore the metadata, which will create totally fresh
> metadata and see if you can still reproduce the issue.

It didn't lockup last night, but I'll keep working to reproduce the 
problem and let you know what we find.

Mike said it could be a race:

> The stack shows the call to sm_disk_new_block() is due to
> dm_pool_alloc_data_block().
> 
> sm_disk_new_block()'s BUG_ON(ev != SM_ALLOC) indicates that somehow it is
> getting called without the passed 'ev' being set to SM_ALLOC.  Only
> drivers/md/persistent-dat/dm-space-map-common.c:sm_ll_mutate() sets
> SM_ALLOC. sm_disk_new_block() is indirectly calling sm_ll_mutate()
> 
> sm_ll_mutate() will only return 0 if ll->save_ie() does, the ll_disk *ll
> should be ll_disk, and so disk_ll_save_ie()'s call to dm_btree_insert()
> returns 0 -- which simply means success.  And on success
> sm_disk_new_block() assumes ev was set to SM_ALLOC (by sm_ll_mutate).
> 
> sm_ll_mutate() decided to _not_ set SM_ALLOC because either:
> 1) ref_count wasn't set
> or
> 2) old was identified
> 
> So all said: somehow a new data block was found to already be in use.
> _WHY_ that is the case isn't clear from this stack...
>
> But it does speak to the possibility of data block allocation racing
> with other operations to the same block.  Which implies missing locking.

Would a spinlock on the block solve the issue?

Where might such a spinlock be added?


--
Eric Wheeler


> 
> Thanks,
> 
> - Joe
> 
