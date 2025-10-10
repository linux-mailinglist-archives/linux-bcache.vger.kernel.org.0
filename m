Return-Path: <linux-bcache+bounces-1217-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6417DBCDEE9
	for <lists+linux-bcache@lfdr.de>; Fri, 10 Oct 2025 18:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4E5574E1259
	for <lists+linux-bcache@lfdr.de>; Fri, 10 Oct 2025 16:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64C32FBDF7;
	Fri, 10 Oct 2025 16:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L1xMUIv2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEDE2FBDF0
	for <linux-bcache@vger.kernel.org>; Fri, 10 Oct 2025 16:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760112842; cv=none; b=o56vkyVClo4KvV/jqlnngBSKvWBgyPU1ERssSglW77KZnsF88gRbHzm8CSYAGckU/7jYtvoTFBlokQ7hXDJnxxe51FlP2LYht4nzvnrnEK9R0KmX/JrNTjfuIhPq+qJj9n3VD4w8bY2oY/y9IYa4iAjy965j2nL8hN0u3KtQzkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760112842; c=relaxed/simple;
	bh=/WF6DzFJyiKCHlVi25r34vlH9BWUy3HEwcWmcnYD5YU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxeDjNeGxDIQB/O7+0pT1KO40A4HRpRiSO96UQH27MTm5UrAR8p7iCn3SfEzy89kMbWFDgTFwslQInqW28eYUEEnELYR/gOYDTekMXEi6+2J3Xc/Ybl5zuXXxfVW3i+elgHYz2Pm3mHxACfxVXR5SOtI15ajC5iO/oSTzteIrTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L1xMUIv2; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760112840; x=1791648840;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/WF6DzFJyiKCHlVi25r34vlH9BWUy3HEwcWmcnYD5YU=;
  b=L1xMUIv2GQTaufMp3IwxQmFFZWI9fPi8OsDLbIn8sSfCWoUpFhweNV4a
   gZpHsKjh3UklngeEao0gBnb6ZEP0j6kTnG6kWJ8VXld0VcM9LpDeIzBTP
   Aj+ttZ9ZcGUhJSn+CvnN4sul/gxjFkXIgwyoxHmW/Y7pLwYuDHhXX75fn
   hSyj2ya3igX+0nLY/csA9g388TRdR0q3t+CViSGa1D0T6G+tzmInwJSaL
   gxzkw8RuDahjJ04252D2iMYCO0CmXPqt6Uz7XpO8NlARp10/v3X6w88E6
   HiUZiqz1aGHDz9c/n0708klil4zro9zCE43sV/0iTuBgAqdI90yPGX/QY
   A==;
X-CSE-ConnectionGUID: 0BzG5wH1QRSEHfLDXL+YUg==
X-CSE-MsgGUID: wSnsxXTZTV2yApnIP2aEZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="62037851"
X-IronPort-AV: E=Sophos;i="6.19,219,1754982000"; 
   d="scan'208";a="62037851"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 09:14:00 -0700
X-CSE-ConnectionGUID: YlgVIwVyTyG8nJHsoFIwWA==
X-CSE-MsgGUID: vwKkMFX7SQOLg8ujto5xPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,219,1754982000"; 
   d="scan'208";a="211961210"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 10 Oct 2025 09:13:57 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7Fkh-0002wh-19;
	Fri, 10 Oct 2025 16:13:55 +0000
Date: Sat, 11 Oct 2025 00:13:49 +0800
From: kernel test robot <lkp@intel.com>
To: colyli@fnnas.com, linux-bcache@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Coly Li <colyli@fnnas.com>, Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Subject: Re: [PATCH] bcache: avoid redundant access RB tree in read_dirty
Message-ID: <202510110048.PdCCuB3b-lkp@intel.com>
References: <20251007090232.30386-1-colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007090232.30386-1-colyli@fnnas.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.17 next-20251010]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/colyli-fnnas-com/bcache-avoid-redundant-access-RB-tree-in-read_dirty/20251010-103843
base:   linus/master
patch link:    https://lore.kernel.org/r/20251007090232.30386-1-colyli%40fnnas.com
patch subject: [PATCH] bcache: avoid redundant access RB tree in read_dirty
config: x86_64-buildonly-randconfig-001-20251010 (https://download.01.org/0day-ci/archive/20251011/202510110048.PdCCuB3b-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251011/202510110048.PdCCuB3b-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510110048.PdCCuB3b-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/md/bcache/writeback.c:592:2: warning: label at end of compound statement is a C23 extension [-Wc23-extensions]
     592 |         }
         |         ^
   1 warning generated.


vim +592 drivers/md/bcache/writeback.c

cafe563591446c Kent Overstreet   2013-03-23  474  
5e6926daac267d Kent Overstreet   2013-07-24  475  static void read_dirty(struct cached_dev *dc)
cafe563591446c Kent Overstreet   2013-03-23  476  {
6f10f7d1b02b1b Coly Li           2018-08-11  477  	unsigned int delay = 0;
448f60e858d871 Coly Li           2025-10-07  478  	struct keybuf_key *keys[MAX_WRITEBACKS_IN_PASS], *w;
448f60e858d871 Coly Li           2025-10-07  479  	struct keybuf_key **dump_keys;
539d39eb270834 Tang Junhui       2018-01-08  480  	size_t size;
448f60e858d871 Coly Li           2025-10-07  481  	int checked, dump_nr;
539d39eb270834 Tang Junhui       2018-01-08  482  	int nk, i;
cafe563591446c Kent Overstreet   2013-03-23  483  	struct dirty_io *io;
5e6926daac267d Kent Overstreet   2013-07-24  484  	struct closure cl;
6e6ccc67b9c7a6 Michael Lyle      2018-01-08  485  	uint16_t sequence = 0;
5e6926daac267d Kent Overstreet   2013-07-24  486  
6e6ccc67b9c7a6 Michael Lyle      2018-01-08  487  	BUG_ON(!llist_empty(&dc->writeback_ordering_wait.list));
6e6ccc67b9c7a6 Michael Lyle      2018-01-08  488  	atomic_set(&dc->writeback_sequence_next, sequence);
5e6926daac267d Kent Overstreet   2013-07-24  489  	closure_init_stack(&cl);
cafe563591446c Kent Overstreet   2013-03-23  490  
cafe563591446c Kent Overstreet   2013-03-23  491  	/*
cafe563591446c Kent Overstreet   2013-03-23  492  	 * XXX: if we error, background writeback just spins. Should use some
cafe563591446c Kent Overstreet   2013-03-23  493  	 * mempools.
cafe563591446c Kent Overstreet   2013-03-23  494  	 */
448f60e858d871 Coly Li           2025-10-07  495  	dump_nr = bch_keybuf_dump(&dc->writeback_keys,
448f60e858d871 Coly Li           2025-10-07  496  			dc->writeback_keys.dump_keys,
448f60e858d871 Coly Li           2025-10-07  497  			ARRAY_SIZE(dc->writeback_keys.dump_keys));
448f60e858d871 Coly Li           2025-10-07  498  	dump_keys = dc->writeback_keys.dump_keys;
448f60e858d871 Coly Li           2025-10-07  499  	atomic_set(&dc->writeback_keys.handled, 0);
448f60e858d871 Coly Li           2025-10-07  500  	checked = 0;
5e6926daac267d Kent Overstreet   2013-07-24  501  
771f393e8ffc9b Coly Li           2018-03-18  502  	while (!kthread_should_stop() &&
771f393e8ffc9b Coly Li           2018-03-18  503  	       !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
448f60e858d871 Coly Li           2025-10-07  504  	       (checked < dump_nr)) {
539d39eb270834 Tang Junhui       2018-01-08  505  		size = 0;
539d39eb270834 Tang Junhui       2018-01-08  506  		nk = 0;
539d39eb270834 Tang Junhui       2018-01-08  507  
539d39eb270834 Tang Junhui       2018-01-08  508  		do {
448f60e858d871 Coly Li           2025-10-07  509  			w = dump_keys[checked];
448f60e858d871 Coly Li           2025-10-07  510  			BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
539d39eb270834 Tang Junhui       2018-01-08  511  
539d39eb270834 Tang Junhui       2018-01-08  512  			/*
539d39eb270834 Tang Junhui       2018-01-08  513  			 * Don't combine too many operations, even if they
539d39eb270834 Tang Junhui       2018-01-08  514  			 * are all small.
539d39eb270834 Tang Junhui       2018-01-08  515  			 */
539d39eb270834 Tang Junhui       2018-01-08  516  			if (nk >= MAX_WRITEBACKS_IN_PASS)
cafe563591446c Kent Overstreet   2013-03-23  517  				break;
cafe563591446c Kent Overstreet   2013-03-23  518  
539d39eb270834 Tang Junhui       2018-01-08  519  			/*
539d39eb270834 Tang Junhui       2018-01-08  520  			 * If the current operation is very large, don't
539d39eb270834 Tang Junhui       2018-01-08  521  			 * further combine operations.
539d39eb270834 Tang Junhui       2018-01-08  522  			 */
539d39eb270834 Tang Junhui       2018-01-08  523  			if (size >= MAX_WRITESIZE_IN_PASS)
539d39eb270834 Tang Junhui       2018-01-08  524  				break;
cafe563591446c Kent Overstreet   2013-03-23  525  
539d39eb270834 Tang Junhui       2018-01-08  526  			/*
539d39eb270834 Tang Junhui       2018-01-08  527  			 * Operations are only eligible to be combined
539d39eb270834 Tang Junhui       2018-01-08  528  			 * if they are contiguous.
539d39eb270834 Tang Junhui       2018-01-08  529  			 *
539d39eb270834 Tang Junhui       2018-01-08  530  			 * TODO: add a heuristic willing to fire a
539d39eb270834 Tang Junhui       2018-01-08  531  			 * certain amount of non-contiguous IO per pass,
539d39eb270834 Tang Junhui       2018-01-08  532  			 * so that we can benefit from backing device
539d39eb270834 Tang Junhui       2018-01-08  533  			 * command queueing.
539d39eb270834 Tang Junhui       2018-01-08  534  			 */
539d39eb270834 Tang Junhui       2018-01-08  535  			if ((nk != 0) && bkey_cmp(&keys[nk-1]->key,
448f60e858d871 Coly Li           2025-10-07  536  						&START_KEY(&w->key)))
539d39eb270834 Tang Junhui       2018-01-08  537  				break;
cafe563591446c Kent Overstreet   2013-03-23  538  
448f60e858d871 Coly Li           2025-10-07  539  			size += KEY_SIZE(&w->key);
448f60e858d871 Coly Li           2025-10-07  540  			keys[nk++] = w;
448f60e858d871 Coly Li           2025-10-07  541  		} while (++checked < dump_nr);
cafe563591446c Kent Overstreet   2013-03-23  542  
539d39eb270834 Tang Junhui       2018-01-08  543  		/* Now we have gathered a set of 1..5 keys to write back. */
539d39eb270834 Tang Junhui       2018-01-08  544  		for (i = 0; i < nk; i++) {
539d39eb270834 Tang Junhui       2018-01-08  545  			w = keys[i];
539d39eb270834 Tang Junhui       2018-01-08  546  
d86eaa0f3c56da Christoph Hellwig 2025-09-08  547  			io = kzalloc(sizeof(*io) + sizeof(struct bio_vec) *
d86eaa0f3c56da Christoph Hellwig 2025-09-08  548  				DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS),
cafe563591446c Kent Overstreet   2013-03-23  549  				GFP_KERNEL);
cafe563591446c Kent Overstreet   2013-03-23  550  			if (!io)
cafe563591446c Kent Overstreet   2013-03-23  551  				goto err;
cafe563591446c Kent Overstreet   2013-03-23  552  
cafe563591446c Kent Overstreet   2013-03-23  553  			w->private	= io;
cafe563591446c Kent Overstreet   2013-03-23  554  			io->dc		= dc;
6e6ccc67b9c7a6 Michael Lyle      2018-01-08  555  			io->sequence    = sequence++;
cafe563591446c Kent Overstreet   2013-03-23  556  
cafe563591446c Kent Overstreet   2013-03-23  557  			dirty_init(w);
c34b7ac6508755 Christoph Hellwig 2022-12-06  558  			io->bio.bi_opf = REQ_OP_READ;
4f024f3797c43c Kent Overstreet   2013-10-11  559  			io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
11e9560e6c005b Christoph Hellwig 2021-04-11  560  			bio_set_dev(&io->bio, dc->disk.c->cache->bdev);
cafe563591446c Kent Overstreet   2013-03-23  561  			io->bio.bi_end_io	= read_dirty_endio;
cafe563591446c Kent Overstreet   2013-03-23  562  
25d8be77e19224 Ming Lei          2017-12-18  563  			if (bch_bio_alloc_pages(&io->bio, GFP_KERNEL))
cafe563591446c Kent Overstreet   2013-03-23  564  				goto err_free;
cafe563591446c Kent Overstreet   2013-03-23  565  
c37511b863f36c Kent Overstreet   2013-04-26  566  			trace_bcache_writeback(&w->key);
cafe563591446c Kent Overstreet   2013-03-23  567  
c2a4f3183a1248 Kent Overstreet   2013-09-23  568  			down(&dc->in_flight);
539d39eb270834 Tang Junhui       2018-01-08  569  
3be11dbab67a3e Coly Li           2018-08-11  570  			/*
3be11dbab67a3e Coly Li           2018-08-11  571  			 * We've acquired a semaphore for the maximum
539d39eb270834 Tang Junhui       2018-01-08  572  			 * simultaneous number of writebacks; from here
539d39eb270834 Tang Junhui       2018-01-08  573  			 * everything happens asynchronously.
539d39eb270834 Tang Junhui       2018-01-08  574  			 */
5e6926daac267d Kent Overstreet   2013-07-24  575  			closure_call(&io->cl, read_dirty_submit, NULL, &cl);
539d39eb270834 Tang Junhui       2018-01-08  576  		}
cafe563591446c Kent Overstreet   2013-03-23  577  
539d39eb270834 Tang Junhui       2018-01-08  578  		delay = writeback_delay(dc, size);
539d39eb270834 Tang Junhui       2018-01-08  579  
771f393e8ffc9b Coly Li           2018-03-18  580  		while (!kthread_should_stop() &&
771f393e8ffc9b Coly Li           2018-03-18  581  		       !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
771f393e8ffc9b Coly Li           2018-03-18  582  		       delay) {
539d39eb270834 Tang Junhui       2018-01-08  583  			schedule_timeout_interruptible(delay);
539d39eb270834 Tang Junhui       2018-01-08  584  			delay = writeback_delay(dc, 0);
539d39eb270834 Tang Junhui       2018-01-08  585  		}
cafe563591446c Kent Overstreet   2013-03-23  586  	}
cafe563591446c Kent Overstreet   2013-03-23  587  
cafe563591446c Kent Overstreet   2013-03-23  588  	if (0) {
cafe563591446c Kent Overstreet   2013-03-23  589  err_free:
cafe563591446c Kent Overstreet   2013-03-23  590  		kfree(w->private);
cafe563591446c Kent Overstreet   2013-03-23  591  err:
cafe563591446c Kent Overstreet   2013-03-23 @592  	}
cafe563591446c Kent Overstreet   2013-03-23  593  
c2a4f3183a1248 Kent Overstreet   2013-09-23  594  	/*
c2a4f3183a1248 Kent Overstreet   2013-09-23  595  	 * Wait for outstanding writeback IOs to finish (and keybuf slots to be
c2a4f3183a1248 Kent Overstreet   2013-09-23  596  	 * freed) before refilling again
c2a4f3183a1248 Kent Overstreet   2013-09-23  597  	 */
5e6926daac267d Kent Overstreet   2013-07-24  598  	closure_sync(&cl);
448f60e858d871 Coly Li           2025-10-07  599  
448f60e858d871 Coly Li           2025-10-07  600  	if (atomic_read(&dc->writeback_keys.handled) == dump_nr) {
448f60e858d871 Coly Li           2025-10-07  601  		spin_lock(&dc->writeback_keys.lock);
448f60e858d871 Coly Li           2025-10-07  602  		dc->writeback_keys.keys = RB_ROOT;
448f60e858d871 Coly Li           2025-10-07  603  		array_allocator_init(&dc->writeback_keys.freelist);
448f60e858d871 Coly Li           2025-10-07  604  		spin_unlock(&dc->writeback_keys.lock);
448f60e858d871 Coly Li           2025-10-07  605  	} else {
448f60e858d871 Coly Li           2025-10-07  606  		for (i = 0; i < dump_nr; i++) {
448f60e858d871 Coly Li           2025-10-07  607  			w = dump_keys[i];
448f60e858d871 Coly Li           2025-10-07  608  			if (!w->private)
448f60e858d871 Coly Li           2025-10-07  609  				continue;
448f60e858d871 Coly Li           2025-10-07  610  			bch_keybuf_del(&dc->writeback_keys, w);
448f60e858d871 Coly Li           2025-10-07  611  		}
448f60e858d871 Coly Li           2025-10-07  612  	}
448f60e858d871 Coly Li           2025-10-07  613  	atomic_set(&dc->writeback_keys.handled, 0);
5e6926daac267d Kent Overstreet   2013-07-24  614  }
5e6926daac267d Kent Overstreet   2013-07-24  615  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

