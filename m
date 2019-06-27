Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF691582BE
	for <lists+linux-bcache@lfdr.de>; Thu, 27 Jun 2019 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfF0MlE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 27 Jun 2019 08:41:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:37434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726308AbfF0MlE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Jun 2019 08:41:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 070E9AE8B;
        Thu, 27 Jun 2019 12:41:03 +0000 (UTC)
Subject: Re: I/O Reordering: Cache -> Backing Device
To:     Vojtech Pavlik <vojtech@suse.com>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Marc Smith <msmith626@gmail.com>, linux-bcache@vger.kernel.org
References: <CAH6h+hd5qZdosqavv_ABHKAgRviUidxH_s3HZtLz5Fntg4Y3+A@mail.gmail.com>
 <alpine.LRH.2.11.1906260001290.1114@mx.ewheeler.net>
 <10bdb5ec-ca74-33f9-7482-fa53046d51b9@suse.de>
 <20190627123433.GA15646@suse.cz>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <24945937-a506-2af2-5852-abbde5b49864@suse.de>
Date:   Thu, 27 Jun 2019 20:40:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190627123433.GA15646@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/27 8:34 下午, Vojtech Pavlik wrote:
> On Thu, Jun 27, 2019 at 08:13:57PM +0800, Coly Li wrote:
> 
>>> Do you know how the nr_stripes, stripe_sectors_dirty and 
>>> full_dirty_stripes bitmaps work together to make a best-effort of writing 
>>> full stripes to the disk, and maybe you can explain under what 
>>> circumstances partial stripes would be written?
>> Hi Eric,
>>
>> I don't have satisfied answer to the above question. But if upper layers
>> don't issue I/Os with full stripe aligned, bcache cannot do anything
>> more than merging adjacent blocks. But for random I/Os, only a few part
>> of I/O requests can be merged, after writeback thread working for a
>> while, almost all writeback I/Os are small and not stripe-aligned, even
>> they are ordered by LBA address number.
>>
>> Thanks.
> 

Hi Vojtech,

> I wonder if it'd make sense for bcache on stripe-oriented backing
> devices to also try to readahead (or read-after) whole stripes from the
> backing device so that they're present in the cache and then write out a
> whole stripe even if the whole stripe isn't dirty.
> 

Let try it out. I assume if a write request hits a read-in cached full
stripe, the clean full-stripe-size block will be split into clean and
dirty part. But I don't fully understand the part of code so far, let me
try and maybe there is chance to improve (e.g mark the whole stripe as
dirty and write the whole stripe out).

> Working with whole stripes on a RAID6 makes a huge performance difference.
> 

Thanks for the hint!

-- 

Coly Li
