Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875CF45AA2B
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Nov 2021 18:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhKWRng (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Nov 2021 12:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhKWRng (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Nov 2021 12:43:36 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15315C061574
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 09:40:28 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v203so25133609ybe.6
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 09:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YA0/reyNJPg/NTu8rUxQY8ZlAtyfXm0hOJTLajtoK50=;
        b=mdXX3cmaCnRIWCT60X55SELjw+A5eo9PlWmGWBKm50VQladpw9ZX6bYhNfSubthP3S
         HbukdLJpYxhFZiwgjBnfA72g+3pjhsyUZbCMG0JLWPa1A5R49g0vXgqBnCj+B4ibaMqB
         paERhH7E4PzTESWn7P7nY/IqoPz3MmeD9oBa8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YA0/reyNJPg/NTu8rUxQY8ZlAtyfXm0hOJTLajtoK50=;
        b=pzxH0Un+a2LtSHcmi+OK3xdDR2mHXTWvfGvt2SoEGPcjIMKNY6qB8fD8aRzFwktXNF
         xfmrrKkPHtDEBbk/IwKGeAsOdLr6uUCsSP13uiSHQPeW6cJo1X/EAY1g3qbeqOm1TcoK
         1P+fLsw67bhVZFliTbiZvYsk8tbN9lGyWgzVoEm2SVt/vPZKRsGYt4kttJJ2iF0dma3k
         fDt3AYo+zHTORuWmbQc249VC/jTnVENpBL4HvePwEtuYInwR7vv4yT9UNfF4eQrDlnRU
         ASqytIjW1rgv1CLF6xGP46k6KL+wmaNUH3XnYTVIBrZhedluw2xIzkTGWq4l5c1owQSa
         L/Zg==
X-Gm-Message-State: AOAM532mLQd76rq35oT+rIxUcR3rMYMQ9fIsdxbaKzH/nQbPzEKZGT85
        PnbqR0BLHlXtGEQzlnrtkldS5BqQFjTsYWdP61yjaskWqpYlww==
X-Google-Smtp-Source: ABdhPJyDU9iLVfZSbiwpZ0NtrN8npur19LpS9wxkdebw3QQTrZ97wIPG5aVlK/qhG3hFVXXzMHXKaS1+jC41z1HdULA=
X-Received: by 2002:a25:30a:: with SMTP id 10mr8299558ybd.492.1637689227363;
 Tue, 23 Nov 2021 09:40:27 -0800 (PST)
MIME-Version: 1.0
References: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com>
 <CAC2ZOYs6iVbqgw8RiiTN7TrHwy3LDTc2AVXm53+2BNjOx04Cmw@mail.gmail.com>
In-Reply-To: <CAC2ZOYs6iVbqgw8RiiTN7TrHwy3LDTc2AVXm53+2BNjOx04Cmw@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Tue, 23 Nov 2021 18:40:16 +0100
Message-ID: <CAC2ZOYtJXL=WOJ6bLvNNnq7SHzHfmzt6AkOSR1m=g95hrggP4w@mail.gmail.com>
Subject: Re: Bcache is not caching anything. cache state=inconsistent, how to clear?
To:     =?UTF-8?Q?Tobiasz_Karo=C5=84?= <unfa00@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Oops:

> # echo 1 >/sys/fs/bcache/CSETUUID/unregister
> # bcache make -C -w 4096 -l LABEL --force /dev/BPART

CPART of course!

# bcache make -C -w 4096 -l LABEL --force /dev/CPART

Bye
Kai
