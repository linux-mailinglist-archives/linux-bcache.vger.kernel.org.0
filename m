Return-Path: <linux-bcache+bounces-1331-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F50ACA2E14
	for <lists+linux-bcache@lfdr.de>; Thu, 04 Dec 2025 10:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BC41E307B4CD
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Dec 2025 09:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13313346AA;
	Thu,  4 Dec 2025 09:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="d8/pFBj4"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8950A332ECD
	for <linux-bcache@vger.kernel.org>; Thu,  4 Dec 2025 09:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764838829; cv=none; b=UKGscoxM5ikB0l1C/O1Gy0handOBsc6fNJCaQIMwK2FLnO/25SuVnFDQgUHyUtb8VJzxUFmTny1vej85cVvRRvmIpg6OzHR6QU+C5q0/or/jl+wFRRW4I90MBvfgnFJeLfoEMj3M3bH4WmyYZJR7hGZ1qy4wdhwJUOy2JNPFUPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764838829; c=relaxed/simple;
	bh=72GPm1ULAj1WA2GXdfhiS+jYjGnUAprwyZKKNmKV62I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KToNWI1/BHEhDOM5YoLDnmG221Q9yyGYfgSgaKjN9i4ty9+eK6ZhOdPl6uj6ONRVwiuW7eSEguhDdfXPcbCyRhXNGyxiaOUyj+MKVIbl2ttDo3iPiXaN9EhLe7ZYl03eIVO9i3IjlWSkvPZsWS+u4FZ5uWOuNokOcTpnhashOuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=d8/pFBj4; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7ba49f92362so437779b3a.1
        for <linux-bcache@vger.kernel.org>; Thu, 04 Dec 2025 01:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764838827; x=1765443627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=72GPm1ULAj1WA2GXdfhiS+jYjGnUAprwyZKKNmKV62I=;
        b=d8/pFBj4FGRkH7QWlN8rQvDV6IlMWDUg605KeQ1gBOCr/BEoQshoR8T5DQFy2RO8N8
         c1k88JauWrYBi7WblT4cyXW3T8XrmXYkhRGNoUs0oap8m4ffw1QHEx0JRoB0N1OO1qs4
         MSivUcGmKJE03vLOq+EJGofaw+BYOBYJHGMn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764838827; x=1765443627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72GPm1ULAj1WA2GXdfhiS+jYjGnUAprwyZKKNmKV62I=;
        b=BQy8c3lBaQaoTMe0VSFwJ8uQmUk5ABhcuFjiAKCnLKmxkwRWFzoRKbWr0uIlLSP6Dk
         bR9lg+pt3rlGssAQR6AKKLQI9ZVl81fb3hH0IAhKvPIN7jHs7zRtWRPsfKFBXDWn2lxs
         nPXe8uf93X99LHVkw27RANS5PLmqgN3yhkmUt9rwvdVHU519In6R6NdUV9Q2eB8FweCZ
         y/iKNHqnm8hkVBxx3USL3gBC8LpdpHeOsY0O9e6lf8VxA+klPFcLmpkA7mBFBpKeNl7m
         7rZx+harG5DFQqpuHXxmYmPU2DNta/73qHXX7TY70N+Z5JsDI2owXEa4pnovXbjXYVKq
         ooqA==
X-Forwarded-Encrypted: i=1; AJvYcCXYL461rZpTiQffa5K40cB78KCWZhz2kMZ0jLocxsVKTTBEbj+pH6XIY23DUfcpVDK+Aq7c1/nEMqE7UZU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+wi9160Fx+PQdftGKCvGWErjIr84An7CrSsmdD3jCx05kUrzA
	ydfBIKt9GqM0MWa5QGrckem8Bmz+dTsisKg1brhmdXBY67kgOvM/ky20B2oP45DNfA==
X-Gm-Gg: ASbGnctZEZ1zIiiNJNwvVVeHdtyYwP5qrYZ1iRDnMxDvdTHQEzP6bNNCgrVv4+PXHD2
	OMYktMxSrJ1ajzthvYIQd8zfqDDWL3qaxnw/YwGx+c9fSeNX4v7lZNdWv7Rz4W+KJWRZxhhh4qy
	BHN4BkGPQmcs7HQDYPi/6P+imeeT9Sew+fSCoKq82aDreLOgcMSuQPsNsrHfiVyOrPFk8hTs/u9
	KDIifXuK10o3BnRVHAjeOTionq57+gcmxreWEKGcf1aMrYBvpe1l5fYpAjE552SdXHUTt4P74Gz
	42i5J35TgnLl1Xjv3tirSw9x0KKJfsaDbtxkD1wmwxObJKRA2P8srg4MbcV0BSoAcOmhDpRAMY6
	FruO5GTKhTBgBq3160kOinz/sow8fljVTomiJYrAox+gZTtug6m9NcbDIItT1snhFW+3aJX1tyW
	jT5RI/v62+5A83qAh4DLfuEJMUbUav0K6sNwCiKjv7oi2egeYwETk=
X-Google-Smtp-Source: AGHT+IGrCmJXKAQtdU3NALKnC/NLtRATjkDSaaivHemq5nPaEpusucmf2NZ3eoouqNk9cTRRShNDMA==
X-Received: by 2002:a05:6a00:6fcd:b0:77d:c625:f5d3 with SMTP id d2e1a72fcca58-7e2020650a4mr2076684b3a.1.1764838826661;
        Thu, 04 Dec 2025 01:00:26 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:803c:ee65:39d6:745e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e29f2ece66sm1483482b3a.13.2025.12.04.01.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 01:00:26 -0800 (PST)
Date: Thu, 4 Dec 2025 18:00:21 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com, 
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com, csander@purestorage.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH v3 8/9] zram: Replace the repetitive bio chaining code
 patterns
Message-ID: <d3du6mmazbygxo2zkxqjxamfg44ovrfiilbof6rnllfjzxnnby@becwubn7keqe>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
 <20251129090122.2457896-9-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129090122.2457896-9-zhangshida@kylinos.cn>

On (25/11/29 17:01), zhangshida wrote:
> Replace duplicate bio chaining logic with the common
> bio_chain_and_submit helper function.

A friendly hint: Cc-ing maintainers doesn't hurt, mostly.

Looks good to me, there is a slight chance of a conflict with
another pending zram patches, but it's quite trivial to resolve.

Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>

