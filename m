Return-Path: <linux-bcache+bounces-1174-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0F77B1ACC3
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Aug 2025 05:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 647A5189D301
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Aug 2025 03:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFCD112DDA1;
	Tue,  5 Aug 2025 03:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ks1udaDd"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43CA146D45;
	Tue,  5 Aug 2025 03:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754364687; cv=none; b=Fpv3iZI737Ribs/Ws5a9D/QWXwle3GsHyTk9sp+MM3orOg4Tcd/oCd8bGjAU/DDjED6UkOM19w4RaJFc8FEETYBvG10vtUHxH7i06bPxD+/iuO8hBrvfiroKGkV/R664Vlc9FnLQ/nPenKsHZByXwI5vg/Ii0Ck58dfcqdPolMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754364687; c=relaxed/simple;
	bh=bH8xAnpKadepAuhv2CA8+Yxy+PGqajGPU1SeU3V2b3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=owt5+NE8kvN5N6fQwr/l/TR7YrNpLo/mCjK/m1kxikAi+stc6noUTycMxB92C2uBmSS1kI9uFzZtlNQFzkxiyBuJH6jbuf647IRrrR+c9Fz41D9WfAuaoKLikcLnNRhU0/AwLfwBc7Nu2PkvF3LZMHs5UGq06aD9PB8o8ppFkik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ks1udaDd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6698C4CEF4;
	Tue,  5 Aug 2025 03:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754364687;
	bh=bH8xAnpKadepAuhv2CA8+Yxy+PGqajGPU1SeU3V2b3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ks1udaDdBB0iHISzBLiBbQ42CtbVmLEN8HBSXGpU0o/bSuxLlN0zHQSdaOiqgGomc
	 o5UjrAif+e9dfgcl+ZIzPFIFo3uMJmbIP2iKYHsgJhDKhvw2pHXLRE+RvKS4ZKiku8
	 uNxAbzLv1FymFyxmP7PG9qIZYf8Z8MI2m+cimhHwe5vfK+sM8fo+1MM8o7XvOlDMpx
	 HmFCO3Y5ddCMcJKfuGdapxaxQs931M+wSSD5Vzi6qWDixSuUa1qbN3pwAavS8WlHUv
	 axAtx0hAs9i0GeBAjL8kBcFwK82u43S8QYUxj++/Hu+bHi8RnRFd6UEHkA9b9ypPoN
	 EIM6i4Uob4tGg==
Date: Tue, 5 Aug 2025 11:31:20 +0800
From: Coly Li <colyli@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Zhou Jifeng <zhoujifeng@kylinos.com.cn>,
	linux-bcache <linux-bcache@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Message-ID: <20250805033120.7pzcpcjtpz5clnnz@P16.>
References: <tencent_22DE1AC52BA931BD442CE823@qq.com>
 <wxyamy7fkf7of4olnvqju2ldflnpj3k5u6qsufvesb3mtoaxwb@fuu5brsbgjwf>
 <tencent_6FE47FFD5A5D8EF818ACD926@qq.com>
 <p4uhjrka2rdj67ph5puvaixxhstcyfitzq63pwrafdwtabtjwn@fbie2x77lqee>
 <tencent_31215CC45AD29EC835D34AD8@qq.com>
 <c2awlgl4ih23npqa3k2ilbrbhciv3nfd7wg5xnsjjxikcmednb@nwn3qc7aqhou>
 <20250804153130.igwkb6baf3vtjhzu@P16.>
 <gc54e3mk6ftv5qhuqvuguuguq3nbrwhty543egvictmiua5me7@nrzyczdgceyr>
 <tencent_418348EE386ED24E54E87AD7@qq.com>
 <mu7u23kbguzgzfovqpadr6id2pi5a3l6tca2gengjiqgndutw2@qu4aj5didb4h>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <mu7u23kbguzgzfovqpadr6id2pi5a3l6tca2gengjiqgndutw2@qu4aj5didb4h>

On Mon, Aug 04, 2025 at 09:31:38PM -0400, Kent Overstreet wrote:
> > Could we consider the solution I submitted, which is based on the
> > following main principle:
> > 1. Firstly, in the write_dirty_finish stage, the dirty marking bkeys are
> > not inserted into the btree immediately. Instead, they are temporarily
> > stored in an internal memory queue called Alist.
> > 2. Then, when the number of bkeys in Alist exceeds a certain limit, a
> > flush request is sent to the backend HDD.
> > 3. After the flush is sent, the bkeys recorded in Alist are then
> > inserted into the btree.
> > This process ensures that the written dirty data is written to the disk
> > before the btree is updated. The length of Alist can be configured,
> > allowing for better control of the flush sending frequency and reducing
> > the impact of the flush on the write speed.
> 
> That approach should work as well. You'll want to make the list size
> rather bit, and add statistics for how ofter flushes are being issued.
>

OK, then let me review this patch.

Coly Li 

