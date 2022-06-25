Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332FC55A77B
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Jun 2022 08:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiFYG33 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Jun 2022 02:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiFYG33 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jun 2022 02:29:29 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1C049262
        for <linux-bcache@vger.kernel.org>; Fri, 24 Jun 2022 23:29:28 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id x3so7987837lfd.2
        for <linux-bcache@vger.kernel.org>; Fri, 24 Jun 2022 23:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=NIfQtqzeiHr1Bx/wI31cgthQtxe3wj/holKaMR/m9zM=;
        b=Da78iQBFQ0j5UZFZNq0UDIyvDfLl1sl1+ECWTo6iMYA2wwtr6o9aSWCeHAEYvNB802
         cGeK2knmCulZLM28E5oGcP6T6V5m9msb7isZR3bc+jQAIj+gHhV5aZD1zFK1F76/zjnV
         vtF0FSPIE26B1wr7WB01ynmce5Nrle9hCau/kRYsj54webfVIzYcwm5UFcnCp/2xatHf
         25WO33+iaobAVhFP33WT+wgqv1JpH2YhS0EBuKadJ5Io1pnaJhdBTA68RaKRXoBx54WE
         p/WosK6sc9HVHWXv311pR0BAf9O7SjZRunLi0mJCszuCDLld3/hox3ruv+tkscZEsL/C
         wrgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=NIfQtqzeiHr1Bx/wI31cgthQtxe3wj/holKaMR/m9zM=;
        b=x3EpqJKMhA0Yp37HcP0rvxWSWvKqEBnqfTJ28K/6KmcomF8IlxM2sLzBR9s8jXQRhE
         gTsdPrCGNGz7xgIky2jbuVYBQP28hrNGrOuK0rH5Uzga7cdjR+KD0lUIiMEI+2WAZBiS
         aq1IVYVnbb9TpRevwMftp7tsZyHRrqBFYR6nykgF2NpeLtgevWx7TP6RKWW4HU4pQxpO
         le3DnOutDxuGHc7hkIKCAz+dh0areRedtOwAliXytaXRERjnyy3HikR1JvwvQWvBZbin
         e/jnCt7u0wOnihpONaFliTtbzmnGrQnUyBgCOqahzuucHkibnaDvMqm4GXB3YVOrci+d
         UJ0g==
X-Gm-Message-State: AJIora9PdcCnmf8YEK0j3F3SnQncz9pzdJ49KTxxWTIyFxnUy5PrxQNg
        8h9D++ECbwen9BkejXQzGsMqPhcos1yOPZj1iaAbroarxXeFHQ==
X-Google-Smtp-Source: AGRyM1soR5L8f+XQOVF7UbIqENEjCdFxWNONgems60J5m+ZRw2ciUMk87o2bon5K/9zNyOa5BcItvg/cCdLcRfQKSJI=
X-Received: by 2002:a05:6512:793:b0:47f:82d0:fadb with SMTP id
 x19-20020a056512079300b0047f82d0fadbmr1575156lfr.545.1656138565484; Fri, 24
 Jun 2022 23:29:25 -0700 (PDT)
MIME-Version: 1.0
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Sat, 25 Jun 2022 11:59:13 +0530
Message-ID: <CAC6jXv0FoE60HEuc7tDMXEA27hkoMkZm5d6gt4NCRkAh2w3WvA@mail.gmail.com>
Subject: bcache I/O performance tests on 5.15.0-40-generic
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

I've been doing some performance tests of bcache on 5.15.0-40-generic.

The baseline figures for the fast and slow disk for random writes are
consistent at around 225MiB/s and 3046KiB/s.

But the bcache results inexplicably drop sometimes to 10Mib/s, for
random write test using fio like this -

fio --rw=randwrite --size=1G --ioengine=libaio --direct=1
--gtod_reduce=1 --iodepth=128 --bs=4k --name=MY_TEST1

  WRITE: bw=168MiB/s (176MB/s), 168MiB/s-168MiB/s (176MB/s-176MB/s),
io=1024MiB (1074MB), run=6104-6104msec
  WRITE: bw=283MiB/s (297MB/s), 283MiB/s-283MiB/s (297MB/s-297MB/s),
io=1024MiB (1074MB), run=3621-3621msec
  WRITE: bw=10.3MiB/s (10.9MB/s), 10.3MiB/s-10.3MiB/s
(10.9MB/s-10.9MB/s), io=1024MiB (1074MB), run=98945-98945msec
  WRITE: bw=8236KiB/s (8434kB/s), 8236KiB/s-8236KiB/s
(8434kB/s-8434kB/s), io=1024MiB (1074MB), run=127317-127317msec
  WRITE: bw=9657KiB/s (9888kB/s), 9657KiB/s-9657KiB/s
(9888kB/s-9888kB/s), io=1024MiB (1074MB), run=108587-108587msec
  WRITE: bw=4543KiB/s (4652kB/s), 4543KiB/s-4543KiB/s
(4652kB/s-4652kB/s), io=1024MiB (1074MB), run=230819-230819msec

This seems to happen after 2 runs of 1gb writes (cache disk is 4gb size)

Some details are here - https://pastebin.com/V9mpLCbY , I will share
the full testing results soon, but just was wondering about this
performance drop for no apparent reason once the cache gets about 50%
full.

I've tested in writeback mode, and also set
congested_read_threshold_us and congested_write_threshold_us to 0

I did not notice this issue while testing on an older kernel -
4.15.0-188-generic

Regards,
Nikhil.
