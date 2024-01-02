Return-Path: <linux-bcache+bounces-195-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 661DA821EFD
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jan 2024 16:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DE281C22587
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jan 2024 15:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573381429F;
	Tue,  2 Jan 2024 15:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0lJbxcpr"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5384514F60
	for <linux-bcache@vger.kernel.org>; Tue,  2 Jan 2024 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7ba97708c38so111162539f.0
        for <linux-bcache@vger.kernel.org>; Tue, 02 Jan 2024 07:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704210248; x=1704815048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g9QVj7o90tQS3H4SwYTPIYauXLnJ6OU7xRh/0KG0CF0=;
        b=0lJbxcprsQY1rGwU0Hb/JUK1MHP0xFeszwYM0OX1EBBAcE0I1aG508nGVoap433fri
         Y4/JxX6DcCzDdgobPVYjZEVy3LhJ/h4RNdoJeVri1nOJT112+e28cBf+q2UqyruttCz3
         /ppdvkPTzvyziOiltWfpck/U2tPuvBVGhi/yFCf7uvVnUCFo5Fut0ntvVnS08oClXGUH
         earLWq8uUyeLxQcvJI+ERbL2vYYeLFvOxGM7Bifn8oFtyRB0KH6WteCAYi6rTEXw3gCM
         X3mTRysESrgZu2fEN5tqv+NrFJoVZrTKFktoA09Lu4MbHLPPMxWdYo2N1JWOHQYkoX4/
         DwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704210248; x=1704815048;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9QVj7o90tQS3H4SwYTPIYauXLnJ6OU7xRh/0KG0CF0=;
        b=Ff+Y1FXmGvKW1qEP0+IQaTPGv0eRqMHQkUH+fagkwvoCQaiC0ZcCRvNHSD0Cr3rLRT
         5nzboMQbQ3uHULv2Q6fWBuo8hwjW0nyfv9n96DdDjP8DI6NBcS/rT2rguxTOqNmVFIQu
         2+WmkstTZznFuItnExZo51LdizMWHp3qlM/lcNemf/KGh1805FbgzVsL8/0EkOt8Bpow
         ol5DN3dw33cyOuGeU7f5R+xbJe6y6L0yvMpC0JG3Iyu+o4COdp67j+dkqog+8P+xn+yL
         JVrVUawMXqdgvzWmUPn7GdJoCN46OHTiEUTBE3boqysp1FJs6Yl+GCOt0RS1WeLtwunt
         1nhQ==
X-Gm-Message-State: AOJu0YxaWP8vXeDEw5d8a0WDzlp5i/oI2pI7LADd6HrqHbJLwrWYBLGZ
	DPvJA1Q3djMiG/unKpMDpFvUz5kNNdZebQ==
X-Google-Smtp-Source: AGHT+IFaAhZehoDkL/Lq9ymm1RdzzKN/67q+7aSVQpGW7QGqOVV9a9BjzLBm4rE1KB/JklVJV2PhvA==
X-Received: by 2002:a6b:e916:0:b0:7ba:9b40:2648 with SMTP id u22-20020a6be916000000b007ba9b402648mr24056653iof.1.1704210248423;
        Tue, 02 Jan 2024 07:44:08 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca16-20020a0566381c1000b0046dcfbc1bc4sm496784jab.79.2024.01.02.07.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jan 2024 07:44:07 -0800 (PST)
Message-ID: <f3758a5a-986f-485c-9a6b-c11af20c3aa5@kernel.dk>
Date: Tue, 2 Jan 2024 08:44:05 -0700
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
In-Reply-To: <400dbdbf-e99e-4747-94db-54fb6674fdd5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/2/24 8:40 AM, Jens Axboe wrote:
> On 1/1/24 6:15 PM, Sergey Senozhatsky wrote:
>> On (23/12/28 07:55), Christoph Hellwig wrote:
>>>
>>> The discard granularity now defaults to a single sector, so don't set
>>> that value explicitly
>>
>> Hmm, but sector size != PAGE_SIZE
>>
>> [..]
>>
>>> @@ -2227,7 +2227,6 @@ static int zram_add(void)
>>>  					ZRAM_LOGICAL_BLOCK_SIZE);
>>>  	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
>>>  	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
>>> -	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
> 
> Yep, that does indeed look buggy.

Ah no it's fine, it'll default to the sector size of the device, which
is set before the discard limit/granularity. So should work fine as-is.

-- 
Jens Axboe



