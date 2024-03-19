Return-Path: <linux-bcache+bounces-311-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82EBC8805B0
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 20:55:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A7FC1C21BD7
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC704AEF8;
	Tue, 19 Mar 2024 19:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i/Gg2Usb"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADC43BB25
	for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 19:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710878123; cv=none; b=csRFhN8K7zd9BnZFs9ApoU1+VsliF24VfJeQFHtAYsGZs5K7EMzaD82cNzcufjF7X8JcuTPnuHASFPcm3R9iLNZAGwRsRJsPNqHIjRWCkn3F41ppy4HmNlOH2Nen7uo+UVcIRA5Iz79QRUHEW9rrx9Ch1NJuEghLvM4DZhY3HvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710878123; c=relaxed/simple;
	bh=tq/1pPtVk4bFy1TUWWqhNCcGUABz2Wn0gW+04VmLGUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YZJuMMcY8gfT541iCOav4rjGHLIR36V26J8pezTCFhU85GBYxVUphgkw7LmCo62Pmd65ZZi0IL6LDiDon8+setvLpoMWPPcXjM+OmfnbqUCHqH5hvH1lI48gAbhulaWVSf/VDAavtxNS6ATFxmwSytCvss5yoRGCCdFSyb6aVVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i/Gg2Usb; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-36646d1c2b7so845ab.1
        for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710878121; x=1711482921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgLh9fxNWA3PLxV487Uv3NZnNjKvvWhoCvzQBg8zyQQ=;
        b=i/Gg2UsbI+WuXMivJK5yDnCJA8uYabgTTBLxhQMw5fQ//qS+w29wcwbyExemOyWlcK
         DIQxAE5ceQYKlRHIBZ7kIXn68al8eQlCZMnrap7wG3IPdS9L1deXQ6doSUtoONwYSsC8
         DKFYVMsd2FPDL/C2RJcUGsLwd0+YLOzjJEsuCAes6fnRoLN2flirAsNsIpcXPNktLsZU
         I2wX8nwHBoZCEHxTBxfAxKIDzKF7EGFySyJxZuW2LIn2nXF73jYT1kTZLQtiefaNj+GM
         ifXMz9UBjHjeRqGHJOQIUD7sv8AwmEd51FXBaYxFmpAn785lNM1nv3NkklCGeR6xMsRo
         FYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710878121; x=1711482921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgLh9fxNWA3PLxV487Uv3NZnNjKvvWhoCvzQBg8zyQQ=;
        b=lN4TOksW1IdDzLH1cSrNzVMo/fCXn/kB4ZA+Hrvn6lQzC+ongLpLOLoXv6FSbge4c+
         WV7OQSbieedPaADExnpeW+R1YLGacrCJO1EPyBVBhaDpvtk4DI7tfGFZrHD7LXoKN/Hq
         ObY2mJEz9Hsat0J0GYNpO5883+UORPfVBpqCgEriZsBaj8JF+M+39Byp2p4Y9A1xHm7Q
         QPvjsVWF+VDi/AdrVEvKV+YrMGW4NxMjbbeLAIiMkA3WWqs/gwm3/ayY5vZX+N9QadId
         KbfVK02TDmghSBusclhY1Dk+QC7cgVzpaa2+nxa3zax80AJXQAs76AlbhxOC6zCcJJCx
         7nNw==
X-Forwarded-Encrypted: i=1; AJvYcCWc2iHx/uRtHYoMGJER1eOdJ8RcpJ2okiThxFLL/Cjd1Xw4bnT1KDEqw0KkxHs+WScJGAw2WA4S0tvQXSloGRxWjZBKuhpTdi/vM1tS
X-Gm-Message-State: AOJu0YygaPTVgbEV4LDspYWII5r0/W4V3dkzfNq333RRiGP5OU1LdjuB
	a55Gp1ZRBlq+7BR1cuf4ZMJQV96ZUewNwatnzZm89xTYMAg0oekvs4+wPP08vJlqa6V1xDSnMc0
	/M0TtqxooyUk+mXrN7dgrgRUQ8FpyxOgFh+rR
X-Google-Smtp-Source: AGHT+IERlmpYbi7scXHRweGWqKFANu4nCnjg91c1eLgZPt1tpqmLTiArMaKYHHFVGIrDmnNDhYnBI2oLyIaUqaSz3v8=
X-Received: by 2002:a05:6e02:1aa7:b0:365:a6a3:9c82 with SMTP id
 l7-20020a056e021aa700b00365a6a39c82mr63098ilv.26.1710878121279; Tue, 19 Mar
 2024 12:55:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-7-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-7-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:55:10 -0700
Message-ID: <CAP-5=fURxwVSddrNRhRwT4rWsRhq+BLkAzqi7ooZ6JQbPsOP8A@mail.gmail.com>
Subject: Re: [PATCH 06/13] lib min_heap: Add min_heap_peek()
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

On Tue, Mar 19, 2024 at 11:00=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.co=
m> wrote:
>
> Add min_heap_peek() function to retrieve a pointer to the smallest
> element. The pointer is cast to the appropriate type of heap elements.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

I see there's coverage of these functions caused by later changes.

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index ed462f194b88..7c1fd1ddc71a 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -56,6 +56,16 @@ void __min_heap_init(struct __min_heap *heap, void *da=
ta, int size)
>  #define min_heap_init(_heap, _data, _size)     \
>         __min_heap_init(&(_heap)->heap, _data, _size)
>
> +/* Get the minimum element from the heap. */
> +static __always_inline
> +void *__min_heap_peek(struct __min_heap *heap)
> +{
> +       return heap->nr ? heap->data : NULL;
> +}
> +
> +#define min_heap_peek(_heap)   \
> +       (__minheap_cast(_heap) __min_heap_peek(&(_heap)->heap))
> +
>  /* Sift the element at pos down the heap. */
>  static __always_inline
>  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> --
> 2.34.1
>

