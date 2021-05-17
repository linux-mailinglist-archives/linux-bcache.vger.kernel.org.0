Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39654382B81
	for <lists+linux-bcache@lfdr.de>; Mon, 17 May 2021 13:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhEQLyg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 May 2021 07:54:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:47716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhEQLyg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 May 2021 07:54:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 703F8AF27;
        Mon, 17 May 2021 11:53:19 +0000 (UTC)
Subject: Re: IO hang when cache do not have enough buckets on small SSD
To:     Jim Guo <jimmygc2008@gmail.com>
References: <CAG9eTxRG8zqe1r47wgtv_fhVAk13fmeB=Fyx-Z6Fq8W0i=om6Q@mail.gmail.com>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <6c9fded6-30f8-b3cd-527b-0ca95fdca6ba@suse.de>
Date:   Mon, 17 May 2021 19:53:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAG9eTxRG8zqe1r47wgtv_fhVAk13fmeB=Fyx-Z6Fq8W0i=om6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/17/21 11:54 AM, Jim Guo wrote:
> Hello, Mr. Li.
> Recently I was experiencing frequent io hang when testing with fio
> with 4K random write. Fio iops dropped  to 0 for about 20 seconds
> every several minutes.
> After some debugging, I discovered that it is the incremental gc that
> cause this problem.
> My cache disk is relatively small (375GiB with 4K block size and 512K
> bucket size), backing hdds are 4 x 1 TiB. I cannot reproduce this on
> another environment with bigger cache disk.
> When running 4K random write fio bench, the buckets are consumed  very
> quickly and soon it has to invalidate some bucket (this happens quite
> often). Since the cache disk is small, a lot of write io will soon
> reach sectors_to_gc and trigger gc thread. Write io will also increase
> search_inflight, which cause gc thread to sleep for 100ms. This will
> cause gc procedure to execute for a long time, and invalidating bucket
> for the write io will wait for the whole gc procedure.
> After removing the 100ms sleep from the incremental gc patch,  the io
> never hang any more.

What is the kernel version in your system? And where the kernel package
is from?


> I think for small ssd, sleeping for 100ms seems too long or maybe
> write io should not trigger gc thread to sleep for 100ms?
> Thank you very much.
> 

Do you have a testing result on this idea?


Thanks.

Coly Li
