Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0A431CCB9
	for <lists+linux-bcache@lfdr.de>; Tue, 16 Feb 2021 16:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhBPPOt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 16 Feb 2021 10:14:49 -0500
Received: from ssl.fluxnetz.de ([159.69.133.186]:57966 "EHLO ssl.fluxnetz.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229942AbhBPPOs (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Feb 2021 10:14:48 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Feb 2021 10:14:48 EST
Received: from [192.168.178.42] by ssl.fluxnetz.de with esmtp (ad22bd52997fba6f1012a9a0ae50ebe4); Tue, 16 Feb 2021 16:06:38 +0100
To:     linux-bcache@vger.kernel.org
From:   Constantin Runge <c.runge@cssbook.de>
Subject: Obsoleted large bucket layout message once
Message-ID: <de528a90-6d3d-d324-ca22-73b635d5153f@cssbook.de>
Date:   Tue, 16 Feb 2021 16:06:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi everybody,

when registering and mounting my bcache devices (unortunately my root 
filesystem), the kernel informed me about `Detected obsoleted large 
bucket layout, all attached bcache device will be read-only'.

Subsequently, my root fs was, in fact, read-only. Thus, I have no logs 
for you unfortunately. As far as I remember, bcache-super-show showed 
the same bucket and block sizes as always (except that the backing 
device showed a clean cache state):

 > bcache-super-show /dev/sda6
sb.magic		ok
sb.first_sector		8 [match]
sb.csum			C5EB3BA8CA523D61 [match]
sb.version		4 [backing device]

dev.label		(empty)
dev.uuid		264d1acc-8461-4ddc-a825-f0acdeea3ede
dev.sectors_per_block	1
dev.sectors_per_bucket	1024
dev.data.first_sector	2048
dev.data.cache_mode	1 [writeback]
dev.data.cache_state	2 [dirty]

cset.uuid		755901be-a101-4581-b1d0-4d21d1619f27
 > bcache-super-show /dev/sdb3
sb.magic		ok
sb.first_sector		8 [match]
sb.csum			BDA92F1E72DBA095 [match]
sb.version		3 [cache device]

dev.label		(empty)
dev.uuid		25151c1a-904e-492e-b99b-6d07e13b047a
dev.sectors_per_block	1
dev.sectors_per_bucket	1024
dev.cache.first_sector	1024
dev.cache.cache_sectors	907564032
dev.cache.total_sectors	907565056
dev.cache.ordered	yes
dev.cache.discard	no
dev.cache.pos		0
dev.cache.replacement	0 [lru]

cset.uuid		755901be-a101-4581-b1d0-4d21d1619f27


For debugging purposes I tried to mount and chroot into my backing 
device directly, using a loopback interface. I was not able to find an 
offset for `losetup -f -o <offset> /dev/sda6', so that `mount -o loop 
/dev/loop0 /mnt/mnt0' would not tell me that there was no filesystem.
Also, `for i in {0.2000}; do dd if=/dev/sda6 skip=$i | file -; done' 
from [1] showed `data' for every offset.

After getting a little desperate, I booted into an older kernel 
(although I didn't update my kernel or my bcache-tools since the last 
boot) and everything worked. I then booted back into my current system 
and everything worked again.

Is this a bug with bcache or do I need to change my setup to prevent 
this from happening again? My bcache devices were created sometime 
around 2015 or 2016.

System info:
uname -a: `Linux Horus 5.10.10-gentoo #1 SMP PREEMPT Mon Feb 15 15:00:49 
CET 2021 x86_64 Intel(R) Core(TM) i7-4790K CPU @ 4.00GHz GenuineIntel 
GNU/Linux'
bcache-tools version: 1.1
The older kernel is a 5.8.11-gentoo with voluntary preempt.

Best regards and thanks,
Constantin


   [1] 
https://stackoverflow.com/questions/22820492/how-to-revert-bcache-device-to-regular-device
