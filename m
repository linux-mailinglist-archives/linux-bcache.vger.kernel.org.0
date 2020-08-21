Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7894024D5E9
	for <lists+linux-bcache@lfdr.de>; Fri, 21 Aug 2020 15:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgHUNPy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 Aug 2020 09:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgHUNPv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 Aug 2020 09:15:51 -0400
X-Greylist: delayed 142 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Aug 2020 06:15:50 PDT
Received: from smtp.mfedv.net (smtp.mfedv.net [IPv6:2a04:6c0:2::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2E5C061385;
        Fri, 21 Aug 2020 06:15:49 -0700 (PDT)
Received: from suse92host.mfedv.net (suse92host.mfedv.net [IPv6:2a04:6c0:2:3:0:0:0:ffff])
        by smtp.mfedv.net (8.15.2/8.15.2/Debian-10) with ESMTP id 07LDDCQq003015;
        Fri, 21 Aug 2020 13:13:13 GMT
Received: from xoff (klappe2.mfedv.net [192.168.71.72])
        by suse92host.mfedv.net (Postfix) with ESMTP id 010EAC89BA;
        Fri, 21 Aug 2020 15:13:11 +0200 (CEST)
        (envelope-from bcache@mfedv.net)
Date:   Fri, 21 Aug 2020 15:13:11 +0200
From:   Matthias Ferdinand <bcache@mfedv.net>
To:     =?utf-8?B?U3fDom1p?= Petaramesh <swami@petaramesh.org>
Cc:     linux-bcache@vger.kernel.org, BTRFS <linux-btrfs@vger.kernel.org>,
        kent.overstreet@gmail.com
Subject: Re: Complete disparition of BTRFS FS on bcache, kernel 5.8
Message-ID: <20200821131311.GG8012@xoff>
References: <98e963a4-dbd0-7d7b-e8e5-cd846cd6c418@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98e963a4-dbd0-7d7b-e8e5-cd846cd6c418@petaramesh.org>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Sorry I probably can't bring you back the fs, I just have a possibly
relevant datapoint to share:

with recent Ubuntu 20.04 and a rather convoluted storage stack (i.e. LVM
volumes consumed not by fs directly but insted by e.g. luks and/or
bcache), on shutdown systemd service blk-availability.service would lead
to 1m30s of frantic disk activity without ever finishing.

I did not have much time to investigate (and I don't right now), but I
remember coming to the conclusion that blk-availability or the invoked
scripts do not honor the case where an LVM volume is consumed by
anything else than a plain filesystem, and so they loop endlessly until
finally being killed by systemd.

I haven't lost data AFAICT, but it's a nuisance, and I disable
blk-availability whenever I see it, and I don't even fully understand
what it intends to achieve.

It is possible that in your case the same type of frantic disk activity
kept some vital fs information from actually reaching the disk.

Regards
Matthias

On Fri, Aug 21, 2020 at 11:58:08AM +0200, Swâmi Petaramesh wrote:
> Hello,
> 
> I have a Manjaro system on which the disks setup is as follows :
> 
> sda : mechanical HD
> 
> - sda1 -> LUKS encryption -> bcache backing dev bcache0 -> BTRFS FS -> /home
> 
> sdb : SSD
> 
> - sdb1 -> System EFI partition
> 
> - sdb2 -> LUKS encryption -> BTRFS FS -> / (system root FS)
> 
> - sdb3 -> LUKS encryption -> bcache cache dev bcache0 (for /home)
> 
> - sdb4 -> LUKS encryption -> SWAP
> 
> bcache working in writeback mode.
> 
> This setup had worked perfectly flawlessly for more than a year with
> different kernel versions.
> 
> Then I upgraded to Manjaro kernel 5.8
> 
> I was immediately under the impression that the overall disks access
> performance had much worsened.
> 
> Then, after I had worked on a couple VMs hosted on the bcache'd FS, I tried
> to power the system down normally from the GUI menu.
> 
> At that time there was high disk activity going on and systemd waited for
> more than 1'30" trying to unmount the FSes, to no avail. Looks like
> everything didn't make it to disk before it eventually timed out.
> 
> Afterwards systemd killed the processes and powered down the system.
> 
> At next powerup, the bcache would activate as usual, but the BTRFS
> filesystem on it was completely *GONE*. The “file” utility would identify
> the device as “data” (not an FS), mount would complain that this wasn't any
> recognizable FS anymore, and “btrfs-find-root” wouldn't find anything.
> 
> AFAIK the FS is completely gone.
> 
> I've been using BTRFS over bcache over LUKS (on 2 machines) for years, and
> it was usually very stable until today.
> 
> Both the HD and SSD looks healthy and their SMART do not record any error,
> remapped sectors, or other issue.
> 
> So this was just to let you know... There might be some new kernel issue in
> bcache or BTRFS or their relation to one another.
> 
> Best regards.
> 
> ॐ
> 
> -- 
> Swâmi Petaramesh <swami@petaramesh.org> PGP 9076E32E
