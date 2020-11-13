Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB1F2B2116
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Nov 2020 17:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgKMQy7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 13 Nov 2020 11:54:59 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:56198
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgKMQy7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Nov 2020 11:54:59 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <glbd-linux-bcache@m.gmane-mx.org>)
        id 1kdcLh-00094s-Ob
        for linux-bcache@vger.kernel.org; Fri, 13 Nov 2020 17:54:57 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-bcache@vger.kernel.org
From:   Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: bcache error -> btrfs unmountable
Date:   Fri, 13 Nov 2020 06:54:50 -1000
Message-ID: <romdor$11i3$1@ciao.gmane.io>
References: <rokg8t$u8n$1@ciao.gmane.io>
 <1854634128.20201113145913@pvgoran.name> <romag0$2ci$1@ciao.gmane.io>
 <1726375278.20201113231911@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <1726375278.20201113231911@pvgoran.name>
Content-Language: fr
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Le 13/11/2020 à 06:19, Pavel Goran a écrit :
> First, you may want to check if there is any dirty data in the cache, by
> executing:
> cat /sys/block/bcache0/bcache/state
> cat /sys/block/bcache1/bcache/state
> 
> If these return "clean", then you should be good to detach the cache.

I get "no cache", not sure why:
[jdg@tiare ~]$ cat /sys/block/bcache{0,1}/bcache/state
no cache
no cache

Here are the kernel logs concerning bcache:
[jdg@tiare ~]$ dmesg | grep bcache
[    9.217610] bcache: bch_journal_replay() journal replay done, 0 keys 
in 1 entries, seq 254637130
[    9.219671] bcache: register_cache() registered cache device nvme0n1p4
[    9.223512] bcache: register_bdev() registered backing device sdc
[    9.226015] bcache: register_bdev() registered backing device sdb
[    9.312796] BTRFS: device fsid c5b8386b-b81d-4473-9340-7b8a74fc3a3c 
devid 2 transid 29647859 /dev/bcache1 scanned by systemd-udevd (314)
[    9.314219] BTRFS: device fsid c5b8386b-b81d-4473-9340-7b8a74fc3a3c 
devid 1 transid 29647859 /dev/bcache0 scanned by systemd-udevd (290)

That was after rebooting, and no trying to mount the broken Btrfs RAID1.

So, should I detach the cache?


Thanks for your assistance Pavel,
Best regards,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527

