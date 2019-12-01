Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61A4010DFF6
	for <lists+linux-bcache@lfdr.de>; Sun,  1 Dec 2019 01:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfLAAwm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 30 Nov 2019 19:52:42 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:43709 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbfLAAwm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Nov 2019 19:52:42 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id F0BCFA0633;
        Sun,  1 Dec 2019 00:52:41 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Qdt5XMol8JjS; Sun,  1 Dec 2019 00:52:11 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 309E3A0440;
        Sun,  1 Dec 2019 00:52:11 +0000 (UTC)
Date:   Sun, 1 Dec 2019 00:52:10 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     linux-bcache@vger.kernel.org
Subject: Re: Backport bcache v5.5 to v4.19
In-Reply-To: <alpine.LRH.2.11.1911302229090.31846@mx.ewheeler.net>
Message-ID: <alpine.LRH.2.11.1912010047050.31846@mx.ewheeler.net>
References: <alpine.LRH.2.11.1911302229090.31846@mx.ewheeler.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, 30 Nov 2019, Eric Wheeler wrote:

> Hi Coly,
> 
> We use 4.19.y and there have been many performance and stability changes 
> since then.  I'm considering backporting the 5.4 version into 4.19 and 
> wondered:
> 
> Are there any changes in bcache between 4.19 and 5.4 that depend on new 
> features elsewhere in the kernel, or should I basically be able to copy 
> the tree from 5.4 to 4.19 and fix minor compilation issues?
> 
> Can you think of any issues that would arise from such a backport?

I'm cherry-picking the following into 4.19.86 for our own testing.  I 
reviewed them and they look safe, but let me know if you see something 
that should be excluded.

-Eric

########  testing backports from 5.4.1 for 4.19.86 ######## 

I diff'ed the git log --oneline's from v4.19..v4.19.86 and v4.19..v5.4 and 
excluded the duplicates, this is what remained:

752f66a bcache: use REQ_PRIO to indicate bio for metadata
4516da4 bcache: fix typo in code comments of closure_return_with_destructor()
3fd3c5c bcache: remove unused bch_passthrough_cache
91bafdf bcache: remove useless parameter of bch_debug_init()
8792099 bcache: use MAX_CACHES_PER_SET instead of magic number 8 in __bch_bucket_alloc_set
f6027bc bcache: split combined if-condition code into separate ones
3a646fd bcache: panic fix for making cache device
d2f96f4 bcache: add comment for cache_set->fill_iter
ae17102 bcache: do not check if debug dentry is ERR or NULL explicitly on remove
3db4d07 bcache: update comment for bch_data_insert
4e361e0 bcache: update comment in sysfs.c
79b7914 bcache: do not mark writeback_running too early
f383ae3 bcache: cannot set writeback_running via sysfs if no writeback kthread created
cb07ad6 bcache: introduce force_wake_up_gc()
7a671d8 bcache: option to automatically run gc thread after writeback
009673d bcache: add MODULE_DESCRIPTION information
9aaf516 bcache: make cutoff_writeback and cutoff_writeback_sync tunable
cc38ca7 bcache: set writeback_percent in a flexible range
e78bd0d bcache: print number of keys in trace_bcache_journal_write
83ff9318 bcache: not use hard coded memset size in bch_cache_accounting_clear()
926d194 bcache: export backing_dev_name via sysfs
d461045 bcache: export backing_dev_uuid via sysfs
e8cf978 bcache: fix indentation issue, remove tabs on a hunk of code
f54478c bcache: fix input integer overflow of congested threshold
e4db37f bcache: add sysfs_strtoul_bool() for setting bit-field variables
f5c0b95 bcache: use sysfs_strtoul_bool() to set bit-field variables
369d21a bcache: fix input overflow to writeback_delay
453745f bcache: fix input overflow to journal_delay_ms
b150084 bcache: fix input overflow to cache set io_error_limit
2e1f4f4 bcache: avoid to use bio_for_each_segment_all() in bch_bio_alloc_pages()
1568ee7 bcache: fix crashes stopping bcache device before read miss done
4e0c04e bcache: fix inaccurate result of unused buckets
792732d bcache: use kmemdup_nul for CACHED_LABEL buffer
3a39472 bcache: Clean up bch_get_congested()
14215ee bcache: move definition of 'int ret' out of macro read_bucket()
2d17456 bcache: add comments for kobj release callback routine
88c12d4 bcache: add error check for calling register_bdev()
bb6d355 bcache: Add comments for blkdev_put() in registration code path
63d63b5 bcache: add comments for closure_fn to be called in closure_queue()
eb8cbb6 bcache: improve bcache_reboot()
f16277c bcache: fix wrong usage use-after-freed on keylist in out_nocoalesce branch of btree_gc_coalesce
f936b06 bcache: clean up do_btree_node_write a bit
2d5abb9 bcache: make is_discard_enabled() static
141df8b bcache: don't set max writeback rate if gc is running
0ae49cb bcache: fix return value error in bch_journal_read()
e6dcbd3 bcache: avoid flushing btree node in cache_set_flush() if io disabled
08ec1e6 bcache: add io error counting in write_bdev_super_endio()
f960fac bcache: remove unnecessary prefetch() in bset_search_tree()
89e0341 bcache: use sysfs_match_string() instead of __sysfs_match_string()
0b13efe bcache: add return value check to bch_cached_dev_run()
bd9026c bcache: remove unncessary code in bch_btree_keys_init()
4b6efb4 bcache: more detailed error message to bcache_device_link()
633bb2c bcache: add more error message in bch_cached_dev_attach()
e0faa3d bcache: improve error message in bch_cached_dev_run()
68a53c9 bcache: remove "XXX:" comment line from run_cache_set()
944a4f3 bcache: make bset_search_tree() be more understandable
0c277e2 bcache: add pendings_cleanup to stop pending bcache device
5c2a634 bcache: stop writeback kthread and kworker when bch_cached_dev_run() failed
a59ff6c bcache: avoid a deadlock in bcache_reboot()
97ba3b8 bcache: acquire bch_register_lock later in cached_dev_detach_finish()
2464b69 bcache: add code comments for journal_read_bucket()
a231f07 bcache: set largest seq to ja->seq[bucket_index] in journal_read_bucket()
1df3877 bcache: shrink btree node cache after bch_btree_check()
d91ce75 bcache: remove retry_flush_write from struct cache_set
91be66e bcache: performance improvement for btree_flush_write()
dff90d5 bcache: add reclaimed_journal_buckets to struct cache_set
5d9e06d bcache: fix possible memory leak in bch_cached_dev_run()
20621fe bcache: Revert "bcache: use sysfs_match_string() instead of __sysfs_match_string()"
d55a4ae bcache: add cond_resched() in __bch_cache_cmp()
d66c992 bcache: Fix an error code in bch_dump_read()

# excluded these (from 5.4), they don't make sense for 4.19 because 
# bio_for_each_segment_all() hadn't changed yet:
2b070cf block: remove the i argument to bio_for_each_segment_all
6dc4f10 block: allow bio_for_each_segment_all() to iterate over multi-page bvec
f936b06 bcache: clean up do_btree_node_write a bit
ec8f24b treewide: Add SPDX license identifier - Makefile/Kconfig


######## testing backports from 5.5 for 4.19.86 ########

]# git log --oneline v5.4..linus/master drivers/md/bcache/ |tac

34cf78b bcache: fix a lost wake-up problem caused by mca_cannibalize_lock
2d88695 bcache: fix static checker warning in bcache_device_free()
aaf8dbe bcache: add more accurate error messages in read_super()
41fa4de bcache: deleted code comments for dead code in bch_data_insert_keys()
06c1526 bcache: add code comment bch_keylist_pop() and bch_keylist_pop_front()
84c529a bcache: fix deadlock in bcache_allocator
5dccefd bcache: add code comments in bch_btree_leaf_dirty()
c5fcded bcache: add idle_max_writeback_rate sysfs interface
9fcc34b bcache: at least try to shrink 1 node in bch_mca_scan()
651bbba bcache: remove the extra cflags for request.o
15fbb23 bcache: don't export symbols

# excluded these (from 5.5):
c0e0954 bcache: fix fifo index swapping condition in journal_pin_cmp()
00b8989 Revert "bcache: fix fifo index swapping condition in journal_pin_cmp()"


--
Eric Wheeler
