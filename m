Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5A64D458B
	for <lists+linux-bcache@lfdr.de>; Thu, 10 Mar 2022 12:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbiCJLT6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 10 Mar 2022 06:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239091AbiCJLT5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 10 Mar 2022 06:19:57 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267309ADBF
        for <linux-bcache@vger.kernel.org>; Thu, 10 Mar 2022 03:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646911137; x=1678447137;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8P1VHMUDhNY3aMi1ZjGFkRLuU3vkNLTK5DtJST3KEAY=;
  b=Yu/QITaOafPnvITV4ZsDz1gmGYiAUWgEhXUdPrsqZaIV8DcGJaJV95s8
   FO8Q5c2DhAPcnsOzE5VWIzjFyjlfijrwmj/KVfo23FGYG0XsBokQi7u/o
   /8W4NqeBpptyzpZgng8Uc9R5QdvjN0RzXvzsfxY82kVvNGiCfRGOOfFe0
   Ryk3IyivNKQURyLa8suEL8yQnwiv/APUN8/WLbsG+XAHVeqQH00VPK2G+
   /EqE5NOMKWowQfD8BgNgV5igjfj6ohcwxZF9MwMcKgmN4tycej/1QHLfb
   opuboKb4CCySXiur618x2ni/di3YEgwnOIlQ+74hSK7LJXyH8I7iH8m1M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="254962699"
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="254962699"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 03:18:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="712325492"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 10 Mar 2022 03:18:54 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSGoo-0004py-4d; Thu, 10 Mar 2022 11:18:54 +0000
Date:   Thu, 10 Mar 2022 19:18:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrea Tomassetti <andrea.tomassetti@devo.com>,
        linux-bcache@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Coly Li <colyli@suse.de>,
        Kent Overstreet <kmo@daterainc.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>,
        Andrea Tomassetti <andrea.tomassetti@devo.com>
Subject: Re: [PATCH] bcache: Use bcache without formatting existing device
Message-ID: <202203101939.OFoiVCSH-lkp@intel.com>
References: <20220310085240.334068-1-andrea.tomassetti@devo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310085240.334068-1-andrea.tomassetti@devo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Andrea,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.17-rc7 next-20220309]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Andrea-Tomassetti/bcache-Use-bcache-without-formatting-existing-device/20220310-165353
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220310/202203101939.OFoiVCSH-lkp@intel.com/config)
compiler: gcc-9 (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/b5073e4ece2a86f002ca66fb1d864034c12be3e2
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Andrea-Tomassetti/bcache-Use-bcache-without-formatting-existing-device/20220310-165353
        git checkout b5073e4ece2a86f002ca66fb1d864034c12be3e2
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/md/bcache/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/md/bcache/control.c:18:6: warning: no previous prototype for 'bch_service_ioctl_ctrl' [-Wmissing-prototypes]
      18 | long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
         |      ^~~~~~~~~~~~~~~~~~~~~~


vim +/bch_service_ioctl_ctrl +18 drivers/md/bcache/control.c

    15	
    16	/* this handles IOCTL for /dev/bcache_ctrl */
    17	/*********************************************/
  > 18	long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
    19			unsigned long arg)
    20	{
    21		int retval = 0;
    22	
    23		if (_IOC_TYPE(cmd) != BCH_IOCTL_MAGIC)
    24			return -EINVAL;
    25	
    26		if (!capable(CAP_SYS_ADMIN)) {
    27			/* Must be root to issue ioctls */
    28			return -EPERM;
    29		}
    30	
    31		switch (cmd) {
    32		case BCH_IOCTL_REGISTER_DEVICE: {
    33			struct bch_register_device *cmd_info;
    34	
    35			cmd_info = vmalloc(sizeof(struct bch_register_device));
    36			if (!cmd_info)
    37				return -ENOMEM;
    38	
    39			if (copy_from_user(cmd_info, (void __user *)arg,
    40					sizeof(struct bch_register_device))) {
    41				pr_err("Cannot copy cmd info from user space\n");
    42				vfree(cmd_info);
    43				return -EINVAL;
    44			}
    45	
    46			retval = register_bcache_ioctl(cmd_info);
    47	
    48			vfree(cmd_info);
    49			return retval;
    50		}
    51	
    52		default:
    53			return -EINVAL;
    54		}
    55	}
    56	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
