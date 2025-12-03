Return-Path: <linux-bcache+bounces-1325-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 66AF1C9DE81
	for <lists+linux-bcache@lfdr.de>; Wed, 03 Dec 2025 07:14:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DB725346CBC
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Dec 2025 06:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3BC25B31D;
	Wed,  3 Dec 2025 06:14:10 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E839C1FFC59;
	Wed,  3 Dec 2025 06:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764742450; cv=none; b=m4UREpRacBDbWhI6t+WoqNGIdpooi6cSGcrYtgML5wyu9/gB/+1Nbao+TiymSg4EtW+m3EcETWrl4+wR7oDYnzbXggSbtf+Te4GKw8B9GrE7GYtPpFQI31j+Hd5ORhvmNxIXM8yB742sq7/WWktzrWAFa5Ftg7b9U1EBcrugzT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764742450; c=relaxed/simple;
	bh=/u1H3TxmuYD3SuHYqYM3U/2R/m8Fg/gP0U8T1C7keJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BnlZwokULt7Dv3uP5L19RNLTrv+DJiT0Mlfg7h/FW0wMOz9JjKxGWlGOZRjoyeWqdVc7E9GOg7F8kluCfmh4b/pGXzg1e+YzvFm5M2h+9INtCVlC6MDFhL+QXPMItfNcPLuOnr9KvcNXl0OWUBR/6WJKqGPWTZWpWrW0FBgA+XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F30DC68B05; Wed,  3 Dec 2025 07:14:03 +0100 (CET)
Date: Wed, 3 Dec 2025 07:14:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Johannes.Thumshirn@wdc.com,
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com,
	csander@purestorage.com, colyli@fnnas.com,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH v4 3/3] block: prevent race condition on bi_status in
 __bio_chain_endio
Message-ID: <20251203061403.GA16604@lst.de>
References: <20251201090442.2707362-1-zhangshida@kylinos.cn> <20251201090442.2707362-4-zhangshida@kylinos.cn> <CAHc6FU4o8Wv+6TQti4NZJRUQpGF9RWqiN9fO6j55p4xgysM_3g@mail.gmail.com> <aS17LOwklgbzNhJY@infradead.org> <CAHc6FU7k7vH5bJaM6Hk6rej77t4xijBESDeThdDe1yCOqogjtA@mail.gmail.com> <20251202054841.GC15524@lst.de> <CAHc6FU6B6ip8e-+VXaAiPN+oqJTW2Tuoh0Vv-E96Baf2SSbt7w@mail.gmail.com> <CANubcdWHor3Jx+5yeY84nx0yFe3JosqVG4wGdVkpMfbQLVAWpQ@mail.gmail.com> <CANubcdWBF5tCfrutAOiUkFaZb=9s4=bMKzi7dSwQxTGbC_3_1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdWBF5tCfrutAOiUkFaZb=9s4=bMKzi7dSwQxTGbC_3_1Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 03, 2025 at 11:09:36AM +0800, Stephen Zhang wrote:
> 
> I’ve been reconsidering the two approaches for the upcoming patch revision.
> Essentially, we’re comparing two methods:
> A:
>         if (bio->bi_status)
>                    parent->bi_status = bio->bi_status;
> B:
>         if (bio->bi_status)
>                 cmpxchg(&parent->bi_status, 0, bio->bi_status);
> 
> Both appear correct, but B seems a little bit redundant here.

A is not correct.  You at least needs READ_ONCE/WRITE_ONCE here.

B solves all these issues.

> Upon further reflection, I’ve noticed a subtle difference:
> A unconditionally writes to parent->bi_status when bio->bi_status is non-zero,
> regardless of the current value of parent->bi_status.
> B uses cmpxchg to only update parent->bi_status if it is still zero.
> 
> Thus, B could avoid unnecessary writes in cases where parent->bi_status has
> already been set to a non-zero value.

The unnecessary writes don't really matter, we're in an error slow path
here.


