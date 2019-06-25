Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644CF5565E
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Jun 2019 19:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbfFYRzA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Jun 2019 13:55:00 -0400
Received: from mail-ua1-f49.google.com ([209.85.222.49]:41911 "EHLO
        mail-ua1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfFYRzA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Jun 2019 13:55:00 -0400
Received: by mail-ua1-f49.google.com with SMTP id 34so7381579uar.8
        for <linux-bcache@vger.kernel.org>; Tue, 25 Jun 2019 10:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gdftPShtgtHD3PfvB9vRc7NQge9c73h+i9CIjxRDZfI=;
        b=U7v4+UZzuPCl6jx8ogY/bCD1ADF29Mp8CWOU+gNJc+6Mkwog5pLqqzRlzW2/vTvgi/
         LZAmBlFjuIiaFhCwvueZIsg3rBTr7Ecg8ApdeIuOOrXPyq3JdeJ+//S789R8cwHSrFOU
         paMMHo0O9bKWy0LE1rnj6IEO9IMQov2Kd6r687cLjVFuN+L6Iy/wz3/oEKoMh76ZaClF
         IkshOMi1/rLqBzwgyr0uWJL8cUApbwg2B50XxcGOSHxPBNHN/JS/zPIjDN8He5/jYs4d
         WbyNLlV702EFlVVBYvwHod0LXnhZRhN4i+u2CaWt49Uex1uZjcZv4k3zPJEBPREHoBoQ
         n9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gdftPShtgtHD3PfvB9vRc7NQge9c73h+i9CIjxRDZfI=;
        b=JrCkJY4ex0MOoXqNCfIFskneLgPQMRPT//wbitapRi8k9GJ8veTXOlrSBHka8qnSCH
         am+eQb2tvOiQ4XwyMfiyYLpyxIIFE8OFt4nV+l5YRlVfTssLWwQkq4B6/rEIPqM46m2m
         K6M6sejJSg/B9GYgqiLSf3IFMPEthMAfQWWuuBJ7hd+zQx/nEDORaYwdvP03RB0cuvd6
         nk+va96n9bALz+cn+VbWrw1324y+LU7ApfhLNPvnqc4mcJ57UmFtYPwUrfkXljnCDbO0
         U2aSrQi074wtKVqz5Bn1PARMXPRo7TPDlGcJ4ESHzrU6Dd1rUQdkpnVtVPGeBpns6sxe
         SV9A==
X-Gm-Message-State: APjAAAV82q/ni08cbzLm+8vo6yQY7nVqUb5j2w/E8m8345SjZgKcC0LB
        gqZvmhbIIWYtqaUgmqskTfRSxUpooLC4mC71bPF7/iVw
X-Google-Smtp-Source: APXvYqz87rqB/QIfKhqOJYTXIWlggL+2r9djEn7+kkXjeNcme9PwPki1DtdcGrHMI97bW95BRamp4zpbAi2sCuw9iC0=
X-Received: by 2002:a9f:2636:: with SMTP id 51mr55861142uag.16.1561485299474;
 Tue, 25 Jun 2019 10:54:59 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Smith <msmith626@gmail.com>
Date:   Tue, 25 Jun 2019 13:54:48 -0400
Message-ID: <CAH6h+hd5qZdosqavv_ABHKAgRviUidxH_s3HZtLz5Fntg4Y3+A@mail.gmail.com>
Subject: I/O Reordering: Cache -> Backing Device
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

I've been experimenting using bcache and MD RAID on Linux 4.14.91. I
have a 12-disk RAID6 MD array as the backing device, and a decent NVMe
SSD as the caching device. I'm testing using write-back mode.

I've been able to tune the sequential_cutoff so when issuing full
stripe writes to the bcache device, these bypass hitting the cache
device and go right into the MD RAID6 array, which seems to be working
nicely.

In the next experiment, when performing more random / sequential
(mixed) writes, the cache device does a nice job of keeping up
performance. However, when watching the data get flushed from the
cache device to the backing device (the MD RAID6 volume), it doesn't
seem the data is being written out as mostly full stripe writes. I get
a lot of RMW's on the drives, so I don't believe I'm seeing these full
stripe writes. I was sort of hoping/expecting bcache to do some
re-ordering with this... there seem to be some knobs in bcache where
it detects the full stripe size, and it knows partial stripe writes
are expensive.

So I guess my question is if it's known that the data is not
re-ordered using full stripe geometry in bcache, or perhaps this is
just a tunable that I'm not seeing? It seems bcache has access to this
data, but maybe this is a future item where it could be implemented?

The problem of course comes from the the sub-par performance when data
is flushed from the cache device to the backing device... lots of
read-modify-writes result in very poor write performance. If the I/O
was pushed to the backing device as full stripe I/O's (or at least
mostly) I'd expect to see better performance when flushing the cache.

Thanks for your time.

--Marc
