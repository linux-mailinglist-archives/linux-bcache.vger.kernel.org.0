Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A74758E43
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jul 2023 09:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjGSHB2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 19 Jul 2023 03:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjGSHBO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Jul 2023 03:01:14 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311431B9
        for <linux-bcache@vger.kernel.org>; Wed, 19 Jul 2023 00:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689750071; x=1721286071;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b18vK8nkvvWK30Is/f9qiIIs5rPzl+cfPCvrd2745w0=;
  b=YRikQ9OqIQkaiyyc5Q4m0Zu4f08ogobQMZtXp185iGYb+Uj0mYB8jzAU
   aAxdJPjT/xBb/WqTFpBgCQu9DKOanUMcAQrcBifSXv2Ce79W/ynIBtYBh
   cbdbLNexd2fn9Q6srJ3Ng2fyzYYqIUc063jF9Qsdq95JF3KxIWjURlsS0
   yx7ySdYnqPy+k5kP/KsJPjH2EK5sMR3Kr9DogCaFv9obhtDuUAK9dRLgK
   7XrlHT12NaHRzx6gM877GMRFxwrCa9aUTTho1D6qmPgwmSn2R+pmuf+ag
   5bKH3ljpHaqglob/FwZqBumpDB2BmxWAYK18jWGQ6tkyoPhQFp4RRnwR2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="432572272"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="432572272"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 00:01:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="717878642"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="717878642"
Received: from lkp-server02.sh.intel.com (HELO 36946fcf73d7) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 19 Jul 2023 00:01:09 -0700
Received: from kbuild by 36946fcf73d7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qM1BM-0004Eb-0c;
        Wed, 19 Jul 2023 07:01:08 +0000
Date:   Wed, 19 Jul 2023 15:00:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>, colyli@suse.de,
        linux-bcache@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        bcache@lists.ewheeler.net, zoumingzhe@qq.com
Subject: Re: [PATCH v2 1/3] bcache: the gc_sectors_used size matches the
 bucket size
Message-ID: <202307191421.MARPn86g-lkp@intel.com>
References: <20230719024709.287-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719024709.287-1-mingzhe.zou@easystack.cn>
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
[also build test ERROR on v6.5-rc2 next-20230719]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mingzhe-Zou/bcache-Separate-bch_moving_gc-from-bch_btree_gc/20230719-105019
base:   linus/master
patch link:    https://lore.kernel.org/r/20230719024709.287-1-mingzhe.zou%40easystack.cn
patch subject: [PATCH v2 1/3] bcache: the gc_sectors_used size matches the bucket size
config: hexagon-randconfig-r025-20230718 (https://download.01.org/0day-ci/archive/20230719/202307191421.MARPn86g-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230719/202307191421.MARPn86g-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202307191421.MARPn86g-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/md/bcache/trace.c:2:
   In file included from drivers/md/bcache/bcache.h:181:
   In file included from include/linux/bio.h:10:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     547 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     560 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   In file included from drivers/md/bcache/trace.c:2:
   In file included from drivers/md/bcache/bcache.h:181:
   In file included from include/linux/bio.h:10:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     573 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   In file included from drivers/md/bcache/trace.c:2:
   In file included from drivers/md/bcache/bcache.h:181:
   In file included from include/linux/bio.h:10:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     584 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     594 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     604 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   In file included from drivers/md/bcache/trace.c:9:
   In file included from include/trace/events/bcache.h:505:
   In file included from include/trace/define_trace.h:102:
   In file included from include/trace/trace_events.h:419:
>> include/trace/events/bcache.h:441:22: error: call to undeclared function 'GC_SECTORS_USED'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     441 |                 __entry->sectors        = GC_SECTORS_USED(&ca->buckets[bucket]);
         |                                           ^
   6 warnings and 1 error generated.


vim +/GC_SECTORS_USED +441 include/trace/events/bcache.h

cafe563591446cf Kent Overstreet 2013-03-23  427  
7159b1ad3dded9d Kent Overstreet 2014-02-12  428  TRACE_EVENT(bcache_invalidate,
7159b1ad3dded9d Kent Overstreet 2014-02-12  429  	TP_PROTO(struct cache *ca, size_t bucket),
7159b1ad3dded9d Kent Overstreet 2014-02-12  430  	TP_ARGS(ca, bucket),
cafe563591446cf Kent Overstreet 2013-03-23  431  
cafe563591446cf Kent Overstreet 2013-03-23  432  	TP_STRUCT__entry(
7159b1ad3dded9d Kent Overstreet 2014-02-12  433  		__field(unsigned,	sectors			)
7159b1ad3dded9d Kent Overstreet 2014-02-12  434  		__field(dev_t,		dev			)
7159b1ad3dded9d Kent Overstreet 2014-02-12  435  		__field(__u64,		offset			)
cafe563591446cf Kent Overstreet 2013-03-23  436  	),
cafe563591446cf Kent Overstreet 2013-03-23  437  
cafe563591446cf Kent Overstreet 2013-03-23  438  	TP_fast_assign(
7159b1ad3dded9d Kent Overstreet 2014-02-12  439  		__entry->dev		= ca->bdev->bd_dev;
7159b1ad3dded9d Kent Overstreet 2014-02-12  440  		__entry->offset		= bucket << ca->set->bucket_bits;
7159b1ad3dded9d Kent Overstreet 2014-02-12 @441  		__entry->sectors	= GC_SECTORS_USED(&ca->buckets[bucket]);
cafe563591446cf Kent Overstreet 2013-03-23  442  	),
cafe563591446cf Kent Overstreet 2013-03-23  443  
7159b1ad3dded9d Kent Overstreet 2014-02-12  444  	TP_printk("invalidated %u sectors at %d,%d sector=%llu",
7159b1ad3dded9d Kent Overstreet 2014-02-12  445  		  __entry->sectors, MAJOR(__entry->dev),
7159b1ad3dded9d Kent Overstreet 2014-02-12  446  		  MINOR(__entry->dev), __entry->offset)
7159b1ad3dded9d Kent Overstreet 2014-02-12  447  );
7159b1ad3dded9d Kent Overstreet 2014-02-12  448  
7159b1ad3dded9d Kent Overstreet 2014-02-12  449  TRACE_EVENT(bcache_alloc,
7159b1ad3dded9d Kent Overstreet 2014-02-12  450  	TP_PROTO(struct cache *ca, size_t bucket),
7159b1ad3dded9d Kent Overstreet 2014-02-12  451  	TP_ARGS(ca, bucket),
7159b1ad3dded9d Kent Overstreet 2014-02-12  452  
7159b1ad3dded9d Kent Overstreet 2014-02-12  453  	TP_STRUCT__entry(
7159b1ad3dded9d Kent Overstreet 2014-02-12  454  		__field(dev_t,		dev			)
7159b1ad3dded9d Kent Overstreet 2014-02-12  455  		__field(__u64,		offset			)
7159b1ad3dded9d Kent Overstreet 2014-02-12  456  	),
7159b1ad3dded9d Kent Overstreet 2014-02-12  457  
7159b1ad3dded9d Kent Overstreet 2014-02-12  458  	TP_fast_assign(
7159b1ad3dded9d Kent Overstreet 2014-02-12  459  		__entry->dev		= ca->bdev->bd_dev;
7159b1ad3dded9d Kent Overstreet 2014-02-12  460  		__entry->offset		= bucket << ca->set->bucket_bits;
7159b1ad3dded9d Kent Overstreet 2014-02-12  461  	),
7159b1ad3dded9d Kent Overstreet 2014-02-12  462  
7159b1ad3dded9d Kent Overstreet 2014-02-12  463  	TP_printk("allocated %d,%d sector=%llu", MAJOR(__entry->dev),
7159b1ad3dded9d Kent Overstreet 2014-02-12  464  		  MINOR(__entry->dev), __entry->offset)
cafe563591446cf Kent Overstreet 2013-03-23  465  );
cafe563591446cf Kent Overstreet 2013-03-23  466  
c37511b863f36c1 Kent Overstreet 2013-04-26  467  TRACE_EVENT(bcache_alloc_fail,
78365411b344df3 Kent Overstreet 2013-12-17  468  	TP_PROTO(struct cache *ca, unsigned reserve),
78365411b344df3 Kent Overstreet 2013-12-17  469  	TP_ARGS(ca, reserve),
cafe563591446cf Kent Overstreet 2013-03-23  470  
c37511b863f36c1 Kent Overstreet 2013-04-26  471  	TP_STRUCT__entry(
7159b1ad3dded9d Kent Overstreet 2014-02-12  472  		__field(dev_t,		dev			)
c37511b863f36c1 Kent Overstreet 2013-04-26  473  		__field(unsigned,	free			)
c37511b863f36c1 Kent Overstreet 2013-04-26  474  		__field(unsigned,	free_inc		)
c37511b863f36c1 Kent Overstreet 2013-04-26  475  		__field(unsigned,	blocked			)
c37511b863f36c1 Kent Overstreet 2013-04-26  476  	),
cafe563591446cf Kent Overstreet 2013-03-23  477  
c37511b863f36c1 Kent Overstreet 2013-04-26  478  	TP_fast_assign(
7159b1ad3dded9d Kent Overstreet 2014-02-12  479  		__entry->dev		= ca->bdev->bd_dev;
78365411b344df3 Kent Overstreet 2013-12-17  480  		__entry->free		= fifo_used(&ca->free[reserve]);
c37511b863f36c1 Kent Overstreet 2013-04-26  481  		__entry->free_inc	= fifo_used(&ca->free_inc);
c37511b863f36c1 Kent Overstreet 2013-04-26  482  		__entry->blocked	= atomic_read(&ca->set->prio_blocked);
c37511b863f36c1 Kent Overstreet 2013-04-26  483  	),
cafe563591446cf Kent Overstreet 2013-03-23  484  
2531d9ee61fa08a Kent Overstreet 2014-03-17  485  	TP_printk("alloc fail %d,%d free %u free_inc %u blocked %u",
7159b1ad3dded9d Kent Overstreet 2014-02-12  486  		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->free,
2531d9ee61fa08a Kent Overstreet 2014-03-17  487  		  __entry->free_inc, __entry->blocked)
cafe563591446cf Kent Overstreet 2013-03-23  488  );
cafe563591446cf Kent Overstreet 2013-03-23  489  
c37511b863f36c1 Kent Overstreet 2013-04-26  490  /* Background writeback */
cafe563591446cf Kent Overstreet 2013-03-23  491  
c37511b863f36c1 Kent Overstreet 2013-04-26  492  DEFINE_EVENT(bkey, bcache_writeback,
c37511b863f36c1 Kent Overstreet 2013-04-26  493  	TP_PROTO(struct bkey *k),
c37511b863f36c1 Kent Overstreet 2013-04-26  494  	TP_ARGS(k)
c37511b863f36c1 Kent Overstreet 2013-04-26  495  );
cafe563591446cf Kent Overstreet 2013-03-23  496  
c37511b863f36c1 Kent Overstreet 2013-04-26  497  DEFINE_EVENT(bkey, bcache_writeback_collision,
c37511b863f36c1 Kent Overstreet 2013-04-26  498  	TP_PROTO(struct bkey *k),
c37511b863f36c1 Kent Overstreet 2013-04-26  499  	TP_ARGS(k)
cafe563591446cf Kent Overstreet 2013-03-23  500  );
cafe563591446cf Kent Overstreet 2013-03-23  501  
cafe563591446cf Kent Overstreet 2013-03-23  502  #endif /* _TRACE_BCACHE_H */
cafe563591446cf Kent Overstreet 2013-03-23  503  
cafe563591446cf Kent Overstreet 2013-03-23  504  /* This part must be outside protection */
cafe563591446cf Kent Overstreet 2013-03-23 @505  #include <trace/define_trace.h>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
