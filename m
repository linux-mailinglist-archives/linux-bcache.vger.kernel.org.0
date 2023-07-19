Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244F2758B80
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jul 2023 04:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjGSCrc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 18 Jul 2023 22:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjGSCrb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Jul 2023 22:47:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F8B1BC6
        for <linux-bcache@vger.kernel.org>; Tue, 18 Jul 2023 19:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689734848; x=1721270848;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y65VeUnqXZArx/32mFReii5yKSCq8hQHFFw2ubTHsCw=;
  b=AQUKqSVF3SPmQjyeEYj9toPAG/5rlfmrG/KgB2F9UI4w0DQW/zHKgcAx
   tSs+qwSXjJZjf0v8H4Q4y2zuGphW7dgPK7ClVKf9dwTw956sB3UQViVwm
   Whem0/RTEtuNA074gyZLhufhzCYsV87NTIBHldoP+70W0of3agCH43sRK
   I0kTiWaiKehal6fONkisoClWTpFCzb1TBSzisYWMXXRsAXzo4VHrPhl0f
   qolWp2xzOZfXmKmTjVSfN1X8Y2I/AoHSvEYOasHXqxA+uztyhtvxMfsYi
   be0yQRiuaUmuxYjF9toA/UaiM3JkyKasZTFh5NvA6ncFDWxeY4AwYtOjn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="366400731"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="366400731"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 19:47:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="847907104"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="847907104"
Received: from lkp-server02.sh.intel.com (HELO 36946fcf73d7) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 18 Jul 2023 19:47:26 -0700
Received: from kbuild by 36946fcf73d7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qLxDp-00045K-1F;
        Wed, 19 Jul 2023 02:47:25 +0000
Date:   Wed, 19 Jul 2023 10:46:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>, colyli@suse.de,
        linux-bcache@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, bcache@lists.ewheeler.net,
        zoumingzhe@qq.com
Subject: Re: [PATCH 2/3] bcache: Separate bch_moving_gc() from bch_btree_gc()
Message-ID: <202307191019.6OQTEaHw-lkp@intel.com>
References: <20230717124143.171-2-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717124143.171-2-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Mingzhe,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.5-rc2 next-20230718]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mingzhe-Zou/bcache-Separate-bch_moving_gc-from-bch_btree_gc/20230718-195022
base:   linus/master
patch link:    https://lore.kernel.org/r/20230717124143.171-2-mingzhe.zou%40easystack.cn
patch subject: [PATCH 2/3] bcache: Separate bch_moving_gc() from bch_btree_gc()
config: arc-randconfig-r043-20230718 (https://download.01.org/0day-ci/archive/20230719/202307191019.6OQTEaHw-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230719/202307191019.6OQTEaHw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202307191019.6OQTEaHw-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:22,
                    from arch/arc/include/asm/bug.h:30,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/arc/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/wait.h:9,
                    from include/linux/mempool.h:8,
                    from include/linux/bio.h:8,
                    from drivers/md/bcache/bcache.h:181,
                    from drivers/md/bcache/movinggc.c:8:
   drivers/md/bcache/movinggc.c: In function 'bch_moving_gc':
>> drivers/md/bcache/movinggc.c:236:18: error: 'struct cache_set' has no member named 'sb'
     236 |                 c->sb.set_uuid, sectors_to_move, ca->heap.used);
         |                  ^~
   include/linux/printk.h:427:33: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:528:9: note: in expansion of macro 'printk'
     528 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   drivers/md/bcache/movinggc.c:235:9: note: in expansion of macro 'pr_info'
     235 |         pr_info("moving gc: on set %pU, %lu sectors from %zu buckets",
         |         ^~~~~~~


vim +236 drivers/md/bcache/movinggc.c

   196	
   197	void bch_moving_gc(struct cache_set *c)
   198	{
   199		struct cache *ca = c->cache;
   200		struct bucket *b;
   201		unsigned long sectors_to_move, reserve_sectors;
   202	
   203		c->cache->only_moving_gc = 0;
   204	
   205		if (!c->copy_gc_enabled)
   206			return;
   207	
   208		mutex_lock(&c->bucket_lock);
   209	
   210		sectors_to_move = 0;
   211		reserve_sectors = ca->sb.bucket_size *
   212				     fifo_used(&ca->free[RESERVE_MOVINGGC]);
   213	
   214		ca->heap.used = 0;
   215	
   216		for_each_bucket(b, ca) {
   217			if (GC_MOVE(b) || GC_MARK(b) == GC_MARK_METADATA ||
   218			    !b->gc_sectors_used ||
   219			    b->gc_sectors_used == ca->sb.bucket_size ||
   220			    atomic_read(&b->pin))
   221				continue;
   222	
   223			if (!heap_full(&ca->heap)) {
   224				sectors_to_move += b->gc_sectors_used;
   225				heap_add(&ca->heap, b, bucket_cmp);
   226			} else if (bucket_cmp(b, heap_peek(&ca->heap))) {
   227				sectors_to_move -= bucket_heap_top(ca);
   228				sectors_to_move += b->gc_sectors_used;
   229	
   230				ca->heap.data[0] = b;
   231				heap_sift(&ca->heap, 0, bucket_cmp);
   232			}
   233		}
   234	 
   235		pr_info("moving gc: on set %pU, %lu sectors from %zu buckets",
 > 236			c->sb.set_uuid, sectors_to_move, ca->heap.used);
   237	
   238		while (sectors_to_move > reserve_sectors) {
   239			heap_pop(&ca->heap, b, bucket_cmp);
   240			sectors_to_move -= b->gc_sectors_used;
   241		}
   242	
   243		while (heap_pop(&ca->heap, b, bucket_cmp))
   244			SET_GC_MOVE(b, 1);
   245	
   246		mutex_unlock(&c->bucket_lock);
   247	
   248		c->moving_gc_keys.last_scanned = ZERO_KEY;
   249	
   250		read_moving(c);
   251	}
   252	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
