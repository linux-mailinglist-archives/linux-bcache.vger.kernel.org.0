Return-Path: <linux-bcache+bounces-823-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5FF9EB5E5
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Dec 2024 17:17:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 675D9281E52
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Dec 2024 16:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECDD51BEF70;
	Tue, 10 Dec 2024 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nka1w8jW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40211A0732
	for <linux-bcache@vger.kernel.org>; Tue, 10 Dec 2024 16:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733847464; cv=none; b=mQ0+Zh6gaZbGH+rudrT2COb3beUFrqN/00xec15t55que00+DH8UUQ1oile5+xN+D//5Qlov+RevjbMkimIGfOD3P+0rwN5Y8e1YNlu0tYaZcgctW5WYkRhcbQmqt2obYh2nD1ypzzm9b0/GOHvhxDA5i4DvfjV4GvhmsC4IxB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733847464; c=relaxed/simple;
	bh=WFGbp/rJV46bRkoFg19L3FZC6MzfgqNyYAz3I0W4PEI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Vvns7RJZwc+Q7hpmhlE4lZJENiCkA5atOyXAAuNV4aEfU6OgMd+djuWfTnxbDgQWLLlhBy3lOsxF9qLgIt+Brgerk3srRFvk9GIeIpx5Shc0iTjx8ncePucUpULyGO6J9wkYU+wYMYK2z3o7Wr5O87cHotRcPW+DctjoBXGG5ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nka1w8jW; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-29e998c70f9so3193187fac.2
        for <linux-bcache@vger.kernel.org>; Tue, 10 Dec 2024 08:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733847461; x=1734452261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtugL1GOMmkuSroetbFeNzVAId+uZTGj9FtiYpIZXco=;
        b=nka1w8jWniSf5XnKtkJrN8MeuMrQXTpFokDRq6p+sRt3Q/cV7g9lESNAR99PjJ26PU
         Au9afg/1qCRQV9nGfbp0m/K5VzuXaxNxlhWNfy1v6ebuoTSr8AtZVxxj5wBnrbBzPAOd
         P/G+5h/uEKIBiDHqIQR0UxUNLVQ6wx4HarJpf59eqeiDbKY+AQjC6GAvrtd65k/3zYhB
         OD3sT6CGpt5V1uAKorf5qSWPWf2ZzVNfAZQu+RqBIng4YAuE2UiEAXw0UBBEFgyv28Jo
         94UHUyNJ1NRwqYrT0H7pGjymEJOQBaSZLa8NAF4swczy5AJl9TfhYSpnNPUAvAvY+HdV
         mAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733847461; x=1734452261;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TtugL1GOMmkuSroetbFeNzVAId+uZTGj9FtiYpIZXco=;
        b=kuOi+WR6V0yvoZVS8hwahqQznpyxkZnakEQwHdZ0nP5k1SIwgRmY78UpBOmpYAdja/
         uvVfBTRWCGVPPwoIIo56oR4ivON/yUMl4Eu+kbzYtmyt0keyWQD6nr4ObNVuRhk4tHMr
         Qnb/7rZ7DJ9zGYS4JZmJMGpLXged3R1bTI10hbNIBrdBn29PI+Trjsdgxp2Ld9jZ0CQP
         46ZIKZVfFdwjsh8vzc3HJOR3I41XtIHNYokCFmAknHH+M2xOC3bq9xs/ziTcXg6fJQSb
         D6QAQyeyCFHGUoxeVJdmWLh4cZVUetgo0Ekd6Pzyo10vjux1eomSefJBjoJ4/mOB9zQL
         bLJg==
X-Gm-Message-State: AOJu0YyRootHWg3z7Y2GoUYrjOnTHqy4LXy/1FtJAl5MbyaOY3qxqUqN
	rX8vpGz75sd6J2Y+YzqTcJrpoTp20n1j61RggeEfWQpwEmVzkZD4UCT0sFXNdx3oZAf+d4i+SER
	x
X-Gm-Gg: ASbGnctRuKzNa/+rK7p4tzc4BgW8JhxZhzJLDg2V0luICqQkh8kNXR1moigQ9XUWvOt
	o4O5ivYBSP5qzBVv8ckMuj0S2Wlj0Kv5B4N9LpgSoF7sIPEVZHIlt37UkH+Lqq1zwJ4cpg9PbM7
	oMjN4zcFnOi3w8EZIZO32BiMsPEfC8EO0u8wb7KnMHy7s+1Sq7lGFuN16rkvNjaBk2aR0jGJKv4
	uq7wMN5kpZOndNfhrb4jlKPq1ovNldXwJKzjZnTiIUZ
X-Google-Smtp-Source: AGHT+IGVY/C8GN4QT+IFfl31u/lE/DASrDNbbdZOWmsimrsPCEqJemJOZBakQcoij+eK/vXgBKsQPA==
X-Received: by 2002:a05:6871:358c:b0:29e:547f:e1e1 with SMTP id 586e51a60fabf-29f7389c541mr14202348fac.29.1733847461475;
        Tue, 10 Dec 2024 08:17:41 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f279324914sm2639115eaf.36.2024.12.10.08.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 08:17:40 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: colyli@kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
In-Reply-To: <20241208115350.85103-1-colyli@kernel.org>
References: <20241208115350.85103-1-colyli@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: update Coly Li's email address
Message-Id: <173384746036.444526.10848476315219885523.b4-ty@kernel.dk>
Date: Tue, 10 Dec 2024 09:17:40 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Sun, 08 Dec 2024 19:53:50 +0800, colyli@kernel.org wrote:
> This patch updates Coly Li's email addres to colyli@kernel.org.
> 
> 

Applied, thanks!

[1/1] MAINTAINERS: update Coly Li's email address
      commit: 6f604b59c2841168131523e25f5e36afa17306f4

Best regards,
-- 
Jens Axboe




