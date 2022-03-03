Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EB64CC514
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Mar 2022 19:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbiCCSZ4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Thu, 3 Mar 2022 13:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiCCSZv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Mar 2022 13:25:51 -0500
X-Greylist: delayed 2526 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Mar 2022 10:25:04 PST
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795851A3636
        for <linux-bcache@vger.kernel.org>; Thu,  3 Mar 2022 10:25:03 -0800 (PST)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 223HgpwP027062
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 3 Mar 2022 17:42:52 GMT
From:   Nix <nix@esperi.org.uk>
To:     Coly Li <colyli@suse.de>
Cc:     Zhang Zhen <zhangzhen.email@gmail.com>,
        linux-bcache@vger.kernel.org, jianchao.wan9@gmail.com
Subject: Re: bcache detach lead to xfs force shutdown
References: <e6c45b07-769c-575b-0d9c-929aba6ab21a@gmail.com>
        <da192278-8d05-2cce-0301-abafeff3c2fb@suse.de>
        <252588da-1e44-71d9-95a0-39a70c5d3f42@gmail.com>
        <6cab50d8-8771-8b6f-cd09-d318fc3986d3@suse.de>
Emacs:  the Swiss Army of Editors.
Date:   Thu, 03 Mar 2022 17:42:51 +0000
In-Reply-To: <6cab50d8-8771-8b6f-cd09-d318fc3986d3@suse.de> (Coly Li's message
        of "Wed, 2 Mar 2022 17:19:11 +0800")
Message-ID: <87sfrzdjac.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-DCC-x.dcc-servers-Metrics: loom 104; Body=4 Fuz1=4 Fuz2=4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2 Mar 2022, Coly Li verbalised:

> On 2/23/22 8:26 PM, Zhang Zhen wrote:
>> The reproduce opreation as follows:
>> 1. mount a bcache disk with xfs
>>
>> /dev/bcache1 on /media/disk1 type xfs
>>
>> 2. run ls in background
>> #!/bin/bash
>>
>> while true
>> do
>>   echo 2 > /proc/sys/vm/drop_caches
>>   ls -R /media/disk1 > /dev/null
>> done
>>
>>
>> 3. remove cache disk sdc
>> echo 1 >/sys/block/sdc/device/delete
>>
>> 4. dmesg should get xfs error
>>
>> I write a patch to improve，please help to review it, thanks.
>
> Hold on. Why do you think it should be fixed? As I said, it is as-designed behavior.

I was thinking exactly as you were... but, y'know, this might be a
genuine resiliency improvement, *if* done only when the cache is
writearound (or none, I suppose!). Obviously if writes are being cached
a cache device failure must trigger I/O failures visible to userspace...
but if it's just speeding up the underlying device, having it fail would
ideally just fail it out and cause all I/Os to proceed uncached,
including the one that was underway when the cache I/O error was
encountered.

-- 
NULL && (void)
