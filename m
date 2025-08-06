Return-Path: <linux-bcache+bounces-1180-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7019EB1C99E
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Aug 2025 18:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EEDD623B25
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Aug 2025 16:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767462989B4;
	Wed,  6 Aug 2025 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYmXYE2A"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3A318A6AB;
	Wed,  6 Aug 2025 16:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754496656; cv=none; b=Vh378qhgXRC9X1F9e/x7GCM8BZPfECrenP2UCt4xpsU7GrGyBAC6dGuC46d+NdQaew6RBht6jAC492oSEo/XMOo7AwQUWbBBF+rsQqJakaUbXdfcje7m9+M2nOtg4bPFxwxC1aYtipVk7dZtEtDw8zzAEHR8iy9v3oMrSJIg8WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754496656; c=relaxed/simple;
	bh=WqURAroBlot3BKcRkU57tPw+uTst8u/HvzLlwfACFxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJdprHWWJAFXbtagFAjQcr7x63YQz61Y2BtoCaQsLWDJQG22pEh33ZzYGH3JP7PSgB6bOl3TQStipWwGaiY+wlxWxeGFE3TomSxRzTB2AvpHhSg3G4mPP+TgS8MqdM2kARt7oTlutlcJaXM7UksA3OAElwCgOvjU5uPpH/3Dw0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYmXYE2A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0471EC4CEE7;
	Wed,  6 Aug 2025 16:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754496655;
	bh=WqURAroBlot3BKcRkU57tPw+uTst8u/HvzLlwfACFxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kYmXYE2AfPcc3M5icsim0mDqdiZQuLqBgY2TqDXrtz+rGU77FlgOpanCshl/bjtKd
	 Tk7UVWn4uflLxA7GjuESUmCom0SMp/wNTn1PIEo9ajPtD7DReWpbl2XUS3eH7kqK/a
	 HdWXZ7wCB4ktLlcsYiXpztFDTPk/i1ULmmqqKGixxGkrhZb9dZ/hCiQvaPeoZfHuiz
	 RfkXkm7xf7L9tDOUmaliPnfsBd0Hg9SKONukUGPeTNjz/VklTiirCJyFsoO/cjbLS5
	 k2bSvaBcPFQrcQo2XguOqALJBUX0O1J8Az6uXvpcEXCrJVDBzDxGJEzO2UAqrLlOQM
	 /I6wevf864rNw==
Date: Thu, 7 Aug 2025 00:10:50 +0800
From: Coly Li <colyli@kernel.org>
To: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Cc: "kent.overstreet" <kent.overstreet@linux.dev>,
	linux-bcache <linux-bcache@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Message-ID: <20250806161050.iggmpp4mdmcysegn@P16.>
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
 <20250805045745.iu4ukc6tfdm3j7xn@P16.>
 <tencent_29AAD4111647BCD160DCFD85@qq.com>
 <20250805162915.3kaqbxjbwfuj6u6w@P16.>
 <tencent_59A1DBB462115B77340A389D@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tencent_59A1DBB462115B77340A389D@qq.com>

On Wed, Aug 06, 2025 at 07:19:49PM +0800, Zhou Jifeng wrote:
> On Wed, 6 Aug 2025 at 00:29, Coly Li <colyli@kernel.org> wrote:
> >
> > On Tue, Aug 05, 2025 at 05:37:44PM +0800, Zhou Jifeng wrote:
> > > On Tue, 5 Aug 2025 at 13:00, Coly Li <colyli@kernel.org> wrote:
> > > >
> > > > On Thu, Jul 31, 2025 at 02:21:40PM +0800, Zhou Jifeng wrote:
> > > > > There is a potential data consistency risk in bcache's writeback mode:when
> > > > > the application calls fsync, bcache returns success after completing the
> > > > > log write, persisting the cache disk data, and persisting the HDD internal
> > > > > cache. However, at this point, the actual application data may still be in
> > > > > a dirty state and remain stuck in the cache disk. when these data are
> > > > > subsequently written back to the HDD asynchronously through REQ_OP_WRITE,
> > > > > there is no forced refresh mechanism to ensure physical placement on the
> > > > > disk, and there may be no power-off protection measures, which poses a risk
> > > > > of data loss. This mechanism may cause the application to misjudge that the
> > > > > data has been persisted, which is different from the actual storage state,
> > > > > and also violates the semantic agreement that fsync should ensure data
> > > > > persistence.
> > > > >
> > > >
> > > > [snipped]
> > > >
> > > >
> > > >
> > > > If before the cleared key inserted into the btree, there are new write
> > > > into overlapped LBA range of the cleared key and a dirty key inserted.
> > > > Then the cleared key is inserted and overwrites the dirty key, but the
> > > > dirty data on cache is not written back to backing device yet. How to
> > > > handle such situation?
> > > >
> > >
> > > There are indeed some issues here. I have initially come up with a
> > > solution: Utilize the existing dc->writeback_keys mechanism for
> > > protection. The general processing flow is as follows:
> > > 1. In the write_dirty_finish() function, remove the operation of
> > > updating bkey insertion, and delete the code bch_keybuf_del(&dc
> > > ->writeback_keys, w).
> > > 2. After executing the read_dirty(dc) code, perform flush, then
> > > insert the updated bkey, and finally remove the bkey from dc->
> > > writeback_keys. This process is equivalent to sending a flush
> > > every KEYBUF_NR bkeys are written back.
> > > 3. Support configurable KEYBUF_NR to indirectly control the
> > > frequency of flush.
> > >
> > > Is this plan appropriate? Or are there any better ways to handle it?
> >
> > No, I won't suggest this way. It sounds complicaed and changes the main
> > code flow too much in an implicit way, this should be avoided.
> >
> > So it seems Kent's suggestion to flush backing device before committing
> > jset is the proper method I can see now.
> >
> > Coly Li
> >
> 
> Sorry, my previous response was not rigorous enough. I have carefully
> considered your question about "the bkey being overwritten". In fact,
> there is no issue of being overwritten. The bcache has ingeniously
> designed a replace mechanism. In my code, the bkey with the dirty flag
> cleared is inserted using the replace method. This method handles
> address overlaps ingeniously during the insertion of the bkey and will
> not overwrite the bkey generated by concurrent writes. The main code
> for the replace mechanism is located in bch_btree_insert_key->bch_extent_insert_fixup
> , which calls the bch_bkey_equal_header function, which is also a
> crucial checkpoint.

I am not able to make judgement by the above description, can you post a patch
then I can see how you insert the key with replace parameter.

Coly Li

