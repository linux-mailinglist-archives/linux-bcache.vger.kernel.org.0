Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295443688F7
	for <lists+linux-bcache@lfdr.de>; Fri, 23 Apr 2021 00:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbhDVWTt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Apr 2021 18:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236915AbhDVWTs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Apr 2021 18:19:48 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7EDC06174A
        for <linux-bcache@vger.kernel.org>; Thu, 22 Apr 2021 15:19:12 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id h3so22114015qve.13
        for <linux-bcache@vger.kernel.org>; Thu, 22 Apr 2021 15:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZqBzNty2RYJgJglsKzg0KiNUUNa44VKj1loxk9PuvCE=;
        b=M5QZh5c0gDOsNrCKPjXjZxSyJWg7trLtzuyepLr5KrB4n2jAe5PGXL0VmT3NlwULOX
         M8yb9H+B6blcEoaEkFOxBes35HtX77UI1OyUquz4oRyca1Ub3D7VEzpYQmTxuucX48SW
         Zozt1j6V93CDxY5eUj3KWfroeG0t9ulUC/BL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZqBzNty2RYJgJglsKzg0KiNUUNa44VKj1loxk9PuvCE=;
        b=FOr5Y1zKF6g3wnjrrVt0vW5jequeDq0Z3GyoGZMAnR/NCzU34Xi8JPvyAyIGTCwXhp
         flXk4lBQ1RM0ppUEtgOFrRpuIgtUgVo367YymWMWlykXgBazLL1fx1PlAnTiMCdX0oy0
         7caPHIAzxR0M6E2AOktQ5kR6UNyiuQTdBtIv8igDds29BtUwShBOVtGL2KYf+wxVVtBq
         w4lHIWYZPhfZ2IqT74KGR0AAJ6Xse3TsjssuvkQbQnSCQ10vKwvUr1h7HINU6nIvV06v
         5leyqYGPSULfjfw2g5NkDR/9CkIUf5TduvoEmqlrd1pGmlW30kI3pNfOO+ym8zIT7rx4
         znuQ==
X-Gm-Message-State: AOAM533pFXOgNXy6J6mlKYZuaydgRS7mS+RTdVGLwUIBWErsz7E27rUK
        gmJiLKr+2Ii3BgaiB7NtizVWPWCYumi4cRfRhGn7MA==
X-Google-Smtp-Source: ABdhPJydD0Yzr9xdCf5cfNAgok9B37Vjw0YITY+0skCfI+ivedTRDfMyWgpB8jVJOQrK1/0KO+yLtprg3XMaOhdlVvA=
X-Received: by 2002:a0c:9b82:: with SMTP id o2mr1181437qve.47.1619129951330;
 Thu, 22 Apr 2021 15:19:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAH6h+heRQ0m4widKfWSfsqptO0xiXA4BW1pVHow2_+JbNrvZUQ@mail.gmail.com>
 <e61bcc44-5ac1-e58c-d5c9-fb7257ba044d@suse.de>
In-Reply-To: <e61bcc44-5ac1-e58c-d5c9-fb7257ba044d@suse.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Fri, 23 Apr 2021 00:19:00 +0200
Message-ID: <CAC2ZOYvKZBFRPi+-BB8vyTWhMoTGsQZ+7vuFfDmBzpSjzwvVYg@mail.gmail.com>
Subject: Re: Race Condition Leads to Corruption
To:     Coly Li <colyli@suse.de>
Cc:     Marc Smith <msmith626@gmail.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Coly!

Am Do., 22. Apr. 2021 um 18:05 Uhr schrieb Coly Li <colyli@suse.de>:

> In direct I/Os, to read the just-written data, the reader must wait and
> make sure the previous write complete, then the reading data should be
> the previous written content. If not, that's bcache bug.

Isn't this report exactly about that? DIO data has been written, then
differently written again with a concurrent process, and when you read
it back, any of both may come back (let's call it state A). But the
problem here is that this is not persistent, and that should actually
not happen: bcache now has stale content in its cache, and after write
back finished, the contents of the previous read (from state A)
changed to a new state B. And this is not what you should expect from
direct IO: The contents have literally changed under your feet with a
much too high latency: If some read already confirmed that data has
some state A after concurrent writes, it should not change to a state
B after bcache finished write-back.

> You may try the above steps on non-bcache block devices with/without
> file systems, it is probably to reproduce similar "race" with parallel
> direct read and writes.

I'm guessing the bcache results would suggest there's a much higher
latency of inconsistency between write and read races, in the range of
minutes or even hours. So there'd be no chance to properly verify your
DIO writes by the following read and be sure that this state persists
- just because there might be outstanding bcache dirty data.

I wonder if this is why I'm seeing btrfs corructions with bcache when
I enabled auto-defrag in btrfs. OTOH, I didn't check the code on how
auto-defrag is actually implemented and if it uses some direct-io path
under the hoods.


Regards,
Kai
