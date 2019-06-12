Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FCC41A3E
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Jun 2019 04:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406602AbfFLCH7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 11 Jun 2019 22:07:59 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:43716 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404880AbfFLCH7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 Jun 2019 22:07:59 -0400
Received: by mail-lj1-f179.google.com with SMTP id 16so13583882ljv.10
        for <linux-bcache@vger.kernel.org>; Tue, 11 Jun 2019 19:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zvcuGBw+4LQao88YFmzPADNOaa+2pmIz1aMFK+ndk6M=;
        b=XcZ9B2oIjVRXTLHyuEPsLajuh6i76LN69nh3G8uioz1IkqIoBNiJmqBx/YkM+zyHPY
         2G4ifYC/e/x616EYdSNIo03kIta8UGvL7gEmyY9zsCOwuEh0KIGgPW6cVGtYZOxKD6oY
         Cr+IJ89IjBKKmulpfediz94KCA9DcxQ3obwPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zvcuGBw+4LQao88YFmzPADNOaa+2pmIz1aMFK+ndk6M=;
        b=rmpvJxDghWt3rScceq8A+8MNfJbgcsWG7sg9ecQZGfmgu2pMhxf1YdBCDd4rmUdj2f
         coYp60Kog2CDRJOdKSF5KDwM3A7FWkk9lMxjuO7YH/fzUxHWjRlXYHYTRQ9TwL7PftD+
         Oo6LMCoJ+vtDGadL7bI/wfAJrVE+DI3hGR8x2q33/kv0iRorjvP2WJZ96DVjmkqvpnCM
         teE8Gzu9TQJGlwfVs6sZuwcwOhoCnSeSKO+ogpQFN9GI+WAt9pf/ry9nWDapJsencd6c
         fQIDaN8rMenUwZjQ1MkS+7i6Afz/HnZWBh1E+cf5JkG/MJXIxS2oNz62YFMBmD6XecLQ
         OIPQ==
X-Gm-Message-State: APjAAAWG15s9DLUO47SptG83RH9Qnw7W5zo+FEZ3641i6JHl0GgwUJMw
        sEsiLGIKbY3aq3c4PkLMJYbEVANvm1c=
X-Google-Smtp-Source: APXvYqyTbsj2/MjcAkuT/t3mcwhAy6cS6uHYcQ61g6UeNUgFIQ4dhD2FaiUtNH/cjdMvZD9m52REIg==
X-Received: by 2002:a2e:8696:: with SMTP id l22mr18767890lji.201.1560305277154;
        Tue, 11 Jun 2019 19:07:57 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id z193sm1762330lfd.49.2019.06.11.19.07.56
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 19:07:56 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id i21so13611250ljj.3
        for <linux-bcache@vger.kernel.org>; Tue, 11 Jun 2019 19:07:56 -0700 (PDT)
X-Received: by 2002:a2e:9c03:: with SMTP id s3mr26468187lji.209.1560305276220;
 Tue, 11 Jun 2019 19:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611041045.GA14363@dread.disaster.area> <CAHk-=whDmeozRHUO0qM+2OeGw+=dkcjwGdsvms-x5Dz4y7Tzcw@mail.gmail.com>
 <20190611071038.GC14363@dread.disaster.area>
In-Reply-To: <20190611071038.GC14363@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 11 Jun 2019 16:07:40 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgBdTUvjYXKPr_wAAe_Z-hFgM2KMHcsK+b=3w5yMSJ9zw@mail.gmail.com>
Message-ID: <CAHk-=wgBdTUvjYXKPr_wAAe_Z-hFgM2KMHcsK+b=3w5yMSJ9zw@mail.gmail.com>
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

On Mon, Jun 10, 2019 at 9:11 PM Dave Chinner <david@fromorbit.com> wrote:
>
> The same rwsem issues were seen on the mmap_sem, the shrinker rwsem,
> in a couple of device drivers, and so on. i.e. This isn't an XFS
> issue I'm raising here - I'm raising a concern about the lack of
> validation of core infrastructure and it's suitability for
> functionality extensions.

I haven't actually seen the reports.

That said, I do think this should be improving. The random
architecture-specific code is largely going away, and we'll have a
unified rwsem.

It might obviously cause some pain initially, but I think long-term we
should be much better off, at least avoiding the "on particular
configurations" issue..

              Linus
