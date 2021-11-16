Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC37452EBA
	for <lists+linux-bcache@lfdr.de>; Tue, 16 Nov 2021 11:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbhKPKNw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 16 Nov 2021 05:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbhKPKNt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Nov 2021 05:13:49 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A86C061570
        for <linux-bcache@vger.kernel.org>; Tue, 16 Nov 2021 02:10:53 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id q74so55877447ybq.11
        for <linux-bcache@vger.kernel.org>; Tue, 16 Nov 2021 02:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=uWMFQgYnSJL6nVRP/65AJvYO7Fbf+NOdHFy0RZX0bWc=;
        b=imi4zDUHr09iBAREcbFSshO7HE3eI9WoO2ZnXsS//qE7gUbBL2d15P3GnNjkVD+ASi
         1An5NoLQiQB9ygRMBpWEjOCh+xqgJxNc6bNyl5QGt8qj30QrnukL2docPHKaMqPN8ZdQ
         Z0nO6Eedg52fyfZhukK3pvHxqw/d5dfiiNdRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=uWMFQgYnSJL6nVRP/65AJvYO7Fbf+NOdHFy0RZX0bWc=;
        b=eTv4qEStHDLaV9s3AwLO0ueX5UAyyv/m1adLUVR/9y+rNC7d2oEXcgu7k4msu6ZMj6
         Bg37N/AexsvNrOvho9meRwBI8HwvTLjGRbYZUDive1/tycUawd6zZelzLdW2fME4e9Nm
         suGg+OUbEIKZ9PJ7iyAi9HCUVuc3AbYfZkA4VYBErxyPlTlOnd6/SYWtrVLFRMayq9V2
         KHEg/fKRrRWIlB/iDQtlF4ji57SBKkDgWFi1/thLhFz+kiNefvu9eTy8KQqI0MiZA/jA
         bzDXXWKSeJ4hMZpuE3Bbli2ku2umV86QJjag8nDhsru39yF+nYJwAyMplj4BBE/UPckj
         FiMg==
X-Gm-Message-State: AOAM533pnjI86Pwi1mtirbXYXbnwxL/wZeOrQTLiC37Y4bNbdB5RIVJ9
        0DjhLUyXL8ho1OuCTB76Hfo3R6Du8EMhdrTRYpCjWhlb2IUBKA==
X-Google-Smtp-Source: ABdhPJz4jK4d1y5haDhdM2cpeUueouIBC3ck8FQNt6dH53BRaregXbBAC8Svo3ZrsxpM/pa2NCw1NVn8Dl4pdk2BU4g=
X-Received: by 2002:a25:800f:: with SMTP id m15mr6799337ybk.525.1637057452374;
 Tue, 16 Nov 2021 02:10:52 -0800 (PST)
MIME-Version: 1.0
From:   Kai Krakow <kai@kaishome.de>
Date:   Tue, 16 Nov 2021 11:10:41 +0100
Message-ID: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
Subject: Consistent failure of bcache upgrading from 5.10 to 5.15.2
To:     linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Coly!

I think I can consistently reproduce a failure mode of bcache when
going from 5.10 LTS to 5.15.2 - on one single system (my other systems
do just fine).

In 5.10, bcache is stable, no problems at all. After booting to
5.15.2, btrfs would complain about broken btree generation numbers,
then freeze completely. Going back to 5.10, bcache complains about
being broken and cannot start the cache set.

I was able to reproduce the following behavior after the problem
struck me twice in a row:

1. Boot into SysRescueCD
2. modprobe bcache
3. Manually detach the btrfs disks from bcache, set cache mode to
none, force running
4. Reboot into 5.15.2 (now works)
5. See this error in dmesg:

[   27.334306] bcache: bch_cache_set_error() error on
04af889c-4ccb-401b-b525-fb9613a81b69: empty set at bucket 1213, block
1, 0 keys, disabling caching
[   27.334453] bcache: cache_set_free() Cache set
04af889c-4ccb-401b-b525-fb9613a81b69 unregistered
[   27.334510] bcache: register_cache() error sda3: failed to run cache set
[   27.334512] bcache: register_bcache() error : failed to register device

6. wipefs the failed bcache cache
7. bcache make -C -w 512 /dev/sda3 -l bcache-cdev0 --force
8. re-attach the btrfs disks in writearound mode
9. btrfs immediately fails, freezing the system (with transactions IDs way off)
10. reboot loops to 5, unable to mount
11. escape the situation by starting at 1, and not make a new bcache

Is this a known error? Why does it only hit this machine?

SSD Model: Samsung SSD 850 EVO 250GB

Thanks,
Kai
