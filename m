Return-Path: <linux-bcache+bounces-1150-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C34FAAF5E61
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Jul 2025 18:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A315C3A69B1
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Jul 2025 16:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4412D372C;
	Wed,  2 Jul 2025 16:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MQzdi4h9"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDE9272E60;
	Wed,  2 Jul 2025 16:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751473185; cv=none; b=niKY0f0DuqQd3LIyLxVGi7CMNo0lL6lOv5kzbopsvw73PHaEG0+AXRlDe5olAhdDYpepEIGml3QAFjHOLH9LLeUCCqkovB4o+XiEL+FF06G9rnBVyV2I8urfeb9xYnQNORtAdjbiMCgocSIQJVCSQ4vgIE9lxlbhatB6NSvqWG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751473185; c=relaxed/simple;
	bh=eJHOQtqA3xF7mK33ylDHVOemht94RK//ALIurEx23uY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=VCes2aBYbUcpUWsFduv9Tnn2A4xu6a8TUa3VZ1v0wP4p3uQbb9QShhiNOTRuSbFitjCQ6VK8+2rQyLTDgBgUKqaoY6yoNWhX2WlERaKdh3uMhe2zojfn237zM+GslcXMA6JcuEYb0Wbco9hm3y/nXYvZ1kLUk8QaTEDvHALRbVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MQzdi4h9; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-236470b2dceso40329085ad.0;
        Wed, 02 Jul 2025 09:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751473183; x=1752077983; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UvuwG1BeX3SmP91n5grjnwtkYnE0lIY3xyC/GFoKlQU=;
        b=MQzdi4h9Sty2K3fxtd2fOmFgSizS4WYruof66bpOp9nJ6nb5sxra15trxKaY4wfD++
         G4TRnUvc83cm41s71RAYRxC6YWGK6NPVAA/WASIIIRZljcMGP/8XhJ1iPRoVufIUp/Hz
         pCLvIQWlZaO/8Z375Yit7Z9WKzTEjYSvoAlUEyiW8Y9ofAbSTMBRpaUzA9muIfmxetre
         JWDmNc/02IM5v7e9Wu0vcnsSZJ0pvv1nOzxV7VapqapDitt0O0ZI0fXefZnHAcXFLtEe
         dFNgyUZW8l0Lj5sctlfeR6Gx1alSzbUT8jZ+SbufFrpIPxpqkixNAM8221EbEJB4mN6b
         0F7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751473183; x=1752077983;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UvuwG1BeX3SmP91n5grjnwtkYnE0lIY3xyC/GFoKlQU=;
        b=irr0oEDgQKiYiLjAXi2CHQ51k7w6gF9m6M4baBO5LtXm4UpMYpzq3niRPU5o7FqikD
         5ur8/UX0tC+fQewiH0iObYnviv3iSdtr86O08JrVcBXGLJp4x5W3uz9Xn//+D0CyYXwu
         1HsYXYjyI75NQpwKjExyXVwAGQ6pAXzXOR3Vj7Fr8As/L3npFlWgatUuq98KN0cEWOqS
         Dn93YVTYP31DhFdqg4FNxiwnmoWP+GcIxtbCDmTiOFi+X4sZ0bkujHqzvQlYhzAE3cr8
         OMkzbg+gqqQjQ9wFYD94pqTT663IOXyiN+yrVNneNxzX8nmA+6OBNzoZFhjQR25FZbB+
         7XvQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6GlkCjg8pW5GgmYBlDUiNAbr1N10AojahPuIeli+RvaF8MAOkvi70T/mGbj/02QTPb1+at/Cw7wLplhY=@vger.kernel.org, AJvYcCWfeqlay0S9l8vh/Tw+jw6hVqxAI8xZeJvl7OX3ZB6KNWL7JxfHILlh1yTa5WqqyLPWjX7jCf9CoWVt7fE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY1twGUk+n1nGaDLU82JE+KrVwmzGJayuTDE3ScEjHJP1g6ZDV
	vL16G0kbk6ZumXoFMF8oyU4XQ7RelrdRPBkgeoy2S2iiEMl3ha9vnaTl6A2tP9kb
X-Gm-Gg: ASbGncvwqNd08jgwLt14z4Me48REKwKUbP4QuZqJANVYrBaZ8LzL+iM7VyImQCz5I1a
	uSVaTUWNtPKVQPS/pJxJIgrCwjj4utk+W3yao0bkswcVyELCWWBN5+iKacOChpQJirxzMo1k2UM
	T8eKndcARAGtBTvVSOPOsY10WgoCL5Kacx4HIppnR8vj6ZND5ALpPFHiFP4wdFgFP59ujgitwt6
	dnnKvnJIhj/pwEY5s9oWJZJ0aUN7KA3Ia9pqlAGBDXp4e+wOE7n1nVzEd6ZosipciuUObYyHg5A
	zUuV87WMTdyo3nBj2xnh4L1S6p8AONo3d2LwMWX1lGJaecqGIg0gVQRiEJ/2+kt8a9VzpZRd90V
	aqEo7fT9e4fHKCbPG
X-Google-Smtp-Source: AGHT+IEVAZYCl6bKVOdoOvyjbF2Fqsrp72OI8nq/SHLXyB6iz0D6CrSxMKthrj96isA6mCbUNOGG/A==
X-Received: by 2002:a17:902:d487:b0:234:ef42:5d69 with SMTP id d9443c01a7336-23c6e5007ecmr51878625ad.13.1751473182906;
        Wed, 02 Jul 2025 09:19:42 -0700 (PDT)
Received: from smtpclient.apple (n218103205009.netvigator.com. [218.103.205.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2e39besm141816475ad.13.2025.07.02.09.19.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jul 2025 09:19:42 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH] bcache: Use a folio
From: Coly Li <colyli@gmail.com>
In-Reply-To: <a741131f-b06c-4565-974a-f2c1a45d44c6@kernel.dk>
Date: Thu, 3 Jul 2025 00:19:27 +0800
Cc: colyli@kernel.org,
 axboe@kernel.org,
 linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DFCB60F9-C0A5-4E89-A0F1-8B48575CDED3@gmail.com>
References: <20250702024848.343370-1-colyli@kernel.org>
 <a741131f-b06c-4565-974a-f2c1a45d44c6@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3826.600.51.1.1)



> 2025=E5=B9=B47=E6=9C=882=E6=97=A5 21:49=EF=BC=8CJens Axboe =
<axboe@kernel.dk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 7/1/25 8:48 PM, colyli@kernel.org wrote:
>> From: Matthew Wilcox (Oracle) <willy@infradead.org>
>>=20
>> Retrieve a folio from the page cache instead of a page.  Removes a
>> hidden call to compound_head().  Then be sure to call folio_put()
>> instead of put_page() to release it.  That doesn't save any calls
>> to compound_head(), just moves them around.
>=20
> Really needs a better subject line... I can do that while applying,
> however. How about:
>=20
> bcache: switch from pages to folios in read_super()

Yeah, this subject is good IMHO.

Thanks.

Coly Li=

