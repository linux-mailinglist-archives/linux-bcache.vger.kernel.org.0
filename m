Return-Path: <linux-bcache+bounces-156-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D2C817D61
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Dec 2023 23:45:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A0E61F236D7
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Dec 2023 22:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF8974E38;
	Mon, 18 Dec 2023 22:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cir2Ky1h"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6098C49893
	for <linux-bcache@vger.kernel.org>; Mon, 18 Dec 2023 22:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-55372c1338bso1475333a12.2
        for <linux-bcache@vger.kernel.org>; Mon, 18 Dec 2023 14:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702939504; x=1703544304; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dEFkGMqGEOddGAHC2+I5Dnup+dyLVF1PGFcOkLtAGcU=;
        b=Cir2Ky1hLqn12v+3tTEg5aK2Me4WW04GSVMAgCr1iGv1nR6WGIGsM5c8g2xfUE7rPQ
         +dMnKgPxAq+wjek2+aprnLeWhT2f3WEpage+FvvCXV10F5ZmbMsW6CcPjSTrbA5U5XRf
         iFtrv2qzCJIeXyi72cAmxJeDe0r5TjnJkeA8flduIBg9kyZzNXL4mce9Obd5m/4hR3b3
         5dreEi+dSQkfNCzVCPDDVwhGNjWl+kEg8Zt+Ur8MhfNu0SysaavlKj3DyNJKpSeM2Sey
         6Cfuga6DRMX8mV1w1288ypfBChfwAUHXX7ZjJNV7r8kiehIl0bZx4gue2+Qs+FNNr0kN
         +Hag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702939504; x=1703544304;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dEFkGMqGEOddGAHC2+I5Dnup+dyLVF1PGFcOkLtAGcU=;
        b=JRZMTtA2JeBuHCSCg9F7lcZkNi2LB5XCuiuE1Wu9VOKWikENv6chaT52P0c6dWaFe/
         tTIB9Ey13htZNQYVthXzhWBHerchyZ3341D2JovrHvSXeh4RJQDWsT2XRJM53QhARsP7
         VDQYrI46WFIS0HIC5nFlU/1keZUa/xyodpL4vTB1Tkw5XlLYlXnMlMNlvp/QNZeULtmR
         7nxDjeuNv1MrumQYvyJqKOcN8S/DG7EC1AIVIZg9hw0bhmEgaAY8tW5tqYb0exdFRXNo
         QKpioERSNOrg685QsgM1nPgBGtFpCNBAor61EKiuIwvwAnBWJmFtizgCD4qum8YJeVKZ
         ceBw==
X-Gm-Message-State: AOJu0YzpjENPlNsU8g3y7RYWFgxIX31RyfZljgLGLXj6qGySQP02D700
	+J+Jfh3yCWz5UcQkk+eGma0CwVmTTblhdV0HabfIQlT5bSk=
X-Google-Smtp-Source: AGHT+IHCwDSHcsT9p9pVBB5zJu1k+7qlTW1AWVEFB4lwrojfR0vChA4AGE+PxMFClaLmJ+JPmVjOtc+Xi6gXsqeP2zs=
X-Received: by 2002:a50:9e6b:0:b0:553:6c79:ac7 with SMTP id
 z98-20020a509e6b000000b005536c790ac7mr844384ede.9.1702939504507; Mon, 18 Dec
 2023 14:45:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: N <dundir@gmail.com>
Date: Mon, 18 Dec 2023 14:44:52 -0800
Message-ID: <CAFkZcMzLpS=uJK-N2XGLBse1gec1CsR4-cBErZ9JdQCZvgxWSg@mail.gmail.com>
Subject: bcache, possible to peg specific blocks to the cache drive?
To: linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I asked in the IRC but didn't get an answer.

I'm trying to find out how or if it might be possible to use the
bcache module; and peg certain blocks/related files such that they
will always be available from the cache?

Usually its not much, but for example, with blocks related to boot
files that may be invalidated fairly quickly under what would normally
be heavier operating loads, this would be useful.

Best Regards,
N

