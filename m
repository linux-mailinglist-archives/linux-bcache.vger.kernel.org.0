Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F57E4052
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Oct 2019 01:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfJXXWw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Oct 2019 19:22:52 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:36620 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbfJXXWw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Oct 2019 19:22:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 7D5C8A067D;
        Thu, 24 Oct 2019 23:22:51 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id sxoybavYckcd; Thu, 24 Oct 2019 23:22:50 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 2199CA01F9;
        Thu, 24 Oct 2019 23:22:50 +0000 (UTC)
Date:   Thu, 24 Oct 2019 23:22:49 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Larkin Lowrey <llowrey@nuclearwinter.com>
cc:     linux-bcache@vger.kernel.org
Subject: Re: bcache writeback infinite loop?
In-Reply-To: <4d6fe8a0-ecae-738b-165b-ee66683a2df6@nuclearwinter.com>
Message-ID: <alpine.LRH.2.11.1910242322110.25870@mx.ewheeler.net>
References: <4d6fe8a0-ecae-738b-165b-ee66683a2df6@nuclearwinter.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1690155773-1040007700-1571959370=:25870"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1690155773-1040007700-1571959370=:25870
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 23 Oct 2019, Larkin Lowrey wrote:
> I have a backing device that is constantly writing due to bcache_writebac. It
> has been at 14.3.MB dirty all day and has not changed. There's nothing else
> writing to it.
> 
> This started after I "upgraded" from Fedora 29 to 30 and consequently from
> kernel 5.2.18 to 5.3.6.
> 
> You can see from the info below that the writeback process is chewing up  A
> LOT of CPU and writing constantly at ~7MB/s. It sure looks like it's in an
> infinite loop and writing the same data over and over. At least I hope that's
> the case and it's not just filling the array with garbage.
> 
> This configuration has been stable for many years and across many Fedora
> upgrades. The host has ECC memory so RAM corruption should not be a concern. I
> have not had any recent controller or drive failures.
> 
>  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
>  5915 root      20   0       0      0      0 R  94.1   0.0 891:45.42
>  bcache_writebac
> 
> 
> Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm
> %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> md3              0.02 1478.77      0.00      6.90     0.00     0.00   0.00
> 0.00    0.00    0.00   0.00     7.72     4.78   0.00   0.00
> md3              0.00 1600.00      0.00      7.48     0.00     0.00   0.00
> 0.00    0.00    0.00   0.00     0.00     4.79   0.00   0.00
> md3              0.00 1300.00      0.00      6.07     0.00     0.00   0.00
> 0.00    0.00    0.00   0.00     0.00     4.78   0.00   0.00
> md3              0.00 1500.00      0.00      7.00     0.00     0.00   0.00
> 0.00    0.00    0.00   0.00     0.00     4.78   0.00   0.00
> 
> --- bcache ---
> UUID                        dc2877bc-d1b3-43fa-9f15-cad018e73bf6
> Block Size                  512 B
> Bucket Size                 512.00 KiB
> Congested?                  False
> Read Congestion             2.0ms
> Write Congestion            20.0ms
> Total Cache Size            128 GiB
> Total Cache Used            128 GiB     (100%)
> Total Cache Unused          0 B (0%)
> Evictable Cache             127 GiB     (99%)
> Replacement Policy          [lru] fifo random
> Cache Mode                  writethrough [writeback] writearound none
> Total Hits                  49872       (97%)
> Total Misses                1291
> Total Bypass Hits           659 (77%)
> Total Bypass Misses         189
> Total Bypassed              5.8 MiB
> --- Cache Device ---
>   Device File               /dev/dm-3 (253:3)
>   Size                      128 GiB
>   Block Size                512 B
>   Bucket Size               512.00 KiB
>   Replacement Policy        [lru] fifo random
>   Discard?                  False
>   I/O Errors                0
>   Metadata Written          5.0 MiB
>   Data Written              86.1 MiB
>   Buckets                   262144
>   Cache Used                128 GiB     (100%)
>   Cache Unused              0 B (0%)
> --- Backing Device ---
>   Device File               /dev/md3 (9:3)
>   bcache Device File        /dev/bcache0 (252:0)
>   Size                      73 TiB
>   Cache Mode                writethrough [writeback] writearound none
>   Readahead                 0.0k
>   Sequential Cutoff         4.0 MiB
>   Merge sequential?         False
>   State                     dirty
>   Writeback?                True
>   Dirty Data                14.3 MiB
>   Total Hits                49872       (97%)
>   Total Misses              1291
>   Total Bypass Hits         659 (77%)
>   Total Bypass Misses       189
>   Total Bypassed            5.8 MiB
> 
> I have not tried reverting back to an earlier kernel. I'm concerned about
> possible corruption. Is that safe? Any other suggestions as to how to debug
> and/or resolve this issue?

I don't there have been any on-disk format changes, reverting should be 
safe.

Coly?  Can you confirm?


--
Eric Wheeler



> 
> Thank you,
> 
> --Larkin
> 
> 
---1690155773-1040007700-1571959370=:25870--
