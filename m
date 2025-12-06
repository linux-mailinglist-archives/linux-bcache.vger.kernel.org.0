Return-Path: <linux-bcache+bounces-1340-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AEE26CAABC5
	for <lists+linux-bcache@lfdr.de>; Sat, 06 Dec 2025 19:02:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 688233007A0D
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Dec 2025 18:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1582A29C327;
	Sat,  6 Dec 2025 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fKU+BuyT"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E69C16D9C2;
	Sat,  6 Dec 2025 18:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765044121; cv=none; b=FXUh7iOc2wd+/eSSyFMsuwi7MZbsbO0mgnPHfCsCwJftfRR8smk8j00rXb6evsY68PsTB/bVLhHjX1werznskTmXVOuuRz/3bs5tLouT+3BoxUavOMc3i7zIFj2DL18GCkrkdP93kAJtZwiyVD+SY8VhkTqoNJLld2Ud8Y9IrN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765044121; c=relaxed/simple;
	bh=YoHW8PPiN2rSkIW/NA0mZkSslyiXwDxRxy8s45eKEus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dqx1uUVb4TpGc6N+SxOq5PKNO8oHcU1Nw0LTlREpu+KEtA0PzFyZLRWxUJ65hG/H3GrlczCT4FRjli8cF4IkRMYQ97QfjgziQ9cfCQYP2N/ZcGkz4Nrkq515HeDqW3N1yEiv7g8hZX8yTAV3ezDhnvhN2X4W9CaJWildNdFhMso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fKU+BuyT; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765044120; x=1796580120;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YoHW8PPiN2rSkIW/NA0mZkSslyiXwDxRxy8s45eKEus=;
  b=fKU+BuyTcRZYfPX1wBgEcT7VV7298DM2/MPx6qzmaRk1Z9hYBONZAL8L
   ERE+I/pjLVnuR9TlgTf68egGrZE7Bgv/IYA9/3rYb6EJe4E84fjsj8i0d
   mUXsaD0s/NyWT66WwhE4nMq1xcrFaCovvpbFXsZbeS6zIYYgyU09yNxuL
   Zjvhdm4rimAJH8bZMf48ih7t+r2nj0jQWvfzLhncc4W8LputEzM9qwK4v
   6o4joRuZqZHQluQg9OVqrr5cosqXXOwDa+0LgCyPYQq0SnG+8ng45vxJa
   5f0keV9AQcfpbI69kupQJTOwmeYd3rHJIefdvJcGQ+c6FQEjXZLZx2yhD
   Q==;
X-CSE-ConnectionGUID: nkc6KcnARWCfKH5mzIPZNg==
X-CSE-MsgGUID: Lhckcrc2TT6CdnAoWqvO5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11634"; a="70896809"
X-IronPort-AV: E=Sophos;i="6.20,255,1758610800"; 
   d="scan'208";a="70896809"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 10:01:59 -0800
X-CSE-ConnectionGUID: mbVIpTMvSQGcpHRVZsdDmg==
X-CSE-MsgGUID: s4k9r/igRSCDKCoEwdGvBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,255,1758610800"; 
   d="scan'208";a="195384340"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 06 Dec 2025 10:01:55 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRwbP-00000000IeP-3eOd;
	Sat, 06 Dec 2025 18:01:51 +0000
Date: Sun, 7 Dec 2025 02:01:45 +0800
From: kernel test robot <lkp@intel.com>
To: zhangshida <starzhangzsd@gmail.com>, Johannes.Thumshirn@wdc.com,
	hch@infradead.org, agruenba@redhat.com, ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com, csander@purestorage.com
Cc: oe-kbuild-all@lists.linux.dev, linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn, starzhangzsd@gmail.com
Subject: Re: [PATCH v3 3/9] block: prevent race condition on bi_status in
 __bio_chain_endio
Message-ID: <202512070122.my7vkR7A-lkp@intel.com>
References: <20251129090122.2457896-4-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129090122.2457896-4-zhangshida@kylinos.cn>

Hi zhangshida,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe/for-next]
[also build test WARNING on xfs-linux/for-next nvdimm/libnvdimm-for-next linus/master brauner-vfs/vfs.all v6.18 next-20251205]
[cannot apply to nvdimm/dax-misc]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/zhangshida/md-bcache-fix-improper-use-of-bi_end_io/20251129-170348
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20251129090122.2457896-4-zhangshida%40kylinos.cn
patch subject: [PATCH v3 3/9] block: prevent race condition on bi_status in __bio_chain_endio
config: loongarch-randconfig-r133-20251130 (https://download.01.org/0day-ci/archive/20251207/202512070122.my7vkR7A-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251207/202512070122.my7vkR7A-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512070122.my7vkR7A-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> block/bio.c:319:17: sparse: sparse: cast from restricted blk_status_t
>> block/bio.c:319:17: sparse: sparse: cast from restricted blk_status_t
>> block/bio.c:319:17: sparse: sparse: cast to restricted blk_status_t

vim +319 block/bio.c

   313	
   314	static struct bio *__bio_chain_endio(struct bio *bio)
   315	{
   316		struct bio *parent = bio->bi_private;
   317	
   318		if (bio->bi_status)
 > 319			cmpxchg(&parent->bi_status, 0, bio->bi_status);
   320	
   321		bio_put(bio);
   322		return parent;
   323	}
   324	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

