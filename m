Return-Path: <linux-bcache+bounces-1332-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE4ACA3064
	for <lists+linux-bcache@lfdr.de>; Thu, 04 Dec 2025 10:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92BFB3020C7C
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Dec 2025 09:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037833328EB;
	Thu,  4 Dec 2025 09:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MnrUlk3r";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rVIhqCbY"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A643074A2
	for <linux-bcache@vger.kernel.org>; Thu,  4 Dec 2025 09:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841025; cv=none; b=gNBCgFgfGGAqRSZ1SZ4UmV7gD9ptEo3aBIsXO3GHcB/Ld51Jm0/MzUskYUD/8RGt6mB4E3FxSnNKMu2Rrwbq2/XQyVJUnQEulW4bL6lTMEy6A688INg8MdQwh97MbgQWQAuWCOB6+z7tk7xcKsFb/wx1qh9tuCypHCS3vfEWx6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841025; c=relaxed/simple;
	bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fL/EomNXC/ObKdbBwwJdgykERUznWrwxNti8ylAHVxSNfi5sNjZHEnMeqC4eefQg6vdtomPx62wSYMTp9bhsCc1hcDwAwq4dn3oR90jplEwUBzIN9X5c3tPXFMiqdTPzdgk3xQVz6YkiJc3NtVO2edpv107H6xaFCa9+ySy0yaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MnrUlk3r; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rVIhqCbY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764841023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
	b=MnrUlk3rZ3itfapUBEA90V3po8H4Wu4WwjHa02o7cr42ekaZPN95keGnEapTMn0+PZXlZg
	iwvmOeGCvj32XcNy0S5jA5ZkuhFMwKQIg4bp6r5TxLX9cs58R65H4bjSBrKzo49K9YEX7T
	wRXTajkakiouFcUwsLELzmvaEGEsjR8=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-mXCiw3MkMr6WRpHyo2haHQ-1; Thu, 04 Dec 2025 04:37:01 -0500
X-MC-Unique: mXCiw3MkMr6WRpHyo2haHQ-1
X-Mimecast-MFC-AGG-ID: mXCiw3MkMr6WRpHyo2haHQ_1764841021
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-787e3b03cc2so10651707b3.1
        for <linux-bcache@vger.kernel.org>; Thu, 04 Dec 2025 01:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764841021; x=1765445821; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
        b=rVIhqCbYJIshhr1SDoAzl0uxJ3l2OknzAacF5X1A0A8YSzt91sa5gVt2s2Kp2sWJB9
         Hgli5ZUl4CsxXmvL9tdbhsJry4TaLBE1C++twE7VZYk7+QzPkxNO4ooZGrS+nj2wZSDL
         6meyQgb+gtMBIucQ2xdOnMJ7o7G85PNDylK1hou7CxAjlvuRKlt3ve4UZRm9l73ZKBPR
         nf2rxHGK+5fX7U4j75tPudKUs2dYi0ismLtiSgvMKI6Zjz1HWz9U7HIQHsH49JpJEvC2
         GIdg/XBoZgwdsvkaWHa4+lJkRE3yiX1xY3S4HnujXpX6oHd441uW6MMSzVaiXCXoC4mh
         tYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764841021; x=1765445821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
        b=VMlg5B1kYAZZQ7gFwg6VWO3BPgwxP7NnLBdtxXeN/CMyHXf0G/dh0LZLVEv9N8tas6
         H+rT1J4HmgaViCaxJxA2zS2BE1lNDNQ87/az6tMHRRTkspz1S0Om5ez2MOi2/GWrI1kW
         w409yt5t7KsisxGJbMGP4H9mDEPIqErctNRtAbNyHtvFW680n1FEHtHNzBLDOlGnU5de
         5UheySvp3bc/ydM/WtVbXGlBdLdr4XBl6bWfk31DSvSHYIL5g1yNjuvUbIw1HMeCBE0N
         dsYz9PF0gyqA7VnyADu9t2dt/WEIvRp0OcTEZg3ad5pd9sdpf1oJnj5vjjjnDWlxqr+E
         o/LA==
X-Forwarded-Encrypted: i=1; AJvYcCUIjDlgCdNS/5r8K1XpjzsnuGORWN6vSsXofQCab3wcppV+ErScP0RUAzrC5LnoWww9nPrEFLT5pbuBD6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0ulzkU9QqXJ/zRI2rIXAEjJLyNCe8rXYS/cPP14Dh/0j/EN5K
	A4Fkl3+wlsVG7VE4KRdoYHSrOKXq7gV6swoUuEQiMycDUvYa+ziO4SmVcpklXM6o6zMjBdhyFqe
	5/I2Q3kuCTp1jbzHOqELbtVwtBqXh7jPZcDJFUbyG/urP9uleDgQWjTPOkDkD4ON1Pc4CJmbv3D
	ognzpXF4nl4rxOJvI5GG+mQIsnJk6ZgbvV5viXgYZP5jTVrTiL
X-Gm-Gg: ASbGncsqFLumQTDNKY5cRd7E9tDxqD2SP4fNHvXCAsfquFO+ih4MVCMEVhP2fZHw8DH
	tkiWPKYzFwoiCU/KT3QPGxOoeA8gwEo6vzqmckTVQ+l7+sHTNO/BgkXZ1ZdvkG0jAH+dk67GOic
	Ls7Afy/T3VMSjyXY8SJRA9pL5A5QVfbV46P2cmKF1agwPWYfvcFUlTvaQxLXVLH4oR
X-Received: by 2002:a05:690c:6713:b0:786:4fd5:e5de with SMTP id 00721157ae682-78c0c210028mr42666217b3.67.1764841021011;
        Thu, 04 Dec 2025 01:37:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBJRkWOGl554rCJxMS1W+VD+59CzpNDKchBFktxp0UKkP2qgdZoPND338wG5ha+uJ8PPPkfv0dwHOd25ifO9U=
X-Received: by 2002:a05:690c:6713:b0:786:4fd5:e5de with SMTP id
 00721157ae682-78c0c210028mr42666067b3.67.1764841020714; Thu, 04 Dec 2025
 01:37:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-7-zhangshida@kylinos.cn> <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
 <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com>
In-Reply-To: <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 4 Dec 2025 10:36:49 +0100
X-Gm-Features: AWmQ_blRRqbIFTY0f39yIA51TqtDoPBldWIhSqZwhzNWbMT5aHjbQPCsAOYEw2M
Message-ID: <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 11:31=E2=80=AFAM Andreas Gruenbacher <agruenba@redha=
t.com> wrote:
> On Sat, Nov 29, 2025 at 3:48=E2=80=AFAM Stephen Zhang <starzhangzsd@gmail=
.com> wrote:
> > This one should also be dropped because the 'prev' and 'new' are in
> > the wrong order.
>
> Ouch. Thanks for pointing this out.

Linus has merged the fix for this bug now, so this patch can be
updated / re-added.

Thanks,
Andreas


