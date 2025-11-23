Return-Path: <linux-bcache+bounces-1260-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD7AC7DB2C
	for <lists+linux-bcache@lfdr.de>; Sun, 23 Nov 2025 04:14:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2305C350FAF
	for <lists+linux-bcache@lfdr.de>; Sun, 23 Nov 2025 03:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF28218AA0;
	Sun, 23 Nov 2025 03:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kx9RzuA6"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD0F1EDA3C
	for <linux-bcache@vger.kernel.org>; Sun, 23 Nov 2025 03:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763867691; cv=none; b=MK/qgplOuYSvufsugzNXUs7QIHJQNy4ZLFBs9VtkzxankauHqGKNeTsO1nwyzWZjMh4272aJ8e22emLBbTmsPqrofiCgJdlAHgkZ3EXHmgZWTAKx94lupMJlMTVyJcx42UJ0m4qyY3kB6RT8JVhCr/TT9YX/o1Z5a6v0qjfsri8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763867691; c=relaxed/simple;
	bh=nRs19Xsq1ucV508Y+KpD0MmfKZJfnRugxP+r8Pey/Ow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CE+ptbdCH832Ud1AMQFtgLaUiwioC4q3qLBEpkhUUdfbeyTDVkZydgrr05nXt9bc5I75yEJHBWTq2eXRXRKR6d/Xv/mDYi8UdcpCKrtZnbHw64CC15sdohpwOlEIc7oKyJASe+h5xRl+NFLYG9cMk/eOFDqI5K5dG9beBdfrrJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kx9RzuA6; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso44769531cf.0
        for <linux-bcache@vger.kernel.org>; Sat, 22 Nov 2025 19:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763867688; x=1764472488; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sSUmOlF3E259ASbJ7NKM/1Z38SFWeY0yp8l6jgM+Ktg=;
        b=Kx9RzuA6o7L5/regvp7GCHsXfXPn7NCcqo3aCBfPl4hiu7fwebLSYvsKKUY0KVQ+Ie
         ICT83rwOpf9TiDzPvgQ1GfYd8DusVNTqbwZV0JzVcMGs5HhK695wRZ70sm6flScHvlUf
         UgMlWhuZgWhMBY7jpYWFjd6yD8RdoSY8F4A1HGTC2s5msh57a5g9dSWMFxo0k6jcWr95
         hv7A0qDPp/C3mXlb/sql77oWRBnQERTwG1bAsDL8leZW7jWFhBjiqCBF5lRshOiV4mpS
         Es9nKtAQ6+uTDUyBSccyKYpywg44qPu0ahwgWWpJsaebiWg6LTeuCoW1dBUJHNxB3/Yw
         AwOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763867688; x=1764472488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sSUmOlF3E259ASbJ7NKM/1Z38SFWeY0yp8l6jgM+Ktg=;
        b=uuUIx37hQGvIAvhn2CGYkVJ4dp1tIHW8HIz6Zk6ghRexp2lDrzq0Mup9mynf2lZO7b
         rqf13a9wiAvo9ta7SgtA5/1ZmIhMIRAACv7j3aNZ9jHaBzmKaXoyBr2g/pP+1sOm7swK
         jVz+fOCpG4McPxKhMSklWsl8Y0dlvVaOTCLC/aCy8TKLgbZ/HR/uRwK0n4Tf43DYbQyk
         6P2OSXAZDOTGXYj6gyvehOhCzjymkyoMt0bqWUuPJSAlMd0nv25VBaGTPM9GtGd50siQ
         6/e0e3vMrmyPR/o7kgvz+doBWh/T2q89ScRoLfrwRRp4LJOXYFx/Yn+dsnfdvGJ97KRs
         IRpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEIqHSa3a3VEIkGXT+yPw6tl4Wb6vGqGYNO2NHvl4qScWV6BRQ8faYbSltEPOdxfmY5y99bB+bwNP8+ic=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaVWoW0+ISgEIbfCax5hE4c7+O8YTiVvrtGgNMnjaIvexUN5gr
	9YenYjIclq4Wmh7lfgH6xNeMm/ohFvATdUozcaf/d+mYjCeYWaoUntMkmX3TEwypnhfah3+ieDQ
	TZ6N/cYTucwU0RzDZ6wZgmaB4HUrmtL/UVDQDsQ0=
X-Gm-Gg: ASbGncumTCmKWumn8ePvALh9xl47MYWpfFewrW/C5rZ6ERWxEUE7D3W7J5QezdULiiG
	Rnu8BRes7Q8Vl92YpJAreLCIIL7yFk6wn0sjzSpxODhttwgsjvkc2xEE55ql58+6AS6Ht3lXgkE
	NhS7DuI1dHwId9CNwpOzCk6G2JL7KbMGK+kn+cjqtZSugIode+sNjIpTD/jnf8aiGOJMdzvWeDh
	lu75Yb/qTjmMnl+sXKa9h6J5EQZ2sKEuOn6aMYQY1CYk/b65JwpBZmw0v6KP89Mqvf0TcE=
X-Google-Smtp-Source: AGHT+IGdga/kzhdwCVG7yVfSoR3Y4Mpj0tXp1Phothz1pnN4zZDpqFPu9X4DmFfSbiDItMnyiKDLP9Ui4prcpSBpeyE=
X-Received: by 2002:a05:622a:409:b0:4ec:ef62:8c81 with SMTP id
 d75a77b69052e-4ee588cb739mr81789031cf.47.1763867688428; Sat, 22 Nov 2025
 19:14:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSEvg8z9qxSwJmZn@fedora> <CANubcdULTQo5jF7hGSWFqXw6v5DhEg=316iFNipMbsyz64aneg@mail.gmail.com>
 <aSGmBAP0BA_2D3Po@fedora> <CAHc6FU7+riVQBX7L2uk64A355rF+DfQ6xhP425ruQ76d_SDPGA@mail.gmail.com>
In-Reply-To: <CAHc6FU7+riVQBX7L2uk64A355rF+DfQ6xhP425ruQ76d_SDPGA@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sun, 23 Nov 2025 11:14:12 +0800
X-Gm-Features: AWmQ_bkhV3WFHcWH6ezrZh5TyYLHctF2XYDfyBPe3dT3HiPXGugPAFouComClV0
Message-ID: <CANubcdXOZvW9HjG4NA0DUWjKDbG4SspFnEih_RyobpFPXn2jWQ@mail.gmail.com>
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain Handling
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	zhangshida@kylinos.cn, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=88=
22=E6=97=A5=E5=91=A8=E5=85=AD 22:57=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Nov 22, 2025 at 1:07=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wr=
ote:
> > > static void bio_chain_endio(struct bio *bio)
> > > {
> > >         bio_endio(__bio_chain_endio(bio));
> > > }
> >
> > bio_chain_endio() never gets called really, which can be thought as `fl=
ag`,
>
> That's probably where this stops being relevant for the problem
> reported by Stephen Zhang.
>
> > and it should have been defined as `WARN_ON_ONCE(1);` for not confusing=
 people.
>
> But shouldn't bio_chain_endio() still be fixed to do the right thing
> if called directly, or alternatively, just BUG()? Warning and still
> doing the wrong thing seems a bit bizarre.
>
> I also see direct bi_end_io calls in erofs_fileio_ki_complete(),
> erofs_fscache_bio_endio(), and erofs_fscache_submit_bio(), so those
> are at least confusing.
>
> Thanks,
> Andreas
>

Thank you, Ming and Andreas, for the detailed explanation. I will
remember to add the `WARN()`/`BUG()` macros in `bio_chain_endio()`.

Following that discussion, I have identified a similar and suspicious
call in the
bcache driver.

Location:`drivers/md/bcache/request.c`
```c
static void detached_dev_do_request(struct bcache_device *d, struct bio *bi=
o,
                                    struct block_device *orig_bdev,
unsigned long start_time)
{
    struct detached_dev_io_private *ddip;
    struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);

    /*
     * no need to call closure_get(&dc->disk.cl),
     * because upper layer had already opened bcache device,
     * which would call closure_get(&dc->disk.cl)
     */
    ddip =3D kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
    if (!ddip) {
        bio->bi_status =3D BLK_STS_RESOURCE;
        bio->bi_end_io(bio); // <-- POTENTIAL ISSUE
        return;
    }
    // ...
}
```
Scenario Description:
1.  A chained bio is created in the block layer.
2.  This bio is intercepted by the bcache layer to be routed to the appropr=
iate
backing disk.
3.  The code path determines that the backing device is in a detached state=
,
leading to a call to `detached_dev_do_request()` to handle the I/O.
4.  The memory allocation for the `ddip` structure fails.
5.  In the error path, the function directly invokes `bio->bi_end_io(bio)`.

The Problem:
For a bio that is part of a chain, the `bi_end_io` function is likely set t=
o
`bio_chain_endio`. Directly calling it in this context would corrupt the
`bi_remaining` reference count, exactly as described in our previous
discussion.

Is it  a valid theoretical scenario?

And there is another call:
```
static void detached_dev_end_io(struct bio *bio)
{
        struct detached_dev_io_private *ddip;

        ddip =3D bio->bi_private;
        bio->bi_end_io =3D ddip->bi_end_io;
        bio->bi_private =3D ddip->bi_private;

        /* Count on the bcache device */
        bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);

        if (bio->bi_status) {
                struct cached_dev *dc =3D container_of(ddip->d,
                                                     struct cached_dev, dis=
k);
                /* should count I/O error for backing device here */
                bch_count_backing_io_errors(dc, bio);
        }

        kfree(ddip);
        bio->bi_end_io(bio);
}
```

Would you mind me adding the bcache to the talk?
[Adding the bcache list to the CC]

Thanks,
Shida

