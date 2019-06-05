Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5413C35D5C
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jun 2019 14:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfFEM5g (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jun 2019 08:57:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:47322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727769AbfFEM5f (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jun 2019 08:57:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 30FEDAEBD;
        Wed,  5 Jun 2019 12:57:34 +0000 (UTC)
Subject: Re: Device IO error question
To:     nina <nina_2011@126.com>
References: <2b89ab95.72b9.16b2791e9ee.Coremail.nina_2011@126.com>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <70a612e4-4fb8-3746-5141-843045157af7@suse.de>
Date:   Wed, 5 Jun 2019 20:57:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <2b89ab95.72b9.16b2791e9ee.Coremail.nina_2011@126.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/5 8:16 ÏÂÎç, nina wrote:
> Hi, Dear Mr
> 
> with linux 4.17.11, I built a bcache environment, one nvme as a cache device, and six sata as a device. It is found that if one sata io exception causes the cache to be unavailable, then the other five sata is also kicked off. The following is the dmesg log.
> sd 0:2:7:0: [sdi] tag#2 FAILED Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 0:2:7:0: [sdi] tag#29 FAILED Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 0:2:7:0: [sdi] tag#2 CDB: Read(16) 88 00 00 00 00 00 c2 82 fa b8 00 00 00 40 00 00
> sd 0:2:7:0: [sdi] tag#29 CDB: Write(16) 8a 00 00 00 00 02 36 4b dc 70 00 00 02 00 00 00
> print_req_error: I/O error, dev sdi, sector 3263363768
> print_req_error: I/O error, dev sdi, sector 9500875888
> sd 0:2:7:0: [sdi] tag#17 FAILED Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 0:2:7:0: [sdi] tag#17 CDB: Read(16) 88 00 00 00 00 01 9b 48 68 00 00 00 02 00 00 00
> print_req_error: I/O error, dev sdi, sector 6900180992
> print_req_error: I/O error, dev sdi, sector 6969256320
> sd 0:2:7:0: [sdi] tag#4 FAILED Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 0:2:7:0: [sdi] tag#1 FAILED Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 0:2:7:0: [sdi] tag#6 CDB: Write(16) 8a 00 00 00 00 02 36 4b d6 70 00 00 02 00 00 00
> print_req_error: I/O error, dev sdi, sector 7108554960
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> print_req_error: I/O error, dev sdi, sector 9500876400
> sd 0:2:7:0: [sdi] tag#4 CDB: Read(16) 88 00 00 00 00 00 01 94 3d e0 00 00 01 c0 00 00
> print_req_error: I/O error, dev sdi, sector 9500874352
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> sd 0:2:7:0: [sdi] tag#8 CDB: Read(16) 88 00 00 00 00 01 c7 a3 3f b0 00 00 02 00 00 00
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> sd 0:2:7:0: [sdi] tag#1 CDB: Read(16) 88 00 00 00 00 00 c2 82 f8 b8 00 00 02 00 00 00
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> megaraid_sas 0000:02:00.0: scanning for scsi0...
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> megaraid_sas 0000:02:00.0: 1508 (595830949s/0x0001/FATAL) - VD 07/7 is now OFFLINE
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_count_backing_io_errors() sdi: IO error on backing device, unrecoverable
> bcache: bch_cached_dev_error() stop bcache7: too many IO errors on backing device sdi
> bcache: bch_count_io_errors() nvme1n1: IO error on writing data to cache.
> bcache: bch_count_io_errors() nvme1n1: IO error on writing data to cache.
> bcache: bch_count_io_errors() nvme1n1: IO error on writing data to cache.
> bcache: bch_count_io_errors() nvme1n1: IO error on writing data to cache.
> bcache: bch_count_io_errors() nvme1n1: IO error on writing data to cache.
> bcache: bch_count_io_errors() nvme1n1: IO error on writing data to cache.
> bcache: bch_count_io_errors() nvme1n1: IO error on writing data to cache.
> bcache: bch_cache_set_error() CACHE_SET_IO_DISABLE already set
> bcache: error on b1dd28cb-10ec-4915-9b48-88deb6a7f61b:
> nvme1n1: too many IO errors writing data to cache
> , disabling caching
> bcache: conditional_stop_bcache_device() stop_when_cache_set_failed of bcache6 is "auto" and cache is dirty, stop it to avoid potential data corruption.
> bcache: conditional_stop_bcache_device() stop_when_cache_set_failed of bcache7 is "auto" and cache is dirty, stop it to avoid potential data corruption.
> bcache: conditional_stop_bcache_device() stop_when_cache_set_failed of bcache8 is "auto" and cache is dirty, stop it to avoid potential data corruption.
> bcache: conditional_stop_bcache_device() stop_when_cache_set_failed of bcache9 is "auto" and cache is dirty, stop it to avoid potential data corruption.
> bcache: conditional_stop_bcache_device() stop_when_cache_set_failed of bcache10 is "auto" and cache is dirty, stop it to avoid potential data corruption.
> bcache: conditional_stop_bcache_device() stop_when_cache_set_failed of bcache11 is "auto" and cache is dirty, stop it to avoid potential data corruption.
> bcache: cached_dev_detach_finish() Caching disabled for sdk
> bcache: cached_dev_detach_finish() Caching disabled for sdh
> bcache: cached_dev_detach_finish() Caching disabled for sdl
> bcache: cached_dev_detach_finish() Caching disabled for sdj
> bcache: cached_dev_detach_finish() Caching disabled for sdm
> sd 0:2:7:0: SCSI device is removed
> megaraid_sas 0000:02:00.0: 1512 (595831198s/0x0004/CRIT) - Enclosure PD 20(c None/p1) phy bad for slot 7
> bcache: bcache_device_free() bcache11 stopped
> bcache: bcache_device_free() bcache10 stopped
> bcache: bcache_device_free() bcache9 stopped
> bcache: bcache_device_free() bcache8 stopped
> bcache: bcache_device_free() bcache7 stopped
> bcache: bcache_device_free() bcache6 stopped
> bcache: cache_set_free() Cache set b1dd28cb-10ec-4915-9b48-88deb6a7f61b unregistered
> 
> I looked at the bcache code and found that in the bch_cached_dev_error function, the flag of cache_set is set to CACHE_SET_IO_DISABLE, but the code to clear this flag is not found, and  in the closure_bio_submit function. If the flags of cache_set  is CACHE_SET_IO_DISABLE, will trigger cache Io error.
> 
> Is the design of bcache like this, or is my use wrong?
> 
> I look forward to your reply. Thank you.

This problem is caused by commit 6147305c73e4 ("bcache: set
CACHE_SET_IO_DISABLE in bch_cached_dev_error()")

I will post a revert patch to revert this commit in 5.3 and CC
stable@vger.kernel.org

Thanks.

Coly Li


-- 

Coly Li
