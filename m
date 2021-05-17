Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC57B38232F
	for <lists+linux-bcache@lfdr.de>; Mon, 17 May 2021 05:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhEQDzn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 May 2021 23:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhEQDzn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 May 2021 23:55:43 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED994C061573
        for <linux-bcache@vger.kernel.org>; Sun, 16 May 2021 20:54:27 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so4491351oto.0
        for <linux-bcache@vger.kernel.org>; Sun, 16 May 2021 20:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=AiM1UwuUvZBoSDCFO2HBrthDh4iQTocqYa90r4rcoM8=;
        b=mfctunzmWmKTx17vVlLsWkx/qiYVL8sfcEuzs/jakXCDkW6eiTtMdnR2CJaehLdGWz
         2Pd8Y5CRXezKQVIqXSXTr7oox15pRlvgbU/246SENd5Zv00ql4BZ8f/j/pEEDfEUWXHM
         MZFtCbCTmh0+/CvCiswxLq++FNdgvM5JAt/DorTij+MRRoIXY9glvK4rw6F79bkezq13
         tRUwhqxnPmptMAaqmGNsCWZU61poTc7jDRubQ9QudrWTWJPzig88FaBzfUY3lszXfnsA
         CjVC3hPvlJ7hdCPB4FWHPpi7CfBZjK0sYcqtWE5sUKtR8yffumYskVDdohiqLtuKoXAq
         WEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=AiM1UwuUvZBoSDCFO2HBrthDh4iQTocqYa90r4rcoM8=;
        b=OsR2ZfeJAbVVQ70THOWv4aYPRktDWbt6Hrf6DbRkNgVh6+rW2sZrHTSljojrKTpxgC
         p1WEMwSrI1xNYpI5/RAaNrwn2SENkGAoOOxCRttExjKD/XXqfXm4K3aqJj4ZmycKbrHZ
         oOGCMDWe+nRlQ/emiJYx3Er0qRdoSK7PYfGW7kYdlctz/CXATCg9URyW8MuJiGg8DJLx
         IYBLSOziDrR+tVDMTZ6LFkSzYMO/w38Rr901VGY/+rGWlvQGSRnBSdp5/xe1Rl/6OI2r
         Lj806NP2bYjtRcLjJfhfsEohQYpUKt0UzqXylOXfilaHQizXYP2IN5QWFmY0hL8uUcCV
         OSPQ==
X-Gm-Message-State: AOAM533bUAxi/lJNIr0Y2mewHIka6Xx84fTMwogD+oDi1m2NzEJrv5Wt
        CREryhz7TuQFrqOh2gEMDem26PB2oi/yWyRIChmCt2kw+HEGRg==
X-Google-Smtp-Source: ABdhPJzrp3boto76Ca+nr75XICb5zlPDZjgfc4miQNaLQtXYGwL9FeLapCKYHxlteEE1w3ifHxmGS+BSH8KYMsvZNiI=
X-Received: by 2002:a9d:7a44:: with SMTP id z4mr38321214otm.196.1621223667273;
 Sun, 16 May 2021 20:54:27 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Guo <jimmygc2008@gmail.com>
Date:   Mon, 17 May 2021 11:54:13 +0800
Message-ID: <CAG9eTxRG8zqe1r47wgtv_fhVAk13fmeB=Fyx-Z6Fq8W0i=om6Q@mail.gmail.com>
Subject: IO hang when cache do not have enough buckets on small SSD
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello, Mr. Li.
Recently I was experiencing frequent io hang when testing with fio
with 4K random write. Fio iops dropped  to 0 for about 20 seconds
every several minutes.
After some debugging, I discovered that it is the incremental gc that
cause this problem.
My cache disk is relatively small (375GiB with 4K block size and 512K
bucket size), backing hdds are 4 x 1 TiB. I cannot reproduce this on
another environment with bigger cache disk.
When running 4K random write fio bench, the buckets are consumed  very
quickly and soon it has to invalidate some bucket (this happens quite
often). Since the cache disk is small, a lot of write io will soon
reach sectors_to_gc and trigger gc thread. Write io will also increase
search_inflight, which cause gc thread to sleep for 100ms. This will
cause gc procedure to execute for a long time, and invalidating bucket
for the write io will wait for the whole gc procedure.
After removing the 100ms sleep from the incremental gc patch,  the io
never hang any more.
I think for small ssd, sleeping for 100ms seems too long or maybe
write io should not trigger gc thread to sleep for 100ms?
Thank you very much.
