Return-Path: <linux-bcache+bounces-1321-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75604C9D05B
	for <lists+linux-bcache@lfdr.de>; Tue, 02 Dec 2025 22:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BFDF3A93B0
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Dec 2025 21:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726B72F60A7;
	Tue,  2 Dec 2025 21:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pd8ELGu2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aut8n+bn"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3682D47F3
	for <linux-bcache@vger.kernel.org>; Tue,  2 Dec 2025 21:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764710135; cv=none; b=c/507NMNOlblXPa7zxIyuoRtGWI3VIOBT560N0XEHliZnFnQb5wdtWdKvl7wSrDJvVGrTcFpSl+w7rNzxsA1MySdbnUKXnrx6fELpAHPwSUDZOrJGmBZgF+YGfctyrf2S42d7dTt+2BFPG5/EEHAo5znUm3b1kK7EQKnfO4rNnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764710135; c=relaxed/simple;
	bh=hSJAG6LqPOB7r60cQCXbOcqgiTCj34wNVnz/GzFCNiQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H5ziSCQd+7Y5j3uYIec24oQjpY/GuS3kGtOMfO2dIjHhHjyNT02s70FlQ8sHpJ53ev4SuysqweLGXadOTS0RJ5shEv0nh3KhnKESJWxGkV/qgTPLHsmPVSk3utZNfLARF9cJkPn0O3iduYKrv29PJoyWw3YiVu/4DKZ02XBeQSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pd8ELGu2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aut8n+bn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764710132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lpUIvQ+034yOcee5egVJA2ANWXFdHSKuoF2BHUlEcog=;
	b=Pd8ELGu2ynTPDToZs9H/MRl62zczIJa7dFvmeYdntOKWzTln2Ilk5t2ePc3knvZ/0WrVGW
	AyV7wQZU0HDOqdzxfjxLxpuQf/9vbeFUC0HkKKCwdYIoBpTYpslpwE89SBP7/ahM2lVDyE
	WqZGSXD9zEbtaEEg5zOsAuQ9xc1QgY4=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-TiEhMxKlMQmfnxFrto-vcQ-1; Tue, 02 Dec 2025 16:15:31 -0500
X-MC-Unique: TiEhMxKlMQmfnxFrto-vcQ-1
X-Mimecast-MFC-AGG-ID: TiEhMxKlMQmfnxFrto-vcQ_1764710131
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-643301710efso3883618d50.0
        for <linux-bcache@vger.kernel.org>; Tue, 02 Dec 2025 13:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764710131; x=1765314931; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lpUIvQ+034yOcee5egVJA2ANWXFdHSKuoF2BHUlEcog=;
        b=aut8n+bnAkRyrn8IoCi9FpWAfue/G996S/zSj6u8JeIDMhzHVfWegm/qFWgvXEapRy
         C4hCn0BhQwhWIDVcmL7KtR22s2T1MK8Xv3+kWNRjDUAqJX/0EaTHrymQoNNlvvPoqak+
         +P7zDfC9lARkCurSqyB2KBlpHX8pWDqMJmclsvBmcxQoGzNkxSSnCkCtakD3DuCmkbUn
         vOnrwFEbC0ESsG98574XuJ8XOtlFyLr08YHJPksFO6NybXpRc/k5AEUgRpllsNpXNpj1
         hdmGOTVCKiTCtPs0ESQlhuq5wIhRnsZhhQt64nHTxKA3WtUucqKuRXv2QqfSd+LXdg/u
         KYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764710131; x=1765314931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lpUIvQ+034yOcee5egVJA2ANWXFdHSKuoF2BHUlEcog=;
        b=vtF1VW/oECG2Su4nQSUZlooPkBdKTCaj5guZ/3MlUa/CcLHgRhxk/P1qSSgGSsQWx6
         IupO6zEbKuFd1R8zO9YZoI8vRwSc3+ifjnTkqV0Zkqo62OR7xA2xD1aZOkn6IbZ4BfzP
         wIOHIC9MHQdplsqPPXnqJGV1999k8kHzXRW15OV9XRDkC/97kRFK3EWW42EadU7d+oRI
         HbWsiOSVG2u1L9K7pAZhP5L0uH16mK1lu6VS8E0aEhtMvq7nIm6xbwNh9NxEFc24Je9x
         lmAngtLU4ryVg8cpAxZpf4XqoZAotNtp7k8UZzxZf+yy2T6ZZs2X8si6cGtNpT0ms7Za
         dfyg==
X-Forwarded-Encrypted: i=1; AJvYcCUGRbpwsTjIfRPTl+/TZQxtwxs2YTSa/0dGeindirUSdf+FNQm0JEdlJy3fy15/RaD9sixe85hQB0ho/gQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3aoYF0CxMz5wmk7NcmIxMe+lOPoQ4rj88yUUl+RjW+Q4HWR05
	DY5f6Jz2Sjnkp1UXX3TAFkJ6YEzZEfLljDgBObrwIPWXNmUIMXiyaiLWI4rWrYmqmXW/3m02bhi
	D7TXOGOQqrN7CzzFbCi84I8tGqIi4/kT/036Gr+aTWcJ6KYl20fhzuU/CZtOqYxxdRAC2bf/vS2
	lE/LmviEzHFOOqw5cAqVpwy/qjzQQS75J9hzDIrrVv
X-Gm-Gg: ASbGncuitxPoCQZ+uG+GAkBGyORKBt9BmX7P+TCzMiXRL3+JPu3gzuTnnfMtLhzzCJa
	pFwhSpmMmE4LPrJWnesZvaQdFVj4s06Bl60DGIF73Re835zHr0nLr3IHKmKQeU1LuLnKO/BWzfN
	y5a6cS6g2EJtiLlhsnaQuBopOZFoYbtOmIBOW039xkMQe6Tr1yOipZifHWTkPoN+xd
X-Received: by 2002:a05:690e:1c19:b0:644:2e0f:4158 with SMTP id 956f58d0204a3-64436fb40bfmr157126d50.25.1764710130971;
        Tue, 02 Dec 2025 13:15:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFy28A6VJcPbVSh5fL1qoiSxgrGoPRFkJcOjOIvadzD/gFVkIqW6MfGx4MoJat0TQW6yn8VkhbElC9CtOOg+3w=
X-Received: by 2002:a05:690e:1c19:b0:644:2e0f:4158 with SMTP id
 956f58d0204a3-64436fb40bfmr157092d50.25.1764710130510; Tue, 02 Dec 2025
 13:15:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251201090442.2707362-1-zhangshida@kylinos.cn>
 <20251201090442.2707362-4-zhangshida@kylinos.cn> <CAHc6FU4o8Wv+6TQti4NZJRUQpGF9RWqiN9fO6j55p4xgysM_3g@mail.gmail.com>
 <aS17LOwklgbzNhJY@infradead.org> <CAHc6FU7k7vH5bJaM6Hk6rej77t4xijBESDeThdDe1yCOqogjtA@mail.gmail.com>
 <20251202054841.GC15524@lst.de>
In-Reply-To: <20251202054841.GC15524@lst.de>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 2 Dec 2025 22:15:19 +0100
X-Gm-Features: AWmQ_blB9WwRmpWnf-ymSCKQHeFw0T9WISk1loqMRlFNqqfSUUqLagqIZTqBuzc
Message-ID: <CAHc6FU6B6ip8e-+VXaAiPN+oqJTW2Tuoh0Vv-E96Baf2SSbt7w@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] block: prevent race condition on bi_status in __bio_chain_endio
To: Christoph Hellwig <hch@lst.de>
Cc: zhangshida <starzhangzsd@gmail.com>, Johannes.Thumshirn@wdc.com, ming.lei@redhat.com, 
	hsiangkao@linux.alibaba.com, csander@purestorage.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 6:48=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
> On Mon, Dec 01, 2025 at 02:07:07PM +0100, Andreas Gruenbacher wrote:
> > On Mon, Dec 1, 2025 at 12:25=E2=80=AFPM Christoph Hellwig <hch@infradea=
d.org> wrote:
> > > On Mon, Dec 01, 2025 at 11:22:32AM +0100, Andreas Gruenbacher wrote:
> > > > > -       if (bio->bi_status && !parent->bi_status)
> > > > > -               parent->bi_status =3D bio->bi_status;
> > > > > +       if (bio->bi_status)
> > > > > +               cmpxchg(&parent->bi_status, 0, bio->bi_status);
> > > >
> > > > Hmm. I don't think cmpxchg() actually is of any value here: for all
> > > > the chained bios, bi_status is initialized to 0, and it is only set
> > > > again (to a non-0 value) when a failure occurs. When there are
> > > > multiple failures, we only need to make sure that one of those
> > > > failures is eventually reported, but for that, a simple assignment =
is
> > > > enough here.
> > >
> > > A simple assignment doesn't guarantee atomicy.
> >
> > Well, we've already discussed that bi_status is a single byte and so
> > tearing won't be an issue. Otherwise, WRITE_ONCE() would still be
> > enough here.
>
> No.  At least older alpha can tear byte updates as they need a
> read-modify-write cycle.

I know this used to be a thing in the past, but to see that none of
that is relevant anymore today, have a look at where [*] quotes the
C11 standard:

        memory location
                either an object of scalar type, or a maximal sequence
                of adjacent bit-fields all having nonzero width

                NOTE 1: Two threads of execution can update and access
                separate memory locations without interfering with
                each other.

                NOTE 2: A bit-field and an adjacent non-bit-field member
                are in separate memory locations. The same applies
                to two bit-fields, if one is declared inside a nested
                structure declaration and the other is not, or if the two
                are separated by a zero-length bit-field declaration,
                or if they are separated by a non-bit-field member
                declaration. It is not safe to concurrently update two
                bit-fields in the same structure if all members declared
                between them are also bit-fields, no matter what the
                sizes of those intervening bit-fields happen to be.

[*] Documentation/memory-barriers.txt

> But even on normal x86 the check and the update would be racy.

There is no check and update (RMW), though. Quoting what I wrote
earlier in this thread:

On Mon, Dec 1, 2025 at 11:22=E2=80=AFAM Andreas Gruenbacher <agruenba@redha=
t.com> wrote:
> Hmm. I don't think cmpxchg() actually is of any value here: for all
> the chained bios, bi_status is initialized to 0, and it is only set
> again (to a non-0 value) when a failure occurs. When there are
> multiple failures, we only need to make sure that one of those
> failures is eventually reported, but for that, a simple assignment is
> enough here. The cmpxchg() won't guarantee that a specific error value
> will survive; it all still depends on the timing. The cmpxchg() only
> makes it look like something special is happening here with respect to
> ordering.

So with or without the cmpxchg(), if there are multiple errors, we
won't know which bi_status code will survive, but we do know that we
will end up with one of those error codes.

Andreas


