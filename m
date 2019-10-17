Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1AFDB0FC
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Oct 2019 17:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391343AbfJQPV1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 17 Oct 2019 11:21:27 -0400
Received: from s802.sureserver.com ([195.8.222.36]:38378 "EHLO
        s802.sureserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391285AbfJQPV1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 17 Oct 2019 11:21:27 -0400
Received: (qmail 23871 invoked by uid 1003); 17 Oct 2019 15:21:24 -0000
Received: from unknown (HELO ?94.155.37.179?) (zimage@dni.li@94.155.37.179)
  by s802.sureserver.com with ESMTPA; 17 Oct 2019 15:21:24 -0000
To:     linux-bcache@vger.kernel.org
From:   Teodor Milkov <tm@del.bg>
Subject: Very slow bcache-register: 6.4TB takes 10+ minutes
Message-ID: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
Date:   Thu, 17 Oct 2019 18:21:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

I've tried using bcache with a large 6.4TB NVMe device, but found it 
takes long time to register after clean reboot -- around 10 minutes. 
That's even with idle machine reboot.

Things look like this soon after reboot:

root@node420:~# ps axuww |grep md12
root      9768 88.1  0.0   2268   744 pts/0    D+   16:20 0:25 
/lib/udev/bcache-register /dev/md12


Device            r/s     w/s     rMB/s     wMB/s rrqm/s   wrqm/s  
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1        420.00    0.00     52.50      0.00 0.00     0.00   0.00   
0.00    0.30    0.00   1.04   128.00 0.00   2.38  99.87
nvme1n1        417.67    0.00     52.21      0.00 0.00     0.00   0.00   
0.00    0.30    0.00   1.03   128.00 0.00   2.39 100.00
md12           838.00    0.00    104.75      0.00 0.00     0.00   0.00   
0.00    0.00    0.00   0.00   128.00 0.00   0.00   0.00

As you can see nvme1n1, which is Micron 9200, is reading with the humble 
52MB/s (417r/s), and that is very far bellow it's capabilities of 
3500MB/s & 840K IOPS.

At the same time it seems like the bcache-register process is saturating 
the CPU core it's running on, so maybe that's the bottleneck?

Tested with kernels 4.9 and 4.19.

1. Is this current state of affairs -- i.e. this known/expected 
behaviour with such a large cache?

2. If this isn't expected -- any ideas how to debug or fix it?

3. What is max recommended cache size?


--

Best regards,
Teodor Milkov

