Return-Path: <linux-bcache+bounces-1320-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B467AC9A212
	for <lists+linux-bcache@lfdr.de>; Tue, 02 Dec 2025 06:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71FF43A52EE
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Dec 2025 05:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8932F90D5;
	Tue,  2 Dec 2025 05:48:47 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32A71F130A;
	Tue,  2 Dec 2025 05:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654527; cv=none; b=FbwSZZR/V7ydolyhhbbD7IrmLxlzlv6BAp9MNjnHNVtwK0TbGA+KCG44dipfmAk0RaVYTIcdLCnPN1uovxktGVSwGvdWEGwPKHUj2rJ29QaAVECbtFq6y4IYIhUz618RV0ncQm0FBnEg+7la9bKMf2h7ZKMgwtT8Cmf1NibEk2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654527; c=relaxed/simple;
	bh=g+vqXtzPJeEI3Dd6FtmOglXCbH56j06fAkw/GmAGAfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pYKHQsKzM3l81mXIeRx/157N7cfY+wD2fjYhSc6Uk7uG07CCFnbeGUk6fTnPAHOAO0rL8sjCfbEJ9Xg3UfME1ZaBxNTrdvfUanx+pdeTy9jqFbYKVB4mMqa7mBlJ6cOnVN8TpYLFvubKFUGXIV2a1zRgwuTTeZncPKEJ8XSRdgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D1A9868AA6; Tue,  2 Dec 2025 06:48:41 +0100 (CET)
Date: Tue, 2 Dec 2025 06:48:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: zhangshida <starzhangzsd@gmail.com>, Johannes.Thumshirn@wdc.com,
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com,
	csander@purestorage.com, colyli@fnnas.com,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH v4 3/3] block: prevent race condition on bi_status in
 __bio_chain_endio
Message-ID: <20251202054841.GC15524@lst.de>
References: <20251201090442.2707362-1-zhangshida@kylinos.cn> <20251201090442.2707362-4-zhangshida@kylinos.cn> <CAHc6FU4o8Wv+6TQti4NZJRUQpGF9RWqiN9fO6j55p4xgysM_3g@mail.gmail.com> <aS17LOwklgbzNhJY@infradead.org> <CAHc6FU7k7vH5bJaM6Hk6rej77t4xijBESDeThdDe1yCOqogjtA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHc6FU7k7vH5bJaM6Hk6rej77t4xijBESDeThdDe1yCOqogjtA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 01, 2025 at 02:07:07PM +0100, Andreas Gruenbacher wrote:
> On Mon, Dec 1, 2025 at 12:25 PM Christoph Hellwig <hch@infradead.org> wrote:
> > On Mon, Dec 01, 2025 at 11:22:32AM +0100, Andreas Gruenbacher wrote:
> > > > -       if (bio->bi_status && !parent->bi_status)
> > > > -               parent->bi_status = bio->bi_status;
> > > > +       if (bio->bi_status)
> > > > +               cmpxchg(&parent->bi_status, 0, bio->bi_status);
> > >
> > > Hmm. I don't think cmpxchg() actually is of any value here: for all
> > > the chained bios, bi_status is initialized to 0, and it is only set
> > > again (to a non-0 value) when a failure occurs. When there are
> > > multiple failures, we only need to make sure that one of those
> > > failures is eventually reported, but for that, a simple assignment is
> > > enough here.
> >
> > A simple assignment doesn't guarantee atomicy.
> 
> Well, we've already discussed that bi_status is a single byte and so
> tearing won't be an issue. Otherwise, WRITE_ONCE() would still be
> enough here.

No.  At least older alpha can tear byte updates as they need a
read-modify-write cycle.  But even on normal x86 the check and the update
would be racy.  The cmpxchg makes the intentions very clear, works
everywhere and given it only happens in the error path does not create
any fast path overhead.


