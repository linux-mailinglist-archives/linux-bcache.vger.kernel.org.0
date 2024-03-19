Return-Path: <linux-bcache+bounces-314-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3C18805C0
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 20:59:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 264CD1F2317C
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56A85786B;
	Tue, 19 Mar 2024 19:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mK7AsmiD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE38101D4
	for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 19:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710878386; cv=none; b=JPv1bDjyopND1KAaLn5+2MswHWhWtE7UsSwkJ2uI/QJWfyrJ3VfyWCRaaV+W34bkib57p3FrAaRuukCN2osIJbih6MyAg9qTa55f8Z+osCe/93WZgubwk/X1ZpBV311XGgiedh6Uqd1WnG323RxGR6pl/BDh52YHWbZkVbKAwSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710878386; c=relaxed/simple;
	bh=5F9GV5774xtDFEEGdDVdO5yEYWYXmfsvieiNhJPNsC8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUVnEzhqdxrcj7EatocaR6u+T5eM/4chglIPzBOJeLcXQJV+nmH4pnTUuB+H81YKM3wSCcOUTUi6B6t/hcrDgbRO+2mgoBM3XK6VWi+npYwG2BA5wBRQFOHhh/jgs/I+yJPZZ0SmtDIrg1cf4pRXIipUha0HdrxqB8RtTpD0jZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mK7AsmiD; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e058b9e479so25715ad.0
        for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 12:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710878384; x=1711483184; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DobisIZIdWT5fAMjugODSdKj/CsBUKizI1tCDIITWoc=;
        b=mK7AsmiDoHfrkG5ox8Iqi92M23TWxzowYMPMYpzWVAfjgcSVyiuhr1DtULGd+ZfHi/
         XlAKCxRApRxSLkaXn/MSfvsL5BNywkFFYcjkd/DtyM60AjZymj5RnLmJubBbeDOauTlz
         C6q6orx8hFmGcQ1mv5N6vHxlCr56lU+m121GKdFYffRTXBV0OTrZqeASKJJ9z4WbflNg
         Leh7I1ztnfYkW0eH4J9dCvsgKqpTt8u3v2W5wXObqHr1FbJNItKuQtZnDMiO3iwhsmXy
         G30cjJqF1WNn4BnHT6GdBHpXARhf1Kvon1XpF41scbwHqXLDhHgho0wGyMr06Ux/d/Ps
         YEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710878384; x=1711483184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DobisIZIdWT5fAMjugODSdKj/CsBUKizI1tCDIITWoc=;
        b=WKywv37k48l+qnt1nI7e1KMccY4SiQA+X9sZj8s1Umd6BYyX6zfvzNlowcxxaFMNnk
         7QBUnCFh6yLEbPbJQHYLFeJWommEgDgIeNQEPKT92g6MbDJvGE1zx2icaCStmaBqRLTZ
         89nGNNsn2GNLdJ8y3nQdu7GGreK74L9HlWzIWX9GR+ewzwRoKWZlIs9LE4HN8FKpFeiw
         z8GGBjG4CXFutvfkI9paqmedpUf6b2DAccy0in9aOllUJb2v0hCW31idD9hwSifbxvJ/
         2yhpBVissGW6Y82RBeB2hv1svevTBuBF0NpnYS+dq/fnMHn3os6YvJaAozD+6+9BuLwm
         dx5w==
X-Forwarded-Encrypted: i=1; AJvYcCU29JaN0Xc9DTn50AqG9rl14i/cM/fzs8FYS+4cvtIPUUw0ICGs3vIqJTavVMIwjuEECOqzp9wRMJyUX9yYvvUlyWJM4edy/EVN8Wi5
X-Gm-Message-State: AOJu0YzssLdpwQR3+RXkK0cnWNajOSclj2zO8BYUFVhQl919yRj/V0eo
	B+nAe2wkcg34bohqOqAL2CLoRcutKW2gZUcnx3/MYq5ZCXhxEqWfSpUTexBQ5aYS5FPvZMZvuSn
	n5Oo6yhTY7LprR6vgpEYjI2trpks/3NC6AAda
X-Google-Smtp-Source: AGHT+IHKYWLHUpxloLUH+NKyvBuPDnmTq249MWbzWivuQqJ4VjbGHKTaD+z9zajEi+vi9n0XoP3Own5xUGSSExIU1xI=
X-Received: by 2002:a17:902:d4c6:b0:1dd:b010:8339 with SMTP id
 o6-20020a170902d4c600b001ddb0108339mr65089plg.8.1710878383639; Tue, 19 Mar
 2024 12:59:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-12-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-12-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:59:32 -0700
Message-ID: <CAP-5=fXKU9uS-F=G5q8jEdCGC8tS9uM52TKjHOE9aP7yXb6RaQ@mail.gmail.com>
Subject: Re: [PATCH 11/13] lib min_heap: Add min_heap_del()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 11:01=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.co=
m> wrote:
>
> Add min_heap_del() to delete the element at index 'idx' in the heap.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 154ac2102114..ce085137fce7 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -199,4 +199,28 @@ bool __min_heap_push(struct __min_heap *heap, const =
void *element, size_t elem_s
>  #define min_heap_push(_heap, _element, _func, _args)   \
>         __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_hea=
p), _func, _args)
>
> +/* Remove ith element from the heap, O(log2(nr)). */
> +static __always_inline
> +bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t id=
x,
> +               const struct min_heap_callbacks *func, void *args)
> +{
> +       void *data =3D heap->data;
> +
> +       if (WARN_ONCE(heap->nr <=3D 0, "Popping an empty heap"))
> +               return false;
> +
> +       /* Place last element at the root (position 0) and then sift down=
. */
> +       heap->nr--;
> +       if (idx =3D=3D heap->nr)
> +               return true;
> +       memcpy(data, data + (heap->nr * elem_size), elem_size);
> +       __min_heap_sift_up(heap, elem_size, idx, func, args);
> +       __min_heapify(heap, idx, elem_size, func, args);
> +
> +       return true;
> +}
> +
> +#define min_heap_del(_heap, _idx, _func, _args)        \
> +       __min_heap_del(&(_heap)->heap, __minheap_obj_size(_heap), _idx, _=
func, _args)
> +
>  #endif /* _LINUX_MIN_HEAP_H */
> --
> 2.34.1
>

