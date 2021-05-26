Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE67391060
	for <lists+linux-bcache@lfdr.de>; Wed, 26 May 2021 08:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhEZGLL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 26 May 2021 02:11:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:38734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232657AbhEZGLJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 26 May 2021 02:11:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622009376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ySh2Hd2xbPPIm0hVylfe8g2a88Y2OpaZrYnAzKyUKqE=;
        b=ZdYOO33WPTl7gSQ804nc4Z8pOkobrpg8VhGw5uhH1xDKZCXfyq5jssorPs0bJxPjN09Cv+
        KAoOvDKYZmj2HihpId29d5Q3kN2j535ZSY+9HKR0DT/tysisQxMXoqlt7Vu63ypCKrNEkP
        cB4fBRvCYItZfQ5ie8SFmjRB70kxAT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622009376;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ySh2Hd2xbPPIm0hVylfe8g2a88Y2OpaZrYnAzKyUKqE=;
        b=gJljBv3QQ4Luvh8/DuLIMLyK7fNNFRI1XLRWnM1o53k/QmPvPlk4WiBlcaagL9h2oeNrLG
        rwiSQL55ty7mGsAg==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 387C7B1AC;
        Wed, 26 May 2021 06:09:36 +0000 (UTC)
Subject: Re: IO hang when cache do not have enough buckets on small SSD
To:     Jim Guo <jimmygc2008@gmail.com>
Cc:     linux-bcache@vger.kernel.org
References: <CAG9eTxRG8zqe1r47wgtv_fhVAk13fmeB=Fyx-Z6Fq8W0i=om6Q@mail.gmail.com>
 <6c9fded6-30f8-b3cd-527b-0ca95fdca6ba@suse.de>
 <CAG9eTxTMOqs0kUEGhWYhUj2VkpgwBmtZQ_AJEkT=02oksep3yQ@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <3fb2d5bd-4e59-bad8-c3e7-1bcc58a4bea7@suse.de>
Date:   Wed, 26 May 2021 14:09:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAG9eTxTMOqs0kUEGhWYhUj2VkpgwBmtZQ_AJEkT=02oksep3yQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/26/21 1:58 PM, Jim Guo wrote:
>> What is the kernel version in your system? And where the kernel package
>> is from?
> I am using kernel version 4.19.142, I compile it from source code
> downloaded from kernel.org.
> 
>> Do you have a testing result on this idea?
> Sorry, the testing environment is not owned by me and I did not keep
> any testing result currently. I will test for this later in my own
> testing environment.
> 

OK. And I would suggest to start your work on upstream bcache code.

Coly Li


> Coly Li <colyli@suse.de> 于2021年5月17日周一 下午7:53写道：
> 
>>
>> On 5/17/21 11:54 AM, Jim Guo wrote:
>>> Hello, Mr. Li.
>>> Recently I was experiencing frequent io hang when testing with fio
>>> with 4K random write. Fio iops dropped  to 0 for about 20 seconds
>>> every several minutes.
>>> After some debugging, I discovered that it is the incremental gc that
>>> cause this problem.
>>> My cache disk is relatively small (375GiB with 4K block size and 512K
>>> bucket size), backing hdds are 4 x 1 TiB. I cannot reproduce this on
>>> another environment with bigger cache disk.
>>> When running 4K random write fio bench, the buckets are consumed  very
>>> quickly and soon it has to invalidate some bucket (this happens quite
>>> often). Since the cache disk is small, a lot of write io will soon
>>> reach sectors_to_gc and trigger gc thread. Write io will also increase
>>> search_inflight, which cause gc thread to sleep for 100ms. This will
>>> cause gc procedure to execute for a long time, and invalidating bucket
>>> for the write io will wait for the whole gc procedure.
>>> After removing the 100ms sleep from the incremental gc patch,  the io
>>> never hang any more.
>>
>> What is the kernel version in your system? And where the kernel package
>> is from?
>>
>>
>>> I think for small ssd, sleeping for 100ms seems too long or maybe
>>> write io should not trigger gc thread to sleep for 100ms?
>>> Thank you very much.
>>>
>>
>> Do you have a testing result on this idea?
>>
>>
>> Thanks.
>>
>> Coly Li

