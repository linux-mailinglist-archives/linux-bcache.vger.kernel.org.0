Return-Path: <linux-bcache+bounces-798-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFDC79D56AD
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Nov 2024 01:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50B011F22A6D
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Nov 2024 00:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B1B2309AC;
	Fri, 22 Nov 2024 00:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QVZn1HXv"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781934C98
	for <linux-bcache@vger.kernel.org>; Fri, 22 Nov 2024 00:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234940; cv=none; b=Bqdd+M4RmrLtZDjUQ55Acl3VZjIaaUxKt27iWs7byQvMu6/uLUHGt6dXATaB3Dii5ICpZbE10fMpH1v8/ImVk1eDtvNPwV9YAtND7HgQV9FEwfhGv/ShLfzT2ZTThPsdsKPabWRbYa52WwJg/XVqvwLoB95L7p8fcnQ9/MqtoSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234940; c=relaxed/simple;
	bh=VSV++YL5Bh/VHZUZH2u7wQe0aT4G7y0X5WkEUWEqgik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eRda0WhE8L8ulQQxeLFBmP78OfDwp3rHbvMJgQvIqg44fwYQwvJ/LKKVEfo3sJuG7ehNqy6jpqSFyEjtfa2R+kClC86irtzkK+jryLrj1XXn7wTt6sTqryOgR7e1hVnSwiJy8Sc2gNGt+f9B0zc2bYyAYT4s0MWSxWG1fjCiwmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QVZn1HXv; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732234939; x=1763770939;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VSV++YL5Bh/VHZUZH2u7wQe0aT4G7y0X5WkEUWEqgik=;
  b=QVZn1HXvH1CxZYiOJMuU7i9UtTE0wEaFDbzABLZ6VtIylixAwoE9Mb8V
   ZUf5QSFIM1zh6zPciFnUr+qcYFoZE1uD4x4J5r3vLJ0zhZhk1WCQpP5z9
   T1QTe+E5y5qvdKwFbmvd1cXaxdKGuCLx7s8ZmU+2KfeK8nGpTPcuKd206
   WYg+fkgPyNQFFm8X/UDsgE01WSmSSIwk8Da6gLpiSL2PcksUPFG6geUgf
   CHBhda+EYT3BxvUrbPEGyo3KhBA985J3LyHsVcOWB4MTMsvn4dK6goe7h
   wTwefn0V2LpI289Pe4bHjKhrHVwgMDRHRhcxyJdE27FSczuslqkqBA0nU
   w==;
X-CSE-ConnectionGUID: OUDTGwI5TCKy9MmIbciAZw==
X-CSE-MsgGUID: zd7DUqk9TX+ymqwAUPPMqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="31734569"
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="31734569"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 16:22:18 -0800
X-CSE-ConnectionGUID: AoY2e9XSRfW+u5qWsOoS2A==
X-CSE-MsgGUID: KRpEu6biTfaJpnQroIcSRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="91217963"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 21 Nov 2024 16:22:16 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tEHR7-0003VV-2D;
	Fri, 22 Nov 2024 00:22:13 +0000
Date: Fri, 22 Nov 2024 08:21:17 +0800
From: kernel test robot <lkp@intel.com>
To: mingzhe.zou@easystack.cn, colyli@suse.de
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-bcache@vger.kernel.org, dongsheng.yang@easystack.cn,
	zoumingzhe@qq.com
Subject: Re: [PATCH 2/3] bcache: fix io error during cache read race
Message-ID: <202411220826.WbtAugHL-lkp@intel.com>
References: <20241119032852.2511-2-mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119032852.2511-2-mingzhe.zou@easystack.cn>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20241121]
[also build test ERROR on v6.12]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/mingzhe-zou-easystack-cn/bcache-fix-io-error-during-cache-read-race/20241121-142652
base:   next-20241121
patch link:    https://lore.kernel.org/r/20241119032852.2511-2-mingzhe.zou%40easystack.cn
patch subject: [PATCH 2/3] bcache: fix io error during cache read race
config: arm-randconfig-001-20241122 (https://download.01.org/0day-ci/archive/20241122/202411220826.WbtAugHL-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241122/202411220826.WbtAugHL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411220826.WbtAugHL-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/bcache/request.c:573:55: error: no member named 'sb' in 'struct cache_set'
     573 |                 pr_warn("%pU cache read race count: %lu", s->iop.c->sb.set_uuid,
         |                                                           ~~~~~~~~  ^
   include/linux/printk.h:554:37: note: expanded from macro 'pr_warn'
     554 |         printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |                                            ^~~~~~~~~~~
   include/linux/printk.h:501:60: note: expanded from macro 'printk'
     501 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                            ^~~~~~~~~~~
   include/linux/printk.h:473:19: note: expanded from macro 'printk_index_wrap'
     473 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   1 error generated.


vim +573 drivers/md/bcache/request.c

   520	
   521	/*
   522	 * Read from a single key, handling the initial cache miss if the key starts in
   523	 * the middle of the bio
   524	 */
   525	static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
   526	{
   527		struct search *s = container_of(op, struct search, op);
   528		struct bio *n, *bio = &s->bio.bio;
   529		struct bkey *bio_key;
   530	
   531		if (bkey_cmp(k, &KEY(s->iop.inode, bio->bi_iter.bi_sector, 0)) <= 0)
   532			return MAP_CONTINUE;
   533	
   534		if (KEY_INODE(k) != s->iop.inode ||
   535		    KEY_START(k) > bio->bi_iter.bi_sector) {
   536			unsigned int bio_sectors = bio_sectors(bio);
   537			unsigned int sectors = KEY_INODE(k) == s->iop.inode
   538				? min_t(uint64_t, INT_MAX,
   539					KEY_START(k) - bio->bi_iter.bi_sector)
   540				: INT_MAX;
   541			int ret = s->d->cache_miss(b, s, bio, sectors);
   542	
   543			if (ret != MAP_CONTINUE)
   544				return ret;
   545	
   546			/* if this was a complete miss we shouldn't get here */
   547			BUG_ON(bio_sectors <= sectors);
   548		}
   549	
   550		if (!KEY_SIZE(k))
   551			return MAP_CONTINUE;
   552	
   553		atomic_inc(&PTR_BUCKET(s->iop.c, k, 0)->pin);
   554	
   555		PTR_BUCKET(b->c, k, 0)->prio = INITIAL_PRIO;
   556	
   557		n = bio_next_split(bio, min_t(uint64_t, INT_MAX,
   558					      KEY_OFFSET(k) - bio->bi_iter.bi_sector),
   559				   GFP_NOIO, &s->d->bio_split);
   560	
   561	retry:
   562		/*
   563		 * If the bucket was reused while our bio was in flight, we might have
   564		 * read the wrong data. Set s->cache_read_races and reread the data
   565		 * from the backing device.
   566		 */
   567		if (ptr_stale(s->iop.c, k, 0)) {
   568			if (PTR_BUCKET(b->c, k, 0)->invalidating)
   569				goto retry;
   570	
   571			atomic_dec(&PTR_BUCKET(s->iop.c, k, 0)->pin);
   572			atomic_long_inc(&s->iop.c->cache_read_races);
 > 573			pr_warn("%pU cache read race count: %lu", s->iop.c->sb.set_uuid,
   574				atomic_long_read(&s->iop.c->cache_read_races));
   575	
   576			n->bi_end_io	= backing_request_endio;
   577			n->bi_private	= &s->cl;
   578	
   579			/* I/O request sent to backing device */
   580			closure_bio_submit(s->iop.c, n, &s->cl);
   581			return n == bio ? MAP_DONE : MAP_CONTINUE;
   582		}
   583	
   584		bio_key = &container_of(n, struct bbio, bio)->key;
   585		bch_bkey_copy_single_ptr(bio_key, k, 0);
   586	
   587		bch_cut_front(&KEY(s->iop.inode, n->bi_iter.bi_sector, 0), bio_key);
   588		bch_cut_back(&KEY(s->iop.inode, bio_end_sector(n), 0), bio_key);
   589	
   590		n->bi_end_io	= bch_cache_read_endio;
   591		n->bi_private	= &s->cl;
   592	
   593		/*
   594		 * The bucket we're reading from might be reused while our bio
   595		 * is in flight, and we could then end up reading the wrong
   596		 * data.
   597		 *
   598		 * We guard against this by checking (in cache_read_endio()) if
   599		 * the pointer is stale again; if so, we treat it as an error
   600		 * and reread from the backing device (but we don't pass that
   601		 * error up anywhere).
   602		 */
   603	
   604		__bch_submit_bbio(n, b->c);
   605		return n == bio ? MAP_DONE : MAP_CONTINUE;
   606	}
   607	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

