Return-Path: <linux-bcache+bounces-1166-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BDAEB18F93
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Aug 2025 19:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 601D7189AA28
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Aug 2025 17:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D882624BBEC;
	Sat,  2 Aug 2025 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlNRXFop"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D8F17A2EC;
	Sat,  2 Aug 2025 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754155799; cv=none; b=EDNClSSP533lWFt1g+6+Iv7RyIdABbi4Jlmh9I8wlHJ/vFptO8Y3eWxizIgYKcONxilWHcrogjLAs3qgpRgDt2xpbexVP+uYVnRj7E6tynNqDAmhIVHpI7AxEr0NsV0eMclyOBiGkIjyCS3syD7uhs7P8mMkqAvxRQz3H5dzftE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754155799; c=relaxed/simple;
	bh=eNAtyQFKX/W5Qa6UnTZ0A9NQMJcPaisQ5AvkovUgd8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cLlQgyVVwgJ0xS4N/gD5RldddfGtDhRGowJbRksMu6HotlMRHkhtuDsF50EMI/04Dx+dUNGA7Dkv1HklJAHgZYS0Gr7+X9ABSJhXXCxAwMl9/IXUOJzevN3qPETRQXCCsAS66fVIToZ+405iddZRk3n2JqgeTCaKI0xWqJ/4KNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlNRXFop; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C58DC4CEEF;
	Sat,  2 Aug 2025 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754155799;
	bh=eNAtyQFKX/W5Qa6UnTZ0A9NQMJcPaisQ5AvkovUgd8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UlNRXFopjna7M+0JmMyrDkQFWeATW2HPraT107Y5rsEWxKd2Or8UJGduRbYHoKyzq
	 GYBD5oBlBbUsan+kCssE49cyR35ubFjIaPZuTPZPJvcbo24kaXU1TCnCNIUfMSJT86
	 SMJSC6GEkabhjwppOvjDjpGXiWiZhff/XJWpbuOaM4S0W/NOSKofR0CAK0iFOmsvaz
	 txdpsP9DXQ08Mov+F3KXrMpvyioJujXdTIXZl2k+kKFTUys4KTEQ/nUWk37fedp9RQ
	 8MeeQdxPEtAZLnBI/+lB3T52oGJSDowppALcWQ+V2P+n6S+5KdNHabFzK9BMIv+2t2
	 DbcRMku9ul2Uw==
Date: Sun, 3 Aug 2025 01:29:55 +0800
From: Coly Li <colyli@kernel.org>
To: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache <linux-bcache@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Message-ID: <p4uhjrka2rdj67ph5puvaixxhstcyfitzq63pwrafdwtabtjwn@fbie2x77lqee>
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
 <etlu4r6gxbe2jc3eemj3n4slg6xraxtxxydvxvmhv77xv42uss@7aw3yxbdgrdl>
 <tencent_656F159830BC538C2D26CD68@qq.com>
 <zcxdklyr2ugq7cfbed4olcsfcboy3nksxtpjs2g76bauvef5cq@4akbspw3ydiw>
 <tencent_22DE1AC52BA931BD442CE823@qq.com>
 <wxyamy7fkf7of4olnvqju2ldflnpj3k5u6qsufvesb3mtoaxwb@fuu5brsbgjwf>
 <tencent_6FE47FFD5A5D8EF818ACD926@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tencent_6FE47FFD5A5D8EF818ACD926@qq.com>

On Fri, Aug 01, 2025 at 02:10:12PM +0800, Zhou Jifeng wrote:
> On Fri, 1 Aug 2025 at 11:42, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Aug 01, 2025 at 11:30:43AM +0800, Zhou Jifeng wrote:
> > > On Fri, 1 Aug 2025 at 10:37, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > > >
> > > > On Fri, Aug 01, 2025 at 10:27:21AM +0800, Zhou Jifeng wrote:
> > > > > In the writeback mode, the current bcache code uses the
> > > > > REQ_OP_WRITE operation to handle dirty data, and clears the bkey
> > > > > dirty flag in the btree during the bio completion callback. I think
> > > > > there might be a potential risk: if in the event of an unexpected
> > > > > power outage, the data in the HDD hardware cache may not have
> > > > > had time to be persisted, then the data in the HDD hardware cache
> > > > > that is pending processing may be lost. Since at this time the bkey
> > > > > dirty flag in the btree has been cleared, the data status recorded
> > > > > by the bkey does not match the actual situation of the SSD and
> > > > > HDD.
> > > > > Am I understanding this correctly?
> > > >
> > > > For what you're describing, we need to make sure the backing device is
> > > > flushed when we're flushing the journal.
> > > >
> > > > It's possible that this isn't handled correctly in bcache; bcachefs
> > > > does, and I wrote that code after bcache - but the bcache version would
> > > > look quite different.
> > > >
> > > > You've read that code more recently than I have - have you checked for
> > > > that?
> > >
> > > In the `write_dirty_finish` function, there is an attempt to update the
> > > `bkey` status, but I did not observe any logging writing process. In the
> > > core function `journal_write_unlocked` of bcache for writing logs, I
> > > also couldn't find the code logic for sending a FLUSH command to the
> > > backend HDD.
> >
> > The right place for it would be in the journal code: before doing a
> > journal write, issue flushes to the backing devices.
> >
> > Can you check for that?
> >
> 
> I checked and found that there was no code for sending a flush request
> to the backend device before the execution log was written. Additionally,
> in the callback function after the dirty data was written back, when it
> updated the bkey, it did not insert this update into the log.
>

It doesn't have to. If the previous dirty version of the key is on cache device
already, and power off happens, even the clean version of the key is gone, the
dirty version and its data are all valid. If the LBA range of this key is
allocated to a new key, a GC must have alrady happened, and the dirty key is
invalid due to bucket generation increased. So don't worry, the clean key is
unncessary to go into journal in the writeback scenario.
 
IMHO, you may try to flush backing device in a kworker before calling
set_gc_sectors() in bch_gc_thread(). The disk cache can be flushed in time
before the still-dirty-on-disk keys are invalidated by increase bucket key
gen. And also flushing backing device after searched_full_index becomes
true in the writeback thread main loop (as you did now).

Flushing backing device after read_dirty() returns is too heavy, event with
the flush hint keys. And the flushing operations are unnecessary before the
keys are reclaimed by garbage collaction.

Just my suggestion for your consideration.

Thanks.

Coly Li


> The following callback function after dirty data is written back only
> updates the bkey, without recording the inserted bkey in the journal:
> static CLOSURE_CALLBACK(write_dirty_finish)
> {
>     closure_type(io, struct dirty_io, cl);
>     struct keybuf_key *w = io->bio.bi_private;
>     struct cached_dev *dc = io->dc;
> 
>     bio_free_pages(&io->bio);
> 
>     /* This is kind of a dumb way of signalling errors. */
>     if (KEY_DIRTY(&w->key)) {
>         int ret;
>         unsigned int i;
>         struct keylist keys;
> 
>         bch_keylist_init(&keys);
> 
>         bkey_copy(keys.top, &w->key);
>         SET_KEY_DIRTY(keys.top, false);
>         bch_keylist_push(&keys);
> 
>         for (i = 0; i < KEY_PTRS(&w->key); i++)
>             atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
> 
>         ret = bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
> 
>         if (ret)
>             trace_bcache_writeback_collision(&w->key);
> 
>         atomic_long_inc(ret
>                 ? &dc->disk.c->writeback_keys_failed
>                 : &dc->disk.c->writeback_keys_done);
>     }
> 
>     bch_keybuf_del(&dc->writeback_keys, w);
>     up(&dc->in_flight);
> 
>     closure_return_with_destructor(cl, dirty_io_destructor);
> }



