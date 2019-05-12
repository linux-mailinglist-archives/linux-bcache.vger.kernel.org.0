Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C009A1AD74
	for <lists+linux-bcache@lfdr.de>; Sun, 12 May 2019 19:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfELRLm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 May 2019 13:11:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:55232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726529AbfELRLm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 May 2019 13:11:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD817ADD5;
        Sun, 12 May 2019 17:11:40 +0000 (UTC)
Subject: Re: Critical bug on bcache kernel module in Fedora 30
To:     Pierre JUHEN <pierre.juhen@orange.fr>, linux-bcache@vger.kernel.org
Cc:     kent.overstreet@gmail.com
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
Date:   Mon, 13 May 2019 01:11:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/5/12 1:30 上午, Pierre JUHEN wrote:
> Hi,
> 
> I use bcache extensively on 3 PC, and I lost data on 2 of them after an
> attempt to migrate to Fedora 30.
> 
> My configuration is almost the same on the 3 PCs :
> 
> /boot/efi and /boot are native on the SSD, and there is a bache frontend.
> 
> bcache backend is on a HDD or on a raid1 array.
> 
> bcache device is the physical volume of an LVM volume group.
> 
> Here is how to reproduce the problem :
> 
> 1/ Create the storage configuration as explained above.
> 
> 2/ Install Fedora 29 on a logical volume (ext4) and a swap logical volume.
> 
> 3/ Update the installation (dnf update --refresh)
> 
> 4/ Migrate to Fedora 30 in download mode (dnf system-upgrade
> --releasever=30 --allowerasing donwnload, then dnf system-upgrade reboot)
> 
> 5/ try to prevent automatic reboot in Fedora 30 (for example in
> commenting out /boot/efi in /etc/fstab)
> 
> 6/ reboot using Fedora 29 kernel and initramfs -> Everything is fine
> 
> 7/ reboot using Fedora 30 kernel and initramfs -> Everything is
> corrupted, even unmounted volumes of the volume group
> 
> I did the test case twice, the second time in downgrading bcache-tools
> to Fedora 29 -> same issue
> 
> This means that's the problem is located in the bcache kernel module ;
> but since I guess it's the same code, the problem is probably linked to
> the building environment (gcc version ?)
> 
> I reported the bug : https://bugzilla.redhat.com/show_bug.cgi?id=1707822
> 
> But I thought it was not a kernel problem.

On my development machine the GCC is still v7.3.1, for now I don't know
how to upgrade to GCC 9.1 yet.

From the dmesg.lis file, it seems fc30 uses 5.0.11-300, so what is the
kernel version of fc29 ?

(And from dmesg.lis I don't see anything suspicious on bcache message,
no clue yet).

Coly Li
-- 

Coly Li
