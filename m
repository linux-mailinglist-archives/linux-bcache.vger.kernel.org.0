Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769D839B8B1
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jun 2021 14:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFDMHH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Jun 2021 08:07:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55004 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhFDMHH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Jun 2021 08:07:07 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9564B1FD47;
        Fri,  4 Jun 2021 12:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622808320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbxQazhtoWUdPhxWJVDEe8zl4SuGmuV0veqNl8j+IZc=;
        b=EHh+8fQ52OoEAR2r9LYLpGHoBOSGhktbw6NYrtHdGjaVFv1O/9nP+/LFwIngONhg6t2l06
        VTKfK1uugwutCQGwPNZWM7S8BEZCHdmK8PmEYlDhjChZEkr5UXF02UAnJ1mI0WKv3VKZtw
        ALzOiLnblWAxIv7B9rpUw4BEtla5IcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622808320;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbxQazhtoWUdPhxWJVDEe8zl4SuGmuV0veqNl8j+IZc=;
        b=OUfz8X5PQFL2Bh95JcAwwyf5WlfmmeDEND+AMe8/G7ThHAPY8mJSWh4LhwEGHvKJIwKNic
        awgRNYTzDaPiURDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 593D7118DD;
        Fri,  4 Jun 2021 12:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622808320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbxQazhtoWUdPhxWJVDEe8zl4SuGmuV0veqNl8j+IZc=;
        b=EHh+8fQ52OoEAR2r9LYLpGHoBOSGhktbw6NYrtHdGjaVFv1O/9nP+/LFwIngONhg6t2l06
        VTKfK1uugwutCQGwPNZWM7S8BEZCHdmK8PmEYlDhjChZEkr5UXF02UAnJ1mI0WKv3VKZtw
        ALzOiLnblWAxIv7B9rpUw4BEtla5IcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622808320;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbxQazhtoWUdPhxWJVDEe8zl4SuGmuV0veqNl8j+IZc=;
        b=OUfz8X5PQFL2Bh95JcAwwyf5WlfmmeDEND+AMe8/G7ThHAPY8mJSWh4LhwEGHvKJIwKNic
        awgRNYTzDaPiURDw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id zQMXBv4WumDpMgAALh3uQQ
        (envelope-from <colyli@suse.de>); Fri, 04 Jun 2021 12:05:18 +0000
Subject: Re: Low hit ratio and cache usage
To:     Santiago Castillo Oli <scastillo@aragon.es>
References: <5b01087b-6e56-0396-774a-1c1a71fe50df@aragon.es>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <4cc064bc-36f3-cb15-0240-610a45e49300@suse.de>
Date:   Fri, 4 Jun 2021 20:05:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <5b01087b-6e56-0396-774a-1c1a71fe50df@aragon.es>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/4/21 7:07 PM, Santiago Castillo Oli wrote:
> Hi all!
>
>
> I'm using bcache and I think I have a rather low hit ratio and cache
> occupation.
>
>
> My setup is:
>
> - Cache device: 82 GiB partition on a SSD drive. Bucket size=4M. The
> partition is aligned on a Gigabyte boundary.
>
> - Backing device: 3.6 TiB partition on a HDD drive. There is 732 GiB
> of data usage on this partition. This 732 GiB are used by 9 qcow2
> files assigned to 3 VMs running on the host.
>
> - Neither the SDD nor HDD drives have another partitions in use.
>
> - After 24 hours of use, according to priority_stats the cache is 75%
> Unused (63 GiB Unused - 19 GiB used), but...
>
> - ... according to "smartctl -a" in those 24 hours "Writes to Flash"
> has increased in 160 GiB and "GB written from host" has increased in
> 90 GiB
>
> - cache_hit_ratio is 10 %
>
>
>
> - I'm using maximum bucket size (4M) trying to minimize write
> amplification. With this bucket size, "Writes to Flash" (160) to "GB
> written from host"(90) ratio is 1,78. Previously, some days ago, I was
> using default bucket size. The write amplification ratio then was 2,01.
>
> - Isn't the cache_hit_ratio (10%) a bit low?
>
> - Is it normal that, after 24 hours running, the cache occupation is
> that low (82-63 = 19GiB, 25%)  when the host has written 90 GiB to the
> cache device in the same period? I don´t understand why 90 GiB of data
> has been written to fill 19 GiB of cache.
>
>
> Any ideas?
>
>
> Thank you and regards.
>
>

What is the kernel version and where do you have the kernel ?  And what
is the workload on your machine ?

Most of the read requests are missing, so they will read from backing
device and refilled into cache device as used-and-clean data. Once there
is no enough space to hold more read-cached data, garbage colleague may
retire the used-and-clean data very fast and make available room for new
refilling read data. The 19GB data might be existing data from last time gc.

Coly Li
