Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71A01CB6A3
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 20:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgEHSE7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 14:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726864AbgEHSE6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 14:04:58 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5BBC05BD43
        for <linux-bcache@vger.kernel.org>; Fri,  8 May 2020 11:04:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id d16so1955545edv.8
        for <linux-bcache@vger.kernel.org>; Fri, 08 May 2020 11:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+vtj9kAvnXfdA0IFN6kkpOkjHUwpRBJt7518BSBQldY=;
        b=VLfu18xvdyYvX+V3um74QbEgFlho/gmsdlebCehHgRC64LZ2LrwpLSPmFXlKyiifMG
         /2mXN3cYmzMOG97rtljf0sT2QTUcVKx0FHG3wqHOn7YZJCXdCNGibohHbksMUKyWKlmI
         u1s1YRJzpU1L2la8Jh5ttA2RLPctTxbiNdxv5J+1g/qta/vl3/3fnC/sNfCJYpUd8mBU
         rhA0RJUtnY0TDMxjb+AxGbqdOAZaUfuuGplRawkJdhwtGOz/RRQ8kRykAiOe7EfzaLOX
         DLh537yRKgaNM5aAIB51dRs9O5e+S0jhrluFx3rLNSiCGFuLiqA0Hj3QpKIo8KItLtbA
         P4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+vtj9kAvnXfdA0IFN6kkpOkjHUwpRBJt7518BSBQldY=;
        b=PrxtYosKCRDzkuQbyM/gt6Fdvo9LdrejkLh667D4l5ooTxQyJd5I+er8+y4AERYkTz
         86AJCn0XzJal2O9MeKAs/aa6vGiX3hU0rYs2plpPqwdFKWMC0w1t/UEyJoLUBgBpCYfj
         ZA13O15HU1B/lXDH34KpdM6s6CL1EuK/lQ7hvSFmOetYulL7AT1j74Y50zAJSHQNPkHh
         ndeZFpOxBiEG67WHRPq0rD1duvlDlXvavvD271x9aP9qdiYnfAl6U/mfizxTSxOX9ims
         wM5oRZ8fF4sL4eyBbtAHZz84o4cENb7OrM5O9O887M7QLL9K5g16Lp8G7Of5FtOuhjMN
         Pd1w==
X-Gm-Message-State: AGi0PuYkNvBCu5VG4qWLdwLqB7gryWxN5XlhiGmMJkIV2WkXcsemM4rO
        022gBdywSV3gmZK7F9uRgPg5WvEM1TGbxx7q/upsdQ==
X-Google-Smtp-Source: APiQypLP4j4lAauikZOSYW9imDv/qSFGiWgh0ghiKFKN6QKIltyJGJv056sHO7WKbYwrvEJrNoRF76BYTsHSimP70IA=
X-Received: by 2002:a50:c3c2:: with SMTP id i2mr3146588edf.93.1588961096815;
 Fri, 08 May 2020 11:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200508161517.252308-1-hch@lst.de>
In-Reply-To: <20200508161517.252308-1-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 8 May 2020 11:04:45 -0700
Message-ID: <CAPcyv4j3gVqrZWCCc2Q-6JizGAQXW0b+R1BcvWCZOvzaukGLQg@mail.gmail.com>
Subject: Re: remove a few uses of ->queuedata
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k@lists.linux-m68k.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 8, 2020 at 9:16 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi all,
>
> various bio based drivers use queue->queuedata despite already having
> set up disk->private_data, which can be used just as easily.  This
> series cleans them up to only use a single private data pointer.

...but isn't the queue pretty much guaranteed to be cache hot and the
gendisk cache cold? I'm not immediately seeing what else needs the
gendisk in the I/O path. Is there another motivation I'm missing?
