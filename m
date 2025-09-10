Return-Path: <linux-bcache+bounces-1203-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52CD4B51C8E
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Sep 2025 17:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FDC717FA9D
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Sep 2025 15:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 969BC311C11;
	Wed, 10 Sep 2025 15:54:52 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA2A25B1C7
	for <linux-bcache@vger.kernel.org>; Wed, 10 Sep 2025 15:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.187.191.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757519692; cv=none; b=iZJTnzOejwuxvScVC4nbroGujkmWCGd8CVWsXb296byPDvgUBSDOwW2MNhn3AKJ5pGEkJPk5mWt+P8pqd4Xc8n6LqghPNPKvLf0zO1YK11n36EAqD0HG9ZnarVfaS028BMqzdFkHqzESxRVS2NL3dIFnnFbTWL+NBgOifIwQCJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757519692; c=relaxed/simple;
	bh=k+xOMZFfU/VJnVd+TdCv7o9OiJw6H0N6VolCuwOuTl0=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=S/DKiU/PAGEo6uVZ76T8gxi8YwrqqbMiQ2dKWN0NDKCVXaiJAhSJc5EgkcZAeHQzcsUxFsbOd4yNVNyg8sh0JzohGRWiOlhRxFIw9ChhzJadvtSHLmGjEwvj6Xo8m0EnD2so/VDinGegGdnXl8MsDBmd/XomEbI7ZVaXMZJ397I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=esperi.org.uk; spf=pass smtp.mailfrom=esperi.org.uk; arc=none smtp.client-ip=81.187.191.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=esperi.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=esperi.org.uk
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
	by mail.esperi.org.uk (8.17.2/8.17.2) with ESMTPS id 58AFsc2w019076
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 10 Sep 2025 16:54:38 +0100
From: Nix <nix@esperi.org.uk>
To: Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org
Subject: Re: gen wraparound warning: is this a problem?
References: <87a536e3b5.fsf@esperi.org.uk>
	<C155231F-E439-46E5-8AFE-502CB75F183C@coly.li>
Emacs: indefensible, reprehensible, and fully extensible.
Date: Wed, 10 Sep 2025 16:54:38 +0100
In-Reply-To: <C155231F-E439-46E5-8AFE-502CB75F183C@coly.li> (Coly Li's message
	of "Mon, 8 Sep 2025 14:51:41 +0800")
Message-ID: <871poecngh.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.3 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-DCC--Metrics: loom 1102; Body=2 Fuz1=2 Fuz2=2 rep=57%

On 8 Sep 2025, Coly Li verbalised:

>> 2025=E5=B9=B49=E6=9C=887=E6=97=A5 22:37=EF=BC=8CNix <nix@esperi.org.uk> =
=E5=86=99=E9=81=93=EF=BC=9A
>>=20
>> So, out of the blue, I just got this for my long-standing writearound
>> bcache setup (which covers my rootfs and $HOME, so I kind of care that
>> it keeps working):

(Oh, this is kernel 6.15.6 -- but that's only since Jul 20th. Before
that, I was running 5.16.19 right back to April 2022, yes, I know... so
it's possible this wasn't touched by *5.16* and thus this is a bug that
was fixed long ago.)

>> These both map to this in bch_inc_gen():
>>=20
>>     WARN_ON_ONCE(ca->set->need_gc > BUCKET_GC_GEN_MAX);
>
> It seems a bucket has not been touched by garbage collection for a long t=
ime.

Not too surprising: half-terabyte cache, and the xfs filesystems it
backs only has 1.5TiB of data on it and not all of it is accessed
frequently, and some is bypassed... so it can take a long time to gc
through the entire cache :) it took months just to fill it.

>> Is this something the admin needs to do something about? (And, if it's
>> not and bcache recovers smoothly, as so far it seems to -- though I
>> haven't tried to remount it since the warning -- why do we warn about
>> it at all?)
>
> I don=E2=80=99t know why this bucket is not touched by GC for such a long
> time. It should not happen in my expectation.

It's possible that *no* buckets were touched for a long time.

> To make sure everything is safe, I would suggest to writeback all the
> dirty datas into backing device, detach the cache device, re-make the
> cache device and attach backing device to it again.

There is no dirty data (writethrough cache)... and this is backing the
rootfs, among other things, so IIRC detaching is quite difficult and
panic-prone to do (it's been many years, but I believe you can't do it
while mounted?). I'll schedule it for the next reboot...

