Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54EFC3BDB9
	for <lists+linux-bcache@lfdr.de>; Mon, 10 Jun 2019 22:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389331AbfFJUq6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 10 Jun 2019 16:46:58 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33486 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389538AbfFJUq6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Jun 2019 16:46:58 -0400
Received: by mail-lf1-f67.google.com with SMTP id y17so7632340lfe.0
        for <linux-bcache@vger.kernel.org>; Mon, 10 Jun 2019 13:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3dZjFALioLfmWT2gX0OovbSYoNZY24tjNWFjpsEzRZY=;
        b=OW2Dex0kC9JUsK1CtK5L0J10uoGXFqGOUG1VA+0wauSzJMHtqZFtHeg4zvU9maNl4n
         OZW+g4o0pnDdCxvJBdZHVHjOtF90nTXwp8sBsSG1/heY+cBzcFDob/dNI51E/aFazn/e
         Q0imxrIBOzeOvg0igH+hFLwCY647B83Q0fqew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3dZjFALioLfmWT2gX0OovbSYoNZY24tjNWFjpsEzRZY=;
        b=mg00lj0jkZAO/eGEwhfDo/JmzfTq7nGU/LL/RSBmDr4/h/nCikHsYVrhDtAOcbnWqz
         Gc5SnYAbm6Uodf0ovGwVhuwAeIQXHebvKzyL7YwZE++RGf91nVyTC6VHU6bCW+guebsn
         oh8ctrNVLg2QVEssdls3jbRXIaYJSAC1PRNq7d1LT5qtNTy8UoOiC4p23wvowOC8FdvP
         HiXqtE7Vvu2YxZjzF6AmLbPqKjggWmKGn44LtYxkdREcrppbaT8uI5OPl7e3FY5Lgy0o
         u+S74S+MLAATcy8MncT2vao0fr19+/3uKi7yLTWGq7IazmvMee6mGRzu6Yg/maSf3nBA
         AyLg==
X-Gm-Message-State: APjAAAUDE8+Pb80lc4hHaz/moaz/KDRz71GhzZy5/JDliOXX+l/JnpND
        LWTnSudk9yKq5q1TLwb9qnTKjQsmtsQ=
X-Google-Smtp-Source: APXvYqx+X7hNq4OOeA49RRvQJQG/lPykduDlLYAlU0WN9uc8skxmPbmWiB7hDsIr79gQYoOxuU7/kA==
X-Received: by 2002:a19:f713:: with SMTP id z19mr34264429lfe.121.1560199614544;
        Mon, 10 Jun 2019 13:46:54 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id k4sm1021637ljg.59.2019.06.10.13.46.52
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 13:46:52 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id r15so7614945lfm.11
        for <linux-bcache@vger.kernel.org>; Mon, 10 Jun 2019 13:46:52 -0700 (PDT)
X-Received: by 2002:a19:ae01:: with SMTP id f1mr34920353lfc.29.1560199612181;
 Mon, 10 Jun 2019 13:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Jun 2019 10:46:35 -1000
X-Gmail-Original-Message-ID: <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
Message-ID: <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker merged)
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
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

On Mon, Jun 10, 2019 at 9:14 AM Kent Overstreet
<kent.overstreet@gmail.com> wrote:
>
> So. Here's my bcachefs-for-review branch - this has the minimal set of patches
> outside of fs/bcachefs/. My master branch has some performance optimizations for
> the core buffered IO paths, but those are fairly tricky and invasive so I want
> to hold off on those for now - this branch is intended to be more or less
> suitable for merging as is.

Honestly, it really isn't.

There are obvious things wrong with it - like the fact that you've
rebased it so that the original history is gone, yet you've not
actually *fixed* the history, so you find things like reverts of
commits that should simply have been removed, and fixes for things
that should just have been fixed in the original commit the fix is
for.

And this isn't just "if you rebase, just fix things". You have actual
bogus commit messages as a result of this all.

So to point at the revert, for example. The commit message is

    This reverts commit 36f389604294dfc953e6f5624ceb683818d32f28.

which is wrong to begin with - you should always explain *why* the
revert was done, not just state that it's a revert.

But since you rebased things, that commit 36f3896042 doesn't exist any
more to begin with.  So now you have a revert commit that doesn't
explain why it reverts things, but the only thing it *does* say is
simply wrong and pointless.

Some of the "fixes" commits have the exact same issue - they say things like

    gc lock must be held while invalidating buckets - fixes
    "1f7a95698e bcachefs: Invalidate buckets when writing to alloc btree"

and

    fixes b0f3e786995cb3b12975503f963e469db5a4f09b

both of which are dead and stale git object pointers since the commits
in question got rebased and have some other hash these days.

But note that the cleanup should go further than just fix those kinds
of technical issues. If you rebase, and you have fixes in your tree
for things you rebase, just fix things as you rewrite history anyway
(there are cases where the fix may be informative in itself and it's
worth leaving around, but that's rare).

Anyway, aside from that, I only looked at the non-bcachefs parts. Some
of those are not acceptable either, like

    struct pagecache_lock add_lock
        ____cacheline_aligned_in_smp; /* protects adding new pages */

in 'struct address_space', which is completely bogus, since that
forces not only a potentially huge amount of padding, it also requires
alignment that that struct simply fundamentally does not have, and
_will_ not have.

You can only use ____cacheline_aligned_in_smp for top-level objects,
and honestly, it's almost never a win. That lock shouldn't be so hot.

That lock is somewhat questionable in the first place, and no, we
don't do those hacky recursive things anyway. A recursive lock is
almost always a buggy and mis-designed one.

Why does the regular page lock (at a finer granularity) not suffice?

And no, nobody has ever cared. The dio people just don't care about
page cache anyway. They have their own thing going.

Similarly, no, we're not starting to do vmalloc in non-process context. Stop it.

And the commit comments are very sparse. And not always signed off.

I also get the feeling that the "intent" part of the six-locks could
just be done as a slight extension of the rwsem, where an "intent" is
the same as a write-lock, but without waiting for existing readers,
and then the write-lock part is just the "wait for readers to be
done".

Have you talked to Waiman Long about that?

                    Linus
