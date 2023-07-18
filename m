Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA95B7588C9
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jul 2023 00:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjGRW4i (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 18 Jul 2023 18:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGRW4i (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Jul 2023 18:56:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED314E0
        for <linux-bcache@vger.kernel.org>; Tue, 18 Jul 2023 15:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689720993; x=1721256993;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9WATWyxBP0Ga9/qY83mxhXujm/6DGmrnQqsOSnQtbas=;
  b=JeMPp45YmAv3HpB9CU+i/ZnlnqKMGJViyHNv1lCsi6KvpHgwBstUGwqU
   lLSh0jXr+bTGG0t6tUIi6WG7b+eihVRUfGikC8MSlQONwHKhyS9rlqLQf
   WccR2DIFG5CFrY5tkMVtj11liigdiSvkpYw82dTRZRK/qRP5MjKRUtkWx
   PDYwhLoqO9gtCU7QFu5S8oR2ZnJaYCGGWMj2LBugpqilm1AlyzVPGNGR8
   nbStGB1vYnoY17S0aJjlt/yig7OCmAfeaa+MX41BNXMNLlRkPYABRKh2F
   sUx8btLhURQKzoFF/i7IPjSF/eC6A4BXpfDakYl5QSm2pnZlfzWKrpXgm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="452706211"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="452706211"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 15:56:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="847852575"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="847852575"
Received: from lkp-server02.sh.intel.com (HELO 36946fcf73d7) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 18 Jul 2023 15:56:31 -0700
Received: from kbuild by 36946fcf73d7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qLtcM-0003wH-0c;
        Tue, 18 Jul 2023 22:56:30 +0000
Date:   Wed, 19 Jul 2023 06:55:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>, colyli@suse.de,
        linux-bcache@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        bcache@lists.ewheeler.net, zoumingzhe@qq.com
Subject: Re: [PATCH 1/3] bcache: the gc_sectors_used size matches the bucket
 size
Message-ID: <202307190650.U1M6Vswr-lkp@intel.com>
References: <20230717124143.171-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717124143.171-1-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
patch link:    https://lore.kernel.org/r/20230717124143.171-1-mingzhe.zou%40easystack.cn
patch subject: [PATCH 1/3] bcache: the gc_sectors_used size matches the bucket size
config: i386-randconfig-r024-20230718 (https://download.01.org/0day-ci/archive/20230719/202307190650.U1M6Vswr-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce: (https://download.01.org/0day-ci/archive/20230719/202307190650.U1M6Vswr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202307190650.U1M6Vswr-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/md/bcache/trace.c:9:
   In file included from include/trace/events/bcache.h:505:
   In file included from include/trace/define_trace.h:102:
   In file included from include/trace/trace_events.h:419:
>> include/trace/events/bcache.h:441:22: error: call to undeclared function 'GC_SECTORS_USED'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
                   __entry->sectors        = GC_SECTORS_USED(&ca->buckets[bucket]);
                                             ^
   In file included from drivers/md/bcache/trace.c:9:
   In file included from include/trace/events/bcache.h:505:
   In file included from include/trace/define_trace.h:103:
   In file included from include/trace/perf.h:75:
>> include/trace/events/bcache.h:441:22: error: call to undeclared function 'GC_SECTORS_USED'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
                   __entry->sectors        = GC_SECTORS_USED(&ca->buckets[bucket]);
                                             ^
   2 errors generated.


vim +/GC_SECTORS_USED +441 include/trace/events/bcache.h

cafe563591446c Kent Overstreet 2013-03-23  427  
7159b1ad3dded9 Kent Overstreet 2014-02-12  428  TRACE_EVENT(bcache_invalidate,
7159b1ad3dded9 Kent Overstreet 2014-02-12  429  	TP_PROTO(struct cache *ca, size_t bucket),
7159b1ad3dded9 Kent Overstreet 2014-02-12  430  	TP_ARGS(ca, bucket),
cafe563591446c Kent Overstreet 2013-03-23  431  
cafe563591446c Kent Overstreet 2013-03-23  432  	TP_STRUCT__entry(
7159b1ad3dded9 Kent Overstreet 2014-02-12  433  		__field(unsigned,	sectors			)
7159b1ad3dded9 Kent Overstreet 2014-02-12  434  		__field(dev_t,		dev			)
7159b1ad3dded9 Kent Overstreet 2014-02-12  435  		__field(__u64,		offset			)
cafe563591446c Kent Overstreet 2013-03-23  436  	),
cafe563591446c Kent Overstreet 2013-03-23  437  
cafe563591446c Kent Overstreet 2013-03-23  438  	TP_fast_assign(
7159b1ad3dded9 Kent Overstreet 2014-02-12  439  		__entry->dev		= ca->bdev->bd_dev;
7159b1ad3dded9 Kent Overstreet 2014-02-12  440  		__entry->offset		= bucket << ca->set->bucket_bits;
7159b1ad3dded9 Kent Overstreet 2014-02-12 @441  		__entry->sectors	= GC_SECTORS_USED(&ca->buckets[bucket]);
cafe563591446c Kent Overstreet 2013-03-23  442  	),
cafe563591446c Kent Overstreet 2013-03-23  443  
7159b1ad3dded9 Kent Overstreet 2014-02-12  444  	TP_printk("invalidated %u sectors at %d,%d sector=%llu",
7159b1ad3dded9 Kent Overstreet 2014-02-12  445  		  __entry->sectors, MAJOR(__entry->dev),
7159b1ad3dded9 Kent Overstreet 2014-02-12  446  		  MINOR(__entry->dev), __entry->offset)
7159b1ad3dded9 Kent Overstreet 2014-02-12  447  );
7159b1ad3dded9 Kent Overstreet 2014-02-12  448  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
