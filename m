Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A193C39B94C
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jun 2021 14:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhFDNBR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Jun 2021 09:01:17 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:60660 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhFDNBR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Jun 2021 09:01:17 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 834511FD7E;
        Fri,  4 Jun 2021 12:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622811570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRCO3qWLybROOPtv7ZMGzgj6L4RKcYVvHG1dxwIVHqE=;
        b=rocTOZ1Nki5VcyhngIL56kPnALNRYp+NFUFkM57+avPheLuXlMyVTkqVe/Nfmq/fnxJ4yf
        iW84327MHqT1I8iL0Rsm2rYMCS6XaXA0ZuILKKQm6Drwq2N9uhF/c+PP9TGSD5LynaMMGw
        j1RmVGxOftX9QzAWEdS7XFOr9v04NdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622811570;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRCO3qWLybROOPtv7ZMGzgj6L4RKcYVvHG1dxwIVHqE=;
        b=WZ9ij82lgfL6KXWvJ6s3CaajkWwkq/vHPGkfu2Jz7+D1BrchRMH6s76TMdybyoDYRKFZaX
        MJ9Cq9dA/R80RcCw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id CDD2E118DD;
        Fri,  4 Jun 2021 12:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622811570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRCO3qWLybROOPtv7ZMGzgj6L4RKcYVvHG1dxwIVHqE=;
        b=rocTOZ1Nki5VcyhngIL56kPnALNRYp+NFUFkM57+avPheLuXlMyVTkqVe/Nfmq/fnxJ4yf
        iW84327MHqT1I8iL0Rsm2rYMCS6XaXA0ZuILKKQm6Drwq2N9uhF/c+PP9TGSD5LynaMMGw
        j1RmVGxOftX9QzAWEdS7XFOr9v04NdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622811570;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRCO3qWLybROOPtv7ZMGzgj6L4RKcYVvHG1dxwIVHqE=;
        b=WZ9ij82lgfL6KXWvJ6s3CaajkWwkq/vHPGkfu2Jz7+D1BrchRMH6s76TMdybyoDYRKFZaX
        MJ9Cq9dA/R80RcCw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id qNbfJbEjumBySwAALh3uQQ
        (envelope-from <colyli@suse.de>); Fri, 04 Jun 2021 12:59:29 +0000
Subject: Re: Low hit ratio and cache usage
To:     Santiago Castillo Oli <scastillo@aragon.es>
Cc:     linux-bcache@vger.kernel.org
References: <5b01087b-6e56-0396-774a-1c1a71fe50df@aragon.es>
 <4cc064bc-36f3-cb15-0240-610a45e49300@suse.de>
 <62f20c57-d502-c362-da84-61a47c891e6d@aragon.es>
From:   Coly Li <colyli@suse.de>
Message-ID: <75a8b590-a877-7ac8-729d-57ebc09690d2@suse.de>
Date:   Fri, 4 Jun 2021 20:59:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <62f20c57-d502-c362-da84-61a47c891e6d@aragon.es>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/4/21 8:35 PM, Santiago Castillo Oli wrote:
> Hi Coli!
>
>
> El 04/06/2021 a las 14:05, Coly Li escribió:
>> What is the kernel version and where do you have the kernel ?  And what
>> is the workload on your machine ?
>
> I'm using debian 10 with default debian kernel (4.19.0-16-amd64) in
> host and guests.
>
> For virtualization I'm using KVM.


The kernel version is too old. I strongly suggest to use 5.3+ kernel,
which most of obvious bugs were fixed.
Then let's see what will happen.

>
>
> There is a host, where bcache is running. The filesystem over bcache
> device is ext4. In that filesystem there is only 9 qcow2 files user by
> three VM guests. Two VM are running small nextcloud instances, another
> one is running transmission (bittorrent) for feeding debian and other
> distro iso files (30 files - 60 GiB approx.)
>
>
>> Most of the read requests are missing, so they will read from backing
>> device and refilled into cache device as used-and-clean data. Once there
>> is no enough space to hold more read-cached data, garbage colleague may
>> retire the used-and-clean data very fast and make available room for new
>> refilling read data. The 19GB data might be existing data from last
>> time gc.
>
> Is it possible to know GC last execution time?
>

See /sys/fs/bcache/<UUID>/internal/btree_gc_last_sec



Coly Li
