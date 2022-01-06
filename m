Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC0148670C
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 16:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240598AbiAFPtM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jan 2022 10:49:12 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:50424 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiAFPtM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jan 2022 10:49:12 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3792121126;
        Thu,  6 Jan 2022 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641484151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4b5yDC0/bBdsUmIlW9C3C3FsILiCSK5bHixXsCclpbA=;
        b=OkMYE3zxpyDkjYxbHb3K3CQzSIsFugv62O1tGj7q1BlJUEn4uAHKDYxYs+HiLOcBgVVI43
        aAloBMPVCSC0BlH5P2ykLkJakEyv6oqNwdbJ1KI9YtN8QL2HJ02WG70a1ayGq+eDpo6Zzb
        x134WujjGCLriXAM5Y2kAdMrq5Fsptg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641484151;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4b5yDC0/bBdsUmIlW9C3C3FsILiCSK5bHixXsCclpbA=;
        b=pKN8hIiWyGTne7VSaBok/tqHLRYOlW6jhgVyrbdZtQkOmH1x26PU01437VWp7BUhH6X+Y4
        XDXqIlYfjlv9mGDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 74E8A13C5A;
        Thu,  6 Jan 2022 15:49:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TGxACHUP12FGfgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 06 Jan 2022 15:49:09 +0000
Message-ID: <8799ba1c-5c12-d69b-948f-4df9667a801a@suse.de>
Date:   Thu, 6 Jan 2022 23:49:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
Content-Language: en-US
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Kai Krakow <kai@kaishome.de>, linux-bcache@vger.kernel.org,
        =?UTF-8?Q?Fr=c3=a9d=c3=a9ric_Dumas?= <f.dumas@ellis.siteparc.fr>,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
 <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de>
 <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
 <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net>
 <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de>
 <431f7be3-3b72-110-692c-ca8a11265d3@ewheeler.net>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <431f7be3-3b72-110-692c-ca8a11265d3@ewheeler.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/6/22 10:51 AM, Eric Wheeler wrote:
> On Tue, 23 Nov 2021, Coly Li wrote:
>> On 11/20/21 8:06 AM, Eric Wheeler wrote:
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
>>>   > On 2018/5/9 3:59 PM, Kent Overstreet wrote:
>>>   > > Have you checked extent merging?
>>>   >
>>>   > Hi Kent,
>>>   >
>>>   > Not yet. Let me look into it.
>>>   >
>>>   > Thanks for the hint.
>>>   >
>>>   > Coly Li
>> I tried and I still remember this, the headache is, I don't have a 4Kn SSD to
>> debug and trace, just looking at the code is hard...

Hi Eric,

> The scsi_debug driver can do it:
> 	modprobe scsi_debug sector_size=4096 dev_size_mb=$((128*1024))
>
> That will give you a 128gb SCSI ram disk with 4k sectors.  If that is
> enough for a cache to test against then you could run your super-high-IO
> test against it and see what you get.  I would be curious how testing
> bcache on the scsi_debug ramdisk in writeback performs!

The dram is not big enough on my testing server....

>> If anybody can send me (in China to Beijing) a 4Kn SSD to debug and testing,
>> maybe I can make some progress. Or can I configure the kernel to force a
>> specific non-4Kn SSD to only accept 4K aligned I/O ?
> I think the scsi_debug option above might be cheaper ;)
>
> But seriously, Frédéric who reported this error was using an Intel P3700
> if someone (SUSE?) wants to fund testing on real hardware.  <$150 used on
> eBay:

Currently all my testing SSDs are supported from Lenovo and Memblaze. I 
tried the hdparm command which Kai Krakow told me, and didn't work out.

Thanks for the hint for Intel P3700, I will try to find some and try to 
reproduce.
>
> I'm not sure how to format it 4k, but this is how Frédéric set it to 512
> bytes and fixed his issue:
>
> # intelmas start -intelssd 0 -nvmeformat LBAFormat=0
> # intelmas start -intelssd 1 -nvmeformat LBAFormat=0

Copied. Let me try to find Intel P3700 firstly.

Coly Li
