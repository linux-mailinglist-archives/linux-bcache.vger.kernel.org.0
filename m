Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7F55A815D
	for <lists+linux-bcache@lfdr.de>; Wed, 31 Aug 2022 17:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiHaPhb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 31 Aug 2022 11:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiHaPh2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Aug 2022 11:37:28 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14980D8B3F
        for <linux-bcache@vger.kernel.org>; Wed, 31 Aug 2022 08:37:26 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-33dc345ad78so311015587b3.3
        for <linux-bcache@vger.kernel.org>; Wed, 31 Aug 2022 08:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Z5bWT124P9msiKtHJxXWtamGxGE9nU7NFSbNkXeVir4=;
        b=q4yt7LQZaKZTdzRnqOfBDWuxDUawgahY2C4+8NClZrlVWpZiq8b8wuUtt2FXanHGEc
         GKUHZeMZM5jPluxM3gpqfRkq+ZEpQLG+BNvz98YUVO6qqcwbNq/QfwpxfY1bBqJ/PbUe
         qN9rURlcwiX2U8yaFrSKUwROmM3LF8ndCfS6j0AHC4HsQL8z7s2/MCCQMTRvX3Ne6rDh
         NX1iVO84IZTdrxORhVNpFjbUB389eDGDLX9acAC39/jQL/Xkcw+zdEhsbVQSkIB5PGSl
         3MgCLAYUQZJEhdAOCDXe/UR2KtUxqwQZuMK/LjLdJHtYQZbxs0yHQAWgM70EmS5KjdKg
         raEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Z5bWT124P9msiKtHJxXWtamGxGE9nU7NFSbNkXeVir4=;
        b=sVmti25SRPQT8fDRzdldHwkDCFKyR9tJHdLBerooxxK1FLwUcRjOHLVXe8p2A1QX7B
         wcN8zJtGJBvekGEV/b7in7Zw4QrDCETF9lbuuSQQQERPLdp0bDwIQJ3elhEd8aIxglPo
         tO5xQShKvmE0CJ2ZymLQSN24/8Td7WYyevxSKh0ACCjQbC2mToryGIdwINoNYjFHIfmF
         rpJf9oMMlaiUrCe4vVZn1875iMDidToeaqbYH3PfKTJ3rc2MtuXpBqaV0G0rbMB6FcDJ
         KIE7lWwAUpyJW9tUa4U3rdwY7QbNZrPLllKHls6VqKMpSFfMoO4JcteSOqRzTtyZwu2g
         gsDg==
X-Gm-Message-State: ACgBeo1oUOWOOh97Ntes6w7M8/sXFIvxEgSyc/JW21uOlkiqMZl2e89g
        lZiYP4//44JFExwbxhkJn5RhZEQpRGbc7VDaA77tLA==
X-Google-Smtp-Source: AA6agR4eyfrVHwFKMQTAM4+K85p4B7I6c+zSy9tLGnKDo68fc8kY3s9yyQtJtbnPccojelXd5+hkkFEpEU7+woAq0vg=
X-Received: by 2002:a81:7784:0:b0:33d:ca62:45f5 with SMTP id
 s126-20020a817784000000b0033dca6245f5mr18452862ywc.180.1661960245620; Wed, 31
 Aug 2022 08:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <20220830214919.53220-4-surenb@google.com>
 <20220831100249.f2o27ri7ho4ma3pe@suse.de>
In-Reply-To: <20220831100249.f2o27ri7ho4ma3pe@suse.de>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 31 Aug 2022 08:37:14 -0700
Message-ID: <CAJuCfpHpBCUma_=AdTQ+UkfSkfkov2JbKfxLdp5K9_MoonkT7g@mail.gmail.com>
Subject: Re: [RFC PATCH 03/30] Lazy percpu counters
To:     Mel Gorman <mgorman@suse.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <liam.howlett@oracle.com>,
        David Vernet <void@manifault.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Christopher Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, 42.hyeyoo@gmail.com,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>, dvyukov@google.com,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>, arnd@arndb.de,
        jbaron@akamai.com, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        kernel-team <kernel-team@android.com>,
        linux-mm <linux-mm@kvack.org>, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Aug 31, 2022 at 3:02 AM Mel Gorman <mgorman@suse.de> wrote:
>
> On Tue, Aug 30, 2022 at 02:48:52PM -0700, Suren Baghdasaryan wrote:
> > From: Kent Overstreet <kent.overstreet@linux.dev>
> >
> > This patch adds lib/lazy-percpu-counter.c, which implements counters
> > that start out as atomics, but lazily switch to percpu mode if the
> > update rate crosses some threshold (arbitrarily set at 256 per second).
> >
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
>
> Why not use percpu_counter? It has a per-cpu counter that is synchronised
> when a batch threshold (default 32) is exceeded and can explicitly sync
> the counters when required assuming the synchronised count is only needed
> when reading debugfs.

The intent is to use atomic counters for places that are not updated very often.
This would save memory required for the counters. Originally I had a config
option to choose which counter type to use but with lazy counters we sacrifice
memory for performance only when needed while keeping the other counters
small.

>
> --
> Mel Gorman
> SUSE Labs
