Return-Path: <linux-bcache+bounces-225-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 884E9826003
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Jan 2024 16:00:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19F90B22BA7
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Jan 2024 15:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9F179D0;
	Sat,  6 Jan 2024 14:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xm4fBVLg"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CA0846F;
	Sat,  6 Jan 2024 14:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704553196; x=1736089196;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JnCYGoOQs0yi8PaGnxuB0NsSgyv/YTGrF0XZ0KOj6K8=;
  b=Xm4fBVLgnwUlNPHMOx9qpsyDQErqfanP9HfdKdSIzKhMMrAleriDv0R4
   Zf3j/XwIKd96KeqGoskwW7227XczsL4ywFJkU3DDLeysqJNF5J29PwZMv
   BjTAYryJ7etAD9kvq3XJp8NTnM6g843TpyeFifA1hsz5MEyveyRUVUTAb
   C6Y0Diip2FVSLcaDXoOtKLuCbOj88c/4UVlqbheaKDLsHM+dmeIRTdhfx
   L3SO6Ot45wDc15BCrUkxvLx57YhI73F0pDi2Iw3i5whDP5R0NFmaYS55d
   bI8mYANg3wnXTFMkVjLaq4OwAs6sUXZKp5E6TfxojmTaHi4pm5K2jJ3W4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10945"; a="5017136"
X-IronPort-AV: E=Sophos;i="6.04,337,1695711600"; 
   d="scan'208";a="5017136"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2024 06:59:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10945"; a="846816279"
X-IronPort-AV: E=Sophos;i="6.04,337,1695711600"; 
   d="scan'208";a="846816279"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2024 06:59:51 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1rM7nJ-0000000BvkH-23ko;
	Sat, 06 Jan 2024 16:37:01 +0200
Date: Sat, 6 Jan 2024 16:37:01 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Suren Baghdasaryan <surenb@google.com>, Coly Li <colyli@suse.de>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Kees Cook <keescook@chromium.org>, Marco Elver <elver@google.com>,
	Jani Nikula <jani.nikula@intel.com>, Ingo Molnar <mingo@kernel.org>,
	linux-bcache@vger.kernel.org
Subject: Re: [PATCH v2 0/3] list: Add hlist_count_nodes()
Message-ID: <ZZlljaqUr44CPicD@smile.fi.intel.com>
References: <20240104164937.424320-1-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104164937.424320-1-pierre.gondois@arm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Jan 04, 2024 at 05:49:32PM +0100, Pierre Gondois wrote:
> v2:
> - Add usages of the function to avoid considering it as dead code.
> v1:
> - https://lore.kernel.org/all/20240103090241.164817-1-pierre.gondois@arm.com/
> 
> Add a generic hlist_count_nodes() function.
> 
> This function aims to be used in a private module. As suggested by
> Marco, having it used would avoid to consider it as dead code.
> Thus, add some usages of the function in two drivers.

With or without a nit-pick being addressed,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko



