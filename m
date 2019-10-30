Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7744EA524
	for <lists+linux-bcache@lfdr.de>; Wed, 30 Oct 2019 22:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfJ3VHP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 30 Oct 2019 17:07:15 -0400
Received: from titan.nuclearwinter.com ([205.185.120.7]:51062 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfJ3VHP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 30 Oct 2019 17:07:15 -0400
Received: from [IPv6:2601:6c5:8000:6b90:3869:81d7:ef0:db01] (desktop.nuclearwinter.com [IPv6:2601:6c5:8000:6b90:3869:81d7:ef0:db01])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id x9UL74qq004027
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 30 Oct 2019 17:07:06 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com x9UL74qq004027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1572469627;
        bh=TrML7HHCNUWptla7IGjRWeTwL78ak89qxwjFpyXChVc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=vEmDZhSzyax2n8CmJW74x92s9QtIbIiDLJHlHq+P3uG5ORJ8mieWHYWf1owvqIlxJ
         jtBxLWc6BjsxzX0nVeMZcTYa6og0s0jVD5ugoE7DEW7nIR+Mt9nnvVq2hdBN2eSP/B
         YtJDEsLqnaStIx4oxkFtNm4CXOg7Gozli/LAcBG4=
Subject: Re: bcache writeback infinite loop?
To:     Kai Krakow <kai@kaishome.de>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
References: <4d6fe8a0-ecae-738b-165b-ee66683a2df6@nuclearwinter.com>
 <alpine.LRH.2.11.1910242322110.25870@mx.ewheeler.net>
 <fa7a7125-195f-a2ad-4b5e-287c02cd9327@suse.de>
 <89f29562-409b-7b4e-e299-1c8e8db77ea5@nuclearwinter.com>
 <0b20203f-84c5-ce3e-e9e2-13600cb2d77c@suse.de>
 <1a07d296-82ec-6fa6-bbd4-357a972c0e63@nuclearwinter.com>
 <CAC2ZOYsrwObbMD+2khsbpiM+e9FUCdiONNQbBMFt9Mx7aXpyZQ@mail.gmail.com>
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
Message-ID: <00dfeefe-73f8-eeb8-b256-a51b2002e9e3@nuclearwinter.com>
Date:   Wed, 30 Oct 2019 17:07:03 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAC2ZOYsrwObbMD+2khsbpiM+e9FUCdiONNQbBMFt9Mx7aXpyZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (titan.nuclearwinter.com [IPv6:2605:6400:20:950:ed61:983f:b93a:fc2b]); Wed, 30 Oct 2019 17:07:07 -0400 (EDT)
X-Spam-Status: No, score=-1.1 required=5.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU autolearn=disabled version=3.4.0
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        titan.nuclearwinter.com
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 10/30/2019 3:18 PM, Kai Krakow wrote:
>> I did a scrub with bcache running and 19 errors were found and corrected
>> using duplicate metadata. That seems encouraging.
> What kind of scrub? Did it affect bcache caching or backing device?

btrfs scrub. Not sure what, if anything, was actually effected.

>
>> Unfortunately, I can't
>> seem to shut down bcache in order to test as you suggest. I can stop
>> bcache0 but I am unable to stop the cache device. I do the usual:
>>
>> echo 1 > /sys/fs/bcache/dc2877bc-d1b3-43fa-9f15-cad018e73bf6/stop
> I was seeing a similar issue. I'm not sure "stop" always works as
> expected. You should try "detach" instead. When it finished writeback
> eventually, it would detach cache from backing, and upon next mount
> they won't be attached to each other any longer and you should be able
> to unmount.
>
> If you cannot get rid of dirty data, you could also unregister bcache,
> then wipe the cache device, and then re-register and force-run the
> bcache backing device. Tho, discarding write-back data will eventually
> damage your FS. You should try switching to write-around first and see
> if you can convince bcache to write back data that way (maybe through
> a clean reboot after switching to write-around).

Duh, yes, unregistering the backing device did what I needed. I'm now 
running a new scrub without the cache device. Interestingly, the initial 
scrub speed with bcache ran at 900MB/s and without bcache it's 1400MB/s.


>
>
>> ... and nothing happens. I assume that's because it can't do a clean
>> shutdown. Is there any other way to unload bcache?
> I needed to bump the minimum writeback rate up to get that done in time.
>
> But I think you're facing a different problem than I had. My bcache
> btree was technically okay.
>
>
>> My alternative is to dig up a bootable usb drive that doesn't auto-start
>> bcache. So far, all of the boot images I've tried init bcache automatically.
> You could try disabling the bcache module, or if using dracut,
> "rd.break=pre-mount" or similar break-points may work.
>
>
> HTH
> Kai

Thanks for the un-register tip!

--Larkin
