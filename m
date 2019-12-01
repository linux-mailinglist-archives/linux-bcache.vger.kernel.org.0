Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDB010E210
	for <lists+linux-bcache@lfdr.de>; Sun,  1 Dec 2019 14:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfLANoL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 1 Dec 2019 08:44:11 -0500
Received: from schatzi.steelbluetech.co.uk ([92.63.139.240]:21075 "EHLO
        schatzi.steelbluetech.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726340AbfLANoL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 1 Dec 2019 08:44:11 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Dec 2019 08:44:10 EST
Received: from [10.0.5.25] (tv.ehuk.net [10.0.5.25])
        by schatzi.steelbluetech.co.uk (Postfix) with ESMTP id 19947BFEA2;
        Sun,  1 Dec 2019 13:37:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.10.3 schatzi.steelbluetech.co.uk 19947BFEA2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ehuk.net; s=default;
        t=1575207421; bh=f/xAr94viG0K8FWURq5ItTOqa3JpTB2Q1gDOwD3bhNU=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PgB9+7gono5WakF0glsZcQcOK7wSq2r484JjecNubxlMT8J51z3fpJpOiSaUhvd9P
         USYTYEiE2dOz25Fb2k8pQkSLdQXSo6TEul17VBVAReRcqgIzBcR18ZYGpft33VVpyw
         PNf6m/1/btxRtMjfFN16o4Zpi7C+A1DDKWukoYGY=
Reply-To: eddie@ehuk.net
Subject: Re: Backport bcache v5.4 to v4.19
To:     Coly Li <colyli@suse.de>, Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org
References: <alpine.LRH.2.11.1911302229090.31846@mx.ewheeler.net>
 <cf687ad0-ca8a-dd9a-5959-079762c7a7e5@suse.de>
From:   Eddie Chapman <eddie@ehuk.net>
Message-ID: <ded403fa-7f78-69e9-9d12-d16114246b18@ehuk.net>
Date:   Sun, 1 Dec 2019 13:37:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cf687ad0-ca8a-dd9a-5959-079762c7a7e5@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 01/12/2019 08:45, Coly Li wrote:
> On 2019/12/1 6:34 上午, Eric Wheeler wrote:
>> Hi Coly,
>>
>> We use 4.19.y and there have been many performance and stability changes
>> since then.  I'm considering backporting the 5.4 version into 4.19 and
>> wondered:
>>
>> Are there any changes in bcache between 4.19 and 5.4 that depend on new
>> features elsewhere in the kernel, or should I basically be able to copy
>> the tree from 5.4 to 4.19 and fix minor compilation issues?
>>
>> Can you think of any issues that would arise from such a backport?
> 
> Hi Eric,
> 
> It should be OK to backport bcache patches from 5.4 to 4.19. I did
> similar thing for SUSE Enterprise kernel which were based on Linux 4.12
> code base, and the changes was tiny.
> 
> If you encounter problem during the backport, you may post the .rej file
> and maybe I can help.

Hi Eric, Coly,

I have been applying the list below to kernel.org 4.19.x latest stable 
and using it on several production machines without any issues for 
months apart from the newer ones of course.  Apart from the odd context 
adjust I don't think any needed any modifying. My list used to be much 
bigger but a lot has been backported already in 4.19.x stable so my list 
has gone down quite a lot :-)

Sorry I don't use git but if I run in my patches directory as it is 
currently the list is:

egrep '^Subject' *.patch

00a.patch:Subject: bcache: account size of buckets used in uuid write to
00b.patch:Subject: bcache: fix typo in code comments of 
closure_return_with_destructor()
00c.patch:Subject: bcache: recal cached_dev_sectors on detach
01.patch:Subject: bcache: remove unused bch_passthrough_cache
02.patch:Subject: bcache: remove useless parameter of bch_debug_init()
03.patch:Subject: bcache: use MAX_CACHES_PER_SET instead of magic number 
8 in
05.patch:Subject: bcache: do not check if debug dentry is ERR or NULL 
explicitly on
06.patch:Subject: bcache: do not mark writeback_running too early
07.patch:Subject: bcache: cannot set writeback_running via sysfs if no 
writeback
08.patch:Subject: bcache: introduce force_wake_up_gc()
09.patch:Subject: bcache: not use hard coded memset size in
11.patch:Subject: bcache: fix input integer overflow of congested threshold
13.patch:Subject: bcache: add sysfs_strtoul_bool() for setting bit-field 
variables
14.patch:Subject: bcache: use sysfs_strtoul_bool() to set bit-field 
variables
15.patch:Subject: bcache: fix input overflow to writeback_delay
17.patch:Subject: bcache: fix input overflow to journal_delay_ms
18.patch:Subject: bcache: fix input overflow to cache set io_error_limit
20.patch:Subject: bcache: fix crashes stopping bcache device before read 
miss done
22.patch:Subject: bcache: fix inaccurate result of unused buckets
24.patch:Subject: bcache: add error check for calling register_bdev()
26.patch:Subject: bcache: improve bcache_reboot()
28.patch:Subject: bcache: fix wrong usage use-after-freed on keylist in 
out_nocoalesce
30.patch:Subject: [PATCH 07/12] bcache: fix deadlock in bcache_allocator
