Return-Path: <linux-bcache+bounces-1336-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C882CA65A4
	for <lists+linux-bcache@lfdr.de>; Fri, 05 Dec 2025 08:17:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C75A33140C6A
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Dec 2025 07:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2548A2FB99F;
	Fri,  5 Dec 2025 07:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QdiGj0Zs"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64E72F83C1
	for <linux-bcache@vger.kernel.org>; Fri,  5 Dec 2025 07:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764918829; cv=none; b=ERPhNBqTiLdXFpV5NmlLAgXh3X48755nYBL/mj19NZhqF0kkTQYKe1uAioc2PZ5kaRgu/NiphGXNLZw9EK2SbG9S6qGTbj1UoDumAVgSUL0OodjUOEFcJcdmBSnqRSeffuY9zzpTaLVtVacEns+8upiyynL05pGRPAIrO9GSkCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764918829; c=relaxed/simple;
	bh=Pwy8IpSMRvV4pLYbOFuG1E10Sbp1P4ndJix3SkClrEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kRKaz4DlSElLpVK7tQNUlMgB/e/75vPP503GPjHC6sw3S+DVA+MoCoMYPzTN/KM+Wola00J63ZUQ4NwvdNxRT3bvCLZ0zFUiGyQRZ0Wtc0pOnBDZjgsBoFREofF0PpzPhy4cc2+LM5vxkFePYIjSXhHLMB7/8CRo64Tf6v/ZR+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QdiGj0Zs; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee14ba3d9cso16657281cf.1
        for <linux-bcache@vger.kernel.org>; Thu, 04 Dec 2025 23:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764918825; x=1765523625; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZZsthjM36AzHfzJRPv+fucYmlyEL9uQqlbDBpqCCaLU=;
        b=QdiGj0Zsubu18EeDMdJMOc0rVl8qh588fVqBx4OqCAaJweWObgWjqkiVjS+uQxqBu4
         oZsntiEqSqKoloiwI3yGO0pcKeGfYSFSRWIlULTYOdLlOVik4U5luPzwweRqJCxvHHdP
         0a2c6mK5CQ16EQQevgGm5tdW8FFxG5XK8L0Aj8VGXS0SUlAdFanRgxR8BQZMoaiXBV/6
         LDwCTEG0W5pUwhgLCX8fM4bkvemFDaD5RKfVxZxQK6z1Zs1volK6++tlOqHYp/UQl9is
         hsFjkl8w4KXKGdOC9CneYFvkZ1zUHGdXfan6ZyEdypmqHDXAquisqQ+KdLZFMSckZ9xt
         5EVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764918825; x=1765523625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZZsthjM36AzHfzJRPv+fucYmlyEL9uQqlbDBpqCCaLU=;
        b=OQXR751OwwLXcQ+aDjewCeo5iqmwtvH0w95fNWGzgPSxqt28RRT+jR2xNruLb9e4YM
         l4680zNi06Ok+zXWPiSjEUK4wEDEFv2qqfA3yrQ25ckt0z4JgTYJ4HeTjFo8XZJmmpdL
         tUN4F/LqBv3gODRxN+Dy+gV8ttaCqBAXYOAZMnowjBlNJe57zVcUHlJ841LwoTjNN4fY
         KmYOfL0BVMK+1foErnkWacv5ocgvAYBg/tRuFlbE9yBB95BxHnBLIFiqjwpB1KlteKm/
         SWGfDCjqekLPbM7dVZbVEQeTOUWpDW7meQrAkOSQ7uQDwg5fvunX3MS3ZE3kU1SqqqsR
         6XQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqE1ncK46YDtUHo1rz27ftHiCMgSJinSV5+3Rq8CYBWCIO8JVhC2gopRX/C25OF/eGiG9mMvACsxLXPjo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4z1Dj0ylpVcCIQM5RMeIhkqI9FYSGnHS1kuoJCsT7MWXX67wL
	bNYHnios+bZXlGHrs2Y3HdRsqKZmq8OcBqSUnAQHCWKwpt2TKC6imbJKOPWOkdQc/1JrdfFaLrU
	/znHfKmizLA+wAVuaJENcJSJt10KgVOQ=
X-Gm-Gg: ASbGncur1iTOaMpEKjW8ZUtzAIqJSjTOHZ5N9dAUNwQk0xFL0Yx59hl88uSFlKmnPcg
	BlyYe/s+a+aKDp19hrSXd7cisD3/0CPQNnwU4XyvjKvflQ9mOc+kkr9bS8C+tiVUMKzxv/iI+p5
	JRHvyteL7e5anfTOP3dWAdnaxkidTXTF1NeA5nJVQS5T6fn9fTyHN3pvyHy43IAJPRybEHF0fuN
	CdIiHF5OlPs2011ZfPSmPQtDND5bKOyP+YKp0jaNbV8qr5IxbdmvQ0983amwQmiNK8nRmg=
X-Google-Smtp-Source: AGHT+IHJYWyI1mjiCTADN5mDPLjPn3O9aCgQQv/47u89Ok6QQjz9aaYuj5efWq8w321nH+Wx4kCBL9g4Yv4MqXDmCBE=
X-Received: by 2002:a05:622a:50a:b0:4ed:8264:9199 with SMTP id
 d75a77b69052e-4f01765302bmr128016701cf.67.1764918825449; Thu, 04 Dec 2025
 23:13:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204024748.3052502-1-zhangshida@kylinos.cn>
 <20251204024748.3052502-4-zhangshida@kylinos.cn> <CAHc6FU5KQBpJOWcx0uiE1U5vJoON147wFMUn0oWzUmzSQajirw@mail.gmail.com>
In-Reply-To: <CAHc6FU5KQBpJOWcx0uiE1U5vJoON147wFMUn0oWzUmzSQajirw@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 5 Dec 2025 15:13:09 +0800
X-Gm-Features: AWmQ_bmJlyuWuTYYPV6iO6_S52PTzlNhO3cILZ9KpXHKGaOmepcVIhpJGge9aIk
Message-ID: <CANubcdVgSO1RwAU+mp5AguaZk78SqrBRS-eWbgz1mNLs7JA_uA@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] block: prevent race condition on bi_status in __bio_chain_endio
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	hsiangkao@linux.alibaba.com, csander@purestorage.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=88=
4=E6=97=A5=E5=91=A8=E5=9B=9B 20:01=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Dec 4, 2025 at 3:48=E2=80=AFAM zhangshida <starzhangzsd@gmail.com=
> wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Andreas point out that multiple completions can race setting
> > bi_status.
>
> What I've actually  pointed out is that the '!parent->bi_status' check
> in this statement is an unnecessary optimization that can be removed.
> But this is not what this discussion is mainly about anymore.
>
> In the current code, multiple completions can race setting bi_status,
> but that is fine as long as bi_status is never set to 0 during bio
> completion. The effect is that when there are multiple errors, the
> bi_error field of the final bio will eventually be set to an error
> code, but we don't know which error code will win. This all works
> correctly today, and there is no race to fix because the race is
> intentional.
>
> > If __bio_chain_endio() is called concurrently from multiple threads
> > accessing the same parent bio, it should use WRITE_ONCE()/READ_ONCE()
> > to access parent->bi_status and avoid data races.
> >
> > On x86 and ARM, these macros compile to the same instruction as a
> > normal write, but they may be required on other architectures to
> > prevent tearing, and to ensure the compiler does not add or remove
> > memory accesses under the assumption that the values are not accessed
> > concurrently.
>
> WRITE_ONCE() and READ_ONCE() also prevent the compiler from reordering
> operations. Even when the compiler doesn't seem to do anything nasty
> at the moment, it would probably still be worthwhile to use
> WRITE_ONCE() for setting bi_status throughout the code. But that's
> beyond the scope of this patch, and it calls for more than a global
> search and replace job.
>
> > Adopting a cmpxchg approach, as used in other code paths, resolves all
> > these issues, as suggested by Christoph.
>
> No, the cmpxchg() doesn't actually achieve anything, it only makes
> things worse. For example, when there is an A -> B chain, we can end
> up with the following sequence of events:
>
>   - A fails, sets A->bi_status, and calls bio_endio(A).
>   - B->status is still 0, so bio_endio(A) sets B->bi_status to A->bi_stat=
us.
>   - B fails and sets B->bi_status, OVERRIDING the value of A->bi_status.
>   - bio_endio(B) calls B->bi_end_io().
>
> Things get worse in an A -> B -> C chain, but I've already mentioned
> that earlier in this thread.
>
> So again, the cmpxchg() is unnecessary, but it is also harmless
> because it suggests that there is some form of synchronization that
> doesn't exist. The btrfs code that the cmpxchg() was taken from seems
> to implement actual first-failure-wins semantics, but this patch does
> not.
>
> The underlying question here is whether we want to change things so
> that bi_status is set to the first error that occurs (probably first
> in time, not first in the chain). If that is the goal, then we should
> be explicit about it. Right now, I don't see the need.
>

Thank you for the thorough discussion on this matter. Based on my
understanding, there appear to be two main viewpoints:

Side 1 (S1) argues:
A. Using cmpxchg() addresses all the issues that
READ_ONCE()/WRITE_ONCE() can solve. That said, cmpxchg()
appears to provide a comprehensive solution.
B. While cmpxchg() introduces some additional overhead, this may not
be significant since it occurs in a slow error-handling path.
Or nondeterministic order of overriding, Which is not a problem.

Side 2 (S2) argues:
A. While READ_ONCE()/WRITE_ONCE()-style protections may be
needed, addressing them in this specific patch may not be appropriate.
B. The cmpxchg() approach adds unnecessary complexity without clear
benefits.

The trade-off between S1B and S2B seems somewhat balanced, with
no clear winner.
However, regarding S1A versus S2A, I wonder:

If we agree that READ_ONCE()/WRITE_ONCE() protections are required
here, is there a specific reason we couldn't address just this code snippet
in this patch? We could then follow the S1 approach and use cmpxchg().

However, If this change remains controversial, I'd be happy to drop it and
resend v6 without this modification.

Thanks,
Shida





> Thanks,
> Andreas
>
> > Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  block/bio.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index cfb751dfcf5..51b57f9d8bd 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -314,8 +314,9 @@ static struct bio *__bio_chain_endio(struct bio *bi=
o)
> >  {
> >         struct bio *parent =3D bio->bi_private;
> >
> > -       if (bio->bi_status && !parent->bi_status)
> > -               parent->bi_status =3D bio->bi_status;
> > +       if (bio->bi_status)
> > +               cmpxchg(&parent->bi_status, 0, bio->bi_status);
> > +
> >         bio_put(bio);
> >         return parent;
> >  }
> > --
> > 2.34.1
> >
>

