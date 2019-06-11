Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483023C25F
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2019 06:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391003AbfFKEjV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 11 Jun 2019 00:39:21 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:46369 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388735AbfFKEjV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 Jun 2019 00:39:21 -0400
Received: by mail-lf1-f52.google.com with SMTP id z15so5518315lfh.13
        for <linux-bcache@vger.kernel.org>; Mon, 10 Jun 2019 21:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9SMEwJWMeHtEyw0+L1caTDzGbNv810UPp3Lqsx3PUF8=;
        b=QoOOR0HYKqsx3JsW6Ew+a3guMYkQ2W/iAmuqxvOFKc2gBdgPpiDUc6GDNZv08ve+UL
         EI1jVlrxftmcd8GkeJ0oFp4Q1bcxwTC2j3DRi7CGlH9xQA0pIgDG9f/n8XTk+FnhBPSf
         5EUYmUYvqmN9yKTc9mv8oUSfj0cMJfJ9bKh/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9SMEwJWMeHtEyw0+L1caTDzGbNv810UPp3Lqsx3PUF8=;
        b=Tz4pCC7C0b+y5AQp6NXacXpDbBBHx0bZZn/sFLRv8BMgCM0AF0zfRuy+keUfOQ4p0d
         RF8gd39FDH2a+B6kRHPK/EBZcIjbG+xa/IiYk408ZJxr8O7sOSC+gilcxw1/DI1rVboD
         ZTU6+CdaIPjQcorUXohsuA+5zEZuPWMtIf9NSn1Xo5CM5Q4hQabtNGYU/QXOGcFUDDA3
         tWEWddGUc38iPGS8JqOlgpZXyVygUmOshEUXy5DeQiWj+yEHJhKVcSUjpS61pF2ZfnR8
         51W0rcyWzMq1c7BKdHgKY8xCoPaQdQFpc1CTdOAK+oABS8JwxxYfL2ALfcxXa01lK9G9
         5lkA==
X-Gm-Message-State: APjAAAUHL5yF9TlVdByM4fiXAQOOEAt6Cl4hgd7ICQBVAHN11N3AamOe
        tiF+otsGAiSEJ1ti8BHPPbPJ8HlmmAY=
X-Google-Smtp-Source: APXvYqy2SG2VtC/IRKsqyTkDcrU7kMO8ZKnfiPJybtoB5+swdSkEn5LpJbQTUCY5CMcnghlp0etfFg==
X-Received: by 2002:a05:6512:29a:: with SMTP id j26mr3560961lfp.44.1560227958488;
        Mon, 10 Jun 2019 21:39:18 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id u13sm2297023lfl.61.2019.06.10.21.39.16
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:39:17 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id i21so10140261ljj.3
        for <linux-bcache@vger.kernel.org>; Mon, 10 Jun 2019 21:39:16 -0700 (PDT)
X-Received: by 2002:a2e:2c07:: with SMTP id s7mr4973161ljs.44.1560227956599;
 Mon, 10 Jun 2019 21:39:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com> <20190611041045.GA14363@dread.disaster.area>
In-Reply-To: <20190611041045.GA14363@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Jun 2019 18:39:00 -1000
X-Gmail-Original-Message-ID: <CAHk-=whDmeozRHUO0qM+2OeGw+=dkcjwGdsvms-x5Dz4y7Tzcw@mail.gmail.com>
Message-ID: <CAHk-=whDmeozRHUO0qM+2OeGw+=dkcjwGdsvms-x5Dz4y7Tzcw@mail.gmail.com>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker merged)
To:     Dave Chinner <david@fromorbit.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-bcache@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Zach Brown <zach.brown@ni.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 6:11 PM Dave Chinner <david@fromorbit.com> wrote:
>
> Please, no, let's not make the rwsems even more fragile than they
> already are. I'm tired of the ongoing XFS customer escalations that
> end up being root caused to yet another rwsem memory barrier bug.
>
> > Have you talked to Waiman Long about that?
>
> Unfortunately, Waiman has been unable to find/debug multiple rwsem
> exclusion violations we've seen in XFS bug reports over the past 2-3
> years.

Inside xfs you can do whatever you want.

But in generic code, no, we're not saying "we don't trust the generic
locking, so we cook our own random locking".

If tghere really are exclusion issues, they should be fairly easy to
try to find with a generic test-suite. Have a bunch of readers that
assert that some shared variable has a particular value, and a bund of
writers that then modify the value and set it back. Add some random
timing and "yield" to them all, and show that the serialization is
wrong.

Some kind of "XFS load Y shows problems" is undebuggable, and not
necessarily due to locking.

Because if the locking issues are real (and we did fix one bug
recently in a9e9bcb45b15: "locking/rwsem: Prevent decrement of reader
count before increment") it needs to be fixed. Some kind of "let's do
something else entirely" is simply not acceptable.

                  Linus
