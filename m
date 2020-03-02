Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9A91760DB
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Mar 2020 18:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbgCBRQ7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 12:16:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:56610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBRQ7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 12:16:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 918CDAE48;
        Mon,  2 Mar 2020 17:16:57 +0000 (UTC)
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Michal Hocko <mhocko@kernel.org>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz> <20200302134919.GB9769@redhat.com>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <48c6480a-3b26-fb7f-034d-923f9b8875f1@suse.de>
Date:   Tue, 3 Mar 2020 01:16:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302134919.GB9769@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/3/2 9:49 下午, Oleg Nesterov wrote:
> On 03/02, Michal Hocko wrote:
>>
>> I cannot really comment on the bcache part because I am not familiar
>> with the code.
> 
> same here...
> 
>>> This patch calls flush_signals() in bcache_device_init() if there is
>>> pending signal for current process. It avoids bcache registration
>>> failure in system boot up time due to bcache udev rule timeout.
>>
>> this sounds like a wrong way to address the issue. Killing the udev
>> worker is a userspace policy and the kernel shouldn't simply ignore it.
> 
> Agreed. If nothing else, if a userspace process has pending SIKILL then
> flush_signals() is very wrong.
> 
>> Btw. Oleg, I have noticed quite a lot of flush_signals usage in the
>> drivers land and I have really hard time to understand their purpose.
> 
> Heh. I bet most if not all users of flush_signals() are simply wrong.
> 
>> What is the actual valid usage of this function?
> 
> I thinks it should die... It was used by kthreads, but today
> signal_pending() == T is only possible if kthread does allow_signal(),
> and in this case it should probably use kernel_dequeue_signal().
> 
> 
> Say, io_sq_thread(). Why does it do
> 
> 		if (signal_pending(current))
> 			flush_signals(current);
> 
> afaics this kthread doesn't use allow_signal/allow_kernel_signal, this
> means that signal_pending() must be impossible even if this kthread sleeps
> in TASK_INTERRUPTIBLE state. Add Jens.

Hi Oleg,

Can I use disallow_signal() before the registration begins and use
allow_signal() after the registration done. Is this a proper way to
ignore the signal sent by udevd for timeout ?

For me the above method seems to solve my problem too.

Thanks.

-- 

Coly Li
