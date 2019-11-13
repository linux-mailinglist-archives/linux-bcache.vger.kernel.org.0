Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30AEFAA70
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2019 07:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfKMGtd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Nov 2019 01:49:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:45596 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbfKMGtc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Nov 2019 01:49:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5E98CAF13;
        Wed, 13 Nov 2019 06:49:31 +0000 (UTC)
Subject: Re: Several bugs/flaws in the current(?) bcache implementation
To:     Christian Balzer <chibi@gol.com>
Cc:     linux-bcache@vger.kernel.org
References: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp>
 <a138b451-0a3e-2646-111e-cd095699ab0e@suse.de>
 <20191112101739.1c2517a4@batzmaru.gol.ad.jp>
 <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
 <20191112153947.7acdc5a2@batzmaru.gol.ad.jp>
 <3016280c-58c8-77f3-f938-4e835ab8d6c2@suse.de>
 <20191113151022.6c64d765@batzmaru.gol.ad.jp>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <f10c7eaf-b803-d556-b2c5-81112dc31926@suse.de>
Date:   Wed, 13 Nov 2019 14:49:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191113151022.6c64d765@batzmaru.gol.ad.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/11/13 2:10 下午, Christian Balzer wrote:
> On Wed, 13 Nov 2019 11:44:50 +0800 Coly Li wrote:
> 
> [snip]
>>
>> Hi Christian,
>>
>> Could you please try the attached patch in your environment ? Let's see
>> whether it makes things better on your side.
>>
> 
> Don't have custom/handrolled kernels on those machines, but I'll give it a
> spin later.
> Looking at the code I'm sure it will work, as in not going to full speed
> when idle.
> 
> Is there any reason for this being a flag instead of actually setting the
> max writeback rate, as mentioned when comparing this to MD RAID min/max?
> 
> What this does now is having writeback_rate_minimum both as the min and max
> rate for non-dirty pressure flushing.
> Whereas most people who want to actually set these values would probably
> be interested in a min rate as it is now (to drain things effectively w/o
> going overboard) and a max rate that never should be exceeded even if the
> PDC thinks otherwise.

For the max writeback rate limit, so far it is handled by the PDC
controller. I will have a try whether I can make it myself before
anybody helps to post patch. But it is at quite low priority location in
my todo list, I need to complete other tasks firstly which are not easy
neither and spent a lot of time already.

I post the patch to upstream for Linux v5.5, and add Reported-by: tag
with your email address.

Thanks.
-- 

Coly Li
