Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5519331A245
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Feb 2021 17:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhBLQCi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 Feb 2021 11:02:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:52506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229679AbhBLQCg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Feb 2021 11:02:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 704D5AC90;
        Fri, 12 Feb 2021 16:01:53 +0000 (UTC)
To:     David Laight <David.Laight@ACULAB.COM>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dongdong tao <dongdong.tao@canonical.com>
References: <20210212125028.GA264620@embeddedor>
 <ea24a361-ab1f-a330-b5e6-007bb9a1013b@suse.de>
 <0a2eb2e143ad480cbce3f84c3c920b5f@AcuMS.aculab.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH][next] bcache: Use 64-bit arithmetic instead of 32-bit
Message-ID: <cb3ffad1-e877-c6f9-168e-da7f55c59485@suse.de>
Date:   Sat, 13 Feb 2021 00:01:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <0a2eb2e143ad480cbce3f84c3c920b5f@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/12/21 11:31 PM, David Laight wrote:
>>>  		if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID) {
>>> -			fp_term = dc->writeback_rate_fp_term_low *
>>> +			fp_term = (int64_t)dc->writeback_rate_fp_term_low *
>>>  			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW);
>>>  		} else if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH) {
>>> -			fp_term = dc->writeback_rate_fp_term_mid *
>>> +			fp_term = (int64_t)dc->writeback_rate_fp_term_mid *
>>>  			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID);
>>>  		} else {
>>> -			fp_term = dc->writeback_rate_fp_term_high *
>>> +			fp_term = (int64_t)dc->writeback_rate_fp_term_high *
>>>  			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH);
>>>  		}
>>>  		fps = div_s64(dirty, dirty_buckets) * fp_term;
>>>
>>
>> Hmm, should such thing be handled by compiler ?  Otherwise this kind of
>> potential overflow issue will be endless time to time.
>>
>> I am not a compiler expert, should we have to do such explicit type cast
>> all the time ?
> 

Hi David,

I add Dongdong Tao Cced, who is author of this patch.

Could you please offer me more information about the following lines?
Let me ask more for my questions.

> We do to get a 64bit product from two 32bit values.
> An alternative for the above would be:
> 		fp_term = c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH;
> 		fp_term *= dc->writeback_rate_fp_term_high;

The original line is,
fp_term = dc->writeback_rate_fp_term_high * (c->gc_stats.in_use -
BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH)

The first value dc->writeback_rate_fp_term_high is unsigned int (32bit),
and the second value (c->gc_stats.in_use -
BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH) is unsigned int (32bit) too. And
fp_term is 64bit, if the product is larger than 32bits, the compiler
should know fp_term is 64bit and upgrade the product to 64bit.

The above is just my guess, because I feel compiling should have the
clue for the product upgrade to avoid overflow. But I almost know
nothing about compiler internal ....

> 
> I hope BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW is zero :-)

Why BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW being zero can be helpful to
avoid the overflow ? Could you please to provide more detailed information.

I am not challenging you, I just want to extend my knowledge by learning
from you. Thanks in advance.

Coly Li

