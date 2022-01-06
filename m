Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B2D4866C0
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 16:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240486AbiAFPcn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jan 2022 10:32:43 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:49500 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240432AbiAFPcm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jan 2022 10:32:42 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B219A21126;
        Thu,  6 Jan 2022 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641483161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=igR8pahVeImKuOJY3uL9wxjzDzCsDJFknPmkz3LGsqg=;
        b=HzDvBZCX/mvBdeI9ZoOP776ZHXesOX04y62SLby8HaslQ0hxTAmf+NxsbhHTO93PRIDo4p
        rw6oNSHlcwCMNA5m/OUmW1XN72AdUfDSkAyRZWZMz/wC4ngQ4pC35c5+OLsLU4TQOL2zlJ
        TRC+qjbZaG8bJcJ9KgWPhP49jNugzlc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641483161;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=igR8pahVeImKuOJY3uL9wxjzDzCsDJFknPmkz3LGsqg=;
        b=NkXPCV/zu1ZqaxDa+2hEVyzHPjSI3kzyNa1FYiZ7ENATc9fC9t+BBfU+bugJju6CcCZzdN
        lKyDlu7OTwlrl9BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3144013C5A;
        Thu,  6 Jan 2022 15:32:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UE4XO5cL12FxeAAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 06 Jan 2022 15:32:39 +0000
Message-ID: <35228856-c691-da1e-d89f-06c1fd7958e0@suse.de>
Date:   Thu, 6 Jan 2022 23:32:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
Content-Language: en-US
To:     Kai Krakow <kai@kaishome.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org,
        =?UTF-8?Q?Fr=c3=a9d=c3=a9ric_Dumas?= <f.dumas@ellis.siteparc.fr>,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
 <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de>
 <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
 <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net>
 <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de>
 <CAC2ZOYuTP4ErWELz93JWCTbDK_1pNABdktW3ejWMWhzE942j1w@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAC2ZOYuTP4ErWELz93JWCTbDK_1pNABdktW3ejWMWhzE942j1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/23/21 5:30 PM, Kai Krakow wrote:
> Am Di., 23. Nov. 2021 um 09:54 Uhr schrieb Coly Li <colyli@suse.de>:
>> On 11/20/21 8:06 AM, Eric Wheeler wrote:
>>> (Fixed mail header and resent, ignore possible duplicate message and
>>> reply to this one instead because the From header was broken.)
>>>
>>>
>>> Hi Coly, Kai, and Kent, I hope you are well!
>>>
>>> On Thu, 18 Nov 2021, Kai Krakow wrote:
>>>
>>>> Hi Coly!
>>>>
>>>> Reading the commit logs, it seems to come from using a non-default
>>>> block size, 512 in my case (although I'm pretty sure that *is* the
>>>> default on the affected system). I've checked:
>>>> ```
>>>> dev.sectors_per_block   1
>>>> dev.sectors_per_bucket  1024
>>>> ```
>>>>
>>>> The non-affected machines use 4k blocks (sectors per block = 8).
>>> If it is the cache device with 4k blocks, then this could be a known issue
>>> (perhaps) not directly related to the 5.15 release. We've hit a before:
>>>     https://www.spinics.net/lists/linux-bcache/msg05983.html
>>>
>>> and I just talked to Frédéric Dumas this week who hit it too (cc'ed).
>>> His solution was to use manufacturer disk tools to change the cachedev's
>>> logical block size from 4k to 512-bytes and reformat (see below).
>>>
>>> We've not seen issues with the backing device using 4k blocks, but bcache
>>> doesn't always seem to make 4k-aligned IOs to the cachedev.  It would be
>>> nice to find a long-term fix; more and more SSDs support 4k blocks, which
>>> is a nice x86 page-alignment and may provide for less CPU overhead.
>>>
>>> I think this was the last message on the subject from Kent and Coly:
>>>
>>>        > On 2018/5/9 3:59 PM, Kent Overstreet wrote:
>>>        > > Have you checked extent merging?
>>>        >
>>>        > Hi Kent,
>>>        >
>>>        > Not yet. Let me look into it.
>>>        >
>>>        > Thanks for the hint.
>>>        >
>>>        > Coly Li
>> I tried and I still remember this, the headache is, I don't have a 4Kn
>> SSD to debug and trace, just looking at the code is hard...
>>
>> If anybody can send me (in China to Beijing) a 4Kn SSD to debug and
>> testing, maybe I can make some progress. Or can I configure the kernel
>> to force a specific non-4Kn SSD to only accept 4K aligned I/O ?
> I think you can switch at least SOME models to native 4k?
>
> https://unix.stackexchange.com/questions/606072/change-logical-sector-size-to-4k
>
>> Changing a HDD to native 4k sectors works at least with WD Red Plus 14 TB drives but LOSES ALL DATA. The data is not actually wiped but partition tables and filesystems cannot be found after the change because of their now incorrect LBA locations.
>>
>> hdparm --set-sector-size 4096 --please-destroy-my-drive /dev/sdX

I didn't reply this email because I don't test the above example on 
latest mainline kernel.

I tested the command on 5.10 kernel with NVMe and SATA SSD, both of them 
didn't work. I wanted to verify whether this is new on latest mainline 
kernel but not find a chance to do this yet.

Thanks for the hint.

Coly Li

