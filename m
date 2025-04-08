Return-Path: <linux-bcache+bounces-859-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4FBA7FC8B
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 12:44:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C50D6189B103
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 10:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D5D9266B73;
	Tue,  8 Apr 2025 10:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E3IREDl5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7258A264A88;
	Tue,  8 Apr 2025 10:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744108750; cv=none; b=MVhiVqabqhWHy2iZuXGmeaG4urZ4zXFTde/Ad/05IAX+IEJNMSQgJo1WMSCOEuH221Q2Ab0lKcBV2UCB0FFrMbguNwIHglZ3+1fBAa0BYUyo2+lAhWdtF22FM2Fg+OAw988xaUpEmuXbDPEr9H9tPH59N2d2GkF7Xjmm8SG2tDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744108750; c=relaxed/simple;
	bh=QpJG9H5T8cY42DnW9QAlexFT0QzgTyNQEECGuCjDIgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbRAV0/OxvyuSNU2kxFxx+I94r0Vrshnl1QqQAsNVzGv5utCqibsTJNNEP1X6jGkKgLYj9UrIOxmD2J5o+u2tMoF/wTbrtH6zYByq/V+fs54dMVmkwhdvQvJ4FWf/yBQtgsVoVw3+f3JJRv5YdQJN8jdQTcEKn4WK2LYgoQAdL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E3IREDl5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEA7C4CEE5;
	Tue,  8 Apr 2025 10:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744108750;
	bh=QpJG9H5T8cY42DnW9QAlexFT0QzgTyNQEECGuCjDIgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E3IREDl5rD0W3NMQqmocoXRX7qSKOF/dyEEcWk9r2j50qHmukxA9sLvVo5wNsXMqC
	 ItNS9cSTk+LMZT9RyMA21RNIqJZpiwU4ImpwJv4C8vX9idx/PAgyv/6vjl96gAIxwi
	 b6GMue5xgUs1vPixD0m1ysf0za+bSq9+NI+0v+V6AzYjNzL3ECr3i73YV2jzaD4i7I
	 c0POxch8T5g40tmfF+Wzwc+RE3+JB5SdQETtcQSrqN47624gqgQiKOhR0TYURkDVPc
	 U3rELYatB5Suu+xk18vL2ogBdnZx6mxa0gF1W7VMqy7mCU21aNB+/P/WidXgWw1An6
	 1pIMe5xziafUQ==
Date: Tue, 8 Apr 2025 18:39:06 +0800
From: Coly Li <colyli@kernel.org>
To: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	kernelmentees@lists.linuxfoundation.org
Subject: Re: [PATCH 2/2] bcache: Fix warnings for incorrect type in
 assignments
Message-ID: <zqhlvh3jftam6ka5hu7ardcnaeyzvbvbmttjqubeeutuhcmurp@dsgpwpwvgj6y>
References: <20250408033322.401680-1-gshahrouzi@gmail.com>
 <20250408033322.401680-3-gshahrouzi@gmail.com>
 <7muoawncdumcsclkcxklw6olqcjko63et26ptbh5lidximffoh@lu34aqtcujtn>
 <CAKUZ0zKWDVocdSa60ZZPjq9u24wEW+EaUsXoUrrCF=Z+pacGHQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKUZ0zKWDVocdSa60ZZPjq9u24wEW+EaUsXoUrrCF=Z+pacGHQ@mail.gmail.com>

On Tue, Apr 08, 2025 at 03:15:00AM +0800, Gabriel Shahrouzi wrote:
> On Tue, Apr 8, 2025 at 12:58 AM Coly Li <colyli@kernel.org> wrote:
> >
> > On Mon, Apr 07, 2025 at 11:33:22PM +0800, Gabriel Shahrouzi wrote:
> > > Remove unnecessary cpu_to_le16() and cpu_to_le32() conversions when
> > > assigning values (priorities, timestamps) to native integer type
> > > members. Prevent incorrect byte ordering for big-endian systems.
> > >
> >
> > Hmm, why do you feel the conversions are unncessary? Please explain
> > with details.
> I used Sparse for static analysis on bcache and it gave incorrect type
> in assignment warnings.
> 
> For example:
> 
> u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
> 
> ktime_get_real_seconds() returns back u64 and gets casted down to a
> u32. u is of type struct uuid_entry whose member fields are either u8,
> u32, or u64. A conversion here contradicts the type it should be
> assigned.
> 
> From my understanding, this would not produce an unexpected result if
> the value were to be read from or written to some location which seems
> to be the case here. I believe it would only cause issues on
> big-endian systems if the value were to be modified in some way.
> 

Yes you are right, and I agree with you.


> Looking at the commit history for when the code for this specific
> example was first introduced (12 years ago), it seems like this was
> the author’s intent. It looks like the intention was to store the
> value as little endian in uint32_t. Doing this, the author saves space
> / time. If the type was le32 instead, the conversion would have to be
> applied each time it’s used. Alternatively, if another member variable
> was defined but for the le32 version, then extra space is used up.
> 

This is kind of convention that on-media values are stored in little
endian, for portablity purpose. But bcache is special, current
implementation and usage don't require/support portability on different
byte order machines. So cpu_to/from_le** routines are almostly
unnecessary indeed.

*BUT* the cast (u32) works as expected on big endian machine as well,
same result generated as little indian machine does. The out-of-order
issue on big endian machine for the code you mentioned won't happen. 

> In the unlikely event that these specific files change drastically,
> making sure the types are the same serves as a preventative measure
> to make sure it’s not misused. On the other hand, making the change
> most likely goes against the author’s original intent and could cause
> something unintended.
> >
> > I don't mean the modification is correct or incorrect, just want to
> > see detailed analysis and help me understand in correct why as you
> > are.
> >
> > BTW, did you have chance to test your patch on big-endian machine?
> I only analyzed the compilation warnings so far. I’ll look into trying
> to test this on a big-endian machine.
> 
> 

You may have a try and verify my statement.

And for the change in bch_prio_write(), this is something out of your
orignal scope of this patch. The prio width is 16bits, byte order and
length truncation issue doesn't apply here.

After all, no mather the cpu_to_le*() or le*_to_cpu() routines are used
or not, the code works well. Because bcache cache device dosn't port
between big and little endian machines.

I don't want to unify the code to all use cpu_to_le*() routines or
remove all these routines, both sides make sense and resonable.
IMHO they are just changes for changing. So I intend to keep it as what
Kent orignally wrote it.

Thanks.

> > > Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
> > > ---
> > >  drivers/md/bcache/super.c | 12 ++++++------
> > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > > index e42f1400cea9d..c4c5ca17fb600 100644
> > > --- a/drivers/md/bcache/super.c
> > > +++ b/drivers/md/bcache/super.c
> > > @@ -648,7 +648,7 @@ int bch_prio_write(struct cache *ca, bool wait)
> > >               for (b = ca->buckets + i * prios_per_bucket(ca);
> > >                    b < ca->buckets + ca->sb.nbuckets && d < end;
> > >                    b++, d++) {
> > > -                     d->prio = cpu_to_le16(b->prio);
> > > +                     d->prio = b->prio;
> > >                       d->gen = b->gen;
> > >               }
> > >
> > > @@ -721,7 +721,7 @@ static int prio_read(struct cache *ca, uint64_t bucket)
> > >                       d = p->data;
> > >               }
> > >
> > > -             b->prio = le16_to_cpu(d->prio);
> > > +             b->prio = d->prio;
> > >               b->gen = b->last_gc = d->gen;
> > >       }
> > >
> > > @@ -832,7 +832,7 @@ static void bcache_device_detach(struct bcache_device *d)
> > >
> > >               SET_UUID_FLASH_ONLY(u, 0);
> > >               memcpy(u->uuid, invalid_uuid, 16);
> > > -             u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
> > > +             u->invalidated = (u32)ktime_get_real_seconds();
> > >               bch_uuid_write(d->c);
> > >       }
> > >
> > > @@ -1188,7 +1188,7 @@ void bch_cached_dev_detach(struct cached_dev *dc)
> > >  int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
> > >                         uint8_t *set_uuid)
> > >  {
> > > -     uint32_t rtime = cpu_to_le32((u32)ktime_get_real_seconds());
> > > +     uint32_t rtime = (u32)ktime_get_real_seconds();
> > >       struct uuid_entry *u;
> > >       struct cached_dev *exist_dc, *t;
> > >       int ret = 0;
> > > @@ -1230,7 +1230,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
> > >           (BDEV_STATE(&dc->sb) == BDEV_STATE_STALE ||
> > >            BDEV_STATE(&dc->sb) == BDEV_STATE_NONE)) {
> > >               memcpy(u->uuid, invalid_uuid, 16);
> > > -             u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
> > > +             u->invalidated = (u32)ktime_get_real_seconds();
> > >               u = NULL;
> > >       }
> > >
> > > @@ -1591,7 +1591,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
> > >
> > >       get_random_bytes(u->uuid, 16);
> > >       memset(u->label, 0, 32);
> > > -     u->first_reg = u->last_reg = cpu_to_le32((u32)ktime_get_real_seconds());
> > > +     u->first_reg = u->last_reg = (u32)ktime_get_real_seconds();
> > >
> > >       SET_UUID_FLASH_ONLY(u, 1);
> > >       u->sectors = size >> 9;
> > > --
> > > 2.43.0
> > >
> >
> > --
> > Coly Li
> 

-- 
Coly Li

