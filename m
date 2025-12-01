Return-Path: <linux-bcache+bounces-1302-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C60C3C959D3
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 03:49:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B1F9D4E0659
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 02:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464BE1A0BD6;
	Mon,  1 Dec 2025 02:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G08+8BpI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7F443147
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 02:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764557395; cv=none; b=ELnpn2WAUf/k9tI03ctx6PerCkNf4ku2Kv8ktjAHtQUSaKlh0PDdOlxNl7yBuTpcC3gZobblEGNKdADnvhuTwJAt0s7VAp05aRCQ9dPxU4Ddt/2nnVF6fvK9OEIecVwF5vLC+8Wz5KHZaakr7HaicWbP/6kYOKX17pmxouXomXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764557395; c=relaxed/simple;
	bh=hYkEJxVrr6gPeedbWPWdpq0mOw+kd5SNTJlObMvF+hY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=G9N6XgSrKGPVdmTc4cUr83U7CnWp1I2uT2bMkjIW/gfY2lU1SGFulYXPuXOStqu/3w36F+lAuFE8FT31cewgdNRL4CjOEB+2WLmGFhqQ7UbiOwtoGZWXi+bCpmdtOuBkN+hJTf6rsKF1Kirtl1kejM0ScVz79wUSgt81NEzzsgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G08+8BpI; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ee0ce50b95so41812601cf.0
        for <linux-bcache@vger.kernel.org>; Sun, 30 Nov 2025 18:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764557393; x=1765162193; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hYkEJxVrr6gPeedbWPWdpq0mOw+kd5SNTJlObMvF+hY=;
        b=G08+8BpIOkay6R4TxeEfs1UO1bT6utSL8C/9ybmBuwSc9qgF0MKy8TVvy12viWb/Rk
         1dMc6/gB4LfOW5Hdf7kDhT0K7CKvjBjnCO+Yqm74TOCZeg7xAthQmycKDPne5G1VlZHU
         VaDPavtUBa2iDBwdE09ZMoskebHH0k3JJ3WNsRsqu28zQZYQaoUrUN5B3hU8YqamOTRH
         Ozo7pS+LHkdPb+g1BxOPgPSM+WNhjs2fkvBekGP4LhLkjh/8SGz++3GWhcOIA5g4/fA9
         3NCbkRPLzhLylzGrQXj+AQ7Cuc+4rh76DS6JEM5BZMo/qN+XxHBorPjdBP6uMuwbnkNM
         22Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764557393; x=1765162193;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hYkEJxVrr6gPeedbWPWdpq0mOw+kd5SNTJlObMvF+hY=;
        b=lOM1a+wO3bCR548sd5rr015Z9QPkIA712eHKZtNNTX680VHKEWQjY/oFxr9upVL1D7
         Pyth67Q+2RmQUHniIGc+u+p8aIkQa/10SLlccX7ZHaiv9j60h1F0bcKwn92CoMfsACC7
         OuGNL5y2Ni0RrWzQXmbGeX0tA0U4LzCp5FImLgwXR3WJs9LStnz9iLaF0eJExI8qA2rd
         UKFFd+Gf1JyTUzev+Bs2Juu01Z7wVpPneVyCfmrq5ww/+IJF9g6GEY/igzBPT0WVUZ2q
         mIu+zRTpVCh6gT2fz9/WNXEqxdrUGUorlYlJhNdIoGEOBh3ceZkiLqj9tByoLXHh6PgO
         xSFg==
X-Forwarded-Encrypted: i=1; AJvYcCUPPOFlRRJY9lwPyoHtQH0j53QM+BvHbw9fhJa+6de2S4w8GyHEzuIsLhZu4aaDWjSiz95BiHSwZBHH4ss=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcOLTHWO8F9vJRqtcfgOxW8nB7Npl7R0+EqN4RWYYfk4Y2bWEJ
	nMyIylo4ZJ8el/glx9OKjm3YwDPMY6VroDR7ZASSAADIyuf6gQ/6qxLyMbADwbjtjI6QUZDnNvI
	JZ8qejbzzA/PeMDGd0XHTpTh+6N6cINU=
X-Gm-Gg: ASbGncvhj4tqquBQQ5jBJ8TLlhtePh0ca1fHrC0oA6hSljm1Rgk+1powGK+5JGVdenr
	FO5MbdjkbvnSX0ed0hvJD55IfHrEZGtXh0eCBSTnLSAmuIZtMeazA32GH8ALv50/BX9RMQNjWqk
	Tbai/TV/tJrgCeTVhh1a6zSoubVNQYQZgKch3btwZcaPhdvWbnbmUTvzGiXTv5uaofDKaVqJ9wa
	NGf4oe+fDFQIwTIl2Y2XzIphq6q8TCNmVX/eIMufW9YZM3pF9R8qh8vHSJtku83812wenc=
X-Google-Smtp-Source: AGHT+IHMHWZUpIKd+U2gvM8f3QvXs4CC0pyopjWK9dMI7GD9DZxVsJO8lLrq5dpoyZwFws+kCu6JW4osX+zGhT5svzg=
X-Received: by 2002:a05:622a:1a9e:b0:4ed:806c:69e2 with SMTP id
 d75a77b69052e-4ee4b418e8amr556087811cf.7.1764557392655; Sun, 30 Nov 2025
 18:49:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 1 Dec 2025 10:49:15 +0800
X-Gm-Features: AWmQ_bmP5hMjMgqU5H0KVWtv-n5YkyzDiO8iqPzfWNNMOQJznUvcruZT5FUNQRE
Message-ID: <CANubcdUGqYsaxsd-cUtjhtCSL4G1kQGevei1m25qKm0ip0-i9g@mail.gmail.com>
Subject: Re: [PATCH] bcache: call bio_endio() to replace directly calling bio->bi_end_io()
To: Coly Li <colyli@fnnas.com>
Cc: baijiaju1990@gmail.com, Christoph Hellwig <hch@infradead.org>, linux-bcache@vger.kernel.org, 
	linux-block@vger.kernel.org, stable@vger.kernel.org, 
	zhangshida <zhangshida@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

Hi Coly,

For this issue, I've previously sent a fix here:
https://lore.kernel.org/all/20251129090122.2457896-2-zhangshida@kylinos.cn/
Would you be able to take a look and see if that one is suitable to pick up?

Thanks,
Shida

