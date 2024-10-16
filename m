Return-Path: <linux-bcache+bounces-759-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5809A1646
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Oct 2024 01:53:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC6EC1C21B3C
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Oct 2024 23:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B3CC1D2710;
	Wed, 16 Oct 2024 23:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="re9k23jS"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655C9282FA
	for <linux-bcache@vger.kernel.org>; Wed, 16 Oct 2024 23:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729122819; cv=none; b=PXdmlmI8MDlyFBG9FgF159JD2KqJxwlkUcA8omSA2geSzTnvDaR6nYlCvRVAqf8l/G7xdCirIkMlVB0A9OCnr4HMxIfsSlYV0NsU1LUpJyi9UghztaztnBevhO/g2wL9x9P5cxKlHlhgpsqsN6AlUFVsXulgxpirQQV35lwCeJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729122819; c=relaxed/simple;
	bh=pF6hFpiGWzjoSR2ARfAE2ToLDYmWUDSBLdb9wDRcLWI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=qrxl+SGIsatCZMBD/waurle846xMFSYLoEsrXyAPikF8wfqLUPDu/CIM8m7NJ3El35y+NJ0taDDkMA5hq2hPTnkMZnMgsIj5Xw4XkRTsVzDTQdcfB2yWgJW7CTWh+R7y0jau2jh3oSye+1NS8XC4qkS3pDWep0Asr8XEiWex/a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=re9k23jS; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c93e9e701fso5440a12.1
        for <linux-bcache@vger.kernel.org>; Wed, 16 Oct 2024 16:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729122815; x=1729727615; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pF6hFpiGWzjoSR2ARfAE2ToLDYmWUDSBLdb9wDRcLWI=;
        b=re9k23jSaRKSKeYEVg01vsKAzze6j4WSJPl2e+W4F6HpULXYiU+8DnpbhKyiAK5Tji
         5TuV7bxJ9ZJNyCR47+oMqsM40rqB99DaGN4dqkFDnJre1lzdUv3cLbZZMy8u4e2pZ5Et
         BzKc4a0YxEzeGeT0X5f+IkJgBROcM7Tt0ZD+nUIRiMq22pVrj+BgEWRYgaTanfq5NAOp
         FKmjsKrETvg3X8U0UkNND5XLcTTq1pOTnrdzQ/GO1jpFfppAEb/ImmYRoA3LIbhNUXhn
         SC8CmaGHFBg8ME+KXuAL17ILZ60U18LolyJMEzVNPp3mYKmjqaq6RkfeOJ6bZGA6x1nw
         vyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729122815; x=1729727615;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pF6hFpiGWzjoSR2ARfAE2ToLDYmWUDSBLdb9wDRcLWI=;
        b=oUCa+oDlpEApsAI0lxEwxIj0rj8w6hXoVfoNE2psKiUv9n798fUbHSXy5QO59pYvoZ
         WPXZPaNCIe9OA65+k12aBLTXMqYs7Z5eaJC1M+3IpoywRIqkcc+6LnCFEeHQyTRkcrEq
         3XJgm1696DbNLsAzfwdcHYRJRo6eHN9KBdZY9yjpf5B6ggivvzu/PbSwWMDnVrIVNMvh
         jyMqhEFB1tK9Gsrf76La/O3s/A87mSrhaPFF0fjIK7Vdj2MvIr3ZOeF+Y1RIZzYNXwD1
         m7ka3EVj1mslO4Pp92gGIu1tJsdMcPsg65uT+3ldf/FAebvrq82oXkX5ja95yvNb2KNR
         svUw==
X-Gm-Message-State: AOJu0Yw0D+unb7YXu9CoHH/ZEZnVwbsutDv38b6v7JXGTqzWQ4PPQZgb
	a8YIHKoE/wUno7RGXP/KeeF/zyqL+EG8J0nJIm4J5leteTlahygOvHX0e/AZrNMy8yJSbbxnw8U
	f+RBpurbzxxFlNJhZH/NJl4KNzDJKYQRCEIsj5lit51Y6wwCnzsWw
X-Google-Smtp-Source: AGHT+IEuDS9Ay3eq55SNxEbrOPdfwNKPEryeQhZTekExPYVOKY/J4yaLIXctgldPGV8nNtQignwkf369aTTDHJ/ARqw=
X-Received: by 2002:a05:6402:4315:b0:5c8:82b3:9933 with SMTP id
 4fb4d7f45d1cf-5c9ec6e6a5emr97303a12.7.1729122814477; Wed, 16 Oct 2024
 16:53:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Robert Pang <robertpang@google.com>
Date: Wed, 16 Oct 2024 16:53:23 -0700
Message-ID: <CAJhEC045dvCNoiWerk5SJ+EpavDvwPkjsBc4wuKTpeSNFCKDZQ@mail.gmail.com>
Subject: bcache test suites
To: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Dear bcache maintainers

I hope this email finds you well.

I'm interested in making some changes to bcache and would like to make
sure that my changes are well-tested. I wonder if you could give me
pointers about the test suites available for bcache. I'm particularly
interested in knowing:

- What types of tests are available?
- How can I run the tests?

Thank you for your time and consideration.

Sincerely,
Robert Pang

P.S. I checked [1] and the associated docs but found no references.
Nor I found any handily under Linux ktest. Separately, I found [2] and
[3] which seem to have some coverage for bcache, but am unsure if they
are the right ones.

[1] https://www.kernel.org/doc/Documentation/bcache.txt
[2] https://github.com/koverstreet/ktest
[3] https://github.com/jthornber/device-mapper-test-suite

