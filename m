Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1B6348891
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Mar 2021 06:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhCYFa1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 25 Mar 2021 01:30:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:50260 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhCYFaB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Mar 2021 01:30:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 52EB7AB8A;
        Thu, 25 Mar 2021 05:30:00 +0000 (UTC)
Subject: Re: Undoing an "Auto-Stop" when Cache device has recovered?
To:     Nikolaus Rath <nikolaus@rath.org>
References: <3030cad3-47e2-43b0-8a82-656c6b774c78@www.fastmail.com>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <bcfeb53d-b8b0-883a-7a02-90b44b23f4dd@suse.de>
Date:   Thu, 25 Mar 2021 13:29:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <3030cad3-47e2-43b0-8a82-656c6b774c78@www.fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/25/21 4:21 AM, Nikolaus Rath wrote:
> Hello,
> 
> My (writeback enabled) bcache cache device had a temporary failure, but seems to have fully recovered (it may have been overheating or a loose cable).
> 
> From the last kernel messages, it seems that bcache tried to flush the dirty data, but failed, and then stopped the cache device.
> 
> After a reboot, the bcacheX device indeed no longer has an associated cache set..
> 
> I think in my case the cache device is in perfect shape again and still has all the data, so I would really like bcache to attach it again so that the dirty cache data is not lost.
> 
> Is there a way to do that?
> 
> (Yes, I will still replace the device afterwards)
> 
> (I am pretty sure that just re-attaching the cacheset will make bcache forget that there was a previous association and will wipe the corresponding metadata).
> 

Hi Nikolaus,

Do you have the kernel log? It depends on whether the cache set is clean
or not. For a clear cache set, the cache set is detached, and next
reattach will invalidate all existing cached data. If the cache set is
dirty and all existing data is wiped, that will be fishy....

Thanks.

Coly Li
