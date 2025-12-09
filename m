Return-Path: <linux-bcache+bounces-1351-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD051CB0B44
	for <lists+linux-bcache@lfdr.de>; Tue, 09 Dec 2025 18:21:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48565305EC17
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Dec 2025 17:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8074E32ABF9;
	Tue,  9 Dec 2025 17:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1IFq9vuL"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DB932ABC0
	for <linux-bcache@vger.kernel.org>; Tue,  9 Dec 2025 17:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300896; cv=none; b=fL4QWMB8EW4kXjg9wxVLWM6fgSXOb72vLuG0GoaNLwZlJDLGQtCOjidf2APw8hsOFVu6XkuCGv+7f4Hz+g30tUlzJbZiH+ig3q4KJq4/xCjc6G3uBIB1n/wNYV4+0zISNDQt8xt8qvUP4H6juK8+AeC9NiiYrVvik76Z26I7P/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300896; c=relaxed/simple;
	bh=PxfN6IrhmJsY3FGoedlwbgk9sixTb5+ZEyyS77wtU7E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RVcUdjxFAtCtESs606CS/SKctw2msH8CB/WhiTLLRy/5GrxMrfKCcJLhzxOOVVJA3TYWT5KI/lxjk1KDq6/lAEMYbr+neCp0swt89RjFx4wwBQLD7y03Y0tq5PFVJz007+NS8vf0DfSt3DhtQPXobLa8nZ4TNSxK89TudnVwR7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1IFq9vuL; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c03ec27c42eso1112999a12.1
        for <linux-bcache@vger.kernel.org>; Tue, 09 Dec 2025 09:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765300894; x=1765905694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rCsW9PlTAYIGULzV3a3bQeMbvWm/rssCDvYfHhy5jY=;
        b=1IFq9vuLT8BcaYEzHwCFYUamjWdAF4jJuX9BVzkpT7Nr7/M7H5/c2m1TmL7jVfGeJH
         /u692qOsoEryq3Qdz/lUcHUo/RsbLbNipVqFFOiNK1KhLh2O4Oq81N77eYuxP8gmMffX
         VoFjh2fJly141fPSewLKszypo+XEwqVHsimtOkWDH2GgcmvN7uL6OGHOwnC0P+J9iYSc
         CAyD22GOFO4WwLpENl+Oh8i66fwP3LSiUEwAyeWHd+o4RFxTaEtI7+gpqMNgYGIqpUAX
         haTdh7yOJuhvA+9758XILu2CJm9ZU2zHvR8+36w0vrXcjey8E4bxtrma0OR0CWxaH+xn
         jtGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765300894; x=1765905694;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1rCsW9PlTAYIGULzV3a3bQeMbvWm/rssCDvYfHhy5jY=;
        b=Ex56zK6EA6wU0f+tDoqME24dt2hD2SLjjN4rM97YbOM7hXjNOrcTad2dyXAdP3pynE
         lbeHW5UEtVO/4AT76p2/G4/XQP3Mjgu6ZseKY8n2YuUVEWwmglHrSXhe5BNFOi6x5/er
         zbnS8ziX5qbOxlJE3WtRBdCDV2hEhncAaC7yyJPFkgC4fNxhfEhlPK5edWqwfKauN9vS
         iR1JXLq0bpUU8jYtpQi7RqZGN36BesOubDNwHvXKcmV2wQh2ha7Eyb6Y0XPb/RxPj6kC
         Mr23BW4Q1SfYOOUDWbxmcUZzv3m+g0ae6OjakooK0W3D7uyyzicMHbuIDOtAGMc15GR5
         dS7A==
X-Forwarded-Encrypted: i=1; AJvYcCX18wtBh5uMZKEQuXeyAOcv/6OW9gCMUr1qzgv3IdaGIHxlOlVKNXG1u9EyE1EUsnOckaj5IbBEofDZdn4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5ducwKBUydzQon+/6m3WN4l5CRvnwMXejTyLbTOV5S7JTTTEb
	EgtEFXNtNeY52j6A+nAJXD6/KaaVW0JmXbjc3znjEDFUYHfbhykXUtLT6bg4e0maZgA=
X-Gm-Gg: ASbGncsMjn5wZ47yvz4GwchgiBCYxb/ZAAzfhd2iBujcRIBeB5uHVWeozZpEGVraiZO
	kLk9NioUOiGRnl1Q+McgqzfuDmxVgEK28S1gnAduqMRI3QkYl6YNCR9YUCneLUWu/ZjhQj0VjJi
	h/W6Fi9ZXxo+2JaFk4EMgytcuF1Mobgyz2I7CLxM7sVjDCY8WxsgTdCVn9NwsURMcav7uIKd+Uv
	QpNmY9wQJlUWQzopRAp+TPYAV1Ce63exabkzkJgjBorV3ZI5N419/h8CuOVbEj4aBC3+pxATZJv
	l5DpZWTVd5DbRkXw3/yFhRjr1OGxurQBvy5pbRpvK/6e8r1y/LfZDfgjBNFcDIIxfPQVFwwWzy/
	JY+77TjHOryeAj/IjIwVS6V71RnavrgXkhaVsDuFf/bRUHY+hE3CFETaH81Y3mICEWMdb1Ot0sJ
	nAJivtN8ikoWz9Elz9H3uclpB2UB0ZhFvNhQVZClHGPiEUvHR+BOPhDWPP
X-Google-Smtp-Source: AGHT+IH6eqzKuOWUxreqhPpZimoHVZ2JHD7vpSeAoJZzK5vKnGNGqQwB+Pc2fWZI97x8Z5EiAlsbCQ==
X-Received: by 2002:a05:7022:fe05:b0:11d:f0d3:c5da with SMTP id a92af1059eb24-11e032bbdc1mr6698483c88.43.1765300893595;
        Tue, 09 Dec 2025 09:21:33 -0800 (PST)
Received: from [127.0.0.1] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f283d4733sm994549c88.17.2025.12.09.09.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 09:21:33 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com, 
 ming.lei@redhat.com, csander@purestorage.com, colyli@fnnas.com, 
 Gao Xiang <xiang@kernel.org>, zhangshida <starzhangzsd@gmail.com>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
 linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
In-Reply-To: <20251209090157.3755068-1-zhangshida@kylinos.cn>
References: <20251209090157.3755068-1-zhangshida@kylinos.cn>
Subject: Re: [PATCH v7 0/2] Fix bio chain related issues
Message-Id: <176530089153.83150.12817626967905322379.b4-ty@kernel.dk>
Date: Tue, 09 Dec 2025 10:21:31 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 09 Dec 2025 17:01:55 +0800, zhangshida wrote:
> This series addresses incorrect usage of bio_chain_endio().
> 
> Note: Patch 2 depends on changes introduced in patch 1. Therefore, patch
> 1 is still included in this series even though Coly suggested sending it
> directly to the bcache mailing list:
> https://lore.kernel.org/all/20251201082611.2703889-1-zhangshida@kylinos.cn/
> 
> [...]

Applied, thanks!

[1/2] bcache: fix improper use of bi_end_io
      commit: 53280e398471f0bddbb17b798a63d41264651325
[2/2] block: prohibit calls to bio_chain_endio
      commit: cfdeb588ae1dff5d52da37d2797d0203e8605480

Best regards,
-- 
Jens Axboe




