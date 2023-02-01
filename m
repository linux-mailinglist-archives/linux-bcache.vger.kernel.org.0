Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1755686D9D
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Feb 2023 19:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjBASFY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Feb 2023 13:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBASFX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Feb 2023 13:05:23 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5995B58E
        for <linux-bcache@vger.kernel.org>; Wed,  1 Feb 2023 10:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675274711; x=1706810711;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o0Z655HtuO5myBzjOa1xZ+wMK4znPKAfOzEZFZhUmKg=;
  b=Ue8heO1wxY+VvvEDfR/0gghxczAWgCun9HSbANJMpw2zOwPboplmo0X1
   FD9kRB0PTB6E7smMZxf2w8Spu7ZcfG8yphnaqsFFQKZzU8XSLmtjzxP0p
   VotUv4uRJSiMeOIzkijyeLR6tWHYBlodMmelx+nnKFWMkNSoTqSya+q4V
   /ehgng7k7j2iF3W3wbuN7abw1x2s8hROwWAinWnyefVOLvVsriDH2thtV
   0K0StUw0YqbGf/vARYdpt20mhbTH82NgTmRgUj/ArN4q4PuJuaIIeV72x
   2NCamWVtiO4sfiUP9gSZeYvtRIvMmwx9ISJ6U43RZ0AXu04mY6iWJdS5T
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="390615843"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="390615843"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 10:04:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="788972328"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="788972328"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 01 Feb 2023 10:03:41 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNHSO-0005fI-1e;
        Wed, 01 Feb 2023 18:03:40 +0000
Date:   Thu, 2 Feb 2023 02:02:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     mingzhe.zou@easystack.cn, colyli@suse.de,
        andrea.tomassetti-opensource@devo.com, bcache@lists.ewheeler.net
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        zoumingzhe@qq.com, Dongsheng Yang <dongsheng.yang@easystack.cn>,
        mingzhe <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH 3/3] bcache: support overlay bcache
Message-ID: <202302020147.4HT8cQF3-lkp@intel.com>
References: <20230201065202.17610-3-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201065202.17610-3-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.2-rc6 next-20230201]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/mingzhe-zou-easystack-cn/bcache-submit-writeback-inflight-dirty-writes-in-batch/20230201-145421
patch link:    https://lore.kernel.org/r/20230201065202.17610-3-mingzhe.zou%40easystack.cn
patch subject: [PATCH 3/3] bcache: support overlay bcache
config: x86_64-randconfig-a014-20230130 (https://download.01.org/0day-ci/archive/20230202/202302020147.4HT8cQF3-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/785b6ea709e3008e2df009d5555c80db709e6d5f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review mingzhe-zou-easystack-cn/bcache-submit-writeback-inflight-dirty-writes-in-batch/20230201-145421
        git checkout 785b6ea709e3008e2df009d5555c80db709e6d5f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/md/bcache/super.c:1475:34: error: implicit declaration of function 'part_to_dev' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
           ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
                                           ^
>> drivers/md/bcache/super.c:1475:62: error: member reference type 'int' is not a pointer
           ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
                                           ~~~~~~~~~~~~~~~~~~~~~~~~~~  ^
>> drivers/md/bcache/super.c:1475:52: error: no member named 'bd_part' in 'struct block_device'
           ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
                                                       ~~~~  ^
   drivers/md/bcache/super.c:2403:34: error: implicit declaration of function 'part_to_dev' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
           ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
                                           ^
   drivers/md/bcache/super.c:2403:62: error: member reference type 'int' is not a pointer
           ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
                                           ~~~~~~~~~~~~~~~~~~~~~~~~~~  ^
   drivers/md/bcache/super.c:2403:52: error: no member named 'bd_part' in 'struct block_device'
           ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
                                                       ~~~~  ^
   6 errors generated.


vim +/part_to_dev +1475 drivers/md/bcache/super.c

  1453	
  1454	static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
  1455					 struct block_device *bdev,
  1456					 struct cached_dev *dc)
  1457	{
  1458		const char *err = "cannot allocate memory";
  1459		struct cache_set *c;
  1460		int ret = -ENOMEM;
  1461	
  1462		memcpy(&dc->sb, sb, sizeof(struct cache_sb));
  1463		dc->bdev = bdev;
  1464		dc->bdev->bd_holder = dc;
  1465		dc->sb_disk = sb_disk;
  1466	
  1467		if (cached_dev_init(dc, sb->block_size << 9))
  1468			goto err;
  1469	
  1470		err = "error creating kobject";
  1471		if (kobject_add(&dc->disk.kobj, bdev_kobj(bdev), "bcache_bdev"))
  1472			goto err;
  1473	
  1474		err = "error creating lagacy sysfs link";
> 1475		ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
  1476					       &dc->disk.kobj, "bcache");
  1477		if (ret && ret != -EEXIST) {
  1478			pr_err("Couldn't create lagacy disk sysfs ->bcache");
  1479			goto err;
  1480		}
  1481	
  1482		if (bch_cache_accounting_add_kobjs(&dc->accounting, &dc->disk.kobj))
  1483			goto err;
  1484	
  1485		pr_info("registered backing device %pg\n", dc->bdev);
  1486	
  1487		list_add(&dc->list, &uncached_devices);
  1488		/* attach to a matched cache set if it exists */
  1489		list_for_each_entry(c, &bch_cache_sets, list)
  1490			bch_cached_dev_attach(dc, c, NULL);
  1491	
  1492		if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
  1493		    BDEV_STATE(&dc->sb) == BDEV_STATE_STALE) {
  1494			err = "failed to run cached device";
  1495			ret = bch_cached_dev_run(dc);
  1496			if (ret)
  1497				goto err;
  1498		}
  1499	
  1500		return 0;
  1501	err:
  1502		pr_notice("error %pg: %s\n", dc->bdev, err);
  1503		bcache_device_stop(&dc->disk);
  1504		return ret;
  1505	}
  1506	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
