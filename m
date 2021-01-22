Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116AD300AD1
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Jan 2021 19:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbhAVRWu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 22 Jan 2021 12:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729608AbhAVQy3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 22 Jan 2021 11:54:29 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91F6C06174A
        for <linux-bcache@vger.kernel.org>; Fri, 22 Jan 2021 08:53:05 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c2so7048942edr.11
        for <linux-bcache@vger.kernel.org>; Fri, 22 Jan 2021 08:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hjt7g9Sd9z9XByQpSWlYfUSxlLbsDu2HNNBhlR833iM=;
        b=eR7ub1sz6rV+em/h20Q5b9/vRdWg9B/7oVnMVw710VsN9qshpY0hy8oqvPIr6fs5Iw
         FHEoA6ov4TEeBMBRPUoAmJLbEelxrxobkBcg9K3IZKLG5o7URank1i4BMMi1ngwTkyAF
         2d1yGmvAs7LszL98+r+mzjbHXPsTAWDkADA81clseYzemU8O5IbHj2OL6DrZAfWvXKL4
         9uI9Twlporo56GEKhiPp7Wo70UESqC1HEsyxGmP/xDwEqf0kbyoEHV52FMmzH25oJqz9
         jf9tgjPmODSwk1PrDYFa1iiMh/AvTf7+JgfRGXn6KG46yfwViqAn4+CnX+BCsnl7J1mA
         Qa1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hjt7g9Sd9z9XByQpSWlYfUSxlLbsDu2HNNBhlR833iM=;
        b=Ow68jvjCrMa6ahFPUSP84XGuT0wH/t9YvmfZRrYJ1687vwacBejvmyKQYML55wGj6a
         4FZItVJ+P/CEe8SOvEue3S2VItSgbWzn9I0omPD9CSBewrYNpDRN31Xfk2Sfh6zBFBax
         ESEKMPc3nQrkn0HszQRmMWgKk7ZRqpJbuCup6dEMafkYrujyu6VzgaEvOKt08/Zua73P
         nUh1vJEsmVXk07j/+YlJBMJYuXAxthDyTOMyfdRwIf9URgSQy/qr9N4OvAy3dVbqPi8O
         8KtD7PnKS4qg6yZSiHrR+79Y2YjPgpAivHL2HELKEPaHXZgCemoWO2bkCPaRtNfZf064
         C7uQ==
X-Gm-Message-State: AOAM532mQQF+FyERdC/z4fU8Q3t/cvvFO8Z+8jng5LC9Y8v4Wl3nr/Jv
        wuDT5V6apGSzKhkCiT5CuBFpU1rXjaEbfNkJIdjSo8CH2xVkWg==
X-Google-Smtp-Source: ABdhPJx2CBnIiA228/8ZsDTghfUA4QdqO8gbcTmFm/qS7zS54VVbYTvoFpklhWyTm9MQuUSkwKcpDCp8w38OG9WRyy8=
X-Received: by 2002:aa7:d0d4:: with SMTP id u20mr3717420edo.203.1611334384335;
 Fri, 22 Jan 2021 08:53:04 -0800 (PST)
MIME-Version: 1.0
From:   Brendan Boerner <bboerner.biz@gmail.com>
Date:   Fri, 22 Jan 2021 10:52:53 -0600
Message-ID: <CAKkfZL06PzvN6M+A+RC6C-eTL9uNReQTDbqHGRFbmRA9BzVUtQ@mail.gmail.com>
Subject: How to release backing device from bcache?
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

How do I get bcache to completely give up access to a backing device
so I can mount it using losetup?

My backing device is an lvm logical volume which I expanded in size.

I want to mount it using losetup to use xfs_growfs however I can't
access the backing device:

root@timber4:/var/log# umount /mnt/archives/ ; echo 1 >
/sys/block/bcache1/bcache/stop ; echo 1 > /sys/block/dm-1/bcache/stop
; losetup -o 8192 /dev/loop0 /dev/vg-bfd02/archives_bc
-bash: /sys/block/dm-1/bcache/stop: No such file or directory
losetup: /dev/vg-bfd02/archives_bc: failed to set up loop device:
Device or resource busy

I know in some cases udev is scurrying in and causing the cache to be
recreated but even immediately after the stop and before udev can get
in the backing device is still locked:

Jan 22 11:48:33 timber4 kernel: [370093.820204] XFS (bcache1):
Unmounting Filesystem
Jan 22 11:48:33 timber4 kernel: [370093.830609] bcache:
bcache_device_free() bcache1 stopped
Jan 22 11:48:33 timber4 systemd[1]: Stopped File System Check on
/dev/disk/by-uuid/cb9c1149-73b8-4929-bcc6-d1599d41da73.
Jan 22 11:48:33 timber4 kernel: [370093.904348] bcache:
register_bcache() error /dev/dm-1: device busy

I was able to do this in the past when I first started learning to use
bcache which is why this is especially perplexing.

Suggestions?

Thanks,
Brendan
