Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B10E73FE93
	for <lists+linux-bcache@lfdr.de>; Tue, 27 Jun 2023 16:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjF0Onr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 27 Jun 2023 10:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjF0Ona (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2023 10:43:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3644030E5
        for <linux-bcache@vger.kernel.org>; Tue, 27 Jun 2023 07:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687876979; x=1719412979;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AuLDT/dz2aZd+pHPOoxb2U0yPepdHkz8HU8ac7HnCgU=;
  b=O4FdaKjlOGnXw7WoUcHoEFvJEz+Tov8gBZxJYMTGDfvzi/8Dxz0ypXhg
   NL25k3Q6LykJ4T9MRO8ZiBvPuG25LETtXLeeiHUxW7JgG7jwOUYu1Vr1+
   TXmVExWoCrVHGlRuUEFqFUtLppveaNWkE/6f9zmXMu0f6cuI4zgFx3UAp
   OXQEj2VMr+bymjY/wBkacLCbe//JzbHFYEn+8yoYd/BQcTDmwXYRoQuMB
   VxQOwdsnhuHYLCdTtZ6N+tulXNSTURzT46C8MI31xfmShTW47rep/Fexu
   DV/niw7cCNJuOmxYNhQF6mtK3yEJ5V0xl15ddRZSDk68lQA1mkFSROEe5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="427588453"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="427588453"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 07:42:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="693901337"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="693901337"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 27 Jun 2023 07:42:08 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qE9tP-000Byx-2n;
        Tue, 27 Jun 2023 14:42:07 +0000
Date:   Tue, 27 Jun 2023 22:41:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>, colyli@suse.de,
        linux-bcache@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        bcache@lists.ewheeler.net, zoumingzhe@qq.com
Subject: Re: [PATCH] Separate bch_moving_gc() from bch_btree_gc()
Message-ID: <202306272212.276Fkm0f-lkp@intel.com>
References: <20230627092122.197-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627092122.197-1-mingzhe.zou@easystack.cn>
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
[also build test ERROR on v6.4 next-20230627]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mingzhe-Zou/Separate-bch_moving_gc-from-bch_btree_gc/20230627-172221
base:   linus/master
patch link:    https://lore.kernel.org/r/20230627092122.197-1-mingzhe.zou%40easystack.cn
patch subject: [PATCH] Separate bch_moving_gc() from bch_btree_gc()
config: powerpc-randconfig-r012-20230627 (https://download.01.org/0day-ci/archive/20230627/202306272212.276Fkm0f-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230627/202306272212.276Fkm0f-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306272212.276Fkm0f-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/bcache/btree.c:1839:27: error: use of undeclared identifier 'bch_cutoff_writeback_sync'
    1839 |         if (c->gc_stats.in_use > bch_cutoff_writeback_sync)
         |                                  ^
>> drivers/md/bcache/btree.c:1843:18: error: use of undeclared identifier 'b'
    1843 |         for_each_bucket(b, ca) {
         |                         ^
>> drivers/md/bcache/btree.c:1843:18: error: use of undeclared identifier 'b'
>> drivers/md/bcache/btree.c:1843:18: error: use of undeclared identifier 'b'
   drivers/md/bcache/btree.c:1844:15: error: use of undeclared identifier 'b'
    1844 |                 if (GC_MARK(b) != GC_MARK_DIRTY)
         |                             ^
   drivers/md/bcache/btree.c:1849:34: error: use of undeclared identifier 'b'
    1849 |                 used_sectors = GC_SECTORS_USED(b);
         |                                                ^
>> drivers/md/bcache/btree.c:1862:78: error: expected ';' after expression
    1862 |         frag_percent = div_u64(frag_sectors * 100, ca->sb.bucket_size * c->nbuckets)
         |                                                                                     ^
         |                                                                                     ;
   7 errors generated.


vim +/bch_cutoff_writeback_sync +1839 drivers/md/bcache/btree.c

  1831	
  1832	static bool moving_gc_should_run(struct cache_set *c)
  1833	{
  1834		struct cache *ca = c->cache;
  1835		size_t moving_gc_threshold = ca->sb.bucket_size >> 2, frag_percent;
  1836		unsigned long used_buckets = 0, frag_buckets = 0, move_buckets = 0;
  1837		unsigned long dirty_sectors = 0, frag_sectors, used_sectors;
  1838	
> 1839		if (c->gc_stats.in_use > bch_cutoff_writeback_sync)
  1840			return true;
  1841	
  1842		mutex_lock(&c->bucket_lock);
> 1843		for_each_bucket(b, ca) {
  1844			if (GC_MARK(b) != GC_MARK_DIRTY)
  1845				continue;
  1846	
  1847			used_buckets++;
  1848	
  1849			used_sectors = GC_SECTORS_USED(b);
  1850			dirty_sectors += used_sectors;
  1851	
  1852			if (used_sectors < ca->sb.bucket_size)
  1853				frag_buckets++;
  1854	
  1855			if (used_sectors <= moving_gc_threshold)
  1856				move_buckets++;
  1857		}
  1858		mutex_unlock(&c->bucket_lock);
  1859	
  1860		c->fragment_nbuckets = frag_buckets;
  1861		frag_sectors = used_buckets * ca->sb.bucket_size - dirty_sectors;
> 1862		frag_percent = div_u64(frag_sectors * 100, ca->sb.bucket_size * c->nbuckets)
  1863	
  1864		if (move_buckets > ca->heap.size)
  1865			return true;
  1866	
  1867		if (frag_percent >= COPY_GC_PERCENT)
  1868			return true;
  1869	
  1870		return false;
  1871	}
  1872	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
