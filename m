Return-Path: <linux-bcache+bounces-892-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E298A911AE
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 04:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF2C15A1468
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 02:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28801A9B34;
	Thu, 17 Apr 2025 02:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hKj2hXhR"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244B713D51E
	for <linux-bcache@vger.kernel.org>; Thu, 17 Apr 2025 02:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744857089; cv=none; b=ElhwUmjiOaz59+tQQMl5NjcjkTz0JqWdaL4TwdqwnIHu2CHyiTh7cuqN8SshNF05d2vN9glAoma9Uh0/6CXdsylDcwniKeQWL/ineV6vlYSK61gLXYO2r56CpG1creSxiEeM+hd70UA9uAXmxvbgSQCnq1/0O8pPnp/nVsHtSso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744857089; c=relaxed/simple;
	bh=RuTtooDYoMbsdrtm8qNmd5HQ+945cpWtQ0qTs88NgxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bU0Pf7M4ZdcLUPpB9FaEt3FitpP3oP3P95w/BCXSt4XsdWHfHjLYIrtbzVUFQlwmPvmBoKGH+Hh+mlqGg1WnSBjOQCIwpQdFd+/h1Z9kq76mFrOlPv7ZNAr0zHC//nEYk7+FlGY29zLQW+pVPP1OYXjv6Ivdj6o31gG8J31NarY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hKj2hXhR; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744857088; x=1776393088;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RuTtooDYoMbsdrtm8qNmd5HQ+945cpWtQ0qTs88NgxE=;
  b=hKj2hXhR+hOh7IrroeAwmpA2r5z3zxnAmzjxyByWNQ16tPdDh42yc/w9
   /4lP8/T0i3ST55e+9tW/+/nuSdA0Rn4viPqiHyakgjuwfB0Cc8gwEyooC
   HRNNZS48erJaJOj6fuicE5XPbgxxItHgsKowOlP+I3Q5a7JKMlWi8I+hN
   CD6OVc/w1/mLEWpChISqWLwqiJHFHe+3ugLjEMH1VEkzQxFseGUsAH2cC
   n8B79ptKgwwXo/c57ICS5LljxpU/SF7b6bRFNOepal5gF5eFLmGdeGlpB
   QFSLi5rWdkqclD7O2SN8FWtljuDZ3JO4C9M+8lboYd/+RvHVRJYX2axpw
   Q==;
X-CSE-ConnectionGUID: h+AhTHzuTNeG5b71FMGUcw==
X-CSE-MsgGUID: bR3k7d7rTSySsCigzbkLRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11405"; a="50075734"
X-IronPort-AV: E=Sophos;i="6.15,217,1739865600"; 
   d="scan'208";a="50075734"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 19:31:27 -0700
X-CSE-ConnectionGUID: N5A6QRvBRXSxsIL7qykapQ==
X-CSE-MsgGUID: ypTfot/dTn6LQeHRYspquQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,217,1739865600"; 
   d="scan'208";a="135515948"
Received: from lkp-server01.sh.intel.com (HELO b207828170a5) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 16 Apr 2025 19:31:25 -0700
Received: from kbuild by b207828170a5 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u5F2B-000KoA-0C;
	Thu, 17 Apr 2025 02:31:23 +0000
Date: Thu, 17 Apr 2025 10:31:03 +0800
From: kernel test robot <lkp@intel.com>
To: Robert Pang <robertpang@google.com>, Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcache@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Robert Pang <robertpang@google.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH v2 1/1] bcache: process fewer btree nodes in incremental
 GC cycles
Message-ID: <202504171044.TFdtTfEh-lkp@intel.com>
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
config: i386-buildonly-randconfig-001-20250417 (https://download.01.org/0day-ci/archive/20250417/202504171044.TFdtTfEh-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250417/202504171044.TFdtTfEh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504171044.TFdtTfEh-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__udivdi3" [drivers/md/bcache/bcache.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

