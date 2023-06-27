Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD72E740242
	for <lists+linux-bcache@lfdr.de>; Tue, 27 Jun 2023 19:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjF0RfV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 27 Jun 2023 13:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjF0RfT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2023 13:35:19 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57326268C
        for <linux-bcache@vger.kernel.org>; Tue, 27 Jun 2023 10:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687887318; x=1719423318;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U+N7Ibz3Z+yfeA6mFst4GebSrrDDzlhu8gVVBJjGI+w=;
  b=TmUSZOhh8nm4cQowaizC2m1QlLvSeGkHoTkrw6+AKh8rWtnkcVEwdVtC
   cjH6L3JKk91h3oinbLIRV7+3B8nY2aVjBrSDUaflwX5x4dfRF1aZk/H9H
   SVAS4PAu9LGMjuJFHgKOgyC5jW99C4JqjPI0MQAqxSEPX6fSWKakleMPM
   1huva2AzRnWKQfmSEFCpDhT3Fp8KwyrVViZLXlBCNlNphZJNx5qBuIoMm
   1eYlzSo0SehfOwUNRsAfR1hLZSSg3hDEGKI8Fg0fGmb/3vMvaeKHQ5NVs
   xdjbwVLUJ/5RZ2ILbOzvRrQkRWtVVYdyXpcOUrQBATAYUutgH3Wx7Aqdy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="364185988"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="364185988"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 10:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="786703745"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="786703745"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jun 2023 10:35:14 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qECav-000C6J-1R;
        Tue, 27 Jun 2023 17:35:13 +0000
Date:   Wed, 28 Jun 2023 01:34:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>, colyli@suse.de,
        linux-bcache@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, bcache@lists.ewheeler.net,
        zoumingzhe@qq.com
Subject: Re: [PATCH] Separate bch_moving_gc() from bch_btree_gc()
Message-ID: <202306280137.Dirtk7fY-lkp@intel.com>
References: <20230627092122.197-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627092122.197-1-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
config: arc-randconfig-r043-20230627 (https://download.01.org/0day-ci/archive/20230628/202306280137.Dirtk7fY-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230628/202306280137.Dirtk7fY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306280137.Dirtk7fY-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/md/bcache/btree.c: In function 'moving_gc_should_run':
>> drivers/md/bcache/btree.c:1839:34: error: 'bch_cutoff_writeback_sync' undeclared (first use in this function)
    1839 |         if (c->gc_stats.in_use > bch_cutoff_writeback_sync)
         |                                  ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/bcache/btree.c:1839:34: note: each undeclared identifier is reported only once for each function it appears in
   In file included from drivers/md/bcache/btree.c:24:
>> drivers/md/bcache/btree.c:1843:25: error: 'b' undeclared (first use in this function)
    1843 |         for_each_bucket(b, ca) {
         |                         ^
   drivers/md/bcache/bcache.h:890:14: note: in definition of macro 'for_each_bucket'
     890 |         for (b = (ca)->buckets + (ca)->sb.first_bucket;                 \
         |              ^
>> drivers/md/bcache/btree.c:1862:85: error: expected ';' before 'if'
    1862 |         frag_percent = div_u64(frag_sectors * 100, ca->sb.bucket_size * c->nbuckets)
         |                                                                                     ^
         |                                                                                     ;
    1863 | 
    1864 |         if (move_buckets > ca->heap.size)
         |         ~~                                                                           


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
