Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBB93251C6
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Feb 2021 15:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhBYOyu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 25 Feb 2021 09:54:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:54570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhBYOys (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Feb 2021 09:54:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D14D4AF6F;
        Thu, 25 Feb 2021 14:54:06 +0000 (UTC)
Subject: Re: bcacheX is missing after removing a backend and adding it again
To:     wubenqing@ruijie.com.cn
References: <82A10A71B70FF2449A8AD233969A45A101CCD9757E@FZEX6.ruijie.com.cn>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <4e22ce8b-6dfb-0b2a-2082-27f7ae97fee0@suse.de>
Date:   Thu, 25 Feb 2021 22:54:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <82A10A71B70FF2449A8AD233969A45A101CCD9757E@FZEX6.ruijie.com.cn>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/25/21 11:12 AM, wubenqing@ruijie.com.cn wrote:
> Hi guys,
> I am testing a scenario where multiple backend attach one cache. When I removed one of the backend and added it back, I found that bcacheX was missing. I configured cache_mode to writeback.
> 
> Before:
> /dev/sdd
> ©¸©¤bcache0
> /dev/sdc
> ©¸©¤bcache1
> 
> After:
> /dev/sdg
> /dev/sdc
> ©¸©¤bcache1
> 
> 
> The name of the block device /dev/sdd is changed to /dev/sdg, and bcache0 is missing when excuting lsblk. I found that /sys/bkock/bache0/bcache link to the old device which does not exist.
> # ll /sys/block/bcache0/bcache
> lrwxrwxrwx 1 root root 0 Feb 23 17:36 /sys/block/bcache0/bcache -> ../../../pci0000:80/0000:80:01.0/0000:82:00.0/host1/port-1:3/end_device-1:3/target1:0:3/1:0:3:0/block/sdd/bcache
> 
> 
> The super block of /dev/sdg shows that there is still dirty data stored on the cache device.
> # bcache-super-show /dev/sdg
> sb.magicok
> sb.first_sector8 [match]
> sb.csum 80AE8CFCCC740075 [match]
> sb.version1 [backing device]
> 
> dev.label(empty)
> dev.uuid22cb8e47-67d8-4f54-97b4-a8c86d986aac
> dev.sectors_per_block 1
> dev.sectors_per_bucket 1024
> dev.data.first_sector 16
> dev.data.cache_mode 1 [writeback]
> dev.data.cache_state 2 [dirty]
> 
> 
> When I checked the kernel log, I found that:
> ...
> [81701.447130] bcache: bch_count_backing_io_errors() sdd: IO error on backing device, unrecoverable
> [81701.487543] bcache: bch_count_backing_io_errors() sdd: IO error on backing device, unrecoverable
> [81701.985562] bcache: bch_count_backing_io_errors() sdd: IO error on backing device, unrecoverable
> [81702.590435] bcache: backing_request_endio() Can't flush sdd: returned bi_status 10
> 
> ...
> [81849.890604] bcache: register_bdev() registered backing device sdg
> [81849.890608] bcache: bch_cached_dev_attach() Tried to attach sdg but duplicate UUID already attached
> 
> ...
> 
> "IO error on backing device, unrecoverable" appeared 63 times in total. It may be that the io_disable of the backend device is set to true due to io_error_limit is 64, but I did not find the log "too many IO errors on backing device" which bch_cached_dev_error will print.
> 
> bch_writeback_thread is very high cpu usage and the SSD(cache) shows very high read traffic but no write traffic.
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> nvme0n1           0.00     0.00 33836.00    0.00  1619.07     0.00    98.00    76.55    2.68    2.68    0.00   0.03 100.00
> 
> 
> The important problem is that there is no way to recover bcache0, even if I try to re-execute "echo /dev/sdg > /sys/fs/bcache/register". The kernel log shows that:
> [91091.621773] bcache: register_bcache() error : device already registered
> 
> I suspect that /dev/sdd still remains in c->cached_devs, and it is set to io_disable, and /dev/sdd does not exist anymore, so writeback cannot flush dirty data. Since the name of the block device has become /dev/sdg, /dev/sdg cannot be reattached successfully.
> Does bcache support backend for hot-swapping scenarios? If not, what command should I use to manually restore bcache0.

Which kernel version do you use ?

A reboot might solve the problem. But I feel it could be improved to
avoid the extra reboot.

Let me add it into my todo list, if no one else posts patch before I
work on it...

Thanks for the suggestion.

Coly Li
