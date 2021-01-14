Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39C62F5E4E
	for <lists+linux-bcache@lfdr.de>; Thu, 14 Jan 2021 11:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbhANKGb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 14 Jan 2021 05:06:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:56462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbhANKGa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Jan 2021 05:06:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3B286B1C4;
        Thu, 14 Jan 2021 10:05:47 +0000 (UTC)
To:     Dongdong Tao <dongdong.tao@canonical.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Gavin Guo <gavin.guo@canonical.com>,
        Gerald Yang <gerald.yang@canonical.com>,
        Trent Lloyd <trent.lloyd@canonical.com>,
        Dominique Poulain <dominique.poulain@canonical.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
References: <20210105030602.14427-1-tdd21151186@gmail.com>
 <CAJS8hVK-ZCxJt=E3hwR0hmqPYL1T07_WC_nerb-dZodO+DqtDA@mail.gmail.com>
 <1a4b2a68-a7b0-8eb0-e60b-c3cf5a5a9e56@suse.de>
 <CAJS8hVL2B=RZr8H4jFbz=bX9k_E9ur7kTeue6BJwzm4pwv1+qQ@mail.gmail.com>
 <084276ab-7c74-31be-b957-3b039d7061a1@suse.de>
 <CAJS8hVKJMZ-9Ep-8v7FALeW5dGMttpQ45=WKJTQmLUKEozhfXg@mail.gmail.com>
 <299ea3ff-4a9c-734e-0ec1-8b8d7480a019@suse.de>
 <CAJS8hVLSP2mk0Qzsxp=i5_ZgH4QJppPOrr2LU0oEAM-EOMjOyg@mail.gmail.com>
 <CAJS8hVJDaREvpvG4iO+Xs-KQXQKFi7=k29TrG=NXqjyiPpUCZA@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: consider the fragmentation when update the
 writeback rate
Message-ID: <392abd73-c58a-0a34-bd21-1e9adfffc870@suse.de>
Date:   Thu, 14 Jan 2021 18:05:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAJS8hVJDaREvpvG4iO+Xs-KQXQKFi7=k29TrG=NXqjyiPpUCZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/14/21 12:45 PM, Dongdong Tao wrote:
> Hi Coly,
> 
> I've got the testing data for multiple threads with larger IO depth.
> 

Hi Dongdong,

Thanks for the testing number.

> *Here is the testing steps:
> *1. make-bcache -B <> -C <> --writeback
> 
> 2. Open two tabs, start different fio task in them at the same time.
> Tab1 run below fio command:
> sudo fio --name=random-writers --filename=/dev/bcache0 --ioengine=libaio
> --iodepth=32 --rw=randrw --blocksize=64k,8k  --direct=1 --runtime=24000
> 
> Tab2 run below fio command:
> sudo fio --name=random-writers2 --filename=/dev/bcache0
> --ioengine=libaio --iodepth=8 --rw=randwrite --bs=4k --rate_iops=150
> --direct=1 --write_lat_log=rw --log_avg_msec=20
> 


Why you limit the iodep to 8 and iops to 150 on cache device?
For cache device the limitation is small. Iosp 150 with 4KB block size,
it means every hour writing (150*4*60*60=2160000KB=) 2GB data. For 35
hours it is only 70GB.


What if the iodeps is 128 or 64, and no iops rate limitation ?


> Note
> - Tab1 fio will run for 24000 seconds, which is the one to cause the
> fragmentation and made the cache_available_percent drops to under 40.
> - Tab2 fio is the one that I'm capturing the latency and I have let it
> run for about 35 hours, which is long enough to allow the
> cache_available_percent drops under 30.
> - This testing method utilized fio benchmark with larger read block
> size/small write block size to cause the high fragmentation, However in
> a real production env, there could be
>    various reasons or a combination of various reasons to cause the high
> fragmentation,  but I believe it should be ok to use any method to cause
> the fragmentation to verify if
>    bcache with this patch is responding better than the master in this
> situation. 
> 
> *Below is the testing result:*
> 
> The total run time is about 35 hours, the latency points in the charts
> for each run are 1.5 million
> 
> Master:
> fio-lat-mater.png
> 
> Master + patch:
> fio-lat-patch.png
> Combine them together:
> fio-lat-mix.png
> 
> Now we can see the master is even worse when we increase the iodepth,
> which makes sense since the backing HDD is being stressed more hardly.
> 
> *Below are the cache stats changing during the run:*
> Master:
> bcache-stats-master.png
> 
> Master + the patch:
> bcache-stats-patch.png
> 
> That's all the testing done with 400GB NVME with 512B block size.
> 
> Coly, do you want me to continue the same testing on 1TB nvme with
> different block size ?
> or is it ok to skip the 1TB testing and continue the test with 400GB
> NVME but with different block size? 
> feel free to let me know any other test scenarios that we should cover
> here. 

Yes please, more testing is desired for performance improvement. So far
I don't see performance number for real high work load yet.

Thanks.

Coly Li

