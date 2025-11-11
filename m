Return-Path: <linux-bcache+bounces-1240-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A01FC4E37A
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Nov 2025 14:44:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AE3D1898AAB
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Nov 2025 13:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B547A342513;
	Tue, 11 Nov 2025 13:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="xWpSYUW+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ABB331217
	for <linux-bcache@vger.kernel.org>; Tue, 11 Nov 2025 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762868598; cv=none; b=TXmzgZUMQLstkdnnbBXlMiPHY+B6gRJhbHE7n7a9Z9JuZKDFWyAw3EOhphaUiSzgXX1Pgrm1STadZsXfs2HpRcvlgDTUEKlodE8L/vDcrlvHzdO3csu74JQqf9K39Vev4nB/n2eT//i5Io2puFf3vO8XGRKo0T/h3dm0A6korIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762868598; c=relaxed/simple;
	bh=0H+Gerke8ppaRRjtigYGXTcaKIwDUqySBp2HGWMLq8o=;
	h=In-Reply-To:To:Subject:Cc:Message-Id:From:Date:Mime-Version:
	 Content-Disposition:References:Content-Type; b=jxDCBhz1O6Z8C4ILqznAylrtENmN4n1TXBXY1RVbsw3S3Xw9/LcFYQoHyzUgfhUYyQLxTp/4ZDhPRBQKcsK09PON8uMGjsDQCDGLBo+3wP8rCtcsBawpgWwwgOQmumNF475rS8Agyd8nEXbbpx58h9GK0sKy8ULv1vHAwYPXecA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=xWpSYUW+; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762868589;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2b0zj8nz9IcPCTEaSOwNKpCL+oqq9pnCWEKq4tv2bec=;
 b=xWpSYUW+pfKj4cO3OiSy+Zqb1p1zeYS/RcMOADsFIwftnDA6Bh7pTfEWMHHRCbh2MIobSp
 HIObglcX8SxdRCvk/Gxfsf8FC9afz42SP7FgCJPSmv1/yrWgFcxmySo5iHevP5BrywLltQ
 jMp3jSPNlxI78wkPdf1S2pULt5v+4FvVVFgasfMpkWV3t77+DFun1CO4GCDujTGsBHLHve
 +R11eIs/taS7KMCPRebecODXEY6YjJ69+rRC+g5YjvJsx2AelbGq+pgh2lr7/lewqfWzCM
 BobTFGDq5tSFKaXwfOdSHPa4tyOGlX/uUxXkAIH+rkVyiGX7TYh/bKtEX+3akw==
In-Reply-To: <a956504a-55af-4c2c-95a0-15663435624a@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH][next] bcache: Avoid -Wflex-array-member-not-at-end warning
Received: from studio.coly ([120.245.64.178]) by smtp.feishu.cn with ESMTPS; Tue, 11 Nov 2025 21:43:06 +0800
Content-Transfer-Encoding: 7bit
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>
Message-Id: <7zweggwc6mkksyhxzbdsphachjj5pzlaebli6xitryfl4yiqdj@eziyaibeuhza>
X-Lms-Return-Path: <lba+269133d6b+56f6ac+vger.kernel.org+colyli@fnnas.com>
From: "Coly Li" <colyli@fnnas.com>
Date: Tue, 11 Nov 2025 21:43:05 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Disposition: inline
References: <aRHFchrO3BmVMH5c@kspp> <7g2dkwi2nzxe2luykodsknobzr5bkl23d5mbahkyo7adhg55oy@6uisoc7jzgy6> <a956504a-55af-4c2c-95a0-15663435624a@embeddedor.com>
X-Original-From: Coly Li <colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8

On Tue, Nov 11, 2025 at 10:28:57PM +0800, Gustavo A. R. Silva wrote:
> 
> 
> On 11/11/25 22:17, Coly Li wrote:
> > On Mon, Nov 10, 2025 at 07:58:58PM +0800, Gustavo A. R. Silva wrote:
> > > -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> > > getting ready to enable it, globally.
> > > 
> > > Use the new TRAILING_OVERLAP() helper to fix the following warning:
> > > 
> > > drivers/md/bcache/bset.h:330:27: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> > > 
> > > This helper creates a union between a flexible-array member (FAM) and a
> > > set of MEMBERS that would otherwise follow it.
> > > 
> > > This overlays the trailing MEMBER struct btree_iter_set stack_data[MAX_BSETS];
> > > onto the FAM struct btree_iter::data[], while keeping the FAM and the start
> > > of MEMBER aligned.
> > > 
> > > The static_assert() ensures this alignment remains, and it's
> > > intentionally placed inmediately after the corresponding structures --no
> > > blank line in between.
> > > 
> > > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > > ---
> > >   drivers/md/bcache/bset.h | 8 ++++++--
> > >   1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> > > index 011f6062c4c0..6ee2c6a506a2 100644
> > > --- a/drivers/md/bcache/bset.h
> > > +++ b/drivers/md/bcache/bset.h
> > > @@ -327,9 +327,13 @@ struct btree_iter {
> > >   /* Fixed-size btree_iter that can be allocated on the stack */
> > >   struct btree_iter_stack {
> > > -	struct btree_iter iter;
> > > -	struct btree_iter_set stack_data[MAX_BSETS];
> > > +	/* Must be last as it ends in a flexible-array member. */
> > > +	TRAILING_OVERLAP(struct btree_iter, iter, data,
> > > +		struct btree_iter_set stack_data[MAX_BSETS];
> > > +	);
> > >   };
> > > +static_assert(offsetof(struct btree_iter_stack, iter.data) ==
> > > +	      offsetof(struct btree_iter_stack, stack_data));
> > > 
> > 
> > I have to say this is ugly. Not the patch, but the gcc 14 warning option
> > of such coding style. Look at TRAILING_OVERLAP() usage here, this is not
> > C, this is something to fix a gcc bug which cannot handle FAM properly.
> 
> This is not a GCC bug.
> 
> > 
> > Gustavo, this complain is not to you, just I feel a bit sad how GCC makes
> > the code comes to such an ugly way, and it makes things much complicated.
> > For anyone doesn't have deep understanding of TRAILING_OVERLAP(), I
> > highly suspect whether he or she can understand what happens here.
> > 
> > Andrew and Gustavo, is this a mandatary to fix FAM in such way? If yes
> > I take the patch and keep my own opinion. If not, I'd like to see gcc
> > fixes its bug, for the this code I don't see the author does things
> > wrong.
> 
> This is a false positive that needs to be addressed in some way in order to
> enable -Wflex-array-member-not-at-end in mainline.
> 
> Here you can take a look at the patches I (and others) have submitted to
> modify similar code over the last year:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/?qt=grep&q=-Wflex-array-member-not-at-end
> 

I see. I take this patch, with the above complain...

Coly Li

