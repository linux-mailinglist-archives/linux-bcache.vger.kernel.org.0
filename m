Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0294F4D4681
	for <lists+linux-bcache@lfdr.de>; Thu, 10 Mar 2022 13:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbiCJMLN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 10 Mar 2022 07:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241836AbiCJMLM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 10 Mar 2022 07:11:12 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B501480C4
        for <linux-bcache@vger.kernel.org>; Thu, 10 Mar 2022 04:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646914211; x=1678450211;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4CtCpqIlNo5aBzxReUSEjXicRfM85sYSubjHc2cGY1Q=;
  b=KnjMs9P2CJzaYPJJZZevXhMo02UgjBYIIOopCPjS3/6TypiNkiwlmxpH
   EOd2S9pNcLXz7C/gF94fOFyUM4043mmM21VhNIUC3HdrkN93HNLJr7Epm
   0nSbPLRMtvZ3j4BuaGTfqccuVCkIBkUNs0q5Oy+4uCDDOjc+WAEDOLE//
   n0gOMXiuAAjjcHklN//GnBHG4vTiGG3pDqebVkXN++zko14CB2p3yN0j6
   3M7IvRRxJ8oma5O1TvZMTFhcCcTqzVDVotZqg/UcKFesVZAbGclDJIMQS
   YnzyXVazZTMlIkIqZ/QWoBq3Ks+DtxX3lDrglcpLwVZ89DeJSZ8tNeNva
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235184249"
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="235184249"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 04:10:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="496234220"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 10 Mar 2022 04:10:01 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSHcH-0004tw-2l; Thu, 10 Mar 2022 12:10:01 +0000
Date:   Thu, 10 Mar 2022 20:09:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrea Tomassetti <andrea.tomassetti@devo.com>,
        linux-bcache@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Coly Li <colyli@suse.de>,
        Kent Overstreet <kmo@daterainc.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>,
        Andrea Tomassetti <andrea.tomassetti@devo.com>
Subject: Re: [PATCH] bcache: Use bcache without formatting existing device
Message-ID: <202203102007.cDiegien-lkp@intel.com>
References: <20220310085240.334068-1-andrea.tomassetti@devo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310085240.334068-1-andrea.tomassetti@devo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20220310/202203102007.cDiegien-lkp@intel.com/config)
compiler: gcc-9 (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/b5073e4ece2a86f002ca66fb1d864034c12be3e2
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Andrea-Tomassetti/bcache-Use-bcache-without-formatting-existing-device/20220310-165353
        git checkout b5073e4ece2a86f002ca66fb1d864034c12be3e2
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash drivers/md/bcache/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/md/bcache/control.c:18:6: sparse: sparse: symbol 'bch_service_ioctl_ctrl' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
