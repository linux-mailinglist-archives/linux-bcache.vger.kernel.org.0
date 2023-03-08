Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD5F6B06C6
	for <lists+linux-bcache@lfdr.de>; Wed,  8 Mar 2023 13:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCHMRt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 8 Mar 2023 07:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCHMRs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Mar 2023 07:17:48 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F7C3B85E
        for <linux-bcache@vger.kernel.org>; Wed,  8 Mar 2023 04:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678277867; x=1709813867;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1QaxEmNW1vLTh8ptu/lzEOnT9wluloI7+24syDclYkY=;
  b=jSM2eqsjH37IpRelk77BfEbCPdSNcDnN7nSznpJxm0Hao4YJW38q87WP
   ER01WgzDyQSJTG1OW7gR5FbO/rUbhc2M31+Uq9ERpnv7cuiaSLk1KSADZ
   QiMPNRzww30JPXPMo1DBy1FkNMd/87zUgYSEUPksMYbW33Xj9iePDcjnH
   4ltV/9RTO4e/lCT3ELjX548SHWVEA8XGVqwyiiqE/3zjGpR2e88GyEcaI
   oT4ZVdHIQbaVKWFZe8RCey6xVgNvZtGr3D9V7Zq1LLusm3YbCe1vX3WMj
   LJpYjuexOtNjapV/C771fguzdPVgUO65D1ZltcG43jlnLqBkQPsJXrAy6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="398717342"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="398717342"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 04:17:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="851063974"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="851063974"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 08 Mar 2023 04:17:45 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pZsjo-00027h-1V;
        Wed, 08 Mar 2023 12:17:44 +0000
Date:   Wed, 8 Mar 2023 20:16:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     mingzhe <mingzhe.zou@easystack.cn>, colyli@suse.de,
        bcache@lists.ewheeler.net
Cc:     oe-kbuild-all@lists.linux.dev, linux-bcache@vger.kernel.org,
        zoumingzhe@qq.com
Subject: Re: [PATCH] bcache: set io_disable to true when stop bcache device
Message-ID: <202303082025.PP1BZsDY-lkp@intel.com>
References: <20230308092036.11024-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308092036.11024-1-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi mingzhe,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.3-rc1 next-20230308]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/mingzhe/bcache-set-io_disable-to-true-when-stop-bcache-device/20230308-172245
patch link:    https://lore.kernel.org/r/20230308092036.11024-1-mingzhe.zou%40easystack.cn
patch subject: [PATCH] bcache: set io_disable to true when stop bcache device
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230308/202303082025.PP1BZsDY-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/6a59a84151f42d58e6010f18c92b98cbaf58bdc1
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review mingzhe/bcache-set-io_disable-to-true-when-stop-bcache-device/20230308-172245
        git checkout 6a59a84151f42d58e6010f18c92b98cbaf58bdc1
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/md/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303082025.PP1BZsDY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/md/bcache/request.c: In function 'cached_dev_bio_fail':
>> drivers/md/bcache/request.c:764:28: warning: unused variable 'dc' [-Wunused-variable]
     764 |         struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
         |                            ^~


vim +/dc +764 drivers/md/bcache/request.c

   760	
   761	static void cached_dev_bio_fail(struct closure *cl)
   762	{
   763		struct search *s = container_of(cl, struct search, cl);
 > 764		struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
   765	
   766		s->iop.status = BLK_STS_IOERR;
   767		cached_dev_bio_complete(cl);
   768	}
   769	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
