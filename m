Return-Path: <linux-bcache+bounces-20-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D5C67F0D16
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 08:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FFC3B210C3
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 07:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A394DDA4;
	Mon, 20 Nov 2023 07:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FPHD7PbW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308CABF;
	Sun, 19 Nov 2023 23:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700467163; x=1732003163;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RkoBlV0ZvQ4yB4slhmGVmoFATZDCQaRMKWluOzLvrLc=;
  b=FPHD7PbWlmSw+VLF8X8fy+p55IpRP7ip6olri8R/6rmlmdmxBjLYBOVS
   TYtbssBxxX8RrqAGy8PcZIlXknbwCWwyBMgliDRIYDLl0wjC9Q02Ds0gH
   KGIjbwq7HfPlRUw5y0cNphZDmJ11ot2A46eDJXR/Q6cMbiMfg55NehClQ
   xN5Uj9zFJEW3Phn+JBeP/p95oIsjWXRwupfHCKler8br0Y/EYiwfx23xy
   iyHlqfRwCYNoUTbs4AuetotDfx7s7plDtHOAZ0hx14iGYWAqHTElQQjXN
   y/9KOfDVw2HWmBCB0SLuGhLDrDowZgoXtpuEAVBw8JUqfv6vI1c+9Pu3p
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10899"; a="390432915"
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="390432915"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2023 23:59:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10899"; a="1097677167"
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="1097677167"
Received: from lkp-server02.sh.intel.com (HELO b8de5498638e) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 19 Nov 2023 23:59:19 -0800
Received: from kbuild by b8de5498638e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r4zBc-0006C3-2Z;
	Mon, 20 Nov 2023 07:59:16 +0000
Date: Mon, 20 Nov 2023 15:58:39 +0800
From: kernel test robot <lkp@intel.com>
To: Kent Overstreet <kmo@daterainc.com>, linux-bcachefs@vger.kernel.org,
	linux-bcache@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Kent Overstreet <kmo@daterainc.com>,
	Kees Cook <keescook@chromium.org>, Coly Li <colyli@suse.de>
Subject: Re: [PATCH] closures: CLOSURE_CALLBACK() to fix type punning
Message-ID: <202311201543.JV4oP14G-lkp@intel.com>
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
[also build test WARNING on v6.7-rc2 next-20231117]
[cannot apply to kees/for-next/pstore kees/for-next/kspp]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kent-Overstreet/closures-CLOSURE_CALLBACK-to-fix-type-punning/20231120-110920
base:   linus/master
patch link:    https://lore.kernel.org/r/20231120030729.3285278-1-kent.overstreet%40linux.dev
patch subject: [PATCH] closures: CLOSURE_CALLBACK() to fix type punning
config: x86_64-buildonly-randconfig-003-20231120 (https://download.01.org/0day-ci/archive/20231120/202311201543.JV4oP14G-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231120/202311201543.JV4oP14G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311201543.JV4oP14G-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/bcachefs/io_write.c:1570: warning: Function parameter or member 'bch2_write' not described in 'CLOSURE_CALLBACK'
>> fs/bcachefs/io_write.c:1570: warning: expecting prototype for bch2_write(). Prototype was for CLOSURE_CALLBACK() instead


vim +1570 fs/bcachefs/io_write.c

4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1551  
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1552  /**
96dea3d599dbc3 fs/bcachefs/io_write.c Kent Overstreet 2023-09-12  1553   * bch2_write() - handle a write to a cache device or flash only volume
96dea3d599dbc3 fs/bcachefs/io_write.c Kent Overstreet 2023-09-12  1554   * @cl:		&bch_write_op->cl
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1555   *
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1556   * This is the starting point for any data to end up in a cache device; it could
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1557   * be from a normal write, or a writeback write, or a write to a flash only
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1558   * volume - it's also used by the moving garbage collector to compact data in
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1559   * mostly empty buckets.
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1560   *
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1561   * It first writes the data to the cache, creating a list of keys to be inserted
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1562   * (if the data won't fit in a single open bucket, there will be multiple keys);
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1563   * after the data is written it calls bch_journal, and after the keys have been
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1564   * added to the next journal write they're inserted into the btree.
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1565   *
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1566   * If op->discard is true, instead of inserting the data it invalidates the
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1567   * region of the cache represented by op->bio and op->inode.
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1568   */
b945f655e6185e fs/bcachefs/io_write.c Kent Overstreet 2023-11-19  1569  CLOSURE_CALLBACK(bch2_write)
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16 @1570  {
b945f655e6185e fs/bcachefs/io_write.c Kent Overstreet 2023-11-19  1571  	closure_type(op, struct bch_write_op, cl);
4b0a66d508d7bf fs/bcachefs/io.c       Kent Overstreet 2019-08-21  1572  	struct bio *bio = &op->wbio.bio;
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1573  	struct bch_fs *c = op->c;
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1574  	unsigned data_len;
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1575  
b17d3cec14b487 fs/bcachefs/io.c       Kent Overstreet 2022-10-31  1576  	EBUG_ON(op->cl.parent);
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1577  	BUG_ON(!op->nr_replicas);
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1578  	BUG_ON(!op->write_point.v);
e88a75ebe86c1d fs/bcachefs/io.c       Kent Overstreet 2022-11-24  1579  	BUG_ON(bkey_eq(op->pos, POS_MAX));
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1580  
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1581  	op->start_time = local_clock();
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1582  	bch2_keylist_init(&op->insert_keys, op->inline_keys);
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1583  	wbio_init(bio)->put_bio = false;
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1584  
8244f3209b5b49 fs/bcachefs/io.c       Kent Overstreet 2021-12-14  1585  	if (bio->bi_iter.bi_size & (c->opts.block_size - 1)) {
7fec8266af12b6 fs/bcachefs/io.c       Kent Overstreet 2022-11-15  1586  		bch_err_inum_offset_ratelimited(c,
7fec8266af12b6 fs/bcachefs/io.c       Kent Overstreet 2022-11-15  1587  			op->pos.inode,
7fec8266af12b6 fs/bcachefs/io.c       Kent Overstreet 2022-11-15  1588  			op->pos.offset << 9,
0fefe8d8ef7402 fs/bcachefs/io.c       Kent Overstreet 2020-12-03  1589  			"misaligned write");
4b0a66d508d7bf fs/bcachefs/io.c       Kent Overstreet 2019-08-21  1590  		op->error = -EIO;
4b0a66d508d7bf fs/bcachefs/io.c       Kent Overstreet 2019-08-21  1591  		goto err;
4b0a66d508d7bf fs/bcachefs/io.c       Kent Overstreet 2019-08-21  1592  	}
4b0a66d508d7bf fs/bcachefs/io.c       Kent Overstreet 2019-08-21  1593  
b40901b0f71825 fs/bcachefs/io.c       Kent Overstreet 2023-03-13  1594  	if (c->opts.nochanges) {
b40901b0f71825 fs/bcachefs/io.c       Kent Overstreet 2023-03-13  1595  		op->error = -BCH_ERR_erofs_no_writes;
b40901b0f71825 fs/bcachefs/io.c       Kent Overstreet 2023-03-13  1596  		goto err;
b40901b0f71825 fs/bcachefs/io.c       Kent Overstreet 2023-03-13  1597  	}
b40901b0f71825 fs/bcachefs/io.c       Kent Overstreet 2023-03-13  1598  
b40901b0f71825 fs/bcachefs/io.c       Kent Overstreet 2023-03-13  1599  	if (!(op->flags & BCH_WRITE_MOVE) &&
d94189ad568f6c fs/bcachefs/io.c       Kent Overstreet 2023-02-09  1600  	    !bch2_write_ref_tryget(c, BCH_WRITE_REF_write)) {
858536c7cea8bb fs/bcachefs/io.c       Kent Overstreet 2022-12-11  1601  		op->error = -BCH_ERR_erofs_no_writes;
4b0a66d508d7bf fs/bcachefs/io.c       Kent Overstreet 2019-08-21  1602  		goto err;
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1603  	}
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1604  
104c69745fdf7e fs/bcachefs/io.c       Daniel Hill     2022-03-15  1605  	this_cpu_add(c->counters[BCH_COUNTER_io_write], bio_sectors(bio));
4b0a66d508d7bf fs/bcachefs/io.c       Kent Overstreet 2019-08-21  1606  	bch2_increment_clock(c, bio_sectors(bio), WRITE);
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1607  
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1608  	data_len = min_t(u64, bio->bi_iter.bi_size,
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1609  			 op->new_i_size - (op->pos.offset << 9));
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1610  
07358a82bb36ff fs/bcachefs/io.c       Kent Overstreet 2019-11-29  1611  	if (c->opts.inline_data &&
07358a82bb36ff fs/bcachefs/io.c       Kent Overstreet 2019-11-29  1612  	    data_len <= min(block_bytes(c) / 2, 1024U)) {
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1613  		bch2_write_data_inline(op, data_len);
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1614  		return;
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1615  	}
4be1a412ea3492 fs/bcachefs/io.c       Kent Overstreet 2019-11-09  1616  
b17d3cec14b487 fs/bcachefs/io.c       Kent Overstreet 2022-10-31  1617  	__bch2_write(op);
4b0a66d508d7bf fs/bcachefs/io.c       Kent Overstreet 2019-08-21  1618  	return;
4b0a66d508d7bf fs/bcachefs/io.c       Kent Overstreet 2019-08-21  1619  err:
4b0a66d508d7bf fs/bcachefs/io.c       Kent Overstreet 2019-08-21  1620  	bch2_disk_reservation_put(c, &op->res);
46e4bb1c378248 fs/bcachefs/io.c       Kent Overstreet 2019-12-27  1621  
b17d3cec14b487 fs/bcachefs/io.c       Kent Overstreet 2022-10-31  1622  	closure_debug_destroy(&op->cl);
b17d3cec14b487 fs/bcachefs/io.c       Kent Overstreet 2022-10-31  1623  	if (op->end_io)
c32bd3ad1fe595 fs/bcachefs/io.c       Kent Overstreet 2019-11-11  1624  		op->end_io(op);
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1625  }
1c6fdbd8f2465d fs/bcachefs/io.c       Kent Overstreet 2017-03-16  1626  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

