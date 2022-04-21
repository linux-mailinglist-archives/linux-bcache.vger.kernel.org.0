Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FE750A946
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Apr 2022 21:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382456AbiDUTh3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 21 Apr 2022 15:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiDUTh2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 21 Apr 2022 15:37:28 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481904D9CE
        for <linux-bcache@vger.kernel.org>; Thu, 21 Apr 2022 12:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650569678; x=1682105678;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zIes1bsbOVVFJmOKScby9X/jxq6YafRkBMeiGJtfDHI=;
  b=kWegRa8O1tPyxZUE+hv7iG4+clKvL0g97l6xt8RtSJFPVhDfO6G9h8qX
   crTupFHISmXasx8z8M62ALG3xmr2hcl8PrubHMhSaBc8JoYV8cUIvTPTg
   4UTZX2lgfXXQgdYgP3hja7EPZxoNBrE7UcJH/j7UK79GDm2IgrkdD4h5G
   X++cLUzZoxCEfGSH9jNqc16edpW22BKSnaaztOCi2Ze+zx7tQ0IYEHdPN
   laJaWrLMN0baj4WwKN8OQALzpWFkW7MBCDdZRU0ntvhjKOQEeJN684HwE
   kLp2iH18oRVcSMRRXLawj8YuKPHYUIBGaynLvPx/e0qcDJDyXbv9yY0WP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245032286"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="245032286"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 12:34:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="671195492"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 21 Apr 2022 12:34:36 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhcZX-0008ic-DQ;
        Thu, 21 Apr 2022 19:34:35 +0000
Date:   Fri, 22 Apr 2022 03:34:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     mingzhe.zou@easystack.cn, colyli@suse.de,
        linux-bcache@vger.kernel.org
Cc:     kbuild-all@lists.01.org, zoumingzhe@qq.com
Subject: Re: [PATCH] bcache: dynamic incremental gc
Message-ID: <202204220354.7eXmJIoI-lkp@intel.com>
References: <20220421121735.11591-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421121735.11591-1-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.18-rc3 next-20220421]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/mingzhe-zou-easystack-cn/bcache-dynamic-incremental-gc/20220421-201917
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git b253435746d9a4a701b5f09211b9c14d3370d0da
config: powerpc-randconfig-c024-20220421 (https://download.01.org/0day-ci/archive/20220422/202204220354.7eXmJIoI-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/9934df989e22e2a0da9c61c9c47da9839220570e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review mingzhe-zou-easystack-cn/bcache-dynamic-incremental-gc/20220421-201917
        git checkout 9934df989e22e2a0da9c61c9c47da9839220570e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   powerpc-linux-ld: drivers/md/bcache/btree.o: in function `bch_btree_gc':
>> drivers/md/bcache/btree.c:1870: undefined reference to `__udivdi3'


vim +1870 drivers/md/bcache/btree.c

  1832	
  1833	static void bch_btree_gc(struct cache_set *c)
  1834	{
  1835		int ret;
  1836		struct gc_stat stats;
  1837		struct closure writes;
  1838		struct btree_op op;
  1839		uint64_t sleep_time;
  1840	
  1841		trace_bcache_gc_start(c);
  1842	
  1843		memset(&stats, 0, sizeof(struct gc_stat));
  1844		closure_init_stack(&writes);
  1845		bch_btree_op_init(&op, SHRT_MAX);
  1846	
  1847		btree_gc_start(c);
  1848		stats.start_time = local_clock();
  1849	
  1850		/* if CACHE_SET_IO_DISABLE set, gc thread should stop too */
  1851		do {
  1852			stats.times++;
  1853			ret = bcache_btree_root(gc_root, c, &op, &writes, &stats);
  1854			closure_sync(&writes);
  1855			cond_resched();
  1856	
  1857			sleep_time = btree_gc_sleep_ms(c, &stats);
  1858			if (ret == -EAGAIN) {
  1859				stats.sleep_cost += sleep_time * NSEC_PER_MSEC;
  1860				schedule_timeout_interruptible(msecs_to_jiffies
  1861							       (sleep_time));
  1862			} else if (ret)
  1863				pr_warn("gc failed!\n");
  1864		} while (ret && !test_bit(CACHE_SET_IO_DISABLE, &c->flags));
  1865	
  1866		bch_btree_gc_finish(c);
  1867		wake_up_allocators(c);
  1868	
  1869		bch_time_stats_update(&c->btree_gc_time, stats.start_time);
> 1870		stats.average_cost = stats.gc_cost / stats.nodes;
  1871		pr_info("gc %llu times with %llu nodes, sleep %llums, "
  1872			"average gc cost %lluus per node",
  1873			(uint64_t)stats.times, (uint64_t)stats.nodes,
  1874			div_u64(stats.sleep_cost, NSEC_PER_MSEC),
  1875			div_u64(stats.average_cost, NSEC_PER_USEC));
  1876	
  1877		stats.key_bytes *= sizeof(uint64_t);
  1878		stats.data	<<= 9;
  1879		bch_update_bucket_in_use(c, &stats);
  1880		memcpy(&c->gc_stats, &stats, sizeof(struct gc_stat));
  1881	
  1882		trace_bcache_gc_end(c);
  1883	
  1884		bch_moving_gc(c);
  1885	}
  1886	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
