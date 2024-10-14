Return-Path: <linux-bcache+bounces-758-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA6B99C6A8
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 12:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF5821C22672
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 10:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3AD7158DD4;
	Mon, 14 Oct 2024 10:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DjvPewfQ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606C3156678;
	Mon, 14 Oct 2024 10:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728900249; cv=none; b=aTbz+R9alkQ+q+ayRD1+fuuSx9shddAkpP8qInJIWbsDKfJo2S6xBu9BQq2j5HD0pURkzOspj8iJBTOjdneolUbvsIofIEtNKggQDiFUBJjELcD9IHESok2hADBC/ZAzbjiW4zsYiBepy/zwbej1u/1XTANCSiyjr2J1stqYFiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728900249; c=relaxed/simple;
	bh=gxRDnZwXl/5mrp9SDbutci1G7aNGYTG5SqDg7ifmzpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4kc/5XxA4sTXquRhyqwLPZ2OKEH6ex1QsHavv3rKq8BFVKfulwBzy6TztkI+DeoJAsSsw1T4Rtx7KcefQrKnVPOtWR6gR5Vi9+9xgBT4NtYtH8AsBDAtM8Z38QtkNq01Yqpq+uHLrTBX+4pmKgmmSc87pFg5vChFIzj1R3lRck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DjvPewfQ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71e5b2814f6so958099b3a.2;
        Mon, 14 Oct 2024 03:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728900248; x=1729505048; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f1UpkN6G+I3ynXmvcvmHYVqtSomW6VaVjxkgmMaS5WQ=;
        b=DjvPewfQFzmS9ITwHux7KjFJ2WKUE/EbuGK5bEOZB2Q8Se2khJLxrF8Nq+QQu590kY
         bGoUE/5ZU0RFcug4L3DlnQ9Y8dtj18/6AuAji4yVCyGhLa4ex2cmXjsSmVMCeTPrnAvJ
         O7oebe/1UzNbo526FglNDOmyoXId/1QDVvneAKwoAWe+Vqy6kcY4G5IDxTNF+irNNBv5
         uuRJK+yOnBV0n3lB9NP8Tq9u9GTFIzCwOtnlPwViytSxZ7eHQj0K+oCcu/fhk96yvwfw
         0SfEx8xV6COEp4wKH1ZQG9THVFPlH9k+WWi3kZKzQLpE5op87ubAuLwNypLHvYC/vAdq
         b7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728900248; x=1729505048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1UpkN6G+I3ynXmvcvmHYVqtSomW6VaVjxkgmMaS5WQ=;
        b=IpR9JeDG7ZK+Xw+dOWegF2lyyAm9AKEvc/hzloSBvuWxVLsoWBRtw3PLsjZWMxGoTO
         INTCYG4S27Gt7bKAmrAAEojs1G88E9N/TgwB25EDgb4Uy1RewmDAfvblsG8U4yGUak6T
         WXLaWhus8XrCrDAhPoKnueZoT/dcie/4zt2pt7CDTdRx7nWQzmpRmKnZ/E2VEtR0sjXF
         4CuHv4AANQOWwwsc9bojRpx+0zNSMVa3HKpdFDdnjLiYi2dB8bRPf8fYZ4gMuALXH5gE
         RIQkczFYu7QF/RtYHtNeO2xvJqxwHTND+pmKk75AEtz2Ods9OYto4lrA4HO56iowQXFv
         NSvw==
X-Forwarded-Encrypted: i=1; AJvYcCV1QI42gwMA660pGLuSnoaW5WFT0t67484ERYBLHBfQbN2nuGVBvNVX7FbEIMkoNQa22aQPIUboqZJ8YgBiKjqaUw==@vger.kernel.org, AJvYcCVOXcnJXaprcn4z4uNhyV+O/Esh5wK2puG2MLH0Ee0FHtsLHh4LZO8AXLeSY5vea205cHdlCTN0KcJs+Wq8qLw=@vger.kernel.org, AJvYcCVTWc3jjz2BIvEsTTjeUtpSBkc0NZOKuirgZ7XQvS0LfAUFNZFHFdNb/NqvZtEKyl7IFed+Pyu5btFZgFo=@vger.kernel.org, AJvYcCVf/M9WfppDwMeJASyHLbLrPPIKlHjFWoxW1pHQmDPjyRetQBHuXJ1YMStIT9g/JYL/se/AX5yXWssDHViN@vger.kernel.org, AJvYcCXCauLOnH4ftuQ7ZCONpz+79UqHiphIyjwQzL96te8BuuuokSayYUYIIbKs1W4t9zzlQM8jDD/s88Af@vger.kernel.org
X-Gm-Message-State: AOJu0YzZbxYwJekPURCIblmaLPZbcJxcoWwX1raRCm4z+4GcRBpT/cXY
	qi4Ai1KY2L6M+/eas4FVs+HbnnLyycxez94XZehcv2zqNRWrveHB
X-Google-Smtp-Source: AGHT+IGgEa3bpvndU2jxBEWa1yPYBEP7dBrWvI/1I6n9qW/VRreLiILNdpVJ/aCiWYGC5lADcN/4KA==
X-Received: by 2002:a05:6a21:6e41:b0:1cc:e43e:3a01 with SMTP id adf61e73a8af0-1d8bcfa53ebmr16834401637.33.1728900247665;
        Mon, 14 Oct 2024 03:04:07 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e618318d3sm2226638b3a.42.2024.10.14.03.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 03:04:07 -0700 (PDT)
Date: Mon, 14 Oct 2024 18:04:01 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
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
Message-ID: <ZwzskczB85bGKWO/@visitorckw-System-Product-Name>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-4-visitorckw@gmail.com>
 <ZwzcnHmtRFISI9Ua@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwzcnHmtRFISI9Ua@casper.infradead.org>

On Mon, Oct 14, 2024 at 09:55:56AM +0100, Matthew Wilcox wrote:
> On Mon, Oct 14, 2024 at 02:47:03AM +0800, Kuan-Wei Chiu wrote:
> > Introduce an overview of the min heap API, detailing its usage and
> > functionality. The documentation aims to provide developers with a
> > clear understanding of how to implement and utilize min heaps within
> > the Linux kernel, enhancing the overall accessibility of this data
> > structure.
> 
> Please format this text to 80 columns.  Just pass it through 'fmt'.
> 
> > +This API supports efficient insertion, deletion, and access to the minimum element. It is optimized
> > +for use in systems with performance constraints and is suitable for scenarios where the minimum
> > +element needs to be accessed or updated frequently.
> 
> All systems have "performance constraints".  I'm not sure what that
> means in this context.
> 
> > +This document provides a guide to the Min Heap API, detailing how to define and use min-heaps.
> > +Please note that users should not directly call functions with **__min_heap_*()** names, but should
> > +instead use the provided macro wrappers.
> 
> You can always remove "Please note that".  It has no meaning.  Just say
> "You should not call functions with **__min_heap_** prefixes; use the
> functions documented here instead.
> 
> > +Min-Heap Definition
> > +-------------------
> > +
> > +The core data structure for representing a min-heap is defined using the **MIN_HEAP_PREALLOCATED**
> > +and **DEFINE_MIN_HEAP** macros. These macros allow you to define a min-heap with a preallocated
> > +buffer or dynamically allocated memory.
> > +
> > +Example:
> > +
> > +.. code-block:: c
> > +
> > +    #define MIN_HEAP_PREALLOCATED(_type, _name, _nr)
> > +    struct _name {
> > +        int nr;         /* Number of elements in the heap */
> > +        int size;       /* Maximum number of elements that can be held */
> > +        _type *data;    /* Pointer to the heap data */
> > +        _type preallocated[_nr];  /* Static preallocated array */
> > +    }
> 
> This isn't an example of code the reader of this document would write
> though, is it?  This looks like code already provided.  An example
> should be something like:
> 
> MIN_HEAP_PREALLOCATED(struct page, my_pages, 23);
> 
> ... or whatever would actually make sense.

Thank you for the review. I'll wait for the decision on whether to keep
the non-inline API before sending a v2 patch to address these comments.

Regards,
Kuan-Wei

