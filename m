Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055001AD8A
	for <lists+linux-bcache@lfdr.de>; Sun, 12 May 2019 19:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfELRle (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 May 2019 13:41:34 -0400
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:35736 "EHLO
        smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfELRle (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 May 2019 13:41:34 -0400
Received: from pierre.juhen (89-156-43-137.rev.numericable.fr [89.156.43.137])
        by smtp6.tech.numericable.fr (Postfix) with ESMTPS id A1956180100;
        Sun, 12 May 2019 19:41:30 +0200 (CEST)
Subject: Re: Critical bug on bcache kernel module in Fedora 30
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     kent.overstreet@gmail.com, Rolf Fokkens <rolf@rolffokkens.nl>
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
 <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
From:   Pierre JUHEN <pierre.juhen@orange.fr>
Message-ID: <c9a78d32-5752-6106-9a13-6afd9d4d75b3@orange.fr>
Date:   Sun, 12 May 2019 19:41:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr-FR
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrledvgdduudehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfdpqfgfvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomheprfhivghrrhgvucflfgfjgffpuceophhivghrrhgvrdhjuhhhvghnsehorhgrnhhgvgdrfhhrqeenucffohhmrghinheprhgvughhrghtrdgtohhmnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

the bug is present in 5.0.11, 5.0.13 et 5.0.14 (rawhide).

Please see :

https://bugzilla.redhat.com/show_bug.cgi?id=1708315

I guess it will be a tough one, since it's seems clearly linked to the 
gcc version, since the same code works under Fedora 29 (gcc 8), and 
fails under Fedora 30 (gcc 9).

Regards,

Pierre

Le 12/05/2019 à 19:11, Coly Li a écrit :
> On 2019/5/12 1:30 上午, Pierre JUHEN wrote:
>> Hi,
>>
>> I use bcache extensively on 3 PC, and I lost data on 2 of them after an
>> attempt to migrate to Fedora 30.
>>
>> My configuration is almost the same on the 3 PCs :
>>
>> /boot/efi and /boot are native on the SSD, and there is a bache frontend.
>>
>> bcache backend is on a HDD or on a raid1 array.
>>
>> bcache device is the physical volume of an LVM volume group.
>>
>> Here is how to reproduce the problem :
>>
>> 1/ Create the storage configuration as explained above.
>>
>> 2/ Install Fedora 29 on a logical volume (ext4) and a swap logical volume.
>>
>> 3/ Update the installation (dnf update --refresh)
>>
>> 4/ Migrate to Fedora 30 in download mode (dnf system-upgrade
>> --releasever=30 --allowerasing donwnload, then dnf system-upgrade reboot)
>>
>> 5/ try to prevent automatic reboot in Fedora 30 (for example in
>> commenting out /boot/efi in /etc/fstab)
>>
>> 6/ reboot using Fedora 29 kernel and initramfs -> Everything is fine
>>
>> 7/ reboot using Fedora 30 kernel and initramfs -> Everything is
>> corrupted, even unmounted volumes of the volume group
>>
>> I did the test case twice, the second time in downgrading bcache-tools
>> to Fedora 29 -> same issue
>>
>> This means that's the problem is located in the bcache kernel module ;
>> but since I guess it's the same code, the problem is probably linked to
>> the building environment (gcc version ?)
>>
>> I reported the bug : https://bugzilla.redhat.com/show_bug.cgi?id=1707822
>>
>> But I thought it was not a kernel problem.
> On my development machine the GCC is still v7.3.1, for now I don't know
> how to upgrade to GCC 9.1 yet.
>
> >From the dmesg.lis file, it seems fc30 uses 5.0.11-300, so what is the
> kernel version of fc29 ?
>
> (And from dmesg.lis I don't see anything suspicious on bcache message,
> no clue yet).
>
> Coly Li


