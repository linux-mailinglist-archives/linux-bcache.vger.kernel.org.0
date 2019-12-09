Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D86116A31
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Dec 2019 10:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfLIJxA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 04:53:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:56670 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725994AbfLIJxA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 04:53:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DB004B279;
        Mon,  9 Dec 2019 09:52:58 +0000 (UTC)
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Liang Chen <liangchen.linux@gmail.com>, kent.overstreet@gmail.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com>
 <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
 <20191209073744.GB3852@infradead.org>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <dc01bf2c-4457-9658-c0a3-cbd4b7eff82b@suse.de>
Date:   Mon, 9 Dec 2019 17:52:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191209073744.GB3852@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/9 3:37 下午, Christoph Hellwig wrote:
> On Fri, Dec 06, 2019 at 05:44:38PM +0800, Coly Li wrote:
>>>  {
>>> -	struct cache_sb *out = page_address(bio_first_page_all(bio));
>>> +	struct cache_sb *out;
>>>  	unsigned int i;
>>> +	struct buffer_head *bh;
>>> +
>>> +	/*
>>> +	 * The page is held since read_super, this __bread * should not
>>> +	 * cause an extra io read.
>>> +	 */
>>> +	bh = __bread(bdev, 1, SB_SIZE);
>>> +	if (!bh)
>>> +		goto out_bh;
>>> +
>>> +	out = (struct cache_sb *) bh->b_data;
>>
>> This is quite tricky here. Could you please to move this code piece into
>> an inline function and add code comments to explain why a read is
>> necessary for a write.
> 
> A read is not nessecary.  He only added it because he was too fearful
> of calculating the data offset directly.  But calculating it directly
> is almost trivial and should just be done here.  Alternatively if that
> is still to hard just keep a pointer to the cache_sb around, which is
> how most file systems do it.
> 
Copied, if Liang does not have time to handle this as your suggestion, I
will handle it.

Thanks for the hint.

-- 

Coly Li
