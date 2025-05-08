Return-Path: <linux-bcache+bounces-1059-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D53F8AAFAF2
	for <lists+linux-bcache@lfdr.de>; Thu,  8 May 2025 15:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A371A7A344F
	for <lists+linux-bcache@lfdr.de>; Thu,  8 May 2025 13:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB71D22CBF4;
	Thu,  8 May 2025 13:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dElkhqxu"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C1B22CBE9
	for <linux-bcache@vger.kernel.org>; Thu,  8 May 2025 13:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746709819; cv=none; b=PFVD67JDJtV9kgBuEIq2dWuG2JUedzGYylezBTHDnyM8RYKoIHkrfRAo6n+1xIJp9cTvlcwZq4iDFfL9sWLGP7MxdiYS+13SuEzmjH2L2j6OI4HFK/h0eHOxG/RzkoSWS6Bcnc/wRLFHO708KwwBL/0Hb+Acd3reGiXgjUbtcxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746709819; c=relaxed/simple;
	bh=p3igjo1WeQ4ei3xNoOb2bq7IvOmv4IUIwEwUY8QYhsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FbWcWPi1ql5J1pZANjI5TEK3vyV85zb4LxgyMRurxsy2+OOAzlNPjDZF24Efw1KM453MjGefS6iN2Q+2CD76lztiWNiN6nzOaNe/i9VyattlKPyh/igKYZ/sdNrTcyqHNrdBy688FaHO30ZJKjUJughuXF8NiabDBg169tZcj1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dElkhqxu; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-476ab588f32so14386921cf.2
        for <linux-bcache@vger.kernel.org>; Thu, 08 May 2025 06:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746709816; x=1747314616; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XTDtbe4K12xhEpViDB+3A6qWj2g+MO64MrS+vZvyuzM=;
        b=dElkhqxu/goVLCAJe4YPugx0jIvVu3HkSV3T2iJALFlfFNIXcRGxDWSUglX0tUG3CJ
         t/MCz4ZrKPpWINAqWURuSlmJiBp0qkU8hunAqzJmdUJ0iKEsaxxQXsc+YVtTZJ15QWkS
         scX/2joh/OLf1q9NIBVPquAY6PZbbwtxsZj7mpE6I+0ASUQrpKG60HIak6CiD/6VQf+u
         aBAjzc6sGAVBkpN3DPZI7h12TNKtDSodHnHCZ6TmQe0w9y4Nh6CTiTNYng5q+V27+9Pd
         xekZUQjToRDmOKBXwBOdC6KpPugNqMHPcdqLEDgzCU5eCbIi+q/zT4p/ANvrIn59+dVU
         JvLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746709816; x=1747314616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XTDtbe4K12xhEpViDB+3A6qWj2g+MO64MrS+vZvyuzM=;
        b=EUpIvSDN6aXbQRllMzRhAxwkW3rnrlXum4c0svMjdsjbFkgQukv/8u13qrFgjTMvz7
         IN5VU9EUbnF0DATKZq2vdKQzUEaqj4MIfDVvzOlb7rv+G4ATcP3cCQ4EwbGdZgsRqa/V
         hJi6xX6JAoV0qYHETF8W3ydWLobRpllbe4rZtLnzT58Sx1sg7oufB4Pa6gb33OPIslD8
         uuxtUUF9PqC/4WSvsT6CI2i2pyziFuYUQPicCfjTvuhWuG1la0OWDflfrRanPUBVotZS
         zs9Z865RDzgteb6mZo4Yap64ZTQM0v5tWOAHZGSKPgkaWNEgfuBOc8mvMFevPEDKSbB3
         lkyw==
X-Forwarded-Encrypted: i=1; AJvYcCUTdL2zntuKHH/RUh2ovCSowSpv85xk2cU1Qci9K4mH3p8uVJ9Q2sXdA1q3UK8FaS8TptPBXsdKQOiIvG4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfEpxqpv0OLYORHigr9pgUZB9yno8FnZL971OS7n9UOehtO5CT
	NhQAjrZDl2aVrsmuE89eEt82qOcbOizjA83n++VLpzg+bKGKHUmW3/iMpo/h3GH57mtnv7NNpKU
	W
X-Gm-Gg: ASbGnctRPHDMkSeKlZIw+f1rxJYRJ9OUKhNufKxK0u1Tw+Ubnj2/ayf2ICgHuDpniP4
	7FfrHrVwwScHRO7DlV4pmG3TaS14PlsgmlN+3WVP4U067cpqkprjJDDlup3HWjm/DFWdSpmXhIk
	xArFY9CDnHEasYeoYg1fnlUz3DA2w/DbMDigpL/o7z6nwq704fmYRJivNxQ0hjKeEoW3+K9pl62
	Q1FleQG8ZVvrdRRPjlWqPU9me8VAjmJtFLx9vMpmMHRoSxVV/ja2+1n1n/R24kIh64TqMijHlO2
	zr3c6AaB4nwJ4aiyAeo/AJK0dyOBhtO5zVzV
X-Google-Smtp-Source: AGHT+IFc67B3rj29wLwGe5b9hNdUhbBaJDAFmOrgjOa9uQdS/eOlhjhIK4I5PRu/Z5lCJQDbW0IFWg==
X-Received: by 2002:a05:6e02:12ef:b0:3d4:6ff4:261e with SMTP id e9e14a558f8ab-3da73867d6fmr68904585ab.0.1746709805765;
        Thu, 08 May 2025 06:10:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a945471sm3173148173.70.2025.05.08.06.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 06:10:05 -0700 (PDT)
Message-ID: <0df727b4-c0fb-4051-9169-3bd11035d3e0@kernel.dk>
Date: Thu, 8 May 2025 07:10:03 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] block: add a bdev_rw_virt helper
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-pm@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250507120451.4000627-1-hch@lst.de>
 <20250507120451.4000627-3-hch@lst.de>
 <a789a0bd-3eaf-46de-9349-f19a3712a37c@kernel.dk>
 <aBypK_nunRy92bi5@casper.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aBypK_nunRy92bi5@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/8/25 6:52 AM, Matthew Wilcox wrote:
> On Wed, May 07, 2025 at 08:01:52AM -0600, Jens Axboe wrote:
>> On 5/7/25 6:04 AM, Christoph Hellwig wrote:
>>> +int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
>>> +		size_t len, enum req_op op)
>>
>> I applied the series, but did notice a lot of these - I know some parts
>> like to use the 2-tab approach, but I still very much like to line these
>> up. Just a style note for future patches, let's please have it remain
>> consistent and not drift towards that.
> 
> The problem with "line it up" is that if we want to make it return
> void or add __must_check to it or ... then we either have to reindent
> (and possibly reflow) all trailing lines which makes the patch review
> harder than it needs to be.  Or the trailing arguments then don't line
> up the paren, getting to the situation we don't want.

Yeah I'm well aware of why people like the 2 tab approach, I just don't
like to look at it aesthetically. And I've been dealing that kind of
reflowing for decades, never been a big deal.

> I can't wait until we're using rust and the argument goes away because
> it's just "whatever rustfmt says".

Heh one can hope, but I suspect hoping for a generic style for the whole
kernel across sub-systems is a tad naive ;-)

-- 
Jens Axboe

