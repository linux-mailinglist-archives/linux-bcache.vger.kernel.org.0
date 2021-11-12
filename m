Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA6644E1AB
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Nov 2021 06:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhKLFsB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 Nov 2021 00:48:01 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:58922 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhKLFsA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Nov 2021 00:48:00 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C19EE1FDC1;
        Fri, 12 Nov 2021 05:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636695909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n+LxdYi31XYyACVXniNdK1SyGZrDTjeJJH1So70wuho=;
        b=AVmkNdbMT8kgaRPrO0s3qGbKEuIZahry+8FkGb6Q4bztav4B8hCpHo5pgt1+jRy9yOCf2c
        Ixn2BRHBjbyWyWy8Pn3E+waiAWm7uPYYhu6+yyazfFlms17uBiL4CUcVlGQCUl4R8bvfvJ
        RQCK5vVohGBpCCai1CUFjtZIV4l5o8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636695909;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n+LxdYi31XYyACVXniNdK1SyGZrDTjeJJH1So70wuho=;
        b=0xoC09hcUobzBwONchfoo+At80dsoSwnl+69TJhyOPYyDE6Ldyv+7xYBf+6cpgAureAjBt
        5joPvlW72tFUoECw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E48EB13E3B;
        Fri, 12 Nov 2021 05:45:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /iCYK2T/jWF2TwAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 12 Nov 2021 05:45:08 +0000
Message-ID: <3768e9e4-892e-ca99-507c-040c725f0db5@suse.de>
Date:   Fri, 12 Nov 2021 13:45:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: bcache-register hang after reboot
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org,
        Nikhil Kshirsagar <nkshirsagar@gmail.com>
References: <CAC6jXv0mw4eOzFSzzm0acBJFM5whhC=hTFG6_8H__rfA6zq5Cg@mail.gmail.com>
 <YYwn1eT86dvSRfeA@moria.home.lan>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <YYwn1eT86dvSRfeA@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/11/21 4:13 AM, Kent Overstreet wrote:
> On Wed, Nov 10, 2021 at 11:14:41AM +0530, Nikhil Kshirsagar wrote:
>> Hello,
>>
>> After a reboot of an Ubuntu server running 4.15.0-143-generic kernel,
>> the storage devices using bcache do not come back up and the following
>> stack traces are seen in kern.log. Please could someone help me
>> understand if this is due to a full bcache journal? Is there any
>> workaround, or fix?
> Your journal is completely full, so persisting the new btree root while doing
> journal replay is hanging.
>
> There isn't a _good_ solution for this journal deadlock in bcache (it's fixed in
> bcachefs), but there is a hack:
>
> edit drivers/md/bcache/btree.c line 2493
>
> delete the call to bch_journal_meta(), and build a new kernel. Once you've
> gotten it to register, do a clean shutdown and then go back to a stock kernel.
>
> Running the kernel with that call deleted won't be safe if you crash, but it'll
> get you going again.

This happens eventually. I had a patch to reserve the last 2 blocks in 
the last journal bucket, and only to use them during boot time. It seems 
to be time to refine the patch.

(BTW, looking forward to see bcachefs in mainline kernel).

Coly Li
