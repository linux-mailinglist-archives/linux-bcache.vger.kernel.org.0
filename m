Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EDC489CD0
	for <lists+linux-bcache@lfdr.de>; Mon, 10 Jan 2022 16:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbiAJPxR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 10 Jan 2022 10:53:17 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:50124 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236509AbiAJPxQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Jan 2022 10:53:16 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D76FD1F393;
        Mon, 10 Jan 2022 15:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641829994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FRM4BcmD9hfO5nbXPqn+DFkr64sSUqkyCYTzumTkKhk=;
        b=HxSwhujHM56DgA0t1Mwoxptc4JAuP4ieSwDdElwSgSCdMLHrANAYh+Xq2Mz89veNpEywRh
        xLKRVnKxWvT/r2wGY67JhgHwgZj5V/Ln80UK8nl4ZCmswxU5dczof6z6yjZB1q9FK5ouje
        SH9vAhHd6H5gSmaX0MJBAV+TPWYj6Fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641829994;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FRM4BcmD9hfO5nbXPqn+DFkr64sSUqkyCYTzumTkKhk=;
        b=C8T0d+w3VB+duw4c77N2MUtc/ZZeUErPQL5VoR4JCQ+vDD7zefO7e7wtelRDxU1+MjVEoK
        mipfN5KN4heFkVDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5629513D88;
        Mon, 10 Jan 2022 15:53:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Y+eyAmlW3GEWDgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 10 Jan 2022 15:53:13 +0000
Message-ID: <97e5c59a-ac8e-ffee-b5d5-55883932b8df@suse.de>
Date:   Mon, 10 Jan 2022 23:53:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] bcache: use default_groups in kobj_type
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220106100004.3277439-1-gregkh@linuxfoundation.org>
 <7cbca83d-bcac-464e-d2e4-c54b2d53eead@suse.de> <YdlL4YAScYp9XxkI@kroah.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <YdlL4YAScYp9XxkI@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/8/22 4:31 PM, Greg Kroah-Hartman wrote:
> On Sat, Jan 08, 2022 at 02:16:28PM +0800, Coly Li wrote:
>> On 1/6/22 6:00 PM, Greg Kroah-Hartman wrote:
>>> There are currently 2 ways to create a set of sysfs files for a
>>> kobj_type, through the default_attrs field, and the default_groups
>>> field.  Move the bcache sysfs code to use default_groups field which has
>>> been the preferred way since aa30f47cf666 ("kobject: Add support for
>>> default attribute groups to kobj_type") so that we can soon get rid of
>>> the obsolete default_attrs field.
>>>
>>> Cc: Coly Li <colyli@suse.de>
>>> Cc: Kent Overstreet <kent.overstreet@gmail.com>
>>> Cc: linux-bcache@vger.kernel.org
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> It looks good to me.
>>
>> Acked-by: Coly Li <colyli@suse.de>
>>
>> I assume you may take this patch directly in your maintenance path, but if
>> you want me to take this, just let me know. Thanks.
> I can take it myself, or you can, which ever is easiest for you, just
> let me know which you prefer.  Thanks for the review!

It will be faster for this patch goes into mainline in your path, I am 
on vacation now and will have a latency...

Thank you.

Coly Li
