Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7212F480630
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Dec 2021 06:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhL1FM6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Dec 2021 00:12:58 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:56006 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhL1FM4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Dec 2021 00:12:56 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 969612113D;
        Tue, 28 Dec 2021 05:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640668374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2KFwh8yhnhjlUIUNd3TLB0tvFqrNdzPEOF14AoxMgt4=;
        b=kgwUllaeSuDMOEHeY3obDskXM61Dr5e7m3tWMmq7rfhm9JvZA00CKbDP1uPDu32hBmIGIf
        C6zpB6Avch5qZfLtNredl80v1OxESTn5O5y1eXlcGG4CvR+XEl7+7rltaBEbiITlY6r5jv
        Wyl0+V9VongMNkcWkyF8iY9PPXThdks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640668374;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2KFwh8yhnhjlUIUNd3TLB0tvFqrNdzPEOF14AoxMgt4=;
        b=4N90ophzg+7DM3pdFuuJtAt8mCGSciycD8j+tb8XjntIsR4mfQvCpVRRQKO5Tgn4+V8KON
        J0YXBfBuUJRuXLCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF45F13343;
        Tue, 28 Dec 2021 05:12:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id P9YrH9OcymHdEwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 28 Dec 2021 05:12:51 +0000
Message-ID: <f713d122-07af-435f-5716-36351936695c@suse.de>
Date:   Tue, 28 Dec 2021 13:12:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v13 03/12] bcache: initialization of the buddy
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        kernel test robot <lkp@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-4-colyli@suse.de> <20211215162005.GA1978@kadam>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211215162005.GA1978@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/16/21 12:20 AM, Dan Carpenter wrote:
> On Mon, Dec 13, 2021 at 01:05:43AM +0800, Coly Li wrote:
>> +	/*
>> +	 * parameters of bitmap_set/clear are unsigned int.
>> +	 * Given currently size of nvm is far from exceeding this limit,
>> +	 * so only add a WARN_ON message.
>> +	 */
>> +	WARN_ON(BITS_TO_LONGS(ns->pages_total) > UINT_MAX);
>> +	ns->pages_bitmap = kvcalloc(BITS_TO_LONGS(ns->pages_total),
>> +				    sizeof(unsigned long), GFP_KERNEL);
> BITS_TO_LONGS() has a potential integer overflow if we're talking about
> truly giant numbers.  It will return zero if ns->pages_total is more
> than U64_MAX - 64.  In that case kvcalloc() will return ZERO_SIZE_PTR.
>
> Btw, kvcalloc() will never let you allocate more than INT_MAX.  It will
> trigger a WARN_ONCE().  If people want to allocate more than 2GB of RAM
> then they have to plan ahead of time and use vmalloc().
>

Hi Dan,

Thanks for the informative hint. I discussed with Qiaowen and Jianpeng, 
we plan to use an extent tree to replace current bitmap to record the 
free and allocated areas on the NVDIMM namespace. Which may have more 
efficient memory usage and avoid such size limitation.

Sorry for replying late, I was in travel and followed a sick for whole 
week. Again, thank you for taking time to look into this, and please 
continue next time :-)

Coly Li
