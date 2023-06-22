Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49387395D4
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 05:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjFVDaf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Jun 2023 23:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjFVDad (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2023 23:30:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C5B1A4;
        Wed, 21 Jun 2023 20:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687404631; x=1718940631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9M7I1//XquKcZIL2PPA1I4Yksw7jYe7PccJhUo9OhyI=;
  b=Y7DHxPIhzsvgyUigjtABXlfX1MBOHS8o2xnn1wR7JdUMsiVfAWpNyQZR
   Nx+DwZd41cvbKrlCIfmqRwYmcOBBM/Zf70HA2E5DrVJ1rFdx8PhuE1Kls
   cij73xBLq24gBhxmPCkNlTeJHz+akL1uCW2xKYH3Sq5gJARNIS0sF6rrl
   ucXxd2oRo8Xu0liFTpTlg0sa7N+XQ9uIc2/ZycQSM6TI4xh2VGbJ0fe05
   37v81c0yQXzeYV87qeU+LTT1qK4tbqqz2wBxB8MRMFAGfdruyv7y+u4Wq
   7G4pA1a75gf3hFEE2zWGF6MaKOOfkWJDZTXp/F6Q5G0Ckw+GO+i3c+gMS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="357868997"
X-IronPort-AV: E=Sophos;i="6.00,262,1681196400"; 
   d="scan'208";a="357868997"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 20:30:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="827727302"
X-IronPort-AV: E=Sophos;i="6.00,262,1681196400"; 
   d="scan'208";a="827727302"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 21 Jun 2023 20:30:28 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qCB1f-0007Il-2y;
        Thu, 22 Jun 2023 03:30:27 +0000
Date:   Thu, 22 Jun 2023 11:29:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Cc:     oe-kbuild-all@lists.linux.dev,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] bcache: Fix bcache device claiming
Message-ID: <202306221133.HFiLGynP-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe-block/for-6.5/block]
[also build test ERROR on next-20230621]
[cannot apply to linus/master hch-configfs/for-next v6.4-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jan-Kara/bcache-Alloc-holder-object-before-async-registration/20230622-002543
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-6.5/block
patch link:    https://lore.kernel.org/r/20230621162333.30027-2-jack%40suse.cz
patch subject: [PATCH 2/2] bcache: Fix bcache device claiming
config: i386-debian-10.3 (https://download.01.org/0day-ci/archive/20230622/202306221133.HFiLGynP-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230622/202306221133.HFiLGynP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306221133.HFiLGynP-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

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
>> drivers/md/bcache/super.c:2520:14: warning: unused variable 'async_registration' [-Wunused-variable]
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
   In file included from arch/x86/include/asm/page.h:85,
                    from arch/x86/include/asm/thread_info.h:12,
                    from include/linux/thread_info.h:60,
                    from arch/x86/include/asm/preempt.h:9,
                    from include/linux/preempt.h:78:
>> include/asm-generic/memory_model.h:55:2: error: expected identifier or '(' before ')' token
      55 | })
         |  ^
   include/asm-generic/memory_model.h:65:21: note: in expansion of macro '__pfn_to_page'
      65 | #define pfn_to_page __pfn_to_page
         |                     ^~~~~~~~~~~~~
   arch/x86/include/asm/page.h:68:33: note: in expansion of macro 'pfn_to_page'
      68 | #define virt_to_page(kaddr)     pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
         |                                 ^~~~~~~~~~~
   drivers/md/bcache/super.c:2640:18: note: in expansion of macro 'virt_to_page'
    2640 |         put_page(virt_to_page(sb_disk));
         |                  ^~~~~~~~~~~~
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
                    from ./arch/x86/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:247,
                    from include/linux/build_bug.h:5,
                    from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/wait.h:7:
   include/linux/stddef.h:8:14: warning: initialization of 'int' from 'void *' makes integer from pointer without a cast [-Wint-conversion]
       8 | #define NULL ((void *)0)
         |              ^
   drivers/md/bcache/super.c:2647:16: note: in expansion of macro 'NULL'
    2647 |         path = NULL;
         |                ^~~~
   drivers/md/bcache/super.c:2648:15: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
    2648 | out_module_put:
         |               ^
   drivers/md/bcache/super.c:2650:4: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
    2650 | out:
         |    ^
   In file included from include/linux/kernel.h:30,
                    from arch/x86/include/asm/percpu.h:27,
                    from arch/x86/include/asm/preempt.h:6:
   include/linux/printk.h:428:10: error: expected identifier or '(' before ')' token
     428 |         })
         |          ^
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   include/linux/printk.h:528:9: note: in expansion of macro 'printk'
     528 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   drivers/md/bcache/super.c:2652:17: note: in expansion of macro 'pr_info'
    2652 |                 pr_info("error %s: %s\n", path?path:"", err);
         |                 ^~~~~~~
   drivers/md/bcache/super.c:2653:9: error: expected identifier or '(' before 'return'
    2653 |         return ret;
         |         ^~~~~~
   drivers/md/bcache/super.c:2654:1: error: expected identifier or '(' before '}' token
    2654 | }
         | ^
   drivers/md/bcache/super.c:2492:13: warning: 'register_device_async' defined but not used [-Wunused-function]
    2492 | static void register_device_async(struct async_reg_args *args)
         |             ^~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


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
a58e88bfdc4d52 Coly Li           2020-10-01  2523  #ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
a58e88bfdc4d52 Coly Li           2020-10-01  2524  	async_registration = true;
a58e88bfdc4d52 Coly Li           2020-10-01  2525  #endif
cafe563591446c Kent Overstreet   2013-03-23  2526  
50246693f81fe8 Christoph Hellwig 2020-01-24  2527  	ret = -EBUSY;
29cda393bcaad1 Coly Li           2020-01-24  2528  	err = "failed to reference bcache module";
cafe563591446c Kent Overstreet   2013-03-23  2529  	if (!try_module_get(THIS_MODULE))
50246693f81fe8 Christoph Hellwig 2020-01-24  2530  		goto out;
cafe563591446c Kent Overstreet   2013-03-23  2531  
a59ff6ccc2bf2e Coly Li           2019-06-28  2532  	/* For latest state of bcache_is_reboot */
a59ff6ccc2bf2e Coly Li           2019-06-28  2533  	smp_mb();
29cda393bcaad1 Coly Li           2020-01-24  2534  	err = "bcache is in reboot";
a59ff6ccc2bf2e Coly Li           2019-06-28  2535  	if (bcache_is_reboot)
50246693f81fe8 Christoph Hellwig 2020-01-24  2536  		goto out_module_put;
a59ff6ccc2bf2e Coly Li           2019-06-28  2537  
50246693f81fe8 Christoph Hellwig 2020-01-24  2538  	ret = -ENOMEM;
50246693f81fe8 Christoph Hellwig 2020-01-24  2539  	err = "cannot allocate memory";
a56489d4b3c914 Florian Schmaus   2018-07-26  2540  	path = kstrndup(buffer, size, GFP_KERNEL);
a56489d4b3c914 Florian Schmaus   2018-07-26  2541  	if (!path)
50246693f81fe8 Christoph Hellwig 2020-01-24 @2542  		goto out_module_put;
a56489d4b3c914 Florian Schmaus   2018-07-26  2543  
a56489d4b3c914 Florian Schmaus   2018-07-26  2544  	sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL);
a56489d4b3c914 Florian Schmaus   2018-07-26  2545  	if (!sb)
50246693f81fe8 Christoph Hellwig 2020-01-24  2546  		goto out_free_path;
cafe563591446c Kent Overstreet   2013-03-23  2547  
50246693f81fe8 Christoph Hellwig 2020-01-24  2548  	ret = -EINVAL;
cafe563591446c Kent Overstreet   2013-03-23  2549  	err = "failed to open device";
ee9eea7d8b1a83 Jan Kara          2023-06-21  2550  	bdev = blkdev_get_by_path(strim(path), BLK_OPEN_READ, NULL, NULL);
ee9eea7d8b1a83 Jan Kara          2023-06-21  2551  	if (IS_ERR(bdev))
50246693f81fe8 Christoph Hellwig 2020-01-24  2552  		goto out_free_sb;
f59fce847fc848 Kent Overstreet   2013-05-15  2553  
f59fce847fc848 Kent Overstreet   2013-05-15  2554  	err = "failed to set blocksize";
f59fce847fc848 Kent Overstreet   2013-05-15  2555  	if (set_blocksize(bdev, 4096))
50246693f81fe8 Christoph Hellwig 2020-01-24  2556  		goto out_blkdev_put;
cafe563591446c Kent Overstreet   2013-03-23  2557  
cfa0c56db9c087 Christoph Hellwig 2020-01-24  2558  	err = read_super(sb, bdev, &sb_disk);
cafe563591446c Kent Overstreet   2013-03-23  2559  	if (err)
50246693f81fe8 Christoph Hellwig 2020-01-24  2560  		goto out_blkdev_put;
cafe563591446c Kent Overstreet   2013-03-23  2561  
867f981b0739bd Jan Kara          2023-06-21  2562  	holder = alloc_holder_object(sb);
867f981b0739bd Jan Kara          2023-06-21  2563  	if (!holder) {
867f981b0739bd Jan Kara          2023-06-21  2564  		ret = -ENOMEM;
867f981b0739bd Jan Kara          2023-06-21  2565  		err = "cannot allocate memory";
867f981b0739bd Jan Kara          2023-06-21  2566  		goto out_put_sb_page;
867f981b0739bd Jan Kara          2023-06-21  2567  	}
867f981b0739bd Jan Kara          2023-06-21  2568  
ee9eea7d8b1a83 Jan Kara          2023-06-21  2569  	/* Now reopen in exclusive mode with proper holder */
ee9eea7d8b1a83 Jan Kara          2023-06-21  2570  	bdev2 = blkdev_get_by_dev(bdev->bd_dev, BLK_OPEN_READ | BLK_OPEN_WRITE,
ee9eea7d8b1a83 Jan Kara          2023-06-21  2571  				  holder, NULL);
ee9eea7d8b1a83 Jan Kara          2023-06-21  2572  	blkdev_put(bdev, NULL);
ee9eea7d8b1a83 Jan Kara          2023-06-21  2573  	bdev = bdev2;
ee9eea7d8b1a83 Jan Kara          2023-06-21  2574  	if (IS_ERR(bdev))
ee9eea7d8b1a83 Jan Kara          2023-06-21  2575  		ret = PTR_ERR(bdev);
ee9eea7d8b1a83 Jan Kara          2023-06-21  2576  		if (bdev == ERR_PTR(-EBUSY)) {
ee9eea7d8b1a83 Jan Kara          2023-06-21  2577  			dev_t dev;
ee9eea7d8b1a83 Jan Kara          2023-06-21  2578  
ee9eea7d8b1a83 Jan Kara          2023-06-21  2579  			mutex_lock(&bch_register_lock);
ee9eea7d8b1a83 Jan Kara          2023-06-21  2580  			if (lookup_bdev(strim(path), &dev) == 0 &&
ee9eea7d8b1a83 Jan Kara          2023-06-21  2581  			    bch_is_open(dev))
ee9eea7d8b1a83 Jan Kara          2023-06-21  2582  				err = "device already registered";
ee9eea7d8b1a83 Jan Kara          2023-06-21  2583  			else
ee9eea7d8b1a83 Jan Kara          2023-06-21  2584  				err = "device busy";
ee9eea7d8b1a83 Jan Kara          2023-06-21  2585  			mutex_unlock(&bch_register_lock);
ee9eea7d8b1a83 Jan Kara          2023-06-21  2586  			if (attr == &ksysfs_register_quiet) {
ee9eea7d8b1a83 Jan Kara          2023-06-21  2587  				quiet = true;
ee9eea7d8b1a83 Jan Kara          2023-06-21  2588  				ret = size;
ee9eea7d8b1a83 Jan Kara          2023-06-21  2589  			}
ee9eea7d8b1a83 Jan Kara          2023-06-21  2590  		}
ee9eea7d8b1a83 Jan Kara          2023-06-21  2591  		goto out_free_holder;
ee9eea7d8b1a83 Jan Kara          2023-06-21  2592  	}
ee9eea7d8b1a83 Jan Kara          2023-06-21  2593  
cc40daf91bdddb Tang Junhui       2018-03-05  2594  	err = "failed to register device";
a58e88bfdc4d52 Coly Li           2020-10-01  2595  
a58e88bfdc4d52 Coly Li           2020-10-01  2596  	if (async_registration) {
9e23ccf8f0a22e Coly Li           2020-05-27  2597  		/* register in asynchronous way */
9e23ccf8f0a22e Coly Li           2020-05-27  2598  		struct async_reg_args *args =
9e23ccf8f0a22e Coly Li           2020-05-27  2599  			kzalloc(sizeof(struct async_reg_args), GFP_KERNEL);
9e23ccf8f0a22e Coly Li           2020-05-27  2600  
9e23ccf8f0a22e Coly Li           2020-05-27  2601  		if (!args) {
9e23ccf8f0a22e Coly Li           2020-05-27  2602  			ret = -ENOMEM;
9e23ccf8f0a22e Coly Li           2020-05-27  2603  			err = "cannot allocate memory";
867f981b0739bd Jan Kara          2023-06-21  2604  			goto out_free_holder;
9e23ccf8f0a22e Coly Li           2020-05-27  2605  		}
9e23ccf8f0a22e Coly Li           2020-05-27  2606  
9e23ccf8f0a22e Coly Li           2020-05-27  2607  		args->path	= path;
9e23ccf8f0a22e Coly Li           2020-05-27  2608  		args->sb	= sb;
9e23ccf8f0a22e Coly Li           2020-05-27  2609  		args->sb_disk	= sb_disk;
9e23ccf8f0a22e Coly Li           2020-05-27  2610  		args->bdev	= bdev;
867f981b0739bd Jan Kara          2023-06-21  2611  		args->holder	= holder;
d7fae7b4fa1527 Kai Krakow        2021-02-10  2612  		register_device_async(args);
9e23ccf8f0a22e Coly Li           2020-05-27  2613  		/* No wait and returns to user space */
9e23ccf8f0a22e Coly Li           2020-05-27  2614  		goto async_done;
9e23ccf8f0a22e Coly Li           2020-05-27  2615  	}
9e23ccf8f0a22e Coly Li           2020-05-27  2616  
2903381fce7100 Kent Overstreet   2013-04-11  2617  	if (SB_IS_BDEV(sb)) {
4fa03402cda2fa Kent Overstreet   2014-03-17  2618  		mutex_lock(&bch_register_lock);
867f981b0739bd Jan Kara          2023-06-21  2619  		ret = register_bdev(sb, sb_disk, bdev, holder);
4fa03402cda2fa Kent Overstreet   2014-03-17  2620  		mutex_unlock(&bch_register_lock);
bb6d355c2aff42 Coly Li           2019-04-25  2621  		/* blkdev_put() will be called in cached_dev_free() */
fc8f19cc5dce18 Christoph Hellwig 2020-01-24  2622  		if (ret < 0)
fc8f19cc5dce18 Christoph Hellwig 2020-01-24  2623  			goto out_free_sb;
cafe563591446c Kent Overstreet   2013-03-23  2624  	} else {
bb6d355c2aff42 Coly Li           2019-04-25  2625  		/* blkdev_put() will be called in bch_cache_release() */
867f981b0739bd Jan Kara          2023-06-21  2626  		ret = register_cache(sb, sb_disk, bdev, holder);
d55f7cb2e5c053 Chao Yu           2021-10-20  2627  		if (ret)
fc8f19cc5dce18 Christoph Hellwig 2020-01-24  2628  			goto out_free_sb;
50246693f81fe8 Christoph Hellwig 2020-01-24  2629  	}
50246693f81fe8 Christoph Hellwig 2020-01-24  2630  
f59fce847fc848 Kent Overstreet   2013-05-15  2631  	kfree(sb);
f59fce847fc848 Kent Overstreet   2013-05-15  2632  	kfree(path);
f59fce847fc848 Kent Overstreet   2013-05-15  2633  	module_put(THIS_MODULE);
9e23ccf8f0a22e Coly Li           2020-05-27  2634  async_done:
50246693f81fe8 Christoph Hellwig 2020-01-24  2635  	return size;
f59fce847fc848 Kent Overstreet   2013-05-15  2636  
867f981b0739bd Jan Kara          2023-06-21  2637  out_free_holder:
867f981b0739bd Jan Kara          2023-06-21  2638  	kfree(holder);
50246693f81fe8 Christoph Hellwig 2020-01-24  2639  out_put_sb_page:
cfa0c56db9c087 Christoph Hellwig 2020-01-24  2640  	put_page(virt_to_page(sb_disk));
50246693f81fe8 Christoph Hellwig 2020-01-24  2641  out_blkdev_put:
ee9eea7d8b1a83 Jan Kara          2023-06-21  2642  	blkdev_put(bdev, holder);
50246693f81fe8 Christoph Hellwig 2020-01-24  2643  out_free_sb:
50246693f81fe8 Christoph Hellwig 2020-01-24  2644  	kfree(sb);
50246693f81fe8 Christoph Hellwig 2020-01-24  2645  out_free_path:
50246693f81fe8 Christoph Hellwig 2020-01-24  2646  	kfree(path);
ae3cd299919af6 Coly Li           2020-01-24  2647  	path = NULL;
50246693f81fe8 Christoph Hellwig 2020-01-24  2648  out_module_put:
50246693f81fe8 Christoph Hellwig 2020-01-24  2649  	module_put(THIS_MODULE);
50246693f81fe8 Christoph Hellwig 2020-01-24  2650  out:
ee9eea7d8b1a83 Jan Kara          2023-06-21  2651  	if (!quiet)
46f5aa8806e34f Joe Perches       2020-05-27  2652  		pr_info("error %s: %s\n", path?path:"", err);
50246693f81fe8 Christoph Hellwig 2020-01-24  2653  	return ret;
cafe563591446c Kent Overstreet   2013-03-23  2654  }
cafe563591446c Kent Overstreet   2013-03-23  2655  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
