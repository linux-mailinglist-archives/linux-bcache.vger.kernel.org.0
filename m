Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876D0369669
	for <lists+linux-bcache@lfdr.de>; Fri, 23 Apr 2021 17:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhDWPyM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 23 Apr 2021 11:54:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:48938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243028AbhDWPyL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 23 Apr 2021 11:54:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B0B63AEC6;
        Fri, 23 Apr 2021 15:53:32 +0000 (UTC)
Subject: Re: Race Condition Leads to Corruption
To:     Kai Krakow <kai@kaishome.de>, Marc Smith <msmith626@gmail.com>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
References: <CAH6h+heRQ0m4widKfWSfsqptO0xiXA4BW1pVHow2_+JbNrvZUQ@mail.gmail.com>
 <e61bcc44-5ac1-e58c-d5c9-fb7257ba044d@suse.de>
 <CAC2ZOYvKZBFRPi+-BB8vyTWhMoTGsQZ+7vuFfDmBzpSjzwvVYg@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <f12265e4-e8e4-98ac-cb5e-c44e8f8941a2@suse.de>
Date:   Fri, 23 Apr 2021 23:53:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAC2ZOYvKZBFRPi+-BB8vyTWhMoTGsQZ+7vuFfDmBzpSjzwvVYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/23/21 6:19 AM, Kai Krakow wrote:
> Hello Coly!
> 
> Am Do., 22. Apr. 2021 um 18:05 Uhr schrieb Coly Li <colyli@suse.de>:
> 
>> In direct I/Os, to read the just-written data, the reader must wait and
>> make sure the previous write complete, then the reading data should be
>> the previous written content. If not, that's bcache bug.
> 
> Isn't this report exactly about that? DIO data has been written, then
> differently written again with a concurrent process, and when you read
> it back, any of both may come back (let's call it state A). But the
> problem here is that this is not persistent, and that should actually
> not happen: bcache now has stale content in its cache, and after write
> back finished, the contents of the previous read (from state A)
> changed to a new state B. And this is not what you should expect from
> direct IO: The contents have literally changed under your feet with a
> much too high latency: If some read already confirmed that data has
> some state A after concurrent writes, it should not change to a state
> B after bcache finished write-back.

Hi Kai,

Your comments make me have a better comprehension. Yes the staled key
continues to exist even after a reboot, it is problematic.


> 
>> You may try the above steps on non-bcache block devices with/without
>> file systems, it is probably to reproduce similar "race" with parallel
>> direct read and writes.
> 
> I'm guessing the bcache results would suggest there's a much higher
> latency of inconsistency between write and read races, in the range of
> minutes or even hours. So there'd be no chance to properly verify your
> DIO writes by the following read and be sure that this state persists
> - just because there might be outstanding bcache dirty data.
> 
> I wonder if this is why I'm seeing btrfs corructions with bcache when
> I enabled auto-defrag in btrfs. OTOH, I didn't check the code on how
> auto-defrag is actually implemented and if it uses some direct-io path
> under the hoods.

Hi Marc,

It seems that if the read miss hitting an on-flight writethrough I/O on
backing device, such read request should served without caching onto the
cache set.

Do you have a patch for the fix up ?

Thanks.

Coly Li
