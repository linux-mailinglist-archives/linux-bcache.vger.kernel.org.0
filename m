Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FBE24D1DA
	for <lists+linux-bcache@lfdr.de>; Fri, 21 Aug 2020 11:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgHUJ6N (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 Aug 2020 05:58:13 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:60015 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbgHUJ6N (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 Aug 2020 05:58:13 -0400
X-Originating-IP: 82.67.131.7
Received: from [10.137.0.38] (unknown [82.67.131.7])
        (Authenticated sender: swami@petaramesh.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 40532240003;
        Fri, 21 Aug 2020 09:58:10 +0000 (UTC)
To:     linux-bcache@vger.kernel.org, BTRFS <linux-btrfs@vger.kernel.org>
Cc:     kent.overstreet@gmail.com, swami@petaramesh.org
From:   =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>
Subject: Complete disparition of BTRFS FS on bcache, kernel 5.8
Message-ID: <98e963a4-dbd0-7d7b-e8e5-cd846cd6c418@petaramesh.org>
Date:   Fri, 21 Aug 2020 11:58:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

I have a Manjaro system on which the disks setup is as follows :

sda : mechanical HD

- sda1 -> LUKS encryption -> bcache backing dev bcache0 -> BTRFS FS -> /home

sdb : SSD

- sdb1 -> System EFI partition

- sdb2 -> LUKS encryption -> BTRFS FS -> / (system root FS)

- sdb3 -> LUKS encryption -> bcache cache dev bcache0 (for /home)

- sdb4 -> LUKS encryption -> SWAP

bcache working in writeback mode.

This setup had worked perfectly flawlessly for more than a year with 
different kernel versions.

Then I upgraded to Manjaro kernel 5.8

I was immediately under the impression that the overall disks access 
performance had much worsened.

Then, after I had worked on a couple VMs hosted on the bcache'd FS, I 
tried to power the system down normally from the GUI menu.

At that time there was high disk activity going on and systemd waited 
for more than 1'30" trying to unmount the FSes, to no avail. Looks like 
everything didn't make it to disk before it eventually timed out.

Afterwards systemd killed the processes and powered down the system.

At next powerup, the bcache would activate as usual, but the BTRFS 
filesystem on it was completely *GONE*. The “file” utility would 
identify the device as “data” (not an FS), mount would complain that 
this wasn't any recognizable FS anymore, and “btrfs-find-root” wouldn't 
find anything.

AFAIK the FS is completely gone.

I've been using BTRFS over bcache over LUKS (on 2 machines) for years, 
and it was usually very stable until today.

Both the HD and SSD looks healthy and their SMART do not record any 
error, remapped sectors, or other issue.

So this was just to let you know... There might be some new kernel issue 
in bcache or BTRFS or their relation to one another.

Best regards.

ॐ

-- 
Swâmi Petaramesh <swami@petaramesh.org> PGP 9076E32E

