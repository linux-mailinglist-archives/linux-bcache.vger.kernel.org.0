Return-Path: <linux-bcache+bounces-224-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E0FB8825FEA
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Jan 2024 15:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2CC4B228DB
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Jan 2024 14:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A4579D7;
	Sat,  6 Jan 2024 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZAA2nBTM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1D3882E;
	Sat,  6 Jan 2024 14:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704551795; x=1736087795;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LcQHKTNnzexQYEQpKyQzDBzYwTLlJSqPJzl708DLwh8=;
  b=ZAA2nBTMq0Fv2VA7VrgxLJBPb1QFbnmVhx2Jm+fub83GN8AvLzKU3nEl
   Un8XmMsbecDRzBI/S+EtoI2eUb8mnZ5kaUcyduI/LdlAVCK/gXLXDiw1S
   PylwTJMs7LgjPT8LW+aVTqlgIbFk7KbJ/bb6EsGAyHOnI/IIHBKn0ysdo
   K+Ado9TWV+v7+9kqqP4Dp35ZRHnJl2TPyukfBRVg78eNOonzzHBotK8c1
   bxy2fZzkIcLOc5m+lTUBef8s8Oo0u9YdQYXBAnT6ILu7KtJnlVHaIbMm0
   aXVbm5zx2QdJIMLsdA9wDYOLdy1om47PAFz6qvxNNVO+3R02MLgCY+zDq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10945"; a="382629178"
X-IronPort-AV: E=Sophos;i="6.04,337,1695711600"; 
   d="scan'208";a="382629178"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2024 06:36:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10945"; a="846814579"
X-IronPort-AV: E=Sophos;i="6.04,337,1695711600"; 
   d="scan'208";a="846814579"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2024 06:36:31 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1rM7ml-0000000Bvjm-3ts2;
	Sat, 06 Jan 2024 16:36:27 +0200
Date: Sat, 6 Jan 2024 16:36:27 +0200
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
	Marco Elver <elver@google.com>, Kees Cook <keescook@chromium.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Ingo Molnar <mingo@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH v2 3/3] bcache: Use of hlist_count_nodes()
Message-ID: <ZZlla_BYIP_dnLmA@smile.fi.intel.com>
References: <20240104164937.424320-1-pierre.gondois@arm.com>
 <20240104164937.424320-4-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104164937.424320-4-pierre.gondois@arm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Jan 04, 2024 at 05:49:35PM +0100, Pierre Gondois wrote:
> Make use of the newly added hlist_count_nodes().

...

>  	for (h = c->bucket_hash;
>  	     h < c->bucket_hash + (1 << BUCKET_HASH_BITS);
>  	     h++) {
> -		unsigned int i = 0;
> -		struct hlist_node *p;
> -
> -		hlist_for_each(p, h)
> -			i++;
> -
> -		ret = max(ret, i);
> +		ret = max(ret, hlist_count_nodes(h));
>  	}

After this you probably may drop {}.


-- 
With Best Regards,
Andy Shevchenko



