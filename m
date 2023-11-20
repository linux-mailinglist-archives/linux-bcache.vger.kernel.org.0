Return-Path: <linux-bcache+bounces-19-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BB5D7F0D15
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 08:59:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C71831F2171B
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 07:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF4DD519;
	Mon, 20 Nov 2023 07:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nKJc63P2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C96B4;
	Sun, 19 Nov 2023 23:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700467162; x=1732003162;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cwvEB9QFyUlsIvhjn7SwmzSn+4+fIOdLItgaxTwoQws=;
  b=nKJc63P2tSKnD4VuY9GDaLdP9BzX9XDV9STa0ZIQcrnYVELH2PUFwh+s
   i4uZCCL8BzSrq/P1jRDdTh5G8v51wMAdoLIo2E37pIoEw7VpXIRMUNkA3
   /xk3QFirWy7W5s3hTzxJLeMDAGBigroPrhyR9BxFvHCTZ6eU0y2uO2DL8
   3S/pjtOYeoBhdfxuBf0LdjGg3dQTm8fpB4mh21slj8+ErQx2u+dsfUNml
   8DbHYUu/vLDtP+nwBPg1hkXdTE6qLz4zxiBkGuo2ERvvFE3ggF7qP8Ldd
   joFQAyZ2p91s9UmkGl/1VNnIVZxG5izrtDNV/GJoDgnBxwksCW6fAA2dD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10899"; a="390432910"
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="390432910"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2023 23:59:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10899"; a="1097677169"
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="1097677169"
Received: from lkp-server02.sh.intel.com (HELO b8de5498638e) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 19 Nov 2023 23:59:19 -0800
Received: from kbuild by b8de5498638e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r4zBc-0006CA-2n;
	Mon, 20 Nov 2023 07:59:16 +0000
Date: Mon, 20 Nov 2023 15:58:40 +0800
From: kernel test robot <lkp@intel.com>
To: Kent Overstreet <kmo@daterainc.com>, linux-bcachefs@vger.kernel.org,
	linux-bcache@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Kent Overstreet <kmo@daterainc.com>,
	Kees Cook <keescook@chromium.org>, Coly Li <colyli@suse.de>
Subject: Re: [PATCH] closures: CLOSURE_CALLBACK() to fix type punning
Message-ID: <202311201549.FNQyD6Xl-lkp@intel.com>
References: <20231120030729.3285278-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120030729.3285278-1-kent.overstreet@linux.dev>

Hi Kent,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.7-rc2 next-20231120]
[cannot apply to kees/for-next/pstore kees/for-next/kspp]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kent-Overstreet/closures-CLOSURE_CALLBACK-to-fix-type-punning/20231120-110920
base:   linus/master
patch link:    https://lore.kernel.org/r/20231120030729.3285278-1-kent.overstreet%40linux.dev
patch subject: [PATCH] closures: CLOSURE_CALLBACK() to fix type punning
config: x86_64-buildonly-randconfig-005-20231120 (https://download.01.org/0day-ci/archive/20231120/202311201549.FNQyD6Xl-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231120/202311201549.FNQyD6Xl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311201549.FNQyD6Xl-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/md/bcache/request.c:309: warning: Function parameter or member 'bch_data_insert' not described in 'CLOSURE_CALLBACK'
>> drivers/md/bcache/request.c:309: warning: expecting prototype for bch_data_insert(). Prototype was for CLOSURE_CALLBACK() instead


vim +309 drivers/md/bcache/request.c

cafe563591446c Kent Overstreet 2013-03-23  287  
cafe563591446c Kent Overstreet 2013-03-23  288  /**
a34a8bfd4e6358 Kent Overstreet 2013-10-24  289   * bch_data_insert - stick some data in the cache
47344e330eabc1 Bart Van Assche 2018-03-18  290   * @cl: closure pointer.
cafe563591446c Kent Overstreet 2013-03-23  291   *
cafe563591446c Kent Overstreet 2013-03-23  292   * This is the starting point for any data to end up in a cache device; it could
cafe563591446c Kent Overstreet 2013-03-23  293   * be from a normal write, or a writeback write, or a write to a flash only
cafe563591446c Kent Overstreet 2013-03-23  294   * volume - it's also used by the moving garbage collector to compact data in
cafe563591446c Kent Overstreet 2013-03-23  295   * mostly empty buckets.
cafe563591446c Kent Overstreet 2013-03-23  296   *
cafe563591446c Kent Overstreet 2013-03-23  297   * It first writes the data to the cache, creating a list of keys to be inserted
cafe563591446c Kent Overstreet 2013-03-23  298   * (if the data had to be fragmented there will be multiple keys); after the
cafe563591446c Kent Overstreet 2013-03-23  299   * data is written it calls bch_journal, and after the keys have been added to
cafe563591446c Kent Overstreet 2013-03-23  300   * the next journal write they're inserted into the btree.
cafe563591446c Kent Overstreet 2013-03-23  301   *
3db4d0783eaf2a Shenghui Wang   2018-12-13  302   * It inserts the data in op->bio; bi_sector is used for the key offset,
cafe563591446c Kent Overstreet 2013-03-23  303   * and op->inode is used for the key inode.
cafe563591446c Kent Overstreet 2013-03-23  304   *
3db4d0783eaf2a Shenghui Wang   2018-12-13  305   * If op->bypass is true, instead of inserting the data it invalidates the
3db4d0783eaf2a Shenghui Wang   2018-12-13  306   * region of the cache represented by op->bio and op->inode.
cafe563591446c Kent Overstreet 2013-03-23  307   */
b945f655e6185e Kent Overstreet 2023-11-19  308  CLOSURE_CALLBACK(bch_data_insert)
cafe563591446c Kent Overstreet 2013-03-23 @309  {
b945f655e6185e Kent Overstreet 2023-11-19  310  	closure_type(op, struct data_insert_op, cl);
cafe563591446c Kent Overstreet 2013-03-23  311  
60ae81eee86dd7 Slava Pestov    2014-05-22  312  	trace_bcache_write(op->c, op->inode, op->bio,
60ae81eee86dd7 Slava Pestov    2014-05-22  313  			   op->writeback, op->bypass);
220bb38c21b83e Kent Overstreet 2013-09-10  314  
220bb38c21b83e Kent Overstreet 2013-09-10  315  	bch_keylist_init(&op->insert_keys);
220bb38c21b83e Kent Overstreet 2013-09-10  316  	bio_get(op->bio);
b945f655e6185e Kent Overstreet 2023-11-19  317  	bch_data_insert_start(&cl->work);
cafe563591446c Kent Overstreet 2013-03-23  318  }
cafe563591446c Kent Overstreet 2013-03-23  319  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

