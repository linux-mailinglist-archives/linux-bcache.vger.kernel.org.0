Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B07E365E18
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Apr 2021 19:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhDTRCn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Apr 2021 13:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbhDTRCm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Apr 2021 13:02:42 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FF6C06174A
        for <linux-bcache@vger.kernel.org>; Tue, 20 Apr 2021 10:02:09 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id r8so4673058uaw.12
        for <linux-bcache@vger.kernel.org>; Tue, 20 Apr 2021 10:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=YwviVpR6Rw4w8/38XW1BJj31P3MGQjeBOROoX8j3awA=;
        b=K9+DyCJ2wztmqibKmnlpUET26FgVB4SxTPWG7bZ2O4wuA77V+zmysw7C1KPgcdCO1a
         mZuulaVh/WOYsK4lAvsZ/x6/KBSRib6YbobTR8b5vkyFGWJabzbfKVxUMHM0AYbDzHw+
         71HD7vZl71ni6qjdJFBuGplOtjcO+JNEUoLo1W00VLd7ZwZdD2ljTnAN4xJUQ6sLYJB0
         aFqPnPyKJG3usbmPq859WZ/9C+N+yXgSUvKFBbHtD3vrzz9rj7fHzAtTZeuuP7uk07IC
         t21uXkQ6EIFHwJEzU1H/SheH7cvIYUfwUQ/wRZeMHBAU3whr6GBQ5XcDMSAo21Yqp69C
         WocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=YwviVpR6Rw4w8/38XW1BJj31P3MGQjeBOROoX8j3awA=;
        b=t18ngMxdMlfqJ0KiJiaIsq+4VtLSiTp6wwlaFeQYKHOu8fx8gzVqOTrL3Ip0AHfznk
         AlHagBKVotU388CzXF5UU8r0stt2AeQPm0e2DOL0BM27jt0v+7G4xJEz/U52a4BIUAhT
         GT0Or2v15AeAt4iNej8VeKo2GikJG2DCfThWAfX3lF24ibYdp3kv2cDRfQ61i+/WhFjm
         oOQKc44i/+daV9/cJfqrtAxplJ52ApC/WmpDHg7pM/aUkJZ8JofiE1r3bvQWral5NpV5
         qEOTCEh5WI7OtU5t/kTQ8MeLvdi0Saw8YSkGwByX3YRmBA/fKWThJ9DWNbX4/ulUhO4v
         hPuA==
X-Gm-Message-State: AOAM530Kb7ddGfp7f6v36s+dFpEUZa8ePHDluqLGmjzuYVmW5d+qYDCH
        3S2dL2ZVD5UPa5/hlE/SS6PHmHiYgZmdzAZFbmOnsTJIQQE=
X-Google-Smtp-Source: ABdhPJzcUwW84kp7qJbEH1jufP3HbZSJAck3VSB+WbsUfnMoksG/s5hNAfml3LsAhPoKHo+8v+wiNNFyYpxzuGsdNyQ=
X-Received: by 2002:ab0:1e06:: with SMTP id m6mr13758920uak.16.1618938128494;
 Tue, 20 Apr 2021 10:02:08 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Smith <msmith626@gmail.com>
Date:   Tue, 20 Apr 2021 13:01:57 -0400
Message-ID: <CAH6h+heRQ0m4widKfWSfsqptO0xiXA4BW1pVHow2_+JbNrvZUQ@mail.gmail.com>
Subject: Race Condition Leads to Corruption
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

We are using Linux 5.4.69 (kernel.org) with bcache as a caching layer
in a block storage setup and have encountered a bug which results in
corruption. The corruption manifests as stale data being returned from
a READ operation.

The cause of the corruption is due to a race condition that does not
appear to be handled by bcache. Namely, if an inflight backing WRITE
operation for a block is performed that meets the criteria for
bypassing the cache and that takes a long time to complete, a READ
operation for the same block may be fully processed in the interim
that populates the cache with the device content from before the
inflight WRITE. When the inflight WRITE finally completes, since it
was marked for bypass, the cache is not subsequently updated, and the
stale data populated by the READ request remains in cache. While there
is code in bcache for invalidating the cache when a bypassed WRITE is
performed, this is done prior to issuing the backend I/O so it does
not help.

**Reproduction with Btrace Analysis**
The issue is 100% reproducible by setting up a bcache device using
=E2=80=9Cwritearound=E2=80=9D cache mode and running the following two scri=
pts at the
same time:

Script #1 (named =E2=80=9Cdoit1=E2=80=9D):
--snip--
#!/bin/sh

dd count=3D1 if=3D/dev/zero bs=3D1024k | tr '\0' 'A' > /tmp/a
dd count=3D1 if=3D/dev/zero bs=3D1024k | tr '\0' 'Z' > /tmp/z

while true
do
        dd status=3Dnone if=3D/tmp/a of=3D/dev/bcache0 bs=3D1024k count=3D1=
 oflag=3Ddirect
        dd status=3Dnone if=3D/dev/bcache0 bs=3D4k count=3D1 iflag=3Ddirect=
 | grep Z
        if [ $? -eq 0 ]; then
                killall -9 doit2
                echo found Z
                exit 1
        fi
        dd status=3Dnone if=3D/tmp/z of=3D/dev/bcache0 bs=3D1024k count=3D1=
 oflag=3Ddirect
        dd status=3Dnone if=3D/dev/bcache0 bs=3D4k count=3D1 iflag=3Ddirect=
 | grep A
        if [ $? -eq 0 ]; then
                killall -9 doit2
                echo found A
                exit 1
        fi
done
--snip--

Script #2 (named =E2=80=9Cdoit2=E2=80=9D):
--snip--
#!/bin/sh

while true
do
        dd status=3Dnone of=3D/dev/null if=3D/dev/bcache0 bs=3D4k count=3D1=
 iflag=3Ddirect
done
--snip--

If either script is run by itself, nothing goes wrong. When they are
run concurrently, in less than a second =E2=80=9Cdoit1=E2=80=9D will bomb o=
ut with the
following:
# /tmp/doit2
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=E2=80=A6.
found A
Killed

The output indicates that doit1 found a block of =E2=80=9CA=E2=80=9D when e=
xpected
=E2=80=9CZ=E2=80=9D. The reverse can also occur where =E2=80=9Cdoit1=E2=80=
=9D expected to find =E2=80=9CZ=E2=80=9D and
found =E2=80=9CA=E2=80=9D instead.

So, what is happening? In my setup, I have /dev/sda configured as the
backing drive and /dev/sdb configured as the cache drive. Here are the
block devices with the device numbers written as (MAJOR, MINOR):
249,0 -> /dev/bcache0
8,0 - > backing device =E2=80=9C/dev/sda=E2=80=9D
8,16 -> cache device =E2=80=9C/dev/sdb=E2=80=9D

Backing device settings used:
cache_mode -> =E2=80=98writearound=E2=80=99
sequential_cutoff -> =E2=80=98655360=E2=80=99
writeback_percent -> =E2=80=981=E2=80=99
writeback_delay -> 0

Cache device settings used:
gc_after_writeback -> 1
congested_read_threshold_us -> 0
congested_write_threshold_us -> 0

When a failure occurs, a btrace(8) capture will contain output such as
the following. The lines prefixed with an asterisk are the interesting
ones and below the btrace output is commentary.

    device CPU    seq #  timestamp     PID Action R/W I/O details
(e.g. off + cnt)
    ------ --- --------  ----------- ----- ------ ---
----------------------------
* 1 249,0    0      241  1.634187070 24797      Q  WS 0 + 2048 [dd]
* 2   8,0    0     1866  1.634190230 24797      Q  WS 16 + 2048 [dd]
  3   8,0    0     1867  1.634197750 24797      X  WS 16 / 1040 [dd]
  4   8,0    0     1868  1.634198970 24797      G  WS 16 + 1024 [dd]
  5   8,0    0     1869  1.634199240 24797      P   N [dd]
  6   8,0    0     1870  1.634201060 24797      G  WS 1040 + 1024 [dd]
  7   8,0    0     1871  1.634201290 24797      U   N [dd] 1
  8   8,0    0     1872  1.634201560 24797      I  WS 16 + 1024 [dd]
  9   8,0    0     1873  1.634202810 24797      D  WS 16 + 1024 [dd]
 10   8,0    0     1874  1.634211980 24797      P   N [dd]
 11   8,0    0     1875  1.634212240 24797     UT   N [dd] 1
 12   8,0    0     1876  1.634212400 24797      I  WS 1040 + 1024 [dd]
 13   8,0    0     1877  1.634226710   789      D  WS 1040 + 1024 [kworker/=
0:1H]
 14   8,16   3     1950  1.634265520 18737      C   W 971168 + 8 [0]
 15   8,0    3     2517  1.634347191     0      C   R 16 + 8 [0]
 16   8,0    3     2518  1.634351021   229      C   R 16 + 8 [0]
 17   8,16   3     1951  1.634366511   229      Q   W 1397248 + 8 [kworker/=
3:2]
 18   8,16   3     1952  1.634367601   229      G   W 1397248 + 8 [kworker/=
3:2]
 19   8,16   3     1953  1.634367981   229      I   W 1397248 + 8 [kworker/=
3:2]
 20   8,16   3     1954  1.634371242   948      D   W 1397248 + 8 [kworker/=
3:1H]
*21 249,0    1      235  1.634855557 24798      Q   R 0 + 8 [dd]
*22   8,0    1     1916  1.634873197 24798      Q   R 16 + 8 [dd]
 23   8,0    1     1917  1.634875497 24798      G   R 16 + 8 [dd]
 24   8,0    1     1918  1.634875927 24798      I   R 16 + 8 [dd]
 25   8,0    1     1919  1.634880947  2453      D   R 16 + 8 [kworker/1:1H]
 26   8,16   3     1955  1.635498244     0      C   W 1397248 + 8 [0]
 27   8,0    3     2519  1.635545534     0      C  WS 1040 + 1024 [0]
*28   8,0    3     2520  1.635571594     0      C   R 16 + 8 [0]
 29   8,0    3     2521  1.635574655   229      C   R 16 + 8 [0]
*30   8,16   3     1956  1.635586355   229      Q   W 1395216 + 8 [kworker/=
3:2]
 31   8,16   3     1957  1.635587475   229      G   W 1395216 + 8 [kworker/=
3:2]
 32   8,16   3     1958  1.635587825   229      I   W 1395216 + 8 [kworker/=
3:2]
 33   8,16   3     1959  1.635591285   948      D   W 1395216 + 8 [kworker/=
3:1H]
*34   8,0    3     2522  1.635737956     0      C  WS 16 + 1024 [0]
 35   8,0    3     2523  1.635738966     0      C  WS 2064 [0]
*36   8,16   3     1960  1.635743666     0      C   W 1395216 + 8 [0]
 37 249,0    1      236  1.636092640 24799      Q   R 0 + 8 [dd]
 38   8,16   1       69  1.636100850 24799      Q   R 1395216 + 8 [dd]
 39   8,16   1       70  1.636104400 24799      G   R 1395216 + 8 [dd]
 40   8,16   1       71  1.636104970 24799      I   R 1395216 + 8 [dd]
 41   8,16   1       72  1.636109960  2453      D   R 1395216 + 8 [kworker/=
1:1H]
*42 249,0    0      242  1.636338843 24800      Q   R 0 + 8 [dd]
*43   8,16   0       72  1.636346203 24800      Q   R 1395216 + 8 [dd]
 44   8,16   0       73  1.636349653 24800      G   R 1395216 + 8 [dd]
 45   8,16   0       74  1.636350223 24800      I   R 1395216 + 8 [dd]
 46   8,16   0       75  1.636355133   789      D   R 1395216 + 8 [kworker/=
0:1H]
*47   8,16   3     1961  1.636643156     0      C   R 1395216 + 8 [0]

Line #1: =E2=80=9Cdd=E2=80=9D queues a 1MiB (2048 sector) WRITE at offset 0=
 from
/dev/bcache0 (249, 0). In doit1 this is a result of this command:
dd status=3Dnone if=3D/tmp/a of=3D/dev/bcache0 bs=3D1024k count=3D1 oflag=
=3Ddirect

Line #2: in turn, bcache queues a 1MiB WRITE. Note the address is 16
and not 0 because the first 8K of the backing device is used
internally by bcache. i.e. when translating from /dev/bcache0 offset
to /dev/sda, there is a +16 sector shift.

Line #21: =E2=80=9Cdd=E2=80=9D from doit2 queues a 4K (8 sector) READ at of=
fset 0 from
/dev/bcache0 (249, 0) due to this command:
dd status=3Dnone of=3D/dev/null if=3D/dev/bcache0 bs=3D4k count=3D1 iflag=
=3Ddirect

Line #22: In turn bcache queues a 4K (8 sector) READ =E2=80=9Cdd=E2=80=9D t=
o the
backing device (8,0) at sector offset 16.

Line #28: The 4K READ from Line #22 completes

Line #30: Bcache Queues a WRITE to sector 1395216 of 8K on the CACHE
device (8,16). This is a copy of what was just read at Line #22 / Line
#28. This data is what at the sector 16 from the backing device (8, 0)
before Line #1 was ever run.

Line #34: The I/O initiated at Line #2 finally completes. Sector 16 on
the backing device (8, 0) now contains the correct data.

Line #36: The I/O queued at Line #30 containing the old, stale data
completes. At sector 1395216, the CACHE now contains STALE version of
the data that supposed to be the same as what is at sector 16 in the
BACKING DEVICE.

Line #42: The bcache device (249,0) is read as a result of this
command in doit1:
dd status=3Dnone if=3D/dev/bcache0 bs=3D4k count=3D1 iflag=3Ddirect | grep =
Z

Line #43: In turn, the bcache does a cache lookup, gets a HIT, and
initiates a READ starting at sector 1395216 of the cache device (8,16)

Line #47: The READ initiated at Line #43 completes and the doit1
script sees bad data and bombs out


To recap, a long running WRITE to the backing device that bypasses the
cache is allowing a READ for the same block on the backing device to
sneak in, get to the disk first, return and populate the cache with
stale data. When the WRITE completes, the cache is not invalidated. As
a result, a subsequent READ sees the stale data.

To confirm the bypass theory, we ran another experiment which we are
unable to fail using the scripts above where writes are NOT bypassed
(eg, all incoming writes go to cache). We use the following settings
for cache + backing device:
cache_mode -> =E2=80=98writeback=E2=80=99
sequential_cutoff -> =E2=80=980=E2=80=99
writeback_percent -> =E2=80=981=E2=80=99
writeback_delay -> 0
gc_after_writeback -> 1
congested_read_threshold_us -> 0
congested_write_threshold_us -> 0

This essentially forces all writes to go to the cache device and not
bypass; with the parameters above, the test *passes* (we are unable to
induce a failure).


We also tested using the latest stable kernel.org Linux (5.11.15) and
it fails there as well:
[root@localhost tmp]# uname -a
Linux localhost.localdomain 5.11.15 #1 SMP Tue Apr 20 09:50:04 CDT
2021 x86_64 x86_64 x86_64 GNU/Linux

[root@localhost tmp]# /tmp/doit1 &
[1] 32924
[root@localhost tmp]# 1+0 records in
1+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.00218758 s, 479 MB/s
1+0 records in
1+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.00172663 s, 607 MB/s

[root@localhost tmp]# /tmp/doit2
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
found Z
Killed


Any guidance would be greatly appreciated; we have a couple potential
ideas for fixes but wanted to check if the bcache community is aware
of this problem, and if there are any proposed fixes, or something
else that we are missing. All the kernel code was compiled using GCC
8.x.


Thanks,

Marc
