Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3591739468
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 03:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjFVBXg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Jun 2023 21:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjFVBXe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2023 21:23:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E889B7;
        Wed, 21 Jun 2023 18:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687397012; x=1718933012;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sEab5jQzvmbvFz7vjdp5HVT4UH6QLmjGrBDme7unp/k=;
  b=WusKErei7liqTQ+b9BrvliSh21/6SwL7YvbI34j/zbgJMvSQLN9l4UgW
   8x2FJs72/rL9Sis3THtVbcDnbPurWIm6ZmhJd2F7cjmOsjIpxJiB9Mr24
   pupYqA2llLtt6qWEeRcAaoEFPx8FnaqQ8RuR6Ibw2TeXTM/O189YesrFh
   jiM8kw2B406lbpLs1mNfaaZwLKd17oixENQuOX9bkQPeQMv346MaTKrnD
   kLRoOdei96tyMxP+01DqRin8kTDMBb5yTW0aaLP/eupJU+S4x+60Nsyq8
   hWdY/nx8Ba9IfbmgNCR87RP0LX4ubYvoi2RiuWfBANUQi/wJzJHyhrgsb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="363784320"
X-IronPort-AV: E=Sophos;i="6.00,262,1681196400"; 
   d="scan'208";a="363784320"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 18:23:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="859232010"
X-IronPort-AV: E=Sophos;i="6.00,262,1681196400"; 
   d="scan'208";a="859232010"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 21 Jun 2023 18:23:24 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qC92h-0007Dn-2v;
        Thu, 22 Jun 2023 01:23:23 +0000
Date:   Thu, 22 Jun 2023 09:23:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Cc:     oe-kbuild-all@lists.linux.dev,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] bcache: Fix bcache device claiming
Message-ID: <202306220927.dRUNZbek-lkp@intel.com>
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
[cannot apply to linus/master v6.4-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jan-Kara/bcache-Alloc-holder-object-before-async-registration/20230622-002543
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-6.5/block
patch link:    https://lore.kernel.org/r/20230621162333.30027-2-jack%40suse.cz
patch subject: [PATCH 2/2] bcache: Fix bcache device claiming
config: s390-defconfig (https://download.01.org/0day-ci/archive/20230622/202306220927.dRUNZbek-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230622/202306220927.dRUNZbek-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306220927.dRUNZbek-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   drivers/md/bcache/super.c: In function 'register_bcache':
>> drivers/md/bcache/super.c:2574:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
    2574 |         if (IS_ERR(bdev))
         |         ^~
   drivers/md/bcache/super.c:2576:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
    2576 |                 if (bdev == ERR_PTR(-EBUSY)) {
         |                 ^~
>> drivers/md/bcache/super.c:2591:17: error: label 'out_free_holder' used but not defined
    2591 |                 goto out_free_holder;
         |                 ^~~~
>> drivers/md/bcache/super.c:2566:17: error: label 'out_put_sb_page' used but not defined
    2566 |                 goto out_put_sb_page;
         |                 ^~~~
>> drivers/md/bcache/super.c:2560:17: error: label 'out_blkdev_put' used but not defined
    2560 |                 goto out_blkdev_put;
         |                 ^~~~
>> drivers/md/bcache/super.c:2552:17: error: label 'out_free_sb' used but not defined
    2552 |                 goto out_free_sb;
         |                 ^~~~
>> drivers/md/bcache/super.c:2546:17: error: label 'out_free_path' used but not defined
    2546 |                 goto out_free_path;
         |                 ^~~~
>> drivers/md/bcache/super.c:2542:17: error: label 'out_module_put' used but not defined
    2542 |                 goto out_module_put;
         |                 ^~~~
>> drivers/md/bcache/super.c:2530:17: error: label 'out' used but not defined
    2530 |                 goto out;
         |                 ^~~~
>> drivers/md/bcache/super.c:2521:14: warning: variable 'quiet' set but not used [-Wunused-but-set-variable]
    2521 |         bool quiet = false;
         |              ^~~~~
   drivers/md/bcache/super.c:2520:14: warning: unused variable 'async_registration' [-Wunused-variable]
    2520 |         bool async_registration = false;
         |              ^~~~~~~~~~~~~~~~~~
>> drivers/md/bcache/super.c:2519:17: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
    2519 |         ssize_t ret;
         |                 ^~~
   drivers/md/bcache/super.c:2592:9: error: no return statement in function returning non-void [-Werror=return-type]
    2592 |         }
         |         ^
   drivers/md/bcache/super.c: At top level:
>> drivers/md/bcache/super.c:2594:9: warning: data definition has no type or storage class
    2594 |         err = "failed to register device";
         |         ^~~
>> drivers/md/bcache/super.c:2594:9: error: type defaults to 'int' in declaration of 'err' [-Werror=implicit-int]
>> drivers/md/bcache/super.c:2594:15: warning: initialization of 'int' from 'char *' makes integer from pointer without a cast [-Wint-conversion]
    2594 |         err = "failed to register device";
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/bcache/super.c:2594:15: error: initializer element is not computable at load time
>> drivers/md/bcache/super.c:2596:9: error: expected identifier or '(' before 'if'
    2596 |         if (async_registration) {
         |         ^~
   drivers/md/bcache/super.c:2617:9: error: expected identifier or '(' before 'if'
    2617 |         if (SB_IS_BDEV(sb)) {
         |         ^~
>> drivers/md/bcache/super.c:2624:11: error: expected identifier or '(' before 'else'
    2624 |         } else {
         |           ^~~~
   drivers/md/bcache/super.c:2631:9: warning: data definition has no type or storage class
    2631 |         kfree(sb);
         |         ^~~~~
>> drivers/md/bcache/super.c:2631:9: error: type defaults to 'int' in declaration of 'kfree' [-Werror=implicit-int]
>> drivers/md/bcache/super.c:2631:9: warning: parameter names (without types) in function declaration
>> drivers/md/bcache/super.c:2631:9: error: conflicting types for 'kfree'; have 'int()'
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
>> include/linux/export.h:27:21: error: expected declaration specifiers or '...' before '(' token
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
    2647 |         path = NULL;
         |                ^~~~
   drivers/md/bcache/super.c:2648:15: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
    2648 | out_module_put:
         |               ^
   drivers/md/bcache/super.c:2650:4: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
    2650 | out:
         |    ^
   In file included from include/asm-generic/bug.h:22,
                    from arch/s390/include/asm/bug.h:69,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from arch/s390/include/asm/preempt.h:6,
                    from include/linux/preempt.h:78:
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


vim +/out_free_holder +2591 drivers/md/bcache/super.c

  2509	
  2510	static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
  2511				       const char *buffer, size_t size)
  2512	{
  2513		const char *err;
  2514		char *path = NULL;
  2515		struct cache_sb *sb;
  2516		struct cache_sb_disk *sb_disk;
  2517		struct block_device *bdev, *bdev2;
  2518		void *holder = NULL;
> 2519		ssize_t ret;
  2520		bool async_registration = false;
> 2521		bool quiet = false;
  2522	
  2523	#ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
  2524		async_registration = true;
  2525	#endif
  2526	
  2527		ret = -EBUSY;
  2528		err = "failed to reference bcache module";
  2529		if (!try_module_get(THIS_MODULE))
> 2530			goto out;
  2531	
  2532		/* For latest state of bcache_is_reboot */
  2533		smp_mb();
  2534		err = "bcache is in reboot";
  2535		if (bcache_is_reboot)
  2536			goto out_module_put;
  2537	
  2538		ret = -ENOMEM;
  2539		err = "cannot allocate memory";
  2540		path = kstrndup(buffer, size, GFP_KERNEL);
  2541		if (!path)
> 2542			goto out_module_put;
  2543	
  2544		sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL);
  2545		if (!sb)
> 2546			goto out_free_path;
  2547	
  2548		ret = -EINVAL;
  2549		err = "failed to open device";
  2550		bdev = blkdev_get_by_path(strim(path), BLK_OPEN_READ, NULL, NULL);
  2551		if (IS_ERR(bdev))
> 2552			goto out_free_sb;
  2553	
  2554		err = "failed to set blocksize";
  2555		if (set_blocksize(bdev, 4096))
  2556			goto out_blkdev_put;
  2557	
  2558		err = read_super(sb, bdev, &sb_disk);
  2559		if (err)
> 2560			goto out_blkdev_put;
  2561	
  2562		holder = alloc_holder_object(sb);
  2563		if (!holder) {
  2564			ret = -ENOMEM;
  2565			err = "cannot allocate memory";
> 2566			goto out_put_sb_page;
  2567		}
  2568	
  2569		/* Now reopen in exclusive mode with proper holder */
  2570		bdev2 = blkdev_get_by_dev(bdev->bd_dev, BLK_OPEN_READ | BLK_OPEN_WRITE,
  2571					  holder, NULL);
  2572		blkdev_put(bdev, NULL);
  2573		bdev = bdev2;
> 2574		if (IS_ERR(bdev))
  2575			ret = PTR_ERR(bdev);
> 2576			if (bdev == ERR_PTR(-EBUSY)) {
  2577				dev_t dev;
  2578	
  2579				mutex_lock(&bch_register_lock);
  2580				if (lookup_bdev(strim(path), &dev) == 0 &&
  2581				    bch_is_open(dev))
  2582					err = "device already registered";
  2583				else
  2584					err = "device busy";
  2585				mutex_unlock(&bch_register_lock);
  2586				if (attr == &ksysfs_register_quiet) {
  2587					quiet = true;
  2588					ret = size;
  2589				}
  2590			}
> 2591			goto out_free_holder;
> 2592		}
  2593	
> 2594		err = "failed to register device";
  2595	
> 2596		if (async_registration) {
  2597			/* register in asynchronous way */
  2598			struct async_reg_args *args =
  2599				kzalloc(sizeof(struct async_reg_args), GFP_KERNEL);
  2600	
  2601			if (!args) {
  2602				ret = -ENOMEM;
  2603				err = "cannot allocate memory";
  2604				goto out_free_holder;
  2605			}
  2606	
  2607			args->path	= path;
  2608			args->sb	= sb;
  2609			args->sb_disk	= sb_disk;
  2610			args->bdev	= bdev;
  2611			args->holder	= holder;
  2612			register_device_async(args);
  2613			/* No wait and returns to user space */
  2614			goto async_done;
  2615		}
  2616	
> 2617		if (SB_IS_BDEV(sb)) {
  2618			mutex_lock(&bch_register_lock);
  2619			ret = register_bdev(sb, sb_disk, bdev, holder);
  2620			mutex_unlock(&bch_register_lock);
  2621			/* blkdev_put() will be called in cached_dev_free() */
  2622			if (ret < 0)
  2623				goto out_free_sb;
> 2624		} else {
  2625			/* blkdev_put() will be called in bch_cache_release() */
  2626			ret = register_cache(sb, sb_disk, bdev, holder);
  2627			if (ret)
  2628				goto out_free_sb;
  2629		}
  2630	
> 2631		kfree(sb);
  2632		kfree(path);
> 2633		module_put(THIS_MODULE);
> 2634	async_done:
  2635		return size;
  2636	
  2637	out_free_holder:
  2638		kfree(holder);
  2639	out_put_sb_page:
  2640		put_page(virt_to_page(sb_disk));
  2641	out_blkdev_put:
  2642		blkdev_put(bdev, holder);
> 2643	out_free_sb:
  2644		kfree(sb);
  2645	out_free_path:
  2646		kfree(path);
> 2647		path = NULL;
  2648	out_module_put:
  2649		module_put(THIS_MODULE);
  2650	out:
  2651		if (!quiet)
> 2652			pr_info("error %s: %s\n", path?path:"", err);
> 2653		return ret;
> 2654	}
  2655	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
