Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F6950A7E4
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Apr 2022 20:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391024AbiDUSQ0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 21 Apr 2022 14:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391036AbiDUSQZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 21 Apr 2022 14:16:25 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07174B1D4
        for <linux-bcache@vger.kernel.org>; Thu, 21 Apr 2022 11:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650564813; x=1682100813;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wFQwU73IsVOlHG0heObUZaetd8RY1FhxzkrOV7+aPOk=;
  b=L3pS0pZxdFMWKyIU2FChUO0R8oTRDdkbPckEArJm1WpT/7s+91Ug5uMp
   vVT0kUqZiTPN844AROKBXSYpTOoqDRhIjMPoWTLHA54IeHSdA49RMG+bn
   ugWUeS9IyU45XSWkiPnF1m8Ehq1Xb5JVGFArZ7SOlnT6keOzKtTfcnfE3
   8AjHGKkbLgw0OM3xTlJHHfxtza3XSeFjx1LsjZERE+APh7e+QU0gqFFpM
   L+4iz7kOOZeHoiAxfqd4VSSLyHfw/BcRl+v0Pwj9+yjvWSqtMZtpBBuwK
   LBQZx/ENnL3xITPN/rdbanwevpc31+oqnQdM8WTy+soTV6hZNAND+NJfp
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="244362554"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="244362554"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 11:13:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="671161803"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 21 Apr 2022 11:13:31 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhbJ5-0008eR-4n;
        Thu, 21 Apr 2022 18:13:31 +0000
Date:   Fri, 22 Apr 2022 02:12:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     mingzhe.zou@easystack.cn, colyli@suse.de,
        linux-bcache@vger.kernel.org
Cc:     kbuild-all@lists.01.org, zoumingzhe@qq.com
Subject: Re: [PATCH] bcache: dynamic incremental gc
Message-ID: <202204220253.PJykKQfz-lkp@intel.com>
References: <20220421121735.11591-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421121735.11591-1-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.18-rc3 next-20220421]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/mingzhe-zou-easystack-cn/bcache-dynamic-incremental-gc/20220421-201917
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git b253435746d9a4a701b5f09211b9c14d3370d0da
config: m68k-randconfig-r025-20220421 (https://download.01.org/0day-ci/archive/20220422/202204220253.PJykKQfz-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/9934df989e22e2a0da9c61c9c47da9839220570e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review mingzhe-zou-easystack-cn/bcache-dynamic-incremental-gc/20220421-201917
        git checkout 9934df989e22e2a0da9c61c9c47da9839220570e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   m68k-linux-ld: section .rodata VMA [0000000000002000,00000000001d1067] overlaps section .text VMA [0000000000000400,000000000057bf1f]
   m68k-linux-ld: drivers/md/bcache/btree.o: in function `bch_btree_gc':
>> btree.c:(.text+0x54cc): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
