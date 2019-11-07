Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5DFF3282
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Nov 2019 16:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388675AbfKGPNM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Nov 2019 10:13:12 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:34311 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388728AbfKGPNL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Nov 2019 10:13:11 -0500
Received: by mail-vs1-f66.google.com with SMTP id y23so1525990vso.1
        for <linux-bcache@vger.kernel.org>; Thu, 07 Nov 2019 07:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Q+kEJEGlZZTKE7RlR/gcVL1e0saBkIFyIbZQJpXvkdk=;
        b=qmlbEz9PaYCxWljYpJDv0pC7TX/XBOMq78CIUax4c1UAw+CUE/wIANm20ea3MIQqA1
         q9+zk/Hyp7Jk32jP0RrwfymdoySuPo8xiQlhmvLqppB4cyosspPzPzs/EzvQKdrArjcr
         HC5bxR+Ncd5/UVt+vy7WvdIscT4Suc0lthnXNU93unq2xSnJ5rlBMwl7nQLHGxbSrrW9
         MX6hw24x5Us6N/tbl11jw0gMfm6XpL4/zgccKX0hh6o87KXrZV0i9B5rpPiMxE8R9HEF
         Jv8f5ZnvF8K/2BdqCDtDhjs1L4m6DQdxvVEmiAd/CyHsSAxrHxAlESYPusjrUMQdP2m/
         KaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Q+kEJEGlZZTKE7RlR/gcVL1e0saBkIFyIbZQJpXvkdk=;
        b=IIh4oatU6H6kU75ZL1Sq2y+kWPD1uNP93awV0FhHjpKx/4DENs6yxBV8EHLIViAchJ
         Kl1z1RwPj6l3hrl2MDU3eu+K8abjPN6mfXFVIg3tTzZw7hW6nkP7GoG4omuq87zDxZUw
         pKZOZM9wGtNtP+EFBqdwxkYQsRVHRQkXM73Arl8ZDDbnLgz7LDQBDBaqbTmoA97ztZOS
         Xm6fwEAwNwAyJqmTNw/w/ORCD166RF2EXD+9+pbhg45kqxzUigUi+ZihsTPYTWU71aio
         uvuGi+iZtadUD1OD29LXSoqPiqxmjVygua5TiK0l1B9AVMHpfvJg8jb0rHJYDN8ZCSKT
         p8KA==
X-Gm-Message-State: APjAAAVtWJD34QXqyUp2g7phMAW8cA+SGQZWHxVZLEqKqPF/E99Fqwun
        dNKnZ6K7HpZ2Ah22ld5c/Gs1c3p5zbZRfMmb3H1SRejUSdo=
X-Google-Smtp-Source: APXvYqwDne/zQ5uOBBtgTrCmtFwgWcX+TdYhWHZekzr1JFf3saqLav20Uuyo3RCpLv+MEcGTkKOdwGUWGdnUGff16Is=
X-Received: by 2002:a67:ec13:: with SMTP id d19mr2225174vso.36.1573139590140;
 Thu, 07 Nov 2019 07:13:10 -0800 (PST)
MIME-Version: 1.0
From:   Ville Aakko <ville.aakko@gmail.com>
Date:   Thu, 7 Nov 2019 17:12:59 +0200
Message-ID: <CAEP-KKvhWT=pgHRbr3bRSzMoK7Nj00aPn+xGXBD9hgN8LP1DWw@mail.gmail.com>
Subject: Poor read performance with bcache (as if no caching actually takes place)
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi!

(Similar post also at Arch Linux forum here:
https://bbs.archlinux.org/viewtopic.php?id=250525 ; better formatting
there for code blocks etc.; sorry for the lengthy post, I'm trying to
be concise while also posting all relevant information).

I seem to be having problems getting bcache working properly at the
moment. The problem is that no matter what I've tried, the performance
for reads is as if the cache was not there (this is a Desktop
computer, and as such mostly I'm interested in a "hot data" cache;
write caching is of lesser importance).

FWIW I used to have a working bcache setup with a SATA SSD, and know
roughly what kind of performance boost to expect (on bootup etc.).

Summary of the setup:

* kernel-5.3.8 (and various older ones, but recent-ish kernels; on
Arch Linux in case that makes a difference)
* caching device: Samsung 960EVO 500GB, whole device as the single
cache device (nvme0n1)
* The NVME SSD has been on the Motherboard M.2 slot (Asus Maximus VII
Gene) and on a separate PCIe card in a 3.0 PCIe slot (no effect which
one is used, currently on the PCIe adapter)
* backing device: many 5400RPM HDDs (WD Red 4+4+8GB) and partitions
(the main one is shown below as /dev/sdc2). Formatted as ext4.
* Current set (backing and cache) was created with default options,
except discard was enabled (make-bcache --discard -C ; make-bcache
-B).

bcache-super show listings of relevan devices:

$ sudo bcache-super-show /dev/sdc2
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 FC6434BAB97C1B37 [match]
sb.version              1 [backing device]

dev.label               (empty)
dev.uuid                063814f0-a14b-4db5-9cd5-b98ef658993f
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.data.first_sector   16
dev.data.cache_mode     1 [writeback]
dev.data.cache_state    2 [dirty]

cset.uuid               d6420bd9-a45f-4688-a9c0-217c88072449

And the cache itself:

$ sudo bcache-super-show /dev/nvme0n1
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 70AE2DCA768AC61A [match]
sb.version              3 [cache device]

dev.label               (empty)
dev.uuid                7e099d6e-3426-49d8-bf55-1e79eacd59a4
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.cache.first_sector  1024
dev.cache.cache_sectors 976772096
dev.cache.total_sectors 976773120
dev.cache.ordered       yes
dev.cache.discard       yes
dev.cache.pos           0
dev.cache.replacement   0 [lru]

cset.uuid               d6420bd9-a45f-4688-a9c0-217c88072449

Curiously, there still seems to be decent amount of cache hits. Maybe
the cache device is reading too slow? Or some bug prevents the cached
data from being used (and the HDD is read)? I can see from a LED (on
the NVMe adapter card) the SSD is trying to read (or write) data, but
performance is just bad.

In stats_total (of bcache2/bcache/stats_total):

$ grep -H . *
bypassed:288.8M
cache_bypass_hits:1359
cache_bypass_misses:32500
cache_hit_ratio:87
cache_hits:3186
cache_miss_collisions:1
cache_misses:436
cache_readaheads:0

Rough speed test (to see the interfaces are working as expected):

$ sudo hdparm -Tt --direct /dev/nvme0n1

/dev/nvme0n1:
 Timing O_DIRECT cached reads:   4988 MB in  2.00 seconds = 2495.19 MB/sec
 HDIO_DRIVE_CMD(identify) failed: Inappropriate ioctl for device
 Timing O_DIRECT disk reads: 5052 MB in  3.00 seconds = 1683.84 MB/sec

And for comparison:

$ sudo hdparm -Tt --direct /dev/sdc

/dev/sdc:
 Timing O_DIRECT cached reads:   988 MB in  2.00 seconds = 493.55 MB/sec
 Timing O_DIRECT disk reads: 552 MB in  3.00 seconds = 183.97 MB/sec

Things I've tried (including):

* align with -w 4k and --bucket 2M (partially guesswork as it is
difficult to say what the EBS size is on the SSD),
* create the caching device with and without discard,
* decrease sequential_cutoff to 0
* thresholds to 0 (in /sys/fs/bcache/...)
* change write cache mode (writeback -> writethorough and IIRC also
writearound, but well, it should work regardless)
* recently deleted all partitions on the SSD and made the whole 500GB
device a backing device

The last thing (create cache on the device itself) was done in the
hopes it is an alignment issue. This time, I didn't touch the default
bucket and block sizes (as there should be decent performance increase
even with non-optimal alignment - it's mainly meant to reduce wear
leveling in any case, unless I'm mistaken). However, seems the
performance is still atrociously bad, as in the SSD makes no effect
whatsoever compared to it being absent.

Any ideas are welcome, as to what might be wrong! Will be happy to
post more information, too :-)

Cheers!

p.s. Some more (not so relevant) background: This is a desktop
computer (mainly a toy but also for occasional serious stuff). I used
to have a SATA SSD (Samsung EVO 840 IIRC). It was replaced by an NVME
SSD, Samsung 960 EVO (500GB). I know roughly what the performance
should be with SSD read caching working; with the previous SATA SSD,
boot from power off (after Linux Kernel has been loaded) was ~15
seconds until the desktop environment has settled, and ~60seconds+
with a bare mechanical 5400RPM HDD (with KDE Plasma and some
applications autostarting, including Firefox and tvheadend in the
background). I actually got a bit of real-life benchmarks left from
the days the caching used to work (things such as loading StarCraft
II, starting LibreOffice, starting Blender etc. with and without the
data in bcache - I can provide these numbers in case semone is
interested; depending on application / test, loading times were cut
into 1/4 -> 1/6th of the time). The only change in this setup is that
the cache moved from SATA -> NVME, after which I've had these
problems. IIRC I never got bcache to work properly for read caches
with the NVME SSD, although it should be better than the previous SATA
SSD!

--
Ville Aakko - ville.aakko@gmail.com
