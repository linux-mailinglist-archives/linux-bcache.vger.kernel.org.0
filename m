Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22047CB77C
	for <lists+linux-bcache@lfdr.de>; Tue, 17 Oct 2023 02:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjJQAjy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 16 Oct 2023 20:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbjJQAjx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 16 Oct 2023 20:39:53 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B54A7
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2023 17:39:51 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 3f1490d57ef6-d9ac9573274so5618179276.0
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2023 17:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google; t=1697503190; x=1698107990; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iTv7uMUBkdt44N/+vT14q4uYwbIm6gVJ1dg57N7H0ck=;
        b=mUiRTMmF+ZUq/0LUzp2F0g+CNYXaYgjoFLDCwpMkKp3OniDGhJ0+ZgwiRHUEpawf93
         VSEN8mFIDtFwzHzULlPRMnA83s6bgdXc6jN+cy97Nm/p+F1heakAXwHA9H3X6CRzC8UX
         PI2Bmn47Xc5qf5AgT8jJS9R3oCJuIXaDYX4Eo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697503190; x=1698107990;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iTv7uMUBkdt44N/+vT14q4uYwbIm6gVJ1dg57N7H0ck=;
        b=DJYmklYX0vsgQQ+T70D2GBDT4EkJIm46qy+RBOXTupeJ1ZAUI8KSzYtqL2c9WiQmQ3
         VgYJIpj1eWLOPsB2aJJaKuBpo+FKoo/lfxkU22XgSTjWBtz2IjxnwkY0dBeF3KJjEpE3
         GRMVif4hDcIFCByIsBS9jMJz4aczzuON9eVQHYO58MECf8YpWdlCB7uxhSaXnb48VcyZ
         rebLabVKf1/ki8219BV/ckr3n1kjGNyTgGa1w1UJEu/vML8Ow9C/0ZLuEgk2LtBPq2Ht
         Z1+zR/JhEG119+B/EwQUeXmiHgPh0EYrePTLEakVwuEN99QKuBc0WkCA6cCvABtbdBxD
         JOnw==
X-Gm-Message-State: AOJu0YxL/1szj0q3gxR3O88WwH0Pkc+zl0YV05hPcNhJIT88srri5bsl
        R2Z/Bd1ZmbaxM3V9T/JiH9X8ZDcwIjHZL04cuArGvw==
X-Google-Smtp-Source: AGHT+IEssYbWtnV48Koh+i3od37IvaR/4M/6yBRA+4lZON+PViMxlfEndtTZ9PipTuY5yiQxGTyOekrtcLb9+gys6Qw=
X-Received: by 2002:a25:6807:0:b0:d5b:80df:21f5 with SMTP id
 d7-20020a256807000000b00d5b80df21f5mr569557ybc.23.1697503190364; Mon, 16 Oct
 2023 17:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <7cadf9ff-b496-5567-9d60-f0af48122595@ewheeler.net>
 <AJUA3AAkJBN4GUdLmkiuQ4qP.3.1694501683518.Hmail.mingzhe.zou@easystack.cn>
 <f2fcf354-29ec-e2f7-b251-fb9b7d36f4@ewheeler.net> <CAC2ZOYti00duQqPJJqGm=GZRmH+X_uZW+V-WitvwP2s_12JGWA@mail.gmail.com>
 <87b4cac-6b15-14d9-7179-9becc24816d7@ewheeler.net> <CAC2ZOYsvAap_fb3E_XBUSUQY79vY+xuQCB2hipVfcCVSD74VMw@mail.gmail.com>
In-Reply-To: <CAC2ZOYsvAap_fb3E_XBUSUQY79vY+xuQCB2hipVfcCVSD74VMw@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Tue, 17 Oct 2023 02:39:39 +0200
Message-ID: <CAC2ZOYvfmGrfj6t6PsqRHx0q1ADn39r-d=+8NysOJq-rUgOHrw@mail.gmail.com>
Subject: Re: Re: Dirty data loss after cache disk error recovery
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     =?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>,
        Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo/lt54p?= 
        <wubenqing@ruijie.com.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Just another thought...

Am Di., 17. Okt. 2023 um 02:33 Uhr schrieb Kai Krakow <kai@kaishome.de>:

> Except that in writeback mode, it won't (and cannot) return errors to
> user-space although writes eventually fail later and data does not
> persist. So it may be better to turn writeback off as soon as bdev IO
> errors are found, or trigger an immediate writeback by temporarily
> setting writeback_percent to 0. Usually, HDDs support self-healing -
> which didn't work in this case because of delayed writeback. After I
> switched to "none", it worked.

In that light, it might be worth thinking about how bcache could be
used to encourage self-healing of HDDs:

1. If a read IO error occurs, it should start flushing dirty data,
maybe switch to "none" or "writethrough/writearound".

2. Cached bcache contents could be used to rewrite data - in case a
sector has become bad. But I think this needs the firmware to detect a
read error on that sector first - which doesn't help us because then
the data would not be in bcache in the first place.

3. How does bcache handle bdev write errors in common, and in case of
delayed writeback in special?


Regards,
Kai
