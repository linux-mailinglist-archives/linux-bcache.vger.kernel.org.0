Return-Path: <linux-bcache+bounces-799-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD6B9D56AE
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Nov 2024 01:22:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0F0E283139
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Nov 2024 00:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6F9BA20;
	Fri, 22 Nov 2024 00:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FiBEjfcA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A40C79FE
	for <linux-bcache@vger.kernel.org>; Fri, 22 Nov 2024 00:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234943; cv=none; b=J37qsGKZ7upUxyOfZO2rvi33ME0QxyB3vrPCdOnlsQu3JkXpLiDEkeP3pCka1RTAwBJu44Fb/pev1bcioIVgdxGLR2DJlSHJUDLbfV/k3v8CNzjuGvS7K33R0pYidSeM9tgVA+e9ziDA0eIKXG1Bj8M2BAfHy5rlIRt6dNqbmi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234943; c=relaxed/simple;
	bh=6P+eVd0nXKIKZcYe3yzYkx/vRksW06y9OdHpNmrqQ1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPCC15yWe/8m7ShH1wP3W6n7cjGt086745FQayNpcryvLiluKQZ0lGEYHxVY1ua+oh828fxFtvj9A0g87rv2ZkaM6WT0KcGDgMhzARZmHjY2yam/h5Cveebk4XoimbjDB6GoUpZkaVdLvN5fWq8nstXRBA+U0dxCGWS4eGCP/vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FiBEjfcA; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732234942; x=1763770942;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6P+eVd0nXKIKZcYe3yzYkx/vRksW06y9OdHpNmrqQ1A=;
  b=FiBEjfcAUAcG9UL57pW6ONxP50+0SXMXGaMWsfMxPMzA2evoezt/gZbA
   AYvwlEkTVM01JP/1FMKw7HcqMlXUJlZqFMZahQiAQiHv6DZXSCzjY2aEI
   1zFm/WXaLys/NPdXEovNOXwB4GDq9oZLTXHZvk8xevx4GoMCpSKdtwWJh
   3xM5jBUbUQwMilRSxjJu1Yvn/2y5tKi0jxXTCcHRxqEWCZf1CVyEICPww
   b+cvwfFJULu535cgWCTSoFXG3Tb6e2siaq2KPof7seG4BTj8I0H8kE2n+
   IlsNCGY/G5mJhuEjjQ6R4NQdo95RMPud+lpMN7nqDzhowyjuBYepDvz6l
   Q==;
X-CSE-ConnectionGUID: zQBuoyYUQxWS+Xqr1Ic3nw==
X-CSE-MsgGUID: kYP4kJ7rSTSi6SSe6jWLVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="31734594"
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="31734594"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 16:22:21 -0800
X-CSE-ConnectionGUID: +4IPvABSQwO91B6XmqU2Hg==
X-CSE-MsgGUID: v4sAPJ4LTfWUQZuqyU8mlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="90833918"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 21 Nov 2024 16:22:16 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tEHR7-0003VT-29;
	Fri, 22 Nov 2024 00:22:13 +0000
Date: Fri, 22 Nov 2024 08:21:15 +0800
From: kernel test robot <lkp@intel.com>
To: mingzhe.zou@easystack.cn, colyli@suse.de
Cc: oe-kbuild-all@lists.linux.dev, linux-bcache@vger.kernel.org,
	dongsheng.yang@easystack.cn, zoumingzhe@qq.com
Subject: Re: [PATCH 2/3] bcache: fix io error during cache read race
Message-ID: <202411220800.SWuw4yAb-lkp@intel.com>
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
config: arc-randconfig-001-20241122 (https://download.01.org/0day-ci/archive/20241122/202411220800.SWuw4yAb-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241122/202411220800.SWuw4yAb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411220800.SWuw4yAb-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:22,
                    from arch/arc/include/asm/bug.h:30,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/current.h:6,
                    from arch/arc/include/asm/current.h:20,
                    from include/linux/sched.h:12,
                    from include/linux/mempool.h:8,
                    from include/linux/bio.h:8,
                    from drivers/md/bcache/bcache.h:181,
                    from drivers/md/bcache/request.c:10:
   drivers/md/bcache/request.c: In function 'cache_lookup_fn':
>> drivers/md/bcache/request.c:573:67: error: 'struct cache_set' has no member named 'sb'
     573 |                 pr_warn("%pU cache read race count: %lu", s->iop.c->sb.set_uuid,
         |                                                                   ^~
   include/linux/printk.h:473:33: note: in definition of macro 'printk_index_wrap'
     473 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:554:9: note: in expansion of macro 'printk'
     554 |         printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   drivers/md/bcache/request.c:573:17: note: in expansion of macro 'pr_warn'
     573 |                 pr_warn("%pU cache read race count: %lu", s->iop.c->sb.set_uuid,
         |                 ^~~~~~~


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

