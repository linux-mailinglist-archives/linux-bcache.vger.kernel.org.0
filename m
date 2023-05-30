Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753C07159B3
	for <lists+linux-bcache@lfdr.de>; Tue, 30 May 2023 11:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjE3JRQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 May 2023 05:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjE3JRP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 May 2023 05:17:15 -0400
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 May 2023 02:17:12 PDT
Received: from mail.eclipso.de (mail.eclipso.de [217.69.254.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864CECD
        for <linux-bcache@vger.kernel.org>; Tue, 30 May 2023 02:17:12 -0700 (PDT)
X-ESMTP-Authenticated-User: 000500FD
Message-ID: <5e538ece-4197-55ad-6631-771b1dab28d9@eclipso.eu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eclipso.de; s=mail;
        t=1685437926; bh=J0ZUCBrNGXIRMqTlebV2FmDGp2LPR+AFXGTyTBIgSFA=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=Ti8Kb2McBvDsKCGegWKD8I0IwCT5qjbvx+Kcx6319x5GohkKMZOmOcb+YnDX2JzXL
         Oyo+sNtLJajbYbd4ugyo3Eo1NVDuh41eEU82+xBXVUtqZ2K2zi4OLYyMktrwbM+d1x
         sE6VRPZtKYsdFFrEZbb82Nm+3h7N9njDMZn/ErH6Ccpb03lhrOJykdgU3ILRi89iuW
         Xzp/IorQj57sTPuOM2NNOIFSoMRokCLax+5PnmCfHvmKHjwdi6c88FMzuER3nWG8Lo
         5ECUPyEOaRd0u8Gts7N0Ix7H4FH4XHhhHsqWcRsdBEboN2Lh8gKQQpYtsX7IYSJOiL
         HUB9v3hwDW9Rw==
Date:   Tue, 30 May 2023 11:12:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Cc:     cedric.dewijs@eclipso.eu, colyli@suse.de,
        andrea.tomassetti-opensource@devo.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, zoumingzhe@qq.com,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [PATCH 3/3] bcache: support overlay bcache
To:     mingzhe <mingzhe.zou@easystack.cn>,
        Eric Wheeler <bcache@lists.ewheeler.net>
References: <20230201065202.17610-1-mingzhe.zou@easystack.cn>
 <20230201065202.17610-3-mingzhe.zou@easystack.cn>
 <e4a4362e-85d9-285d-726d-3b1df73329f8@ewheeler.net>
 <994cd286-1929-60e2-8be9-71efd825ae84@easystack.cn>
Content-Language: nl-NL, en-US-large
From:   Cedric de Wijs <cedric.dewijs@eclipso.eu>
In-Reply-To: <994cd286-1929-60e2-8be9-71efd825ae84@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

<snip>
>>>
>>> Then we can create a cached_dev with bcache1 (flash dev) as backing dev.
>>> $ make-bcache -B /dev/bcache1
>>> $ lsblk
>>> NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
>>> vdf                        252:80   0   50G  0 disk
>>> ├─bcache0                  251:0    0  100G  0 disk
>>> └─bcache1                  251:128  0  100G  0 disk
>>>    └─bcache2                251:256  0  100G  0 disk
>>>
>>> As a result there is a cached device bcache2 with backing device of a 
>>> flash device bcache1.
>>>          ----------------------------
>>>          | bcache2 (cached_dev)     |
>>>          | ------------------------ |
>>>          | |   sdb (cache_dev)    | |
>>>          | ------------------------ |
>>>          | ------------------------ |
>>>          | |   bcache1 (flash_dev)| |
>>>          | ------------------------ |
>>>          ----------------------------
>>
>> Does this allow an arbitrary depth of bcache stacking?
>>
>> -Eric
>>
> More than 2 layers we did not test, but should be allowed.
> 
> mingzhe
>>>
>>> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
>>> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
>>> ---
>>>   drivers/md/bcache/super.c | 40 +++++++++++++++++++++++++++++++++++----
>>>   1 file changed, 36 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>> index ba3909bb6bea..0ca8c05831c9 100644
>>> --- a/drivers/md/bcache/super.c
>>> +++ b/drivers/md/bcache/super.c
<snip>

Hi All,

I've not seen this commit appear in the mainline kernel yet. In 2023, 
only this commit changed super.c in 2023:
2023-04-25	block/drivers: remove dead clear of random flag
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/drivers/md/bcache/super.c?h=v6.4-rc4

What's preventing this patch from going into the mainline kernel?

Cheers,
Cedric

_________________________________________________________________
________________________________________________________
Your E-Mail. Your Cloud. Your Office. eclipso Mail & Cloud. https://www.eclipso.de


