Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EE3687086
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Feb 2023 22:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBAVj6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Feb 2023 16:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBAVj5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Feb 2023 16:39:57 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D093045887
        for <linux-bcache@vger.kernel.org>; Wed,  1 Feb 2023 13:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675287595; x=1706823595;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E349jM/kwjl5HlI8qq0f7Mh0xl5qabzrVNPAGr8GscQ=;
  b=T3xXQ8kIu7Oe+3GVhGYQ//1hiiAqsORIGvjDdv4P526wxsAGzVxoL3BI
   u6+/+APTBbuBMu5qVA+zLUc3A72zeCwveNvnu8ps6dGXsbI+r2vJV5UEK
   w8HXiZ/yKoL9oJqnZZpYHPRP4GtnQ4u0keLdVneYEpdrkoKd9+H31ONmD
   s/hJuoRjjIkPEcQAPOs8zslOVwdyhz7YEg78dxB17HHoDe3pP0xJHxzad
   MeTXmYeLQ62Hu9YrsHCng8SJXSM/dT9f+TeHgECxInK8qJfQs/zw+gkHD
   CHUe2OeJj+NjuXRSALSOuyk3MqCarNDs+F0icJU0RBMvfOLgE4kB0dyGN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="308624048"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="308624048"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 13:39:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="614998243"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="614998243"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 01 Feb 2023 13:39:51 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNKpa-0005pm-1X;
        Wed, 01 Feb 2023 21:39:50 +0000
Date:   Thu, 2 Feb 2023 05:39:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     mingzhe.zou@easystack.cn, colyli@suse.de,
        andrea.tomassetti-opensource@devo.com, bcache@lists.ewheeler.net
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        zoumingzhe@qq.com, Dongsheng Yang <dongsheng.yang@easystack.cn>,
        mingzhe <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH 3/3] bcache: support overlay bcache
Message-ID: <202302020507.y0NPeWHf-lkp@intel.com>
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
config: riscv-randconfig-r042-20230130 (https://download.01.org/0day-ci/archive/20230202/202302020507.y0NPeWHf-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 4196ca3278f78c6e19246e54ab0ecb364e37d66a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/785b6ea709e3008e2df009d5555c80db709e6d5f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review mingzhe-zou-easystack-cn/bcache-submit-writeback-inflight-dirty-writes-in-batch/20230201-145421
        git checkout 785b6ea709e3008e2df009d5555c80db709e6d5f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/md/bcache/super.c:1475:34: error: call to undeclared function 'part_to_dev'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
                                           ^
   drivers/md/bcache/super.c:1475:62: error: member reference type 'int' is not a pointer
           ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
                                           ~~~~~~~~~~~~~~~~~~~~~~~~~~  ^
   drivers/md/bcache/super.c:1475:52: error: no member named 'bd_part' in 'struct block_device'
           ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
                                                       ~~~~  ^
   drivers/md/bcache/super.c:2403:34: error: call to undeclared function 'part_to_dev'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
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
