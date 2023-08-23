Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3801F784EAB
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Aug 2023 04:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjHWCWx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Aug 2023 22:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjHWCWw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Aug 2023 22:22:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC05D3
        for <linux-bcache@vger.kernel.org>; Tue, 22 Aug 2023 19:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692757370; x=1724293370;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X1+p1qTbbZMS50dAfz80v7sLu2asHhLYb8sDoJXRM/k=;
  b=MTobl5pnoqjElLMvsXAC8koI2vzuYCi0Hk1dV8Wav6QnxsXUufknn7Mq
   lI82u2QoXNQ8gr/DDClH6J4t96P+ETtA/QWgnPU9BVgZcbHKJAdtEEAdn
   It7zwROkp0fP1whbqnzm83RgafWodWyY90A6xgZTUfhDaQOfx09ecr00H
   iRY80eMZxu4RI+rUuO5ZQ4/oj/60lAF17MerovUf2gOrc72HUwggxJk7S
   wwa2SVf3W7Nh+BtWc+cHnh2qx/k9NKv+YQPccQDhsDq/4A1xGHQf2EtNX
   puUo2GOU6Fz9DfYRhMF2eD5ciecbtvbDNQBqGBrVwQPYlaohC1VtPlidJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="353600321"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="353600321"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 19:22:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="736463527"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="736463527"
Received: from lkp-server02.sh.intel.com (HELO daf8bb0a381d) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 22 Aug 2023 19:22:46 -0700
Received: from kbuild by daf8bb0a381d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qYdWA-0000ky-0s;
        Wed, 23 Aug 2023 02:22:46 +0000
Date:   Wed, 23 Aug 2023 10:22:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>, colyli@suse.de,
        bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        zoumingzhe@qq.com, Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH] bcache: fixup init dirty data errors
Message-ID: <202308231002.XWYzjVgk-lkp@intel.com>
References: <20230822101958.2577-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230822101958.2577-1-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Mingzhe,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.5-rc7 next-20230822]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mingzhe-Zou/bcache-fixup-init-dirty-data-errors/20230822-182044
base:   linus/master
patch link:    https://lore.kernel.org/r/20230822101958.2577-1-mingzhe.zou%40easystack.cn
patch subject: [PATCH] bcache: fixup init dirty data errors
config: i386-randconfig-011-20230822 (https://download.01.org/0day-ci/archive/20230823/202308231002.XWYzjVgk-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce: (https://download.01.org/0day-ci/archive/20230823/202308231002.XWYzjVgk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308231002.XWYzjVgk-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/bcache/writeback.c:986:22: error: no member named 'dirty_sectors' in 'struct bcache_device'
           atomic_long_set(&d->dirty_sectors, 0);
                            ~  ^
   1 error generated.


vim +986 drivers/md/bcache/writeback.c

   976	
   977	void bch_sectors_dirty_init(struct bcache_device *d)
   978	{
   979		int i;
   980		struct bkey *k = NULL;
   981		struct btree_iter iter;
   982		struct sectors_dirty_init op;
   983		struct cache_set *c = d->c;
   984		struct bch_dirty_init_state state;
   985	
 > 986		atomic_long_set(&d->dirty_sectors, 0);
   987	
   988		/* Just count root keys if no leaf node */
   989		rw_lock(0, c->root, c->root->level);
   990		if (c->root->level == 0) {
   991			bch_btree_op_init(&op.op, -1);
   992			op.inode = d->id;
   993			op.count = 0;
   994	
   995			for_each_key_filter(&c->root->keys,
   996					    k, &iter, bch_ptr_invalid) {
   997				if (KEY_INODE(k) != op.inode)
   998					continue;
   999				sectors_dirty_init_fn(&op.op, c->root, k);
  1000			}
  1001	
  1002			rw_unlock(0, c->root);
  1003			return;
  1004		}
  1005	
  1006		memset(&state, 0, sizeof(struct bch_dirty_init_state));
  1007		state.c = c;
  1008		state.d = d;
  1009		state.total_threads = bch_btre_dirty_init_thread_nr();
  1010		state.key_idx = 0;
  1011		spin_lock_init(&state.idx_lock);
  1012		atomic_set(&state.started, 0);
  1013		atomic_set(&state.enough, 0);
  1014		init_waitqueue_head(&state.wait);
  1015	
  1016		for (i = 0; i < state.total_threads; i++) {
  1017			/* Fetch latest state.enough earlier */
  1018			smp_mb__before_atomic();
  1019			if (atomic_read(&state.enough))
  1020				break;
  1021	
  1022			state.infos[i].state = &state;
  1023			state.infos[i].thread =
  1024				kthread_run(bch_dirty_init_thread, &state.infos[i],
  1025					    "bch_dirtcnt[%d]", i);
  1026			if (IS_ERR(state.infos[i].thread)) {
  1027				pr_err("fails to run thread bch_dirty_init[%d]\n", i);
  1028				for (--i; i >= 0; i--)
  1029					kthread_stop(state.infos[i].thread);
  1030				goto out;
  1031			}
  1032			atomic_inc(&state.started);
  1033		}
  1034	
  1035	out:
  1036		/* Must wait for all threads to stop. */
  1037		wait_event(state.wait, atomic_read(&state.started) == 0);
  1038		rw_unlock(0, c->root);
  1039	}
  1040	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
