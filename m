Return-Path: <linux-bcache+bounces-756-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0933999C437
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 10:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A640F1F21D28
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 08:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B586154BE2;
	Mon, 14 Oct 2024 08:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BLT4CKBB"
X-Original-To: linux-bcache@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98F01487F4;
	Mon, 14 Oct 2024 08:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728896169; cv=none; b=YA84mpqpXX7jTaP0EfF6PLiEVP/TFo2CweIM0ZPXkd+gA/hPv/Mu3Nl+Y0oLwq1q9extY1xuye5gLEecRcjNzyYur2p/9COvfalg3KCokH0clxkIstixGnSRaN2FwIw/7LQZwGnNCMBbX3FuDVvXOy8tQkGKvwSlao/rD0PDKuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728896169; c=relaxed/simple;
	bh=4ttVn61IPJPGOXQUuj+F3AwzkPevNjd/7JwzshsRbEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUYieAGnuwyW48AdmD0QBN5E7KUCr8kT8NSE0aqs7o4a+XTa4ZlGhhKLpwh4M++jwS4tby/RiI3uTf6oG0kut6nWL/FBOBrkOrLSB1ozZ19WavxF3zc0MPH9LGmrRraNkXzqhuQI893h6oRK6Lu7oGM0Su5Rj/Q/x1mYXyF69FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BLT4CKBB; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hnnP3kvCrMp1udzAiNl9/QUooyGV+DH0dEows1BIW9c=; b=BLT4CKBB+vSrXtQgfDsDRy+krq
	RFw+VMsFJSwzBaC1wJ0wO7sTaUTI6WyLb+z+XrtCFUYb6b2P4EgBxWDLdNt96IbAOsn/cpYs7bm+1
	oUXSGODvhXpb6DgIeOWjccJfVraAoI+5VTnyAgmv1xg4Om2t4PPpRq4cEz/vrJ/81ORrjeW6CHGi+
	BIYhnxdMtXXkVe7j6d3d+XI9LEIOBmYBdLJQnIh6DcxAOUzOVSZubT3NX+oLZqQHLQt5pF0VgnUql
	K7EvwXjr5ZWeC8SD5hEeGx6Ya46hZhehtDezQ19Ct4HzAgAG/YjtJwFRdHbLQe1Vu+b9BwEnA2w7h
	1tCUhv5Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0Grs-000000018Uo-1njp;
	Mon, 14 Oct 2024 08:55:56 +0000
Date: Mon, 14 Oct 2024 09:55:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/3] Documentation/core-api: Add min heap API introduction
Message-ID: <ZwzcnHmtRFISI9Ua@casper.infradead.org>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-4-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013184703.659652-4-visitorckw@gmail.com>

On Mon, Oct 14, 2024 at 02:47:03AM +0800, Kuan-Wei Chiu wrote:
> Introduce an overview of the min heap API, detailing its usage and
> functionality. The documentation aims to provide developers with a
> clear understanding of how to implement and utilize min heaps within
> the Linux kernel, enhancing the overall accessibility of this data
> structure.

Please format this text to 80 columns.  Just pass it through 'fmt'.

> +This API supports efficient insertion, deletion, and access to the minimum element. It is optimized
> +for use in systems with performance constraints and is suitable for scenarios where the minimum
> +element needs to be accessed or updated frequently.

All systems have "performance constraints".  I'm not sure what that
means in this context.

> +This document provides a guide to the Min Heap API, detailing how to define and use min-heaps.
> +Please note that users should not directly call functions with **__min_heap_*()** names, but should
> +instead use the provided macro wrappers.

You can always remove "Please note that".  It has no meaning.  Just say
"You should not call functions with **__min_heap_** prefixes; use the
functions documented here instead.

> +Min-Heap Definition
> +-------------------
> +
> +The core data structure for representing a min-heap is defined using the **MIN_HEAP_PREALLOCATED**
> +and **DEFINE_MIN_HEAP** macros. These macros allow you to define a min-heap with a preallocated
> +buffer or dynamically allocated memory.
> +
> +Example:
> +
> +.. code-block:: c
> +
> +    #define MIN_HEAP_PREALLOCATED(_type, _name, _nr)
> +    struct _name {
> +        int nr;         /* Number of elements in the heap */
> +        int size;       /* Maximum number of elements that can be held */
> +        _type *data;    /* Pointer to the heap data */
> +        _type preallocated[_nr];  /* Static preallocated array */
> +    }

This isn't an example of code the reader of this document would write
though, is it?  This looks like code already provided.  An example
should be something like:

MIN_HEAP_PREALLOCATED(struct page, my_pages, 23);

... or whatever would actually make sense.


