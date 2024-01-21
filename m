Return-Path: <linux-bcache+bounces-238-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 034208356FE
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 18:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C31EB20D73
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 17:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5F83770F;
	Sun, 21 Jan 2024 17:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5Hnq18+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A786312E4C;
	Sun, 21 Jan 2024 17:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705856733; cv=none; b=ftQUBoJWdBmT0snumjRlY9MNLKtVAeQM7jBqUlWd6NNnbg/hVvhny+QcjDkL9aCMIS9GOGr5aT6qwV+YoKa1RerUt5B6soeuehVSYVZMPq0HH/hZBSyUUBqu9MUK60fXkdbFbBaVusI/7Cnt5dcWzXsY1jQeOP+XOxnN/W7dPhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705856733; c=relaxed/simple;
	bh=/BBQEgsyEX+CgV7C74J42qwIUw91ntDU8ZHez9wNpNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcOxszMHo8DaVqtiIOUWcSuDDStOiWPvhuB1O7ZxQuAL18r+x+G9tk7EOI5lw1zzpA8mnDd5I7VzCr+sZrwwM5j2uFlt0iyxi7+VB8c3Yjs4iDhh6FxIO+Avi9L79XnkuRoxMzKI8i2BuYCX2Gea2o2Jz8xsPOTsibnjQyn8A64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W5Hnq18+; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-28b93b04446so619959a91.0;
        Sun, 21 Jan 2024 09:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705856732; x=1706461532; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MkbA457M4E440O7ar5sDvfp8xELZCIe8Nky4cfiSYro=;
        b=W5Hnq18+rvkfFubkWUteg8FMiUK+AyuJMpt8d+s9dAQsoyJvBcYnhge4dbcsvDMLms
         AAina+JWEPMn+I5RFntkUEW76TMfs8B1153oguJp1X5oIZQES6XoX4hL13e3HnbULqJP
         KJpvd5O8a9pi9ORdl3S328PXCHRfv4PPX+Rs3+YAk/lji3Uu8iBIyEa3NBlv83KTpZHd
         AkoSm8btp2CkAk3IDBhGfHsIk+7vwAo+OYGLYKNDZGHzjM7iOsuuKrjKQ0SZRxvuH9BS
         g4/LC6MIqh2QnRMCdpcIC+H+YumfEjp5ulGlX8EWuUiswgmmLeAW8J0ElF+M4jCldCl3
         9lbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705856732; x=1706461532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MkbA457M4E440O7ar5sDvfp8xELZCIe8Nky4cfiSYro=;
        b=rH9PP6ZMBmMOYC19hzZhGkMacN1pK2AJ3CYPJfcEQ1NZnOru5NVC32vXN5E3nVhhqN
         HytftnV8RSpkR2Xgiun12MWtQuJWsjcdBa7pqSt7zt14W6O1wLUbKHyddcDBYRdXMxcT
         bOn2+yHN+vAg5Ft4M6L1V8+UBatCW0L/kuj5SfjEUKy21tGEuqNwIdkQglXvCM4t/6uY
         2ZFRBQYMd9NzqaT2hAyMBMbOvnbC6FkN5AZmXANhsPYJ1X7eaiivN8Q6pIhbjRJs1LIU
         mxMlxRFUVr6xfS+EMvBxSZq0T8A8bQt0us4/3xgXHYAjr+JlikI7f0Rx8Dx5kh2zantb
         M7Tg==
X-Gm-Message-State: AOJu0YzZnPJfy3WHCBxb8yR1oOzk/c/An96jxpBzP9P5v9y21O7GDvrH
	puyWm+mEHz4g3CjGk5TPPC5nv0T/r3wDt7AhQYT5lELKu2WsN3fw
X-Google-Smtp-Source: AGHT+IG/Nlq04qRAefj6UwiT/yqPb2U5/xdaUXjXAXdLqOty7Btht6NLGyJkf9xdNvEYfJJ0E/3TnQ==
X-Received: by 2002:a17:90b:46d3:b0:290:65ef:9ba6 with SMTP id jx19-20020a17090b46d300b0029065ef9ba6mr3499077pjb.2.1705856731909;
        Sun, 21 Jan 2024 09:05:31 -0800 (PST)
Received: from visitorckw-System-Product-Name (IP-216-168.cs.nctu.edu.tw. [140.113.216.168])
        by smtp.gmail.com with ESMTPSA id w15-20020a17090ad60f00b0028dd42b115bsm7740198pju.5.2024.01.21.09.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 09:05:31 -0800 (PST)
Date: Mon, 22 Jan 2024 01:05:28 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, bfoster@redhat.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/5] bcachefs: Introduce parent function for
 sort_cmp_size()
Message-ID: <Za1O2JDOnTRL0QvL@visitorckw-System-Product-Name>
References: <20240121153649.2733274-1-visitorckw@gmail.com>
 <20240121153649.2733274-3-visitorckw@gmail.com>
 <vrzgjxym2gnawuds54s4lr4zqbldm6sxp5yksrz5467hcrzjtp@lphbsqbidqdm>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vrzgjxym2gnawuds54s4lr4zqbldm6sxp5yksrz5467hcrzjtp@lphbsqbidqdm>

On Sun, Jan 21, 2024 at 11:17:30AM -0500, Kent Overstreet wrote:
> On Sun, Jan 21, 2024 at 11:36:46PM +0800, Kuan-Wei Chiu wrote:
> > When dealing with array indices, the parent's index can be obtained
> > using the formula (i - 1) / 2. However, when working with byte offsets,
> > this approach is not straightforward. To address this, we have
> > introduced a branch-free parent function that does not require any
> > division operations to calculate the parent's byte offset.
> 
> This is a good commit message - but it would be even better if it was a
> function comment on parent()
>
Sure, however, it seems that sort_cmp_size() can be directly replaced
with the sort function from include/linux. Once we decide on the
cleanup tasks, if we still choose to retain this patch, I will make the
adjustments.
> > 
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > ---
> > This patch has undergone unit testing using the following code [1].
> > 
> > [1]:
> > static int test(void)
> > {
> >     size_t i, p, size, lsbit;
> > 
> >     for (i = 0; i < 10000; i++) {
> >         size = get_random_u32() % (1U << 10);
> >         lsbit = size & -size;
> >         i = get_random_u32() % (1U << 20) * size + size;
> >         p = parent(i, lsbit, size);
> >         if (p != (i / size - 1) / 2 * size)
> >             return -1;
> >     }
> > 
> >     return 0;
> > }
> > 
> >  fs/bcachefs/util.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> > index bbc83b43162e..f5bbf96df2ce 100644
> > --- a/fs/bcachefs/util.c
> > +++ b/fs/bcachefs/util.c
> > @@ -907,6 +907,13 @@ static inline void do_swap(void *base, size_t n, size_t size,
> >  		  size);
> >  }
> >  
> > +static inline size_t parent(size_t i, size_t lsbit, size_t size)
> > +{
> > +	i -= size;
> > +	i -= size & -(i & lsbit);
> > +	return i >> 1;
> > +}
> > +
> >  void eytzinger0_sort(void *base, size_t n, size_t size,
> >  		     int (*cmp_func)(const void *, const void *, size_t),
> >  		     void (*swap_func)(void *, void *, size_t))
> > -- 
> > 2.25.1
> > 

