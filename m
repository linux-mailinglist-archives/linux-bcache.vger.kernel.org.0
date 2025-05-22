Return-Path: <linux-bcache+bounces-1077-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E50FAC0CD4
	for <lists+linux-bcache@lfdr.de>; Thu, 22 May 2025 15:30:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7072D16EDB9
	for <lists+linux-bcache@lfdr.de>; Thu, 22 May 2025 13:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6C328C035;
	Thu, 22 May 2025 13:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EaKwX2/I"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABE628C5CA
	for <linux-bcache@vger.kernel.org>; Thu, 22 May 2025 13:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747920607; cv=none; b=HNVvcYHliNShgMGqoMD+F8qjdhf652OyGbbJVGFJxAce+8rn1N76FoA+q1cv5E4/FQg/KSj1p1XnQ0EkZiKpoUTcup0K/wqWDWtjm3TO8UJs1wsM8+CN6fbXn9NjMsO6Rb2u+uirT8p75JYzAB/1IlJWj1lP58m9puJsGrjRgMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747920607; c=relaxed/simple;
	bh=NHyEFssMjma0bg2s2drOqDgNRfGG15lqfqeZ7WbrMPo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=WSx0Bur8FBbipaZ8Ag1OefXQoBrajrvd2q9rPanEIUMZ8dQSrAxiMqV5+oWqkNGcmFJ+SktsmYa8eAxj1c8QFOoeNZtC9Jml8V2MtffWHBpXmDBqR7tafwwmEwynl+mCuyOyOelbg1SB0SD4PvbSCiDXamw7v0OOylGLjhAuc0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EaKwX2/I; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-4e2b21d1b46so1113873137.3
        for <linux-bcache@vger.kernel.org>; Thu, 22 May 2025 06:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747920604; x=1748525404; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tx8vZFDZpMbO+Kg6fLcfBD8qiDuWKhB/aBNAjV7446I=;
        b=EaKwX2/IRpfkrQbTFAjDRxBJ7OQS0h4443A7c7TDZtCp5KEtCoLMDF2VL4pBqlKL9D
         tGy2wqY0bMEwsteK6PPwQDpux4qeeGkVA1M3/GC0Z1yiwisxqtcvGhKNl56fDiRaklXJ
         Qj1IAcmtolJsMM/q6Wb4XxBA+zJGjYzi5EeCneLBeqgsYwiTlFFTmRbDKlg6jY+DPKRB
         p2BuiGRs5rq96K3SH8Aorr22HY1xB7LLN26xqZh+5XNPkCaw1hILN9ZdkTZZZvvQ0t74
         QxVwE+/1ogTDWxsWdANY/YYvwzIC6O+ZQkAy1IHshTrevC3cQ+OgZkwKTP5FhW3ZeVyG
         PxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747920604; x=1748525404;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tx8vZFDZpMbO+Kg6fLcfBD8qiDuWKhB/aBNAjV7446I=;
        b=v/JYTZ3GYmgLf13rZW3EKRuh426o9iQs5XdgjHxUHpga3Ufb3Wdbb5GQXZ9G9RNV7f
         viLZntYuVjBfXqjQucg3JtGA1swGE9lPFj/9OIdAz20YVnhHcxTl+LC9RWBBZ291JfmJ
         Du5tFonV7eYJ9HmGbwFRTT5EGC4S2t9ig9gJiF0sqAudp7O7yknmo+clBzzx4bnGMeUD
         Mv7ivbrjeZ8xS7Hc1RICte3zT97kytkJrQw/syKLN4lNKoaaS74RqedeF12cMHcOQmVI
         iZSkwHI/YxD6JDoxyU3nLgqokK+Jc2YaNx6bCMLrtjMxOuOK7ft1sAhw3ZktkoeyaHeE
         sPnw==
X-Gm-Message-State: AOJu0YzxQSoowntJg6+C6FkqUj038ikdpAfsYvccx0QViTtcOPvV8A6q
	jvePzfYfuBV8hIbo7R49sienujWhwnCroJWS2IMTmyk+2HGTIbuaxLVvgs2YOd27Qq7PIWhiwL4
	RHWM/VrThkT4HaUzctfS28Gl6DsDrMC+EUxDQGJRmj/bitlqpXlU2X+Q=
X-Gm-Gg: ASbGncvoJW8gBDvUeqepQ3GKpj+FE4UDNMRVmtuFHk1zmh5yw2G4bF35Buf5+WWYwng
	bweX3YRP2ZQMxNjwki/wf9N44vmvmhwmWiRmwB0p3XJAN6dn+Aig1TqmhV8dAf3Sltz1iX21heE
	6TpqoZFDbKlIl2BEM/AiJO2xsr0dEnliB6UN+t62VxONDLpnSAfx3QCrWkSRQN2EkjuA==
X-Google-Smtp-Source: AGHT+IGrsi4YeCwF+gsQk3AjFpqFQrgmg+CFW2hddWEvAMNinJZ1EJNY3oA1upi+6Yf3kxEJfATUWZY7yhYbYr2g7fA=
X-Received: by 2002:a67:e701:0:b0:4da:de8d:9e34 with SMTP id
 ada2fe7eead31-4dfa6bfc5b9mr25918306137.19.1747920604094; Thu, 22 May 2025
 06:30:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 22 May 2025 18:59:53 +0530
X-Gm-Features: AX0GCFvDM2W9SugJkICsPS9liVtWMt8HZYA63Ym2Osx1MzkHItI7ZrZ35OaG-WU
Message-ID: <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
Subject: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is
 larger than 2048 bytes [-Werror=frame-larger-than=]
To: linux-bcache@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>
Cc: kent.overstreet@linux.dev, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Regressions on riscv allyesconfig build failed with gcc-13 on the Linux next
tag next-20250516 and next-20250522.

First seen on the next-20250516
 Good: next-20250515
 Bad:  next-20250516

Regressions found on riscv:
 - build/gcc-13-allyesconfig

Regression Analysis:
 - New regression? Yes
 - Reproducible? Yes

Build regression: riscv gcc-13 allyesconfig error the frame size of
2064 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
fs/bcachefs/data_update.c: In function '__bch2_data_update_index_update':
fs/bcachefs/data_update.c:464:1: error: the frame size of 2064 bytes
is larger than 2048 bytes [-Werror=frame-larger-than=]
  464 | }
      | ^
cc1: all warnings being treated as errors


## Source
* Kernel version: 6.15.0-rc7
* Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
* Git sha: 460178e842c7a1e48a06df684c66eb5fd630bcf7
* Git describe: next-20250522

## Build
* Build log: https://qa-reports.linaro.org/api/testruns/28521854/log_file/
* Build history:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250522/testrun/28521854/suite/build/test/gcc-13-allyesconfig/history/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2xRoAAw5dl69AvvHb8oZ3pL1SFx/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2xRoAAw5dl69AvvHb8oZ3pL1SFx/config

--
Linaro LKFT
https://lkft.linaro.org

