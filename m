Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C17355410
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Apr 2021 14:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbhDFMhp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Apr 2021 08:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbhDFMhp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Apr 2021 08:37:45 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630BFC06174A
        for <linux-bcache@vger.kernel.org>; Tue,  6 Apr 2021 05:37:36 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id c4so14706687qkg.3
        for <linux-bcache@vger.kernel.org>; Tue, 06 Apr 2021 05:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fUVONSEGu3HMQtrIco8Ba5zYIKpzT6n9erUrj5lGg58=;
        b=lxhxK3V8oUQdKTAZUKYH9PcDlYJitu7MJL7+ICsvDkm2VI61s1aYYmCMeaYl9jNSvp
         Bw1l8LCEs2Esnzwf8TNtBP34EpX0kZvnN7UxnDlaci9NgBANjnLkIzqH/TZQeBXEbB8o
         yseT4PhPI7NEC+2uP/DlUUv5SRSAB3foD3/3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fUVONSEGu3HMQtrIco8Ba5zYIKpzT6n9erUrj5lGg58=;
        b=nUGrh8ONt8SIS019W6n97ePvRvEcWRnISX4OqMfIrdcHcc6xWy8/tUnPOcQTOlruUy
         yglLa+XpGYZ5bRDoAY88g7Iggta3pPtmO9ijO6fQEJY6BM6Jk4jeyYyutwyXCiuCdrBG
         ntN8ac67EUH6skxIO520NPGVZXGk0eO5cYZbm1FMgxuwF+oODst0qYL3k+2gPx5grBrm
         25JPN28hEo3mrxUFWDQryJ0Jlz+0OaW10gFN+ATpaXiBxc4QiTO/QiXDxlLgZR472GuS
         GeQBRX7tIaAkp+5Io3uVy0GbgsnzoO0fNkSxjUVsIct+8r+FAHcnDWIijOilNZv2Ha91
         kVxA==
X-Gm-Message-State: AOAM533jBpTkeUO20Y8gPPVYTSIufFEWLHWS0vO81M4nvSTtu+606up3
        4IEUsvqEQ70uuWAV9vnJmcRmfjw7vU5pL4bW7Vgbpg==
X-Google-Smtp-Source: ABdhPJypCMUh68YWDBf2p7iCCgLl/AxSPD7tJFrs/Xvg66ctHyWHPWxL8DEZW0E/lqfWif//3zaXx8PiB4mof6UoyqM=
X-Received: by 2002:a37:a603:: with SMTP id p3mr28853103qke.362.1617712655668;
 Tue, 06 Apr 2021 05:37:35 -0700 (PDT)
MIME-Version: 1.0
References: <3030cad3-47e2-43b0-8a82-656c6b774c78@www.fastmail.com>
 <bcfeb53d-b8b0-883a-7a02-90b44b23f4dd@suse.de> <397bddb7-9750-4dd9-bf6e-2287d89778f1@www.fastmail.com>
 <CAH6h+hfN=L+DKGAZv9TUUNmFF4jHzyEeo=9Tr7rw5haLeM3CMQ@mail.gmail.com>
In-Reply-To: <CAH6h+hfN=L+DKGAZv9TUUNmFF4jHzyEeo=9Tr7rw5haLeM3CMQ@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Tue, 6 Apr 2021 14:37:24 +0200
Message-ID: <CAC2ZOYsr9aQjJLa-e0F3cXyKmJmq+6BNZ=mUMmqw8bPxMpQWuw@mail.gmail.com>
Subject: Re: Undoing an "Auto-Stop" when Cache device has recovered?
To:     Marc Smith <msmith626@gmail.com>
Cc:     Nikolaus Rath <nikolaus@rath.org>, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Di., 6. Apr. 2021 um 14:16 Uhr schrieb Marc Smith <msmith626@gmail.com>:

> My thought was to use "panic" in the 'errors' sysfs attribute so the
> machine panics instead of detaching the cache device. Otherwise, it
> seems the cache device gets detached with dirty data present, and the
> backing device is started (yet data is not present).
>
> I'll work on reproducing the original case with the "unregister" value
> and provide logs, as it sounds like this behavior is unexpected (eg, a
> cache device should only detach if there is NO dirty data present).

It could be useful to switch the caching mode to write-around at the
same time, so no data would be written to the device accidentally.

For consistency reasons, the backing device should become inaccessible
when the cache device with dirty data goes away. If the cache is
clean, the cache can just be detached. So it should have an "auto"
option which does either the one or the other thing depending on
caching state.
