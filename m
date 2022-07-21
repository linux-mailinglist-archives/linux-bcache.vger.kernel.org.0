Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACCA57D168
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Jul 2022 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiGUQWT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 21 Jul 2022 12:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGUQWS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 21 Jul 2022 12:22:18 -0400
X-Greylist: delayed 196 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Jul 2022 09:22:16 PDT
Received: from schatzi.steelbluetech.co.uk (james.steelbluetech.co.uk [92.63.139.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834D684ED2
        for <linux-bcache@vger.kernel.org>; Thu, 21 Jul 2022 09:22:16 -0700 (PDT)
Received: from [10.0.5.25] (tv.ehuk.net [10.0.5.25])
        by schatzi.steelbluetech.co.uk (Postfix) with ESMTP id 897EFBFC1E
        for <linux-bcache@vger.kernel.org>; Thu, 21 Jul 2022 17:18:58 +0100 (BST)
DKIM-Filter: OpenDKIM Filter v2.10.3 schatzi.steelbluetech.co.uk 897EFBFC1E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ehuk.net; s=default;
        t=1658420338; bh=hTRwQsNAGRDPgxtsJDwiPSMl0QvFqb/3st0tH8O4D+A=;
        h=Date:To:Reply-To:From:Subject:From;
        b=VO/Bxe4LH9SvSIv6E8ZEr2sG5eaCio/OkyWU8iYqKj6weLLnpZ1AiKhfjOlip0P/3
         1yd0hDSLyDdW8kH+ZeGg08cPfTMIWw5uabLcXevUfstFdaewzAyKtPxOIfO31qm2ZT
         6nFCb6RHgVfj5a38iZHtiMpQ+xaOw/mqXJOwjzaI=
Message-ID: <b968c31a-aeeb-28fd-78ef-d38344d4ecc1@ehuk.net>
Date:   Thu, 21 Jul 2022 17:18:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To:     linux-bcache@vger.kernel.org
Reply-To: eddie@ehuk.net
Content-Language: en-GB
From:   Eddie Chapman <eddie@ehuk.net>
Subject: Some persistently stuck cache devices after backing device failures
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

I've been using bcache for several years and have learned how to resolve 
various problems. However now I have a situation on a live server where 
I've tried everything but looks like I might have to reboot the kernel 
to resolve it. This will be a big pain for this server so thought I'd 
check here if anyone knows something else I could try.

Let me try and describe the situation:

- system is running vanilla stable kernel 5.10.107 for 100+ days
- There's a single nvme device with 15 partitions
- Each nvme partition is a bcache cache device in writeback mode, 
attached to a backing device of course (there are various types of 
backing devices)
- Now a SATA controller has completely failed and taken out 3 spinning 
SATA disks, leading to several backing devices but not all failing.
- The nvme device is fine and still acting as cache for some remaining, 
working backing devices which have nothing to do with the failed disks.
- The bcache backing devices that failed and their corresponding caches 
were in a mixed state immediately after the disks failed, some gone, 
some not.
- I don't care about any of the failed data, I just want to clean up the 
mess and re-use the nvme partitions that had backing device failures 
with some other working spinning disks on the system.
- So, I've been able to unregister, free, wipe and re-use MOST of the 
cache devices that had failed backing devices.
- Of the cache devices I unregistered I've been able to clean up 
completely their failed backing devices (both the bcacheN device and 
failed backing device is completely gone from /sys/block).
- However, there are 3 cache devices, with failed backing devices, which 
completely refuse to either stop or unregister. I have written 1 many 
times to the "stop" and "unregister" files but nothing changes and 
nothing is logged in the kernel log.
- There has not been any crash or warning emitted by bcache in the 
kernel log, just the normal messages you would expect to see when 
backing devices fail.

For each of these 3 "stuck" cache devices:

   - The cache directory still exists in /sys/fs/bcache/
   - Inside the cache directory there is no bdev0 symlink anymore. There 
*is* the cache0 symlink pointing to the nvme partition.
   - The corresponding /sys/block/bcacheN directory does still exist.
   - There is nothing in the /sys/block/bcacheN/holders/ directory. 
Above the bcache device was LVM devices but I was able to successfully 
remove all of them with dmsetup remove. There is definitely nothing 
above still holding the bcacheN device still open.
   - The failed backing device, which is an md raid0, still exists on 
the system, but it is not possible to stop it with mdadm, it is also 
"stuck" (I've tried to normally "fail" and "remove" it as well as using 
mdadm's special "failed" and "detached" keywords). It still shows up in 
/proc/mdstat. The raid members are the SATA disks which have now 
disappeared. mdadm -D says the array is in a state "broken, FAILED" and 
it's disks are all "missing".
   - Inside the /sys/block/mdN/ directory there is NO "bcache" subdirectory
   - Inside the /sys/block/mdN/holders/ directory there is still a 
working "bcacheN" symlink to /sys/block/bcacheN
   - Inside the /sys/block/bcacheN directory there is a broken "bcache" 
symlink pointing to the now disappeared /sys/block/mdN/bcache


As I said, I don't care about any of the failed data, I only care about 
freeing the nvme cache devices. But I have 2 problems:

1. Something in the kernel is constantly reading hundreds of Mbytes/s of 
data from the 3 "stuck" nvme partitions (but not writing anything, at 
least not at any significant rate). I can see it using atop. I'm 
wondering if bcache is stuck in a loop trying to read something from 
them and that is why it will not let go of these remaining 3 nvme 
partitions. I believe this is affecting performance of the nvme device 
as a whole for the other working bcache devices using it. load average 
is quite high continually as a result.

2. I cannot re-use these 3 nvme partitions while they are "stuck", 
though this is less of a problem that 1.

I'm hoping there might be a simple way to force bcache to "let go" of 
these 3 cache devices without rebooting? I don't care if the leftover 
stuff of the md backing devices doesn't go away, it is not doing any 
harm that I can tell, just that I can successfully unregister the cache 
devices. Or at least stop bcache from constantly reading the hundreds of 
Mbyte/s, I could live with just that.

I see there is an "io_disable" file in the "internal" subdirectory. What 
does that do? Maybe it is the solution but I dare not try it as I don't 
know what it does and don't want to risk crashing the kernel.

I can provide anything else anyone might want to see but I'll stop here 
as it's already a long message.

Many thanks!
Eddie
