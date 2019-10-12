Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307C1D505F
	for <lists+linux-bcache@lfdr.de>; Sat, 12 Oct 2019 16:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbfJLOXy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 12 Oct 2019 10:23:54 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:43337 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727642AbfJLOXy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 12 Oct 2019 10:23:54 -0400
Received: by mail-lf1-f43.google.com with SMTP id u3so8935749lfl.10
        for <linux-bcache@vger.kernel.org>; Sat, 12 Oct 2019 07:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=L0mDZV+IVRVsc/hohSVtpXPPLgYwSDor3yDAmFtvLz4=;
        b=IRt6OkinxEDZn1ggk+SB8QPDv2hW3IxWepcN1KqEawtpsK8VOlrFo+x0mBO3gVfuq8
         3NCRyJDPQCrq/G2FHnmHiKhkCg4w2P7nLObhSdMD6KJwRZU0hnBu1kb4ewvUKeqBX/75
         FnReY7prdTfd0aPwKtzMpyyvrRmVpMWpxBIXn+PrNLxTH8Kgv6EB2rk6HGdQqW7xH93Z
         6k9KW6+7q3iibGOvjP5yfM2V6/rsslf1EFY6XG9LMayzhf8TxgpZ7dqBmz6JdYilt2vt
         hP1g/fT2yN41F/3SccPn2dnIaWF2bKx/DClibGbwmqNYayTMDW4WjfLNiKcE+SV04Cqv
         8beQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=L0mDZV+IVRVsc/hohSVtpXPPLgYwSDor3yDAmFtvLz4=;
        b=V4QYqRFCpqYZl2bQ3pD0Pn7jFy6Whfqyi9HL2/x6Jk/HzS4a0LkV9MaW/6D8mBO2kZ
         30bs8GTQGp0Woj0VFyi6eYWSBQbl0ahNXNF4xGLY+MK5VqDndKN2AbfDc4WAgY+weHMN
         slK8g9rBHLdSWb7kTQM+mDj7cNuOSH4Qiwohd3sxOl1DrkgO/XCqZhGVwzztBer9ADda
         E+1mC3r8GXIf/wQ5IiT5tqH01s2f+Qv8eQr7YixYwa/yNZpJywq5wUy4yswPCf0ttL6C
         ADZ618aT4WkSRwZc2qTWX7pbIaDWqzv7h0EDssOP5R5XwdBlID9Lrroq7enkKJu4kxji
         oSdw==
X-Gm-Message-State: APjAAAWdaiL+KT8dgr4H/FnVfNplcTM1hAG5uJ9YNJvxUka5Gwr0AKRk
        93gyZ9rXNZscUt7G/o6hxFRVYR7rscnjVNXuZCf3Lwk1FPI=
X-Google-Smtp-Source: APXvYqyawR37Q6vd1bVb+0oHmxv8G2dQ1oAIIYc7/kvz18GbcrNjqFLcUiiJp+K8TVor1J5PJasxLbPsIt3Ycabe8DM=
X-Received: by 2002:a19:9114:: with SMTP id t20mr11112753lfd.143.1570890231601;
 Sat, 12 Oct 2019 07:23:51 -0700 (PDT)
MIME-Version: 1.0
From:   Sergey Kolesnikov <rockingdemon@gmail.com>
Date:   Sat, 12 Oct 2019 17:23:40 +0300
Message-ID: <CAExpLJg86wKgY=1iPt6VMOiWbVKHU-TCQqWa0aD1OA-ype07sw@mail.gmail.com>
Subject: Getting high cache_bypass_misses in my setup
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello everyone.

I'm trying to get my bcache setup running, but having almost all my
traffic bypassing the cache.
Here are some stats that I have:


root@midnight:~# cat
/sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/bypassed
2.8G
root@midnight:~# cat
/sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_bypass_misses
247956
root@midnight:~# cat
/sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_bypass_hits
5597
root@midnight:~# cat
/sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_hits
233
root@midnight:~# cat
/sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_misses
243

And now for my machine setup.
Running ubuntu 18.04 LTS with 5.0.0-31-lowlatency kernel.
Cache device is a partition on NVMe PCI-e SSD with 4k logical and
physical sector size.
Backing device is LVM logical volume on a 3-drive MD RAID-0 with 64K
stripe size, so it's optimal IO is 192K.
I have aligned backing-dev data offset with
make-bcache -B -o 15360 --writeback /dev/vm-vg/lvcachedvm-bdev

I have tried all recommendations for routing traffic to SSD:

echo 0 > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/congested_read_threshold_us
echo 0 > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/congested_write_threshold_us
echo 0 > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/sequential_cutoff

But I still get almost all traffic going to cache_bypass_misse. BTW,
what does this stat mean? I don't get it from the in-kernel manual

Any help?..

Thank you.
Best regards,
Sergey E. Kolesnikov
