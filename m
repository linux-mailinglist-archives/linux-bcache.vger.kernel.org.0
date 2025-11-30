Return-Path: <linux-bcache+bounces-1300-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DD553C955ED
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 00:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 55CCB341E85
	for <lists+linux-bcache@lfdr.de>; Sun, 30 Nov 2025 23:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F3B25484D;
	Sun, 30 Nov 2025 23:03:44 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072C82405EB
	for <linux-bcache@vger.kernel.org>; Sun, 30 Nov 2025 23:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764543824; cv=none; b=qNzEh4u6cl8ZNHDu97PX+vAcFHqrm8/A4KezR1XeDqFMCfqQgubSzIXzuvWzG2RnrXbIUESQv1bl8rBVBYYCYJIayBcOg5pdK0lk0N0ZWX9n0gajByPz7opzp8/lGj6uWY0VxE97Vd+DDKqFD7GbQnOz9DMi5ZElhCL95xoWnWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764543824; c=relaxed/simple;
	bh=+KhrMhcJSvItbb/04gtqwcqQ9SN2qd7j6u0HCMyKS6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AdblxI538OAelp+q8Rfq+oaHG2XfXSZqHYvTNLW+h9LRRr4ak+6ufbLlNbKQbZ37UvTl8PlixBDN0+yH6e7silDq4L+5WtqtSmmUld0uJkwu6YCSNBg3GawBNEDntnfS19kJXzFiD7E+08oNAROucpZly+UQgkeKETsKd282c3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42e2ce8681eso795820f8f.0
        for <linux-bcache@vger.kernel.org>; Sun, 30 Nov 2025 15:03:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764543820; x=1765148620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+KhrMhcJSvItbb/04gtqwcqQ9SN2qd7j6u0HCMyKS6E=;
        b=dNFjtLSUedNwaGhrBXQICMGPEVXsvuF2twN8kieVbfO1t6kcNs80SBeWaixizCqqhT
         MfJrOPuf5mYnttGuzFqZdClN3QB2thhm4xKLtrlG4oEf4CNDakjQXhug+NQWmbb2RuuD
         dc3sZ5r9ccWYqC4mF8rpBLQEPI3vm+BBDBZzE0vLprQj0X9bapowN0wsvouW6Fso5kfu
         WBP8DzynmFsztBvAKzqeP5FTnDyZpdL3gpzBEcbCSbwXxvlKSO6qSTLlchQnxG3KbcU+
         S/sd8ph7JNLeUKu8r74vgWv449cGhQ0lrUy33WLWZoSO6J2SHfyfaXD8GBctw2QyeAtJ
         X45A==
X-Forwarded-Encrypted: i=1; AJvYcCWZXpVJPv9ssxHk6HHxn+kohZM0noHJitssssnXvRfD5NIbvf+t2AvmjEB6s+jKW/aToB1JLD/bsiu71RA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy07l0AzjvLHMp529GReEgQ+oA9cLNYn2r3xBLmgyWWb9NQ4ci8
	M31Gp1WH8xZkJbEJgvpiuipAaWFIj30qWJvWqfQyuinLaHU5mTkSxSzh
X-Gm-Gg: ASbGncvG6JyEIs6PNYAoZBT2Ng/LyN8xSw6c/c0iejBA8nj5JHunGFDsFCJ4kNc7W9Y
	q1KEj74HC6nx+jpGpL3e/N8b1hXR2/iHdV/a90HR/nUIiBbBrLTvwH3fO6E6y+GVtRWFGRRko2w
	Z2X2Ki/gzktJm9sajdXzQYgFiU9WCOPXaVXXneagrqaXby+beSb8sa4nVC4GahVNNMDQJJP2K6S
	hLxVsmals01PVJ4udyrEYw/4L9PFbd9Cc6s5c3NYBwUNBVXzQMWMbC61qfwTsZl/fllPGF9iwH0
	49jtdaQFYGKMw0X56cUslPMAnH89xfn+FiaWx3iLf28MLLJw4BbH/cAtCIAsKNohGUZ1dEvjwpI
	gOkC1yZuaBtebhIQeVc8jCCJH5JVgRxJhJ3wF3cRJhl5nfu9O3VQfkE6SMD0oLfoUjy79Aaxdl6
	LE8AH8A+VG8A4cOIcE7fjNlxJawGhirMCkXeoLI6sM
X-Google-Smtp-Source: AGHT+IG0kUJO7SYN4V6YpXy8uJxkqAm9wDLe/yTWTady0nKXHIsEefrNGBZg2POKGw5qhetClLnvgw==
X-Received: by 2002:a05:6000:2484:b0:42c:a449:d68c with SMTP id ffacd0b85a97d-42cc1d0cf34mr37257663f8f.30.1764543820316;
        Sun, 30 Nov 2025 15:03:40 -0800 (PST)
Received: from [10.100.102.74] (89-138-71-2.bb.netvision.net.il. [89.138.71.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caae37esm22401721f8f.40.2025.11.30.15.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Nov 2025 15:03:39 -0800 (PST)
Message-ID: <b33b3587-edb0-4f30-a8ee-baaa2b631ed9@grimberg.me>
Date: Mon, 1 Dec 2025 01:03:37 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio
 chaining
To: zhangshida <starzhangzsd@gmail.com>, Johannes.Thumshirn@wdc.com,
 hch@infradead.org, gruenba@redhat.com, ming.lei@redhat.com,
 siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
 linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhangshida@kylinos.cn
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-13-zhangshida@kylinos.cn>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20251128083219.2332407-13-zhangshida@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Acked-by: Sagi Grimberg <sagi@grimberg.me>

