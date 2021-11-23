Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC082459EB3
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Nov 2021 09:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhKWI6G (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Nov 2021 03:58:06 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:43498 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhKWI6F (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Nov 2021 03:58:05 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6148421709;
        Tue, 23 Nov 2021 08:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637657697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gjq1CBcSuKKsw9LfmRyeLLSINFu3KdWnGuR2IjpK7AE=;
        b=BYHDRL7xNwNBBuOLGVlphYwfM6GM/qXxxOACD37nDZASgtX3Yco6eXWQDdtZVMMmaVPBhk
        9CF/bIPjumrhrGykwphsICeCsYleTi+cjHOIRRRBPmMfbH7cI7VPXqsJ6ejBmcE/cPZBGw
        MXuo0/9lUHF5ag9xLJBngznC8OAaveU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637657697;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gjq1CBcSuKKsw9LfmRyeLLSINFu3KdWnGuR2IjpK7AE=;
        b=kINKl+I2NNgUTGuJRcnWiOhnqa3ALZHiWXZByeruGKQn+vHMGRj8ENDVztxCrWDP1Sv0EZ
        LpQI4hbajJCDpFBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E636213B58;
        Tue, 23 Nov 2021 08:54:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TyT9LF+snGEGBgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 23 Nov 2021 08:54:55 +0000
Message-ID: <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de>
Date:   Tue, 23 Nov 2021 16:54:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
Content-Language: en-US
To:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Kai Krakow <kai@kaishome.de>
Cc:     linux-bcache@vger.kernel.org,
        =?UTF-8?Q?Fr=c3=a9d=c3=a9ric_Dumas?= <f.dumas@ellis.siteparc.fr>,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
 <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de>
 <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
 <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/20/21 8:06 AM, Eric Wheeler wrote:
> (Fixed mail header and resent, ignore possible duplicate message and
> reply to this one instead because the From header was broken.)
>
>
> Hi Coly, Kai, and Kent, I hope you are well!
>
> On Thu, 18 Nov 2021, Kai Krakow wrote:
>
>> Hi Coly!
>>
>> Reading the commit logs, it seems to come from using a non-default
>> block size, 512 in my case (although I'm pretty sure that *is* the
>> default on the affected system). I've checked:
>> ```
>> dev.sectors_per_block   1
>> dev.sectors_per_bucket  1024
>> ```
>>
>> The non-affected machines use 4k blocks (sectors per block = 8).
> If it is the cache device with 4k blocks, then this could be a known issue
> (perhaps) not directly related to the 5.15 release. We've hit a before:
>    https://www.spinics.net/lists/linux-bcache/msg05983.html
>
> and I just talked to Frédéric Dumas this week who hit it too (cc'ed).
> His solution was to use manufacturer disk tools to change the cachedev's
> logical block size from 4k to 512-bytes and reformat (see below).
>
> We've not seen issues with the backing device using 4k blocks, but bcache
> doesn't always seem to make 4k-aligned IOs to the cachedev.  It would be
> nice to find a long-term fix; more and more SSDs support 4k blocks, which
> is a nice x86 page-alignment and may provide for less CPU overhead.
>
> I think this was the last message on the subject from Kent and Coly:
>
> 	> On 2018/5/9 3:59 PM, Kent Overstreet wrote:
> 	> > Have you checked extent merging?
> 	>
> 	> Hi Kent,
> 	>
> 	> Not yet. Let me look into it.
> 	>
> 	> Thanks for the hint.
> 	>
> 	> Coly Li

I tried and I still remember this, the headache is, I don't have a 4Kn 
SSD to debug and trace, just looking at the code is hard...

If anybody can send me (in China to Beijing) a 4Kn SSD to debug and 
testing, maybe I can make some progress. Or can I configure the kernel 
to force a specific non-4Kn SSD to only accept 4K aligned I/O ?

Coly Li


