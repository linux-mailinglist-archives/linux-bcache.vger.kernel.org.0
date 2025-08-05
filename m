Return-Path: <linux-bcache+bounces-1175-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E30B5B1ACCC
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Aug 2025 05:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F5F96205C7
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Aug 2025 03:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669841C75E2;
	Tue,  5 Aug 2025 03:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bG0pYFwW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363791CD0C
	for <linux-bcache@vger.kernel.org>; Tue,  5 Aug 2025 03:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754364896; cv=none; b=QAEfFktY7yTRVjFJq4Mgs0bWHKwS10lWeWj6dK8rdSt/mgOK9T9NvCsfFu+Z/5IAVnM0y9k0oxEpYTTpp49c+7xkf82mNnklpXvGqn4xCyLhRDLXgltJlvB7tUcFvT5JXKMlLsYc8/RXD92qa6VK2HOsZKLwGqZRWVUBAnlnLcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754364896; c=relaxed/simple;
	bh=uazo6AxhnzMqVuV9LYOrR3lAUeZXD+Rm58yGipTotn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q3jLT7S9CmBOCk5kQUywSgcZLSFEYIcmQsxfbict0TVF2GJ/uRW+u74OB5Vcui9o40DS3OJlXPtkoryyZfJMY3YfbeBzMfY6EAZ9nYz+pfdFHAJpY3w7zuUDCaPd/SyPk+MGw7AdYqQt73/MEH3/UVuK/NsEM3ofSkjbJ3Cl1f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bG0pYFwW; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 4 Aug 2025 23:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754364890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gtzZwzFTUxMXvdP3rpPNNlJGSXEoCkBvT6nZ7gpSP+Y=;
	b=bG0pYFwWXEJfvJCjvUS13/5DyHafUI6C2w85OT6P0+5bMo2F2t1f/DY/4fpo0Mpk2Iu+nU
	93Lgol8DpADRhp3THHEcFJpA2OBzEtxN7bzesJ3z07wK7T+jgzOCR63JStzU5scwPqhxEW
	nsJzy2YB9caTVDjA70QFOqVIFE8YPAo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Coly Li <colyli@kernel.org>
Cc: Zhou Jifeng <zhoujifeng@kylinos.com.cn>, 
	linux-bcache <linux-bcache@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Message-ID: <ylqh742munbd2iwmupsia6wjpgs4nzmodlfstbbpht6rbdpkqz@dhprafznlx2z>
References: <wxyamy7fkf7of4olnvqju2ldflnpj3k5u6qsufvesb3mtoaxwb@fuu5brsbgjwf>
 <tencent_6FE47FFD5A5D8EF818ACD926@qq.com>
 <p4uhjrka2rdj67ph5puvaixxhstcyfitzq63pwrafdwtabtjwn@fbie2x77lqee>
 <tencent_31215CC45AD29EC835D34AD8@qq.com>
 <c2awlgl4ih23npqa3k2ilbrbhciv3nfd7wg5xnsjjxikcmednb@nwn3qc7aqhou>
 <20250804153130.igwkb6baf3vtjhzu@P16.>
 <gc54e3mk6ftv5qhuqvuguuguq3nbrwhty543egvictmiua5me7@nrzyczdgceyr>
 <tencent_418348EE386ED24E54E87AD7@qq.com>
 <mu7u23kbguzgzfovqpadr6id2pi5a3l6tca2gengjiqgndutw2@qu4aj5didb4h>
 <20250805033120.7pzcpcjtpz5clnnz@P16.>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805033120.7pzcpcjtpz5clnnz@P16.>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 05, 2025 at 11:31:20AM +0800, Coly Li wrote:
> On Mon, Aug 04, 2025 at 09:31:38PM -0400, Kent Overstreet wrote:
> > > Could we consider the solution I submitted, which is based on the
> > > following main principle:
> > > 1. Firstly, in the write_dirty_finish stage, the dirty marking bkeys are
> > > not inserted into the btree immediately. Instead, they are temporarily
> > > stored in an internal memory queue called Alist.
> > > 2. Then, when the number of bkeys in Alist exceeds a certain limit, a
> > > flush request is sent to the backend HDD.
> > > 3. After the flush is sent, the bkeys recorded in Alist are then
> > > inserted into the btree.
> > > This process ensures that the written dirty data is written to the disk
> > > before the btree is updated. The length of Alist can be configured,
> > > allowing for better control of the flush sending frequency and reducing
> > > the impact of the flush on the write speed.
> > 
> > That approach should work as well. You'll want to make the list size
> > rather bit, and add statistics for how ofter flushes are being issued.
> >
> 
> OK, then let me review this patch.
> 
> Coly Li 

s/rather bit/rather large

