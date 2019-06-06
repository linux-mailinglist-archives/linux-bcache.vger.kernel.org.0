Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E319373EB
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jun 2019 14:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfFFMPN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jun 2019 08:15:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:48066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726605AbfFFMPN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jun 2019 08:15:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7FA0CAD8D;
        Thu,  6 Jun 2019 12:15:12 +0000 (UTC)
Subject: Re: bcache corrupted cache
To:     Massimo Burcheri <massimo.burcheri@gmx.de>,
        linux-bcache@vger.kernel.org
References: <05050ff38ce81f5aa3be938d5bff5b83bd7171e4.camel@gmx.de>
 <f92ff036-5d97-0934-7c5d-0348840c67da@suse.de>
 <27c86f7bc6d3be1cd9502d32f7c3eb91cf08acc9.camel@gmx.de>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <cdf3475f-02dc-97f2-5265-476f28d3f079@suse.de>
Date:   Thu, 6 Jun 2019 20:15:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <27c86f7bc6d3be1cd9502d32f7c3eb91cf08acc9.camel@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/6 7:54 下午, Massimo Burcheri wrote:
> On Thu, 2019-06-06 at 19:38 +0800, Coly Li wrote:
>> What is your gcc version ?
> 
> That Gentoo had some gcc-9.1 enabled, however the running kernel
> was created earlier, probably using gcc-8.3.0.
> 
> The OpenSuse TW live where I tried to register the caching device
> manually, I don't know what the kernel and tools are built with.
> zypper info gcc says 9-1.2, so I guess this was the toolchain for
> creation as well.

OK, then it seems another gcc9 related issue.

> 
>> This one is important, if I can have the kernel message or call
>> trace of this segfault it will be very helpful.
> 
> That one I don't have anymore. I can try with some 5.1.5 kernel
> later..
> 
>>> Is my bcache definitely lost?
> 
>> I am not sure for the dirty data on cache, but for the backing
>> device you may have most of data back. Considering there is btrfs
>> on top of it, a fsck is required.
>> 
>> You may try to run the backing device wihtout attaching cache
>> device by: echo 1 > /sys/block/bcache0/bcache/running
> 
> Read my initial post, I did so. I was able to do a luksOpen. But
> the btrfs inside was corrupted when I tried 'filesystem check' and
> 'mount' on that.

This is bad, it seems btrfs metadata lost.

I am not able to help the data back, but now I am working full time on
the gcc9 compiled bcache issue. This is my first priority now.

-- 

Coly Li
