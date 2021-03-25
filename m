Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C043492B3
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Mar 2021 14:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhCYNGB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 25 Mar 2021 09:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhCYNFi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Mar 2021 09:05:38 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211A2C06174A
        for <linux-bcache@vger.kernel.org>; Thu, 25 Mar 2021 06:05:38 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id u20so2956945lja.13
        for <linux-bcache@vger.kernel.org>; Thu, 25 Mar 2021 06:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lXDLMpabwoGXXgtZUveNeWwq0cxUExbwu98qUr1LN54=;
        b=I1rbnGO5Bk4mMqTng7BvLathsJSp0DqsPKPdKSx9sGei0mfTTU4ynbxoBZEsPE3RCJ
         E9tE7fOhmORtgh8R3AM2/rBdWLwRJotzr4BgyrDQ6w3cv+R1TrneChCrP4QEGn1wVb6G
         8e2vAo8wwu+Eg6Gdh6BaxVqiXb4Ln2qNHI0lYmNFRUGueHLWlrVgH1MVsbxvwOT6f3Hs
         s0EnuegaCR1GD+yTdC0/YHdMI5o2V+1fwJ81j1lANIy3yUWrYMKM+7tEg1rdWgi30oAc
         Pi9bziPVD8a7xJDcEd+Td45oKJo9K9VCSD1wMz7si6paOMZvbbAK9xtIDqdOpCzf1z7j
         /JmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lXDLMpabwoGXXgtZUveNeWwq0cxUExbwu98qUr1LN54=;
        b=nZbNGsz9xMLpL6hPPcgbtcmq+D+f+O/M6zhrMYdyEND2PK9Kk8q/fqsiXkgvoGuwtO
         5balOj1UPVG+C14St7pYPK0QgY/DZbDfH/OBn4H+hivG9TuJAcVQkJFoDyBVnlX6x14H
         IWnn0aRtjqxa+HQAtJnxP4kmzfUkcBM+zbtDpiuNNh3uzTJDP+5sijybg5M/OlbQmczI
         5bDpX0/Lu/ST786ltGcGBGIlPnh+POQZMZzGEfcL/3/YHuWzcn4UyL2VlKn3wshxQYTz
         yNjyPEm0R89z1PVl5BDHt2F1UWskO6V5VmDBOyPj8R137hMGjSziScCw/6vH11gom3x8
         9L6Q==
X-Gm-Message-State: AOAM532hfAYbnto3Yw194ywmRt434V9Q5EATI1VUc7FyiR73Pl6OECc1
        oB+iC32pw7cGZNNvtsmziOSwxG3RvjxLaRKx620=
X-Google-Smtp-Source: ABdhPJxdT/FC/wK+R1HbZU7eN0HU5qWV71qKCpnqk0LJ/eZgSBehNqi6YS4sR7WkR9sD2jURx1tQSivr0djTmcN0Lto=
X-Received: by 2002:a2e:b806:: with SMTP id u6mr5461079ljo.99.1616677532996;
 Thu, 25 Mar 2021 06:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <CANA18Uzd6FK-vEOjakAPW5ZXPG=7OrzYSQvD8ycE5jyxDfAr6g@mail.gmail.com>
 <e0969226-5352-6b57-8fe7-9e672e30174b@suse.de>
In-Reply-To: <e0969226-5352-6b57-8fe7-9e672e30174b@suse.de>
From:   Martin Kennedy <hurricos@gmail.com>
Date:   Thu, 25 Mar 2021 09:05:20 -0400
Message-ID: <CANA18UzWzTKsku_M1z38UCsFOnsxL5pN0998g9KVNeqD05ffpQ@mail.gmail.com>
Subject: Re: A note and a question on discarding, from a novice bcache user
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I don't think the garbage collection performed by bcache actually
sends TRIMs to the SSD unless you turn on discard. Without sending
TRIMs you cannot expect a cheap SSD (or pair of cheap ones in RAID1)
to keep up performance.

After some small load over the month past, I've done another test to
verify that performance has not degraded:

$ fio -filename=/devel/testfio.file -direct=1 -rw=randwrite -bs=4k
-size=1G  -name=randwrite -runtime=60
randwrite: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B,
(T) 4096B-4096B, ioengine=psync, iodepth=1
fio-3.16
Starting 1 process
randwrite: Laying out IO file (1 file / 1024MiB)
Jobs: 1 (f=1): [w(1)][100.0%][w=27.7MiB/s][w=7094 IOPS][eta 00m:00s]
randwrite: (groupid=0, jobs=1): err= 0: pid=513814: Thu Mar 25 12:52:04 2021
  write: IOPS=7777, BW=30.4MiB/s (31.9MB/s)(1024MiB/33707msec); 0 zone resets
    clat (usec): min=57, max=53532, avg=125.70, stdev=287.27
     lat (usec): min=58, max=53533, avg=126.01, stdev=287.29
    clat percentiles (usec):
     |  1.00th=[   70],  5.00th=[   71], 10.00th=[   71], 20.00th=[   72],
     | 30.00th=[   73], 40.00th=[   75], 50.00th=[   77], 60.00th=[   81],
     | 70.00th=[   95], 80.00th=[  128], 90.00th=[  192], 95.00th=[  249],
     | 99.00th=[ 1037], 99.50th=[ 1696], 99.90th=[ 3228], 99.95th=[ 3949],
     | 99.99th=[ 9241]
   bw (  KiB/s): min=19192, max=39880, per=100.00%, avg=31107.36,
stdev=4819.32, samples=67
   iops        : min= 4798, max= 9970, avg=7776.84, stdev=1204.83, samples=67
  lat (usec)   : 100=71.35%, 250=23.70%, 500=3.31%, 750=0.37%, 1000=0.24%
  lat (msec)   : 2=0.65%, 4=0.32%, 10=0.04%, 20=0.01%, 50=0.01%
  lat (msec)   : 100=0.01%
  cpu          : usr=4.02%, sys=33.88%, ctx=262663, majf=0, minf=47
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,262144,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=30.4MiB/s (31.9MB/s), 30.4MiB/s-30.4MiB/s
(31.9MB/s-31.9MB/s), io=1024MiB (1074MB), run=33707-33707msec

Disk stats (read/write):
    dm-6: ios=0/261662, merge=0/0, ticks=0/24716, in_queue=24716,
util=98.71%, aggrios=0/262299, aggrmerge=0/0, aggrticks=0/24696,
aggrin_queue=24696, aggrutil=98.66%
    bcache0: ios=0/262299, merge=0/0, ticks=0/24696, in_queue=24696,
util=98.66%, aggrios=11/133234, aggrmerge=0/3, aggrticks=12/12798,
aggrin_queue=1132, aggrutil=99.34%
  sdh: ios=23/266352, merge=0/7, ticks=24/25596, in_queue=2264, util=99.34%
    md0: ios=0/117, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=0/93, aggrmerge=0/0, aggrticks=0/988, aggrin_queue=810,
aggrutil=2.15%
  sdn: ios=0/94, merge=0/1, ticks=0/904, in_queue=716, util=1.95%
  sdm: ios=0/93, merge=0/0, ticks=0/894, in_queue=716, util=2.00%
  sdl: ios=0/95, merge=0/0, ticks=0/731, in_queue=548, util=2.09%
  sdk: ios=0/95, merge=0/0, ticks=0/1025, in_queue=848, util=2.15%
  sdj: ios=0/92, merge=0/0, ticks=0/921, in_queue=756, util=2.01%
  sdi: ios=0/94, merge=0/1, ticks=0/1189, in_queue=1028, util=2.04%
  sdg: ios=0/93, merge=0/1, ticks=0/1139, in_queue=952, util=2.02%
  sdf: ios=0/93, merge=0/0, ticks=0/1179, in_queue=984, util=1.99%
  sde: ios=0/92, merge=0/0, ticks=0/823, in_queue=652, util=2.01%
  sda: ios=0/93, merge=0/1, ticks=0/1081, in_queue=904, util=2.01%

And indeed, performance has not fundamentally degraded at all as it
had before for me on cheaper EVOs.

The next experiment must be to verify that a RAID1 of two SSDs
properly accepts TRIMs from bcache.

Martin

On Thu, Feb 25, 2021 at 11:12 AM Coly Li <colyli@suse.de> wrote:
>
> On 2/22/21 8:54 AM, Martin Kennedy wrote:
> > I use bcache on some Dell R510s, using an IT-mode HBA, 10 3TB SAS
> > drives and one 120GB, DRZAT-capable SSD as my caching device.
> >
> > I noticed my `fio` benchmarks weren't what they once were, despite
> > starting with writeback caching, almost no dirty_data, and 10
> > writeback_percent. Running `fio -filename=/devel/testfio.file
> > -direct=1 -rw=randwrite -bs=4k -size=1G  -name=randwrite
> > -runtime=60`, I got:
> >
> >
> > randwrite: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B,
> > (T) 4096B-4096B, ioengine=psync, iodepth=1
> > fio-3.16
> > Starting 1 process
> > Jobs: 1 (f=1): [w(1)][100.0%][w=1100KiB/s][w=275 IOPS][eta 00m:00s]
> > randwrite: (groupid=0, jobs=1): err= 0: pid=961776: Sun Feb 21 23:50:25 2021
> >   write: IOPS=710, BW=2841KiB/s (2909kB/s)(166MiB/60001msec); 0 zone resets
> >     clat (usec): min=57, max=109650, avg=1403.63, stdev=5516.41
> >      lat (usec): min=57, max=109651, avg=1404.13, stdev=5516.43
> >     clat percentiles (usec):
> >      |  1.00th=[    70],  5.00th=[   105], 10.00th=[   126], 20.00th=[   155],
> >      | 30.00th=[   172], 40.00th=[   190], 50.00th=[   204], 60.00th=[   229],
> >      | 70.00th=[   255], 80.00th=[   314], 90.00th=[  2933], 95.00th=[  8291],
> >      | 99.00th=[ 14746], 99.50th=[ 18744], 99.90th=[ 89654], 99.95th=[ 96994],
> >      | 99.99th=[101188]
> >    bw (  KiB/s): min=  272, max=21672, per=100.00%, avg=2840.09,
> > stdev=5749.02, samples=120
> >    iops        : min=   68, max= 5418, avg=709.97, stdev=1437.26, samples=120
> >   lat (usec)   : 100=3.89%, 250=64.70%, 500=13.42%, 750=0.06%, 1000=0.14%
> >   lat (msec)   : 2=4.17%, 4=4.37%, 10=7.02%, 20=1.80%, 50=0.10%
> >   lat (msec)   : 100=0.31%, 250=0.02%
> >   cpu          : usr=0.91%, sys=4.91%, ctx=45330, majf=0, minf=28
> >   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      issued rwts: total=0,42611,0,0 short=0,0,0,0 dropped=0,0,0,0
> >      latency   : target=0, window=0, percentile=100.00%, depth=1
> >
> > Run status group 0 (all jobs):
> >   WRITE: bw=2841KiB/s (2909kB/s), 2841KiB/s-2841KiB/s
> > (2909kB/s-2909kB/s), io=166MiB (175MB), run=60001-60001msec
> >
> > Disk stats (read/write):
> >     dm-6: ios=0/42532, merge=0/0, ticks=0/58924, in_queue=58924,
> > util=51.03%, aggrios=0/42680, aggrmerge=0/0, aggrticks=0/60832,
> > aggrin_queue=60832, aggrutil=51.25%
> >     bcache0: ios=0/42680, merge=0/0, ticks=0/60832, in_queue=60832,
> > util=51.25%, aggrios=25/21934, aggrmerge=0/4, aggrticks=744/27768,
> > aggrin_queue=21904, aggrutil=33.72%
> >   sdh: ios=50/40244, merge=0/9, ticks=1488/55537, in_queue=43808, util=33.72%
> >     md0: ios=0/3624, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
> > aggrios=0/801, aggrmerge=0/2, aggrticks=0/5289, aggrin_queue=3676,
> > aggrutil=9.98%
> >   sdn: ios=0/810, merge=0/4, ticks=0/5367, in_queue=3820, util=9.63%
> >   sdm: ios=0/804, merge=0/3, ticks=0/5332, in_queue=3672, util=9.75%
> >   sdl: ios=0/771, merge=0/0, ticks=0/5041, in_queue=3484, util=9.18%
> >   sdk: ios=0/771, merge=0/0, ticks=0/5097, in_queue=3532, util=9.20%
> >   sdj: ios=0/796, merge=0/1, ticks=0/5464, in_queue=3792, util=9.60%
> >   sdi: ios=0/810, merge=0/4, ticks=0/5184, in_queue=3616, util=9.68%
> >   sdg: ios=0/826, merge=0/5, ticks=0/5396, in_queue=3716, util=9.98%
> >   sdf: ios=0/804, merge=0/3, ticks=0/5259, in_queue=3632, util=9.68%
> >   sde: ios=0/796, merge=0/1, ticks=0/5195, in_queue=3600, util=9.60%
> >   sda: ios=0/826, merge=0/5, ticks=0/5555, in_queue=3896, util=9.95%
> >
> >
> > Discard was internally disabled. When this last came to a head, I'd
> > detached, unregistered, blkdiscarded and re-created the caching
> > device. I figured this time I'd record the difference:
> >
> >
> > randwrite: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B,
> > (T) 4096B-4096B, ioengine=psync, iodepth=1
> > fio-3.16
> > Starting 1 process
> > Jobs: 1 (f=1): [w(1)][100.0%][w=37.0MiB/s][w=9727 IOPS][eta 00m:00s]
> > randwrite: (groupid=0, jobs=1): err= 0: pid=964090: Mon Feb 22 00:18:58 2021
> >   write: IOPS=12.0k, BW=46.0MiB/s (49.2MB/s)(1024MiB/21810msec); 0 zone resets
> >     clat (usec): min=53, max=7696, avg=80.65, stdev=106.39
> >      lat (usec): min=53, max=7696, avg=80.93, stdev=106.41
> >     clat percentiles (usec):
> >      |  1.00th=[   56],  5.00th=[   56], 10.00th=[   57], 20.00th=[   57],
> >      | 30.00th=[   57], 40.00th=[   58], 50.00th=[   60], 60.00th=[   61],
> >      | 70.00th=[   68], 80.00th=[   77], 90.00th=[  118], 95.00th=[  178],
> >      | 99.00th=[  330], 99.50th=[  570], 99.90th=[ 1156], 99.95th=[ 1385],
> >      | 99.99th=[ 5932]
> >    bw (  KiB/s): min=21528, max=53232, per=100.00%, avg=48162.42,
> > stdev=5760.66, samples=43
> >    iops        : min= 5382, max=13308, avg=12040.56, stdev=1440.15, samples=43
> >   lat (usec)   : 100=87.07%, 250=10.97%, 500=1.31%, 750=0.33%, 1000=0.14%
> >   lat (msec)   : 2=0.16%, 4=0.01%, 10=0.01%
> >   cpu          : usr=5.64%, sys=28.81%, ctx=262153, majf=0, minf=28
> >   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      issued rwts: total=0,262144,0,0 short=0,0,0,0 dropped=0,0,0,0
> >      latency   : target=0, window=0, percentile=100.00%, depth=1
> >
> > Run status group 0 (all jobs):
> >   WRITE: bw=46.0MiB/s (49.2MB/s), 46.0MiB/s-46.0MiB/s
> > (49.2MB/s-49.2MB/s), io=1024MiB (1074MB), run=21810-21810msec
> >
> > Disk stats (read/write):
> >     dm-6: ios=0/260278, merge=0/0, ticks=0/16632, in_queue=16632,
> > util=99.17%, aggrios=0/262165, aggrmerge=0/0, aggrticks=0/16316,
> > aggrin_queue=16316, aggrutil=99.10%
> >     bcache0: ios=0/262165, merge=0/0, ticks=0/16316, in_queue=16316,
> > util=99.10%, aggrios=0/132040, aggrmerge=0/0, aggrticks=0/8358,
> > aggrin_queue=10, aggrutil=99.54%
> >   sdh: ios=0/264068, merge=0/1, ticks=0/16716, in_queue=20, util=99.54%
> >     md0: ios=0/12, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
> > aggrios=0/3, aggrmerge=0/0, aggrticks=0/49, aggrin_queue=44,
> > aggrutil=0.09%
> >   sdn: ios=0/3, merge=0/0, ticks=0/24, in_queue=16, util=0.09%
> >   sdm: ios=0/3, merge=0/0, ticks=0/37, in_queue=32, util=0.09%
> >   sdl: ios=0/3, merge=0/0, ticks=0/28, in_queue=20, util=0.09%
> >   sdk: ios=0/3, merge=0/0, ticks=0/37, in_queue=32, util=0.09%
> >   sdj: ios=0/3, merge=0/0, ticks=0/41, in_queue=32, util=0.09%
> >   sdi: ios=0/3, merge=0/0, ticks=0/33, in_queue=28, util=0.09%
> >   sdg: ios=0/3, merge=0/0, ticks=0/39, in_queue=32, util=0.09%
> >   sdf: ios=0/3, merge=0/0, ticks=0/206, in_queue=204, util=0.09%
> >   sde: ios=0/3, merge=0/0, ticks=0/18, in_queue=16, util=0.07%
> >   sda: ios=0/3, merge=0/0, ticks=0/36, in_queue=28, util=0.09%
> >
> >
> > I'm did one last, ten-times larger/longer `fio` with 1 in
> > /sys/fs/bcache/<CSET-UID>/cache0/discard to see how far performance
> > decreases with discard enabled:
> >
> >
> > randwrite: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B,
> > (T) 4096B-4096B, ioengine=psync, iodepth=1
> > fio-3.16
> > Starting 1 process
> > randwrite: Laying out IO file (1 file / 10240MiB)
> > Jobs: 1 (f=1): [w(1)][100.0%][w=36.5MiB/s][w=9348 IOPS][eta 00m:00s]
> > randwrite: (groupid=0, jobs=1): err= 0: pid=965082: Mon Feb 22 00:42:15 2021
> >   write: IOPS=4598, BW=17.0MiB/s (18.8MB/s)(10.0GiB/570024msec); 0 zone resets
> >     clat (usec): min=62, max=3572.6k, avg=214.15, stdev=3139.18
> >      lat (usec): min=62, max=3572.6k, avg=214.51, stdev=3139.18
> >     clat percentiles (usec):
> >      |  1.00th=[   73],  5.00th=[   74], 10.00th=[   75], 20.00th=[   77],
> >      | 30.00th=[   79], 40.00th=[   82], 50.00th=[   88], 60.00th=[  109],
> >      | 70.00th=[  133], 80.00th=[  178], 90.00th=[  253], 95.00th=[  322],
> >      | 99.00th=[ 2868], 99.50th=[ 3294], 99.90th=[ 5800], 99.95th=[ 7177],
> >      | 99.99th=[16581]
> >    bw (  KiB/s): min=    8, max=40416, per=100.00%, avg=18686.70,
> > stdev=6454.00, samples=1122
> >    iops        : min=    2, max=10104, avg=4671.65, stdev=1613.50, samples=1122
> >   lat (usec)   : 100=56.23%, 250=33.37%, 500=6.13%, 750=0.25%, 1000=0.23%
> >   lat (msec)   : 2=1.86%, 4=1.56%, 10=0.34%, 20=0.02%, 50=0.01%
> >   lat (msec)   : 100=0.01%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
> >   lat (msec)   : 2000=0.01%, >=2000=0.01%
> >   cpu          : usr=2.98%, sys=24.09%, ctx=2627574, majf=0, minf=290
> >   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      issued rwts: total=0,2621440,0,0 short=0,0,0,0 dropped=0,0,0,0
> >      latency   : target=0, window=0, percentile=100.00%, depth=1
> >
> > Run status group 0 (all jobs):
> >   WRITE: bw=17.0MiB/s (18.8MB/s), 17.0MiB/s-17.0MiB/s
> > (18.8MB/s-18.8MB/s), io=10.0GiB (10.7GB), run=570024-570024msec
> >
> > Disk stats (read/write):
> >     dm-6: ios=391/3106283, merge=0/0, ticks=736/4853852,
> > in_queue=4854588, util=95.23%, aggrios=391/3283448, aggrmerge=0/0,
> > aggrticks=736/6225524, aggrin_queue=6226260, aggrutil=95.26%
> >     bcache0: ios=391/3283448, merge=0/0, ticks=736/6225524,
> > in_queue=6226260, util=95.26%, aggrios=757/1636344, aggrmerge=0/66269,
> > aggrticks=1091/448125, aggrin_queue=161104, aggrutil=96.70%
> >   sdh: ios=1115/2834033, merge=0/132539, ticks=2182/896251,
> > in_queue=322208, util=96.70%
> >     md0: ios=400/438656, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
> > aggrios=40/7874, aggrmerge=0/11639, aggrticks=72/58025,
> > aggrin_queue=42586, aggrutil=7.89%
> >   sdn: ios=99/7785, merge=0/11272, ticks=150/53355, in_queue=37896, util=7.67%
> >   sdm: ios=0/7980, merge=0/12045, ticks=0/64933, in_queue=49832, util=7.70%
> >   sdl: ios=0/7837, merge=0/11695, ticks=0/57164, in_queue=41792, util=7.71%
> >   sdk: ios=121/7828, merge=0/11704, ticks=175/58327, in_queue=42896, util=7.74%
> >   sdj: ios=43/7859, merge=0/11688, ticks=130/60166, in_queue=44732, util=7.69%
> >   sdi: ios=2/7790, merge=0/11267, ticks=30/55933, in_queue=40184, util=7.61%
> >   sdg: ios=0/7913, merge=0/11496, ticks=0/54869, in_queue=39644, util=7.78%
> >   sdf: ios=74/7975, merge=0/12050, ticks=103/59438, in_queue=44000, util=7.89%
> >   sde: ios=0/7871, merge=0/11676, ticks=0/56695, in_queue=40908, util=7.68%
> >   sda: ios=61/7906, merge=0/11503, ticks=133/59371, in_queue=43980, util=7.72%
> >
> >
> > So, a performance drop down to about 17MiB/s from the completely
> > fresh, discarded drive. I will have to wait and see if it drops any
> > further over time.
> >
> > I'm aware of the main reason for not automatically enabling discard --
> > it's unqueued with earlier SATA revisions -- but are there any other
> > disadvantages to it? I can see why never discarding data would be
> > problematic for most consumer SSDs, but I'm not aware (and would like
> > to be) if there have been any reports of data getting eaten.
> >
> > Thank you for bcache. Perhaps the silver lining here is that I could
> > wrangle with this issue without too much documentation or first
> > needing to poke the mailing list; I just wish some of these things
> > were more obvious.
> >
>
> Bcache does gc when it has to, that means when the cache device is
> highly occupied, the garbage collected bucket will be allocated and used
> very soon. Therefore the discard hint to SSD controller might not help
> too much.
>
> In my testing I don't observe obvious performance advantage with discard
> enabled in heavy I/O load, for me the performance depends on how much
> internal space is reserved for the SSD.
>
> Thanks.
>
> Coly Li
>
