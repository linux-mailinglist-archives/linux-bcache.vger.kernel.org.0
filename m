Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30B31A8E4
	for <lists+linux-bcache@lfdr.de>; Sat, 11 May 2019 19:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfEKRqE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 11 May 2019 13:46:04 -0400
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:39410 "EHLO
        smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfEKRqE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 11 May 2019 13:46:04 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 May 2019 13:46:03 EDT
Received: from pierre.juhen (89-156-43-137.rev.numericable.fr [89.156.43.137])
        by smtp6.tech.numericable.fr (Postfix) with ESMTPS id ABB5F180B96;
        Sat, 11 May 2019 19:30:32 +0200 (CEST)
To:     linux-bcache@vger.kernel.org
Cc:     kent.overstreet@gmail.com
From:   Pierre JUHEN <pierre.juhen@orange.fr>
Subject: Critical bug on bcache kernel module in Fedora 30
Message-ID: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
Date:   Sat, 11 May 2019 19:30:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: fr-FR
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrledtgdduudduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfdpqfgfvfenuceurghilhhouhhtmecufedttdenucenucfjughrpefvhffukffffgggtgfgsehtjeertddtfeejnecuhfhrohhmpefrihgvrhhrvgculfgfjffgpfcuoehpihgvrhhrvgdrjhhuhhgvnhesohhrrghnghgvrdhfrheqnecuffhomhgrihhnpehrvgguhhgrthdrtghomhenucfrrghrrghmpehmohguvgepshhmthhpohhuthenucevlhhushhtvghrufhiiigvpedt
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

I use bcache extensively on 3 PC, and I lost data on 2 of them after an 
attempt to migrate to Fedora 30.

My configuration is almost the same on the 3 PCs :

/boot/efi and /boot are native on the SSD, and there is a bache frontend.

bcache backend is on a HDD or on a raid1 array.

bcache device is the physical volume of an LVM volume group.

Here is how to reproduce the problem :

1/ Create the storage configuration as explained above.

2/ Install Fedora 29 on a logical volume (ext4) and a swap logical volume.

3/ Update the installation (dnf update --refresh)

4/ Migrate to Fedora 30 in download mode (dnf system-upgrade 
--releasever=30 --allowerasing donwnload, then dnf system-upgrade reboot)

5/ try to prevent automatic reboot in Fedora 30 (for example in 
commenting out /boot/efi in /etc/fstab)

6/ reboot using Fedora 29 kernel and initramfs -> Everything is fine

7/ reboot using Fedora 30 kernel and initramfs -> Everything is 
corrupted, even unmounted volumes of the volume group

I did the test case twice, the second time in downgrading bcache-tools 
to Fedora 29 -> same issue

This means that's the problem is located in the bcache kernel module ; 
but since I guess it's the same code, the problem is probably linked to 
the building environment (gcc version ?)

I reported the bug : https://bugzilla.redhat.com/show_bug.cgi?id=1707822

But I thought it was not a kernel problem.


Thanks

Regards,


Pierre Juhen



