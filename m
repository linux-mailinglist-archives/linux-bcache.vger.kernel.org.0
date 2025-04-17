Return-Path: <linux-bcache+bounces-891-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB15A91180
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 04:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38BD01906D75
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 02:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C13D1BBBD4;
	Thu, 17 Apr 2025 02:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bK+HGGPa"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D9D1AB52F
	for <linux-bcache@vger.kernel.org>; Thu, 17 Apr 2025 02:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744855825; cv=none; b=DY8D4waDmCAdzyo4QKFt/Jxor0PLIpdRg+kxEAoyOnSNAY+cy9qVTQ2/C36ec4MtPya7oHdzOcIwfsxWo46byTPO4ptrN+bJa327KbCA+a4wFPv3lx8HWsJ3dv21XHEvH0aa4lt00LgErvI9mIqFDXh07KXRM+Bpi7UCWI7ndqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744855825; c=relaxed/simple;
	bh=NxTCaZmDt9S8j9Hy9cdqH8ifbyprL0szl3G8oAm0Oqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=awFMAkjozCsYVGl60xI+TZWyZSpaD6GHOyJgT4BWU5wvTb7LX1ch5eyHJOU/thbdaAP87kudp4PqLXI2OWMsBuAHWL6qzVvgA1LaEbI83HKuhnfvUQLDp090aBW7BtQJE9GWI8PSEB3kyWP9EKPoy7S+5cE0QMp+L+MnsStm+O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bK+HGGPa; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744855823; x=1776391823;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NxTCaZmDt9S8j9Hy9cdqH8ifbyprL0szl3G8oAm0Oqk=;
  b=bK+HGGPaMiF5yBEJMR2Azx+pZsutaU8HzoH5MG3+viKnEpJzOFHMUwKF
   l4u7ZHUxhNN2w5FRmwUOyAlxiC0xDNPcMhB59EFoS3QzNYfyAbUbmx6xl
   ZPqtyDgH4OCaBHxYmVlBEywdAe+h9x2xUPwjbpbYvqZL1SUf27vtqezhC
   bO6q4eJgnMGXMywkf4wTonbhqN44zv3gtLC0CgE2/pcOVZLyL3qrrNf8w
   agjg22lEgkQs8PmseME/ivKqpSQIysY1JBYdMKB9nO5ZJ4vEChvFgHlQc
   4VM0zNYqEh6rZY5vO6eo6KEaSEWKWCCqcFLPN3M4A+VE6kFgmJ54BIncy
   w==;
X-CSE-ConnectionGUID: NYmm/k9zQr2Js3mMVne5ew==
X-CSE-MsgGUID: 83da/5fMQAexAP5l+pJyyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11405"; a="63836583"
X-IronPort-AV: E=Sophos;i="6.15,217,1739865600"; 
   d="scan'208";a="63836583"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 19:10:22 -0700
X-CSE-ConnectionGUID: 4QhI9oLKTQapLTm7XUntsQ==
X-CSE-MsgGUID: ozmrGJzDQ9aJ+e9uM+0BYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,217,1739865600"; 
   d="scan'208";a="135747923"
Received: from lkp-server01.sh.intel.com (HELO b207828170a5) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 16 Apr 2025 19:10:21 -0700
Received: from kbuild by b207828170a5 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u5Ehm-000Kiq-2G;
	Thu, 17 Apr 2025 02:10:18 +0000
Date: Thu, 17 Apr 2025 10:09:27 +0800
From: kernel test robot <lkp@intel.com>
To: Robert Pang <robertpang@google.com>, Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcache@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Robert Pang <robertpang@google.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH v2 1/1] bcache: process fewer btree nodes in incremental
 GC cycles
Message-ID: <202504170950.T7aXwrDK-lkp@intel.com>
References: <20250415174145.346121-2-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415174145.346121-2-robertpang@google.com>

Hi Robert,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.15-rc2 next-20250416]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Robert-Pang/bcache-process-fewer-btree-nodes-in-incremental-GC-cycles/20250416-133615
base:   linus/master
patch link:    https://lore.kernel.org/r/20250415174145.346121-2-robertpang%40google.com
patch subject: [PATCH v2 1/1] bcache: process fewer btree nodes in incremental GC cycles
config: i386-buildonly-randconfig-004-20250417 (https://download.01.org/0day-ci/archive/20250417/202504170950.T7aXwrDK-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250417/202504170950.T7aXwrDK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504170950.T7aXwrDK-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: drivers/md/bcache/btree.o: in function `btree_gc_recurse':
>> btree.c:(.text+0x4c82): undefined reference to `__udivdi3'
>> ld: btree.c:(.text+0x4c91): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

