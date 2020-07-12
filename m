Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D28421C846
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Jul 2020 11:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgGLJbg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Jul 2020 05:31:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:52556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgGLJbg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Jul 2020 05:31:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DB473AD4A;
        Sun, 12 Jul 2020 09:31:35 +0000 (UTC)
Subject: Re: bcache integer overflow for large devices w/small io_opt
To:     Ken Raeburn <raeburn@redhat.com>
Cc:     linux-bcache@vger.kernel.org
References: <878sfrdm23.fsf@redhat.com>
 <4baea764-ba86-e17d-5e75-6acf22f2bbea@suse.de>
 <1de4ebce-c62f-e357-9827-3fa263f6b36a@redhat.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <26ce0472-5727-0601-ed9e-ea9474f39210@suse.de>
Date:   Sun, 12 Jul 2020 17:31:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1de4ebce-c62f-e357-9827-3fa263f6b36a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/7/12 11:06, Ken Raeburn wrote:
> On 7/11/20 11:28 AM, Coly Li wrote:
> 
>> On 2020/7/11 06:47, Ken Raeburn wrote:
>>> The long version is written up at
>>> https://bugzilla.redhat.com/show_bug.cgi?id=1783075 but the short
>>> version:
>>>
>>> There are devices out there which set q->limits.io_opt to small values
>>> like 4096 bytes, causing bcache to use that for the stripe size, but the
>>> device size could still be large enough that the computed stripe count
>>> is 2**32 or more. That value gets stuffed into a 32-bit (unsigned int)
>>> field, throwing away the high bits, and then that truncated value is
>>> range-checked and used. This can result in memory corruption or faults
>>> in some cases.
>>>
>>> The problem was brought up with us on Red Hat's VDO driver team by a
>>> bcache user on a 4.17.8 kernel, has been demonstrated in the Fedora
>>> 5.3.15-300.fc31 kernel, and by inspection appears to be present in
>>> Linus's tree as of this morning.
>>>
>>> The easy fix would be to keep the quotient in a 64-bit variable until
>>> it's validated, but that would simply limit the size of such devices as
>>> bcache backing storage (in this case, limiting VDO volumes to under 8
>>> TB). Is there a way to still be able to use larger devices? Perhaps
>>> scale up the stripe size from io_opt to the point where the stripe count
>>> falls in the allowed range?
>>>
>>> Ken Raeburn
>>> (Red Hat VDO driver developer)
>>>
>> We cannot extend the bit width of nr_stripes, because
>> d->full_dirty_stripes memory allocation depends on it.
>>
>> For the 18T volume, and stripe_size is 4KB, there are 4831838208
>> stripes. Then size of d->full_dirty_stripes will be
>> 4831838208*sizeof(atomic_t) > 140GB. This is too large for kernel memory
>> allocation.
> I didn't intend for nr_stripes to be made 64 bits. Just a temporary
> variable for the purposes of validation, to ensure that you won't be
> losing high bits when coercing to unsigned int.
>> Does it help of we have a option in bcache-tools to specify a
>> stripe_size number to overwrite limit->io_opt ? Then you may specify a
>> larger stripe size which may avoid nr_stripes overflow.
>>
>> Thanks for the report.
>>
>> Coly Li
>>
> Yes, I think letting the user choose a stripe size would be a good way
> to address the problem. Of course, the driver must still defend itself
> against memory corruption anyway, if the user doesn't do so, by
> rejecting or adjusting the values. But whereas I wouldn't recommend the
> driver alter the stripe size by more than necessary to make the stripe
> count fit, the user can make it as big as they want, if they want to
> bring the memory requirement down further, or if they've done some
> performance measurements of different configurations, or they know
> something interesting about their workload's access patterns, etc.

Copied. Correct me if I am wrong, I will do two fixes to solve the problem,
1, The quick fix is to solve ad avoid the kernel panic reported in the
bugzilla.
2, Permit people to set their own stripe_size to overwhelm the default
one, then bache make continue to work on small limit->io_opt device.

Coly Li
