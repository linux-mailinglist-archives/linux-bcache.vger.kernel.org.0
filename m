Return-Path: <linux-bcache+bounces-1319-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74808C977FB
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 14:10:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BE613A1613
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 13:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0312330DD37;
	Mon,  1 Dec 2025 13:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CBr20oRY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="q6z6KB5Q"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3943D2F5A3D
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 13:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764594444; cv=none; b=gInBJ3KFXDtfY62a/ODYYQbkTLNK2t9zBewdgePGSZygSVJDoWPeRqvZVAby1fQyWPCF10MNjabTCHKtNEAnt+z8ZTTQyCoSFo63lKpk6702LDlh1MyIi9Ez/LqsBVhwPSMWCAZ22QpaXYSCQIizH78Ro7VHst4rqr1TYn8XK2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764594444; c=relaxed/simple;
	bh=4TpthFrcKq6ssOYA3fnVs/rr4i9ZL1kaJQAKh2YWwDo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MgD4NBqiw1TYnA5HTubRVrlCz8+6q3w34M0u+2yduSAWe/TMMaOhxJUMi3v5nvACyQlOpRTGjG6ldx+Rkh+76lypCOpGCXw0JT+1kRBG8y9vbgYz+Rk2O5+TNCChwymC5DTBZBhaAmlhum+iqpavr6BUh58D7YxN3ld1RBPFiyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CBr20oRY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=q6z6KB5Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764594442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GlTMWc0lSWfMGmCtqVPNzCqix8+u3BGSjIjRHo6O3xM=;
	b=CBr20oRY+tNjxRo/z6bv/WkhgaOeH6+0TfhPJomhehVgK13ZNI2aYHNXHk468voXINBWWT
	fasySjf2lEC0hdXB/9kIPlXUnJ+TRvukN2zk2S0V1GdreLncnJositih6FY/Us5rRHAuAD
	9zkDtow72wuWQlnddM8lAOlkE/14rio=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-Veh666WcNSecZYhXZLpbOg-1; Mon, 01 Dec 2025 08:07:21 -0500
X-MC-Unique: Veh666WcNSecZYhXZLpbOg-1
X-Mimecast-MFC-AGG-ID: Veh666WcNSecZYhXZLpbOg_1764594440
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-297fbfb4e53so62790135ad.1
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2025 05:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764594440; x=1765199240; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GlTMWc0lSWfMGmCtqVPNzCqix8+u3BGSjIjRHo6O3xM=;
        b=q6z6KB5Q2pkNxnSVcX5Dcz+/a0lrjkJaup+E3vpT2ihLZG839LlVyj1v92tns+5B0H
         WDUPi5kHwoj3j/9GVKMlKkqc57LcBfAPkW8NmpSI+fyJZB227Ok1MB62zSPn4GMxpVRv
         c/poUuLXQArlVUHquOAHZ7F3LcsHc44fO6C5ZhATXNL60fgZmxIi00fUXIe0jyDP1wBZ
         T2gz+6xkLVkoSlo+mh3RDmQ/0QGFSZRA78JiefocwOOe+tN6pkC0T9a500ziLd8JVZIc
         9paaiRQL96mHi8G8UIrXqQOzdCmLgZts3u6IexyMQUC9kcZRm8XXCoTZbqtjXTb7gXxE
         1pRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764594440; x=1765199240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GlTMWc0lSWfMGmCtqVPNzCqix8+u3BGSjIjRHo6O3xM=;
        b=Rd/kT1QIpfabGOqrR2ys9irMMpbTYs/nYAQMD8ofHAsCuLYdqizvEDojcw8YlhSdxv
         Vg7z7TJGgHI4aMokNlh75+bjSrDCtZL5NV4TO8NhmZhZGOg2H+O1SBd+pSD4ZUvl7+KM
         iBuZEZ/5Q3XEXKqNhPCtHDeYKFBoQldO9gEq8j1Ibr8ci2B8v1y6eJdGS53Jqd0BOS9z
         RypeqdN7EFfnjVZIsQt5z+y8iZ1wvgQJSl5/j+fBFc1SfFwqjxwsLEmUmqLNIoibKEG/
         6mbDz4oWAGfc81GEk3QAJbXYn8EPs6I0BYEn7r5S0m1pPLUp3hYHukm3ELcI6+qn+2uV
         ppQw==
X-Forwarded-Encrypted: i=1; AJvYcCU5CUYE9ZXFSJqbCAy6bf7MEW2SpH5sL3XhnMenJKJglKqVjzALh6vJK+S24nSMPNdg6l3NmkU+wwpeL24=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxow2429NPHNS5/JekqFYiwWCyxTXKnyokpYvoPxeLwJr8z+VG3
	p7IDqvsFL4h7QurobePtoL2Hp3xjyZoacCtDXhabX/C3F2QU5fBaUjFZ7k7EMfbAsEbEkyk6abn
	pm/WjnBShkG9g6uKzuZl9VWJlPgbqvHz05gEaEfbCrJeHjaBzF011xv9gb8Gvp2h6d1uJeuWr2c
	vl2FMeBVOyiyof1yElKOg982/vS/drOa4Qub4yGbEN
X-Gm-Gg: ASbGncsoVpLtmGO5DdzPlC0TbmC6X1YYMTv/eieq47CG/jvRH9FA22OzmbKySNVonO6
	H59gksu43aryBAe3zYHUhajx37g7hMwcOPctqxaF53Yi+H/lpJzHTDSKnR/dvC10/PbPhrQBK+4
	FjGydunNtDe1U8xSJT8x4cOrHscVQ7P2Ximw8I8G2F3MWcVGFAL1uQwlxTfh0f3ZRm
X-Received: by 2002:a17:902:db04:b0:276:d3e:6844 with SMTP id d9443c01a7336-29bab14895amr290317305ad.33.1764594439638;
        Mon, 01 Dec 2025 05:07:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHa3nN9mzQFXbbhuJZF5DMZDjfRKoqVAVxxR4e8RxhJk8lGIkCDoTseNfIANRkctGS0AfRNFxOhkbyBQ98AXfI=
X-Received: by 2002:a17:902:db04:b0:276:d3e:6844 with SMTP id
 d9443c01a7336-29bab14895amr290316815ad.33.1764594439085; Mon, 01 Dec 2025
 05:07:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251201090442.2707362-1-zhangshida@kylinos.cn>
 <20251201090442.2707362-4-zhangshida@kylinos.cn> <CAHc6FU4o8Wv+6TQti4NZJRUQpGF9RWqiN9fO6j55p4xgysM_3g@mail.gmail.com>
 <aS17LOwklgbzNhJY@infradead.org>
In-Reply-To: <aS17LOwklgbzNhJY@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 1 Dec 2025 14:07:07 +0100
X-Gm-Features: AWmQ_blxY-wED26_5AK29jUVQ-pdlYqyUIwkotkgWe89NafMExamU2oKPFJsVP8
Message-ID: <CAHc6FU7k7vH5bJaM6Hk6rej77t4xijBESDeThdDe1yCOqogjtA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] block: prevent race condition on bi_status in __bio_chain_endio
To: Christoph Hellwig <hch@infradead.org>
Cc: zhangshida <starzhangzsd@gmail.com>, Johannes.Thumshirn@wdc.com, ming.lei@redhat.com, 
	hsiangkao@linux.alibaba.com, csander@purestorage.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 12:25=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
> On Mon, Dec 01, 2025 at 11:22:32AM +0100, Andreas Gruenbacher wrote:
> > > -       if (bio->bi_status && !parent->bi_status)
> > > -               parent->bi_status =3D bio->bi_status;
> > > +       if (bio->bi_status)
> > > +               cmpxchg(&parent->bi_status, 0, bio->bi_status);
> >
> > Hmm. I don't think cmpxchg() actually is of any value here: for all
> > the chained bios, bi_status is initialized to 0, and it is only set
> > again (to a non-0 value) when a failure occurs. When there are
> > multiple failures, we only need to make sure that one of those
> > failures is eventually reported, but for that, a simple assignment is
> > enough here.
>
> A simple assignment doesn't guarantee atomicy.

Well, we've already discussed that bi_status is a single byte and so
tearing won't be an issue. Otherwise, WRITE_ONCE() would still be
enough here.

>  It also overrides earlier with later status codes, which might not be de=
sirable.

In an A -> B bio chain, we have two competing bi_status writers:

  (1) when the A fails, B->bi_status will be updated using cmpxchg(),
  (2) when B fails, bi_status will be assigned a non-0 value.

In that scenario, B failures will always win over A failures.

In addition, when we have an A -> B -> C bio chain, we still won't get
"first failure wins" semantics because a failure of A will only be
propagated to C once B completes as well. To "fix" that, we'd have to
"chain" all bios to the same parent instead. But I don't think any of
that is really needed.

Andreas


