Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E186447B9E
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Nov 2021 09:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbhKHIOl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Nov 2021 03:14:41 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:52940 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbhKHIOl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Nov 2021 03:14:41 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5EF9F21976;
        Mon,  8 Nov 2021 08:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636359116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ROhavMFZ+NNQakdLJfU6TkiT9H0c9+Q0LHR0ep6pVO8=;
        b=r6k1x4qsAHPllJJHyl4ztgUJvfT/79AnAbo9eEU8xtGYaKMYosHecEusKxk7U3bRbka+Q2
        2SsmKGTwbJKPelYCITi21KcP9EBQSW211BI7WRZFqy3kW6LSpBiXRi4VbZqNdzz1vwHwCy
        ORoxBojY7koTCiyEPvgE9cQjkg0LWmY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636359116;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ROhavMFZ+NNQakdLJfU6TkiT9H0c9+Q0LHR0ep6pVO8=;
        b=orbuacQADKePzJOZto0Z56N5EXSPeYq40zcaXzA8RhLQgERaAOLNNAeMdXgLc7XKH8Gyjv
        zP44AILcpYcRmEDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F0701345F;
        Mon,  8 Nov 2021 08:11:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XY1+GcvbiGG8UAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 08 Nov 2021 08:11:55 +0000
Message-ID: <3d3c78f8-ed3c-7520-fa8a-d55eabe741c2@suse.de>
Date:   Mon, 8 Nov 2021 16:11:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: A lot of flush requests to the backing device
Content-Language: en-US
To:     Kai Krakow <kai@kaishome.de>
Cc:     Aleksei Zakharov <zakharov.a.g@yandex.ru>,
        Dongdong Tao <dongdong.tao@canonical.com>,
        linux-bcache@vger.kernel.org
References: <10612571636111279@vla5-f98fea902492.qloud-c.yandex.net>
 <CAJS8hV+KdLA6c8c5OV=z_KmJN2TSWROR6k9Y6_qut4EavJ0=tA@mail.gmail.com>
 <CAC2ZOYu36PAJO-b-vWYJftFT2PQ-JwiP9q79yqXDS_1z6V7M3g@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAC2ZOYu36PAJO-b-vWYJftFT2PQ-JwiP9q79yqXDS_1z6V7M3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/8/21 2:35 PM, Kai Krakow wrote:
> Am Mo., 8. Nov. 2021 um 06:38 Uhr schrieb Dongdong Tao
> <dongdong.tao@canonical.com>:
>> My understanding is that the bcache doesn't need to wait for the flush
>> requests to be completed from the backing device in order to finish
>> the write request, since it used a new bio "flush" for the backing
>> device.
> That's probably true for requests going to the writeback cache. But
> requests that bypass the cache must also pass the flush request to the
> backing device - otherwise it would violate transactional guarantees.
> bcache still guarantees the presence of the dirty data when it later
> replays all dirty data to the backing device (and it can probably
> reduce flushes here and only flush just before removing the writeback
> log from its cache).
>
> Personally, I've turned writeback caching off due to increasingly high
> latencies as seen by applications [1]. Writes may be slower
> throughput-wise but overall latency is lower which "feels" faster.
>
> I wonder if maybe a lot of writes with flush requests may bypass the cache...
>
> That said, initial releases of bcache felt a lot smoother here. But
> I'd like to add that I only ever used it for desktop workflows, I
> never used ceph.
>
> Regards,
> Kai
>
> [1]: And some odd behavior where bcache would detach dirty caches on
> caching device problems, which happens for me sometimes at reboot just
> after bcache was detected (probably due to a SSD firmware hiccup, the
> device temporarily goes missing and re-appears) - and then all dirty
> data is lost and discarded. In consequence, on next reboot, cache mode
> is set to "none" and the devices need to be re-attached. But until
> then, dirty data is long gone.

Just an off topic question, when you experienced the above situation, 
what is the kernel version for this?
We recently have a bkey oversize regression triggered in Linux v5.12 or 
v5.13, which behaved quite similar to the above description.
The issue was fixed in Linux v5.13 by the following commits,

commit 1616a4c2ab1a ("bcache: remove bcache device self-defined readahead")
commit 41fe8d088e96 ("bcache: avoid oversized read request in cache 
missing code path")

Coly Li
