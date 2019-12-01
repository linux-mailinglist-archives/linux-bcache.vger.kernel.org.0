Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D3A10E119
	for <lists+linux-bcache@lfdr.de>; Sun,  1 Dec 2019 09:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbfLAIvE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 1 Dec 2019 03:51:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:38096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbfLAIvD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 1 Dec 2019 03:51:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 185DEAE47;
        Sun,  1 Dec 2019 08:51:01 +0000 (UTC)
Subject: Re: Backport bcache v5.5 to v4.19
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org
References: <alpine.LRH.2.11.1911302229090.31846@mx.ewheeler.net>
 <alpine.LRH.2.11.1912010047050.31846@mx.ewheeler.net>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <a87d9c08-c872-2f34-0dd3-6bed5739664f@suse.de>
Date:   Sun, 1 Dec 2019 16:50:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1912010047050.31846@mx.ewheeler.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/1 8:52 上午, Eric Wheeler wrote:
> On Sat, 30 Nov 2019, Eric Wheeler wrote:
> 
>> Hi Coly,
>>
>> We use 4.19.y and there have been many performance and stability changes 
>> since then.  I'm considering backporting the 5.4 version into 4.19 and 
>> wondered:
>>
>> Are there any changes in bcache between 4.19 and 5.4 that depend on new 
>> features elsewhere in the kernel, or should I basically be able to copy 
>> the tree from 5.4 to 4.19 and fix minor compilation issues?
>>
>> Can you think of any issues that would arise from such a backport?
> 
> I'm cherry-picking the following into 4.19.86 for our own testing.  I 
> reviewed them and they look safe, but let me know if you see something 
> that should be excluded.
> 

Hi Eric,

I reply inline for the commits.

> -Eric
> 
> ########  testing backports from 5.4.1 for 4.19.86 ######## 
> 
> I diff'ed the git log --oneline's from v4.19..v4.19.86 and v4.19..v5.4 and 
> excluded the duplicates, this is what remained:
> 
> 752f66a bcache: use REQ_PRIO to indicate bio for metadata
> 4516da4 bcache: fix typo in code comments of closure_return_with_destructor()
> 3fd3c5c bcache: remove unused bch_passthrough_cache
> 91bafdf bcache: remove useless parameter of bch_debug_init()
> 8792099 bcache: use MAX_CACHES_PER_SET instead of magic number 8 in __bch_bucket_alloc_set
> f6027bc bcache: split combined if-condition code into separate ones
> 3a646fd bcache: panic fix for making cache device
> d2f96f4 bcache: add comment for cache_set->fill_iter
> ae17102 bcache: do not check if debug dentry is ERR or NULL explicitly on remove
> 3db4d07 bcache: update comment for bch_data_insert
> 4e361e0 bcache: update comment in sysfs.c
> 79b7914 bcache: do not mark writeback_running too early
> f383ae3 bcache: cannot set writeback_running via sysfs if no writeback kthread created
> cb07ad6 bcache: introduce force_wake_up_gc()
> 7a671d8 bcache: option to automatically run gc thread after writeback
> 009673d bcache: add MODULE_DESCRIPTION information
> 9aaf516 bcache: make cutoff_writeback and cutoff_writeback_sync tunable
> cc38ca7 bcache: set writeback_percent in a flexible range
> e78bd0d bcache: print number of keys in trace_bcache_journal_write
> 83ff9318 bcache: not use hard coded memset size in bch_cache_accounting_clear()
> 926d194 bcache: export backing_dev_name via sysfs
> d461045 bcache: export backing_dev_uuid via sysfs
> e8cf978 bcache: fix indentation issue, remove tabs on a hunk of code
> f54478c bcache: fix input integer overflow of congested threshold
> e4db37f bcache: add sysfs_strtoul_bool() for setting bit-field variables
> f5c0b95 bcache: use sysfs_strtoul_bool() to set bit-field variables
> 369d21a bcache: fix input overflow to writeback_delay
> 453745f bcache: fix input overflow to journal_delay_ms
> b150084 bcache: fix input overflow to cache set io_error_limit
> 2e1f4f4 bcache: avoid to use bio_for_each_segment_all() in bch_bio_alloc_pages()

The above commit was related to a bio layer change, if this patch does
not compile in 4.19, you don't have to have it in the backport.

> 1568ee7 bcache: fix crashes stopping bcache device before read miss done
> 4e0c04e bcache: fix inaccurate result of unused buckets
> 792732d bcache: use kmemdup_nul for CACHED_LABEL buffer
> 3a39472 bcache: Clean up bch_get_congested()
> 14215ee bcache: move definition of 'int ret' out of macro read_bucket()
> 2d17456 bcache: add comments for kobj release callback routine
> 88c12d4 bcache: add error check for calling register_bdev()
> bb6d355 bcache: Add comments for blkdev_put() in registration code path
> 63d63b5 bcache: add comments for closure_fn to be called in closure_queue()
> eb8cbb6 bcache: improve bcache_reboot()
> f16277c bcache: fix wrong usage use-after-freed on keylist in out_nocoalesce branch of btree_gc_coalesce
> f936b06 bcache: clean up do_btree_node_write a bit
> 2d5abb9 bcache: make is_discard_enabled() static
> 141df8b bcache: don't set max writeback rate if gc is running
> 0ae49cb bcache: fix return value error in bch_journal_read()
> e6dcbd3 bcache: avoid flushing btree node in cache_set_flush() if io disabled
> 08ec1e6 bcache: add io error counting in write_bdev_super_endio()
> f960fac bcache: remove unnecessary prefetch() in bset_search_tree()
> 89e0341 bcache: use sysfs_match_string() instead of __sysfs_match_string()
> 0b13efe bcache: add return value check to bch_cached_dev_run()
> bd9026c bcache: remove unncessary code in bch_btree_keys_init()
> 4b6efb4 bcache: more detailed error message to bcache_device_link()
> 633bb2c bcache: add more error message in bch_cached_dev_attach()
> e0faa3d bcache: improve error message in bch_cached_dev_run()
> 68a53c9 bcache: remove "XXX:" comment line from run_cache_set()
> 944a4f3 bcache: make bset_search_tree() be more understandable
> 0c277e2 bcache: add pendings_cleanup to stop pending bcache device
> 5c2a634 bcache: stop writeback kthread and kworker when bch_cached_dev_run() failed
> a59ff6c bcache: avoid a deadlock in bcache_reboot()
> 97ba3b8 bcache: acquire bch_register_lock later in cached_dev_detach_finish()
> 2464b69 bcache: add code comments for journal_read_bucket()
> a231f07 bcache: set largest seq to ja->seq[bucket_index] in journal_read_bucket()
> 1df3877 bcache: shrink btree node cache after bch_btree_check()
> d91ce75 bcache: remove retry_flush_write from struct cache_set
> 91be66e bcache: performance improvement for btree_flush_write()
> dff90d5 bcache: add reclaimed_journal_buckets to struct cache_set
> 5d9e06d bcache: fix possible memory leak in bch_cached_dev_run()
> 20621fe bcache: Revert "bcache: use sysfs_match_string() instead of __sysfs_match_string()"
> d55a4ae bcache: add cond_resched() in __bch_cache_cmp()
> d66c992 bcache: Fix an error code in bch_dump_read()
> 
> # excluded these (from 5.4), they don't make sense for 4.19 because 
> # bio_for_each_segment_all() hadn't changed yet:
> 2b070cf block: remove the i argument to bio_for_each_segment_all
> 6dc4f10 block: allow bio_for_each_segment_all() to iterate over multi-page bvec
> f936b06 bcache: clean up do_btree_node_write a bit
> ec8f24b treewide: Add SPDX license identifier - Makefile/Kconfig
> 
> 
> ######## testing backports from 5.5 for 4.19.86 ########
> 
> ]# git log --oneline v5.4..linus/master drivers/md/bcache/ |tac
> 
> 34cf78b bcache: fix a lost wake-up problem caused by mca_cannibalize_lock
> 2d88695 bcache: fix static checker warning in bcache_device_free()
> aaf8dbe bcache: add more accurate error messages in read_super()
> 41fa4de bcache: deleted code comments for dead code in bch_data_insert_keys()
> 06c1526 bcache: add code comment bch_keylist_pop() and bch_keylist_pop_front()
> 84c529a bcache: fix deadlock in bcache_allocator
> 5dccefd bcache: add code comments in bch_btree_leaf_dirty()
> c5fcded bcache: add idle_max_writeback_rate sysfs interface
> 9fcc34b bcache: at least try to shrink 1 node in bch_mca_scan()
> 651bbba bcache: remove the extra cflags for request.o
> 15fbb23 bcache: don't export symbols
> 
> # excluded these (from 5.5):
> c0e0954 bcache: fix fifo index swapping condition in journal_pin_cmp()
> 00b8989 Revert "bcache: fix fifo index swapping condition in journal_pin_cmp()"
>The above two patches can be ignored, they are necessary.

-- 

Coly Li
