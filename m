Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127037394D2
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 03:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjFVBoa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Jun 2023 21:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjFVBo3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2023 21:44:29 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081C5135;
        Wed, 21 Jun 2023 18:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687398268; x=1718934268;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WRCzSbYSREuw4aJy7zSrPIhBbAAjSFJ7rWIg7rGQwmE=;
  b=a+nJ84vizzuGwOevv5ncT/u1CyzuTQQGqRU6sB086AW4vl1OUS575lHD
   BAphekBiikvvfEOOzzEz4ybWC6R8UyN1DF0w2PQ9vqHqycV4am3edrU76
   jGJH1JV6GXsJbYMmzUZ1flEEb7945z2bDv5uOenCYDSp+RIlDDlv18q2a
   Af1yqdwS2XtL5DFmCS4JWJJ09CciasOa+PQEqKVCZ+9eg3BAS/SAbutWx
   5hE0wEjkkQPeopxfX99GzCyZxiVXlQr94WSv1sqjLuymVo2sQjA4Uj0vH
   3+hKilpDk8rDS4Hn9f4VYqAIW/+tvhZFVk7mNpBCMSNMtGcyVTpn40MD+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="424027923"
X-IronPort-AV: E=Sophos;i="6.00,262,1681196400"; 
   d="scan'208";a="424027923"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 18:44:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="804593234"
X-IronPort-AV: E=Sophos;i="6.00,262,1681196400"; 
   d="scan'208";a="804593234"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jun 2023 18:44:24 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qC9N2-0007EV-17;
        Thu, 22 Jun 2023 01:44:24 +0000
Date:   Thu, 22 Jun 2023 09:44:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Cc:     oe-kbuild-all@lists.linux.dev,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] bcache: Fix bcache device claiming
Message-ID: <202306220914.B0THiZdL-lkp@intel.com>
References: <20230621162333.30027-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621162333.30027-2-jack@suse.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-6.5/block]
[also build test WARNING on next-20230621]
[cannot apply to linus/master hch-configfs/for-next v6.4-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jan-Kara/bcache-Alloc-holder-object-before-async-registration/20230622-002543
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-6.5/block
patch link:    https://lore.kernel.org/r/20230621162333.30027-2-jack%40suse.cz
patch subject: [PATCH 2/2] bcache: Fix bcache device claiming
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20230622/202306220914.B0THiZdL-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230622/202306220914.B0THiZdL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306220914.B0THiZdL-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/md/bcache/super.c: In function 'register_bcache':
   drivers/md/bcache/super.c:2574:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
    2574 |         if (IS_ERR(bdev))
         |         ^~
   drivers/md/bcache/super.c:2576:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
    2576 |                 if (bdev == ERR_PTR(-EBUSY)) {
         |                 ^~
   drivers/md/bcache/super.c:2591:17: error: label 'out_free_holder' used but not defined
    2591 |                 goto out_free_holder;
         |                 ^~~~
   drivers/md/bcache/super.c:2566:17: error: label 'out_put_sb_page' used but not defined
    2566 |                 goto out_put_sb_page;
         |                 ^~~~
   drivers/md/bcache/super.c:2560:17: error: label 'out_blkdev_put' used but not defined
    2560 |                 goto out_blkdev_put;
         |                 ^~~~
   drivers/md/bcache/super.c:2552:17: error: label 'out_free_sb' used but not defined
    2552 |                 goto out_free_sb;
         |                 ^~~~
   drivers/md/bcache/super.c:2546:17: error: label 'out_free_path' used but not defined
    2546 |                 goto out_free_path;
         |                 ^~~~
   drivers/md/bcache/super.c:2542:17: error: label 'out_module_put' used but not defined
    2542 |                 goto out_module_put;
         |                 ^~~~
   drivers/md/bcache/super.c:2530:17: error: label 'out' used but not defined
    2530 |                 goto out;
         |                 ^~~~
   drivers/md/bcache/super.c:2521:14: warning: variable 'quiet' set but not used [-Wunused-but-set-variable]
    2521 |         bool quiet = false;
         |              ^~~~~
>> drivers/md/bcache/super.c:2520:14: warning: variable 'async_registration' set but not used [-Wunused-but-set-variable]
    2520 |         bool async_registration = false;
         |              ^~~~~~~~~~~~~~~~~~
   drivers/md/bcache/super.c:2519:17: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
    2519 |         ssize_t ret;
         |                 ^~~
   drivers/md/bcache/super.c:2592:9: error: no return statement in function returning non-void [-Werror=return-type]
    2592 |         }
         |         ^
   drivers/md/bcache/super.c: At top level:
   drivers/md/bcache/super.c:2594:9: warning: data definition has no type or storage class
    2594 |         err = "failed to register device";
         |         ^~~
   drivers/md/bcache/super.c:2594:9: error: type defaults to 'int' in declaration of 'err' [-Werror=implicit-int]
   drivers/md/bcache/super.c:2594:15: warning: initialization of 'int' from 'char *' makes integer from pointer without a cast [-Wint-conversion]
    2594 |         err = "failed to register device";
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/bcache/super.c:2594:15: error: initializer element is not computable at load time
   drivers/md/bcache/super.c:2596:9: error: expected identifier or '(' before 'if'
    2596 |         if (async_registration) {
         |         ^~
   drivers/md/bcache/super.c:2617:9: error: expected identifier or '(' before 'if'
    2617 |         if (SB_IS_BDEV(sb)) {
         |         ^~
   drivers/md/bcache/super.c:2624:11: error: expected identifier or '(' before 'else'
    2624 |         } else {
         |           ^~~~
   drivers/md/bcache/super.c:2631:9: warning: data definition has no type or storage class
    2631 |         kfree(sb);
         |         ^~~~~
   drivers/md/bcache/super.c:2631:9: error: type defaults to 'int' in declaration of 'kfree' [-Werror=implicit-int]
   drivers/md/bcache/super.c:2631:9: warning: parameter names (without types) in function declaration
   drivers/md/bcache/super.c:2631:9: error: conflicting types for 'kfree'; have 'int()'
   In file included from include/linux/fs.h:45,
                    from include/linux/highmem.h:5,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/bio.h:10,
                    from drivers/md/bcache/bcache.h:181,
                    from drivers/md/bcache/super.c:10:
   include/linux/slab.h:210:6: note: previous declaration of 'kfree' with type 'void(const void *)'
     210 | void kfree(const void *objp);
         |      ^~~~~
   drivers/md/bcache/super.c:2632:9: warning: data definition has no type or storage class
    2632 |         kfree(path);
         |         ^~~~~
   drivers/md/bcache/super.c:2632:9: error: type defaults to 'int' in declaration of 'kfree' [-Werror=implicit-int]
   drivers/md/bcache/super.c:2632:9: warning: parameter names (without types) in function declaration
   drivers/md/bcache/super.c:2632:9: error: conflicting types for 'kfree'; have 'int()'
   include/linux/slab.h:210:6: note: previous declaration of 'kfree' with type 'void(const void *)'
     210 | void kfree(const void *objp);
         |      ^~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/preempt.h:10,
                    from include/linux/spinlock.h:56,
                    from include/linux/wait.h:9,
                    from include/linux/mempool.h:8,
                    from include/linux/bio.h:8:
   include/linux/export.h:27:21: error: expected declaration specifiers or '...' before '(' token
      27 | #define THIS_MODULE (&__this_module)
         |                     ^
   drivers/md/bcache/super.c:2633:20: note: in expansion of macro 'THIS_MODULE'
    2633 |         module_put(THIS_MODULE);
         |                    ^~~~~~~~~~~
   drivers/md/bcache/super.c:2634:11: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
    2634 | async_done:
         |           ^
   drivers/md/bcache/super.c:2637:16: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
    2637 | out_free_holder:
         |                ^
   drivers/md/bcache/super.c:2639:16: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
    2639 | out_put_sb_page:
         |                ^
   drivers/md/bcache/super.c:2641:15: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
    2641 | out_blkdev_put:
         |               ^
   drivers/md/bcache/super.c:2643:12: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
    2643 | out_free_sb:
         |            ^
   drivers/md/bcache/super.c:2645:14: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
    2645 | out_free_path:
         |              ^
   drivers/md/bcache/super.c:2647:9: warning: data definition has no type or storage class
    2647 |         path = NULL;
         |         ^~~~
   drivers/md/bcache/super.c:2647:9: error: type defaults to 'int' in declaration of 'path' [-Werror=implicit-int]
   In file included from include/uapi/linux/posix_types.h:5,
                    from include/uapi/linux/types.h:14,
                    from include/linux/types.h:6,
                    from include/linux/kasan-checks.h:5,
                    from include/asm-generic/rwonce.h:26,
                    from arch/s390/include/asm/rwonce.h:29,
                    from include/linux/compiler.h:247,
                    from include/linux/build_bug.h:5,
                    from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/wait.h:7:
   include/linux/stddef.h:8:14: warning: initialization of 'int' from 'void *' makes integer from pointer without a cast [-Wint-conversion]
       8 | #define NULL ((void *)0)
         |              ^
   drivers/md/bcache/super.c:2647:16: note: in expansion of macro 'NULL'


vim +/async_registration +2520 drivers/md/bcache/super.c

867f981b0739bd Jan Kara          2023-06-21  2509  
cafe563591446c Kent Overstreet   2013-03-23  2510  static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
cafe563591446c Kent Overstreet   2013-03-23  2511  			       const char *buffer, size_t size)
cafe563591446c Kent Overstreet   2013-03-23  2512  {
50246693f81fe8 Christoph Hellwig 2020-01-24  2513  	const char *err;
29cda393bcaad1 Coly Li           2020-01-24  2514  	char *path = NULL;
50246693f81fe8 Christoph Hellwig 2020-01-24  2515  	struct cache_sb *sb;
cfa0c56db9c087 Christoph Hellwig 2020-01-24  2516  	struct cache_sb_disk *sb_disk;
ee9eea7d8b1a83 Jan Kara          2023-06-21  2517  	struct block_device *bdev, *bdev2;
ee9eea7d8b1a83 Jan Kara          2023-06-21  2518  	void *holder = NULL;
50246693f81fe8 Christoph Hellwig 2020-01-24  2519  	ssize_t ret;
a58e88bfdc4d52 Coly Li           2020-10-01 @2520  	bool async_registration = false;
ee9eea7d8b1a83 Jan Kara          2023-06-21  2521  	bool quiet = false;
a58e88bfdc4d52 Coly Li           2020-10-01  2522  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
