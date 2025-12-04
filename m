Return-Path: <linux-bcache+bounces-1335-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D3F0CA3853
	for <lists+linux-bcache@lfdr.de>; Thu, 04 Dec 2025 13:01:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E22A830088CC
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Dec 2025 12:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36B533CEBB;
	Thu,  4 Dec 2025 12:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fsuKlQ2Q";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="T5DscVMW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3741328CF5F
	for <linux-bcache@vger.kernel.org>; Thu,  4 Dec 2025 12:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764849699; cv=none; b=bIUP2qo6iaTnlkZzNY+kQc+jTkJjsfELIwumbpRYwz3HMIWAGO6pFQaLXmpBkNRGRCsUUDVZ9NZTPydzxqJx9LQ5eDSvJAWHoSYOiwfH7vaUS6EbcUPUt6L4JlP7/B33T7uIsKVlmcQvCd21m/T7cx2OhCLJvx7fkDPTvUEwf5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764849699; c=relaxed/simple;
	bh=jfW3CAdoNFhx7g5U+wQ9khjTbrglS97Ej8qTjjG7s9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bL17DlyocDPVsTCo8PGb8xbBdVExyNCrpeFRQt8cEiQ327BcsVBjERkHeWWFcLMymJzDi04+opRXhHqnjtZPaAYeC2ywtgR4CR/49VDnRqtjtbikw2KEki0NPRoTJEJCGV9E/Py73o1k2qXPBYB/BZL6BzVj5q+xRloQPIvlG6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fsuKlQ2Q; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=T5DscVMW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764849696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4w3WmoGnO9uNBLR38zg+Zkk86Y4/BqjKKfkk0t4Vczc=;
	b=fsuKlQ2QOKvm8Uva37ggGykUnbh23s0dGmwqZ9mxyUFYlEO/l9gblWdK7wyRnpq81Pz5l2
	SoRwEPJspqwl/GZ/tiE7bEe1NWKfEBBdDFC1fMQSKFdshB/2FonVdCfF+8wpaG8h3wVZf8
	KZq/2/lnCtsJi1r6n/4+tD35xMD2sKQ=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-MQScfK_0Ovy27FFzwsJmrQ-1; Thu, 04 Dec 2025 07:01:34 -0500
X-MC-Unique: MQScfK_0Ovy27FFzwsJmrQ-1
X-Mimecast-MFC-AGG-ID: MQScfK_0Ovy27FFzwsJmrQ_1764849693
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-78933e02c1bso18905047b3.0
        for <linux-bcache@vger.kernel.org>; Thu, 04 Dec 2025 04:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764849693; x=1765454493; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4w3WmoGnO9uNBLR38zg+Zkk86Y4/BqjKKfkk0t4Vczc=;
        b=T5DscVMWvSK0bN2NNoAiZ3GvhvXD7u8mDkQPshPaBFJLHc3Go71PCO5ThUrReBfOKO
         aRLgGebac7Rq0snJabxBUKo0w/S71IF+taB2w1wLhiqSpQYnoi5dLQbjVQ5G4CcWIcxy
         QLKJFfKvHyk+F8Kb9QkIbZl66Q9+tYpyAXQKvbiC9Fh9Q39mn03ZdeSTp4W6mUJn3yXG
         EOZbfjh9aD46GNXyXH+iqV05qP4de3JYbgEr/2IKEx4vf9rf1qP+YCvGrbBman0sNP48
         Kr7jktJSmO4oPBf5l+fat+bXtqZjD3Divap79owv+t+g+TqSYUr8k3NYUNd3fnPyaulp
         59XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764849693; x=1765454493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4w3WmoGnO9uNBLR38zg+Zkk86Y4/BqjKKfkk0t4Vczc=;
        b=UtqQVkaYL/ysQ2A7/FnhTozFgEjPSANvNuxJw4qRgOUbIGoHQgirUDhI2AsZ3NHtwq
         NlEuE2r9PxbUKy1Ro7jClrwvl1oAVZHsPDfPqJdOje5A4vedLFqKtNFVCzkFz7zUG/Dg
         eVoxzvkGaFKIw30qwKzHKPRvqj+awJ8ObifeqIOxwLjHE2mgFLwD3/wGGsWj28mRKJR1
         JKeCh81CwM+u6ffslXoUYemVo/gqGa/AGlrJp69hfRcFj2OFguHihcKDT0g5CCOEconN
         fJZJKabFPIPD2W+vt0Fkz/sRv7pM9v2EwmW2m2Z+TW40spvDMg7fMxJwIkZaK/j9Z9di
         wd3A==
X-Forwarded-Encrypted: i=1; AJvYcCV2M3/oP06RMljnfdw+zxZVMs3NErR2Mxe7vbV28G3rrqh1QisF5Dj5vieH+uMgSvA0A/iA8D86N6CexIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj8KlCkD0YmaumL1UetAlLuFeHxq2opWqm5G/9NcdUCLTcbk2U
	4aqGvMKz3AJsNRwqgkfR2h7qezFUBRq6DR2LnKtqE5/P+FlHTh93uKGNOvHUcf3M3fwOIelaZ0w
	e7s3dvXObWuevSVeM+P36R9sj4H2O/MykOaIVGd84KwwhT2TZ9gtGaxp5bog2A6Qr/xNOczi9Qm
	kArMB4uhn90AbYjidwvF60gYDXPijBwladPj2rLUI1
X-Gm-Gg: ASbGncsMWvRp17S/zrCi8ePLvRXk8fV8FgbzoeJtqOtUi8/AXHqW6ALMLXoWNdvG+gV
	L/DfSTFco9cP0Ky21J5u0BxM+t4NygBZGUL29ScA6G4DUOzaVRdvxHccpRkTIhWO67KqPmCxpsS
	V9KuyZcu0xCplBp7gRbvZ360CSDRpfVvsnVnbMvYvLNWnpjK154M0wPYf4bBEvUfl2
X-Received: by 2002:a05:690c:504a:b0:787:badd:4f with SMTP id 00721157ae682-78c1722b4bfmr20313657b3.17.1764849693137;
        Thu, 04 Dec 2025 04:01:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECdpcnjc0lAQwOjPPPzwOAafG6NKyAqopWgJDmxmT/Iy5U0V5ol27YWd3IGZz+VTw9fsJzVSzhHaKlfGp2CGM=
X-Received: by 2002:a05:690c:504a:b0:787:badd:4f with SMTP id
 00721157ae682-78c1722b4bfmr20313437b3.17.1764849692674; Thu, 04 Dec 2025
 04:01:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204024748.3052502-1-zhangshida@kylinos.cn> <20251204024748.3052502-4-zhangshida@kylinos.cn>
In-Reply-To: <20251204024748.3052502-4-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 4 Dec 2025 13:01:21 +0100
X-Gm-Features: AWmQ_bnMxnSWxa4TOwlYcetyoBXMw8mhTKeVlnUY9cELTHjuJ_ctIxyXqc-JRwE
Message-ID: <CAHc6FU5KQBpJOWcx0uiE1U5vJoON147wFMUn0oWzUmzSQajirw@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] block: prevent race condition on bi_status in __bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	hsiangkao@linux.alibaba.com, csander@purestorage.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 3:48=E2=80=AFAM zhangshida <starzhangzsd@gmail.com> =
wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Andreas point out that multiple completions can race setting
> bi_status.

What I've actually  pointed out is that the '!parent->bi_status' check
in this statement is an unnecessary optimization that can be removed.
But this is not what this discussion is mainly about anymore.

In the current code, multiple completions can race setting bi_status,
but that is fine as long as bi_status is never set to 0 during bio
completion. The effect is that when there are multiple errors, the
bi_error field of the final bio will eventually be set to an error
code, but we don't know which error code will win. This all works
correctly today, and there is no race to fix because the race is
intentional.

> If __bio_chain_endio() is called concurrently from multiple threads
> accessing the same parent bio, it should use WRITE_ONCE()/READ_ONCE()
> to access parent->bi_status and avoid data races.
>
> On x86 and ARM, these macros compile to the same instruction as a
> normal write, but they may be required on other architectures to
> prevent tearing, and to ensure the compiler does not add or remove
> memory accesses under the assumption that the values are not accessed
> concurrently.

WRITE_ONCE() and READ_ONCE() also prevent the compiler from reordering
operations. Even when the compiler doesn't seem to do anything nasty
at the moment, it would probably still be worthwhile to use
WRITE_ONCE() for setting bi_status throughout the code. But that's
beyond the scope of this patch, and it calls for more than a global
search and replace job.

> Adopting a cmpxchg approach, as used in other code paths, resolves all
> these issues, as suggested by Christoph.

No, the cmpxchg() doesn't actually achieve anything, it only makes
things worse. For example, when there is an A -> B chain, we can end
up with the following sequence of events:

  - A fails, sets A->bi_status, and calls bio_endio(A).
  - B->status is still 0, so bio_endio(A) sets B->bi_status to A->bi_status=
.
  - B fails and sets B->bi_status, OVERRIDING the value of A->bi_status.
  - bio_endio(B) calls B->bi_end_io().

Things get worse in an A -> B -> C chain, but I've already mentioned
that earlier in this thread.

So again, the cmpxchg() is unnecessary, but it is also harmless
because it suggests that there is some form of synchronization that
doesn't exist. The btrfs code that the cmpxchg() was taken from seems
to implement actual first-failure-wins semantics, but this patch does
not.

The underlying question here is whether we want to change things so
that bi_status is set to the first error that occurs (probably first
in time, not first in the chain). If that is the goal, then we should
be explicit about it. Right now, I don't see the need.

Thanks,
Andreas

> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index cfb751dfcf5..51b57f9d8bd 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -314,8 +314,9 @@ static struct bio *__bio_chain_endio(struct bio *bio)
>  {
>         struct bio *parent =3D bio->bi_private;
>
> -       if (bio->bi_status && !parent->bi_status)
> -               parent->bi_status =3D bio->bi_status;
> +       if (bio->bi_status)
> +               cmpxchg(&parent->bi_status, 0, bio->bi_status);
> +
>         bio_put(bio);
>         return parent;
>  }
> --
> 2.34.1
>


