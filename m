Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185962F007F
	for <lists+linux-bcache@lfdr.de>; Sat,  9 Jan 2021 15:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbhAIOdC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 9 Jan 2021 09:33:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:54536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbhAIOdC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 Jan 2021 09:33:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DBF48AAF1;
        Sat,  9 Jan 2021 14:32:20 +0000 (UTC)
To:     Cedric.dewijs@eclipso.eu
References: <2d981576325bec349ea63861f65668e0@mail.eclipso.de>
From:   Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: multiple caches code is being removed, what is the recommended
 alternative?
Message-ID: <e03dd593-14cb-b4a0-d68a-bd9b4fb8bd20@suse.de>
Date:   Sat, 9 Jan 2021 22:32:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2d981576325bec349ea63861f65668e0@mail.eclipso.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/7/21 2:30 AM, Cedric.dewijs@eclipso.eu wrote:
> ­Hi All,
> 
> I recently saw a series of patches to remove multiple caches code [1] For me, having one large mirrored write cache is desirable, so I can make this structure:
> 
> +--------------------------------------------------------------------------+
> |                         btrfs raid 1 (2 copies) /mnt                     |
> +--------------+--------------+--------------+--------------+--------------+
> | /dev/bcache0 | /dev/bcache1 | /dev/bcache2 | /dev/bcache3 | /dev/bcache4 |
> +--------------+--------------+--------------+--------------+--------------+
> |                   Mirrored  Writeback Cache (SSD)                        |
> |                         /dev/sda3 and /dev/sda4                          |
> +--------------+--------------+--------------+--------------+--------------+
> | Data         | Data         | Data         | Data         | Data         |
> | /dev/sda8    | /dev/sda9    | /dev/sda10   | /dev/sda11   | /dev/sda12   |
> +--------------+--------------+--------------+--------------+--------------+
> 
> This way I don't have to worry about data loss when one of the SSD's or one of the hard drives fails, and I have maximum performance for the least amount of drives.
> 
> With the code for multiple caches removed, what is the recommended way forward?
> What is the best way to use 2 SSD's with different size and speed, while keeping enough redundancy to survive a single drive failure?
> 
> [1] https://lore.kernel.org/linux-bcache/20200822114536.23491-1-colyli@suse.de/T/#t
> 

It is removed because it is not completed, a working mirror cache in
bcache is not that simple like submitting bios to all cache device and
waiting for all of them completed. This might be one of the reason why
this feature is not production ready after 10+ years since bcache merged
into mainline kernel.

I see many production environments using md raid1 for cached data
duplication. This is the preferred method IMHO.

Coly Li
