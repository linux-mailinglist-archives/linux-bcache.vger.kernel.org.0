Return-Path: <linux-bcache+bounces-735-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE78984CDF
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Sep 2024 23:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7501B1F24B05
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Sep 2024 21:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13D3146A97;
	Tue, 24 Sep 2024 21:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSpF9X1a"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D4E13E043;
	Tue, 24 Sep 2024 21:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727213089; cv=none; b=K1L4zOW9TJh6a0DiN1ENwiN0pvSpwTAlqD+H3RnNFdFJSpk5xOYHNmStoKQKiAFznWNAu/fyrBDQsYfT87Mt1QPzZuKifmMyQhp4u/ZUYogt1mWmEyEJx0CMsKjvp6egLuhkGNnnduNGdO5XKeJRlupECqsxSeIAaHV4GayN4/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727213089; c=relaxed/simple;
	bh=Se2SeyxPn1YF8ln96fxH093MbqW12GotKj2gD9ytgGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BtQyR3xG3L4KIgISzBJi8pdqFz/pQJdqBwil59yLXZXWl8ozeUX1V+2THHj0zGa1fHaQfJ4XGlz4WouvZsQC8CRidO5FWM1ni2t7dVjHRaqF9XvGmut1/O/cDZvGv7a7pHWQcZVMZcSUEaVzqXBfJEEr2b2aNTU9nTbqMRDqswM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSpF9X1a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4994AC4AF0D;
	Tue, 24 Sep 2024 21:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727213089;
	bh=Se2SeyxPn1YF8ln96fxH093MbqW12GotKj2gD9ytgGE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GSpF9X1aEP5ShwEMMdwzFGiXnTFSHDwRhYQxUZDvuKGB/nIhnq2QKeyZ9+FgwI3J1
	 MzQ6/uVcTfvB3PunJtfDAdrckXJdkweDYmb75mBHb+PiQZz0P+vQ4oTcdHPV7I8PTQ
	 U/OXAIrJR/DibW16WO9FY8cpcYnDJSZcIbo5quVX2XOjRmUmk4o4s5pMKCl090hgck
	 VFknEatVJilOvb8vOgbZF0SwLEHhhvQ039Asq0/OE/krJKYdA+DKDq/OEJ6mKWkxFs
	 +BQHRQqBvW70ZPVC34LghNYRoq02iWd5vrnHO9uhOXdzqEfb6ghfw1gJ1vxAslohq2
	 LyrgXavyywJ3g==
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a046d4c465so19598485ab.3;
        Tue, 24 Sep 2024 14:24:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWMG3gCgnoh2ApWXsrulmFYAh8ELLf9pr7p9li1YtpeIu++rqwpyeH89XT7FXCUzimkw/UUd4l8KwwxMw==@vger.kernel.org, AJvYcCWMcsn0ym0ta8u8VP8HfomgOi03Hheord3pwi+i/za5a1S3FXtTIf9sWKeZZx7al8vERcc+NP0MoX8cpDFj@vger.kernel.org, AJvYcCWSrXYeVYYmqsGG6hj4m/FOYru4ezU665TP8WshYKYe4mP55+hAVfmJt5V1tmZACFWNxaw47jnsNH7uhaM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb5O+pJeUXcVkUYFJH406R7EFZXmVYnfqP83hDVajnptsZ06Z/
	QhrTsec0142rSb2kQERjfIlu0ITRPnuAMK5eFVpxfkUs5rSo2JM0BSCI1i7nwPAJY8nBNkzi+nz
	RqW9t1xN6vbRMTb0iz5MnOUhZE68=
X-Google-Smtp-Source: AGHT+IGDkW7WD2/JzFxCpyUwRB5/+sUMgv4hqELdvS0oE8C8Gvs3vzZAdADEd3f3M3MN9EO5an1dEVTf2Q18Yg4o5dM=
X-Received: by 2002:a05:6e02:174a:b0:3a0:aa15:3497 with SMTP id
 e9e14a558f8ab-3a26d6d97acmr10177795ab.1.1727213088499; Tue, 24 Sep 2024
 14:24:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240924091733.8370-1-shenlichuan@vivo.com> <d95d7419-7bac-802f-a5d6-456900539c32@redhat.com>
In-Reply-To: <d95d7419-7bac-802f-a5d6-456900539c32@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 24 Sep 2024 14:24:37 -0700
X-Gmail-Original-Message-ID: <CAPhsuW51S=WfyNoP_cWvNVq3rPW0+iBrhzRVaKK=q3PLRA94UA@mail.gmail.com>
Message-ID: <CAPhsuW51S=WfyNoP_cWvNVq3rPW0+iBrhzRVaKK=q3PLRA94UA@mail.gmail.com>
Subject: Re: [PATCH v1] md: Correct typos in multiple comments across various files
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Shen Lichuan <shenlichuan@vivo.com>, colyli@suse.de, kent.overstreet@linux.dev, 
	agk@redhat.com, snitzer@kernel.org, yukuai3@huawei.com, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mikulas,

On Tue, Sep 24, 2024 at 6:30=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> Hi
>
> I've applied the device mapper part of the patch.

Would you mind taking the whole patch instead? You can add

Acked-by: Song Liu <song@kernel.org>

Thanks,
Song

