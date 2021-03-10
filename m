Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC4B333B4C
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Mar 2021 12:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCJLYo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Mar 2021 06:24:44 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:57427 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhCJLYR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Mar 2021 06:24:17 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MGQzj-1lWIM71eAv-00GoSe; Wed, 10 Mar 2021 12:23:58 +0100
Received: by mail-ot1-f44.google.com with SMTP id x28so1271357otr.6;
        Wed, 10 Mar 2021 03:23:57 -0800 (PST)
X-Gm-Message-State: AOAM5339D7e95cwCcbZPCPbhyGrW/LOC6RZj7tAtqETACXCOPzqrqI1m
        xbSoXNOvqgctYIV2tXq7t5Su2RBmFhIoZjimzWQ=
X-Google-Smtp-Source: ABdhPJzSi9rQjVmQMcCdC3Ugc0EWFLl//ABE/fGqmyUE3BjBZcH2sAsjResUueB/qNZ0M5JXaPsoktuZzqJxAH31rsg=
X-Received: by 2002:a05:6830:14c1:: with SMTP id t1mr2167623otq.305.1615375436800;
 Wed, 10 Mar 2021 03:23:56 -0800 (PST)
MIME-Version: 1.0
References: <20210309181533.231573-1-willy@infradead.org>
In-Reply-To: <20210309181533.231573-1-willy@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 10 Mar 2021 12:23:40 +0100
X-Gmail-Original-Message-ID: <CAK8P3a31=gJkF+GypnaznfhKCYSnwU1yF4u0tem==YSpz3pwXw@mail.gmail.com>
Message-ID: <CAK8P3a31=gJkF+GypnaznfhKCYSnwU1yF4u0tem==YSpz3pwXw@mail.gmail.com>
Subject: Re: [PATCH] include: Remove pagemap.h from blkdev.h
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:ZAMdrLCRoCgXj3tTGCPDyaMO7QGvyKUlz2EHeBiucgYdBifB9nF
 PJ5b8WT7SWsdRy9ivuV9503hX0xNnHrYgtkQG+PUtIjdN7esmNers6qgqNOvGDJt6zuueb5
 Nq7v3rBHycipdjqcDt3ptbbJG1hsm+6sql36pHv7Gaa8pgd4Wmj6JdvCw5SQl95Q2/XoZUa
 L1ofXYif4PmcgUrbOclWA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3jyXK99JXM8=:VDoDom1E04Ct8FnIHdWHkg
 5Ia4vX9kWptKMWFI2zdlhOS1L40FOH7iyhTCZoJ12kCJjOgrNQdrwxevWz9IJdReQ2UPTUEEd
 u3ZSsc8A/wAcv+XSW3uWZnntuFRWkAKHeF6hyKb8IFFjB660n3gFDfehLH2DsRe2GGLGHdkUq
 tUggdFAmLCPZ/cPV7Dsnq8wm4zjBU1AGlsmPPS7s7s4WJ09528pUivexpAe/l+2suGTdRc8Av
 FQ8i5bNuYbMs4xeIzFWCoiKGQyOEu2t9yHO+fboZRlz+z4nm6Rnpke7/WkHyKb0+czrBigcrl
 5dBXq0rJjNDeLX6laLu8FzJbqjR0qvXblJbXqp7LkN5O5Gi8s8Nogx8UG7A+o0MygmDU8yy6N
 hK1kWDOapsDkcd2Ol+yrD3zFXsBclF/RIkBI5EXZKHDKJH1RpZRPqZnPnVd9K69dvIDPRhIbu
 ifERUrrchHyrdg681fLrJet4UnLg+kd7yKddq1Z4quovkXRUimZ8plkiW/VZ+kslZVCUt7HWP
 vBSRcO+OX30XqqSlcFpYHCzjkmhBE13iYDgWeFCGaWPraJY0vCQ5dwHYlf4m2Qwug==
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Mar 9, 2021 at 7:15 PM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> My UEK-derived config has 1030 files depending on pagemap.h before
> this change.  Afterwards, just 240 files need to be rebuilt when I
> touch pagemap.h.  I think blkdev.h is probably included too widely,
> but untangling that dependency is harder and this solves my problem.
> x86 allmodconfig builds, but there may be implicit include problems
> on other architectures.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Good catch!

With the build regression fixed (I suppose you now need to include
pagemap.h in swap.h):

Acked-by: Arnd Bergmann <arnd@arndb.de>
