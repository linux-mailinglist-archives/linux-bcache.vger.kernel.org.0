Return-Path: <linux-bcache+bounces-385-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 836D089B3BF
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Apr 2024 21:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11B10B22629
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Apr 2024 19:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 130E33D55B;
	Sun,  7 Apr 2024 19:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="twdFLsYO"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4645C3D0AF
	for <linux-bcache@vger.kernel.org>; Sun,  7 Apr 2024 19:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712517056; cv=none; b=Zn7fQql3fwmwNMBj3zw2zbwX4Xk1bK6mlmF0FfNxkt9Sa5tiOFrSBWJo6fjPrx18OBmTvDJCd6g9m7Gh4Qf1TcP4QCD1pC9KgeZMQI2iAjODPVoJn7fwE08WCHqyXLi1BzU+EH2I5tEt6iFKwWZycGCU/+xbHIvFoizHyOooXyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712517056; c=relaxed/simple;
	bh=70HHBEd6cxrXlLkgbwjfvu3LYrWt/mT4YkQDDZ2MPi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pRi7/m+HHEaMjj6YUieLB13Zm8WtJ09sbyDotBWQND38boP3zr556Jg1HsgtlpTpZaPjmlp0ZdicpRblOqkDbsLlNjBkNaOzsG2VSuMa/xpFqcn3jndOUTZDN7YCCMBeetMh7wZsbHZIl3llJMAr/bLQ83f2bw9/6+hViOKEQSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=twdFLsYO; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e062f3a47bso123715ad.1
        for <linux-bcache@vger.kernel.org>; Sun, 07 Apr 2024 12:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712517053; x=1713121853; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6EUWLXyMd/QrPrA543Vnpb+tkAZZfWHn9rSEQeDI00=;
        b=twdFLsYOYbDEG5VMd/NJt3yra0CScuu6rLvDlvzD0/UcM3ccsSLLWrFRme5S+Qw4tc
         4AY8PNP5cS4iwCjKeWSUZvUbK4MwXP6J37sY0+2ec0UvZFPji/4xxe/VoNNkX6mhwJLC
         hu1+sVaI9v8ro30Kh9TSdyJCvVyrAnB4tSZd6oDpmHx+P1UgL64ssFvTGjV6VdDe3Bwl
         NIIrwkY261Swzjqh5E3Jxh64m+RJzck+Y3HdCqlFgX+7BqC7cVE8eB5tnujEwkgKkqEG
         wOJ+UEfcVumZZ8F5KdDvPayNoa3ekqecmz9NsZiJeQ4n/MsY3l99qQ8MMohBqtBzuUby
         QHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712517053; x=1713121853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6EUWLXyMd/QrPrA543Vnpb+tkAZZfWHn9rSEQeDI00=;
        b=OoLA2CvTPT1OaPSFkVP5sIJIAhQh1v35WTWO464Z947IbXkGc4Rbk5AzyLj069vZj7
         CpEIUCxetAxkzYpA38w1jNmFwN5W7rq60T7ZjJfoMGs7bb0GT8ZRXy58ar/oP7GSo38e
         7Ovg1hyHgClqK5dSpixr04wT+XpVg99PZU/s+JTydCnhpMzQGBTXXnvqGpl6Ko+7CD1D
         RI0WtQ2OlxOlcI9mRdMtF4KHMAsmq/8wLiucbJ/r5B1u7iXEB2Id+8uBwW1FdqwHGWSd
         d1eaDni3Um/f0P9yh6azVgRQa+Norug6ksavhOYQlJVOhvr9UZfdeJN1POi8vTDO8i8T
         TZXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPXkeh1RDNRj+CwEh6AgmXe3uJZhPVmXfyC9YnZttatoJxys19FjkWofoJ/u55LwtfrzUkqjb9PzDgbO5yeItbHNd79y1AajiAv6nS
X-Gm-Message-State: AOJu0YxuOTAXu6UYvjNG9czo1AAjhkO4xldkKTQ7PDequGpC7lJ1v+YJ
	TeXSHGOnSY8h2rAw24O3nmEWPNHgDH98nwyJ5AgIJwNjm2I4/J1oqMnXffRj5S2D0HHwktqSboS
	q29/eZozpjdL1jCpZ2kfhgTsLfAhnEMX/kotD
X-Google-Smtp-Source: AGHT+IF3K6r9xbBJkilZy6HGKb6dlLXRf6FqatUAZbCIWOQ+wDqVm5LXVF61yEKWVnLToUGV3EtmibzNbcvolpkp1/g=
X-Received: by 2002:a17:903:32c9:b0:1e3:c1a9:ed7e with SMTP id
 i9-20020a17090332c900b001e3c1a9ed7emr176673plr.25.1712517053266; Sun, 07 Apr
 2024 12:10:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240406164727.577914-1-visitorckw@gmail.com> <20240406164727.577914-10-visitorckw@gmail.com>
In-Reply-To: <20240406164727.577914-10-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Sun, 7 Apr 2024 12:10:42 -0700
Message-ID: <CAP-5=fWb3eNe3mufRJjPAc=jcHFiHYpPqLuK2H8YiijHu0rLZw@mail.gmail.com>
Subject: Re: [PATCH v3 09/17] lib min_heap: Add min_heap_sift_up()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 6, 2024 at 9:48=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com>=
 wrote:
>
> Add min_heap_sift_up() to sift up the element at index 'idx' in the
> heap.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 9391f7cc9da9..201f59cb3558 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -111,6 +111,26 @@ void __min_heapify(min_heap_char *heap, int pos, siz=
e_t elem_size,
>  #define min_heapify(_heap, _pos, _func, _args) \
>         __min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_h=
eap), _func, _args)
>
> +/* Sift up ith element from the heap, O(log2(nr)). */
> +static __always_inline
> +void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t id=
x,
> +               const struct min_heap_callbacks *func, void *args)
> +{
> +       void *data =3D heap->data;
> +       size_t parent;
> +
> +       while (idx) {
> +               parent =3D (idx - 1) / 2;
> +               if (func->less(data + parent * elem_size, data + idx * el=
em_size, args))
> +                       break;
> +               func->swp(data + parent * elem_size, data + idx * elem_si=
ze, args);
> +               idx =3D parent;
> +       }
> +}
> +
> +#define min_heap_sift_up(_heap, _idx, _func, _args)    \
> +       __min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_he=
ap), _idx, _func, _args)
> +
>  /* Floyd's approach to heapification that is O(nr). */
>  static __always_inline
>  void __min_heapify_all(min_heap_char *heap, size_t elem_size,
> --
> 2.34.1
>

