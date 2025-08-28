Return-Path: <linux-bcache+bounces-1190-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB3F1B3A596
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Aug 2025 18:07:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE2703BB8E8
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Aug 2025 16:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C806026B2AD;
	Thu, 28 Aug 2025 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gqW0fJgs"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D617D25783B
	for <linux-bcache@vger.kernel.org>; Thu, 28 Aug 2025 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756397191; cv=none; b=HabhWOYYquH91X3whQQu95P7MWpbY3EdptL/pt+mIaafxQ3FocSdsv0brcYWISIJQ8c270uNCibMQNp9Ryfy547vVQZ8Z2z2hLu0UoOU6j9k4O+Gfv9q6l/LlyNNyNW8iXf/xnX9fS3JV7gnXcrXvuzcNkiky73RicdwUp5Cy4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756397191; c=relaxed/simple;
	bh=F//I10DGQ3c+0b/Z9jeGysiniCCLugL6GuqwDiDfu4A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=To7zQg+IuJvycs+EjDCLfIxbBgTpoDhAvOGj5R8BLxKHvFwf+Lx30gHP6cjRQVYEenKTs2si3LtCnTun2ix7LcnZZbIqI0XtM2XFW9zX2lyXEF93cUcaXNa7Q/gYJtx9r/MmJS/55K+n2FVLWTm7VxvwwrHtdQejky0ZJNaeVbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gqW0fJgs; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3ea8b3a64bbso9557625ab.0
        for <linux-bcache@vger.kernel.org>; Thu, 28 Aug 2025 09:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756397188; x=1757001988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQ1iBkivcgNxINJNzY151f9lwALON3YL8XgfKRBEIv8=;
        b=gqW0fJgs8ha6cUN1GUJE12BOGPI8m3auFSLy6xdurSNOubKCa20L37Bb4a58xKPINy
         oaJJMDWWN6jm0oIE52zCaWWvC23dg7Tr/mi4ge/Huq0gSogeRI20HIhXzd1oCHSmhfz7
         lDazi7b6n4zK77UWCWxetxdJCrkNqSwAWYvXKgqJsAVz2sIZ6QuEjhPT/H96DiGpUk8t
         rZi4zjo0t5258kUzPNZteGL4btzTMfCHtkthICLi4myp+w1gEBhuk/wOrhzTCB0UWKX2
         1sSx0KhTo+58ap6soFB0/7uHzMCMS30cZDjf2kVRoDcrW0zsyIilhxZq2LvCB5kPHI3n
         Aj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756397188; x=1757001988;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQ1iBkivcgNxINJNzY151f9lwALON3YL8XgfKRBEIv8=;
        b=KwFlacBzkKpAJDptBbYN6IjyR6j/tt1HFXZf2iiaBg+eBcERknX6K+au7UQYOqaUuD
         IJH5Tp+b6Tw0vRPMxMarGfRAJT0dAo/McNCfETW9qe/Xq+pvrAZ90SWL0EqHiz7Uqzod
         avl8aN8oz2exuEMlY2z9QC0ITyL5zOoqJkALKtKTiUcQzpaJn8H0O5Iy55aviXECE/40
         4IvJyXIb80C3MRzqptz1I438WTOhzU/YZ1HKtJ831Kafx9I4n4VegsrkU6oocuX15NC6
         C0EXKPHZ65tRZfHq7smZmAgzjT/4hvFsklR6VptbKCkbNXInxu2YNbz7qKP7/+SOZ1Fr
         hEGQ==
X-Gm-Message-State: AOJu0YwdcT99j7U0xp9GCUr99sGHUrdSSC1cRVWR7EDOykyFEycAGBTe
	7lPmE5MX0aZ54NsMPBmPIPznosLFPB58JLuh+AesXe6lO0w+fMJeN5rRtwvyoIPDCYzi+fiE7YA
	MyyRp
X-Gm-Gg: ASbGnctPvSAwFIvmLgCICwQelZpQduQEhn4i9DZai9ByRuOGK5O/+5gZnRYfDoYWPE+
	M7vd+5X/rg+2lK8d0r6BUgsY4tRJVowiM+MskkR1k5oyjoju5kV9iKttBT2ocf0GqCAA3X4KxHd
	69uVZ8yzNXdwZcp1Us2I0ZLfPqUwi8maqmbx3fmdp0ZEVBg429uZxxSwmjnEhPOD8IZYeMD+VFE
	Vb9gJKoR8HmLGV5pmXlnJj0YdM5fMnbadoWu24Y6OAhUwnJ32xIEGWOetKKlHZbZPefRurCD+Js
	gr7EoRcqHABRuOfCHxkZMIQU7pMKEIdXfzzQKu8CNOEtnLFtGwZydtyNZKvva7zMGmYFBe9pJoZ
	q5DARWCIPNOpWEQRaY7alZjf1
X-Google-Smtp-Source: AGHT+IFYVPLNEA9w3bodw9+YfXXXHlX/wG691OXdZ7TUdqpI2rZ1DapvCar4yq/2nhje8ygl3GK+kQ==
X-Received: by 2002:a05:6e02:1448:b0:3ec:7e74:36bb with SMTP id e9e14a558f8ab-3ec7e7438b4mr206664125ab.9.1756397187718;
        Thu, 28 Aug 2025 09:06:27 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ea4c191f23sm111747185ab.16.2025.08.28.09.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:06:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: colyli@kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, 
 Coly Li <colyli@suse.de>, Coly Li <colyli@fnnas.com>
In-Reply-To: <20250828154835.32926-1-colyli@kernel.org>
References: <20250828154835.32926-1-colyli@kernel.org>
Subject: Re: [PATCH] bcache: change maintainer's email address
Message-Id: <175639718595.484892.13913272754617595641.b4-ty@kernel.dk>
Date: Thu, 28 Aug 2025 10:06:25 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Thu, 28 Aug 2025 23:48:35 +0800, colyli@kernel.org wrote:
> Change to my new email address on fnnas.com.
> 
> 

Applied, thanks!

[1/1] bcache: change maintainer's email address
      commit: 95a7c5000956f939b86d8b00b8e6b8345f4a9b65

Best regards,
-- 
Jens Axboe




