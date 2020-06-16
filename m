Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171131FB53A
	for <lists+linux-bcache@lfdr.de>; Tue, 16 Jun 2020 16:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgFPO54 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 16 Jun 2020 10:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729239AbgFPO54 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Jun 2020 10:57:56 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66591C061573
        for <linux-bcache@vger.kernel.org>; Tue, 16 Jun 2020 07:57:55 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id o15so1836695vsp.12
        for <linux-bcache@vger.kernel.org>; Tue, 16 Jun 2020 07:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=rVgQHwmOT4mXq5jkVXDGr+XiJa2w+3HRrCrLeCQMBbo=;
        b=A8gKTGuPI0CPw1ykTmUNHq+kaHeF+66gRxnt7Vvopce4M4CAsz5aMSoxB7I6VG8gRN
         tklQFUQVW5REr5VbwHgyhv9fmhATW3BhtaSo0Y3yulLX7thJ5xRNXzCZg661u5HFdKKG
         NycErfel0PnyyVAvKRBWVM4n2+EVVSvQOae0IM8TmwQcff2XhY7V1RYHnTYDcqHvRrWV
         X/L6GDYoMtI5cFTpk7dzlh4ROYyPV5O+Hye+ZLlTNnUHxeNoyook2g0R3xRrNzi8FmDm
         IssM74h5zGlwt2wdO74gmWFecVJl7xwHkESDqlAV9uZdB1/rBSEYyL2x2nmgPEMZumUi
         Ep5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rVgQHwmOT4mXq5jkVXDGr+XiJa2w+3HRrCrLeCQMBbo=;
        b=R+ZfI7hFtHa7cHBJqBljilr4tDbBM8wWTQEL7IQOLFyclSOi/vdqRa2eEbfMxNXhU+
         iON1vmMOx77zGOSyJV6YYrl0zEcz2PsJ+HyiOG93n565hTFbWUNUQ+v4R9ZtXmALbIQi
         hg3Uy6pM++VMvmpVrmjipp0Fu9eH3SzcjrSlWIi/xNiKm0/TW4eVcKuBboHj38pISgKR
         GnolYxR4QdATV58NJUDOAuJz4lunLrwhai7unp07usXXv+3L3dr5BXvibvoBNg8mHDVH
         x602BO3vaRN5zdqOZm/yuiGAtqsakjqIs2VJpUcu5xjpmpGC8TSfLfozUjwc2W2lsK6k
         /+gQ==
X-Gm-Message-State: AOAM532Q4t1+ZkPJ0xsdmUHkspxTgfRkXojiTvS1F6hQnJBC0CeoaQGw
        CuIwyKkmA0c2di/LUZ7MnHnPX6uuBmIyix4/ZdsfK9lFoGk=
X-Google-Smtp-Source: ABdhPJxHD201N0AexEU6Ofi+KG2gChGnbmtsi+/bkXMg5dssjNrQupp+h9gg3DoEmddVVpJsY9KXcVjM6jeC7XLnXJw=
X-Received: by 2002:a67:e00f:: with SMTP id c15mr2125469vsl.214.1592319473870;
 Tue, 16 Jun 2020 07:57:53 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Smith <msmith626@gmail.com>
Date:   Tue, 16 Jun 2020 10:57:43 -0400
Message-ID: <CAH6h+hcikX895gU2mGC05MTw7BCdV+kPeqGgrSRPwKXe1hjw+g@mail.gmail.com>
Subject: Small Cache Dev Tuning
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

I'm using bcache in Linux 5.4.45 and have been doing a number of
experiments, and tuning some of the knobs in bcache. I have a very
small cache device (~16 GiB) and I'm trying to make full use of it w/
bcache. I've increased the two module parameters to their maximum
values:
bch_cutoff_writeback=70
bch_cutoff_writeback_sync=90

This certainly helps me allow more dirty data than what the defaults
are set to. But a couple other followup questions:
- Any additional recommended tuning/settings for small cache devices?
- Is the soft threshold for dirty writeback data 70% so there is
always room for metadata on the cache device? Dangerous to try and
recompile with larger maximums?
- I'm still studying the code, but so far I don't see this, and wanted
to confirm that: The writeback thread doesn't look at congestion on
the backing device when flushing out data (and say pausing the
writeback thread as needed)? For spinning media, if lots of latency
sensitive reads are going directly to the backing device, and we're
flushing a lot of data from cache to backing, that hurts.


Thanks,

Marc
