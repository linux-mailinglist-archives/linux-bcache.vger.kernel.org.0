Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14F631ACA7
	for <lists+linux-bcache@lfdr.de>; Sat, 13 Feb 2021 16:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhBMPmF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 13 Feb 2021 10:42:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:40384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhBMPmF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 13 Feb 2021 10:42:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C1DE9AC69;
        Sat, 13 Feb 2021 15:41:20 +0000 (UTC)
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dongdong tao <dongdong.tao@canonical.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20210212125028.GA264620@embeddedor>
 <ea24a361-ab1f-a330-b5e6-007bb9a1013b@suse.de>
 <0a2eb2e143ad480cbce3f84c3c920b5f@AcuMS.aculab.com>
 <cb3ffad1-e877-c6f9-168e-da7f55c59485@suse.de>
 <468c8699c8ea445cac433406be983e79@AcuMS.aculab.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH][next] bcache: Use 64-bit arithmetic instead of 32-bit
Message-ID: <72d76785-3a03-78f4-bb80-ba1f4306d720@suse.de>
Date:   Sat, 13 Feb 2021 23:41:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <468c8699c8ea445cac433406be983e79@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/13/21 12:42 AM, David Laight wrote:
> From: Coly Li <colyli@suse.de>
>> Sent: 12 February 2021 16:02
>>
>> On 2/12/21 11:31 PM, David Laight wrote:
>>>>>  		if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID) {
>>>>> -			fp_term = dc->writeback_rate_fp_term_low *
>>>>> +			fp_term = (int64_t)dc->writeback_rate_fp_term_low *
>>>>>  			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW);
>>>>>  		} else if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH) {
>>>>> -			fp_term = dc->writeback_rate_fp_term_mid *
>>>>> +			fp_term = (int64_t)dc->writeback_rate_fp_term_mid *
>>>>>  			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID);
>>>>>  		} else {
>>>>> -			fp_term = dc->writeback_rate_fp_term_high *
>>>>> +			fp_term = (int64_t)dc->writeback_rate_fp_term_high *
>>>>>  			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH);
>>>>>  		}
>>>>>  		fps = div_s64(dirty, dirty_buckets) * fp_term;
>>>>>
>>>>
>>>> Hmm, should such thing be handled by compiler ?  Otherwise this kind of
>>>> potential overflow issue will be endless time to time.
>>>>
>>>> I am not a compiler expert, should we have to do such explicit type cast
>>>> all the time ?
>>>
>>
>> Hi David,
>>
>> I add Dongdong Tao Cced, who is author of this patch.
>>
>> Could you please offer me more information about the following lines?
>> Let me ask more for my questions.
>>
>>> We do to get a 64bit product from two 32bit values.
>>> An alternative for the above would be:
>>> 		fp_term = c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH;
>>> 		fp_term *= dc->writeback_rate_fp_term_high;
>>
>> The original line is,
>> fp_term = dc->writeback_rate_fp_term_high * (c->gc_stats.in_use -
>> BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH)
>>
>> The first value dc->writeback_rate_fp_term_high is unsigned int (32bit),
>> and the second value (c->gc_stats.in_use -
>> BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH) is unsigned int (32bit) too. And
>> fp_term is 64bit, if the product is larger than 32bits, the compiler
>> should know fp_term is 64bit and upgrade the product to 64bit.
>>
>> The above is just my guess, because I feel compiling should have the
>> clue for the product upgrade to avoid overflow. But I almost know
>> nothing about compiler internal ....
> 
> No, the expression is evaluated as 32bit and then extended for the assignment.

I do some test, and you are right. I am so surprised that the product
does not extended and the overflowed result is 0. Thank you for letting
me know this, and I correct my mistaken concept not too late :-)

If you want me to take this patch, it is OK to me. I will have it in
v5.12. If you want to handle this patch to upstream in your track, you
may have my
	Acked-by: Coly Li <colyli@suse.de>

Thanks for your patient explaining.

> 
> Or, more correctly, integer variables smaller than int (usually short and char)
> are extended to int prior to any arithmetic.
> If one argument to an operator is larger than int it is extended.
> If there is a sign v unsigned mismatch the signed value is cast to unsigned
> (same bit pattern on 2's compliment systems).
> 
> There are some oddities:
> - 'unsigned char/short' gets converted to 'signed int' unless
>   char/short and int are the same size (which is allowed).
>   (Although if char and int are the same size there are issues
>   with the value for EOF.)
> - (1 << 31) is a signed integer, it will get sign extended if used
>   to mask a 64bit value.
> 
> K&R C converted 'unsigned char' to 'unsigned int' - but the ANSI
> standards body decided otherwise.
> 
> The compiler is allowed to use an 'as if' rule to use the 8bit and
> 16bit arithmetic/registers on x86.
> But on almost everything else arithmetic on char/short local variables
> requires the compiler repeatedly mask the value back to 8/16 bits.
> 
> The C language has some other oddities - that are allowed but never done.
> (Except for 'thought-machines' in comp.lang.c)

I know the above things, but I DO NOT know product of two 32bit values
multiplying does not extend to 64bit. Good to know the compiling is not
that smart.

Thank you!

Coly Li
