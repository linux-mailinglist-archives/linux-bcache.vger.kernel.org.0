Return-Path: <linux-bcache+bounces-196-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C585821EFF
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jan 2024 16:47:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2A84283722
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jan 2024 15:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9641712E7C;
	Tue,  2 Jan 2024 15:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C5zJ7uxX"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DC714A92
	for <linux-bcache@vger.kernel.org>; Tue,  2 Jan 2024 15:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-360576be804so41205ab.0
        for <linux-bcache@vger.kernel.org>; Tue, 02 Jan 2024 07:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704210459; x=1704815259; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ySBFOJIM0DSvIVDKhQcLqvBT2yyLab4gqIewIhfdbtY=;
        b=C5zJ7uxXGYqBgl1NpgoOSuA7SP2BBeUjv4TRU8MCeQpj4fpi4ZO92a7MofpFmLzoan
         DrsZCtcO1eVAOWa5H54qkDGN743LyFSfmZHLztwRiikfI5VYdFCiWUso5ZwJdrsp/l52
         maYJVrnFv+Q9Rw5OVFxYCpYhgd6XXJu5caf8hSP3uZhmXBLMpIAzIdSZF8G03aiWlqhE
         WePrt5pJ/o5kDDbll9j0tH7IISFR2h9JDkB8ph8628RVZdpRXN3c1NjibdDizTy0xGs2
         oGKqIWRfDBjyRTnmaFlLQ9MiUlTwUaaE5rtBNfjtRLNGyWtOxsk1ScVU942Sm+OmTEkR
         G0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704210459; x=1704815259;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ySBFOJIM0DSvIVDKhQcLqvBT2yyLab4gqIewIhfdbtY=;
        b=RzLV+WlKHedvs6H6lf4c81QKvoRxGh3R0hoDfcdkZw6JKzBw0T4GjQbGcumFvBQBAL
         lqCr6aHmoaQpTkptwaI25aQ0gKt+h35o4AcevgQU0/WPLKLNiKvOsaQ6X0KWIfnS5zzi
         /Fh1pqQugx1CVphs11hM5oagjlmoRQasgqx6y9E51Yo49LIwqOAAiJjXpMv4tbpgLyGh
         c/4A7KotTl5twZpqQ7DaDr3MeTjHJ+GuCxTC8MIsYkeIWKp8l/c/6CdrsjnHYs2TytP5
         OSAzC0SbWdDQ0DQqxl6aZv8zBlJh0gGiQvMDwET5pGgICCBQsKlS5W6Uu40PuBqf/Cve
         Tv/Q==
X-Gm-Message-State: AOJu0YzI10Ol8OUprlginKwR4LrPwPIi7EMVms8FMolzpsy/AICskXxt
	Rn04tChlyzF0EL/PX4NakFK15qcJsBGtMw==
X-Google-Smtp-Source: AGHT+IFs9GZ/Ey7ptKHRHLLO93hZlIAauQjofaYqCnhw5oeOlPvARiPsQn3KTgYcoEx49b9b2zgL8Q==
X-Received: by 2002:a92:c26f:0:b0:35f:efdc:7738 with SMTP id h15-20020a92c26f000000b0035fefdc7738mr26703798ild.2.1704210459220;
        Tue, 02 Jan 2024 07:47:39 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cb6-20020a056e02318600b0036003f7ce61sm5383610ilb.87.2024.01.02.07.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jan 2024 07:47:38 -0800 (PST)
Message-ID: <92011368-a4a5-428b-9801-26a6a6a96752@kernel.dk>
Date: Tue, 2 Jan 2024 08:47:36 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] zram: use the default discard granularity
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Christoph Hellwig <hch@lst.de>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>,
 Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Vignesh Raghavendra <vigneshr@ti.com>, linux-um@lists.infradead.org,
 linux-block@vger.kernel.org, nbd@other.debian.org,
 linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org
References: <20231228075545.362768-1-hch@lst.de>
 <20231228075545.362768-8-hch@lst.de> <20240102011543.GA21409@google.com>
 <400dbdbf-e99e-4747-94db-54fb6674fdd5@kernel.dk>
 <f3758a5a-986f-485c-9a6b-c11af20c3aa5@kernel.dk>
In-Reply-To: <f3758a5a-986f-485c-9a6b-c11af20c3aa5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/2/24 8:44 AM, Jens Axboe wrote:
> On 1/2/24 8:40 AM, Jens Axboe wrote:
>> On 1/1/24 6:15 PM, Sergey Senozhatsky wrote:
>>> On (23/12/28 07:55), Christoph Hellwig wrote:
>>>>
>>>> The discard granularity now defaults to a single sector, so don't set
>>>> that value explicitly
>>>
>>> Hmm, but sector size != PAGE_SIZE
>>>
>>> [..]
>>>
>>>> @@ -2227,7 +2227,6 @@ static int zram_add(void)
>>>>  					ZRAM_LOGICAL_BLOCK_SIZE);
>>>>  	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
>>>>  	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
>>>> -	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
>>
>> Yep, that does indeed look buggy.
> 
> Ah no it's fine, it'll default to the sector size of the device, which
> is set before the discard limit/granularity. So should work fine as-is.

Replying to myself again... It does then default it to the logical block
size, not the physical one. Which does look odd, seems like that should
be the physical size?

In any case, this does change behavior for zram.

Christoph?

-- 
Jens Axboe


